# encoding: utf-8
require 'test_helper'

describe BrBoleto::Boleto::Caixa do
	subject { FactoryGirl.build(:boleto_caixa) }

		context "on validations" do
			it { must validate_length_of(:numero_documento).is_at_most(15).with_message(:custom_length_maximum) }
			
			context '#conta.modalidade' do
				it { subject.valid_modalidade_inclusion.must_equal ['14','24'] }
				it 'modalidade deve ter 2 digitos' do
					subject.valid_modalidade_length.must_equal 2
					subject.conta.modalidade = '1'
					conta_must_be_msg_error(:modalidade, :custom_length_is, {count: 2})
					subject.conta.modalidade = '123'
					conta_must_be_msg_error(:modalidade, :custom_length_is, {count: 2})
					subject.conta.modalidade = '12'
					conta_wont_be_msg_error(:modalidade, :custom_length_is, {count: 2})
				end
				it "validação da modalidade da conta" do
					subject.conta.modalidade = '5'
					conta_must_be_msg_error(:modalidade, :custom_inclusion, {list: '14, 24'})
					subject.conta.modalidade = '24'
					conta_wont_be_msg_error(:modalidade, :custom_inclusion, {list: '14, 24'})
				end
			end

			describe '#conta.convenio / codigo_cedente' do
				it { subject.valid_convenio_maximum.must_equal 6 }
				it { subject.valid_convenio_required.must_equal true }
				
				it "validação obrigatoriedade do codigo_cedente da conta" do
					subject.conta.codigo_cedente = ''
					conta_must_be_msg_error(:convenio, :blank)
					subject.conta.codigo_cedente = '123456'
					conta_wont_be_msg_error(:convenio, :blank)
				end
				it "validação tamaho maximo do codigo_cedente da conta" do
					subject.conta.codigo_cedente = '1234567'
					conta_must_be_msg_error(:convenio, :custom_length_maximum, {count: 6})
					subject.conta.codigo_cedente = '123456'
					conta_wont_be_msg_error(:convenio, :custom_length_maximum, {count: 6})
				end
			end

			private

			def conta_must_be_msg_error(attr_validation, msg_key, options_msg={})
				must_be_message_error(:base, "#{BrBoleto::Conta::Sicoob.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
			end
			def conta_wont_be_msg_error(attr_validation, msg_key, options_msg={})
				wont_be_message_error(:base, "#{BrBoleto::Conta::Sicoob.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
			end
		end

	describe "#default_values" do
		it "deve setar um valor padrão de local_pagamento com o valor descrito na documentação" do
			BrBoleto::Boleto::Caixa.new.local_pagamento.must_equal 'PREFERENCIALMENTE NAS CASAS LOTÉRICAS ATÉ O VALOR LIMITE'
		end
	end

	describe "#digito_verificador_nosso_numero " do
		it "deve utilizar o Modulo11FatorDe2a9RestoZero para calcular o digito passando a carteira e numero_documento" do
			subject.assign_attributes(conta: {carteira: '14'}, numero_documento: '77445')
			BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.expects(:new).with("14000000000077445").returns('8')

			subject.digito_verificador_nosso_numero.must_equal '8'
		end
	end

	describe "#nosso_numero " do
		it "deve utilizar a modalidade, numero_documento e o DV do nosso_numero" do
			subject.expects(:digito_verificador_nosso_numero).returns('7')
			subject.assign_attributes(conta: {modalidade: '24'}, numero_documento: '789')
			subject.nosso_numero.must_equal('24000000000000789-7')
		end
	end

	describe "#nosso_numero_de_3_a_5" do
		it "deve pegar o valor das posições 2 até 4 da string do nosso_numero" do
			subject.expects(:nosso_numero).returns('1234567890ABCDEFG-H')
			subject.nosso_numero_de_3_a_5.must_equal '345'
		end
	end

	describe "#nosso_numero_de_6_a_8" do
		it "deve pegar o valor das posições 5 até 7 da string do nosso_numero" do
			subject.expects(:nosso_numero).returns('1234567890ABCDEFG-H')
			subject.nosso_numero_de_6_a_8.must_equal '678'
		end
	end

	describe "#nosso_numero_de_9_a_17" do
		it "deve pegar o valor das posições 8 até 16 da string do nosso_numero" do
			subject.expects(:nosso_numero).returns('1234567890ABCDEFG-H')
			subject.nosso_numero_de_9_a_17.must_equal '90ABCDEFG'
		end
	end

	# describe "#tipo_cobranca" do
	# 	it "deve pegar o primeiro caracter da carteira se houver valor na carteira" do
	# 		subject.conta.carteira = 'X7'
	# 		subject.tipo_cobranca.must_equal 'X'
	# 		subject.conta.carteira = 'A7'
	# 		subject.tipo_cobranca.must_equal 'A'
	# 	end
	# 	it "se carteira for nil não deve dar erro" do
	# 		subject.conta.carteira = nil
	# 		subject.tipo_cobranca.must_be_nil
	# 	end
	# end

	describe "#identificador_de_emissao" do
		it "deve retornar o ultimo caractere da modalidade" do
			subject.conta.modalidade = 'X71'
			subject.identificador_de_emissao.must_equal '1'
			subject.conta.modalidade = 'A2'
			subject.identificador_de_emissao.must_equal '2'
		end
	end

	describe "#composicao_codigo_barras" do
		before do
			subject.conta.codigo_beneficiario = '123456'
			subject.conta.agencia = '2391'
			subject.conta.carteira = '14'
			subject.numero_documento = 'ABCDEFGHIJKLMNO'
		end

		it "codigo completo conforme a documentação" do
			subject.composicao_codigo_barras.must_equal '1234560ABC1DEF4GHIJKLMNO'
		end

		it "da posição 0 até 5 deve ter o valor de codigo_beneficiario " do
			subject.composicao_codigo_barras[0..5].must_equal '123456'
		end

		it "da posição 6 até 6 deve ter o valor de digito_verificador_codigo_beneficiario " do
			subject.composicao_codigo_barras[6].must_equal '0'
		end

		it "da posição 7 até 9 deve ter o valor de nosso_numero_de_3_a_5 " do
			subject.composicao_codigo_barras[7..9].must_equal 'ABC'
		end

		it "da posição 10 até 10 deve ter o valor de tipo_cobranca " do
			subject.composicao_codigo_barras[10].must_equal '1'
		end

		it "da posição 11 até 13 deve ter o valor de nosso_numero_de_6_a_8 " do
			subject.composicao_codigo_barras[11..13].must_equal 'DEF'
		end

		it "da posição 14 até 14 deve ter o valor de identificador_de_emissao " do
			subject.composicao_codigo_barras[14].must_equal '4'
		end

		it "da posição 15 até 23 deve ter o valor de nosso_numero_de_9_a_17 " do
			subject.composicao_codigo_barras[15..23].must_equal 'GHIJKLMNO'
		end

		it "a posição 24 deve ser nil " do
			subject.composicao_codigo_barras[24].must_be_nil
		end		
	end

	describe "#codigo_de_barras_do_banco" do
		it "deve retornar a composicao_codigo_barras e concatenar o DV do mesmo com o calculo de Modulo11FatorDe2a9RestoZero" do
			subject.instance_variable_set(:@composicao_codigo_barras, 'valor')
			subject.expects(:composicao_codigo_barras).returns('123456').twice
			BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.expects(:new).with('123456').returns('*')

			subject.codigo_de_barras_do_banco.must_equal '123456*'
		end
	end
end