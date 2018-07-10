require 'test_helper'

describe BrBoleto::Conta::Bradesco do
	subject { FactoryBot.build(:conta_bradesco) }

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

	describe "#get_codigo_movimento_retorno" do
		context "CÓDIGOS para o Bradesco" do
			it { subject.get_codigo_movimento_retorno('73', 240).must_equal '73' } # Confirmação recebimento pedido de negativação
		end
	end

	describe "#get_codigo_movimento_retorno" do
		context "CÓDIGOS para o cnab 400 do Bradesco" do
			it { subject.get_codigo_movimento_retorno('15', 400).must_equal '101' }  # Liquidação em Cartório (sem motivo)
			it { subject.get_codigo_movimento_retorno('24', 400).must_equal '106' }  # Entrada rejeitada por CEP Irregular
			it { subject.get_codigo_movimento_retorno('25', 400).must_equal '170' }  # Confirmação Receb.Inst.de Protesto Falimentar
			it { subject.get_codigo_movimento_retorno('27', 400).must_equal '100' }  # Baixa Rejeitada
			it { subject.get_codigo_movimento_retorno('32', 400).must_equal '26' }   # Instrução Rejeitada
			it { subject.get_codigo_movimento_retorno('33', 400).must_equal '27' }   # Confirmação Pedido Alteração Outros Dados (sem motivo)
			it { subject.get_codigo_movimento_retorno('40', 400).must_equal '171' }  # Estorno de pagamento
			it { subject.get_codigo_movimento_retorno('55', 400).must_equal '63' }   # Sustado judicial
			it { subject.get_codigo_movimento_retorno('68', 400).must_equal '33' }   # Acerto dos dados do rateio de Crédito
			it { subject.get_codigo_movimento_retorno('69', 400).must_equal '34' }   # Cancelamento dos dados do rateio
		end
	end

	describe "#get_codigo_motivo_ocorrencia" do
		context "CÓDIGOS motivo ocorrencia A do Bradesco para CNAB 400" do
			it { subject.get_codigo_motivo_ocorrencia('00', '02', 400).must_equal 'A00'  } # Ocorrência aceita
			it { subject.get_codigo_motivo_ocorrencia('03', '03', 400).must_equal 'A05'  } # Código da ocorrência inválida
			it { subject.get_codigo_motivo_ocorrencia('05', '26', 400).must_equal 'A208' } # Código de ocorrência não numérico
			it { subject.get_codigo_motivo_ocorrencia('44', '30', 400).must_equal 'A209' } # Agência Beneficiário não prevista
			it { subject.get_codigo_motivo_ocorrencia('65', '35', 400).must_equal 'A83'  } # Limite excedido
			it { subject.get_codigo_motivo_ocorrencia('66', '100', 400).must_equal 'A84'  } # Número autorização inexistente
			it { subject.get_codigo_motivo_ocorrencia('67', '26', 400).must_equal 'A68'  } # Débito automático agendado
			it { subject.get_codigo_motivo_ocorrencia('68', '30', 400).must_equal 'A69'  } # Débito não agendado - erro nos dados de remessa
			it { subject.get_codigo_motivo_ocorrencia('69', '02', 400).must_equal 'A70'  } # Débito não agendado - Pagador não consta no cadastro de autorizante
			it { subject.get_codigo_motivo_ocorrencia('70', '03', 400).must_equal 'A71'  } # Débito não agendado - Beneficiário não autorizado pelo Pagador
			it { subject.get_codigo_motivo_ocorrencia('71', '26', 400).must_equal 'A72'  } # Débito não agendado - Beneficiário não participa da modalidade de déb.automático
			it { subject.get_codigo_motivo_ocorrencia('72', '30', 400).must_equal 'A73'  } # Débito não agendado - Código de moeda diferente de R$
			it { subject.get_codigo_motivo_ocorrencia('73', '35', 400).must_equal 'A74'  } # Débito não agendado - Data de vencimento inválida/vencida
			it { subject.get_codigo_motivo_ocorrencia('74', '100', 400).must_equal 'A75'  } # Débito não agendado - Conforme seu pedido, Título não registrado
			it { subject.get_codigo_motivo_ocorrencia('75', '02', 400).must_equal 'A76'  } # Débito não agendado - Tipo do número de inscrição do pagador debitado inválido
			it { subject.get_codigo_motivo_ocorrencia('76', '03', 400).must_equal 'A103' } # Pagador Eletrônico DDA
			it { subject.get_codigo_motivo_ocorrencia('83', '26', 400).must_equal 'A218' } # Cancelado pelo Pagador e Mantido Pendente, conforme negociação
			it { subject.get_codigo_motivo_ocorrencia('84', '30', 400).must_equal 'A219' } # Cancelado pelo pagador e baixado, conforme negociação
			it { subject.get_codigo_motivo_ocorrencia('88', '35', 400).must_equal 'A210' } # E-mail Pagador não lido no prazo 5 dias
			it { subject.get_codigo_motivo_ocorrencia('89', '100', 400).must_equal 'A211' } # Email Pagador não enviado – título com débito automático
			it { subject.get_codigo_motivo_ocorrencia('90', '26', 400).must_equal 'A212' } # Email pagador não enviado – título de cobrança sem registro
			it { subject.get_codigo_motivo_ocorrencia('91', '30', 400).must_equal 'A213' } # E-mail pagador não recebido
			it { subject.get_codigo_motivo_ocorrencia('94', '35', 400).must_equal 'A214' } # Título Penhorado – Instrução Não Liberada pela Agência
			it { subject.get_codigo_motivo_ocorrencia('97', '03', 400).must_equal 'A215' } # Instrução não permitida título negativado
			it { subject.get_codigo_motivo_ocorrencia('98', '100', 400).must_equal 'A216' } # Inclusão Bloqueada face a determinação Judicial
			it { subject.get_codigo_motivo_ocorrencia('99', '30', 400).must_equal 'A217' } # Telefone beneficiário não informado / inconsistente
		end

		context "CÓDIGOS motivo ocorrencia B do Bradesco para CNAB 400" do
			it { subject.get_codigo_motivo_ocorrencia('68', '28', 400).must_equal 'B16' }  # Fornecimento de máquina FAX
			it { subject.get_codigo_motivo_ocorrencia('81', '28', 400).must_equal 'B14' }  # Tarifa reapresentação automática título
			it { subject.get_codigo_motivo_ocorrencia('83', '28', 400).must_equal 'B15' }  # Tarifa Rateio de Crédito
			it { subject.get_codigo_motivo_ocorrencia('02', '28', 400).must_equal 'B31' }  # Tarifa de permanência título cadastrado
			it { subject.get_codigo_motivo_ocorrencia('12', '28', 400).must_equal 'B32' }  # Tarifa de registro
			it { subject.get_codigo_motivo_ocorrencia('13', '28', 400).must_equal 'B33' }  # Tarifa título pago no Bradesco
			it { subject.get_codigo_motivo_ocorrencia('14', '28', 400).must_equal 'B34' }  # Tarifa título pago compensação
			it { subject.get_codigo_motivo_ocorrencia('15', '28', 400).must_equal 'B35' }  # Tarifa título baixado não pago
			it { subject.get_codigo_motivo_ocorrencia('16', '28', 400).must_equal 'B36' }  # Tarifa alteração de vencimento
			it { subject.get_codigo_motivo_ocorrencia('17', '28', 400).must_equal 'B37' }  # Tarifa concessão abatimento
			it { subject.get_codigo_motivo_ocorrencia('18', '28', 400).must_equal 'B38' }  # Tarifa cancelamento de abatimento
			it { subject.get_codigo_motivo_ocorrencia('19', '28', 400).must_equal 'B39' }  # Tarifa concessão desconto
			it { subject.get_codigo_motivo_ocorrencia('20', '28', 400).must_equal 'B40' }  # Tarifa cancelamento desconto
			it { subject.get_codigo_motivo_ocorrencia('21', '28', 400).must_equal 'B41' }  # Tarifa título pago cics
			it { subject.get_codigo_motivo_ocorrencia('22', '28', 400).must_equal 'B42' }  # Tarifa título pago Internet
			it { subject.get_codigo_motivo_ocorrencia('23', '28', 400).must_equal 'B43' }  # Tarifa título pago term. gerencial serviços
			it { subject.get_codigo_motivo_ocorrencia('24', '28', 400).must_equal 'B44' }  # Tarifa título pago Pág-Contas
			it { subject.get_codigo_motivo_ocorrencia('25', '28', 400).must_equal 'B45' }  # Tarifa título pago Fone Fácil
			it { subject.get_codigo_motivo_ocorrencia('26', '28', 400).must_equal 'B46' }  # Tarifa título Déb. Postagem
			it { subject.get_codigo_motivo_ocorrencia('27', '28', 400).must_equal 'B47' }  # Tarifa impressão de títulos pendentes
			it { subject.get_codigo_motivo_ocorrencia('28', '28', 400).must_equal 'B48' }  # Tarifa título pago BDN
			it { subject.get_codigo_motivo_ocorrencia('29', '28', 400).must_equal 'B49' }  # Tarifa título pago Term. Multi Função
			it { subject.get_codigo_motivo_ocorrencia('30', '28', 400).must_equal 'B50' }  # Impressão de títulos baixados
			it { subject.get_codigo_motivo_ocorrencia('31', '28', 400).must_equal 'B51' }  # Impressão de títulos pagos
			it { subject.get_codigo_motivo_ocorrencia('32', '28', 400).must_equal 'B52' }  # Tarifa título pago Pagfor
			it { subject.get_codigo_motivo_ocorrencia('33', '28', 400).must_equal 'B53' }  # Tarifa reg/pgto – guichê caixa
			it { subject.get_codigo_motivo_ocorrencia('34', '28', 400).must_equal 'B54' }  # Tarifa título pago retaguarda
			it { subject.get_codigo_motivo_ocorrencia('35', '28', 400).must_equal 'B55' }  # Tarifa título pago Subcentro
			it { subject.get_codigo_motivo_ocorrencia('36', '28', 400).must_equal 'B56' }  # Tarifa título pago Cartão de Crédito
			it { subject.get_codigo_motivo_ocorrencia('37', '28', 400).must_equal 'B57' }  # Tarifa título pago Comp Eletrônica
			it { subject.get_codigo_motivo_ocorrencia('38', '28', 400).must_equal 'B58' }  # Tarifa título Baix. Pg. Cartório
			it { subject.get_codigo_motivo_ocorrencia('39', '28', 400).must_equal 'B59' }  # Tarifa título baixado acerto BCO
			it { subject.get_codigo_motivo_ocorrencia('40', '28', 400).must_equal 'B60' }  # Baixa registro em duplicidade
			it { subject.get_codigo_motivo_ocorrencia('41', '28', 400).must_equal 'B61' }  # Tarifa título baixado decurso prazo
			it { subject.get_codigo_motivo_ocorrencia('42', '28', 400).must_equal 'B62' }  # Tarifa título baixado Judicialmente
			it { subject.get_codigo_motivo_ocorrencia('43', '28', 400).must_equal 'B63' }  # Tarifa título baixado via remessa
			it { subject.get_codigo_motivo_ocorrencia('44', '28', 400).must_equal 'B64' }  # Tarifa título baixado rastreamento
			it { subject.get_codigo_motivo_ocorrencia('45', '28', 400).must_equal 'B65' }  # Tarifa título baixado conf. Pedido
			it { subject.get_codigo_motivo_ocorrencia('46', '28', 400).must_equal 'B66' }  # Tarifa título baixado protestado
			it { subject.get_codigo_motivo_ocorrencia('47', '28', 400).must_equal 'B67' }  # Tarifa título baixado p/ devolução
			it { subject.get_codigo_motivo_ocorrencia('48', '28', 400).must_equal 'B68' }  # Tarifa título baixado franco pagto
			it { subject.get_codigo_motivo_ocorrencia('49', '28', 400).must_equal 'B69' }  # Tarifa título baixado SUST/RET/CARTÓRIO
			it { subject.get_codigo_motivo_ocorrencia('50', '28', 400).must_equal 'B70' }  # Tarifa título baixado SUS/SEM/REM/CARTÓRIO
			it { subject.get_codigo_motivo_ocorrencia('51', '28', 400).must_equal 'B71' }  # Tarifa título transferido desconto
			it { subject.get_codigo_motivo_ocorrencia('52', '28', 400).must_equal 'B72' }  # Cobrado baixa manual
			it { subject.get_codigo_motivo_ocorrencia('53', '28', 400).must_equal 'B73' }  # Baixa por acerto cliente
			it { subject.get_codigo_motivo_ocorrencia('54', '28', 400).must_equal 'B74' }  # Tarifa baixa por contabilidade
			it { subject.get_codigo_motivo_ocorrencia('55', '28', 400).must_equal 'B75' }  # Tr. tentativa cons deb aut
			it { subject.get_codigo_motivo_ocorrencia('56', '28', 400).must_equal 'B76' }  # Tr. credito online
			it { subject.get_codigo_motivo_ocorrencia('57', '28', 400).must_equal 'B77' }  # Tarifa reg/pagto Bradesco Expresso
			it { subject.get_codigo_motivo_ocorrencia('58', '28', 400).must_equal 'B78' }  # Tarifa emissão Papeleta
			it { subject.get_codigo_motivo_ocorrencia('59', '28', 400).must_equal 'B79' }  # Tarifa fornec papeleta semi preenchida
			it { subject.get_codigo_motivo_ocorrencia('60', '28', 400).must_equal 'B80' }  # Acondicionador de papeletas (RPB)S
			it { subject.get_codigo_motivo_ocorrencia('61', '28', 400).must_equal 'B81' }  # Acond. De papelatas (RPB)s PERSONAL
			it { subject.get_codigo_motivo_ocorrencia('62', '28', 400).must_equal 'B82' }  # Papeleta formulário branco
			it { subject.get_codigo_motivo_ocorrencia('63', '28', 400).must_equal 'B83' }  # Formulário A4 serrilhado
			it { subject.get_codigo_motivo_ocorrencia('64', '28', 400).must_equal 'B84' }  # Fornecimento de softwares transmiss
			it { subject.get_codigo_motivo_ocorrencia('65', '28', 400).must_equal 'B85' }  # Fornecimento de softwares consulta
			it { subject.get_codigo_motivo_ocorrencia('66', '28', 400).must_equal 'B86' }  # Fornecimento Micro Completo
			it { subject.get_codigo_motivo_ocorrencia('67', '28', 400).must_equal 'B87' }  # Fornecimento MODEN
			it { subject.get_codigo_motivo_ocorrencia('69', '28', 400).must_equal 'B88' }  # Fornecimento de máquinas óticas
			it { subject.get_codigo_motivo_ocorrencia('70', '28', 400).must_equal 'B89' }  # Fornecimento de Impressoras
			it { subject.get_codigo_motivo_ocorrencia('71', '28', 400).must_equal 'B90' }  # Reativação de título
			it { subject.get_codigo_motivo_ocorrencia('72', '28', 400).must_equal 'B91' }  # Alteração de produto negociado
			it { subject.get_codigo_motivo_ocorrencia('73', '28', 400).must_equal 'B92' }  # Tarifa emissão de contra recibo
			it { subject.get_codigo_motivo_ocorrencia('74', '28', 400).must_equal 'B93' }  # Tarifa emissão 2a via papeleta
			it { subject.get_codigo_motivo_ocorrencia('75', '28', 400).must_equal 'B94' }  # Tarifa regravação arquivo retorno
			it { subject.get_codigo_motivo_ocorrencia('76', '28', 400).must_equal 'B95' }  # Arq. Títulos a vencer mensal
			it { subject.get_codigo_motivo_ocorrencia('77', '28', 400).must_equal 'B96' }  # Listagem auxiliar de crédito
			it { subject.get_codigo_motivo_ocorrencia('78', '28', 400).must_equal 'B97' }  # Tarifa cadastro cartela instrução permanente
			it { subject.get_codigo_motivo_ocorrencia('79', '28', 400).must_equal 'B98' }  # Canalização de Crédito
			it { subject.get_codigo_motivo_ocorrencia('80', '28', 400).must_equal 'B99' }  # Cadastro de Mensagem Fixa
			it { subject.get_codigo_motivo_ocorrencia('82', '28', 400).must_equal 'B100' } # Tarifa registro título déb. Automático
			it { subject.get_codigo_motivo_ocorrencia('84', '28', 400).must_equal 'B101' } # Emissão papeleta sem valor
			it { subject.get_codigo_motivo_ocorrencia('85', '28', 400).must_equal 'B102' } # Sem uso
			it { subject.get_codigo_motivo_ocorrencia('86', '28', 400).must_equal 'B103' } # Cadastro de reembolso de diferença
			it { subject.get_codigo_motivo_ocorrencia('87', '28', 400).must_equal 'B104' } # Relatório fluxo de pagto
			it { subject.get_codigo_motivo_ocorrencia('88', '28', 400).must_equal 'B105' } # Emissão Extrato mov. Carteira
			it { subject.get_codigo_motivo_ocorrencia('89', '28', 400).must_equal 'B106' } # Mensagem campo local de pagto
			it { subject.get_codigo_motivo_ocorrencia('90', '28', 400).must_equal 'B107' } # Cadastro Concessionária serv. Publ.
			it { subject.get_codigo_motivo_ocorrencia('91', '28', 400).must_equal 'B108' } # Classif. Extrato Conta Corrente
			it { subject.get_codigo_motivo_ocorrencia('92', '28', 400).must_equal 'B109' } # Contabilidade especial
			it { subject.get_codigo_motivo_ocorrencia('93', '28', 400).must_equal 'B110' } # Realimentação pagto
			it { subject.get_codigo_motivo_ocorrencia('94', '28', 400).must_equal 'B111' } # Repasse de Créditos
			it { subject.get_codigo_motivo_ocorrencia('96', '28', 400).must_equal 'B112' } # Tarifa reg. Pagto outras mídias
			it { subject.get_codigo_motivo_ocorrencia('97', '28', 400).must_equal 'B113' } # Tarifa Reg/Pagto – Net Empresa
			it { subject.get_codigo_motivo_ocorrencia('98', '28', 400).must_equal 'B114' } # Tarifa título pago vencido
			it { subject.get_codigo_motivo_ocorrencia('99', '28', 400).must_equal 'B115' } # TR Tít. Baixado por decurso prazo
			it { subject.get_codigo_motivo_ocorrencia('100', '28', 400).must_equal 'B116' } # Arquivo Retorno Antecipado
			it { subject.get_codigo_motivo_ocorrencia('101', '28', 400).must_equal 'B117' } # Arq retorno Hora/Hora
			it { subject.get_codigo_motivo_ocorrencia('102', '28', 400).must_equal 'B118' } # TR. Agendamento Déb Aut
			it { subject.get_codigo_motivo_ocorrencia('105', '28', 400).must_equal 'B119' } # TR. Agendamento rat. Crédito
			it { subject.get_codigo_motivo_ocorrencia('106', '28', 400).must_equal 'B120' } # TR Emissão aviso rateio
			it { subject.get_codigo_motivo_ocorrencia('107', '28', 400).must_equal 'B121' } # Extrato de protesto
		end

		context "CÓDIGOS motivo ocorrencia C do Bradesco para CNAB 400" do
			it { subject.get_codigo_motivo_ocorrencia('00', '10', 400).must_equal 'C00' }  # Baixado Conforme Instruções da Agência
			it { subject.get_codigo_motivo_ocorrencia('16', '10', 400).must_equal 'C16' }  # Título Baixado pelo Banco por decurso Prazo
			it { subject.get_codigo_motivo_ocorrencia('17', '10', 400).must_equal 'C17' }  # Titulo Baixado Transferido Carteira
			it { subject.get_codigo_motivo_ocorrencia('20', '10', 400).must_equal 'C20' }  # Titulo Baixado e Transferido para Desconto
			it { subject.get_codigo_motivo_ocorrencia('00', '06', 400).must_equal 'C35' }  # Título pago com dinheiro
			it { subject.get_codigo_motivo_ocorrencia('15', '09', 400).must_equal 'C36' }  # Título pago com cheque
			it { subject.get_codigo_motivo_ocorrencia('10', '17', 400).must_equal 'C10' }  # Baixa Comandada pelo cliente
			it { subject.get_codigo_motivo_ocorrencia('42', '06', 400).must_equal 'C42' }  # Rateio não efetuado, cód. Calculo 2 (VLR. Registro) e v (NOVO)
		end

		context "CÓDIGOS motivo ocorrencia C do Bradesco para CNAB 400" do
			it { subject.get_codigo_motivo_ocorrencia('78', '29', 400).must_equal 'D78' }  # Pagador alega que faturamento e indevido
			it { subject.get_codigo_motivo_ocorrencia('95', '29', 400).must_equal 'D95' }  # Pagador aceita/reconhece o faturamento
		end
	end
end
