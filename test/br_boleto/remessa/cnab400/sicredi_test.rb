require 'test_helper'

describe BrBoleto::Remessa::Cnab400::Sicredi do
	subject { FactoryGirl.build(:remessa_cnab400_sicredi, pagamentos: pagamento, conta: conta) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento, pagador: pagador) } 
	let(:conta)     { FactoryGirl.build(:conta_sicredi) } 
	let(:pagador)   { FactoryGirl.build(:pagador) } 


	context "HEADER" do
		describe "#header_posicao_002_a_002" do
			it { subject.header_posicao_002_a_002.size.must_equal 1 }
			it "deve conter as informações nas posições corretas" do
				result = subject.header_posicao_002_a_002
				result.must_equal   '1'
			end

		end

		describe '#informacoes_da_conta' do
			it "deve retornar com 20 caracteres" do
				subject.informacoes_da_conta(:header).size.must_equal 20
			end
			it "deve trazer as informações em suas posições quando o parametro for :header" do
				conta.conta_corrente    = 89755
				conta.cpf_cnpj          = '12345678901'
				result = subject.informacoes_da_conta(:header)

				result[0..4].must_equal  '89755'         # Conta Corrente
				result[5..18].must_equal '00012345678901'  # CPF/CNPJ
				result[19].must_equal    ''.rjust(1)       # Branco
				
				result.size.must_equal 20
			end
			it "deve retornar com 21 caracteres" do
				subject.informacoes_da_conta(:detalhe).size.must_equal 21
			end
			it "deve trazer as informações em suas posições quando o parametro for :detalhe" do
				result = subject.informacoes_da_conta(:detalhe)

				result[0].must_equal      'A'            # Tipo de moeda
				result[1].must_equal      'B'            # Tipo de desconto
				result[2].must_equal      'B'            # Tipo de juros
				result[3..20].must_equal  ''.rjust(18)   # Brancos

				result.size.must_equal 21
			end
		end

		describe "#header_posicao_047_a_076" do
			it { subject.header_posicao_047_a_076.size.must_equal 30 }
			it "deve conter as informações nas posições corretas" do
				result = subject.header_posicao_047_a_076
				result.must_equal   ''.rjust(30)    # Brancos
				result.size.must_equal 30
			end
		end

		describe '#header_posicao_095_a_102' do
			it { subject.header_posicao_095_a_102.size.must_equal 8 }
			it "deve conter as informações nas posições corretas" do
				subject.stubs(:data_hora_arquivo).returns('2016-10-21')
				subject.header_posicao_095_a_102.must_equal '20161021'
				subject.header_posicao_095_a_102.size.must_equal 8
			end
		end

		describe '#header_posicao_103_a_394' do
			it { subject.header_posicao_103_a_394.size.must_equal 292 }
			it "deve conter as informações nas posições corretas" do
				subject.sequencial_remessa = 4758

				subject.header_posicao_103_a_394[0..7].must_equal ''.rjust(8)
				subject.header_posicao_103_a_394[8..14].must_equal '0004758'
				subject.header_posicao_103_a_394[15..287].must_equal ''.rjust(273) 
				subject.header_posicao_103_a_394[288..291].must_equal '2.00'

				subject.header_posicao_103_a_394.size.must_equal 292
			end
		end
	end

	context "DETALHE" do
		describe "#detalhe_posicao_002_004(pagamento)" do
			it { subject.detalhe_posicao_002_004(pagamento).size.must_equal 3 }
			it "deve conter as informações nas posições corretas" do
				result = subject.detalhe_posicao_002_004(pagamento)
				result[0].must_equal   'A'   # Tipo de cobrança
				result[1].must_equal   'A'   # Tipo de carteira
				result[2].must_equal   'A'   # Tipo de Impressão

				result.size.must_equal 3
			end
		end

		describe "#detalhe_posicao_005_016" do
			it { subject.detalhe_posicao_005_016.size.must_equal 12 }
			it "deve conter as informações nas posições corretas" do
				result = subject.detalhe_posicao_005_016
				result.must_equal   ''.rjust(12)    # Brancos
				result.size.must_equal 12
			end
		end

		describe "#detalhe_posicao_038_062(pagamento)" do
			it "deve ter o tamanho de 25 digitos" do
				subject.detalhe_posicao_038_062(pagamento).size.must_equal 25
			end
			it "deve conter as informações nas posições corretas" do
				pagamento.assign_attributes(nosso_numero: '132')
				result = subject.detalhe_posicao_038_062(pagamento)
				result[0..9].must_equal    ''.rjust(10)    # Brancos
				result[10..18].must_equal  '000000132'     # Nosso Numero
				result[19..24].must_equal  ''.rjust(6)     # Brancos
				result.size.must_equal 25
			end
		end

		describe "#detalhe_posicao_063_108(pagamento)" do
			it "deve ter o tamanho de 46 digitos" do
				subject.detalhe_posicao_063_108(pagamento).size.must_equal 46
			end
			it "deve conter as informações nas posições corretas" do
				pagamento.assign_attributes(tipo_emissao: 2)
				pagamento.data_emissao = Date.parse('05/08/2029')
				result = subject.detalhe_posicao_063_108(pagamento)
				result[0..7].must_equal    '20290805'     # Data da Instrução
				result[8].must_equal       ''.rjust(1)    # Campo alterado ( Branco )
				result[9].must_equal       'N'            # Postagem do título
				result[10].must_equal      ''.rjust(1)    # Branco
				result[11].must_equal      'B'            # Condição para Emissão da Papeleta de Cobrança
				result[12..13].must_equal  ''.rjust(2)    # Número da parcela do carnê ( Brancos )
				result[14..15].must_equal  ''.rjust(2)    # Número Total de parcelas do carnê ( Brancos )
				result[16..19].must_equal  ''.rjust(4)    # Brancos
				result[20..29].must_equal  '0000000000'   # Valor Desconto por dia de antecipação (Preencher com Zeros)
				result[30..33].must_equal  '0000'         # % multa por pagamento em atraso (Preencher com Zeros)
				result[34..45].must_equal  ''.rjust(12)   # Preencher com Branco
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
				result[00..05].must_equal '050829'        # "Data Vencimento: Formato DDMMAA Normal ""DDMMAA"" A vista = ""888888"" Contra Apresentação = ""999999"""
				result[06..18].must_equal '0000000004756' # Valor do Titulo 
				result[19..27].must_equal '         '     # Brancos
				result[28..28].must_equal "C"             # Espécie do Título
				result[  29  ].must_equal "N"             # dentificação (Sempre 'N')
				result[30..35].must_equal '150917'        # Data de Emissão do Título: formato ddmmaa
				result[36..37].must_equal '00'            # Primeira instrução codificada
				result[38..39].must_equal '00'            # Segunda instrução

				result.size.must_equal 40
			end
		end
		
		describe '#detalhe_multas_e_juros_do_pagamento' do
			it "deve ter o tamanho de 58 digitos" do
				subject.detalhe_multas_e_juros_do_pagamento(pagamento, 2).size.must_equal 58
			end
			it "deve conter as informações nas posições corretas" do
				pagamento.valor_mora = '0.39'
				pagamento.data_desconto = Date.parse('21/03/2018')
				pagamento.valor_desconto = 4.3
				pagamento.valor_abatimento = 56.47

				result = subject.detalhe_multas_e_juros_do_pagamento(pagamento, 4)
				result.size.must_equal 58

				result[00..12].must_equal '0000000000039'
				result[13..18].must_equal "210318"
				result[19..31].must_equal '0000000000430'
				result[32..44].must_equal '0000000000000'
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

				result[00..01].must_equal "10"                                    # Tipo de Inscrição do Pagador: "01" = CPF / "02" = CNPJ
				result[02..15].must_equal '00012345678901'                        # Número do CNPJ ou CPF do Pagador
				result[16..55].must_equal 'nome pagador'.adjust_size_to(40)       # Nome do Pagador
				
				result[56..73].must_equal 'rua do pagador'.adjust_size_to(18)     # Endereço do Pagador
				result[74..83].must_equal 'bairro do pagador'.adjust_size_to(10)  # Endereço do Pagador
				result[84..93].must_equal 'Chapecó'.adjust_size_to(10)            # Endereço do Pagador
				result[94..95].must_equal 'SC'.adjust_size_to(2)                  # Endereço do Pagador
				result[108..115].must_equal '89885001'                            # CEP do Pagador

				result[121..134].must_equal '84010699043'.rjust(14, '0')          # Observações/Mensagem ou Sacador/Avalista
				result[135..175].must_equal 'Avalista'.adjust_size_to(41)         # Observações/Mensagem ou Sacador/Avalista
			end
		end
	end

	context "TRAILER" do
		describe "#trailer_arquivo_posicao_002_a_394(sequencial)" do
			it { subject.trailer_arquivo_posicao_002_a_394(1).size.must_equal 393 }
			it "deve conter as informações nas posições corretas" do
				conta.conta_corrente    = 89755
				result = subject.trailer_arquivo_posicao_002_a_394(1)

				result[0].must_equal      '1'             # Identificação do arquivo remessa
				result[1..3].must_equal   '748'           # Número do Sicredi
				result[4..8].must_equal   '89755'         # Código do beneficiário
				result[9..392].must_equal  ''.rjust(384)  # Brancos

				result.size.must_equal 393
			end
		end
	end

end