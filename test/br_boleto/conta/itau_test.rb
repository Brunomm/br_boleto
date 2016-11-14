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
				must_be_message_error(:carteira, :custom_inclusion, {list: '104, 105, 107, 108, 109, 112, 113, 116, 117, 119, 121, 122, 126, 131, 134, 135, 136, 142, 143, 146, 147, 150, 168, 169, 174, 175, 180, 191, 196, 198'})
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

	describe "#get_especie_titulo" do
		context "CÓDIGOS para o cnab 240 do Itau" do
			it { subject.get_especie_titulo('02', 240).must_equal '01' } # DUPLICATA MERCANTIL
			it { subject.get_especie_titulo('12', 240).must_equal '02' } # NOTA PROMISSÓRIA
			it { subject.get_especie_titulo('16', 240).must_equal '03' } # NOTA DE SEGURO
			it { subject.get_especie_titulo('21', 240).must_equal '04' } # MENSALIDADE ESCOLAR
			it { subject.get_especie_titulo('17', 240).must_equal '05' } # RECIBO
			it { subject.get_especie_titulo('04', 240).must_equal '08' } # DUPLICATA DE SERVIÇO
			it { subject.get_especie_titulo('07', 240).must_equal '09' } # LETRA DE CÂMBIO
			it { subject.get_especie_titulo('19', 240).must_equal '13' } # NOTA DE DÉBITOS
			it { subject.get_especie_titulo('24', 240).must_equal '15' } # DOCUMENTO DE DÍVIDA
			it { subject.get_especie_titulo('30', 240).must_equal '16' } # ENCARGOS CONDOMINIAIS
			it { subject.get_especie_titulo('32', 240).must_equal '18' } # BOLETO DE PROPOSTA
			it { subject.get_especie_titulo('66', 240).must_equal '06' } # CONTRATO
			it { subject.get_especie_titulo('77', 240).must_equal '07' } # COSSEGUROS
			it { subject.get_especie_titulo('88', 240).must_equal '17' } # CONTA DE PRESTAÇÃO DE SERVIÇOS
		end
	end
	describe "#get_especie_titulo" do
		context "CÓDIGOS para o cnab 400 do Itau" do
			it { subject.get_especie_titulo('02', 400).must_equal '01' } # DUPLICATA MERCANTIL
			it { subject.get_especie_titulo('12', 400).must_equal '02' } # NOTA PROMISSÓRIA
			it { subject.get_especie_titulo('16', 400).must_equal '03' } # NOTA DE SEGURO
			it { subject.get_especie_titulo('21', 400).must_equal '04' } # MENSALIDADE ESCOLAR
			it { subject.get_especie_titulo('17', 400).must_equal '05' } # RECIBO
			it { subject.get_especie_titulo('04', 400).must_equal '08' } # DUPLICATA DE SERVIÇO
			it { subject.get_especie_titulo('07', 400).must_equal '09' } # LETRA DE CÂMBIO
			it { subject.get_especie_titulo('19', 400).must_equal '13' } # NOTA DE DÉBITOS
			it { subject.get_especie_titulo('24', 400).must_equal '15' } # DOCUMENTO DE DÍVIDA
			it { subject.get_especie_titulo('30', 400).must_equal '16' } # ENCARGOS CONDOMINIAIS
			it { subject.get_especie_titulo('32', 400).must_equal '18' } # BOLETO DE PROPOSTA
			it { subject.get_especie_titulo('66', 400).must_equal '06' } # CONTRATO
			it { subject.get_especie_titulo('77', 400).must_equal '07' } # COSSEGUROS
			it { subject.get_especie_titulo('88', 400).must_equal '17' } # CONTA DE PRESTAÇÃO DE SERVIÇOS
		end
	end

	describe "#get_codigo_movimento_remessa" do
		context "CÓDIGOS para o cnab 240 do Itau" do
			it { subject.get_codigo_movimento_remessa('10', 240).must_equal '18' } # SUSTAR O PROTESTO
			it { subject.get_codigo_movimento_remessa('38', 240).must_equal '38' } # BENEFICIÁRIO NÃO CONCORDA COM A ALEGAÇÃO DO PAGADOR CÓDIGO DA ALEGAÇÃO
			it { subject.get_codigo_movimento_remessa('41', 240).must_equal '41' } # EXCLUSÃO DE SACADOR AVALISTA
			it { subject.get_codigo_movimento_remessa('66', 240).must_equal '66' } # ENTRADA EM NEGATIVAÇÃO EXPRESSA
			it { subject.get_codigo_movimento_remessa('67', 240).must_equal '67' } # NÃO NEGATIVAR (INIBE ENTRADA EM NEGATIVAÇÃO EXPRESSA
			it { subject.get_codigo_movimento_remessa('68', 240).must_equal '68' } # EXCLUIR NEGATIVAÇÃO EXPRESSA (ATÉ 15 DIAS CORRIDOS APÓS A ENTRADA EM NEGATIVAÇÃO EXPRESSA)
			it { subject.get_codigo_movimento_remessa('69', 240).must_equal '69' } # CANCELAR NEGATIVAÇÃO EXPRESSA (APÓS TÍTULO TER SIDO NEGATIVADO)
			it { subject.get_codigo_movimento_remessa('93', 240).must_equal '93' } # DESCONTAR TÍTULOS ENCAMINHADOS NO DIA
		end
	end

	describe "#get_codigo_protesto" do
		it { subject.get_codigo_protesto('0').must_equal '0' } # Sem instrução
		it { subject.get_codigo_protesto('07').must_equal '07' } # Negativar (Dias Corridos)
	end

	describe "#get_codigo_multa" do
		it { subject.get_codigo_multa('0').must_equal '0' } # NÃO REGISTRA A MULTA
	end

	describe "#get_codigo_carteira" do
		it "deve retornar E se a carteira for 147" do 
			subject.carteira = '147'
			subject.get_codigo_carteira.must_equal 'E'  # ESCRITURAL ELETRÔNICA – DÓLAR
		end
		it "deve retornar U se a carteira for 150" do
			subject.carteira = '150'
			subject.get_codigo_carteira.must_equal 'U'  # DIRETA ELETRÔNICA SEM EMISSÃO – DÓLAR
		end
		it "deve retornar 1 se a carteira for 191" do
			subject.carteira = '191'
			subject.get_codigo_carteira.must_equal '1'  # DUPLICATAS - TRANSFERÊNCIA DE DESCONTO
		end
		it "deve retornar I para as demais carteiras" do
			subject.carteira = '109'
			subject.get_codigo_carteira.must_equal 'I'  # DEMAIS CARTEIRAS

			subject.carteira = '999'
			subject.get_codigo_carteira.must_equal 'I'  # DEMAIS CARTEIRAS
		end
	end
end