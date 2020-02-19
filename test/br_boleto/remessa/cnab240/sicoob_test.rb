require 'test_helper'

describe BrBoleto::Remessa::Cnab240::Sicoob do
	subject { FactoryGirl.build(:remessa_cnab240_sicoob, lotes: lote) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento, valor_documento: 100.00) }
	let(:lote) { FactoryGirl.build(:remessa_lote, pagamentos: pagamento) }

	it "deve herdar da class Base" do
		subject.class.superclass.must_equal BrBoleto::Remessa::Cnab240::Base
	end

	it "A conta deve ser da class Sicoob" do
		subject.conta.must_be_kind_of BrBoleto::Conta::Sicoob
	end

	context "validations" do
		describe 'Validações personalizadas da conta' do
			it 'valid_modalidade_required' do
				subject.send(:valid_modalidade_required).must_equal true
				subject.conta.modalidade = ''
				conta_must_be_msg_error(:modalidade, :blank)
			end

			it 'valid_conta_corrente_required' do
				subject.send(:valid_conta_corrente_required).must_equal true
				subject.conta.conta_corrente = ''
				conta_must_be_msg_error(:conta_corrente, :blank)
			end
			it 'valid_codigo_cedente_required' do
				subject.send(:valid_codigo_cedente_required).must_equal true
				subject.conta.codigo_cedente = ''
				conta_must_be_msg_error(:convenio, :blank)
			end
			it 'valid_conta_corrente_maximum' do
				subject.send(:valid_conta_corrente_maximum).must_equal 12
				subject.conta.conta_corrente = '1234567890123456'
				conta_must_be_msg_error(:conta_corrente, :custom_length_maximum, {count: 12})
			end
			it 'valid_modalidade_length' do
				subject.send(:valid_modalidade_length).must_equal 2
				subject.conta.modalidade = '1234567890123456'
				conta_must_be_msg_error(:modalidade, :custom_length_is, {count: 2})
			end

			private

			def conta_must_be_msg_error(attr_validation, msg_key, options_msg={})
				must_be_message_error(:base, "#{BrBoleto::Conta::Sicoob.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
			end
		end
		it { must validate_presence_of(:tipo_formulario) }
	end

	describe "#default_values" do
		it "for tipo_formulario" do
			object = subject.class.new()
			object.tipo_formulario.must_equal '4'
		end
	end


	it "o codigo_convenio deve ter 20 posições em branco" do
		subject.codigo_convenio.must_equal ''.rjust(20, ' ')
	end

	it "o convenio_lote deve ser o mesmo valor que o codigo_convenio" do
		subject.stubs(:convenio_lote).returns('qqcoisa')
		subject.convenio_lote.must_equal "qqcoisa"
	end

	describe "#informacoes_da_conta" do
		it "deve ter 20 posições" do
			subject.informacoes_da_conta.size.must_equal 20
		end
		context "1 Primeira parte = agencia 5 posicoes" do
			it "se for menor que 5 deve preencher com zero" do
				subject.conta.agencia = '123'
				subject.informacoes_da_conta[0..4].must_equal '00123'
			end
			it "quando agencia tiver as 5 posições" do
				subject.conta.agencia = '12345'
				subject.informacoes_da_conta[0..4].must_equal '12345'
			end
		end

		context "2 - Segunda parte = agencia_dv" do
			it "deve pegar o digito da agencia" do
				subject.conta.expects(:agencia_dv).returns("&")
				subject.informacoes_da_conta[5].must_equal "&"
			end
		end

		context "3 - Terceira parte = conta_corrente com 12 posições" do
			it "se tiver menos que 12 caracteres deve preencher com zero" do
				subject.conta.stubs(:conta_corrente_dv)
				subject.conta.expects(:conta_corrente).returns("123456")
				subject.informacoes_da_conta[6..17].must_equal "123456".rjust(12, '0')
			end
			it "se tiver 12 caracteres deve manter" do
				subject.conta.stubs(:conta_corrente_dv)
				subject.conta.expects(:conta_corrente).returns("".rjust(12, '1'))
				subject.informacoes_da_conta[6..17].must_equal "1".rjust(12, '1')
			end
		end

		context "4 - Quarta parte = conta_corrente_dv" do
			it "deve buscar o valor do metodo conta_corrente_dv" do
				subject.conta.expects(:conta_corrente_dv).returns('*')
				subject.informacoes_da_conta[18].must_equal('*')
			end
		end
	end

	describe "#complemento_trailer_lote" do
		let(:pagamento_2) { FactoryGirl.build(:remessa_pagamento, valor_documento: 50.25) }
		it "deve carregar os dados dos metodos complemento_trailer_lote na sequencia" do
			subject.stubs(:complemento_trailer_lote_posicao_024_a_029).with(lote).returns(" 024_a_029")
			subject.stubs(:complemento_trailer_lote_posicao_030_a_046).with(lote).returns(" 030_a_046")
			subject.stubs(:complemento_trailer_lote_posicao_047_a_052).with(lote).returns(" 047_a_052")
			subject.stubs(:complemento_trailer_lote_posicao_053_a_069).with(lote).returns(" 053_a_069")
			subject.stubs(:complemento_trailer_lote_posicao_070_a_075).with(lote).returns(" 070_a_075")
			subject.stubs(:complemento_trailer_lote_posicao_076_a_092).with(lote).returns(" 076_a_092")
			subject.stubs(:complemento_trailer_lote_posicao_093_a_098).with(lote).returns(" 093_a_098")
			subject.stubs(:complemento_trailer_lote_posicao_099_a_115).with(lote).returns(" 099_a_115")
			subject.stubs(:complemento_trailer_lote_posicao_116_a_123).with(lote).returns(" 116_a_123")
			subject.stubs(:complemento_trailer_lote_posicao_124_a_240).returns(" 124_a_240")
			subject.complemento_trailer_lote(lote, 1).must_equal(" 024_A_029 030_A_046 047_A_052 053_A_069 070_A_075 076_A_092 093_A_098 099_A_115 116_A_123 124_A_240")
		end

		before do
			lote.pagamentos << pagamento_2
		end

		describe "#complemento_trailer_lote_posicao_024_a_029" do
			it "se o tipo_cobranca_formatada for simples, então deve contar o total de pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:simples)
				subject.complemento_trailer_lote_posicao_024_a_029(lote).must_equal "2".rjust(6, "0")
			end
			it "se o tipo_cobranca_formatada não for simples, então não deve contar o total de pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:caucionada)
				subject.complemento_trailer_lote_posicao_024_a_029(lote).must_equal "".rjust(6, "0")
			end
		end

		describe "#complemento_trailer_lote_posicao_030_a_046" do
			it "se o tipo_cobranca_formatada for simples, então deve somar o valor_documento dos pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:simples)
				subject.complemento_trailer_lote_posicao_030_a_046(lote).must_equal "15025".rjust(17, "0")
			end
			it "se o tipo_cobranca_formatada não for simples, então não deve somar o valor_documento dos pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:caucionada)
				subject.complemento_trailer_lote_posicao_030_a_046(lote).must_equal "".rjust(17, "0")
			end
		end

		describe "#complemento_trailer_lote_posicao_047_a_052" do
			it { subject.complemento_trailer_lote_posicao_047_a_052(lote).must_equal "".rjust(6, "0") }
		end

		describe "#complemento_trailer_lote_posicao_053_a_069" do
			it { subject.complemento_trailer_lote_posicao_053_a_069(lote).must_equal "".rjust(17, "0") }
		end

		describe "#complemento_trailer_lote_posicao_070_a_075" do
			it "se o tipo_cobranca_formatada for caucionada, então deve contar o total de pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:caucionada)
				subject.complemento_trailer_lote_posicao_070_a_075(lote).must_equal "2".rjust(6, "0")
			end
			it "se o tipo_cobranca_formatada não for caucionada, então não deve contar o total de pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:simples)
				subject.complemento_trailer_lote_posicao_070_a_075(lote).must_equal "".rjust(6, "0")
			end
		end

		describe "#complemento_trailer_lote_posicao_076_a_092" do
			it "se o tipo_cobranca_formatada for caucionada, então deve somar o valor_documento dos pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:caucionada)
				subject.complemento_trailer_lote_posicao_076_a_092(lote).must_equal "15025".rjust(17, "0")
			end
			it "se o tipo_cobranca_formatada não for caucionada, então não deve somar o valor_documento dos pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:simples)
				subject.complemento_trailer_lote_posicao_076_a_092(lote).must_equal "".rjust(17, "0")
			end
		end

		describe "#complemento_trailer_lote_posicao_093_a_098" do
			it { subject.complemento_trailer_lote_posicao_093_a_098(lote).must_equal "".rjust(6, "0") }
		end

		describe "#complemento_trailer_lote_posicao_099_a_115" do
			it { subject.complemento_trailer_lote_posicao_099_a_115(lote).must_equal "".rjust(17, "0") }
		end

		describe "#complemento_trailer_lote_posicao_116_a_123" do
			it { subject.complemento_trailer_lote_posicao_116_a_123(lote).must_equal "".rjust(8, " ") }
		end

		describe "#complemento_trailer_lote_posicao_124_a_240" do
			it { subject.complemento_trailer_lote_posicao_124_a_240.must_equal "".rjust(117, " ") }
		end

	end

	describe "#formata_nosso_numero" do
		it "posicao 0 até 9 deve pegar o nosso_numero passado por parametro e ajustar para 10 posições" do
			pagamento.nosso_numero = 123
			subject.formata_nosso_numero(pagamento)[0..9].must_equal "123".rjust(10, '0')
		end
		it "posicao 10 até 11 deve ter o numero da parcela" do
			pagamento.expects(:parcela).returns("99")
			pagamento.nosso_numero = 1
			subject.formata_nosso_numero(pagamento)[10..11].must_equal "99"
		end
		it "posicao 12 até 13 deve ter a conta.modalidade" do
			subject.conta.expects(:modalidade).returns("23")
			pagamento.nosso_numero = 1
			subject.formata_nosso_numero(pagamento)[12..13].must_equal "23"
		end
		it "posicao 14 deve ter o tipo_formulario" do
			subject.expects(:tipo_formulario).returns("4")
			subject.formata_nosso_numero(pagamento)[14].must_equal "4"
		end
		it "posição 15 até 19 deve ser valor em branco" do
			pagamento.nosso_numero = 123
			subject.formata_nosso_numero(pagamento)[15..19].must_equal "".rjust(5, ' ')
		end
		it "deve ajustar a string para no maximo 20 posições" do
			subject.conta.expects(:modalidade).returns("".rjust(20, "1"))
			pagamento.nosso_numero = 123456
			subject.formata_nosso_numero(pagamento).size.must_equal 20
		end
	end

	describe "#dados_do_arquivo" do
		it "deve gerar os dados do arquivo" do
			subject.dados_do_arquivo.size.must_equal 1936
		end
	end

	describe "#tipo_cobranca_formatada" do
		it "deve ser :simples se conta.modalidade for 01" do
			subject.conta.modalidade = '01'
			subject.tipo_cobranca_formatada.must_equal :simples
		end
		it "deve ser :simples se conta.modalidade for 1" do
			subject.conta.modalidade = 1
			subject.tipo_cobranca_formatada.must_equal :simples
		end
		it "deve ser :simples se conta.modalidade for 02" do
			subject.conta.modalidade = '02'
			subject.tipo_cobranca_formatada.must_equal :simples
		end
		it "deve ser :simples se conta.modalidade for 2" do
			subject.conta.modalidade = 2
			subject.tipo_cobranca_formatada.must_equal :simples
		end
		it "deve ser :caucionada se conta.modalidade for 03" do
			subject.conta.modalidade = '03'
			subject.tipo_cobranca_formatada.must_equal :caucionada
		end
		it "deve ser :caucionada se conta.modalidade for 3" do
			subject.conta.modalidade = 3
			subject.tipo_cobranca_formatada.must_equal :caucionada
		end
		it "deve ser nil se conta.modalidade for outro numero" do
			subject.conta.modalidade = 4
			subject.tipo_cobranca_formatada.must_be_nil
		end
		it "deve ser nil se conta.modalidade for nil" do
			subject.conta.modalidade = nil
			subject.tipo_cobranca_formatada.must_be_nil
		end
	end

	describe "particularidades do header_arquivo" do
		describe "#complemento_header_arquivo" do
			it "deve ter 29 posições em branco" do
				subject.complemento_header_arquivo.must_equal ''.rjust(29, ' ')
			end
		end

		it "#header_arquivo_posicao_172_a_191 deve ter 20 posições em branco" do
			subject.header_arquivo_posicao_172_a_191.must_equal ''.rjust(20, ' ')
		end
		it "#header_arquivo_posicao_192_a_211 deve ter 20 posições em branco" do
			subject.header_arquivo_posicao_192_a_211.must_equal ''.rjust(20, ' ')
		end
	end

	describe "particularidades header_lote" do
		it "#header_lote_posicao_012_a_013 deve ter 2 digitos em branco" do
			subject.header_lote_posicao_012_a_013.must_equal '  '
		end
	end

	describe "particularidades do Segmento P" do
		describe "#complemento_p" do
			it "posicao 0 até 11 deve ter a conta_corrente" do
				subject.conta.stubs(:conta_corrente_dv)
				subject.conta.expects(:conta_corrente).returns(123456789)
				subject.complemento_p(pagamento)[0..11].must_equal "000123456789"
			end
			it "posicao 12 deve te o conta_corrente_dv" do
				subject.conta.expects(:conta_corrente_dv).returns("%")
				subject.complemento_p(pagamento)[12].must_equal "%"
			end
			it "posição 13 deve ser um caracter em branco" do
				subject.complemento_p(pagamento)[13].must_equal " "
			end
			it "posição 14 até 33 deve ter o valor do metodo formata_nosso_numero passando o nosso_numero do pagamento" do
				subject.expects(:formata_nosso_numero).with(pagamento).returns("12345678901234567890")
				subject.complemento_p(pagamento)[14..33].must_equal '12345678901234567890'
			end
		end
		it "#segmento_p_posicao_060_a_060 deve ter 1 digito em branco" do
			subject.segmento_p_posicao_060_a_060.must_equal ' '
		end
	end

	describe 'Geração do arquivo' do
		let(:conta) do
			{
				razao_social:   'EMPRESA EMITENTE',
				cpf_cnpj:       '33.486.451/0001-30',
				carteira:       '1',
				modalidade:     '01',
				agencia:        '3040',
				codigo_cedente: '82819',
				conta_corrente: '54843'

			}
		end
		let(:pagador) {
			{
				nome:     'Benjamin Francisco Marcos Vinicius Fernandes',
				cpf_cnpj: '787.933.211-12',
				endereco: 'Rua Principal s/n 881',
				bairro:   'Centro',
				cep:      '79210-972',
				cidade:   'Anastácio',
				uf:       'MS',
			}
		}
		let(:pagamento) {
			BrBoleto::Remessa::Pagamento.new({
				nosso_numero:     '00157804',
				numero_documento: '00157804',
				data_vencimento:  Date.parse('06/09/2016'),
				valor_documento:  147.89,
				pagador:          pagador,
				especie_titulo:   '02',
				codigo_juros:     '1',
				data_juros:       Date.parse('07/09/2016'),
				valor_juros:      0.25,
				codigo_multa:     '2',
				data_multa:       Date.parse('07/09/2016'),
				valor_multa:      2.00,
				data_emissao:     Date.parse('06/09/2016'),
			})
		}
		let(:lote) { BrBoleto::Remessa::Lote.new(pagamentos: pagamento) }
		it "deve gerar o arquivo de remessa corretamente com as informações passadas" do
			remessa = BrBoleto::Remessa::Cnab240::Sicoob.new({
				data_hora_arquivo:  Time.parse('06/09/2016 09:43:52'),
				sequencial_remessa: 11,
				conta:              conta,
				lotes:              [lote],
			})
			idx = 0
			remessa.dados_do_arquivo.split("\n")[idx].must_equal read_fixture('remessa/cnab240/sicoob.rem').split("\n")[idx]
		end
	end
end