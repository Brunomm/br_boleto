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
		it "deve setar a variacao_carteira com '019'" do
			subject.class.new.variacao_carteira.must_equal '019'
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
		it 'variacao_carteira deve ter no maximo 3 digitos' do
			subject.variacao_carteira = '12345'
			must_be_message_error(:variacao_carteira, :custom_length_maximum, {count: 3})
			subject.variacao_carteira = '123'
			wont_be_message_error(:variacao_carteira, :custom_length_maximum, {count: 34})
		end
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

	describe '#variacao_carteira' do
		it "deve ajustar  valor para 3 digitos" do
			subject.variacao_carteira = 14
			subject.variacao_carteira.must_equal '014'
		end
	end

	describe "#get_tipo_cobranca" do
		context "CÓDIGOS para o cnab 400 do Banco do Brasil" do
			# it { subject.get_tipo_cobranca('11', 240).must_equal '1' } # Cobrança Simples
			# it { subject.get_tipo_cobranca('12', 240).must_equal '1' } # Cobrança Simples
			# it { subject.get_tipo_cobranca('15', 240).must_equal '1' } # Cobrança Simples
			# it { subject.get_tipo_cobranca('16', 240).must_equal '1' } # Cobrança Simples
			# it { subject.get_tipo_cobranca('18', 240).must_equal '1' } # Cobrança Simples
			# it { subject.get_tipo_cobranca('31', 240).must_equal '3' } # Cobrança Caucionada
			# it { subject.get_tipo_cobranca('51', 240).must_equal '4' } # Cobrança Descontada
			# it { subject.get_tipo_cobranca('17', 240).must_equal '7' } # Cobrança Direta Especial
			it { subject.get_tipo_cobranca('7', 400).must_equal '7' } # Cobrança Direta Especial
			it { subject.get_tipo_cobranca('5', 400).must_equal '8' }   # Cobrança BBVendor
		end
	end

	describe "#get_codigo_movimento_remessa" do
		context "CÓDIGOS para o cnab 400 do Banco do Brasil" do
			it { subject.get_codigo_movimento_remessa('01', 400).must_equal '01' } # Registro de títulos
			it { subject.get_codigo_movimento_remessa('02', 400).must_equal '02' } # Solicitação de baixa
			it { subject.get_codigo_movimento_remessa('03', 400).must_equal '03' } # Pedido de débito em conta
			it { subject.get_codigo_movimento_remessa('04', 400).must_equal '04' } # Concessão de abatimento
			it { subject.get_codigo_movimento_remessa('05', 400).must_equal '05' } # Cancelamento de abatimento
			it { subject.get_codigo_movimento_remessa('06', 400).must_equal '06' } # Alteração de vencimento de título
			it { subject.get_codigo_movimento_remessa('22', 400).must_equal '07' } # Alteração do número de controle do participante
			it { subject.get_codigo_movimento_remessa('21', 400).must_equal '08' } # Alteração do número do titulo dado pelo cedente
			it { subject.get_codigo_movimento_remessa('09', 400).must_equal '09' } # Instrução para protestar 
			it { subject.get_codigo_movimento_remessa('10', 400).must_equal '10' } # Instrução para sustar protesto
			it { subject.get_codigo_movimento_remessa('11', 400).must_equal '11' } # Instrução para dispensar juros
			it { subject.get_codigo_movimento_remessa('24', 400).must_equal '12' } # Alteração de nome e endereço do Sacado
			it { subject.get_codigo_movimento_remessa('12', 400).must_equal '16' } # Alterar Juros de Mora
			it { subject.get_codigo_movimento_remessa('31', 400).must_equal '31' } # Conceder desconto
			it { subject.get_codigo_movimento_remessa('32', 400).must_equal '32' } # Não conceder desconto
			it { subject.get_codigo_movimento_remessa('33', 400).must_equal '33' } # Retificar dados da concessão de desconto
			it { subject.get_codigo_movimento_remessa('34', 400).must_equal '34' } # Alterar data para concessão de desconto
			it { subject.get_codigo_movimento_remessa('35', 400).must_equal '35' } # Cobrar multa 
			it { subject.get_codigo_movimento_remessa('36', 400).must_equal '36' } # Dispensar multa 
			it { subject.get_codigo_movimento_remessa('37', 400).must_equal '37' } # Dispensar indexador
			it { subject.get_codigo_movimento_remessa('38', 400).must_equal '38' } # Dispensar prazo limite de recebimento
			it { subject.get_codigo_movimento_remessa('39', 400).must_equal '39' } # Alterar prazo limite de recebimento
			it { subject.get_codigo_movimento_remessa('40', 400).must_equal '40' } # Alterar carteira/modalidade
		end
	end

	describe "#get_especie_titulo" do
		context "CÓDIGOS para o cnab 400 do Banco do Brasil" do
			it { subject.get_especie_titulo('01', 400).must_equal '10' } #  Cheque
			it { subject.get_especie_titulo('02', 400).must_equal '01' } #  Duplicata Mercantil
			it { subject.get_especie_titulo('04', 400).must_equal '12' } #  Duplicata de Serviço
			it { subject.get_especie_titulo('07', 400).must_equal '08' } #  Letra de Câmbio
			it { subject.get_especie_titulo('12', 400).must_equal '02' } #  Nota Promissória
			it { subject.get_especie_titulo('16', 400).must_equal '03' } #  Nota de Seguro
			it { subject.get_especie_titulo('17', 400).must_equal '05' } #  Recibo
			it { subject.get_especie_titulo('19', 400).must_equal '13' } #  Nota de Débito
			it { subject.get_especie_titulo('20', 400).must_equal '15' } #  Apólice de Seguro
			it { subject.get_especie_titulo('26', 400).must_equal '09' } #  Warrant
			it { subject.get_especie_titulo('27', 400).must_equal '26' } #  Dívida Ativa de Estado
			it { subject.get_especie_titulo('28', 400).must_equal '27' } #  Dívida Ativa de Município
			it { subject.get_especie_titulo('29', 400).must_equal '25' } #  Dívida Ativa da União
			it { subject.get_especie_titulo('99', 400).must_equal '99' } #  Outros
		end
	end

	describe "#get_codigo_motivo_ocorrencia" do
		context "CÓDIGOS motivo ocorrencia do Banco do Brasil" do
			it { subject.get_codigo_motivo_ocorrencia('52', '02').must_equal 'A104' } # Registro Rejeitado – Título já Liquidado
		end
	end

	describe "#get_codigo_movimento_retorno" do
		context "CÓDIGOS para o cnab 400 do Banco do Brasil" do
			it { subject.get_codigo_movimento_retorno('05', 400).must_equal '17' }   # Liquidado sem registro (carteira 17=tipo4)
			it { subject.get_codigo_movimento_retorno('07', 400).must_equal '102' }  # Liquidação por Conta/Parcial
			it { subject.get_codigo_movimento_retorno('08', 400).must_equal '103' }  # Liquidação por Saldo
			it { subject.get_codigo_movimento_retorno('15', 400).must_equal '101' }  # Liquidação em Cartório
			it { subject.get_codigo_movimento_retorno('16', 400).must_equal '57' }   # Confirmação de alteração de juros de mora
			it { subject.get_codigo_movimento_retorno('20', 400).must_equal '120' }  # Débito em Conta
			it { subject.get_codigo_movimento_retorno('21', 400).must_equal '43' }   # Alteração do Nome do Sacado
			it { subject.get_codigo_movimento_retorno('22', 400).must_equal '43' }   # Alteração do Endereço do Sacado
			it { subject.get_codigo_movimento_retorno('24', 400).must_equal '20' }   # Sustar Protesto
			it { subject.get_codigo_movimento_retorno('25', 400).must_equal '60' }   # Dispensar Juros de mora
			it { subject.get_codigo_movimento_retorno('26', 400).must_equal '40' }   # Alteração do número do título dado pelo Cedente (Seu número) – 10 e 15posições
			it { subject.get_codigo_movimento_retorno('28', 400).must_equal '108' }  # Manutenção de titulo vencido
			it { subject.get_codigo_movimento_retorno('31', 400).must_equal '07' }   # Conceder desconto
			it { subject.get_codigo_movimento_retorno('32', 400).must_equal '08' }   # Não conceder desconto
			it { subject.get_codigo_movimento_retorno('33', 400).must_equal '58' }   # Retificar desconto
			it { subject.get_codigo_movimento_retorno('34', 400).must_equal '58' }   # Alterar data para desconto
			it { subject.get_codigo_movimento_retorno('35', 400).must_equal '56' }   # Cobrar Multa
			it { subject.get_codigo_movimento_retorno('36', 400).must_equal '55' }   # Dispensar Multa
			it { subject.get_codigo_movimento_retorno('37', 400).must_equal '121' }  # Dispensar Indexador
			it { subject.get_codigo_movimento_retorno('38', 400).must_equal '39' }   # Dispensar prazo limite para recebimento
			it { subject.get_codigo_movimento_retorno('39', 400).must_equal '38' }   # Alterar prazo limite para recebimento
			it { subject.get_codigo_movimento_retorno('46', 400).must_equal '45' }   # Título pago com cheque, aguardando compensação
			it { subject.get_codigo_movimento_retorno('73', 400).must_equal '123' }  # Confirmação de Instrução de Parâmetro de Pagamento Parcial
		end
	end
end