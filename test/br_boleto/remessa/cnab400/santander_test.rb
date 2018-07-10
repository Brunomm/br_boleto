require 'test_helper'

describe BrBoleto::Remessa::Cnab400::Santander do
	subject { FactoryBot.build(:remessa_cnab400_santander, pagamentos: pagamento, conta: conta) }
	let(:pagamento) { FactoryBot.build(:remessa_pagamento, pagador: pagador) }
	let(:conta)     { FactoryBot.build(:conta_santander) }
	let(:pagador)   { FactoryBot.build(:pagador) }

	it "deve ter a class para a conta do santander" do
		BrBoleto::Remessa::Cnab400::Santander.new.conta_class.must_equal BrBoleto::Conta::Santander
	end

	it "deve herdar de Cnab400::Base" do
		subject.class.superclass.must_equal BrBoleto::Remessa::Cnab400::Base
	end

	describe '#informacoes_da_conta' do
		it "deve retornar com 20 caracteres" do
			subject.informacoes_da_conta(:header).size.must_equal 20
		end
		it "deve trazer as informações em suas posições quando o parametro for :header" do
			conta.codigo_transmissao           = 1234
			result = subject.informacoes_da_conta(:header)
			result.must_equal    '00000000000000001234'    # codigo_transmissao
		end

		it "deve retornar com 20 caracteres" do
			subject.informacoes_da_conta(:detalhe).size.must_equal 20
		end
		it "deve trazer as informações em suas posições quando o parametro for :detalhe" do
			conta.codigo_transmissao           = 1234
			result = subject.informacoes_da_conta(:detalhe)
			result.must_equal    '00000000000000001234'    # codigo_transmissao
		end
	end

	describe '#complemento_registro' do
		it "deve retornar as informações corretas do complemento_registro" do
			subject.complemento_registro[0..15].must_equal ''.rjust(16, '0')
			subject.complemento_registro[16..290].must_equal ''.rjust(275)
			subject.complemento_registro[291..293].must_equal ''.rjust(3, '0')
			subject.complemento_registro.size.must_equal 294
		end
	end


	describe '#detalhe_posicao_077_108' do
		it "deve ter o tamanho de 14 digitos" do
			subject.detalhe_posicao_063_076(pagamento, '1').size.must_equal 14
		end
		it "deve conter as informações nas posições corretas" do
			pagamento.assign_attributes(nosso_numero: 763)

			result = subject.detalhe_posicao_063_076(pagamento, '1')

			result[0..7].must_equal    '00000763'         # Numero documento
			result[8..13].must_equal   ('0' * 6)          # Zeros

			result.size.must_equal 14
		end
	end

	describe '#detalhe_posicao_077_108' do
		it "deve ter o tamanho de 32 digitos" do
			subject.detalhe_posicao_077_108(pagamento, '1').size.must_equal 32
		end
		it "deve conter as informações nas posições corretas" do
			conta.carteira           = 123
			conta.codigo_carteira    = 1
			pagamento.assign_attributes(tipo_emissao: 2)

			result = subject.detalhe_posicao_077_108(pagamento, '1')

			result[0..0].must_equal  ' '                # Branco
			result[1..1].must_equal  '0'                # Codigo Multa
			result[2..5].must_equal  '0000'             # Percentual Multa
			result[6..7].must_equal  '00'               # Zeros
			result[8..20].must_equal  ('0' * 13)        # Zeros
			result[21..24].must_equal  (' ' * 4)        # Brancos
			result[25..30].must_equal  ('0' * 6)        # Data Multa
			result[31].must_equal      '1'              # Cod. Carteira

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

			result[00..05].must_equal '050829'        # "Data Vencimento: Formato DDMMAA Normal ""DDMMAA"" A vista = ""888888"" Contra Apresentação = ""999999"""
			result[06..18].must_equal '0000000004756' # Valor do Titulo
			result[19..21].must_equal '033'           # Número Banco
			result[22..26].must_equal "00000"         # 000000 ou Agencia
			result[27..28].must_equal "02"            # Espécie do Título
			result[  29  ].must_equal "N"             # dentificação (Sempre 'N')
			result[30..35].must_equal '150917'        # Data de Emissão do Título: formato ddmmaa
			result[36..37].must_equal '00'            # Primeira instrução codificada
			result[38..39].must_equal '00'            # Segunda instrução
		end
	end

	describe '#detalhe_multas_e_juros_do_pagamento' do
		it "deve ter o tamanho de 58 digitos" do
			subject.detalhe_multas_e_juros_do_pagamento(pagamento, 2).size.must_equal 58
		end
		it "deve conter as informações nas posições corretas" do
			pagamento.valor_juros = '0.39'
			pagamento.valor_iof = '2.7'
			pagamento.data_desconto = Date.parse('21/03/2018')
			pagamento.valor_desconto = 4.3
			pagamento.valor_abatimento = 56.47

			result = subject.detalhe_multas_e_juros_do_pagamento(pagamento, 4)
			result.size.must_equal 58

			result[00..12].must_equal '0000000000039'
			result[13..18].must_equal "210318"
			result[19..31].must_equal '0000000000430'
			result[32..44].must_equal '0000000000270'
			result[45..57].must_equal '0000000005647'
		end
	end

	describe '#informacoes_do_sacado' do
		it "deve ter o tamanho de 176 digitos" do
			subject.informacoes_do_sacado(pagamento, 2).size.must_equal 176
		end
		it "deve conter as informações nas posições corretas" do
			# pagador.tipo_cpf_cnpj =  '1'
			pagador.cpf_cnpj           =  '12345678901'
			pagador.nome               =  'nome pagador'
			pagador.endereco           =  'rua do pagador'
			pagador.bairro             =  'bairro do pagador'
			pagador.cidade             =  'Chapecó'
			pagador.uf                 =  'SC'
			pagador.cep                =  '89885-001'
			pagador.nome_avalista      =  'Avalista'
			pagador.documento_avalista =  '840.106.990-43'
			conta.conta_corrente       = 123456789
			conta.conta_corrente_dv    = 0

			result = subject.informacoes_do_sacado(pagamento, 2)
			result.size.must_equal 176

			result[00..01].must_equal "01"                                    # Tipo de Inscrição do Pagador: "01" = CPF / "02" = CNPJ
			result[02..15].must_equal '00012345678901'                        # Número do CNPJ ou CPF do Pagador
			result[16..55].must_equal 'nome pagador'.adjust_size_to(40)       # Nome do Pagador
			result[56..95].must_equal 'rua do pagador'.adjust_size_to(40)     # Endereço do Pagador
			result[96..107].must_equal 'bairro do pagador'.adjust_size_to(12) # Bairro do Pagador
			result[108..115].must_equal '89885001'                            # CEP do Pagador
			result[116..130].must_equal 'Chapecó'.adjust_size_to(15)          # Cidade do Pagador
			result[131..132].must_equal 'SC'.adjust_size_to(2)                # UF do Pagador
			result[133..162].must_equal 'Avalista'.adjust_size_to(30)         # Nome Sacador/Avalista

			result[163..163].must_equal ' '                                   # Complemento Registro (Brancos)
			result[164..164].must_equal 'I'                                   # Identificador do Complemento (I)
			result[165..166].must_equal '90'                                  # Complemento remessa
			result[167..172].must_equal (' ' * 6)                             # Brancos
			result[173..174].must_equal '00'                                  # Quantidade de dias (Zeros)
			result[175].must_equal      ' '                                   # Complemento Registro (Branco)
		end
	end

	describe "#trailer_arquivo_posicao_002_a_394" do
		it "deve conter as informações nas posições corretas" do
			result = subject.trailer_arquivo_posicao_002_a_394(2)

			result[00..05].must_equal "000002"                               # Quantidade total de linhas no arquivo
			result[06..18].must_equal '0000000010012'                        # Valor total dos títulos
			result[19..392].must_equal ('0' * 374)                           # Zeros

			result.size.must_equal 393
		end
	end
end
