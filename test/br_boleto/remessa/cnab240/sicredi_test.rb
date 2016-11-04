require 'test_helper'

describe BrBoleto::Remessa::Cnab240::Sicredi do
	subject { FactoryGirl.build(:remessa_cnab240_sicredi, lotes: lote) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento, valor_documento: 879.66) } 
	let(:lote) { FactoryGirl.build(:remessa_lote, pagamentos: pagamento) } 

	it "deve herdar da class Base" do
		subject.class.superclass.must_equal BrBoleto::Remessa::Cnab240::Base
	end

	context "validations" do
		describe 'Validações personalizadas da conta' do
			it 'valid_carteira_required' do
				subject.conta.carteira = ''
				conta_must_be_msg_error(:carteira, :blank)
			end

			it 'valid_carteira_length' do
				subject.conta.carteira = '1234567890123456'
				conta_must_be_msg_error(:carteira, :custom_length_is, {count: 1})
			end

			it 'valid_convenio_required' do
				subject.conta.convenio = ''
				conta_must_be_msg_error(:convenio, :blank)
			end

			it 'valid_convenio_length' do
				subject.conta.convenio = '1234567890123456'
				conta_must_be_msg_error(:convenio, :custom_length_maximum, {count: 5})
			end

			it 'agencia_required' do
				subject.conta.agencia = ''
				conta_must_be_msg_error(:agencia, :blank)
			end

			it 'agencia_length' do
				subject.conta.agencia = '1234567890123456'
				conta_must_be_msg_error(:agencia, :custom_length_is, {count: 4})
			end

			private

			def conta_must_be_msg_error(attr_validation, msg_key, options_msg={})
				must_be_message_error(:base, "#{BrBoleto::Conta::Sicredi.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
			end
		end
	end

	context "HEADER ARQUIVO" do
		describe "#codigo_convenio" do
			it "deve ter 20 posições" do
				subject.codigo_convenio.size.must_equal 20
			end
			it {subject.codigo_convenio.must_equal ' ' * 20 }
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

			it "2 - Segunda parte = Espaço em Branco" do
				subject.informacoes_da_conta[5].must_equal " "
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

			it "5 - Quinta parte = Espaço em Branco" do
				subject.informacoes_da_conta[19].must_equal(' ')
			end
		end

		describe "#header_arquivo_posicao_167_a_171" do
			it {subject.header_arquivo_posicao_167_a_171.must_equal '01600'}
		end

		describe "#header_arquivo_posicao_172_a_191" do
			it {subject.header_arquivo_posicao_172_a_191.must_equal ' ' * 20 }
		end

		describe "#header_arquivo_posicao_192_a_211" do
			it {subject.header_arquivo_posicao_192_a_211.must_equal ' ' * 20 }
		end

		describe "#complemento_header_arquivo" do
			it "deve ter 29 posições" do
				subject.complemento_header_arquivo.size.must_equal 29
			end

			it "2 - Segunda parte = USO FEBRABAN com 25 posições em branco" do
				subject.complemento_header_arquivo[4..28].must_equal ' ' * 25
			end
		end
	end

	context "HEADER LOTE" do
		describe "#header_lote_posicao_012_a_013" do
			it {subject.header_lote_posicao_012_a_013.must_equal ' ' * 2 }
		end

		describe "#convenio_lote" do
			it "deve ser preenchido com espaço em branco" do
				subject.convenio_lote(lote).must_equal ' ' * 20
			end
			it "deve ter 20 caracteres" do
				subject.convenio_lote(lote).size.must_equal 20
			end
		end
	end

	context "SEGMENTO P" do
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

			it "3 - Terceira parte = Espaço em branco" do
				subject.complemento_p(pagamento)[13..13].must_equal ' '			
			end

			it "4 - Quarta parte = Nosso Numero" do
				pagamento.expects(:nosso_numero).returns("132xxxxxD")
				subject.complemento_p(pagamento)[14..33].must_equal '00000000000132xxxxxD'			
			end
		end

		describe "#segmento_p_numero_do_documento" do
			it "deve ter 15 posições" do
				subject.segmento_p_numero_do_documento(pagamento).size.must_equal 15
			end

			it "deve conter o numero do documento 15 posicoes - ajustados com zeros a esquerda" do	
				pagamento.expects(:numero_documento).returns("977897")
				subject.segmento_p_numero_do_documento(pagamento).must_equal '0000977897     '
			end
		end

		describe "#segmento_p_posicao_224_a_224" do
			it {subject.segmento_p_posicao_224_a_224.must_equal '1'}
		end

		describe "#segmento_p_posicao_225_a_227" do
			it {subject.segmento_p_posicao_225_a_227.must_equal '060'}
		end
	end	

	context "SEGMENTO R" do
		describe "#segmento_r_posicao_066_a_066(pagamento)" do
			it {subject.segmento_r_posicao_066_a_066(pagamento).must_equal '2'}
		end
	end

	context "TRAILER LOTE" do
		describe "#complemento_trailer_lote" do
			it "deve ter 217 posições" do
				subject.complemento_trailer_lote(lote, 5).size.must_equal 217
			end

			it "1 - Primeira parte = 92 posições todas preenchidas com zeros (VALORES UTILIZADOS APENAS PARA ARQUIVO DE RETORNO)" do
				subject.complemento_trailer_lote(lote, 5)[0..91].must_equal '0' * 92
			end

			it "2 - Segunda parte = 8 posições todas preenchidas com zeros (Nr. do aviso de lançamento do crédito referente aos títulos de cobrança)" do
				subject.complemento_trailer_lote(lote, 5)[92..99].must_equal (' ' * 8)
			end

			it "3 - Terceira parte = EXCLUSIVO FEBRABAN com 117 posicoes em branco" do
				subject.complemento_trailer_lote(lote, 5)[100..216].must_equal (' ' * 117)
			end
		end
	end

end