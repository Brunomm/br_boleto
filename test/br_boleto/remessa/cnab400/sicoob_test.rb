require 'test_helper'

describe BrBoleto::Remessa::Cnab400::Sicoob do
	subject { FactoryGirl.build(:remessa_cnab400_sicoob, pagamentos: pagamento, conta: conta) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento, pagador: pagador) } 
	let(:conta)     { FactoryGirl.build(:conta_sicoob) } 
	let(:pagador)   { FactoryGirl.build(:pagador) } 
	
	it "deve ter a class para a conta do sicoob" do
		BrBoleto::Remessa::Cnab400::Sicoob.new.conta_class.must_equal BrBoleto::Conta::Sicoob
	end

	it "deve herdar de Cnab400::Base" do
		subject.class.superclass.must_equal BrBoleto::Remessa::Cnab400::Base
	end

	describe '#informacoes_da_conta' do
		it "deve retornar com 20 caracteres" do
			subject.informacoes_da_conta(:detalhe).size.must_equal 20
		end
		it "deve trazer as informações em suas posições quando o parametro for :detalhe" do
			conta.agencia           = 1234
			conta.agencia_dv        = 1
			conta.codigo_cedente    = 123456
			conta.codigo_cedente_dv = 2
			result = subject.informacoes_da_conta(:detalhe)

			result[0..3].must_equal   '1234'    # Agencia
			result[4].must_equal      '1'       # DV Agencia
			result[5..12].must_equal  '00123456'# DV Agencia
			result[13].must_equal     '2'       # DV Agencia
			result[14..19].must_equal '000000'
		end
		it "deve trazer as informações em suas posições quando o parametro for :header" do
			conta.agencia           = 3321
			conta.agencia_dv        = 3
			conta.codigo_cedente    = 1234567890123
			conta.codigo_cedente_dv = 2
			result = subject.informacoes_da_conta(:header)

			result[0..3].must_equal   '3321'    # Agencia
			result[4].must_equal      '3'       # DV Agencia
			result[5..12].must_equal  '12345678'# DV Agencia
			result[13].must_equal     '2'       # DV Agencia
			result[14..19].must_equal '      '
		end
	end

	describe '#complemento_registro' do
		it "deve retornar o sequencial da remessa com 7 posições e mais 287 brancos" do
			subject.sequencial_remessa = 4758
			subject.complemento_registro.size.must_equal 294
			subject.complemento_registro.must_equal '0004758'.ljust(294, ' ') 
		end
	end

	describe '#dados_do_pagamento' do
		it "deve ter o tamanho de 14 digitos" do
			subject.dados_do_pagamento(pagamento).size.must_equal 14
		end
		it "deve retornar os nosso numero e a parcela" do
			pagamento.assign_attributes(nosso_numero: 4578, parcela: 3)
			result = subject.dados_do_pagamento(pagamento)
			result[0..11].must_equal '000000004578'
			result[12..13].must_equal '03'
		end
	end

	describe '#detalhe_posicao_077_108' do
		it "deve ter o tamanho de 32 digitos" do
			subject.detalhe_posicao_077_108(pagamento, 4).size.must_equal 32
		end
		it "deve conter as informações nas posições corretas" do
			pagamento.assign_attributes(tipo_emissao: 2)
			subject.conta.modalidade = '0333333'
			result = subject.detalhe_posicao_077_108(pagamento, 4)
			result[0..1].must_equal '00'               # 077  078  002  9(02)  Grupo de V
			result[2..4].must_equal ''.rjust(3, ' ')   # 079  081  003  X(03)  Complement
			result[5].must_equal ' '                # 082  082  001  X(01)  "Indicativ
			result[6..8].must_equal ''.rjust(3, ' ')   # 083  085  003  X(03)  Prefixo do
			result[9..11].must_equal '000'              # 086  088  003  9(03)  Variação d
			result[12].must_equal '0'                # 089  089  001  9(01)  Conta Cauç
			result[13..17].must_equal ''.rjust(5, '0')   # 090  094  005  9(05)  "Número do
			result[18].must_equal '0'                # 095  095  001  X(01)  "DV do con
			result[19..24].must_equal ''.rjust(6, '0')   # 096  101  006  9(06)  Numero do 
			result[25..28].must_equal ''.rjust(4, ' ')   # 102  105  004  X(04)  Complement
			result[29].must_equal     "2" #  tipo_emissao
			result[30..31].must_equal '03' #modalidade
			result.size.must_equal 32
		end
	end

	describe '#informacoes_do_pagamento' do
		it "deve ter o tamanho de 40 digitos" do
			subject.informacoes_do_pagamento(pagamento, 1).size.must_equal 40
		end
		it "deve conter as informações nas posições corretas" do
			conta.agencia    = 4587
			conta.agencia_dv = 45 # Vai retornar apenas o 4
			pagamento.data_vencimento = Date.parse('05/08/2029')
			pagamento.valor_documento = 47.56
			pagamento.especie_titulo  = "12"
			pagamento.aceite = true
			pagamento.data_emissao = Date.parse('15/09/2017')
			result = subject.informacoes_do_pagamento(pagamento, 4)
			result.size.must_equal 40

			result[00..05].must_equal '050829' # "Data Vencimento: Formato DDMMAA Normal ""DDMMAA"" A vista = ""888888"" Contra Apresentação = ""999999"""
			result[06..18].must_equal '0000000004756' # Valor do Titulo 
			result[19..21].must_equal '756' # Número Banco: "756"
			result[22..25].must_equal "4587" # Prefixo da Cooperativa: vide e-mail enviado com os dados do processo de homologação
			result[  26  ].must_equal "4" # Dígito Verificador do Prefixo: vide e-mail enviado com os dados do processo de homologação
			result[27..28].must_equal "02" # Espécie do Título
			result[  29  ].must_equal "1" # "Aceite do Título:  "0" = Sem aceite "1" = Com aceite"
			result[30..35].must_equal '150917' # Data de Emissão do Título: formato ddmmaa
			result[36..37].must_equal '00' # Primeira instrução codificada:
			result[38..39].must_equal '00' # Segunda instrução: vide SEQ 33
		end
	end

	describe '#detalhe_multas_e_juros_do_pagamento' do
		it "deve ter o tamanho de 58 digitos" do
			subject.detalhe_multas_e_juros_do_pagamento(pagamento, 2).size.must_equal 58
		end
		it "deve conter as informações nas posições corretas" do
			pagamento.expects(:percentual_juros_formatado).with(6).returns('025000')
			pagamento.expects(:percentual_multa_formatado).with(6).returns('045000')
			pagamento.tipo_emissao = '2'
			pagamento.data_desconto = Date.parse('21/03/2018')
			pagamento.valor_desconto = 4.3
			pagamento.codigo_moeda = 9
			pagamento.valor_abatimento = 56.47

			result = subject.detalhe_multas_e_juros_do_pagamento(pagamento, 4)
			result.size.must_equal 58

			result[00..05].must_equal '025000'
			result[06..11].must_equal '045000'
			result[  12  ].must_equal "2"
			result[13..18].must_equal "210318"
			result[19..31].must_equal '0000000000430'
			result[  32  ].must_equal "9"
			result[33..44].must_equal ''.ljust(12 ,'0')
			result[45..57].must_equal '0000000005647'
		end
	end

	describe '#informacoes_do_sacado' do
		it "deve ter o tamanho de 176 digitos" do
			subject.informacoes_do_sacado(pagamento, 2).size.must_equal 176
		end
		it "deve conter as informações nas posições corretas" do
			# pagador.tipo_cpf_cnpj =  '1'
			pagador.cpf_cnpj      =  '12345678901'
			pagador.nome          =  'nome pagador'
			pagador.endereco      =  'rua'
			pagador.bairro        =  'bairro'
			pagador.cep           =  '89885-001'
			pagador.cidade        =  'São Carlos'
			pagador.uf            =  'SC'
			pagador.nome_avalista =  'Avalista'

			result = subject.informacoes_do_sacado(pagamento, 2)
			result.size.must_equal 176

			result[00..01].must_equal "01" # "Tipo de Inscrição do Pagador: "01" = CPF / "02" = CNPJ
			result[02..15].must_equal '00012345678901' # Número do CNPJ ou CPF do Pagador
			result[16..55].must_equal 'nome pagador'.ljust(40, ' ') # Nome do Pagador
			result[56..92].must_equal 'rua'.ljust(37, ' ') # Endereço do Pagador
			result[93..107].must_equal  'bairro'.ljust(15, ' ') #  Bairro do Pagador
			result[108..115].must_equal '89885001' #  CEP do Pagador
			result[116..130].must_equal 'São Carlos'.ljust(15, ' ') #  Cidade do Pagador
			result[131..132].must_equal 'SC' # UF do Pagador
			result[133..172].must_equal 'Avalista'.ljust(40, ' ') # Observações/Mensagem ou Sacador/Avalista
			result[173..174].must_equal "00" # "Número de Dias Para Protesto: Quantidade dias para envio protesto. Se = "0", utilizar dias protesto padrão do cliente cadastrado na cooperativa
			result[  175  ].must_equal " " #  Complemento do Registro: Brancos
		end
	end
end