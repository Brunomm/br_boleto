require 'test_helper'

describe BrBoleto::Remessa::Cnab240::BancoBrasil do
	subject { FactoryBot.build(:remessa_cnab240_banco_brasil, lotes: lote) }
	let(:pagamento) { FactoryBot.build(:remessa_pagamento, valor_documento: 879.66) }
	let(:lote) { FactoryBot.build(:remessa_lote, pagamentos: pagamento) }

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
				conta_must_be_msg_error(:carteira, :custom_length_is, {count: 2})
			end

			it 'valid_convenio_required' do
				subject.conta.convenio = ''
				conta_must_be_msg_error(:convenio, :blank)
			end

			# it 'valid_convenio_length' do
			# 	subject.send(:valid_convenio_length).must_equal 2
			# 	subject.conta.convenio = '1234567890123456'
			# 	conta_must_be_msg_error(:convenio, :custom_length_maximum, {count: 7})
			# end

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
				must_be_message_error(:base, "#{BrBoleto::Conta::BancoBrasil.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
			end
		end
	end


	describe "#convenio_lote" do
		it "deve ter 20 caracteres" do
			subject.convenio_lote(lote).size.must_equal 20
		end
		it "1 - Primeira parte = codigo convenio 9 posições - ajustados com zeros a esquerda" do
			subject.conta.codigo_cedente = '88'
			subject.convenio_lote(lote)[0..8].must_equal '000000088'

			subject.conta.convenio = '7374'
			subject.convenio_lote(lote)[0..8].must_equal '000007374'
		end

		it "2 - Segunda parte = Cobrança Cedente 4 posições - valor fixo '0014' " do
			subject.convenio_lote(lote)[9..12].must_equal '0014'
		end

		it "3 - Terceira parte = Carteira 2 posições - ajustados com zeros a esquerda" do
			subject.conta.carteira = '88'
			subject.convenio_lote(lote)[13..14].must_equal '88'

			subject.conta.carteira = '1'
			subject.convenio_lote(lote)[13..14].must_equal '01'
		end

		it "4 - Quarta parte = Variação da Carteira 3 posições - ajustados com zeros a esquerda" do
			subject.conta.variacao_carteira = '123'
			subject.convenio_lote(lote)[15..17].must_equal '123'

			subject.conta.variacao_carteira = '1'
			subject.convenio_lote(lote)[15..17].must_equal '001'
		end

		it "5 - Quinta parte = Brancos" do
			subject.convenio_lote(lote)[18..19].must_equal '  '
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

		it "USO FEBRABAN com 25 posições em branco" do
			subject.complemento_header_arquivo[0..28].must_equal ' ' * 29
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
			subject.complemento_p(pagamento)[12..13].must_equal '7 '
		end

		it "3 - Terceira parte = Nosso número com 20 posições ajustado com brancos a direita" do
			pagamento.nosso_numero = '44447777777-1'
			subject.complemento_p(pagamento)[14..33].must_equal '444477777771        '

			pagamento.nosso_numero = '88888888999999999'
			subject.complemento_p(pagamento)[14..33].must_equal '88888888999999999   '
		end

	end

	describe "#segmento_p_numero_do_documento" do
		it "deve ter 15 posições" do
			subject.segmento_p_numero_do_documento(pagamento).size.must_equal 15
		end

		it "deve conter o numero do documento 15 posicoes - ajustados com brancos a direita" do
			pagamento.expects(:numero_documento).returns("977897")
			subject.segmento_p_numero_do_documento(pagamento).must_equal '977897         '
		end
	end

	describe "#complemento_trailer_lote" do
		it "deve ter 217 posições" do
			subject.complemento_trailer_lote(lote, 5).size.must_equal 217
		end

		it " EXCLUSIVO FEBRABAN com 117 posicoes em branco" do
			subject.complemento_trailer_lote(lote, 5).must_equal (' ' * 217)
		end
	end
end
