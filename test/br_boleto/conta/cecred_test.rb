require 'test_helper'

describe BrBoleto::Conta::Cecred do
	subject { FactoryGirl.build(:conta_cecred) }

	it "deve herdar de Conta::Base" do
		subject.class.superclass.must_equal BrBoleto::Conta::Base
	end
	context "valores padrões" do
		it "deve setar a carteira com '1' " do
			subject.class.new.carteira.must_equal '1'
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
		it "deve setar a valid_conta_corrente_maximum com 7 " do
			subject.class.new.valid_conta_corrente_maximum.must_equal 7
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
		context 'Validações padrões da carteira' do
			subject { BrBoleto::Conta::Cecred.new }
			it { must validate_presence_of(:carteira) }
			it 'Tamanho deve ser de 1' do
				subject.carteira = '132'
				must_be_message_error(:carteira, :custom_length_is, {count: 1})
			end
			it "valores aceitos" do
				subject.carteira = '9'
				must_be_message_error(:carteira, :custom_inclusion, {list: '1'})
			end
		end
		context 'Validações padrões da conta_corrente' do
			subject { BrBoleto::Conta::Cecred.new }
			it { must validate_presence_of(:conta_corrente) }
			it 'Tamanho deve ter o tamanho maximo de 7' do
				subject.conta_corrente = '12345678'
				must_be_message_error(:conta_corrente, :custom_length_maximum, {count: 7})
			end
		end
		context 'Validações padrões da codigo_cedente' do
			subject { BrBoleto::Conta::Cecred.new }
			it 'Tamanho deve ter o tamanho maximo de 6' do
				subject.codigo_cedente = '12345678'
				must_be_message_error(:convenio, :custom_length_maximum, {count: 6})
			end
		end
	end

	it "codigo do banco" do
		subject.codigo_banco.must_equal '085'
	end
	it '#codigo_banco_dv' do
		subject.codigo_banco_dv.must_equal '1'
	end

	describe "#nome_banco" do
		it "valor padrão para o nome_banco" do
			subject.nome_banco.must_equal 'CECRED'
		end
		it "deve ser possível mudar o valor do nome do banco" do
			subject.nome_banco = 'MEU'
			subject.nome_banco.must_equal 'MEU'
		end
	end

	it "#versao_layout_arquivo_cnab_240" do
		subject.versao_layout_arquivo_cnab_240.must_equal '087'
	end
	it "#versao_layout_lote_cnab_240" do
		subject.versao_layout_lote_cnab_240.must_equal '045'
	end

	describe '#agencia_dv' do
		it "deve ser personalizavel pelo usuario" do
			subject.agencia_dv = 88
			subject.agencia_dv.must_equal 88
		end
		it "se não passar valor deve calcular automatico" do
			subject.agencia = '1234'
			BrBoleto::Calculos::Modulo11FatorDe2a9.expects(:new).with('1234').returns(stub(to_s: 5))

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
			BrBoleto::Calculos::Modulo11FatorDe2a9.expects(:new).with('0006688').returns(stub(to_s: 5))

			subject.conta_corrente_dv.must_equal 5
		end
	end

	describe "#get_codigo_movimento_retorno" do
		context "CÓDIGOS para o Cecred" do
			it { subject.get_codigo_movimento_retorno('76', 240).must_equal '76' } # Liquidação de boleto cooperativa emite e expede
			it { subject.get_codigo_movimento_retorno('77', 240).must_equal '77' } # Liquidação de boleto após baixa ou não registrado cooperativa emite e expede
			it { subject.get_codigo_movimento_retorno('91', 240).must_equal '91' } # Título em aberto não enviado ao pagador
			it { subject.get_codigo_movimento_retorno('92', 240).must_equal '92' } # Inconsistência Negativação Serasa
			it { subject.get_codigo_movimento_retorno('93', 240).must_equal '93' } # Inclusão Negativação via Serasa
			it { subject.get_codigo_movimento_retorno('94', 240).must_equal '94' } # Exclusão Negativação Serasa
		end
	end

	describe "#get_codigo_motivo_ocorrencia" do
		context "CÓDIGOS para o Cecred" do
			it { subject.get_codigo_motivo_ocorrencia('P1', '91').must_equal 'A114' } # Enviado Cooperativa Emite e Expede
			it { subject.get_codigo_motivo_ocorrencia('S1', '93').must_equal 'D02' }  # Sempre que a solicitação (inclusão ou exclusão) for efetuada com sucesso
			it { subject.get_codigo_motivo_ocorrencia('S2', '94').must_equal 'D03' }  # Sempre que a solicitação for integrada na Serasa com sucesso
			it { subject.get_codigo_motivo_ocorrencia('S3', '94').must_equal 'D04' }  # Sempre que vier retorno da Serasa por decurso de prazo
			it { subject.get_codigo_motivo_ocorrencia('S4', '93').must_equal 'D05' }  # Sempre que o documento for integrado na Serasa com sucesso, quando o UF for de São Paulo
			it { subject.get_codigo_motivo_ocorrencia('S5', '93').must_equal 'D06' }  # Sempre quando houver ação judicial, restringindo a negativação do boleto.
		end
	end
end