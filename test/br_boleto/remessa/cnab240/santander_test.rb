require 'test_helper'

describe BrBoleto::Remessa::Cnab240::Santander do
	subject { FactoryGirl.build(:remessa_cnab240_santander, lotes: lote) }
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
				conta_must_be_msg_error(:carteira, :custom_length_is, {count: 3})
			end

			it 'valid_convenio_required' do
				subject.conta.convenio = ''
				conta_must_be_msg_error(:convenio, :blank)
			end

			it 'valid_convenio_length' do
				subject.conta.convenio = '1234567890123456'
				conta_must_be_msg_error(:convenio, :custom_length_maximum, {count: 7})
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
				must_be_message_error(:base, "#{BrBoleto::Conta::Santander.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
			end
		end
	end


	describe "#convenio_lote" do
		it "deve ter 20 caracteres" do
			subject.convenio_lote(lote).size.must_equal 20
		end
		it "deve ter 20 posições em branco" do
			subject.convenio_lote(lote).must_equal (' ' * 20)
		end
	end

	describe "#informacoes_da_conta" do
		it "deve ter 25 posições" do
			subject.informacoes_da_conta.size.must_equal 25
		end

		it "deve ter 25 posições em brancos" do	
			subject.informacoes_da_conta.must_equal (' '	* 25)

		end
	end

	describe "#header_arquivo_posicao_167_a_240" do
		it "deve ter 74 posições" do
			subject.header_arquivo_posicao_167_a_240.size.must_equal 74
		end

		it "deve ter 74 posições em branco" do
			subject.header_arquivo_posicao_167_a_240.must_equal (' ' * 74)
		end
	end

	describe "#complemento_p" do

		it "deve ter 35 posições" do
			subject.complemento_p(pagamento).size.must_equal 35
		end

		it "1 - Primeira parte = conta_corrente com 12 posicoes - ajustados com zeros a esquerda" do
			subject.conta.conta_corrente = '1234'
			subject.complemento_p(pagamento)[0..8].must_equal '000001234'
		
			subject.conta.conta_corrente = '264631'
			subject.complemento_p(pagamento)[0..8].must_equal '000264631'
		end
		
		it "2 - Seguna parte = Conta Corrente DV - 1 posicao" do
			subject.conta.conta_corrente_dv = '7'
			subject.complemento_p(pagamento)[9..9].must_equal '7'
		end

		it "3 - Terceira parte = zeros" do
			subject.complemento_p(pagamento)[10..18].must_equal '000000000'
		end

		it "4 - Quarta parte = zero" do
			subject.complemento_p(pagamento)[19..19].must_equal '0'
		end

		it "5 - Quinta parte = brancos" do
			subject.complemento_p(pagamento)[20..21].must_equal '  '
		end			

		it "7 - Setima parte = numero_documento DV com 1 posicao - Deve ser o ultimo digito do nosso numero" do
			pagamento.nosso_numero = '1212121212129'
			subject.complemento_p(pagamento)[22..34].must_equal '1212121212129'			

			pagamento.nosso_numero = '9999999999990'
			subject.complemento_p(pagamento)[22..34].must_equal '9999999999990'
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

		it "Exclusivo banco com 217 posicoes em branco" do
			subject.complemento_trailer_lote(lote, 5).must_equal (' ' * 217)
		end
	end
end