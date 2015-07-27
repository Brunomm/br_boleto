require 'test_helper'

describe BrBoleto::Core::Boleto do
	subject { FactoryGirl.build(:core_boleto) }

	it { must validate_numericality_of(:valor_documento).is_less_than_or_equal_to(99999999.99) }

	describe "model_name" do
		it "must return BrBoleto::Core::Boleto" do
			BrBoleto::Core::Boleto.model_name.must_equal 'BrBoleto::Core::Boleto'
		end
	end

	describe "human_attribute_name" do
		it "must respond_to internationalization attribute" do
			BrBoleto::Core::Boleto.human_attribute_name(:same_thing).must_equal "Same thing"
		end
	end

	describe "to_partial_path" do
		it "must return the path from class name" do
			subject.to_partial_path.must_equal 'br_boleto/boleto'
		end
	end

	describe "to_model" do
		it "must returns the same object for comparison purposes" do
			subject.to_model.must_equal subject
		end
	end

	context '#initialize' do
		context "when passing a Hash" do
			before do 
				@object = subject.class.new({
					numero_documento: '191075',
					valor_documento:  101.99,
					data_vencimento:  Date.new(2015, 07, 10),
					carteira:         '175',
					agencia:          '0098',
					conta_corrente:   '98701',
					cedente:          'Nome da razao social',
					sacado:           'Teste',
					documento_sacado: '725.275.005-10',
					endereco_sacado:  'Rua teste, 23045',
					instrucoes1:      'Lembrar de algo 1',
					instrucoes2:      'Lembrar de algo 2',
					instrucoes3:      'Lembrar de algo 3',
					instrucoes4:      'Lembrar de algo 4',
					instrucoes5:      'Lembrar de algo 5',
					instrucoes6:      'Lembrar de algo 6',
				})
			end
			it{ @object.numero_documento.must_equal  '191075' }
			it{ @object.valor_documento.must_equal   101.99 }
			it{ @object.data_vencimento.must_equal   Date.new(2015, 07, 10) }
			it{ @object.carteira.must_equal          '175' }
			it{ @object.agencia.must_equal           '0098' }
			it{ @object.conta_corrente.must_equal    '98701' }
			it{ @object.codigo_moeda.must_equal      '9' }
			it{ @object.cedente.must_equal           'Nome da razao social' }
			it{ @object.especie.must_equal           'R$' }
			it{ @object.especie_documento.must_equal 'DM' }
			it{ @object.data_documento.must_equal    Date.today }
			it{ @object.sacado.must_equal            'Teste' }
			it{ @object.documento_sacado.must_equal  '725.275.005-10' }
			it{ @object.endereco_sacado.must_equal   'Rua teste, 23045'}
			it{ @object.local_pagamento.must_equal   'PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO' }
			it{ @object.instrucoes1.must_equal       'Lembrar de algo 1'}
			it{ @object.instrucoes2.must_equal       'Lembrar de algo 2'}
			it{ @object.instrucoes3.must_equal       'Lembrar de algo 3'}
			it{ @object.instrucoes4.must_equal       'Lembrar de algo 4'}
			it{ @object.instrucoes5.must_equal       'Lembrar de algo 5'}
			it{ @object.instrucoes6.must_equal       'Lembrar de algo 6'}
		end

		context "when passing a block" do
			before do
				@object = subject.class.new do |boleto|
					boleto.numero_documento   = '187390'
					boleto.valor_documento    = 1
					boleto.data_vencimento    = Date.new(2012, 10, 10)
					boleto.carteira           = '109'
					boleto.agencia            = '0914'
					boleto.conta_corrente     = '82369'
					boleto.codigo_cedente     = '90182'
					boleto.endereco_cedente   = 'Rua Itapaiuna, 2434'
					boleto.cedente            = 'Nome da razao social'
					boleto.documento_cedente  = '62.526.713/0001-40'
					boleto.sacado             = 'Teste'
					boleto.instrucoes1        = 'Lembrar de algo 1'
					boleto.instrucoes2        = 'Lembrar de algo 2'
					boleto.instrucoes3        = 'Lembrar de algo 3'
					boleto.instrucoes4        = 'Lembrar de algo 4'
					boleto.instrucoes5        = 'Lembrar de algo 5'
					boleto.instrucoes6        = 'Lembrar de algo 6'
				end
			end

			it {@object.numero_documento.must_equal  '187390' }
			it {@object.valor_documento.must_equal   1 }
			it {@object.carteira.must_equal          '109' }
			it {@object.agencia.must_equal           '0914' }
			it {@object.conta_corrente.must_equal    '82369' }
			it {@object.codigo_moeda.must_equal      '9' }
			it {@object.codigo_cedente.must_equal    '90182' }
			it {@object.endereco_cedente.must_equal  'Rua Itapaiuna, 2434' }
			it {@object.cedente.must_equal           'Nome da razao social' }
			it {@object.documento_cedente.must_equal '62.526.713/0001-40' }
			it {@object.sacado.must_equal            'Teste' }
			it {@object.aceite.must_equal            true }
			it {@object.instrucoes1.must_equal       'Lembrar de algo 1' }
			it {@object.instrucoes2.must_equal       'Lembrar de algo 2' }
			it {@object.instrucoes3.must_equal       'Lembrar de algo 3' }
			it {@object.instrucoes4.must_equal       'Lembrar de algo 4' }
			it {@object.instrucoes5.must_equal       'Lembrar de algo 5' }
			it {@object.instrucoes6.must_equal       'Lembrar de algo 6' }
		end
	end

	context "#carteira_formatada" do
		it "returns 'carteira' as default" do
			subject.stubs(:carteira).returns('Foo')
			subject.carteira_formatada.must_equal 'Foo'
		end
	end

	describe "#valor_documento_formatado" do
		context "when period" do
			before { subject.stubs(:valor_documento).returns(123.45) }

			it {subject.valor_formatado_para_codigo_de_barras.must_equal '0000012345' }
		end

		context "when less than ten" do
			before { subject.stubs(:valor_documento).returns(5.0) }

			it {subject.valor_formatado_para_codigo_de_barras.must_equal '0000000500'}
		end

		context "when have many decimal points" do
			before { subject.stubs(:valor_documento).returns(10.999999) }

			it {subject.valor_formatado_para_codigo_de_barras.must_equal '0000001099' }
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
			before { subject.stubs(:valor_documento).returns('10.999999') }

			it {subject.valor_formatado_para_codigo_de_barras.must_equal '0000001099' }
		end

		context "when the cents is not broken" do
			before { subject.stubs(:valor_documento).returns(229.5) }

			it {subject.valor_formatado_para_codigo_de_barras.must_equal '0000022950'}
		end
	end

	describe "#aceite_formatado" do
		context "when is true" do
			subject { FactoryGirl.build(:core_boleto, aceite: true) }

			it{ subject.aceite_formatado.must_equal 'S' }
		end

		context "when is false" do
			subject { FactoryGirl.build(:core_boleto, aceite: false) }
			
			it{ subject.aceite_formatado.must_equal 'N' }
		end

		context "when is nil" do
			subject { FactoryGirl.build(:core_boleto, aceite: nil) }
			
			it{ subject.aceite_formatado.must_equal 'N' }
		end
	end

	it "#codigo_banco" do
		assert_raises NotImplementedError do
			subject.codigo_banco
		end
	end

	it "#digito_codigo_banco" do
		assert_raises NotImplementedError do
			subject.digito_codigo_banco
		end
	end

	it "#agencia_codigo_cedente" do
		assert_raises NotImplementedError do
			subject.agencia_codigo_cedente
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
end