require 'test_helper'

describe BrBoleto::Conta::BancoBrasil do
	subject { FactoryGirl.build(:conta_banco_brasil) }

	it "deve herdar de Conta::Base" do
		subject.class.superclass.must_equal BrBoleto::Conta::Base
	end
	context "valores padrões" do
		it "deve setar a carteira com '18' " do
			subject.class.new.carteira.must_equal '18'
		end
		it "deve setar a valid_agencia_length com 4 " do
			subject.class.new.valid_agencia_length.must_equal 4
		end
		it "deve setar a valid_carteira_required com true " do
			subject.class.new.valid_carteira_required.must_equal true
		end
		it "deve setar a valid_carteira_length com 2 " do
			subject.class.new.valid_carteira_length.must_equal 2
		end
		it "deve setar a valid_conta_corrente_required com true " do
			subject.class.new.valid_conta_corrente_required.must_equal true
		end
		it "deve setar a valid_conta_corrente_maximum com 8 " do
			subject.class.new.valid_conta_corrente_maximum.must_equal 8
		end
		# it "deve setar a valid_codigo_cedente_maximum com 8 " do
		# 	subject.class.new.valid_codigo_cedente_maximum.must_equal 8
		# end
	end
	describe "Validations" do
		it { must validate_presence_of(:agencia) }
		it { must validate_presence_of(:razao_social) }
		it { must validate_presence_of(:cpf_cnpj) }
		it do
			subject.agencia_dv = 21
			must_be_message_error(:agencia_dv, :custom_length_is, {count: 1})
		end
		context 'Validações padrões da carteira' do
			subject { BrBoleto::Conta::BancoBrasil.new }
			it { must validate_presence_of(:carteira) }
			it 'Tamanho deve ser de 2' do
				subject.carteira = '132'
				must_be_message_error(:carteira, :custom_length_is, {count: 2})
			end
			it "valores aceitos" do
				subject.carteira = '04'
				must_be_message_error(:carteira, :custom_inclusion, {list: '11, 12, 15, 16, 17, 18, 31, 51'})
			end
		end
		context 'Validações padrões da conta_corrente' do
			subject { BrBoleto::Conta::BancoBrasil.new }
			it { must validate_presence_of(:conta_corrente) }
			it 'Tamanho deve ter o tamanho maximo de 8' do
				subject.conta_corrente = '123456789'
				must_be_message_error(:conta_corrente, :custom_length_maximum, {count: 8})
			end
		end
		# context 'Validações padrões da codigo_cedente' do
		# 	subject { BrBoleto::Conta::BancoBrasil.new }
		# 	it 'Tamanho deve ter o tamanho maximo de 8' do
		# 		subject.codigo_cedente = '12345678'
		# 		must_be_message_error(:convenio, :custom_length_maximum, {count: 8})
		# 	end
		# end
	end

	it "codigo do banco" do
		subject.codigo_banco.must_equal '001'
	end
	it '#codigo_banco_dv' do
		subject.codigo_banco_dv.must_equal '9'
	end

	describe "#nome_banco" do
		it "valor padrão para o nome_banco" do
			subject.nome_banco.must_equal 'BANCO DO BRASIL S.A.'
		end
		it "deve ser possível mudar o valor do nome do banco" do
			subject.nome_banco = 'MEU'
			subject.nome_banco.must_equal 'MEU'
		end
	end

	it "#versao_layout_arquivo_cnab_240" do
		subject.versao_layout_arquivo_cnab_240.must_equal '083'
	end
	it "#versao_layout_lote_cnab_240" do
		subject.versao_layout_lote_cnab_240.must_equal '042'
	end

	describe '#agencia_dv' do
		it "deve ser personalizavel pelo usuario" do
			subject.agencia_dv = 88
			subject.agencia_dv.must_equal 88
		end
		it "se não passar valor deve calcular automatico" do
			subject.agencia = '1234'
			BrBoleto::Calculos::Modulo11FatorDe9a2RestoX.expects(:new).with('1234').returns(stub(to_s: 5))

			subject.agencia_dv.must_equal 5
		end
	end

	describe '#conta_corrente_dv' do
		it "deve ser personalizavel pelo usuario" do
			subject.conta_corrente_dv = 88
			subject.conta_corrente_dv.must_equal 88
		end
		it "se não passar valor deve calcular automatico" do
			subject.conta_corrente_dv = nil
			subject.conta_corrente = '6688'
			BrBoleto::Calculos::Modulo11FatorDe9a2RestoX.expects(:new).with('00006688').returns(stub(to_s: 5))

			subject.conta_corrente_dv.must_equal 5
		end
	end

	describe "agencia_codigo_cedente" do
		it "deve retornar agencia e convenio formatados" do
			subject.agencia = 1234
			subject.agencia_dv = 5
			subject.conta_corrente = '12345678'
			subject.conta_corrente_dv = '9'

			subject.agencia_codigo_cedente.must_equal "1234-5 / 12345678-9"
		end
	end

end