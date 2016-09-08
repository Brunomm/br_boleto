# encoding: utf-8
require 'test_helper'

describe BrBoleto::Boleto::Sicoob do
	subject { FactoryGirl.build(:boleto_sicoob, conta: conta) }
	let(:conta) { FactoryGirl.build(:conta_sicoob) } 
	
	context "on validations" do
		it { must validate_length_of(:numero_documento).is_at_most(7).with_message(:custom_length_maximum) }
		context '#conta.modalidade' do
			it { subject.valid_modalidade_inclusion.must_equal ['01','02','03'] }
			it "validação da modalidade da conta" do
				subject.conta.modalidade = '04'
				conta_must_be_msg_error(:modalidade, :custom_inclusion, {list: '01, 02, 03'})
				subject.conta.modalidade = '01'
				conta_wont_be_msg_error(:modalidade, :custom_inclusion, {list: '01, 02, 03'})
			end
		end

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
		it "local_pagamento deve ter o valor padrão conforme a documentação" do
			BrBoleto::Boleto::Sicoob.new.local_pagamento.must_equal 'PREFERENCIALMENTE COOPERATIVAS DA REDE SICOOB'
		end
	end

	describe "#digito_verificador_nosso_numero" do
		it "deve calcular pelo Modulo11Fator3197" do
			subject.conta.agencia = 1
			subject.conta.codigo_cedente = 33
			subject.conta.codigo_cedente_dv = 4
			subject.numero_documento = 111
			BrBoleto::Calculos::Modulo11Fator3197.expects(:new).with("000100000003340000111").returns("meu_resultado")
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
			FactoryGirl.build(:boleto_sicoob, conta: {
					carteira: '1',
					agencia: '78',
					codigo_cedente: '668',
					codigo_cedente_dv: '3',
					modalidade: '02'
				},
				parcelas: '3'
			)
		end
		it "deve montar o codigo corretamente com as informações" do
			subject.stubs(:nosso_numero).returns('0234567-8')

			result = subject.codigo_de_barras_do_banco
			result.size.must_equal 25


			result[0].must_equal '1' # Carteira
			result[1..4].must_equal '0078' # Agencia
			result[5..6].must_equal '02' # modalidade
			result[7..13].must_equal '0006683' # codigo cedente
			result[14..21].must_equal '02345678' # Nosso numero
			result[22..24].must_equal '003' # Parcela
		end
	end

	describe "#codigo_de_barras" do
		subject do
			FactoryGirl.build(:boleto_sicoob) do |sicoob|
				sicoob.conta.agencia        = 3069
				sicoob.conta.codigo_cedente = 828_19 # Para o sicoob é o código do cliente
				sicoob.conta.codigo_cedente_dv = '0' # Para o sicoob é o código do cliente
				sicoob.conta.carteira       = '1'
				sicoob.conta.modalidade     = '01'
				sicoob.numero_documento     = 100_10
				sicoob.valor_documento      = 93015.78
				sicoob.data_vencimento      = Date.parse('2020-02-17')
			end
		end

		it { subject.codigo_de_barras.must_equal '75699816800093015781306901082819000100107001' }
		it { subject.linha_digitavel.must_equal '75691.30698 01082.819002 01001.070018 9 81680009301578' }		

		it "codigo de barras de um boleto de exemplo" do
			subject.conta.agencia           = 3069  
			subject.conta.codigo_cedente    = 82819 # Para o sicoob é o código do cliente
			subject.conta.codigo_cedente_dv = 0 # Para o sicoob é o código do cliente
			subject.conta.carteira       = '1'
			subject.conta.modalidade     = '01'
			subject.numero_documento     = 15_679
			subject.valor_documento      = 408.50
			subject.data_vencimento      = Date.parse('2016-09-01')

			subject.linha_digitavel.must_equal '75691.30698 01082.819002 01567.900012 4 69040000040850'
			subject.codigo_de_barras.must_equal '75694690400000408501306901082819000156790001'
		end
	end
end