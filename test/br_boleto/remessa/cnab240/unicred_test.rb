require 'test_helper'

describe BrBoleto::Remessa::Cnab240::Unicred do
	subject { FactoryGirl.build(:remessa_cnab240_unicred, lotes: lote) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento, valor_documento: 879.66) } 
	let(:lote) { FactoryGirl.build(:remessa_lote, pagamentos: pagamento) } 

	it "deve herdar da class Bradesco" do
		subject.class.superclass.must_equal BrBoleto::Remessa::Cnab240::Bradesco
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
				conta_must_be_msg_error(:convenio, :custom_length_maximum, {count: 7})
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

			private

			def conta_must_be_msg_error(attr_validation, msg_key, options_msg={})
				must_be_message_error(:base, "#{BrBoleto::Conta::Unicred.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
			end
		end
	end


	describe "#convenio_lote" do
		it "as 7 primeiras posições deve ser o valor do convenio ajustado com zeros a esquerda" do
			subject.conta.codigo_cedente = '88'
			subject.convenio_lote(lote).must_equal '00000000000000000088'

			subject.conta.convenio = '7374'
			subject.convenio_lote(lote).must_equal '00000000000000007374'
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
			subject.conta.agencia = '47'
			subject.informacoes_da_conta[0..4].must_equal '00047'			

			subject.conta.agencia = '1234'
			subject.informacoes_da_conta[0..4].must_equal '01234'
		end

		it "2 - Segunda parte = agencia_dv" do
			subject.conta.agencia_dv = '7'
			subject.informacoes_da_conta[5].must_equal "7"
		end

		it "3 - Terceira parte = conta_corrente 12 posicoes - ajustados com zeros a esquerda" do
			subject.conta.conta_corrente = '89755'
			subject.informacoes_da_conta[6..17].must_equal '000000089755'			

			subject.conta.conta_corrente = '1234567890'
			subject.informacoes_da_conta[6..17].must_equal '001234567890'
		end

		it "4 - Quarta parte = Conta Corrente DV" do
			subject.conta.conta_corrente_dv = '8'
			subject.informacoes_da_conta[18..18].must_equal('8')			
		end

		it "5 - Quinta parte = Se o conta_corrente_dv não for 2 digitos deve ter 1 espaço em branco" do
			subject.informacoes_da_conta[19].must_equal(' ')
		end
	end

	describe "#complemento_header_arquivo" do
		it "deve ter 29 posições" do
			subject.complemento_header_arquivo.size.must_equal 29
		end

		it "2 - Segunda parte = USO FEBRABAN com 25 posições em branco" do
			subject.complemento_header_arquivo[4..28].must_equal ' ' * 25
		end
	end

	describe "#complemento_p" do

		it "deve ter 34 posições" do
			subject.complemento_p(pagamento).size.must_equal 34
		end

		it "1 - Primeira parte = conta_corrente com 12 posicoes - ajustados com zeros a esquerda" do
			subject.conta.conta_corrente = '1234'
			subject.complemento_p(pagamento)[0..11].must_equal '000000001234'
		
			subject.conta.conta_corrente = '264631'
			subject.complemento_p(pagamento)[0..11].must_equal '000000264631'
		end
		
		it "2 - Seguna parte = Conta Corrente DV - 1 posicao" do
			subject.conta.conta_corrente_dv = '7'
			subject.complemento_p(pagamento)[12..12].must_equal '7'
		end

		it "3 - Terceira parte = Se o conta_corrente_dv não for 2 digitos deve ter 1 espaço em branco" do
			subject.complemento_p(pagamento)[13..13].must_equal ' '			
		end

		it "4 - Quarta parte = Numero documento com 11 posicoes" do
			pagamento.numero_documento = '89378'
			subject.complemento_p(pagamento)[14..24].must_equal '00000089378'		

			pagamento.numero_documento = '12345678901'
			subject.complemento_p(pagamento)[14..24].must_equal '12345678901'
		end

		it "5 - Quinta parte = numero_documento DV com 1 posicao - Deve ser o ultimo digito do nosso numero" do
			pagamento.nosso_numero = '99/99999999999-9'
			subject.complemento_p(pagamento)[25..25].must_equal '9'			

			pagamento.nosso_numero = '99/99999999999-0'
			subject.complemento_p(pagamento)[25..25].must_equal '0'
		end

		it "6 - Sexta parte = Exclusivo Banco com 8 posicoes preenchidas com zeros" do
			subject.complemento_p(pagamento)[26..33].must_equal ' ' * 8
		end	

	end

	describe "#segmento_p_numero_do_documento" do
		it "deve ter 15 posições" do
			subject.segmento_p_numero_do_documento(pagamento).size.must_equal 15
		end

		it "deve conter o numero do documento 15 posicoes - ajustados com zeros a esquerda" do	
			pagamento.expects(:numero_documento).returns("977897")
			subject.segmento_p_numero_do_documento(pagamento).must_equal '000000000977897'
		end
	end

	describe "#complemento_trailer_lote" do
		it "deve ter 217 posições" do
			subject.complemento_trailer_lote(lote, 5).size.must_equal 217
		end

		it "1 - Primeira parte = 92 posições todas preenchidas com zeros (VALORES UTILIZADOS APENAS PARA ARQUIVO DE RETORNO)" do
			subject.complemento_trailer_lote(lote, 5)[0..91].must_equal '0' * 92
		end

		it "2 - Segunda parte = 8 posições todas preenchidas com zeros (Nr. do aviso de lançamento do crédito referente aos títulos de cobrança)" do
			subject.complemento_trailer_lote(lote, 5)[92..99].must_equal ('0' * 8)
		end

		it "3 - Terceira parte = EXCLUSIVO FEBRABAN com 117 posicoes em branco" do
			subject.complemento_trailer_lote(lote, 5)[100..216].must_equal (' ' * 117)
		end
	end

	describe "usa_segmento_S?" do
		it "deve retornar false como padrão para o UNICRED" do
			subject.usa_segmento_S?.must_equal false 
		end
	end

	describe 'Geração do arquivo' do
		let(:conta) do 
			{
				razao_social:   'EMPRESA EMITENTE',
				cpf_cnpj:       '33.486.451/0001-30',
				carteira:       '09',
				agencia:        '7506',
				codigo_cedente: '82819',
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
				nome_avalista:      'EMPRESA EMITENTE',
				documento_avalista: '33486451000130'
			}
		}
		let(:pagamento) { 
			BrBoleto::Remessa::Pagamento.new({
				nosso_numero:     '09000000000011',
				numero_documento: '00000000001',
				data_vencimento:  Date.parse('13/12/2016'),
				valor_documento:  50.00,
				pagador:          pagador,
				especie_titulo:   '02',
				codigo_juros:     '0', 
				data_juros:       Date.parse('15/12/2016'),
				valor_juros:      0.00,
				codigo_multa:     '0', 
				data_multa:       Date.parse('14/12/2016'),
				valor_multa:      0.00,
				data_emissao:     Date.parse('10/11/2016'),
			})
		}
		let(:lote) { BrBoleto::Remessa::Lote.new(pagamentos: pagamento) } 
		it "deve gerar o arquivo de remessa corretamente com as informações passadas" do
			remessa = BrBoleto::Remessa::Cnab240::Unicred.new({
				data_hora_arquivo:  Time.parse('10/11/2016 09:27:45'),
				sequencial_remessa: 1,
				conta:              conta,
				lotes:              [lote],
			})
			remessa.dados_do_arquivo.must_equal read_fixture('remessa/cnab240/unicred.rem')
		end
	end
end