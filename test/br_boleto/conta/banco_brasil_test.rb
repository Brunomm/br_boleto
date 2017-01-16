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
		context "CÓDIGOS motivo ocorrencia do Banco do Brasil para CNAB 240" do
			it { subject.get_codigo_motivo_ocorrencia('52', '02', 240).must_equal 'A104' } # Registro Rejeitado – Título já Liquidado
		end

		context "CÓDIGOS motivo ocorrencia do Banco do Brasil para CNAB 400 com Código de Movimento 02" do
			it { subject.get_codigo_motivo_ocorrencia('00', '02', 400).must_equal 'A207' } # Entrada Por meio magnético
			it { subject.get_codigo_motivo_ocorrencia('11', '02', 400).must_equal 'A151' } # Entrada Por via convencional
			it { subject.get_codigo_motivo_ocorrencia('16', '02', 400).must_equal 'A152' } # Entrada Por alteração do código do cedente
			it { subject.get_codigo_motivo_ocorrencia('17', '02', 400).must_equal 'A153' } # Entrada Por alteração da variação
			it { subject.get_codigo_motivo_ocorrencia('18', '02', 400).must_equal 'A154' } # Entrada Por alteração da carteira
		end

		context "CÓDIGOS motivo ocorrencia do Banco do Brasil para CNAB 400 com Código de Movimento 03" do
			it { subject.get_codigo_motivo_ocorrencia('03', '03', 400).must_equal 'A27'  } # valor dos juros por um dia inválido
			it { subject.get_codigo_motivo_ocorrencia('04', '03', 400).must_equal 'A29'  } # valor do desconto inválido
			it { subject.get_codigo_motivo_ocorrencia('05', '03', 400).must_equal 'A22'  } # espécie de título inválida para carteira/variação
			it { subject.get_codigo_motivo_ocorrencia('07', '03', 400).must_equal 'A07'  } # Prefixo da agência usuária inválido
			it { subject.get_codigo_motivo_ocorrencia('08', '03', 400).must_equal 'A20'  } # valor do título/apólice inválido
			it { subject.get_codigo_motivo_ocorrencia('09', '03', 400).must_equal 'A16'  } # data de vencimento inválida
			it { subject.get_codigo_motivo_ocorrencia('16', '03', 400).must_equal 'A11'  } # Título preenchido de forma irregular
			it { subject.get_codigo_motivo_ocorrencia('19', '03', 400).must_equal 'A105' } # Código do cedente inválido
			it { subject.get_codigo_motivo_ocorrencia('20', '03', 400).must_equal 'A45'  } # Nome/endereço do cliente não informado (ECT)
			it { subject.get_codigo_motivo_ocorrencia('21', '03', 400).must_equal 'A10'  } # Carteira inválida
			it { subject.get_codigo_motivo_ocorrencia('24', '03', 400).must_equal 'A33'  } # Valor do abatimento inválido
			it { subject.get_codigo_motivo_ocorrencia('25', '03', 400).must_equal 'A86'  } # Novo número do título dado pelo cedente inválido (Seu número)
			it { subject.get_codigo_motivo_ocorrencia('26', '03', 400).must_equal 'A32'  } # Valor do IOF de seguro inválido
			it { subject.get_codigo_motivo_ocorrencia('29', '03', 400).must_equal 'A47'  } # Endereço não informado
			it { subject.get_codigo_motivo_ocorrencia('30', '03', 400).must_equal 'A104' } # Registro de título já liquidado (carteira 17-tipo 4)
			it { subject.get_codigo_motivo_ocorrencia('33', '03', 400).must_equal 'A09'  } # Nosso número já existente
			it { subject.get_codigo_motivo_ocorrencia('37', '03', 400).must_equal 'A24'  } # Data de emissão do título inválida
			it { subject.get_codigo_motivo_ocorrencia('38', '03', 400).must_equal 'A25'  } # Data do vencimento anterior à data da emissão do título
			it { subject.get_codigo_motivo_ocorrencia('39', '03', 400).must_equal 'A04'  } # Comando de alteração indevido para a carteira
			it { subject.get_codigo_motivo_ocorrencia('41', '03', 400).must_equal 'A36'  } # Abatimento não permitido
			it { subject.get_codigo_motivo_ocorrencia('42', '03', 400).must_equal 'A51'  } # CEP/UF inválido/não compatíveis (ECT)
			it { subject.get_codigo_motivo_ocorrencia('46', '03', 400).must_equal 'A105' } # Convenio encerrado
			it { subject.get_codigo_motivo_ocorrencia('49', '03', 400).must_equal 'A107' } # Abatimento a cancelar não consta do título
			it { subject.get_codigo_motivo_ocorrencia('52', '03', 400).must_equal 'A34'  } # Abatimento igual ou maior que o valor do Título
			it { subject.get_codigo_motivo_ocorrencia('66', '03', 400).must_equal 'A53'  } # Número do documento do sacado (CNPJ/CPF) inválido
			it { subject.get_codigo_motivo_ocorrencia('69', '03', 400).must_equal 'A59'  } # Valor/Percentual de Juros Inválido
			it { subject.get_codigo_motivo_ocorrencia('75', '03', 400).must_equal 'A97'  } # Qtde. de dias do prazo limite p/ recebimento de título vencido inválido
			it { subject.get_codigo_motivo_ocorrencia('80', '03', 400).must_equal 'A08'  } # Nosso numero inválido
			it { subject.get_codigo_motivo_ocorrencia('81', '03', 400).must_equal 'A80'  } # Data para concessão do desconto inválida.
			it { subject.get_codigo_motivo_ocorrencia('82', '03', 400).must_equal 'A48'  } # CEP do sacado inválido
			it { subject.get_codigo_motivo_ocorrencia('01', '03', 400).must_equal 'A155'  } # identificação inválida
			it { subject.get_codigo_motivo_ocorrencia('02', '03', 400).must_equal 'A156'  } # variação da carteira inválida
			it { subject.get_codigo_motivo_ocorrencia('06', '03', 400).must_equal 'A157'  } # espécie de valor invariável inválido
			it { subject.get_codigo_motivo_ocorrencia('10', '03', 400).must_equal 'A158'  } # fora do prazo/só admissível na carteira
			it { subject.get_codigo_motivo_ocorrencia('11', '03', 400).must_equal 'A159'  } # inexistência de margem para desconto
			it { subject.get_codigo_motivo_ocorrencia('12', '03', 400).must_equal 'A160'  } # o banco não tem agência na praça do sacado
			it { subject.get_codigo_motivo_ocorrencia('13', '03', 400).must_equal 'A161'  } # razões cadastrais
			it { subject.get_codigo_motivo_ocorrencia('14', '03', 400).must_equal 'A162'  } # sacado interligado com o sacador (só admissível em cobrança simples- cart. 11 e 17)
			it { subject.get_codigo_motivo_ocorrencia('15', '03', 400).must_equal 'A163'  } # Título sacado contra órgão do Poder Público (só admissível na carteira 11 e sem ordem de protesto)
			it { subject.get_codigo_motivo_ocorrencia('17', '03', 400).must_equal 'A164'  } # Título rasurado
			it { subject.get_codigo_motivo_ocorrencia('18', '03', 400).must_equal 'A165'  } # Endereço do sacado não localizado ou incompleto
			it { subject.get_codigo_motivo_ocorrencia('22', '03', 400).must_equal 'A166'  } # Quantidade de valor variável inválida
			it { subject.get_codigo_motivo_ocorrencia('23', '03', 400).must_equal 'A167'  } # Faixa nosso-numero excedida
			it { subject.get_codigo_motivo_ocorrencia('27', '03', 400).must_equal 'A168'  } # Nome do sacado/cedente inválido
			it { subject.get_codigo_motivo_ocorrencia('28', '03', 400).must_equal 'A169'  } # Data do novo vencimento inválida
			it { subject.get_codigo_motivo_ocorrencia('31', '03', 400).must_equal 'A170'  } # Numero do borderô inválido
			it { subject.get_codigo_motivo_ocorrencia('32', '03', 400).must_equal 'A171'  } # Nome da pessoa autorizada inválido
			it { subject.get_codigo_motivo_ocorrencia('34', '03', 400).must_equal 'A172'  } # Numero da prestação do contrato inválido
			it { subject.get_codigo_motivo_ocorrencia('35', '03', 400).must_equal 'A173'  } # percentual de desconto inválido
			it { subject.get_codigo_motivo_ocorrencia('36', '03', 400).must_equal 'A174'  } # Dias para fichamento de protesto inválido
			it { subject.get_codigo_motivo_ocorrencia('40', '03', 400).must_equal 'A175'  } # Tipo de moeda inválido
			it { subject.get_codigo_motivo_ocorrencia('43', '03', 400).must_equal 'A176'  } # Código de unidade variável incompatível com a data de emissão do título
			it { subject.get_codigo_motivo_ocorrencia('44', '03', 400).must_equal 'A177'  } # Dados para débito ao sacado inválidos
			it { subject.get_codigo_motivo_ocorrencia('45', '03', 400).must_equal 'A178'  } # Carteira/variação encerrada
			it { subject.get_codigo_motivo_ocorrencia('47', '03', 400).must_equal 'A179'  } # Título tem valor diverso do informado
			it { subject.get_codigo_motivo_ocorrencia('48', '03', 400).must_equal 'A180'  } # Motivo de baixa invalido para a carteira
			it { subject.get_codigo_motivo_ocorrencia('50', '03', 400).must_equal 'A181'  } # Comando incompatível com a carteira
			it { subject.get_codigo_motivo_ocorrencia('51', '03', 400).must_equal 'A182'  } # Código do convenente invalido
			it { subject.get_codigo_motivo_ocorrencia('53', '03', 400).must_equal 'A183'  } # Título já se encontra na situação pretendida
			it { subject.get_codigo_motivo_ocorrencia('54', '03', 400).must_equal 'A184'  } # Título fora do prazo admitido para a conta 1
			it { subject.get_codigo_motivo_ocorrencia('55', '03', 400).must_equal 'A185'  } # Novo vencimento fora dos limites da carteira
			it { subject.get_codigo_motivo_ocorrencia('56', '03', 400).must_equal 'A186'  } # Título não pertence ao convenente
			it { subject.get_codigo_motivo_ocorrencia('57', '03', 400).must_equal 'A187'  } # Variação incompatível com a carteira
			it { subject.get_codigo_motivo_ocorrencia('58', '03', 400).must_equal 'A188'  } # Impossível a variação única para a carteira indicada
			it { subject.get_codigo_motivo_ocorrencia('59', '03', 400).must_equal 'A189'  } # Título vencido em transferência para a carteira 51
			it { subject.get_codigo_motivo_ocorrencia('60', '03', 400).must_equal 'A190'  } # Título com prazo superior a 179 dias em variação única para carteira 51
			it { subject.get_codigo_motivo_ocorrencia('61', '03', 400).must_equal 'A191'  } # Título já foi fichado para protesto
			it { subject.get_codigo_motivo_ocorrencia('62', '03', 400).must_equal 'A192'  } # Alteração da situação de débito inválida para o código de responsabilidade
			it { subject.get_codigo_motivo_ocorrencia('63', '03', 400).must_equal 'A193'  } # DV do nosso número inválido
			it { subject.get_codigo_motivo_ocorrencia('64', '03', 400).must_equal 'A194'  } # Título não passível de débito/baixa – situação anormal
			it { subject.get_codigo_motivo_ocorrencia('65', '03', 400).must_equal 'A195'  } # Título com ordem de não protestar – não pode ser encaminhado a cartório
			it { subject.get_codigo_motivo_ocorrencia('67', '03', 400).must_equal 'A196'  } # Título/carne rejeitado
			it { subject.get_codigo_motivo_ocorrencia('70', '03', 400).must_equal 'A197'  } # Título já se encontra isento de juros
			it { subject.get_codigo_motivo_ocorrencia('71', '03', 400).must_equal 'A198'  } # Código de Juros Inválido
			it { subject.get_codigo_motivo_ocorrencia('72', '03', 400).must_equal 'A199'  } # Prefixo da Ag. cobradora inválido
			it { subject.get_codigo_motivo_ocorrencia('73', '03', 400).must_equal 'A200'  } # Numero do controle do participante inválido
			it { subject.get_codigo_motivo_ocorrencia('74', '03', 400).must_equal 'A201'  } # Cliente não cadastrado no CIOPE (Desconto/Vendor)
			it { subject.get_codigo_motivo_ocorrencia('76', '03', 400).must_equal 'A202'  } # Título excluído automaticamente por decurso de prazo CIOPE (Desconto/Vendor)
			it { subject.get_codigo_motivo_ocorrencia('77', '03', 400).must_equal 'A203'  } # Título vencido transferido para a conta 1 – Carteira vinculada
			it { subject.get_codigo_motivo_ocorrencia('83', '03', 400).must_equal 'A204'  } # Carteira/variação não localizada no cedente
			it { subject.get_codigo_motivo_ocorrencia('84', '03', 400).must_equal 'A205'  } # Título não localizado na existência/Baixado por protesto
			it { subject.get_codigo_motivo_ocorrencia('85', '03', 400).must_equal 'A206'  } # Recusa do Comando “41” – Parâmetro de Liquidação Parcial.
			it { subject.get_codigo_motivo_ocorrencia('99', '03', 400).must_equal 'A999'  } # Outros motivos
		end

		context "CÓDIGOS motivo ocorrencia C do Banco do Brasil para CNAB 400" do
			it { subject.get_codigo_motivo_ocorrencia('01', '06', 400).must_equal 'C103' }   # Liquidação normal
			it { subject.get_codigo_motivo_ocorrencia('02', '09', 400).must_equal 'C104' }   # Liquidação parcial
			it { subject.get_codigo_motivo_ocorrencia('03', '10', 400).must_equal 'C01' }    # Liquidação por saldo
			it { subject.get_codigo_motivo_ocorrencia('04', '17', 400).must_equal 'C105' }   # Liquidação com cheque a compensar
			it { subject.get_codigo_motivo_ocorrencia('05', '45', 400).must_equal 'C106' }   # Liquidação de título sem registro (carteira 7 tipo 4)
			it { subject.get_codigo_motivo_ocorrencia('07', '102', 400).must_equal 'C107' }   # Liquidação na apresentação
			it { subject.get_codigo_motivo_ocorrencia('09', '103', 400).must_equal 'C08' }    # Liquidação em cartório
			it { subject.get_codigo_motivo_ocorrencia('10', '101', 400).must_equal 'C110' }   # Liquidação Parcial com Cheque a Compensar
			it { subject.get_codigo_motivo_ocorrencia('11', '120', 400).must_equal 'C111' }   # Liquidação por Saldo com Cheque a Compensar
			it { subject.get_codigo_motivo_ocorrencia('00', '06', 400).must_equal 'C10' }   # Solicitada pelo cliente
			it { subject.get_codigo_motivo_ocorrencia('15', '09', 400).must_equal 'C14' }   # Protestado
			it { subject.get_codigo_motivo_ocorrencia('18', '10', 400).must_equal 'C118' }  # Por alteração da carteira
			it { subject.get_codigo_motivo_ocorrencia('19', '17', 400).must_equal 'C119' }  # Débito automático
			it { subject.get_codigo_motivo_ocorrencia('31', '101', 400).must_equal 'C131' }  # Liquidado anteriormente
			it { subject.get_codigo_motivo_ocorrencia('32', '102', 400).must_equal 'C132' }  # Habilitado em processo
			it { subject.get_codigo_motivo_ocorrencia('33', '103', 400).must_equal 'C133' }  # Incobrável por nosso intermédio
			it { subject.get_codigo_motivo_ocorrencia('34', '45', 400).must_equal 'C134' }  # Transferido para créditos em liquidação
			it { subject.get_codigo_motivo_ocorrencia('46', '17', 400).must_equal 'C46' }   # Por alteração da variação
			it { subject.get_codigo_motivo_ocorrencia('47', '09', 400).must_equal 'C47' }   # Por alteração da variação
			it { subject.get_codigo_motivo_ocorrencia('51', '06', 400).must_equal 'C51' }   # Acerto
			it { subject.get_codigo_motivo_ocorrencia('90', '10', 400).must_equal 'C90' }   # Baixa automática

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

		context "CÓDIGOS motivo ocorrencia do Banco do Brasil para CNAB 400 com Código de Movimento 72" do
			it { subject.get_codigo_motivo_ocorrencia('00', '72', 400).must_equal 'D00'  } # Transferência de título de cobrança simples para descontada ou vice-versa
			it { subject.get_codigo_motivo_ocorrencia('52', '72', 400).must_equal 'D52' }  # Reembolso de título vendor ou descontado, quando ocorrerem reembolsos de títulos por falta de liquidação. Não há migração de carteira descontada para simples.
		end
end