# encoding: utf-8
require 'test_helper'

describe BrBoleto::Boleto::Itau do
	subject { FactoryBot.build(:boleto_itau, conta: conta) }
	let(:conta) { FactoryBot.build(:conta_itau) }

	context "on validations" do
		it { must validate_length_of(:numero_documento).is_at_most(8).with_message(:custom_length_maximum) }

		context '#conta.carteira' do
			it { subject.valid_carteira_inclusion.must_equal ['104', '105', '107', '108', '109', '112', '113', '116', '117', '119', '121', '122', '126', '131', '134', '135', '136', '142', '143', '146', '147', '150', '168', '169', '174', '175', '180', '191', '196', '198'] }
			it "validação da carteira da conta" do
				subject.conta.carteira = '4'
				conta_must_be_msg_error(:carteira, :custom_inclusion, {list: '104, 105, 107, 108, 109, 112, 113, 116, 117, 119, 121, 122, 126, 131, 134, 135, 136, 142, 143, 146, 147, 150, 168, 169, 174, 175, 180, 191, 196, 198'})
				subject.conta.carteira = '109'
				conta_wont_be_msg_error(:carteira, :custom_inclusion, {list: '104, 105, 107, 108, 109, 112, 113, 116, 117, 119, 121, 122, 126, 131, 134, 135, 136, 142, 143, 146, 147, 150, 168, 169, 174, 175, 180, 191, 196, 198'})
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
			must_be_message_error(:base, "#{BrBoleto::Conta::Itau.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
		def conta_wont_be_msg_error(attr_validation, msg_key, options_msg={})
			wont_be_message_error(:base, "#{BrBoleto::Conta::Itau.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
	end

	describe "#default_values" do
		it "local_pagamento deve ter o valor padrão conforme a documentação" do
			BrBoleto::Boleto::Itau.new.local_pagamento.must_equal 'PAGÁVEL EM QUALQUER BANCO OU CORRESPONDENTE ATÉ O VENCIMENTO.'
		end
	end

	describe "#digito_verificador_nosso_numero" do
		it "Se for uma carteiras_especiais_nosso_numero_dv (126 131 146 150 168) deve calcular pelo Modulo10 com o carteira e numero do documento" do
			subject.conta.carteira = 126
			subject.numero_documento = 111
			BrBoleto::Calculos::Modulo10.expects(:new).with("12600000111").returns("meu_resultado")
			subject.digito_verificador_nosso_numero.must_equal "meu_resultado"
		end
		it "Demais carteiras deve calcular pelo Modulo10 com o agencia, conta_corrente, carteira e numero do documento" do
			subject.conta.agencia = 1234
			subject.conta.conta_corrente = 12345
			subject.conta.carteira = 109
			subject.numero_documento = 111
			BrBoleto::Calculos::Modulo10.expects(:new).with("12341234510900000111").returns("meu_resultado")
			subject.digito_verificador_nosso_numero.must_equal "meu_resultado"
		end
	end

	describe "#nosso_numero" do
		subject { FactoryBot.build(:boleto_itau, numero_documento: '68315') }

		it "deve retornar o numero do documento com o digito_verificador_nosso_numero" do
			subject.stubs(:digito_verificador_nosso_numero).returns('9')
			subject.numero_documento = '3646'
			subject.nosso_numero.must_equal "109/00003646-9"
		end
	end

	describe '#nosso_numero_retorno' do
		it "deve pegar o valor do nosso_numero desconsiderando a carteira" do
			subject.expects(:nosso_numero).returns('109/00003646-9')
			subject.nosso_numero_retorno.must_equal '000036469'
		end
	end

	describe "#codigo_de_barras_do_banco (com as carteiras especiais de cobrança 107, 122, 142, 143, 196 e 198)" do
		subject do
			FactoryBot.build(:boleto_itau, conta: {
					carteira: '122',
					agencia: '78',
					conta_corrente: '668',
					convenio: '12345',
				},
				numero_documento: '395'
			)
		end
		it "deve montar o codigo corretamente com as informações" do
			subject.stubs(:nosso_numero).returns('122/00000395-9')
			result = subject.codigo_de_barras_do_banco
			result.size.must_equal 25

			result[0..2].must_equal '122'       # Carteira
			result[3..10].must_equal '00000395' # Numero documento
			result[11..17].must_equal '0000039' # Seu número
			result[18..22].must_equal '12345'   # Código cedente
			result[23].must_equal '6'           # DV codigo de barras
			result[24].must_equal '0'           # Zero

			subject.codigo_de_barras_do_banco.must_equal '1220000039500000391234560'
		end
	end

	describe "#codigo_de_barras_do_banco (para as demais carteiras)" do
		subject do
			FactoryBot.build(:boleto_itau, conta: {
					carteira: '109',
					agencia: '78',
					conta_corrente: '668',
					conta_corrente_dv: '5',
				},
				numero_documento: '395'
			)
		end
		it "deve montar o codigo corretamente com as informações" do
			subject.stubs(:nosso_numero).returns('109/00000395-2')
			result = subject.codigo_de_barras_do_banco
			result.size.must_equal 25

			result[0..2].must_equal '109'       # Carteira
			result[3..10].must_equal '00000395' # Numero documento
			result[11].must_equal '2'           # Nosso numero DV
			result[12..15].must_equal '0078'    # Agencia
			result[16..20].must_equal '00668'   # Conta Corrente
			result[21].must_equal '5'           # Conta Corrente DV
			result[22..24].must_equal '000'     # Zeros

			subject.codigo_de_barras_do_banco.must_equal '1090000039520078006685000'
		end
	end

	describe "#codigo_de_barras" do
		subject do
			FactoryBot.build(:boleto_itau) do |itau|
				itau.conta.agencia        = 3069
				itau.conta.codigo_cedente = 828_19 # Para o itau é o código do cliente
				itau.conta.codigo_cedente_dv = '0' # Para o itau é o código do cliente
				itau.conta.carteira       = '106'
				itau.numero_documento     = 100_10
				itau.valor_documento      = 93015.78
				itau.data_vencimento      = Date.parse('2020-02-17')
			end
		end

		it { subject.codigo_de_barras.must_equal '34199816800093015781060001001043069897558000' }
		it { subject.linha_digitavel.must_equal '34191.06004 01001.043064 98975.580006 9 81680009301578' }

		it "codigo de barras de um boleto de exemplo" do
			subject.conta.agencia           = 3069
			subject.conta.codigo_cedente    = 82819 # Para o itau é o código do cliente
			subject.conta.codigo_cedente_dv = 0     # Para o itau é o código do cliente
			subject.conta.carteira       = '175'
			subject.numero_documento     = 15_679
			subject.valor_documento      = 408.50
			subject.data_vencimento      = Date.parse('2016-09-01')

			subject.linha_digitavel.must_equal '34191.75009 01567.963069 98975.580006 2 69040000040850'
			subject.codigo_de_barras.must_equal '34192690400000408501750001567963069897558000'
		end
	end
end
