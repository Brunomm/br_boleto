require 'test_helper'

describe BrBoleto::Remessa::Cnab240::Caixa do
	subject { FactoryGirl.build(:remessa_cnab240_caixa, lotes: lote) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento, valor_documento: 879.66) } 
	let(:lote) { FactoryGirl.build(:remessa_lote, pagamentos: pagamento) } 

	it "deve herdar da class Base" do
		subject.class.superclass.must_equal BrBoleto::Remessa::Cnab240::Base
	end

	context "validations" do
		describe 'Validações personalizadas da conta' do
			it 'valid_carteira_required' do
				# subject.send(:valid_carteira_required).must_equal true
				subject.conta.carteira = ''
				conta_must_be_msg_error(:carteira, :blank)
			end

			it 'valid_carteira_length' do
				# subject.send(:valid_carteira_length).must_equal 2
				subject.conta.carteira = '1234567890123456'
				conta_must_be_msg_error(:carteira, :custom_length_is, {count: 2})
			end

			it 'valid_convenio_required' do
				# subject.send(:valid_convenio_required).must_equal true
				subject.conta.convenio = ''
				conta_must_be_msg_error(:convenio, :blank)
			end

			it 'valid_convenio_length' do
				# subject.send(:valid_convenio_length).must_equal 2
				subject.conta.convenio = '1234567890123456'
				conta_must_be_msg_error(:convenio, :custom_length_maximum, {count: 6})
			end

			it 'agencia_required' do
				# subject.send(:agencia_required).must_equal true
				subject.conta.agencia = ''
				conta_must_be_msg_error(:agencia, :blank)
			end

			it 'agencia_length' do
				# subject.send(:agencia_length).must_equal 2
				subject.conta.agencia = '1234567890123456'
				conta_must_be_msg_error(:agencia, :custom_length_is, {count: 4})
			end

			it 'versao_aplicativo_required' do
				# subject.send(:versao_aplicativo_required).must_equal true
				subject.conta.versao_aplicativo = ''
				conta_must_be_msg_error(:versao_aplicativo, :blank)
			end

			it 'versao_aplicativo_length' do
				# subject.send(:versao_aplicativo_length).must_equal 2
				subject.conta.versao_aplicativo = '1234567890123456'
				conta_must_be_msg_error(:versao_aplicativo, :custom_length_maximum, {count: 4})
			end
			
			private

			def conta_must_be_msg_error(attr_validation, msg_key, options_msg={})
				must_be_message_error(:base, "#{BrBoleto::Conta::Caixa.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
			end
		end
	end

	it "o codigo_convenio deve ter 20 posições com Zeros" do
		subject.codigo_convenio.must_equal '0' * 20
	end

	describe "#convenio_lote" do
		it "as 6 primeiras posições deve ser o valor do convenio ajustado com zeros a esquerda" do
			subject.conta.convenio = '88'
			subject.convenio_lote(lote)[0..5].must_equal '000088'

			subject.conta.convenio = '2878'
			subject.convenio_lote(lote)[0..5].must_equal '002878'
		end
		it "as 14 ultimas posições deve ser tudo Zeros" do
			subject.convenio_lote(lote)[6..19].must_equal '00000000000000'
		end
		it "deve ter 20 caracteres" do
			subject.convenio_lote(lote).size.must_equal 20
		end
	end
	

	describe "#informacoes_da_conta" do
		it "deve ter 20 posições" do
			subject.informacoes_da_conta.size.must_equal 20
		end

		it "1 - Primeira parte = agencia 5 posicoes - ajustados com zeros a esquerda" do
			subject.conta.agencia = '123'
			subject.informacoes_da_conta[0..4].must_equal '00123'
		
			subject.conta.agencia = '1234'
			subject.informacoes_da_conta[0..4].must_equal '01234'
		end

		it "2 - Segunda parte = agencia_dv" do
			subject.conta.expects(:agencia_dv).returns("&")
			subject.informacoes_da_conta[5].must_equal "&"
		end

		it "3 - Terceira parte = convenio 6 posicoes - ajustados com zeros a esquerda" do
			subject.conta.convenio = '123'
			subject.informacoes_da_conta[6..11].must_equal '000123'
		
			subject.conta.convenio = '1234'
			subject.informacoes_da_conta[6..11].must_equal '001234'
		end

		it "4 - Quarta parte = Modelo personalizado - Deve ter 7 zeros" do
			subject.informacoes_da_conta[12..18].must_equal('0000000')			
		end

		it "5 - Quinta parte = Exclusivo caixa - Deve ter 1 zero" do
			subject.informacoes_da_conta[19].must_equal('0')
		end
	end

	describe "#complemento_header_arquivo" do
		it "deve ter 29 posições" do
			subject.complemento_header_arquivo.size.must_equal 29
		end

		it "1 - Primeira parte = versao_aplicativo 4 posicoes - ajustados com zeros a esquerda" do
			subject.conta.versao_aplicativo = '12'
			subject.complemento_header_arquivo[0..3].must_equal '0012'
		
			subject.conta.versao_aplicativo = '123'
			subject.complemento_header_arquivo[0..3].must_equal '0123'
		end

		it "2 - Segunda parte = USO FEBRABAN com 25 posições em branco" do
			subject.complemento_header_arquivo[4..28].must_equal ' ' * 25
		end
	end

	describe "#complemento_p" do

		it "deve ter 34 posições" do
			subject.complemento_p(pagamento).size.must_equal 34
		end

		it "1 - Primeira parte = convenio com 6 posicoes - ajustados com zeros a esquerda" do
			subject.conta.convenio = '12'
			subject.complemento_p(pagamento)[0..5].must_equal '000012'
		
			subject.conta.convenio = '123'
			subject.complemento_p(pagamento)[0..5].must_equal '000123'
		end
		
		it "2 - Seguna parte = Uso Caixa com 11 posicoes com zeros" do
			subject.complemento_p(pagamento)[6..16].must_equal '0' * 11
		end

		it "3 - Terceira parte = Modalidade carteira com 2 posicoes" do
			subject.conta.carteira = '14'
			subject.complemento_p(pagamento)[17..18].must_equal '14'			
			subject.conta.carteira = 'XX'
			subject.complemento_p(pagamento)[17..18].must_equal 'XX'
		end

		it "4 - Quarta parte = nosso_numero com 15 posicoes ajustados com zeros a esquerda" do
			pagamento.nosso_numero = '1234567890'
			subject.complemento_p(pagamento)[19..34].must_equal '000001234567890'
			pagamento.nosso_numero = '1234567890123'
			subject.complemento_p(pagamento)[19..34].must_equal '001234567890123'
		end		
	end

	describe "#segmento_p_numero_do_documento" do
		it "deve ter 15 posições" do
			subject.segmento_p_numero_do_documento(pagamento).size.must_equal 15
		end

		it "1 - Primeira parte = Nr Doc. cobrança com 11 posicoes - ajustados com zeros a esquerda" do
			pagamento.numero_documento = '123456789'
			subject.segmento_p_numero_do_documento(pagamento)[0..10].must_equal '00123456789'
		
			pagamento.numero_documento = '1234567890'
			subject.segmento_p_numero_do_documento(pagamento)[0..10].must_equal '01234567890'
		end

		it "2 - Segunda parte = Uso da CAIXA com 4 posicoes em branco" do
			subject.segmento_p_numero_do_documento(pagamento)[11..14].must_equal ' ' * 4
		end
	end


	describe "#segmento_p_posicao_106_a_106" do
		it "deve ser '0' - diferente do padrão que é um espaço em branco" do
			subject.segmento_p_posicao_106_a_106.must_equal '0'
		end
	end

	describe "#segmento_p_posicao_196_a_220" do
		it "deve ter o numero do documento do pagamento com 25 posições ajustados com zero a esquerda" do
			pagamento.numero_documento = '789798'
			subject.segmento_p_posicao_196_a_220(pagamento).must_equal '789798'.rjust(25, '0')

			pagamento.numero_documento = '99'
			subject.segmento_p_posicao_196_a_220(pagamento).must_equal '99'.rjust(25, '0')
		end
	end

	describe "#segmento_s_posicao_019_a_020_tipo_impressao_1_ou_2" do
		it "deve conter o valor '00' conforme a docuemntação" do
			subject.segmento_s_posicao_019_a_020_tipo_impressao_1_ou_2(pagamento).must_equal '00'
		end
	end
	describe "#segmento_s_posicao_161_a_162_tipo_impressao_1_ou_2" do
		it "deve conter o valor '00' conforme a docuemntação" do
			subject.segmento_s_posicao_161_a_162_tipo_impressao_1_ou_2(pagamento).must_equal '00'
		end
	end

	describe "#complemento_trailer_lote" do
		it "deve ter 217 posições" do
			subject.complemento_trailer_lote(lote, 5).size.must_equal 217
		end

		it "1 - Primeira parte = 69 posições todas preenchidas com zeros" do
			subject.complemento_trailer_lote(lote, 5)[0..68].must_equal '0' * 69
		end

		it "2 - Segunda parte = EXCLUSIVO FEBRABAN com 148 posicoes em branco" do
			subject.complemento_trailer_lote(lote, 5)[69..216].must_equal (' ' * 148)
		end
	end

	describe 'Geração do arquivo' do
		let(:conta) do 
			{
				razao_social:   'EMPRESA EMITENTE',
				cpf_cnpj:       '33.486.451/0001-30',
				carteira:       '14',
				agencia:        '7506',
				codigo_cedente: '828196',
				conta_corrente: '1354843'
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
				nosso_numero:     '140000000000000029',
				numero_documento: '00000000002',
				data_vencimento:  Date.parse('14/11/2016'),
				valor_documento:  10.00,
				pagador:          pagador,
				especie_titulo:   '02',
				codigo_juros:     '0', 
				data_juros:       Date.parse('16/11/2016'),
				valor_juros:      0.00,
				codigo_multa:     '0', 
				data_multa:       Date.parse('15/11/2016'),
				valor_multa:      0.00,
				data_emissao:     Date.parse('14/11/2016'),
			})
		}
		let(:lote) { BrBoleto::Remessa::Lote.new(pagamentos: pagamento) } 
		it "deve gerar o arquivo de remessa corretamente com as informações passadas" do
			remessa = BrBoleto::Remessa::Cnab240::Caixa.new({
				data_hora_arquivo:  Time.parse('14/11/2016 09:31:47'),
				sequencial_remessa: 1,
				conta:              conta,
				lotes:              [lote],
			})
			remessa.dados_do_arquivo.must_equal read_fixture('remessa/cnab240/caixa.rem')
		end
	end
end