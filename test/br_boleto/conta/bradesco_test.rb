require 'test_helper'

describe BrBoleto::Conta::Bradesco do
	subject { FactoryGirl.build(:conta_bradesco) }

	it "deve herdar de Conta::Base" do
		subject.class.superclass.must_equal BrBoleto::Conta::Base
	end
	context "valores padrões" do
		it "deve setar a carteira com '06' " do
			subject.class.new.carteira.must_equal '06'
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
		it "deve setar a valid_conta_corrente_maximum com 7 " do
			subject.class.new.valid_conta_corrente_maximum.must_equal 7
		end
		it "deve setar a valid_codigo_cedente_maximum com 7 " do
			subject.class.new.valid_codigo_cedente_maximum.must_equal 7
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
			subject { BrBoleto::Conta::Bradesco.new }
			it { must validate_presence_of(:carteira) }
			it 'Tamanho deve ser de 2' do
				subject.carteira = '132'
				must_be_message_error(:carteira, :custom_length_is, {count: 2})
			end
			it "valores aceitos" do
				subject.carteira = '04'
				must_be_message_error(:carteira, :custom_inclusion, {list: '06, 09, 19, 21, 22'})
			end
		end
		context 'Validações padrões da conta_corrente' do
			subject { BrBoleto::Conta::Bradesco.new }
			it { must validate_presence_of(:conta_corrente) }
			it 'Tamanho deve ter o tamanho maximo de 7' do
				subject.conta_corrente = '12345678'
				must_be_message_error(:conta_corrente, :custom_length_maximum, {count: 7})
			end
		end
		context 'Validações padrões da codigo_cedente' do
			subject { BrBoleto::Conta::Bradesco.new }
			it 'Tamanho deve ter o tamanho maximo de 7' do
				subject.codigo_cedente = '12345678'
				must_be_message_error(:convenio, :custom_length_maximum, {count: 7})
			end
		end
	end

	it "codigo do banco" do
		subject.codigo_banco.must_equal '237'
	end
	it '#codigo_banco_dv' do
		subject.codigo_banco_dv.must_equal '2'
	end

	describe "#nome_banco" do
		it "valor padrão para o nome_banco" do
			subject.nome_banco.must_equal 'BRADESCO'
		end
		it "deve ser possível mudar o valor do nome do banco" do
			subject.nome_banco = 'MEU'
			subject.nome_banco.must_equal 'MEU'
		end
	end

	it "#versao_layout_arquivo_cnab_240" do
		subject.versao_layout_arquivo_cnab_240.must_equal '084'
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
			BrBoleto::Calculos::Modulo11FatorDe2a7.expects(:new).with('0006688').returns(stub(to_s: 5))

			subject.conta_corrente_dv.must_equal 5
		end
	end

	describe "#get_especie_titulo" do
		context "CÓDIGOS para o cnab 400 do Bradesco" do
			it { subject.get_especie_titulo('07', 400).must_equal '10' } # Letra de Câmbio
			it { subject.get_especie_titulo('17', 400).must_equal '05' } # Recibo
			it { subject.get_especie_titulo('19', 400).must_equal '11' } # Nota de Débito
			it { subject.get_especie_titulo('32', 400).must_equal '30' } # Boleto de Proposta
		end
	end

	describe "#get_codigo_movimento_remessa" do
		context "CÓDIGOS para o cnab 400 do Bradesco" do
			it { subject.get_codigo_movimento_remessa('10', 400).must_equal '18' } # Sustar protesto e baixar Título
			it { subject.get_codigo_movimento_remessa('11', 400).must_equal '19' } # Sustar protesto e manter em carteira
			it { subject.get_codigo_movimento_remessa('31', 400).must_equal '22' } # Transferência Cessão Crédito
			it { subject.get_codigo_movimento_remessa('33', 400).must_equal '68' } # Acerto nos dados do rateio de Crédito
			it { subject.get_codigo_movimento_remessa('43', 400).must_equal '23' } # Transferência entre Carteiras
			it { subject.get_codigo_movimento_remessa('45', 400).must_equal '45' } # Pedido de Negativação
			it { subject.get_codigo_movimento_remessa('46', 400).must_equal '46' } # Excluir Negativação com baixa
			it { subject.get_codigo_movimento_remessa('47', 400).must_equal '47' } # Excluir negativação e manter pendente
			it { subject.get_codigo_movimento_remessa('34', 400).must_equal '69' } # Cancelamento do rateio de crédito.
		end
	end
end