# encoding: utf-8
require 'test_helper'

describe BrBoleto::Boleto::Unicred do
	subject { FactoryGirl.build(:boleto_unicred, conta: conta) }
	let(:conta) { FactoryGirl.build(:conta_unicred) }


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

		context "#valid_avalista_required" do
			it { subject.valid_avalista_required.must_equal true }
		end

		private

		def conta_must_be_msg_error(attr_validation, msg_key, options_msg={})
			must_be_message_error(:base, "#{BrBoleto::Conta::Unicred.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
		def conta_wont_be_msg_error(attr_validation, msg_key, options_msg={})
			wont_be_message_error(:base, "#{BrBoleto::Conta::Unicred.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
	end

	describe "#default_values" do
		it "local_pagamento deve ter o valor padrão conforme a documentação" do
			BrBoleto::Boleto::Unicred.new.local_pagamento.must_equal 'PAGÁVEL PREFERENCIALMENTE NA REDE BRADESCO OU NO BRADESCO EXPRESSO'
		end
	end

	describe "#digito_verificador_nosso_numero" do
		it "deve calcular pelo Modulo11Fator3197" do
			# subject.carteira = 09
			subject.numero_documento = 111
			BrBoleto::Calculos::Modulo11FatorDe2a9.expects(:new).with('00000000111').returns("meu_resultado")
			subject.digito_verificador_nosso_numero.must_equal "meu_resultado"
		end
	end

	describe "#nosso_numero" do
		subject { FactoryGirl.build(:boleto_unicred, numero_documento: '68315') }

		it "deve retornar o numero do documento com o digito_verificador_nosso_numero" do
			subject.stubs(:digito_verificador_nosso_numero).returns('9')
			subject.numero_documento = '3646'
			subject.nosso_numero.must_equal "00000003646-9"
		end
	end

	describe "#codigo_de_barras_do_banco" do
		subject do
			FactoryGirl.build(:boleto_unicred, conta: {
					carteira: '09',
					agencia: '78',
					conta_corrente: '668',
				},
				numero_documento: '395'
			)
		end
		it "deve montar o codigo corretamente com as informações" do
			subject.stubs(:nosso_numero).returns('0000003646-9')

			result = subject.codigo_de_barras_do_banco
			result.size.must_equal 25

			result[0..3].must_equal   '0078'        # Agencia
			result[4..13].must_equal  '0000006688'     # Conta Corrente
			result[14..24].must_equal '00000036469' # Numero documento

			subject.codigo_de_barras_do_banco.must_equal '0078000000668800000036469'
		end
	end

	describe "#codigo_de_barras" do
		subject do
			FactoryGirl.build(:boleto_unicred) do |unicred|
				unicred.conta.agencia           = 3069
				unicred.conta.codigo_cedente    = 828_19 # Para o unicred é o código do cliente
				unicred.conta.codigo_cedente_dv = '0'    # Para o unicred é o código do cliente
				unicred.conta.carteira          = '09'
				unicred.numero_documento        = 100_10
				unicred.valor_documento         = 93015.78
				unicred.data_vencimento         = Date.parse('2020-02-17')
			end
		end

		it { subject.codigo_de_barras.must_equal '13691816800093015783069000089755800000010010' }
		it { subject.linha_digitavel.must_equal  '13693.06905 00089.755805 00000.100107 1 81680009301578' }

		it "codigo de barras de um boleto de exemplo" do
			subject.conta.agencia           = 3069
			subject.conta.codigo_cedente    = 82819 # Para o unicred é o código do cliente
			subject.conta.codigo_cedente_dv = 0     # Para o unicred é o código do cliente
			subject.conta.carteira          = '09'
			subject.numero_documento        = 15_679
			subject.valor_documento         = 408.50
			subject.data_vencimento         = Date.parse('2016-09-01')

			subject.linha_digitavel.must_equal  '13693.06905 00089.755805 00000.156794 9 69040000040850'
			subject.codigo_de_barras.must_equal '13699690400000408503069000089755800000015679'
		end
	end
end