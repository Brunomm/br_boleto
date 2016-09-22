# encoding: utf-8
require 'test_helper'

describe BrBoleto::Boleto::Bradesco do
	subject { FactoryGirl.build(:boleto_bradesco, conta: conta) }
	let(:conta) { FactoryGirl.build(:conta_bradesco) } 
	
	context "on validations" do
		it { must validate_length_of(:numero_documento).is_at_most(11).with_message(:custom_length_maximum) }
		
		context '#conta.carteira' do
			it { subject.valid_carteira_inclusion.must_equal ['06','09','19','21','22'] }
			it "validação da carteira da conta" do
				subject.conta.carteira = '4'
				conta_must_be_msg_error(:carteira, :custom_inclusion, {list: '06, 09, 19, 21, 22'})
				subject.conta.carteira = '06'
				conta_wont_be_msg_error(:carteira, :custom_inclusion, {list: '06, 09, 19, 21, 22'})
			end
		end

		describe '#conta.convenio / codigo_cedente' do
			it { subject.valid_convenio_maximum.must_equal 7 }
			it { subject.valid_convenio_required.must_equal true }
			
			it "validação obrigatoriedade do codigo_cedente da conta" do
				subject.conta.codigo_cedente = ''
				conta_must_be_msg_error(:convenio, :blank)
				subject.conta.codigo_cedente = '123456'
				conta_wont_be_msg_error(:convenio, :blank)
			end
		end

		private

		def conta_must_be_msg_error(attr_validation, msg_key, options_msg={})
			must_be_message_error(:base, "#{BrBoleto::Conta::Bradesco.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
		def conta_wont_be_msg_error(attr_validation, msg_key, options_msg={})
			wont_be_message_error(:base, "#{BrBoleto::Conta::Bradesco.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
	end

	describe "#default_values" do
		it "local_pagamento deve ter o valor padrão conforme a documentação" do
			BrBoleto::Boleto::Bradesco.new.local_pagamento.must_equal 'PAGÁVEL PREFERENCIALMENTE NA REDE BRADESCO OU NO BRADESCO EXPRESSO'
		end
	end

	describe "#digito_verificador_nosso_numero" do
		it "deve calcular pelo Modulo11Fator3197" do
			subject.conta.agencia = 21
			subject.numero_documento = 111
			BrBoleto::Calculos::Modulo11FatorDe2a7.expects(:new).with("2100000000111").returns("meu_resultado")
			subject.digito_verificador_nosso_numero.must_equal "meu_resultado"
		end
	end

	describe "#nosso_numero" do
		subject { FactoryGirl.build(:boleto_bradesco, numero_documento: '68315') }

		it "deve retornar o numero do documento com o digito_verificador_nosso_numero" do 
			subject.stubs(:digito_verificador_nosso_numero).returns('9')
			subject.numero_documento = '3646'
			subject.nosso_numero.must_equal "21/00000003646-9"
		end
	end

	describe "#codigo_de_barras_do_banco" do
		subject do 
			FactoryGirl.build(:boleto_bradesco, conta: {
					carteira: '21',
					agencia: '78',
					conta_corrente: '668',
				},
				numero_documento: '395'
			)
		end
		it "deve montar o codigo corretamente com as informações" do
			subject.stubs(:nosso_numero).returns('21/00000003646-9')

			result = subject.codigo_de_barras_do_banco
			result.size.must_equal 25

			result[0..3].must_equal '0078' # Agencia
			result[4..5].must_equal '21' # Carteira
			result[6..16].must_equal '00000000395' # Numero documento
			result[17..23].must_equal '0000668' # Conta Corrente
			result[24].must_equal '0' # Zero

			subject.codigo_de_barras_do_banco.must_equal '0078210000000039500006680'


		end
	end

	describe "#codigo_de_barras" do
		subject do
			FactoryGirl.build(:boleto_bradesco) do |bradesco|
				bradesco.conta.agencia        = 3069
				bradesco.conta.codigo_cedente = 828_19 # Para o bradesco é o código do cliente
				bradesco.conta.codigo_cedente_dv = '0' # Para o bradesco é o código do cliente
				bradesco.conta.carteira       = '06'
				bradesco.numero_documento     = 100_10
				bradesco.valor_documento      = 93015.78
				bradesco.data_vencimento      = Date.parse('2020-02-17')
			end
		end

		it { subject.codigo_de_barras.must_equal '23799816800093015783069060000001001000897550' }
		it { subject.linha_digitavel.must_equal '23793.06901 60000.001002 10008.975509 9 81680009301578' }		

		it "codigo de barras de um boleto de exemplo" do
			subject.conta.agencia           = 3069  
			subject.conta.codigo_cedente    = 82819 # Para o bradesco é o código do cliente
			subject.conta.codigo_cedente_dv = 0 # Para o bradesco é o código do cliente
			subject.conta.carteira       = '06'
			subject.numero_documento     = 15_679
			subject.valor_documento      = 408.50
			subject.data_vencimento      = Date.parse('2016-09-01')

			subject.linha_digitavel.must_equal '23793.06901 60000.001564 79008.975504 7 69040000040850'
			subject.codigo_de_barras.must_equal '23797690400000408503069060000001567900897550'
		end
	end
end