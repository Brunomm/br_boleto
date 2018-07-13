# encoding: utf-8
require 'test_helper'

describe BrBoleto::Boleto::BancoBrasil do
	subject { FactoryBot.build(:boleto_banco_brasil, conta: conta) }
	let(:conta) { FactoryBot.build(:conta_banco_brasil) }

	context "on validations" do
		# it { must validate_length_of(:numero_documento).is_at_most(11).with_message(:custom_length_maximum) }

		context '#valid_numero_documento_maximum' do
			it "deve setar o tamanho do numero_documento dependendo do tipo de convênio" do
				subject.conta.convenio = '1234'
				must validate_length_of(:numero_documento).is_at_most(7).with_message(:custom_length_maximum)

				subject.conta.convenio = '123456'
				must validate_length_of(:numero_documento).is_at_most(5).with_message(:custom_length_maximum)

				subject.conta.convenio = '1234567'
				must validate_length_of(:numero_documento).is_at_most(10).with_message(:custom_length_maximum)

				subject.conta.convenio = '12345678'
				must validate_length_of(:numero_documento).is_at_most(9).with_message(:custom_length_maximum)
			end
		end

		context '#conta.carteira' do
			it { subject.valid_carteira_inclusion.must_equal ['11','12','15','16','17', '18', '31', '51'] }
			it "validação da carteira da conta" do
				subject.conta.carteira = '4'
				conta_must_be_msg_error(:carteira, :custom_inclusion, {list: '11, 12, 15, 16, 17, 18, 31, 51'})
				subject.conta.carteira = '12'
				conta_wont_be_msg_error(:carteira, :custom_inclusion, {list: '11, 12, 15, 16, 17, 18, 31, 51'})
			end
		end

		# describe '#conta.convenio / codigo_cedente' do
		# 	it { subject.valid_convenio_maximum.must_equal 7 }
		# 	it { subject.valid_convenio_required.must_equal true }

		# 	it "validação obrigatoriedade do codigo_cedente da conta" do
		# 		subject.conta.codigo_cedente = ''
		# 		conta_must_be_msg_error(:convenio, :blank)
		# 		subject.conta.codigo_cedente = '123456'
		# 		conta_wont_be_msg_error(:convenio, :blank)
		# 	end
		# end

		private

		def conta_must_be_msg_error(attr_validation, msg_key, options_msg={})
			must_be_message_error(:base, "#{BrBoleto::Conta::BancoBrasil.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
		def conta_wont_be_msg_error(attr_validation, msg_key, options_msg={})
			wont_be_message_error(:base, "#{BrBoleto::Conta::BancoBrasil.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
	end

	describe "#default_values" do
		it "local_pagamento deve ter o valor padrão conforme a documentação" do
			BrBoleto::Boleto::BancoBrasil.new.local_pagamento.must_equal 'Pagável em qualquer banco até o vencimento. Após, atualize o boleto no site bb.com.br'
		end
	end

	describe "#digito_verificador_nosso_numero" do
		it "deve calcular pelo Modulo11FatorDe9a2RestoX" do
			subject.conta.convenio = 1234
			subject.numero_documento = 111
			BrBoleto::Calculos::Modulo11FatorDe9a2RestoX.expects(:new).with("12340000111").returns("meu_resultado")
			subject.digito_verificador_nosso_numero.must_equal "meu_resultado"
		end
	end

	describe "#nosso_numero" do
		subject { FactoryBot.build(:boleto_banco_brasil, numero_documento: '68315') }

		it "deve retornar o numero do documento com o digito_verificador_nosso_numero com convenio de 4 ou 6 digitos" do
			subject.stubs(:digito_verificador_nosso_numero).returns('9')
			subject.conta.convenio = 1234
			subject.numero_documento = '3646'
			subject.nosso_numero.must_equal "12340003646-9"

			subject.conta.convenio = 123456
			subject.nosso_numero.must_equal "12345603646-9"
		end

		it "deve retornar o numero do documento sem o digito_verificador_nosso_numero com convenio de 7 ou 8 digitos" do
			subject.conta.convenio = 1234567
			subject.numero_documento = '3646'
			subject.nosso_numero.must_equal "12345670000003646"

			subject.conta.convenio = 12345678
			subject.nosso_numero.must_equal "12345678000003646"
		end
	end

	describe "#codigo_de_barras_do_banco" do
		subject do
			FactoryBot.build(:boleto_banco_brasil, conta: {
					carteira: '16',
					agencia: '78',
					conta_corrente: '6685',
				},
				numero_documento: '395'
			)
		end
		it "deve montar o codigo corretamente com as informações (convenio 4 digitos)" do
			subject.conta.convenio = 1234
			subject.stubs(:nosso_numero).returns('12340000395-9')

			result = subject.codigo_de_barras_do_banco
			result.size.must_equal 25

			result[0..3].must_equal   '1234'       # Convênio
			result[4..10].must_equal  '0000395'    # Numero documento
			result[11..14].must_equal '0078'       # Agencia
			result[15..22].must_equal '00006685'   # Conta Corrente
			result[23..24].must_equal '16'         # Carteira

			subject.codigo_de_barras_do_banco.must_equal '1234000039500780000668516'
		end

		it "deve montar o codigo corretamente com as informações (convenio 6 digitos)" do
			subject.conta.convenio = 123456
			subject.stubs(:nosso_numero).returns('12345600395-9')

			result = subject.codigo_de_barras_do_banco
			result.size.must_equal 25

			result[0..5].must_equal   '123456'     # Convênio
			result[6..10].must_equal  '00395'      # Numero documento
			result[11..14].must_equal '0078'       # Agencia
			result[15..22].must_equal '00006685'   # Conta Corrente
			result[23..24].must_equal '16'         # Carteira

			subject.codigo_de_barras_do_banco.must_equal '1234560039500780000668516'
		end
		it "deve montar o codigo corretamente com as informações (convenio 7 digitos)" do
			subject.conta.convenio = 1234567
			subject.stubs(:nosso_numero).returns('12345670000000395')

			result = subject.codigo_de_barras_do_banco
			result.size.must_equal 25

			result[0..5].must_equal   '000000'     # Zeros
			result[6..12].must_equal  '1234567'    # Convênio
			result[13..22].must_equal '0000000395' # Numero documento
			result[23..24].must_equal '16'         # Carteira

			subject.codigo_de_barras_do_banco.must_equal '0000001234567000000039516'
		end
	end

	describe "#codigo_de_barras" do
		subject do
			FactoryBot.build(:boleto_banco_brasil) do |banco_brasil|
				banco_brasil.conta.agencia        = 3069
				banco_brasil.conta.codigo_cedente = 1234 # Para o banco do Brasil é o código do cliente
				banco_brasil.conta.codigo_cedente_dv = '0' # Para o banco do Brasil é o código do cliente
				banco_brasil.conta.carteira       = '12'
				banco_brasil.numero_documento     = 100_10
				banco_brasil.valor_documento      = 93015.78
				banco_brasil.data_vencimento      = Date.parse('2020-02-17')
			end
		end

		it { subject.codigo_de_barras.must_equal '00193816800093015781234001001030690008975512' }
		it { subject.linha_digitavel.must_equal '00191.23405 01001.030699 00089.755128 3 81680009301578' }

		it "codigo de barras de um boleto de exemplo" do
			subject.conta.agencia           = 3069
			subject.conta.codigo_cedente    = 5828196 # Para o banco do Brasil é o código do cliente
			subject.conta.codigo_cedente_dv = 0       # Para o banco do Brasil é o código do cliente
			subject.conta.carteira       = '12'
			subject.numero_documento     = 15_679
			subject.valor_documento      = 408.50
			subject.data_vencimento      = Date.parse('2016-09-01')

			subject.linha_digitavel.must_equal '00190.00009 05828.196005 00015.679129 7 69040000040850'
			subject.codigo_de_barras.must_equal '00197690400000408500000005828196000001567912'
		end
	end
end
