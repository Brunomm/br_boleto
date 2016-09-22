require 'test_helper'

describe BrBoleto::Conta::Caixa do
	subject { FactoryGirl.build(:conta_caixa) }

	it "deve herdar de Conta::Base" do
		subject.class.superclass.must_equal BrBoleto::Conta::Base
	end

	context "valores padrões" do
		it "deve setar a carteira da carteira com 14'" do
			subject.class.new.carteira.must_equal '14'
		end		
		it "deve setar a valid_carteira_required com true" do
			subject.class.new.valid_carteira_required.must_equal true
		end
		it "deve setar a valid_carteira_length com 2" do
			subject.class.new.valid_carteira_length.must_equal 2
		end
		
		it "deve setar a valid_carteira_inclusion com %w[14 24]" do
			subject.class.new.valid_carteira_inclusion.must_equal %w[14 24]
		end
		it "deve setar a valid_convenio_maximum com 6" do
			subject.class.new.valid_convenio_maximum.must_equal 6
		end
		it "deve setar a versao_aplicativo com '0'" do
			subject.class.new.versao_aplicativo.must_equal '0000'
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

		it 'versao_aplicativo deve ter no maximo 4 digitos' do
			subject.versao_aplicativo = '12345'
			must_be_message_error(:versao_aplicativo, :custom_length_maximum, {count: 4})
			subject.versao_aplicativo = '1234'
			wont_be_message_error(:versao_aplicativo, :custom_length_maximum, {count: 4})
		end

		context 'Validações padrões da carteira da carteira' do
			subject { BrBoleto::Conta::Caixa.new }
			it { must validate_presence_of(:carteira) }
			it 'Tamanho deve ser de 2' do
				subject.carteira = '132'
				must_be_message_error(:carteira, :custom_length_is, {count: 2})
			end
			it "valores aceitos" do
				subject.carteira = '04'
				must_be_message_error(:carteira, :custom_inclusion, {list: '14, 24'})
			end
		end

		context 'Validações padrões da convenio' do
			subject { BrBoleto::Conta::Caixa.new }
			it { must validate_presence_of(:convenio) }
			it 'Tamanho deve ter o tamanho maximo de 6' do
				subject.convenio = '1234567'
				must_be_message_error(:convenio, :custom_length_maximum, {count: 6})
			end
		end
	end

	it "codigo do banco" do
		subject.codigo_banco.must_equal '104'
	end
	it '#codigo_banco_dv' do
		subject.codigo_banco_dv.must_equal '0'
	end

	describe "#nome_banco" do
		it "valor padrão para o nome_banco" do
			subject.nome_banco.must_equal 'CAIXA ECONOMICA FEDERAL'
		end
		it "deve ser possível mudar o valor do nome do banco" do
			subject.nome_banco = 'MEU'
			subject.nome_banco.must_equal 'MEU'
		end
	end

	it "#versao_layout_arquivo_cnab_240" do
		subject.versao_layout_arquivo_cnab_240.must_equal '050'
	end
	it "#versao_layout_lote_cnab_240" do
		subject.versao_layout_lote_cnab_240.must_equal '030'
	end

	describe '#agencia_dv' do
		it "deve ser personalizavel pelo usuario" do
			subject.agencia_dv = 88
			subject.agencia_dv.must_equal 88
		end
		it "se não passar valor deve calcular automatico" do
			subject.agencia = '1234'
			BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.expects(:new).with('1234').returns(stub(to_s: 5))

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
			BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.expects(:new).with('6688').returns(stub(to_s: 5))

			subject.conta_corrente_dv.must_equal 5
		end
	end

	describe '#convenio_dv' do
		it "deve ser personalizavel pelo usuario" do
			subject.convenio_dv = 88
			subject.convenio_dv.must_equal 88
		end
		it "se não passar valor deve calcular automatico" do
			subject.convenio_dv = nil
			subject.convenio = '6688'
			BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.expects(:new).with('006688').returns(stub(to_s: 5))

			subject.convenio_dv.must_equal 5
		end
	end

	describe '#versao_aplicativo' do
		it "deve ajustar  valor para 4 digitos" do
			subject.versao_aplicativo = 14
			subject.versao_aplicativo.must_equal '0014'
		end
	end

	describe "#carteira_formatada - Conforme o manual da caixa deve retornar RG para carteira com registro e SR para carteira sem registro" do
		it "para a carteira 14 deve retornar RG" do
			subject.carteira = '14'
			subject.carteira_formatada.must_equal 'RG'
		end
		it "para a carteira 24 deve retornar SR" do
			subject.carteira = '24'
			subject.carteira_formatada.must_equal 'SR'
		end
	end

	
end