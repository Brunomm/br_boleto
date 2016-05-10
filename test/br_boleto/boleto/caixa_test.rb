# encoding: utf-8
require 'test_helper'

describe BrBoleto::Boleto::Caixa do
	subject { FactoryGirl.build(:boleto_caixa) }

	describe "#default_values" do
		it "deve setar um valor padrão de local_pagamento com o valor descrito na documentação" do
			BrBoleto::Boleto::Caixa.new.local_pagamento.must_equal 'PREFERENCIALMENTE NAS CASAS LOTÉRICAS ATÉ O VALOR LIMITE'
		end
	end

	describe "validations" do
		it { must validate_presence_of(:agencia) }
		it { must validate_presence_of(:codigo_cedente) }

		it { must validate_length_of(:agencia         ).is_at_most(4) }		
		it { must validate_length_of(:codigo_cedente  ).is_at_most(6) }
		it { must validate_length_of(:numero_documento).is_at_most(15) }
		
		it { must validate_inclusion_of(:carteira).in_array(%w(14 24)) }
		
		it { must validate_numericality_of(:valor_documento).is_less_than_or_equal_to(99999999.99) }
	end

	describe "#codigo_banco - banco da caixa deve ser 104" do
		it{ subject.codigo_banco.must_equal '104' }
	end

	describe "#digito_codigo_banco - deve ser zero" do
		it { subject.digito_codigo_banco.must_equal '0' }
	end

	describe "#agencia_codigo_cedente" do
		it "deve retornar no formato: agencia / codigo_cedente-dv_codigo_cedente" do
			subject.assign_attributes(agencia: '557', codigo_cedente: '35412')
			subject.expects(:digito_verificador_codigo_cedente).returns('7')
			subject.agencia_codigo_cedente.must_equal "0557 / 035412-7"
		end
	end

	describe "#digito_verificador_codigo_cedente" do
		it "deve utilizar o calculo de Modulo11FatorDe2a9RestoZero para calcular o DV" do
			subject.codigo_cedente = '999999'
			BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.expects(:new).with('999999').returns('5')

			subject.digito_verificador_codigo_cedente.must_equal '5'
		end
		
		describe "#digito_verificador_codigo_beneficiario" do
			it "deve retornar o mesmo valor de #digito_verificador_codigo_cedente" do
				subject.expects(:digito_verificador_codigo_cedente).returns('valor')
				subject.digito_verificador_codigo_beneficiario.must_equal 'valor'
			end
		end
	end

	describe "#digito_verificador_nosso_numero " do
		it "deve utilizar o Modulo11FatorDe2a9RestoZero para calcular o digito passando a carteira e numero_documento" do
			subject.assign_attributes(carteira: '14', numero_documento: '77445')
			BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.expects(:new).with("14000000000077445").returns('8')

			subject.digito_verificador_nosso_numero.must_equal '8'
		end
	end

	describe "#nosso_numero " do
		it "deve utilizar a carteira, numero_documento e o DV do nosso_numero" do
			subject.expects(:digito_verificador_nosso_numero).returns('7')
			subject.assign_attributes(carteira: '24', numero_documento: '789')
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

	describe "#tipo_cobranca" do
		it "deve pegar o primeiro caracter da carteira se houver valor na carteira" do
			subject.carteira = 'X7'
			subject.tipo_cobranca.must_equal 'X'
			subject.carteira = 'A7'
			subject.tipo_cobranca.must_equal 'A'
		end
		it "se carteira for nil não deve dar erro" do
			subject.carteira = nil
			subject.tipo_cobranca.must_be_nil
		end

		describe "#modalidade_cobranca" do
			it "deve simplemente pegar o valor do tipo_cobranca" do
				subject.expects(:tipo_cobranca).returns(:valor)
				subject.modalidade_cobranca.must_equal :valor				
			end
		end
	end

	describe "#identificador_de_emissao" do
		it "deve retornar o ultimo caractere da carteira" do
			subject.carteira = 'X71'
			subject.identificador_de_emissao.must_equal '1'
			subject.carteira = 'A2'
			subject.identificador_de_emissao.must_equal '2'
		end
	end

	describe "#carteira_formatada - Conforme o manual da caixa deve retornar RG para carteira com registro e SR para carteira sem registro" do
		it "para a carteira 14 deve retornar RG" do
			subject.carteira = '14'
			subject.carteira_formatada.must_equal 'RG'
		end
		it "para a carteira 24 deve retornar SR" do
			subject.carteira = '24'
			subject.carteira_formatada.must_equal 'SR'
		end
	end


	describe "#composicao_codigo_barras" do
		before do
			subject.codigo_beneficiario = '123456'
			subject.agencia = '2391'
			subject.carteira = '14'
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