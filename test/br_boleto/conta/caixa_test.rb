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

	describe "#get_codigo_movimento_retorno" do
		context "CÓDIGOS para o Caixa" do
			it { subject.get_codigo_movimento_retorno('01', 240).must_equal '01' }  # Solicitação de Impressão de Títulos Confirmada
			it { subject.get_codigo_movimento_retorno('35', 240).must_equal '135' } # Confirmação de Inclusão Banco de Sacado
			it { subject.get_codigo_movimento_retorno('36', 240).must_equal '136' } # Confirmação de Alteração Banco de Sacado
			it { subject.get_codigo_movimento_retorno('37', 240).must_equal '137' } # Confirmação de Exclusão Banco de Sacado
			it { subject.get_codigo_movimento_retorno('38', 240).must_equal '138' } # Emissão de Bloquetos de Banco de Sacado
			it { subject.get_codigo_movimento_retorno('39', 240).must_equal '139' } # Manutenção de Sacado Rejeitada
			it { subject.get_codigo_movimento_retorno('40', 240).must_equal '140' } # Entrada de Título via Banco de Sacado Rejeitada
			it { subject.get_codigo_movimento_retorno('41', 240).must_equal '141' } # Manutenção de Banco de Sacado Rejeitada
			it { subject.get_codigo_movimento_retorno('44', 240).must_equal '144' } # Estorno de Baixa / Liquidação
			it { subject.get_codigo_movimento_retorno('45', 240).must_equal '145' } # Alteração de Dados
		end
	end

	describe "#get_codigo_motivo_ocorrencia" do
		context "CÓDIGOS para oa Caixa com Motivo Ocorrência A" do
			it { subject.get_codigo_motivo_ocorrencia('11', '02').must_equal 'A115' } # Data de Geração Inválida 
			it { subject.get_codigo_motivo_ocorrencia('64', '03').must_equal 'A116' } # Entrada Inválida para Cobrança Caucionada
			it { subject.get_codigo_motivo_ocorrencia('65', '26').must_equal 'A117' } # CEP do Pagador não encontrado
			it { subject.get_codigo_motivo_ocorrencia('66', '30').must_equal 'A118' } # Agencia Cobradora não encontrada
			it { subject.get_codigo_motivo_ocorrencia('67', '02').must_equal 'A119' } # Agencia Beneficiário não encontrada
			it { subject.get_codigo_motivo_ocorrencia('68', '03').must_equal 'A120' } # Movimentação inválida para título
			it { subject.get_codigo_motivo_ocorrencia('69', '26').must_equal 'A121' } # Alteração de dados inválida
			it { subject.get_codigo_motivo_ocorrencia('70', '02').must_equal 'A122' } # Apelido do cliente não cadastrado
			it { subject.get_codigo_motivo_ocorrencia('71', '03').must_equal 'A123' } # Erro na composição do arquivo
			it { subject.get_codigo_motivo_ocorrencia('72', '26').must_equal 'A124' } # Lote de serviço inválido
			it { subject.get_codigo_motivo_ocorrencia('73', '30').must_equal 'A125' } # Código do Beneficiário inválido
			it { subject.get_codigo_motivo_ocorrencia('74', '02').must_equal 'A126' } # Beneficiário não pertencente a Cobrança Eletrônica
			it { subject.get_codigo_motivo_ocorrencia('75', '03').must_equal 'A127' } # Nome da Empresa inválido
			it { subject.get_codigo_motivo_ocorrencia('76', '26').must_equal 'A128' } # Nome do Banco inválido
			it { subject.get_codigo_motivo_ocorrencia('77', '30').must_equal 'A129' } # Código da Remessa inválido
			it { subject.get_codigo_motivo_ocorrencia('78', '02').must_equal 'A130' } # Data/Hora Geração do arquivo inválida
			it { subject.get_codigo_motivo_ocorrencia('79', '03').must_equal 'A131' } # Número Sequencial do arquivo inválido
			it { subject.get_codigo_motivo_ocorrencia('80', '26').must_equal 'A132' } # Versão do Lay out do arquivo inválido
			it { subject.get_codigo_motivo_ocorrencia('81', '30').must_equal 'A133' } # Literal REMESSA-TESTE - Válido só p/ fase testes
			it { subject.get_codigo_motivo_ocorrencia('82', '02').must_equal 'A134' } # Literal REMESSA-TESTE - Obrigatório p/ fase testes
			it { subject.get_codigo_motivo_ocorrencia('83', '03').must_equal 'A135' } # Tp Número Inscrição Empresa inválido
			it { subject.get_codigo_motivo_ocorrencia('84', '26').must_equal 'A136' } # Tipo de Operação inválido
			it { subject.get_codigo_motivo_ocorrencia('85', '02').must_equal 'A137' } # Tipo de serviço inválido
			it { subject.get_codigo_motivo_ocorrencia('86', '03').must_equal 'A138' } # Forma de lançamento inválido
			it { subject.get_codigo_motivo_ocorrencia('87', '26').must_equal 'A139' } # Número da remessa inválido
			it { subject.get_codigo_motivo_ocorrencia('88', '30').must_equal 'A140' } # Número da remessa menor/igual remessa anterior
			it { subject.get_codigo_motivo_ocorrencia('89', '02').must_equal 'A141' } # Lote de serviço divergente
			it { subject.get_codigo_motivo_ocorrencia('90', '03').must_equal 'A142' } # Número sequencial do registro inválido
			it { subject.get_codigo_motivo_ocorrencia('91', '26').must_equal 'A143' } # Erro seq de segmento do registro detalhe
			it { subject.get_codigo_motivo_ocorrencia('92', '30').must_equal 'A144' } # Cod movto divergente entre grupo de segm
			it { subject.get_codigo_motivo_ocorrencia('93', '02').must_equal 'A145' } # Qtde registros no lote inválido
			it { subject.get_codigo_motivo_ocorrencia('94', '03').must_equal 'A146' } # Qtde registros no lote divergente
			it { subject.get_codigo_motivo_ocorrencia('95', '26').must_equal 'A147' } # Qtde lotes no arquivo inválido
			it { subject.get_codigo_motivo_ocorrencia('96', '30').must_equal 'A148' } # Qtde lotes no arquivo divergente
			it { subject.get_codigo_motivo_ocorrencia('97', '02').must_equal 'A149' } # Qtde registros no arquivo inválido
			it { subject.get_codigo_motivo_ocorrencia('98', '03').must_equal 'A150' } # Qtde registros no arquivo divergente
			it { subject.get_codigo_motivo_ocorrencia('99', '26').must_equal 'A151' } # Código de DDD inválido
		end

		context "CÓDIGOS para oa Caixa com Motivo Ocorrência B" do
			it { subject.get_codigo_motivo_ocorrencia('12', '28').must_equal 'B21' }   # Redisponibilização de Arquivo Retorno Eletrônico
			it { subject.get_codigo_motivo_ocorrencia('15', '28').must_equal 'B22' }   # Banco de Pagadores
			it { subject.get_codigo_motivo_ocorrencia('17', '28').must_equal 'B23' }   # Entrega Aviso Disp Boleto via e-amail ao pagador (s/ emissão Boleto)
			it { subject.get_codigo_motivo_ocorrencia('18', '28').must_equal 'B24' }   # Emissão de Boleto Pré-impresso CAIXA matricial
			it { subject.get_codigo_motivo_ocorrencia('19', '28').must_equal 'B25' }   # Emissão de Boleto Pré-impresso CAIXA A4
			it { subject.get_codigo_motivo_ocorrencia('20', '28').must_equal 'B26' }   # Emissão de Boleto Padrão CAIXA
			it { subject.get_codigo_motivo_ocorrencia('21', '28').must_equal 'B27' }   # Emissão de Boleto/Carnê
			it { subject.get_codigo_motivo_ocorrencia('31', '28').must_equal 'B28' }   # Emissão de Aviso de Vencido
			it { subject.get_codigo_motivo_ocorrencia('42', '28').must_equal 'B29' }   # Alteração cadastral de dados do título - sem emissão de aviso
			it { subject.get_codigo_motivo_ocorrencia('45', '28').must_equal 'B30' }   # Emissão de 2a via de Boleto Cobrança Registrada
		end

		context "CÓDIGOS para oa Caixa com Motivo Ocorrência C" do
			it { subject.get_codigo_motivo_ocorrencia('02', '06').must_equal 'C100' }   # Casa Lotérica
			it { subject.get_codigo_motivo_ocorrencia('03', '09').must_equal 'C101' }   # Agências CAIXA
			it { subject.get_codigo_motivo_ocorrencia('07', '17').must_equal 'C102' }   # Correspondente Bancário
		end

		context "CÓDIGOS para oa Caixa com Motivo Ocorrência D" do
			it { subject.get_codigo_motivo_ocorrencia('01', '08').must_equal 'D07' }   # Liquidação em Dinheiro
			it { subject.get_codigo_motivo_ocorrencia('02', '08').must_equal 'D08' }   # Liquidação em Cheque
		end
	end

	describe "#get_codigo_movimento_retorno" do
		context "CÓDIGOS para o cnab 400 da Caixa" do
			it { subject.get_codigo_movimento_retorno('01', 400).must_equal '02' }   # Entrada Confirmada
			it { subject.get_codigo_movimento_retorno('02', 400).must_equal '09' }   # Baixa Manual Confirmada
			it { subject.get_codigo_movimento_retorno('03', 400).must_equal '12' }   # Abatimento Concedido
			it { subject.get_codigo_movimento_retorno('04', 400).must_equal '13' }   # Abatimento Cancelado
			it { subject.get_codigo_movimento_retorno('05', 400).must_equal '14' }   # Vencimento Alterado
			it { subject.get_codigo_movimento_retorno('06', 400).must_equal '146' }  # Uso da Empresa Alterado
			it { subject.get_codigo_movimento_retorno('08', 400).must_equal '147' }  # Prazo de Devolução Alterado
			it { subject.get_codigo_movimento_retorno('09', 400).must_equal '27' }   # Alteração Confirmada
			it { subject.get_codigo_movimento_retorno('10', 400).must_equal '148' }  # Alteração com reemissão de Boleto Confirmada
			it { subject.get_codigo_movimento_retorno('11', 400).must_equal '149' }  # Alteração da opção de Protesto para Devolução Confirmada
			it { subject.get_codigo_movimento_retorno('12', 400).must_equal '150' }  # Alteração da opção de Devolução para Protesto Confirmada
			it { subject.get_codigo_movimento_retorno('20', 400).must_equal '11' }   # Em Ser
			it { subject.get_codigo_movimento_retorno('21', 400).must_equal '06' }   # Liquidação 
			it { subject.get_codigo_movimento_retorno('22', 400).must_equal '101' }  # Liquidação em Cartório 
			it { subject.get_codigo_movimento_retorno('23', 400).must_equal '151' }  # Baixa por Devolução 
			it { subject.get_codigo_movimento_retorno('25', 400).must_equal '152' }  # Baixa por Protesto 
			it { subject.get_codigo_movimento_retorno('26', 400).must_equal '23' }  # Título enviado para Cartório 
			it { subject.get_codigo_movimento_retorno('27', 400).must_equal '20' }   # Sustação de Protesto 
			it { subject.get_codigo_movimento_retorno('28', 400).must_equal '153' }  # Estorno de Protesto 
			it { subject.get_codigo_movimento_retorno('29', 400).must_equal '154' }  # Estorno de Sustação de Protesto 
			it { subject.get_codigo_movimento_retorno('30', 400).must_equal '61' }   # Alteração de Título 
			it { subject.get_codigo_movimento_retorno('31', 400).must_equal '108' }  # Tarifa sobre Título Vencido 
			it { subject.get_codigo_movimento_retorno('32', 400).must_equal '155' }  # Outras Tarifas de Alteração 
			it { subject.get_codigo_movimento_retorno('33', 400).must_equal '144' }  # Estorno de Baixa / Liquidação 
			it { subject.get_codigo_movimento_retorno('34', 400).must_equal '156' }  # Tarifas Diversas 
		end
	end
end