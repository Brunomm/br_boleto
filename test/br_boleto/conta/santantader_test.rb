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
		it 'codigo_transmissao deve ter no maximo 20 digitos' do
			subject.codigo_transmissao = '123456789012345678901'
			must_be_message_error(:codigo_transmissao, :custom_length_maximum, {count: 20})
			subject.codigo_transmissao = '12345678901234567890'
			wont_be_message_error(:codigo_transmissao, :custom_length_maximum, {count: 20})
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

	describe '#codigo_transmissao' do
		it "deve ajustar  valor para 20 digitos" do
			subject.codigo_transmissao = 14
			subject.codigo_transmissao.must_equal '00000000000000000014'
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
		context "CÓDIGOS para o cnab 400 do Santander" do
			it { subject.get_especie_titulo('02', 400).must_equal '01' } # DM  - DUPLICATA MERCANTIL
			it { subject.get_especie_titulo('12', 400).must_equal '02' } # NP  - NOTA PROMISSORIA
			it { subject.get_especie_titulo('20', 400).must_equal '03' } # AP  - APOLICE DE SEGURO
			it { subject.get_especie_titulo('17', 400).must_equal '05' } # RC  - RECIBO
			it { subject.get_especie_titulo('04', 400).must_equal '06' } # DS  - DUPLICATA DE SERVICO
			it { subject.get_especie_titulo('07', 400).must_equal '07' } # LC  - LETRA DE CÂMBIO
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

		context "CÓDIGOS para o cnab 400 do Santander" do
			it { subject.get_codigo_movimento_remessa('01', 400).must_equal '01' } # Entrada de título
			it { subject.get_codigo_movimento_remessa('02', 400).must_equal '02' } # Pedido de baixa
			it { subject.get_codigo_movimento_remessa('04', 400).must_equal '04' } # Concessão de abatimento
			it { subject.get_codigo_movimento_remessa('05', 400).must_equal '05' } # Cancelamento de abatimento
			it { subject.get_codigo_movimento_remessa('06', 400).must_equal '06' } # Alteração de vencimento
			it { subject.get_codigo_movimento_remessa('21', 400).must_equal '07' } # Alteração da identificação do título na empresa
			it { subject.get_codigo_movimento_remessa('22', 400).must_equal '08' } # Alteração seu número
			it { subject.get_codigo_movimento_remessa('09', 400).must_equal '09' } # Pedido de Protesto
			it { subject.get_codigo_movimento_remessa('10', 400).must_equal '18' } # Sustar Protesto e Baixar Título
			it { subject.get_codigo_movimento_remessa('11', 400).must_equal '18' } # Sustar Protesto e Manter em Carteira
		end
	end

	describe "#get_codigo_multa" do
		context "CÓDIGOS para o Santander" do
			it { subject.get_codigo_multa('1').must_equal '4' } # Com Multa
			it { subject.get_codigo_multa('2').must_equal '4' } # Com Multa
			it { subject.get_codigo_multa('3').must_equal '0' } # Sem Multa (Isento)
		end
	end

	describe "#get_tipo_cobranca" do
		context "CÓDIGOS para o cnab 240 do Santander" do
			it { subject.get_tipo_cobranca('1', 240).must_equal '5' } # Cobrança Simples (Rápida com Registro)
			it { subject.get_tipo_cobranca('3', 240).must_equal '3' } # Cobrança Caucionada (Eletrônica com Registro e Convencional com Registro)
			it { subject.get_tipo_cobranca('4', 240).must_equal '4' } # Cobrança Descontada (Eletrônica com Registro)
			it { subject.get_tipo_cobranca('6', 240).must_equal '6' } # Cobrança Caucionada (Rápida com Registro)
			it { subject.get_tipo_cobranca('7', 240).must_equal '1' } # Cobrança Simples (Sem Registro / Eletrônica com Registro)
		end

		context "CÓDIGOS para o cnab 400 do Santander" do
			it { subject.get_tipo_cobranca('7', 400).must_equal '4' } # Cobrança Sem Registro
			it { subject.get_tipo_cobranca('4', 400).must_equal '7' } # Cobrança Descontada
		end
	end

	describe "#get_codigo_protesto" do
		context "CÓDIGOS para o Santander" do
			it { subject.get_codigo_protesto('3', 240).must_equal '0' }  # Não Protestar
			it { subject.get_codigo_protesto('99', 240).must_equal '3' } # Utilizar perfil cedente
		end
	end

	describe "#get_codigo_moeda_240" do
		context "CÓDIGOS para o Santander" do
			it { subject.get_codigo_moeda('09', 240).must_equal '00' } # Real
		end
	end

	describe "#get_codigo_movimento_retorno" do
		context "CÓDIGOS para o Santander CNAB 400" do
			it { subject.get_codigo_movimento_retorno('01', 400).must_equal '104' } # título não existe
			it { subject.get_codigo_movimento_retorno('07', 400).must_equal '102' } # liquidação por conta
			it { subject.get_codigo_movimento_retorno('08', 400).must_equal '103' } # liquidação por saldo
			it { subject.get_codigo_movimento_retorno('15', 400).must_equal '23' }  # Enviado para Cartório
			it { subject.get_codigo_movimento_retorno('16', 400).must_equal '25' }  # tít. já baixado/liquidado
			it { subject.get_codigo_movimento_retorno('17', 400).must_equal '101' } # liquidado em cartório
			it { subject.get_codigo_movimento_retorno('21', 400).must_equal '23' }  # Entrada em Cartório
			it { subject.get_codigo_movimento_retorno('22', 400).must_equal '24' }  # Retirado de cartório
			it { subject.get_codigo_movimento_retorno('24', 400).must_equal '235' } # Custas de Cartório
			it { subject.get_codigo_movimento_retorno('25', 400).must_equal '19' }  # Protestar Título
			it { subject.get_codigo_movimento_retorno('26', 400).must_equal '20' }  # Sustar Protestonhado a Protesto: Identifica o recebimento da instrução de protesto
		end
	end
	describe "#get_codigo_motivo_ocorrencia" do
		context "CÓDIGOS motivo ocorrência A para o Santander CNAB 400" do
			it { subject.get_codigo_motivo_ocorrencia('01', '02', 400).must_equal 'A01' }  # Código do banco inválido
		
			it { subject.get_codigo_motivo_ocorrencia('001', '02', 400).must_equal 'A08' }  # NOSSO NUMERO NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('002', '03', 400).must_equal 'A33' }  # VALOR DO ABATIMENTO NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('003', '26', 400).must_equal 'A16' }  # DATA VENCIMENTO NAO NUMERICA
			it { subject.get_codigo_motivo_ocorrencia('005', '30', 400).must_equal 'A10' }  # CODIGO DA CARTEIRA NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('006', '02', 400).must_equal 'A10' }  # CODIGO DA CARTEIRA INVALIDO
			it { subject.get_codigo_motivo_ocorrencia('007', '03', 400).must_equal 'A21' }  # ESPECIE DO DOCUMENTO INVALIDA
			it { subject.get_codigo_motivo_ocorrencia('010', '26', 400).must_equal 'A278' } # CODIGO PRIMEIRA INSTRUCAO NAO NUMERICA
			it { subject.get_codigo_motivo_ocorrencia('011', '30', 400).must_equal 'A280' } # CODIGO SEGUNDA INSTRUCAO NAO NUMERICA
			it { subject.get_codigo_motivo_ocorrencia('013', '02', 400).must_equal 'A20' }  # VALOR DO TITULO NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('014', '03', 400).must_equal 'A27' }  # VALOR DE MORA NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('015', '26', 400).must_equal 'A24' }  # DATA EMISSAO NAO NUMERICA
			it { subject.get_codigo_motivo_ocorrencia('016', '30', 400).must_equal 'A16' }  # DATA DE VENCIMENTO INVALIDA
			it { subject.get_codigo_motivo_ocorrencia('017', '02', 400).must_equal 'A61' }  # CODIGO DA AGENCIA COBRADORA NAO NUMERICA
			it { subject.get_codigo_motivo_ocorrencia('019', '03', 400).must_equal 'A48' }  # NUMERO DO CEP NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('020', '26', 400).must_equal 'A46' }  # TIPO INSCRICAO NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('021', '30', 400).must_equal 'A46' }  # NUMERO DO CGC OU CPF NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('022', '02', 400).must_equal 'A244' } # CODIGO OCORRENCIA INVALIDO
			it { subject.get_codigo_motivo_ocorrencia('023', '03', 400).must_equal 'A08' }  # NOSSO NUMERO INV.P/MODALIDADE
			it { subject.get_codigo_motivo_ocorrencia('025', '26', 400).must_equal 'A28' }  # VALOR DESCONTO NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('029', '30', 400).must_equal 'A27' }  # VALOR DE MORA INVALIDO
			it { subject.get_codigo_motivo_ocorrencia('030', '02', 400).must_equal 'A256' } # DT VENC MENOR DE 15 DIAS DA DT PROCES
			it { subject.get_codigo_motivo_ocorrencia('039', '03', 400).must_equal 'A254' } # PERFIL NAO ACEITA TITULO EM BCO CORRESP
			it { subject.get_codigo_motivo_ocorrencia('040', '26', 400).must_equal 'A255' } # COBR RAPIDA NAO ACEITA-SE BCO CORRESP
			it { subject.get_codigo_motivo_ocorrencia('042', '30', 400).must_equal 'A07' }  # CONTA COBRANCA INVALIDA
			it { subject.get_codigo_motivo_ocorrencia('049', '02', 400).must_equal 'A86' }  # SEU NUMERO NAO CONFERE COM O CARNE
			it { subject.get_codigo_motivo_ocorrencia('052', '03', 400).must_equal 'A227' } # OCOR. NAO ACATADA,TITULO LIOUIDADO
			it { subject.get_codigo_motivo_ocorrencia('053', '26', 400).must_equal 'A227' } # OCOR. NAO ACATADA, TITULO BAIXADO
			it { subject.get_codigo_motivo_ocorrencia('057', '30', 400).must_equal 'A322' } # CEP DO SACADO INCORRETO
			it { subject.get_codigo_motivo_ocorrencia('058', '02', 400).must_equal 'A06' }  # CGC/CPF INCORRETO
			it { subject.get_codigo_motivo_ocorrencia('063', '03', 400).must_equal 'A49' }  # CEP NAO ENCONTRADO NA TABELA DE PRACAS
			it { subject.get_codigo_motivo_ocorrencia('073', '26', 400).must_equal 'A34' }  # ABATIMENTO MAIOR/IGUAL AO VALOR TITULO
			it { subject.get_codigo_motivo_ocorrencia('074', '30', 400).must_equal 'A29' }  # PRIM. DESCONTO MAIOR/IGUAL VALOR TITULO
			it { subject.get_codigo_motivo_ocorrencia('075', '02', 400).must_equal 'A29' }  # SEG. DESCONTO MAIOR/IGUAL VALOR TITULO
			it { subject.get_codigo_motivo_ocorrencia('076', '03', 400).must_equal 'A29' }  # TERC. DESCONTO MAIOR/IGUAL VALOR TITULO
			it { subject.get_codigo_motivo_ocorrencia('086', '26', 400).must_equal 'A80' }  # DATA SEGUNDO DESCONTO INVALIDA
			it { subject.get_codigo_motivo_ocorrencia('087', '30', 400).must_equal 'A80' }  # DATA TERCEIRO DESCONTO INVALIDA
			it { subject.get_codigo_motivo_ocorrencia('091', '02', 400).must_equal 'A31' }  # JA EXISTE CONCESSAO DE DESCONTO
			it { subject.get_codigo_motivo_ocorrencia('092', '03', 400).must_equal 'A09' }  # NOSSO NUMERO JA CADASTRADO
			it { subject.get_codigo_motivo_ocorrencia('093', '26', 400).must_equal 'A20' }  # VALOR DO TITULO NAO INFORMADO
			it { subject.get_codigo_motivo_ocorrencia('098', '30', 400).must_equal 'A24' }  # DATA EMISSAO INVALIDA
			it { subject.get_codigo_motivo_ocorrencia('100', '02', 400).must_equal 'A17' }  # DATA EMISSAO MAIOR OUE A DATA VENCIMENTO
			it { subject.get_codigo_motivo_ocorrencia('104', '03', 400).must_equal 'A52' }  # UNIDADE DA FEDERACAO NAO INFORMADA
			it { subject.get_codigo_motivo_ocorrencia('106', '26', 400).must_equal 'A06' }  # CGCICPF NAO INFORMADO
			it { subject.get_codigo_motivo_ocorrencia('107', '30', 400).must_equal 'A52' }  # UNIDADE DA FEDERACAO INCORRETA 00108 DIGITO CGC/CPF INCORRETO
			it { subject.get_codigo_motivo_ocorrencia('110', '02', 400).must_equal 'A80' }  # DATA PRIMEIRO DESCONTO INVALIDA
			it { subject.get_codigo_motivo_ocorrencia('111', '02', 400).must_equal 'A80' }  # DATA DESCONTO NAO NUMERICA
			it { subject.get_codigo_motivo_ocorrencia('112', '03', 400).must_equal 'A28' }  # VALOR DESCONTO NAO INFORMADO
			it { subject.get_codigo_motivo_ocorrencia('113', '26', 400).must_equal 'A28' }  # VALOR DESCONTO INVALIDO
			it { subject.get_codigo_motivo_ocorrencia('114', '30', 400).must_equal 'A33' }  # VALOR ABATIMENTO NAO INFORMADO
			it { subject.get_codigo_motivo_ocorrencia('115', '02', 400).must_equal 'A34' }  # VALOR ABATIMENTO MAIOR VALOR TITULO
			it { subject.get_codigo_motivo_ocorrencia('116', '03', 400).must_equal 'A58' }  # DATA MULTA NAO NUMERICA
			it { subject.get_codigo_motivo_ocorrencia('117', '26', 400).must_equal 'A29' }  # VALOR DESCONTO MAIOR VALOR TITULO
			it { subject.get_codigo_motivo_ocorrencia('118', '30', 400).must_equal 'A58' }  # DATA MULTA NAO INFORMADA
			it { subject.get_codigo_motivo_ocorrencia('120', '02', 400).must_equal 'A59' }  # PERCENTUAL MULTA NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('121', '03', 400).must_equal 'A59' }  # PERCENTUAL MULTA NAO INFORMADO
			it { subject.get_codigo_motivo_ocorrencia('122', '26', 400).must_equal 'A32' }  # VALOR IOF MAIOR OUE VALOR TITULO
			it { subject.get_codigo_motivo_ocorrencia('123', '30', 400).must_equal 'A322' } # CEP DO SACADO NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('124', '02', 400).must_equal 'A48' }  # CEP SACADO NAO ENCONTRADO
			it { subject.get_codigo_motivo_ocorrencia('129', '03', 400).must_equal 'A21' }  # ESPEC DE DOCUMENTO NAO NUMERICA
			it { subject.get_codigo_motivo_ocorrencia('130', '26', 400).must_equal 'A11' }  # FORMA DE CADASTRAMENTO NAO NUMERICA
			it { subject.get_codigo_motivo_ocorrencia('131', '30', 400).must_equal 'A11' }  # FORMA DE CADASTRAMENTO INVALIDA
			it { subject.get_codigo_motivo_ocorrencia('132', '02', 400).must_equal 'A11' }  # FORMA CADAST. 2 INVALIDA PARA CARTEIRA 3
			it { subject.get_codigo_motivo_ocorrencia('133', '03', 400).must_equal 'A11' }  # FORMA CADAST. 2 INVALIDA PARA CARTEIRA 4
			it { subject.get_codigo_motivo_ocorrencia('134', '26', 400).must_equal 'A05' }  # CODIGO DO MOV. REMESSA NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('135', '30', 400).must_equal 'A05' }  # CODIGO DO MOV. REMESSA INVALIDO
			it { subject.get_codigo_motivo_ocorrencia('139', '02', 400).must_equal 'A02' }  # TIPO DE REGISTRO INVALIDO
			it { subject.get_codigo_motivo_ocorrencia('140', '03', 400).must_equal 'A03' }  # COD. SEOUEC.DO REG. DETALHE INVALIDO
			it { subject.get_codigo_motivo_ocorrencia('142', '26', 400).must_equal 'A07' }  # NUM.AG.CEDENTE/DIG.NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('143', '30', 400).must_equal 'A07' }  # NUM. CONTA CEDENTE/DIG. NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('144', '02', 400).must_equal 'A12' }  # TIPO DE DOCUMENTO NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('145', '03', 400).must_equal 'A12' }  # TIPO DE DOCUMENTO INVALIDO
			it { subject.get_codigo_motivo_ocorrencia('149', '26', 400).must_equal 'A26' }  # CODIGO DE MORA INVALIDO
			it { subject.get_codigo_motivo_ocorrencia('150', '30', 400).must_equal 'A26' }  # CODIGO DE MORA NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('151', '02', 400).must_equal 'A27' }  # VL.MORA IGUAL A ZEROS P. COD.MORA 1
			it { subject.get_codigo_motivo_ocorrencia('152', '03', 400).must_equal 'A27' }  # VL. TAXA MORA IGUAL A ZEROS P.COD MORA 2
			it { subject.get_codigo_motivo_ocorrencia('153', '26', 400).must_equal 'A27' }  # VL. MORA DIFERENTE DE ZEROS P.COD.MORA 3
			it { subject.get_codigo_motivo_ocorrencia('154', '30', 400).must_equal 'A27' }  # VL. MORA NAO NUMERICO P. COD MORA 2
			it { subject.get_codigo_motivo_ocorrencia('155', '02', 400).must_equal 'A27' }  # VL. MORA INVALIDO P. COD.MORA 4
			it { subject.get_codigo_motivo_ocorrencia('160', '03', 400).must_equal 'A319' } # BAIRRO DO SACADO NAO INFORMADO
			it { subject.get_codigo_motivo_ocorrencia('161', '26', 400).must_equal 'A53' }  # TIPO INSC.CPF/CGC SACADOR/AVAL.NAO NUM.
			it { subject.get_codigo_motivo_ocorrencia('170', '30', 400).must_equal 'A11' }  # FORMA DE CADASTRAMENTO 2 INV.P.CART.5
			it { subject.get_codigo_motivo_ocorrencia('199', '02', 400).must_equal 'A53' }  # TIPO INSC.CGC/CPF SACADOR.AVAL.INVAL.
			it { subject.get_codigo_motivo_ocorrencia('200', '03', 400).must_equal 'A53' }  # NUM.INSC.(CGC)SACADOR/AVAL.NAO NUMERICO
			it { subject.get_codigo_motivo_ocorrencia('212', '26', 400).must_equal 'A79' }  # DATA DO JUROS DE MORA NAO NUMERICO (D3P)
			it { subject.get_codigo_motivo_ocorrencia('242', '30', 400).must_equal 'A57' }  # COD. DA MULTA NAO NUMERICO (D3R)
			it { subject.get_codigo_motivo_ocorrencia('243', '02', 400).must_equal 'A57' }  # COD. MULTA INVALIDO (D3R)
			it { subject.get_codigo_motivo_ocorrencia('244', '03', 400).must_equal 'A59' }  # VALOR DA MULTA NAO NUMERICO (D3R)
			it { subject.get_codigo_motivo_ocorrencia('245', '26', 400).must_equal 'A58' }  # DATA DA MULTA NAO NUMERICO (D3R)
			it { subject.get_codigo_motivo_ocorrencia('258', '30', 400).must_equal 'A27' }  # VL.MORA NAO NUMERICO P.COD=4(D3P)
			it { subject.get_codigo_motivo_ocorrencia('263', '02', 400).must_equal 'A278' } # INSTRUCAO PARA TITULO NAO REGISTRADO
			it { subject.get_codigo_motivo_ocorrencia('264', '03', 400).must_equal 'A23' }  # CODIGO DE ACEITE (A/N) INVALIDO.
		end
	end
end