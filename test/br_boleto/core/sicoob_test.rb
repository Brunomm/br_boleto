# encoding: utf-8
require 'test_helper'

describe BrBoleto::Core::Sicoob do
	subject { BrBoleto::Core::Sicoob.new }
	context "on validations" do
		it { must validate_length_of(:agencia).is_at_most(4) }
	
		it { must validate_length_of(:codigo_cedente).is_at_most(7) }

		it { must validate_length_of(:numero_documento).is_at_most(7) }
		
		it { must validate_inclusion_of(:carteira).in_array(%w(1 3)) }
		it { wont allow_value(9).for(:carteira) }		
		it { wont allow_value(6).for(:carteira) }		

		it { must validate_inclusion_of(:modalidade_cobranca).in_array(%w(1 2 3)) }
		it { wont allow_value(4).for(:modalidade_cobranca) }		
		it { wont allow_value(5).for(:modalidade_cobranca) }		
		
		it { must validate_numericality_of(:valor_documento).is_less_than_or_equal_to(99999999.99) }
		
	end
	context "#agencia" do
		it "get value when have a value" do
			subject.agencia = '215'
			subject.agencia.must_equal '0215'
		end
		
		it "returns nil when is nil" do
			subject.agencia = nil
			subject.agencia.must_be_nil
		end
	end

	context "#conta_corrente" do
		it "when have a value" do
			subject.codigo_cedente = '9201'
			subject.codigo_cedente.must_equal '0009201' 
		end

		it "when is nil" do
			subject.codigo_cedente = nil
			subject.codigo_cedente.must_be_nil
		end
	end

	context "#numero_documento" do
		it "when have a value" do
			subject.numero_documento = '1'
			subject.numero_documento.must_equal '0000001'
		end

		it "when is nil" do
			subject.numero_documento = nil
			subject.numero_documento.must_be_nil
		end
	end
	describe "#carteira" do
		it "when have a value" do
			subject.carteira = '1'

			subject.carteira.must_equal '1' 
		end

		it "when is nil" do
			subject.carteira = nil
			subject.carteira.must_be_nil
		end
	end

	describe "#codigo_banco" do
		it{ subject.codigo_banco.must_equal '756' }
	end

	describe "#digito_codigo_banco" do
		it { subject.digito_codigo_banco.must_equal '0' }
	end

	describe "#agencia_codigo_beneficiario" do
		subject { FactoryGirl.build(:boleto_sicoob, agencia: 48, codigo_cedente: '7368') }
		 
		it { subject.agencia_codigo_cedente.must_equal '0048 / 0007368' }
	end

	describe "#digito_verificador_nosso_numero" do
		it "deve calcular pelo Modulo11Fator3197" do
			subject.agencia = 1
			subject.codigo_cedente = 33
			subject.numero_documento = 111
			BrBoleto::Calculos::Modulo11Fator3197.expects(:new).with("000100000000330000111").returns("meu_resultado")
			subject.digito_verificador_nosso_numero.must_equal "meu_resultado"
		end
	end

	describe "#nosso_numero" do
		subject { FactoryGirl.build(:boleto_sicoob, numero_documento: '68315') }

		it "deve retornar o numero do documento com o digito_verificador_nosso_numero" do 
			subject.stubs(:digito_verificador_nosso_numero).returns('9')
			subject.numero_documento = '3646'
			subject.nosso_numero.must_equal "0003646-9"
		end
	end

	describe "#codigo_de_barras_do_banco" do
		subject do 
			FactoryGirl.build(:boleto_sicoob,
				carteira: '1',
				agencia: '78',
				codigo_cedente: '66',
				# modalidade_cobranca: '1',
				# parcelas: '1'
			)
		end
		it "name" do
			subject.stubs(:nosso_numero).returns('1234567-8')
			subject.codigo_de_barras_do_banco.must_equal "1007801000006612345678001"
		end
	end

	describe "#modalidade_cobranca" do
		it "tem um valor padrão que é 01" do
			subject.class.new().modalidade_cobranca.must_equal "01"
		end
		it "posso modificar a modalidade de cobranca" do
			subject.modalidade_cobranca = 2
			subject.modalidade_cobranca.must_equal "02"
		end
	end

	describe "#parcelas" do
		it "tem um valor padrão que é 001" do
			subject.class.new().parcelas.must_equal "001"
		end
		it "deve permitir a modificação do número de parcelas" do
			subject.parcelas = 2
			subject.parcelas.must_equal "002"
		end
	end
	
	describe "#codigo_de_barras" do
		subject do
			FactoryGirl.build(:boleto_sicoob) do |sicoob|
				sicoob.agencia          = 3069
				sicoob.codigo_cedente   = 828_190 # Para o sicoob é o código do cliente
				sicoob.numero_documento = 100_10
				sicoob.carteira         = 1
				sicoob.valor_documento  = 93015.78
				sicoob.data_vencimento  = Date.parse('2020-02-17')
			end
		end

		it { subject.codigo_de_barras.must_equal '75699816800093015781306901082819000100107001' }
		it { subject.linha_digitavel.must_equal '75691.30698 01082.819002 01001.070018 9 81680009301578' }		
	end

	describe "#carteiras_suportadas" do
		it { subject.class.carteiras_suportadas.must_equal ["1","3"] }
	end
end