require 'test_helper'

describe BrBoleto::Boleto::Base do
	subject { FactoryGirl.build(:boleto_base) }

	before do
		subject.stubs(:conta_class).returns(BrBoleto::Conta::Sicoob)
	end

	it "deve herdar de ActiveModelBase" do
		subject.must_be_kind_of BrBoleto::ActiveModelBase
	end

	it "deve ter o module HaveConta incluso" do
		subject.class.included_modules.must_include BrBoleto::HaveConta
	end

	it "deve ter o module HavePagador incluso" do
		subject.class.included_modules.must_include BrBoleto::HavePagador
	end

	describe '#validations' do
		it { must validate_presence_of(:valor_documento) }
		it { must validate_presence_of(:numero_documento) }
		it { must validate_presence_of(:data_vencimento) }

		context "tamanho maximo do numero_documento" do
			it "por padrão deve ter o tamanho máximo de 6 digitos" do
				subject.send(:valid_numero_documento_maximum).must_equal 6
				subject.numero_documento = '1234567'
				must_be_message_error(:numero_documento, :custom_length_maximum, {count: 6})
			end
			it "se mudar o valor do metodo valid_numero_documento_maximum dev validar o tamanho maximo a com o valor setado" do
				subject.stubs(:valid_numero_documento_maximum).returns(4)
				subject.numero_documento = '1234567'
				must_be_message_error(:numero_documento, :custom_length_maximum, {count: 4})
			end
			it "se não tiver valor setado em valid_numero_documento_maximum, não deve validar" do
				subject.stubs(:valid_numero_documento_maximum).returns(nil)
				subject.numero_documento = '1234567'
				wont_be_message_error(:numero_documento)
			end
		end
		context "#valor_documento" do
			it "por padrão deve ter a validação de tamanho maximo com 99999999.99" do
				must validate_numericality_of(:valor_documento).is_less_than_or_equal_to(99999999.99)
			end
			it "deve validar o valor maximo a partir do metodo valid_valor_documento_tamanho_maximo" do
				subject.stubs(:valid_valor_documento_tamanho_maximo).returns(100.00)
				must validate_numericality_of(:valor_documento).is_less_than_or_equal_to(100.0)
			end
			it "não deve validar o valor maximo se o metodo valid_valor_documento_tamanho_maximo estiver nil" do
				subject.stubs(:valid_valor_documento_tamanho_maximo).returns(nil)
				wont validate_numericality_of(:valor_documento)
			end
		end

		it "data_vencimento deve ser uma data" do
			subject.data_vencimento = 13
			must_be_message_error :data_vencimento, :invalid
			subject.data_vencimento = '13'
			must_be_message_error :data_vencimento, :invalid
			subject.data_vencimento = Time.current
			must_be_message_error :data_vencimento, :invalid

			subject.data_vencimento = Date.current
			wont_be_message_error :data_vencimento, :invalid
		end
	end

	describe "#default_values" do
		it 'for codigo_moeda' do
			subject.class.new.codigo_moeda.must_equal '9'
		end
		it 'for especie' do
			subject.class.new.especie.must_equal 'R$'
		end
		it 'for especie_documento' do
			subject.class.new.especie_documento.must_equal 'DM'
		end
		it 'for local_pagamento' do
			subject.class.new.local_pagamento.must_equal 'PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO'
		end
		it 'for data_documento' do
			subject.class.new.data_documento.must_equal Date.current
		end
		it 'for aceite' do
			subject.class.new.aceite.must_equal false
		end
	end

	describe '#numero_documento' do
		it "deve ajustar o tamanho do numero conforme valid_numero_documento_maximum" do
			subject.numero_documento = 354
			subject.numero_documento.must_equal '000354'
			
			subject.stubs(:valid_numero_documento_maximum).returns(4)
			subject.numero_documento.must_equal '0354'
			
			subject.stubs(:valid_numero_documento_maximum).returns(nil)
			subject.numero_documento.must_equal 354
		end
	end

	describe "#parcelas" do
		it "se não tiver parcelas setadas, deve retornar 001" do
			subject.parcelas = ''
			subject.parcelas.must_equal "001"
		end
		it "deve permitir a modificação do número de parcelas" do
			subject.parcelas = 2
			subject.parcelas.must_equal "002"
		end
	end

	describe "to_partial_path" do
		it "must return the path from class name" do
			subject.to_partial_path.must_equal 'br_boleto/base'
		end
	end

	describe "#valor_documento_formatado" do
		context "valor maior que 100" do
			before { subject.stubs(:valor_documento).returns(123.45) }

			it {subject.valor_formatado_para_codigo_de_barras.must_equal '0000012345' }
		end

		context "valor menor que 100" do
			before { subject.stubs(:valor_documento).returns(5.0) }

			it {subject.valor_formatado_para_codigo_de_barras.must_equal '0000000500'}
		end

		context "when have many decimal points" do
			before { subject.stubs(:valor_documento).returns(10.999999) }

			it {subject.valor_formatado_para_codigo_de_barras.must_equal '0000001100' }
		end

		context "when integer" do
			before { subject.stubs(:valor_documento).returns(1_999) }

			it {subject.valor_formatado_para_codigo_de_barras.must_equal '0000199900' }
		end

		context "when period with string" do
			before { subject.stubs(:valor_documento).returns('236.91') }

			it {subject.valor_formatado_para_codigo_de_barras.must_equal '0000023691' }
		end

		context "when period with string with many decimals" do
			before { subject.stubs(:valor_documento).returns('10.9895145') }

			it {subject.valor_formatado_para_codigo_de_barras.must_equal '0000001099' }
		end

		context "when the cents is not broken" do
			before { subject.stubs(:valor_documento).returns(229.5) }

			it {subject.valor_formatado_para_codigo_de_barras.must_equal '0000022950'}
		end
	end

	describe "#aceite_formatado" do
		context "when is true" do
			subject { FactoryGirl.build(:boleto_base, aceite: true) }

			it{ subject.aceite_formatado.must_equal 'S' }
		end

		context "when is false" do
			subject { FactoryGirl.build(:boleto_base, aceite: false) }
			
			it{ subject.aceite_formatado.must_equal 'N' }
		end

		context "when is nil" do
			subject { FactoryGirl.build(:boleto_base, aceite: nil) }
			
			it{ subject.aceite_formatado.must_equal 'N' }
		end
	end

	describe '#codigo_de_barras' do
		it 'deve montar o código de barras com o codigo_de_barras_padrao e codigo_de_barras_do_banco' do
			subject.expects(:codigo_de_barras_padrao).returns(''.rjust(18, '1'))
			subject.expects(:codigo_de_barras_do_banco).returns(''.rjust(25, '3'))
			subject.expects(:digito_codigo_de_barras).returns('2')

			subject.codigo_de_barras.must_equal '1111211111111111111'+''.ljust(25, '3')
		end
	end

	describe '#codigo_de_barras_padrao' do
		it "deve montar a parte do codigo de barras padrão para todos os bancos" do
			subject.data_vencimento = Date.parse('21/02/2025') # dia 21/02/2025 vai parar de funcionar
			subject.codigo_moeda    = '8'
			subject.valor_documento   = 5_123.05
			subject.conta.expects(:codigo_banco).returns('554')
			
			resul = subject.codigo_de_barras_padrao
			resul.size.must_equal 18
			resul[0..2].must_equal '554'  # Código do banco
			resul[ 3  ].must_equal '8'    # Código da moeda
			resul[4..7].must_equal '9999' # Fator de vencimento
			resul[8..17].must_equal '0000512305' # Valor do documento			
		end
	end

	describe '#digito_codigo_de_barras' do
		it "deve calcular o digito pelo Modulo11FatorDe2a9 com os valores de codigo_de_barras_padrao e codigo_de_barras_do_banco" do
			subject.expects(:codigo_de_barras_padrao).returns('123456')
			subject.expects(:codigo_de_barras_do_banco).returns('789012')
			BrBoleto::Calculos::Modulo11FatorDe2a9.expects(:new).with('123456789012').returns(7)

			subject.digito_codigo_de_barras.must_equal 7
		end
	end

	describe '#linha_digitavel' do
		it "deve gerar a linha_digitavel a partir do calculo LinhaDigitavel passando o codigo de barras" do
			subject.expects(:codigo_de_barras).returns('CODIGOBARRAS')

			BrBoleto::Calculos::LinhaDigitavel.expects(:new).with('CODIGOBARRAS').returns('LinhaDigitavel')

			subject.linha_digitavel.must_equal 'LinhaDigitavel'
		end
	end

	it "#nosso_numero" do
		assert_raises NotImplementedError do
			subject.nosso_numero
		end
	end

	it "#codigo_de_barras_do_banco" do
		assert_raises NotImplementedError do
			subject.codigo_de_barras_do_banco
		end
	end

	describe '#nosso_numero_retorno' do
		it "deve retornar os números e letras encontrados no nosso_numero" do
			subject.expects(:nosso_numero).returns(' 01/200000000365-X')
			subject.nosso_numero_retorno.must_equal '01200000000365X'
		end
	end
end