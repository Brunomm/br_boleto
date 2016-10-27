# encoding: utf-8
require 'test_helper'

describe BrBoleto::Boleto::Cecred do
	subject { FactoryGirl.build(:boleto_cecred, conta: conta) }
	let(:conta) { FactoryGirl.build(:conta_cecred) } 
	
	context "on validations" do
		it { must validate_length_of(:numero_documento).is_at_most(9).with_message(:custom_length_maximum) }
		
		context '#conta.carteira' do
			it { subject.valid_carteira_inclusion.must_equal ['1'] }
			it "validação da carteira da conta" do
				subject.conta.carteira = '6'
				conta_must_be_msg_error(:carteira, :custom_inclusion, {list: '1'})
				subject.conta.carteira = '1'
				conta_wont_be_msg_error(:carteira, :custom_inclusion, {list: '1'})
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
		end

		private

		def conta_must_be_msg_error(attr_validation, msg_key, options_msg={})
			must_be_message_error(:base, "#{BrBoleto::Conta::Cecred.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
		def conta_wont_be_msg_error(attr_validation, msg_key, options_msg={})
			wont_be_message_error(:base, "#{BrBoleto::Conta::Cecred.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
	end

	describe "#default_values" do
		it "local_pagamento deve ter o valor padrão conforme a documentação" do
			BrBoleto::Boleto::Cecred.new.local_pagamento.must_equal 'PAGAVEL PREFERENCIALMENTE NAS COOPERATIVAS DO SISTEMA CECRED.'
		end
	end

	describe "#nosso_numero" do
		subject { FactoryGirl.build(:boleto_cecred, numero_documento: '68315') }

		it "deve retornar a conta corrente com DV e o numero do documento" do 
			subject.numero_documento = '3646'
			subject.conta.conta_corrente = '1234567'
			subject.conta.conta_corrente_dv = '9'
			subject.nosso_numero.must_equal "12345679000003646"
		end
	end

	describe "#codigo_de_barras_do_banco" do
		subject do 
			FactoryGirl.build(:boleto_cecred, conta: {
					carteira: '1',
					conta_corrente: '668',
					conta_corrente_dv: '7',
					convenio: '987',
				},
				numero_documento: '395'
			)
		end
		it "deve montar o codigo corretamente com as informações" do
			subject.stubs(:nosso_numero).returns('21/00000003646-9')

			result = subject.codigo_de_barras_do_banco
			result.size.must_equal 25

			result[0..5].must_equal   '000987'    # Convênio
			result[6..13].must_equal  '00006687'  # Conta Corrente com DV
			result[14..22].must_equal '000000395' # Numero documento
			result[23..24].must_equal '01'        # Carteira

			subject.codigo_de_barras_do_banco.must_equal '0009870000668700000039501'
		end
	end

	describe "#codigo_de_barras" do
		subject do
			FactoryGirl.build(:boleto_cecred) do |cecred|
				cecred.conta.agencia        = 3069
				cecred.conta.codigo_cedente = 828_19 # Para o cecred é o código do cliente
				cecred.conta.codigo_cedente_dv = '0' # Para o cecred é o código do cliente
				cecred.conta.carteira       = '06'
				cecred.numero_documento     = 100_10
				cecred.valor_documento      = 93015.78
				cecred.data_vencimento      = Date.parse('2020-02-17')
			end
		end

		it { subject.codigo_de_barras.must_equal '08595816800093015780828198975599800001001006' }
		it { subject.linha_digitavel.must_equal '08590.82810 98975.599808 00010.010064 5 81680009301578' }		

		it "codigo de barras de um boleto de exemplo" do
			subject.conta.agencia           = 3069  
			subject.conta.codigo_cedente    = 82819 # Para o cecred é o código do cliente
			subject.conta.codigo_cedente_dv = 0 # Para o cecred é o código do cliente
			subject.conta.carteira       = '06'
			subject.numero_documento     = 15_679
			subject.valor_documento      = 408.50
			subject.data_vencimento      = Date.parse('2016-09-01')

			subject.linha_digitavel.must_equal '08590.82810 98975.599808 00015.679061 6 69040000040850'
			subject.codigo_de_barras.must_equal '08596690400000408500828198975599800001567906'
		end
	end
end