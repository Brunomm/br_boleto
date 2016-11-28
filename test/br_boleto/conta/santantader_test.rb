require 'test_helper'

describe BrBoleto::Conta::Santander do
	subject { FactoryGirl.build(:conta_santander) }

	it "deve herdar de Conta::Base" do
		subject.class.superclass.must_equal BrBoleto::Conta::Base
	end
	context "valores padrões" do
		it "deve setar a carteira com '101' " do
			subject.class.new.carteira.must_equal '101'
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
		it "deve setar a valid_conta_corrente_maximum com 9 " do
			subject.class.new.valid_conta_corrente_maximum.must_equal 9
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
			subject { BrBoleto::Conta::Santander.new }
			it { must validate_presence_of(:carteira) }
			it 'Tamanho deve ser de 3' do
				subject.carteira = '1234'
				must_be_message_error(:carteira, :custom_length_is, {count: 3})
			end
			it "valores aceitos" do
				subject.carteira = '04'
				must_be_message_error(:carteira, :custom_inclusion, {list: '101, 102, 121'})
			end
		end
		context 'Validações padrões da conta_corrente' do
			subject { BrBoleto::Conta::Santander.new }
			it { must validate_presence_of(:conta_corrente) }
			it 'Tamanho deve ter o tamanho maximo de 9' do
				subject.conta_corrente = '1234567890'
				must_be_message_error(:conta_corrente, :custom_length_maximum, {count: 9})
			end
		end
		context 'Validações padrões da codigo_cedente' do
			subject { BrBoleto::Conta::Santander.new }
			it 'Tamanho deve ter o tamanho maximo de 7' do
				subject.codigo_cedente = '12345678'
				must_be_message_error(:convenio, :custom_length_maximum, {count: 7})
			end
		end
	end

	it "codigo do banco" do
		subject.codigo_banco.must_equal '033'
	end
	it '#codigo_banco_dv' do
		subject.codigo_banco_dv.must_equal '7'
	end

	describe "#nome_banco" do
		it "valor padrão para o nome_banco" do
			subject.nome_banco.must_equal 'SANTANDER'
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
			BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.expects(:new).with('000006688').returns(stub(to_s: 5))

			subject.conta_corrente_dv.must_equal 5
		end
	end

	describe "#get_especie_titulo" do
		context "CÓDIGOS para o cnab 240 do Santander" do
			it { subject.get_especie_titulo('02', 240).must_equal '02' } # DM  - DUPLICATA MERCANTIL
			it { subject.get_especie_titulo('04', 240).must_equal '04' } # DS  - DUPLICATA DE SERVICO
			it { subject.get_especie_titulo('07', 240).must_equal '07' } # LC  - LETRA DE CÂMBIO
			it { subject.get_especie_titulo('12', 240).must_equal '12' } # NP  - NOTA PROMISSORIA
			it { subject.get_especie_titulo('13', 240).must_equal '13' } # NR  - NOTA PROMISSORIA RURAL
			it { subject.get_especie_titulo('17', 240).must_equal '17' } # RC  - RECIBO
			it { subject.get_especie_titulo('20', 240).must_equal '20' } # AP  - APOLICE DE SEGURO
			it { subject.get_especie_titulo('01', 240).must_equal '97' } # CH  - CHEQUE
			it { subject.get_especie_titulo('98', 240).must_equal '98' } # NPD - NOTA PROMISSORIA DIRETA
		end
	end

	describe "#get_codigo_movimento_remessa" do
		context "CÓDIGOS para o cnab 240 do Santander" do
			it { subject.get_codigo_movimento_remessa('01', 240).must_equal '01' } # Entrada de título
			it { subject.get_codigo_movimento_remessa('02', 240).must_equal '02' } # Pedido de baixa
			it { subject.get_codigo_movimento_remessa('04', 240).must_equal '04' } # Concessão de abatimento
			it { subject.get_codigo_movimento_remessa('05', 240).must_equal '05' } # Cancelamento de abatimento
			it { subject.get_codigo_movimento_remessa('06', 240).must_equal '06' } # Alteração de vencimento
			it { subject.get_codigo_movimento_remessa('07', 240).must_equal '10' } # Concessão de Desconto
			it { subject.get_codigo_movimento_remessa('08', 240).must_equal '11' } # Cancelamento de desconto
			it { subject.get_codigo_movimento_remessa('09', 240).must_equal '09' } # Pedido de Protesto
			it { subject.get_codigo_movimento_remessa('10', 240).must_equal '18' } # Pedido de Sustação de Protesto
			it { subject.get_codigo_movimento_remessa('21', 240).must_equal '07' } # Alteração da identificação do título na empresa
			it { subject.get_codigo_movimento_remessa('22', 240).must_equal '08' } # Alteração seu número
			it { subject.get_codigo_movimento_remessa('31', 240).must_equal '31' } # Alteração de outros dados
			it { subject.get_codigo_movimento_remessa('41', 240).must_equal '98' } # Não Protestar
		end
	end

	describe "#get_tipo_cobranca" do
		context "CÓDIGOS para o cnab 240 do Santander" do
			it { subject.get_tipo_cobranca('06', 240).must_equal '06' } # Cobrança Caucionada (Rápida com Registro)
		end
	end

	describe "#get_codigo_protesto" do
		context "CÓDIGOS para o Santander" do
			it { subject.get_codigo_protesto('0').must_equal '0' } # Não Protestar
		end
	end

	describe "#get_codigo_moeda_240" do
		context "CÓDIGOS para o Santander" do
			it { subject.get_codigo_moeda('09', 240).must_equal '00' } # Real
		end
	end

end