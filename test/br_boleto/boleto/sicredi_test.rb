# encoding: utf-8
require 'test_helper'

describe BrBoleto::Boleto::Sicredi do
	subject { FactoryGirl.build(:boleto_sicredi, conta: conta) }
	let(:conta) { FactoryGirl.build(:conta_sicredi) }

	context "on validations" do
		it { must validate_length_of(:numero_documento).is_at_most(5).with_message(:custom_length_maximum) }

		context '#conta.carteira' do
			it { subject.valid_carteira_inclusion.must_equal ['1','3'] }
			it "validação da carteira da conta" do
				subject.conta.carteira = '4'
				conta_must_be_msg_error(:carteira, :custom_inclusion, {list: '1, 3'})
				subject.conta.carteira = '1'
				conta_wont_be_msg_error(:carteira, :custom_inclusion, {list: '1, 3'})
			end
		end

		describe '#conta.convenio / codigo_cedente' do
			it { subject.valid_convenio_maximum.must_equal 5 }
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
			must_be_message_error(:base, "#{BrBoleto::Conta::Sicredi.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
		def conta_wont_be_msg_error(attr_validation, msg_key, options_msg={})
			wont_be_message_error(:base, "#{BrBoleto::Conta::Sicredi.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
	end

	describe "#default_values" do
		it "local_pagamento deve ter o valor padrão conforme a documentação" do
			BrBoleto::Boleto::Sicredi.new.local_pagamento.must_equal 'PAGÁVEL PREFERENCIALMENTE NAS COOPERATIVAS DE CRÉDITO DO SICREDI'
		end
	end

	describe "#digito_verificador_nosso_numero" do
		it "deve utilizar o Modulo11FatorDe2a9RestoZero para calcular o digito passando a agencia, posto, conta_corrente, ano, byte_id e numero_documento" do
			subject.stubs(:ano).returns('16')
			subject.assign_attributes(conta: {agencia: '4697', posto: '02', conta_corrente: '55825', codigo_cedente: '9886', byte_id: '3'}, numero_documento: '77445')
			BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.expects(:new).with("4697020988616377445").returns('8')

			subject.digito_verificador_nosso_numero.must_equal '8'
		end
	end

	describe "#nosso_numero" do
		subject { FactoryGirl.build(:boleto_sicredi, numero_documento: '68315') }

		it "deve retornar o numero do documento com o digito_verificador_nosso_numero" do
			subject.stubs(:ano).returns('15')
			subject.conta.byte_id    = '7'
			subject.numero_documento = '3646'
			subject.stubs(:digito_verificador_nosso_numero).returns('9')
			subject.nosso_numero.must_equal "15/703646-9"
		end
	end

	describe "#codigo_de_barras_do_banco" do
		subject do
			FactoryGirl.build(:boleto_sicredi, conta: {
					carteira:          '3',
					codigo_carteira:   '1',
					agencia:           '7832',
					codigo_cedente:    '9649',
					conta_corrente:    '668',
					posto:             '22',
				},
				numero_documento:     '395'
			)
		end
		it "deve montar o codigo corretamente com as informações" do
			subject.stubs(:nosso_numero).returns('15/703646-9')
			subject.stubs(:nosso_numero_codigo_de_barras).returns('152003952')

			result = subject.codigo_de_barras_do_banco
			result.size.must_equal 25

			result[0].must_equal '3'               # Carteira
			result[1].must_equal '1'               # Cod. Carteira
			result[2..10].must_equal '152003952'   # Nosso número com o DV
			result[11..14].must_equal '7832'       # Agência
			result[15..16].must_equal '22'         # Posto
			result[17..21].must_equal '09649'      # Cód. Cedente
			result[22].must_equal '1'
			result[23].must_equal '0'
			result[24].must_equal '3'              # DV Campo Livre
			subject.codigo_de_barras_do_banco.must_equal '3115200395278322209649103'
		end
	end

	describe "#codigo_de_barras" do
		subject do
			FactoryGirl.build(:boleto_sicredi) do |sicredi|
				sicredi.conta.agencia           = 3069
				sicredi.conta.posto             = 66
				sicredi.conta.codigo_cedente    = 828_19 # Para o sicredi é o código do cliente
				sicredi.conta.codigo_cedente_dv = '0'    # Para o sicredi é o código do cliente
				sicredi.conta.carteira          = '1'
				sicredi.conta.codigo_carteira   = '1'
				sicredi.numero_documento        = 100_10
				sicredi.valor_documento         = 93015.78
				sicredi.data_vencimento         = Date.parse('2020-02-17')
				sicredi.data_documento          = Date.parse('2016-02-17')
			end
		end

		it { subject.codigo_de_barras.must_equal '74897816800093015781116210010030696682819108' }
		it { subject.linha_digitavel.must_equal '74891.11620 10010.030699 66828.191081 7 81680009301578' }

		it "codigo de barras de um boleto de exemplo" do
			subject.conta.agencia           = 3069
			subject.conta.posto             = 66
			subject.conta.codigo_cedente    = 82819 # Para o sicredi é o código do cliente
			subject.conta.codigo_cedente_dv = 0     # Para o sicredi é o código do cliente
			subject.conta.carteira          = '1'
			subject.conta.codigo_carteira   = '1'
			subject.numero_documento        = 15_679
			subject.valor_documento         = 408.50
			subject.data_vencimento         = Date.parse('2016-09-01')

			subject.linha_digitavel.must_equal '74891.11620 15679.230696 66828.191065 2 69040000040850'
			subject.codigo_de_barras.must_equal '74892690400000408501116215679230696682819106'
		end
	end
end