require 'test_helper'

describe BrBoleto::Conta::Itau do
	subject { FactoryGirl.build(:conta_itau) }

	it "deve herdar de Conta::Base" do
		subject.class.superclass.must_equal BrBoleto::Conta::Base
	end
	context "valores padrões" do
		it "deve setar a carteira com '109' " do
			subject.class.new.carteira.must_equal '109'
		end
		it "deve setar a valid_agencia_length com 4 " do
			subject.class.new.valid_agencia_length.must_equal 4
		end
		it "deve setar a valid_carteira_required com true " do
			subject.class.new.valid_carteira_required.must_equal true
		end
		it "deve setar a valid_carteira_length com 3 " do
			subject.class.new.valid_carteira_length.must_equal 3
		end
		it "deve setar a valid_conta_corrente_required com true " do
			subject.class.new.valid_conta_corrente_required.must_equal true
		end
		it "deve setar a valid_conta_corrente_maximum com 5 " do
			subject.class.new.valid_conta_corrente_maximum.must_equal 5
		end
		it "deve setar a valid_codigo_cedente_maximum com 5 " do
			subject.class.new.valid_codigo_cedente_maximum.must_equal 5
		end
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
			subject { BrBoleto::Conta::Itau.new }
			it { must validate_presence_of(:carteira) }
			it 'Tamanho deve ser de 3' do
				subject.carteira = '1345'
				must_be_message_error(:carteira, :custom_length_is, {count: 3})
			end
			it "valores aceitos" do
				subject.carteira = '04'
				must_be_message_error(:carteira, :custom_inclusion, {list: '107, 109, 112, 121, 122, 126, 131, 142, 143, 146, 150, 169, 175, 176, 178, 196, 198'})
			end
		end
		context 'Validações padrões da conta_corrente' do
			subject { BrBoleto::Conta::Itau.new }
			it { must validate_presence_of(:conta_corrente) }
			it 'Tamanho deve ter o tamanho maximo de 5' do
				subject.conta_corrente = '12345678'
				must_be_message_error(:conta_corrente, :custom_length_maximum, {count: 5})
			end
		end
		context 'Validações padrões da codigo_cedente' do
			subject { BrBoleto::Conta::Itau.new }
			it 'Tamanho deve ter o tamanho maximo de 5' do
				subject.codigo_cedente = '12345678'
				must_be_message_error(:convenio, :custom_length_maximum, {count: 5})
			end
		end
	end

	it "codigo do banco" do
		subject.codigo_banco.must_equal '341'
	end
	it '#codigo_banco_dv' do
		subject.codigo_banco_dv.must_equal '7'
	end

	describe "#nome_banco" do
		it "valor padrão para o nome_banco" do
			subject.nome_banco.must_equal 'ITAU'
		end
		it "deve ser possível mudar o valor do nome do banco" do
			subject.nome_banco = 'MEU'
			subject.nome_banco.must_equal 'MEU'
		end
	end

	it "#versao_layout_arquivo_cnab_240" do
		subject.versao_layout_arquivo_cnab_240.must_equal '040'
	end
	it "#versao_layout_lote_cnab_240" do
		subject.versao_layout_lote_cnab_240.must_equal '030'
	end

		describe '#conta_corrente_dv' do
		it "deve ser personalizavel pelo usuario" do
			subject.conta_corrente_dv = 88
			subject.conta_corrente_dv.must_equal 88
		end
		it "se não passar valor deve calcular automatico" do
			subject.conta_corrente_dv = nil
			subject.conta_corrente = '12345'			
			subject.agencia_dv = nil
			subject.agencia = '1234'
			BrBoleto::Calculos::Modulo10.expects(:new).with('123412345').returns(stub(to_s: 1))

			subject.conta_corrente_dv.must_equal 1
		end
	end
end