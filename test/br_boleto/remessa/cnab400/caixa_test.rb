require 'test_helper'

describe BrBoleto::Remessa::Cnab400::Caixa do
	subject { FactoryBot.build(:remessa_cnab400_caixa, pagamentos: pagamento, conta: conta) }
	let(:pagamento) { FactoryBot.build(:remessa_pagamento, pagador: pagador) }
	let(:conta)     { FactoryBot.build(:conta_caixa) }
	let(:pagador)   { FactoryBot.build(:pagador) }

	it "deve ter a class para a conta do Caixa" do
		BrBoleto::Remessa::Cnab400::Caixa.new.conta_class.must_equal BrBoleto::Conta::Caixa
	end

	it "deve herdar de Cnab400::Base" do
		subject.class.superclass.must_equal BrBoleto::Remessa::Cnab400::Base
	end

	describe '#informacoes_da_conta' do
		it "deve retornar com 20 caracteres" do
			subject.informacoes_da_conta(:header).size.must_equal 20
		end
		it "deve trazer as informações em suas posições quando o parametro for :header" do
			conta.agencia           = 1234
			conta.convenio          = 89755
			conta.carteira          = 21
			result = subject.informacoes_da_conta(:header)

			result[0..3].must_equal    '1234'      # Agência
			result[4..9].must_equal   '089755'     # Convênio
			result[10..19].must_equal  (' ' * 10)  # Brancos
		end
	end

	describe '#complemento_registro' do
		it "deve retornar o sequencial da remessa com 5 posições e mais 389 brancos" do
			subject.sequencial_remessa = 4758

			subject.complemento_registro[0..288].must_equal ''.rjust(289)
			subject.complemento_registro[289..393].must_equal '04758'

			subject.complemento_registro.size.must_equal 294
		end
	end

	describe "#detalhe_posicao_028_058" do
		it "deve retornar com 31 caracteres" do
			subject.detalhe_posicao_028_058(pagamento).size.must_equal 31
		end
		it "deve trazer as informações em suas posições corretas" do
			pagamento.assign_attributes(emissao_boleto: 1)
			pagamento.assign_attributes(distribuicao_boleto: 2)
			pagamento.numero_documento    = '255'
			conta.carteira                = '99'

			result = subject.detalhe_posicao_028_058(pagamento)

			result[0].must_equal    '1'                    # Identificação da Emissão do Boleto
			result[1].must_equal    '2'                    # ID Entrega/Distribuição do Boleto
			result[2..3].must_equal  '00'                  # Comissão de Permanência (Informar '00')
			result[4..28].must_equal '255'.rjust(25, '0')  # Número do Documento
			result[29..30].must_equal '99'                 # Carteira
		end
	end

	describe "#dados_do_pagamento" do
		it "deve retornar com 18 caracteres" do
			subject.dados_do_pagamento(pagamento).size.must_equal 18
		end
		it "deve trazer as informações em suas posições corretas" do
			pagamento.numero_documento    = '255'

			result = subject.dados_do_pagamento(pagamento)

			result[0..14].must_equal '255'.rjust(15, '0')  # Número do Documento
			result[15..17].must_equal (' ' * 3)            # Brancos
		end
	end

	describe '#detalhe_posicao_077_108' do
		it "deve ter o tamanho de 32 digitos" do
			subject.detalhe_posicao_077_108(pagamento, '1').size.must_equal 32
		end
		it "deve conter as informações nas posições corretas" do
			conta.codigo_carteira = '5'
			result = subject.detalhe_posicao_077_108(pagamento, '1')

			result[0..29].must_equal   (' ' * 30)   # Brancos
			result[30..31].must_equal '05'           # Código da Carteira

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
			pagamento.assign_attributes(codigo_protesto: 2)
			pagamento.data_vencimento = Date.parse('05/08/2029')
			pagamento.valor_documento = 47.56
			pagamento.especie_titulo  = "12"
			pagamento.aceite = true
			pagamento.data_emissao = Date.parse('15/09/2017')
			result = subject.informacoes_do_pagamento(pagamento, 4)
			result.size.must_equal 40

			result[00..05].must_equal '050829'        # "Data Vencimento: Formato DDMMAA Normal ""DDMMAA"" A vista = ""888888"" Contra Apresentação = ""999999"""
			result[06..18].must_equal '0000000004756' # Valor do Titulo
			result[19..21].must_equal '104'           # Número Banco
			result[22..26].must_equal "00000"         # 000000 ou Agencia
			result[27..28].must_equal "02"            # Espécie do Título
			result[  29  ].must_equal "N"             # dentificação (Sempre 'N')
			result[30..35].must_equal '150917'        # Data de Emissão do Título: formato ddmmaa
			result[36..37].must_equal '02'            # Primeira instrução codificada
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
			pagador.cpf_cnpj           =  '12345678901'
			pagador.nome               =  'nome pagador'
			pagador.endereco           =  'rua do pagador'
			pagador.bairro             =  'bairro do pagador'
			pagador.cidade             =  'Chapecó'
			pagador.uf                 =  'SC'
			pagador.cep                =  '89885-001'
			pagador.nome_avalista      =  'Avalista'

			pagamento.data_multa   = Date.parse('28/12/2020')
			pagamento.valor_multa  = 150.3
			pagamento.codigo_moeda = '0'
			pagamento.assign_attributes(dias_protesto: 30)

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

			result[133..138].must_equal '281220'.adjust_size_to(6)            # Data Multa
			result[139..148].must_equal '15030'.rjust(10, '0')                # Valor Multa
			result[149..170].must_equal 'Avalista'.adjust_size_to(22)         # Nome Sacador/Avalista

			result[171..172].must_equal '00'                                  # 3a instrução
			result[173..174].must_equal '30'                                  # Dias para protesto
			result[175].must_equal      '0'                                   # Código da Moeda
		end
	end
end
