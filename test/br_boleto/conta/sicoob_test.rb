require 'test_helper'

describe BrBoleto::Conta::Sicoob do
	subject { FactoryGirl.build(:conta_sicoob) }

	it "deve herdar de Conta::Base" do
		subject.class.superclass.must_equal BrBoleto::Conta::Base
	end
	context "valores padrões" do
		it "deve setar a carteira com '1' " do
			subject.class.new.carteira.must_equal '1'
		end
		it "deve setar a modalidade com '01' " do
			subject.class.new.modalidade.must_equal '01'
		end
		it "deve setar a valid_modalidade_required com true " do
			subject.class.new.valid_modalidade_required.must_equal true
		end
		it "deve setar a valid_modalidade_length com 2 " do
			subject.class.new.valid_modalidade_length.must_equal 2
		end
		it "deve setar a valid_agencia_length com 4 " do
			subject.class.new.valid_agencia_length.must_equal 4
		end
		it "deve setar a valid_carteira_required com true " do
			subject.class.new.valid_carteira_required.must_equal true
		end
		it "deve setar a valid_carteira_length com 1 " do
			subject.class.new.valid_carteira_length.must_equal 1
		end
		it "deve setar a valid_conta_corrente_required com true " do
			subject.class.new.valid_conta_corrente_required.must_equal true
		end
		it "deve setar a valid_conta_corrente_maximum com 8 " do
			subject.class.new.valid_conta_corrente_maximum.must_equal 8
		end
		it "deve setar a valid_codigo_cedente_maximum com 6 " do
			subject.class.new.valid_codigo_cedente_maximum.must_equal 6
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
		
		context 'Validações padrões da modalidade' do
			subject { BrBoleto::Conta::Sicoob.new }
			it { must validate_presence_of(:modalidade) }
			it 'Tamanho deve ser de 2' do
				subject.modalidade = '1'
				must_be_message_error(:modalidade, :custom_length_is, {count: 2})
			end
			it "valores aceitos" do
				subject.modalidade = '04'
				must_be_message_error(:modalidade, :custom_inclusion, {list: '01, 02, 03'})
			end
		end
		context 'Validações padrões da carteira' do
			subject { BrBoleto::Conta::Sicoob.new }
			it { must validate_presence_of(:carteira) }
			it 'Tamanho deve ser de 1' do
				subject.carteira = '132'
				must_be_message_error(:carteira, :custom_length_is, {count: 1})
			end
			it "valores aceitos" do
				subject.carteira = '04'
				must_be_message_error(:carteira, :custom_inclusion, {list: '1, 3'})
			end
		end
		context 'Validações padrões da conta_corrente' do
			subject { BrBoleto::Conta::Sicoob.new }
			it { must validate_presence_of(:conta_corrente) }
			it 'Tamanho deve ter o tamanho maximo de 8' do
				subject.conta_corrente = '123456789'
				must_be_message_error(:conta_corrente, :custom_length_maximum, {count: 8})
			end
		end
		context 'Validações padrões da codigo_cedente' do
			subject { BrBoleto::Conta::Sicoob.new }
			it 'Tamanho deve ter o tamanho maximo de 6' do
				subject.codigo_cedente = '1234567'
				must_be_message_error(:convenio, :custom_length_maximum, {count: 6})
			end
		end
	end

	it "codigo do banco" do
		subject.codigo_banco.must_equal '756'
	end
	it '#codigo_banco_dv' do
		subject.codigo_banco_dv.must_equal '0'
	end

	describe "#nome_banco" do
		it "valor padrão para o nome_banco" do
			subject.nome_banco.must_equal 'SICOOB'
		end
		it "deve ser possível mudar o valor do nome do banco" do
			subject.nome_banco = 'MEU'
			subject.nome_banco.must_equal 'MEU'
		end
	end

	it "#versao_layout_arquivo_cnab_240" do
		subject.versao_layout_arquivo_cnab_240.must_equal '081'
	end
	it "#versao_layout_lote_cnab_240" do
		subject.versao_layout_lote_cnab_240.must_equal '040'
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
			BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.expects(:new).with('00006688').returns(stub(to_s: 5))

			subject.conta_corrente_dv.must_equal 5
		end
	end

	describe "#get_codigo_movimento_remessa" do
		context "CÓDIGOS para o cnab 400 do SICOOB" do
			it { subject.get_codigo_movimento_remessa('23', 400).must_equal '12' } # Alteração de Pagador
			it { subject.get_codigo_movimento_remessa('46', 400).must_equal '34' } # Baixa - Pagamento Direto ao Beneficiário
		end
	end
	describe '#get_codigo_juros' do 
		it { subject.get_codigo_juros('1').must_equal '1' }
		it { subject.get_codigo_juros('2').must_equal '2' }
		it "para o siccob o código que representa sem juros deve ser 0(zero)" do
			subject.get_codigo_juros('3').must_equal '0'
		end
		it "se passar o código '0' para os juros deve retornar 0" do
			subject.get_codigo_juros('0').must_equal '0'
		end
	end
	describe '#get_codigo_multa' do 
		it { subject.get_codigo_multa('1').must_equal '1' }
		it { subject.get_codigo_multa('2').must_equal '2' }
		it "para o siccob o código que representa sem multa deve ser 0(zero)" do
			subject.get_codigo_multa('3').must_equal '0'
		end
		it "se passar o código '0' para os multa deve retornar 0" do
			subject.get_codigo_multa('0').must_equal '0'
		end
	end
end