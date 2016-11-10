require 'test_helper'

describe BrBoleto::Remessa::Cnab400::Itau do
	subject { FactoryGirl.build(:remessa_cnab400_itau, pagamentos: pagamento, conta: conta) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento, pagador: pagador) } 
	let(:conta)     { FactoryGirl.build(:conta_itau) } 
	let(:pagador)   { FactoryGirl.build(:pagador) } 
	
	it "deve ter a class para a conta do itau" do
		BrBoleto::Remessa::Cnab400::Itau.new.conta_class.must_equal BrBoleto::Conta::Itau
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
			conta.agencia_dv        = 1
			conta.conta_corrente    = 89755
			conta.conta_corrente_dv = 7

			result = subject.informacoes_da_conta(:header)

			result[0..3].must_equal    '1234'    # Agencia
			result[4..5].must_equal    '00'  
			result[6..10].must_equal   '89755'    # Conta Corrente
			result[11].must_equal      '7'        # Conta Corrente DV
			result[12..19].must_equal   ' ' * 8


		end
		it "deve retornar com 20 caracteres" do
			subject.informacoes_da_conta(:detalhe).size.must_equal 20
		end
		it "deve trazer as informações em suas posições quando o parametro for :detalhe" do
			conta.agencia           = 1234
			conta.agencia_dv        = 1
			conta.conta_corrente    = 89755
			conta.conta_corrente_dv = 7

			result = subject.informacoes_da_conta(:detalhe)

			result[0..3].must_equal    '1234'    # Agencia
			result[4..5].must_equal    '00'  
			result[6..10].must_equal   '89755'    # Conta Corrente
			result[11].must_equal      '7'        # Conta Corrente DV
			result[12..15].must_equal   '    '
			result[16..19].must_equal   '0000'

		end
	end

	describe '#complemento_registro' do
		it "deve retornar 294 brancos" do
			subject.complemento_registro[0..293].must_equal ''.rjust(294) 
			subject.complemento_registro.size.must_equal 294
		end
	end


	describe '#detalhe_posicao_063_108' do
		it "deve ter o tamanho de 46 digitos" do
			subject.detalhe_posicao_063_108(pagamento).size.must_equal 46
		end
		it "deve conter as informações nas posições corretas" do
			conta.carteira           = 123
			pagamento.assign_attributes(tipo_emissao: 2)
			pagamento.assign_attributes(numero_documento: 763)

			result = subject.detalhe_posicao_063_108(pagamento)

			result[0..7].must_equal   '00000763'          # Numero documento                 
			result[8..20].must_equal  '0' * 13            # Zeros
			result[21..23].must_equal '123'               # Carteira
			result[24..44].must_equal ' ' * 21            # Brancos
			result[45].must_equal     'I'                 # Cod. Carteira

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
			result[19..21].must_equal '341'           # Número Banco
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
			
			result[56..95].must_equal 'rua do pagador'.adjust_size_to(40)     # Endereço do Pagador
			result[96..107].must_equal 'bairro do pagador'.adjust_size_to(12) # Bairro do Pagador
			result[108..115].must_equal '89885001'                            # CEP do Pagador
			result[116..130].must_equal 'Chapecó'.adjust_size_to(15)          # Cidade do Pagador
			result[131..132].must_equal 'SC'.adjust_size_to(2)                # UF do Pagador

			result[133..162].must_equal 'Avalista'.adjust_size_to(30)         # Nome Sacador/Avalista

			result[163..166].must_equal '    '                                # Complemento Registro (Brancos)
			result[167..172].must_equal '000000'                              # Data de mora (Zeros)
			result[173..174].must_equal '03'                                  # Quantidade de dias (Zeros)
			result[175].must_equal      ' '                                   # Complemento Registro (Branco)
		end
	end
end