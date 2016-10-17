require 'test_helper'

describe BrBoleto::Conta::Sicredi do
	subject { FactoryGirl.build(:conta_sicredi) }

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
		it "deve setar a valid_conta_corrente_maximum com 5 " do
			subject.class.new.valid_conta_corrente_maximum.must_equal 5
		end
		it "deve setar a valid_codigo_cedente_maximum com 5 " do
			subject.class.new.valid_codigo_cedente_maximum.must_equal 5
		end
		it "deve setar a posto com '0'" do
			subject.class.new.posto.must_equal '00'
		end
		it "deve setar a byte_id com '2'" do
			subject.class.new.byte_id.must_equal '2'
		end
	end
	describe "Validations" do
		it { must validate_presence_of(:agencia) }
		it { must validate_presence_of(:razao_social) }
		it { must validate_presence_of(:cpf_cnpj) }

		context 'Validações padrões da carteira' do
			subject { BrBoleto::Conta::Sicredi.new }
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
			subject { BrBoleto::Conta::Sicredi.new }
			it { must validate_presence_of(:conta_corrente) }
			it 'Tamanho deve ter o tamanho maximo de 5' do
				subject.conta_corrente = '12345678'
				must_be_message_error(:conta_corrente, :custom_length_maximum, {count: 5})
			end
		end
		context 'Validações padrões da codigo_cedente' do
			subject { BrBoleto::Conta::Sicredi.new }
			it 'Tamanho deve ter o tamanho maximo de 5' do
				subject.codigo_cedente = '12345678'
				must_be_message_error(:convenio, :custom_length_maximum, {count: 5})
			end
		end
		it 'posto deve ter no maximo 2 digitos' do
			subject.posto = '12345'
			must_be_message_error(:posto, :custom_length_maximum, {count: 2})
			subject.posto = '12'
			wont_be_message_error(:posto, :custom_length_maximum, {count: 2})
		end	
		context 'Validações padrões do byte_id'	 do
			subject { BrBoleto::Conta::Sicredi.new }
			it { must validate_presence_of(:byte_id) }
			it 'byte_id deve ter 1 digito' do
				subject.byte_id = '12345'
				must_be_message_error(:byte_id, :custom_length_is, {count: 1})
				subject.byte_id = '9'
				wont_be_message_error(:byte_id, :custom_length_is, {count: 1})
			end
			it "valores aceitos" do
				subject.byte_id = '1'
				must_be_message_error(:byte_id, :custom_inclusion, {list: '2, 3, 4, 5, 6, 7, 8, 9'})
				subject.byte_id = '7'
				wont_be_message_error(:byte_id, :custom_inclusion, {list: '2, 3, 4, 5, 6, 7, 8, 9'})
			end
		end
	end

	it "codigo do banco" do
		subject.codigo_banco.must_equal '748'
	end
	it '#codigo_banco_dv' do
		subject.codigo_banco_dv.must_equal 'X'
	end

	describe "#nome_banco" do
		it "valor padrão para o nome_banco" do
			subject.nome_banco.must_equal 'SICREDI'
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

	describe '#posto' do
		it "deve ajustar  valor para 2 digitos" do
			subject.posto = 4
			subject.posto.must_equal '04'
		end
	end	
	describe '#byte_id' do
		it "deve ajustar  valor para 1 digito" do
			subject.byte_id = 4
			subject.byte_id.must_equal '4'
		end
	end

	describe "#equivalent_especie_titulo_240" do
		context "CÓDIGOS para o cnab 240 do Sicredi" do
			it { subject.get_especie_titulo('03', 240).must_equal 'A' }  # Duplicata Mercantil por Indicação (DMI)
			it { subject.get_especie_titulo('06', 240).must_equal 'B' }  # Duplicata Rural (DR)
			it { subject.get_especie_titulo('12', 240).must_equal 'C' }  # Nota Promissória (NP)
			it { subject.get_especie_titulo('13', 240).must_equal 'D' }  # Nota Promissória Rural (NR)
			it { subject.get_especie_titulo('16', 240).must_equal 'E' }  # Nota de Seguros (NS)
			it { subject.get_especie_titulo('17', 240).must_equal 'G' }  # Recibo (RC)
			it { subject.get_especie_titulo('07', 240).must_equal 'H' }  # Letra de Câmbio (LC)
			it { subject.get_especie_titulo('19', 240).must_equal 'I' }  # Nota de Débito (ND)
			it { subject.get_especie_titulo('05', 240).must_equal 'J' }  # Duplicata de Serviço por Indicação (DSI)
			it { subject.get_especie_titulo('99', 240).must_equal 'K' }  # Outros (OS)
		end
	end

end