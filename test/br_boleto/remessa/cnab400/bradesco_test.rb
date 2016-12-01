require 'test_helper'

describe BrBoleto::Remessa::Cnab400::Bradesco do
	subject { FactoryGirl.build(:remessa_cnab400_bradesco, pagamentos: pagamento, conta: conta) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento, pagador: pagador) } 
	let(:conta)     { FactoryGirl.build(:conta_bradesco) } 
	let(:pagador)   { FactoryGirl.build(:pagador) } 
	
	it "deve ter a class para a conta do bradesco" do
		BrBoleto::Remessa::Cnab400::Bradesco.new.conta_class.must_equal BrBoleto::Conta::Bradesco
	end

	it "deve herdar de Cnab400::Base" do
		subject.class.superclass.must_equal BrBoleto::Remessa::Cnab400::Base
	end

	describe '#informacoes_da_conta' do
		it "deve retornar com 20 caracteres" do
			subject.informacoes_da_conta(:header).size.must_equal 20
		end
		it "deve trazer as informações em suas posições quando o parametro for :header" do
			conta.codigo_empresa = 39321235
			result = subject.informacoes_da_conta(:header)

			result[0..20].must_equal  '00000000000039321235'  # Codigo Empresa
		end
		it "deve retornar com 20 caracteres" do
			subject.informacoes_da_conta(:detalhe).size.must_equal 20
		end
		it "deve trazer as informações em suas posições quando o parametro for :detalhe" do
			conta.agencia           = 1234
			conta.agencia_dv        = 1
			conta.conta_corrente    = 89755
			conta.conta_corrente_dv = 7
			conta.carteira          = 21
			result = subject.informacoes_da_conta(:detalhe)

			result[0..2].must_equal    '   '
			result[3].must_equal       '0'  
			result[4..6].must_equal    '021'  
			result[7..11].must_equal   '01234'    # Agencia
			result[12..18].must_equal  '0089755'  # Conta Corrente
			result[19].must_equal      '7'        # Conta Corrente DV
		end
	end

	describe '#complemento_registro' do
		it "deve retornar o sequencial da remessa com 12 posições e mais 277 brancos" do
			subject.sequencial_remessa = 4758

			subject.complemento_registro[0..7].must_equal '        '
			subject.complemento_registro[8..9].must_equal 'MX'
			subject.complemento_registro[10..16].must_equal '0004758'
			subject.complemento_registro[17..293].must_equal ''.rjust(277) 

			subject.complemento_registro.size.must_equal 294
		end
	end

	it '#detalhe_posicao_002_003 - deve retornar brancos' do
		subject.detalhe_posicao_002_003(pagamento).must_equal (' ' * 2)
	end

	it '#detalhe_posicao_004_017 - deve retornar brancos' do
		subject.detalhe_posicao_004_017.must_equal (' ' * 14)
	end

	describe '#detalhe_posicao_063_108' do
		it "deve ter o tamanho de 46 digitos" do
			subject.detalhe_posicao_063_108(pagamento).size.must_equal 46
		end
		it "deve conter as informações nas posições corretas" do
			pagamento.assign_attributes(tipo_emissao: 2)
			result = subject.detalhe_posicao_063_108(pagamento)

			result[0..2].must_equal   '000'                 
			result[3].must_equal      '0'                  # Identificativos de Multa
			result[4..7].must_equal   '0000'               # Percentual de Multa por Atraso
			result[8..18].must_equal  '00000977897'        # Identificação do Título no Banco
			result[19].must_equal     '6'                  # Nosso numero DV
			result[20..29].must_equal '0000000000'         # Desconto Bonificação por dia
			result[30].must_equal     '2'                  # Condição para Emissão da Papeleta de Cobrança
			result[31..45].must_equal ''.rjust(15)         # Preencher com Branco

			result.size.must_equal 46
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
			result[19..21].must_equal '000'           # 000 ou Número Banco
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
			pagamento.valor_mora = '0.39'
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

			result = subject.informacoes_do_sacado(pagamento, 2)
			result.size.must_equal 176

			result[00..01].must_equal "01"                                    # Tipo de Inscrição do Pagador: "01" = CPF / "02" = CNPJ
			result[02..15].must_equal '00012345678901'                        # Número do CNPJ ou CPF do Pagador
			result[16..55].must_equal 'nome pagador'.adjust_size_to(40)       # Nome do Pagador
			
			result[56..73].must_equal 'rua do pagador'.adjust_size_to(18)     # Endereço do Pagador
			result[74..83].must_equal 'bairro do pagador'.adjust_size_to(10)  # Endereço do Pagador
			result[84..93].must_equal 'Chapecó'.adjust_size_to(10)            # Endereço do Pagador
			result[94..95].must_equal 'SC'.adjust_size_to(2)                  # Endereço do Pagador
			result[108..115].must_equal '89885001'                            # CEP do Pagador

			result[116..129].must_equal '84010699043'.adjust_size_to(14)      # Observações/Mensagem ou Sacador/Avalista
			result[130..175].must_equal 'Avalista'.adjust_size_to(46)         # Observações/Mensagem ou Sacador/Avalista
		end
	end
end