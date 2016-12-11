# encoding: utf-8
require 'test_helper'

describe BrBoleto::Boleto::Santander do
	subject { FactoryGirl.build(:boleto_santander, conta: conta) }
	let(:conta) { FactoryGirl.build(:conta_santander) } 
	
	context "on validations" do
		it { must validate_length_of(:numero_documento).is_at_most(12).with_message(:custom_length_maximum) }
		
		context '#conta.carteira' do
			it { subject.valid_carteira_inclusion.must_equal ['101','102','121'] }
			it "validação da carteira da conta" do
				subject.conta.carteira = '4'
				conta_must_be_msg_error(:carteira, :custom_inclusion, {list: '101, 102, 121'})
				subject.conta.carteira = '102'
				conta_wont_be_msg_error(:carteira, :custom_inclusion, {list: '101, 102, 121'})
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
			must_be_message_error(:base, "#{BrBoleto::Conta::Santander.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
		def conta_wont_be_msg_error(attr_validation, msg_key, options_msg={})
			wont_be_message_error(:base, "#{BrBoleto::Conta::Santander.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
	end

	describe "#default_values" do
		it "local_pagamento deve ter o valor padrão conforme a documentação" do
			BrBoleto::Boleto::Santander.new.local_pagamento.must_equal 'PAGÁVEL PREFERENCIALMENTE NAS AGÊNCIAS DO BANCO SANTANDER'
		end
	end

	describe "#digito_verificador_nosso_numero" do
		it "deve calcular pelo Modulo11FatorDe2a9RestoZero" do
			subject.numero_documento = 111
			BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.expects(:new).with("000000000111").returns("meu_resultado")
			subject.digito_verificador_nosso_numero.must_equal "meu_resultado"
		end
	end

	describe "#nosso_numero" do
		subject { FactoryGirl.build(:boleto_santander, numero_documento: '68315') }

		it "deve retornar o numero do documento com o digito_verificador_nosso_numero" do 
			subject.stubs(:digito_verificador_nosso_numero).returns('9')
			subject.numero_documento = '3646'
			subject.nosso_numero.must_equal "000000003646-9"
		end
	end

	describe "#codigo_de_barras_do_banco" do
		subject do 
			FactoryGirl.build(:boleto_santander, conta: {
					carteira: '121',
					agencia: '78',
					convenio: '668',
				},
				numero_documento: '3646'
			)
		end
		it "deve montar o codigo corretamente com as informações" do
			subject.stubs(:nosso_numero).returns('000000003646-3')

			result = subject.codigo_de_barras_do_banco
			result.size.must_equal 25

			result[0].must_equal      '9'
			result[1..7].must_equal   '0000668'       # Convênio
			result[8..20].must_equal  '0000000036463' # Numero documento
			result[21].must_equal     '0'             # IOF
			result[22..24].must_equal '121'           # Carteira

			subject.codigo_de_barras_do_banco.must_equal '9000066800000000364630121'
		end
	end

	describe "#codigo_de_barras" do
		subject do
			FactoryGirl.build(:boleto_santander) do |santander|
				santander.conta.agencia        = 3069
				santander.conta.codigo_cedente = 828_19 # Para o santander é o código do cliente
				santander.conta.codigo_cedente_dv = '0' # Para o santander é o código do cliente
				santander.conta.carteira       = '121'
				santander.numero_documento     = 100_10
				santander.valor_documento      = 93015.78
				santander.data_vencimento      = Date.parse('2020-02-17')
			end
		end

		it { subject.codigo_de_barras.must_equal '03394816800093015789008281900000001001020121' }
		it { subject.linha_digitavel.must_equal '03399.00821 81900.000001 10010.201217 4 81680009301578' }		

		it "codigo de barras de um boleto de exemplo" do
			subject.conta.agencia           = 3069  
			subject.conta.codigo_cedente    = 82819 # Para o santander é o código do cliente
			subject.conta.codigo_cedente_dv = 0 # Para o santander é o código do cliente
			subject.conta.carteira       = '121'
			subject.numero_documento     = 15_679
			subject.valor_documento      = 408.50
			subject.data_vencimento      = Date.parse('2016-09-01')

			subject.linha_digitavel.must_equal '03399.00821 81900.000001 15679.501211 4 69040000040850'
			subject.codigo_de_barras.must_equal '03394690400000408509008281900000001567950121'
		end
	end
end