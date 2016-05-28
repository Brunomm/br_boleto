module BrBoleto
	module Remessa
		module Cnab240
			module Helper
				module SegmentoP
					# Monta o registro segmento P do arquivo
					#
					# @param pagamento [BrBoleto::Remessa::Pagamento]
					#   objeto contendo os detalhes do boleto (valor, vencimento, sacado, etc)
					# @param nr_lote [Integer]
					#   numero do lote que o segmento esta inserido
					# @param sequencial [Integer]
					#   numero sequencial do registro no lote
					#
					# @return [String]
					#
					def monta_segmento_p(pagamento, nr_lote, sequencial)
						# campos com * na frente nao foram implementados
						#                                                      # DESCRICAO                             TAMANHO
						segmento_p =  ''
						segmento_p <<  segmento_p_posicao_001_a_003             # codigo banco                          3
						segmento_p << segmento_p_posicao_004_a_007(nr_lote)    # lote de servico                       4
						segmento_p << segmento_p_posicao_008_a_008             # tipo de registro                      1
						segmento_p << segmento_p_posicao_009_a_013(sequencial) # num. sequencial do registro no lote   5
						segmento_p << segmento_p_posicao_014_a_014             # cod. segmento                         1
						segmento_p << segmento_p_posicao_015_a_015             # uso exclusivo                         1
						segmento_p << segmento_p_posicao_016_a_017             # cod. movimento remessa                2
						segmento_p << segmento_p_posicao_018_a_022             # agencia                               5
						segmento_p << segmento_p_posicao_023_a_023             # dv agencia                            1
						segmento_p << segmento_p_posicao_024_a_057(pagamento)  # informacoes da conta                  34
						segmento_p << segmento_p_posicao_058_a_058             # codigo da carteira                    1
						segmento_p << segmento_p_posicao_059_a_059             # forma de cadastro do titulo           1
						segmento_p << segmento_p_posicao_060_a_060             # tipo de documento                     1
						segmento_p << segmento_p_posicao_061_a_061             # identificaco emissao                  1
						segmento_p << segmento_p_posicao_062_a_062             # indentificacao entrega                1
						segmento_p << segmento_p_posicao_063_a_077(pagamento)  # numro do documento                    15
						segmento_p << segmento_p_posicao_078_a_085(pagamento)  # data de venc.                         8
						segmento_p << segmento_p_posicao_086_a_100(pagamento)  # valor documento                       15
						segmento_p << segmento_p_posicao_101_a_105             # agencia cobradora                     5
						segmento_p << segmento_p_posicao_106_a_106             # dv agencia cobradora                  1
						segmento_p << segmento_p_posicao_107_a_108             # especie do titulo                     2
						segmento_p << segmento_p_posicao_109_a_109             # aceite                                1
						segmento_p << segmento_p_posicao_110_a_117(pagamento)  # data de emissao titulo                8
						segmento_p << segmento_p_posicao_118_a_118(pagamento)  # cod. do juros                         1   *
						segmento_p << segmento_p_posicao_119_a_126(pagamento)  # data juros                            8   *
						segmento_p << segmento_p_posicao_127_a_141(pagamento)  # valor juros                           15  *
						segmento_p << segmento_p_posicao_142_a_142(pagamento)  # cod. do desconto                      1
						segmento_p << segmento_p_posicao_143_a_150(pagamento)  # data desconto                         8
						segmento_p << segmento_p_posicao_151_a_165(pagamento)  # valor desconto                        15
						segmento_p << segmento_p_posicao_166_a_180(pagamento)  # valor IOF                             15
						segmento_p << segmento_p_posicao_181_a_195(pagamento)  # valor abatimento                      15
						segmento_p << segmento_p_posicao_196_a_220(pagamento)  # identificacao titulo empresa          25  *
						segmento_p << segmento_p_posicao_221_a_221             # cod. para protesto                    1   *
						segmento_p << segmento_p_posicao_222_a_223             # dias para protesto                    2   *
						segmento_p << segmento_p_posicao_224_a_224             # cod. para baixa                       1   *
						segmento_p << segmento_p_posicao_225_a_227             # dias para baixa                       2   *
						segmento_p << segmento_p_posicao_228_a_229             # cod. da moeda                         2
						segmento_p << segmento_p_posicao_230_a_239             # uso exclusivo                         10
						segmento_p << segmento_p_posicao_240_a_240             # uso exclusivo                         1
						segmento_p.upcase
					end

					def segmento_p_posicao_001_a_003 
						codigo_banco
					end

					# Lote de Serviço: Número seqüencial para identificar univocamente um lote de serviço. 
					# Criado e controlado pelo responsável pela geração magnética dos dados contidos no arquivo.
					# Preencher com '0001' para o primeiro lote do arquivo. 
					# Para os demais: número do lote anterior acrescido de 1. O número não poderá ser repetido dentro do arquivo.
					# 4 posições
					#
					def segmento_p_posicao_004_a_007(numero_do_lote)
						numero_do_lote.to_s.rjust(4, '0')
					end

					# Tipo do registro -> Padrão 3
					# 1 posição
					#
					def segmento_p_posicao_008_a_008
						'3'
					end

					# Nº Sequencial do Registro no Lote: 
					# Número adotado e controlado pelo responsável pela geração magnética dos dados contidos no arquivo, 
					# para identificar a seqüência de registros encaminhados no lote. 
					# Deve ser inicializado sempre em '1', em cada novo lote.
					# 5 posições
					#
					def segmento_p_posicao_009_a_013(sequencial)
						sequencial.to_s.rjust(5, '0')
					end

					# Cód. Segmento do Registro - Default: "P"
					# 1 posição
					#
					def segmento_p_posicao_014_a_014
						"P"
					end

					# Uso Exclusivo FEBRABAN/CNAB
					# 1 posição
					#
					def segmento_p_posicao_015_a_015
						' '
					end

					# cod. movimento remessa -> Padrão 01 = Entrada de Titulos
					# 2 posições
					#
					def segmento_p_posicao_016_a_017
						'01'
					end

					# Agência Mantenedora da Conta 
					# 5 posições
					#
					def segmento_p_posicao_018_a_022
						agencia.to_s.rjust(5, '0')
					end

					# Dígito Verificador da Agência 
					# 1 posição
					#
					def segmento_p_posicao_023_a_023
						digito_agencia.to_s
					end

					# O padrão da FEBRABAN é: 
					#      Posição de 24 até 35 com 12 posições = Número da Conta Corrente
					#      Posição de 36 até 36 com 01 posições = DV -> Dígito Verificador da Conta 
					#      Posição de 37 até 37 com 01 posições = DV -> Dígito Verificador da Ag/Conta
					#      Posição de 38 até 57 com 20 posições = Nosso Número -> Identificação do Título no Banco
					# Mas cada banco tem seu padrão
					# 34 posições
					#
					def segmento_p_posicao_024_a_057(pagamento)
						complemento_p(pagamento)
					end

					# Código da carteira
					# 1 posição
					#
					def segmento_p_posicao_058_a_058
						codigo_carteira
					end

					# Forma de Cadastr. do Título no Banco
					# 1 posição
					#
					def segmento_p_posicao_059_a_059
						forma_cadastramento
					end

					# Tipo de Documento
					# 1 posição
					#
					def segmento_p_posicao_060_a_060
						'2'
					end

					# Identificação da Emissão do Bloqueto 
					# 1 posição
					#
					def segmento_p_posicao_061_a_061
						emissao_boleto
					end

					# Identificação da Distribuição
					# 1 posição
					#
					def segmento_p_posicao_062_a_062
						distribuicao_boleto
					end

					# Número do Documento de Cobrança 
					# Cada banco tem seu padrão
					# 15 Posições
					#
					def segmento_p_posicao_063_a_077(pagamento)
						segmento_p_numero_do_documento(pagamento)
					end

					# Data de Vencimento do Título
					# 8 posições
					#
					def segmento_p_posicao_078_a_085(pagamento)
						pagamento.data_vencimento.strftime('%d%m%Y')
					end

					# Valor Nominal do Título 
					# 15 posições (13 posições para valor inteiro e 2 posições para valor quebrado)
					#
					def segmento_p_posicao_086_a_100(pagamento)
						pagamento.valor_documento_formatado(15)
					end

					# Agencia cobradora
					# 5 posições
					#
					def segmento_p_posicao_101_a_105
						''.rjust(5, '0')
					end

					# Dígito Verificador da Agência cobradora
					# 1 posição
					#
					def segmento_p_posicao_106_a_106
						' '
					end

					# Espécie do Título
					# 2 posições
					#
					def segmento_p_posicao_107_a_108 
						especie_titulo
					end

					# Identific. de Título Aceito/Não Aceito (A ou N)
					# 1 posição
					#
					def segmento_p_posicao_109_a_109
						aceite
					end

					# Data da Emissão do Título 
					# 8 posições
					#
					def segmento_p_posicao_110_a_117(pagamento)
						pagamento.data_emissao.strftime('%d%m%Y')
					end

					# Código do Juros de Mora 
					# 1 posição
					# Padrão FEBRABAN = (1 = Valor fixo e 2 = Percentual, 3 = isento)
					#
					def segmento_p_posicao_118_a_118(pagamento) 
						cod = "#{pagamento.codigo_juros}".adjust_size_to(1, '3')
						cod.in?(['1','2','3']) ? cod : '3'
					end

					# Data do Juros de Mora 
					# 8 posições
					#
					def segmento_p_posicao_119_a_126(pagamento)
						"#{pagamento.data_juros_formatado('%d%m%Y')}".adjust_size_to(8, '0')
					end

					# Juros de Mora por Dia/Taxa 
					# 15 posições
					#
					def segmento_p_posicao_127_a_141(pagamento)
						pagamento.valor_juros_formatado(15)
					end

					# Código do Desconto 1 
					# 1 posição
					#
					def segmento_p_posicao_142_a_142(pagamento)
						pagamento.cod_desconto
					end

					# Data do Desconto 1 
					# 8 posições
					#
					def segmento_p_posicao_143_a_150(pagamento)
						pagamento.data_desconto_formatado('%d%m%Y')
					end

					# Valor/Percentual a ser Concedido 
					# 15 posições
					#
					def segmento_p_posicao_151_a_165(pagamento)
						pagamento.valor_desconto_formatado(15)
					end

					# Valor do IOF a ser Recolhido
					# 15 posições
					#
					def segmento_p_posicao_166_a_180(pagamento)
						pagamento.valor_iof_formatado(15)
					end

					# Valor do Abatimento
					# 15 posições
					#
					def segmento_p_posicao_181_a_195(pagamento)
						pagamento.valor_abatimento_formatado(15)
					end

					# Identificação do Título na Empresa 
					# 25 posições
					#
					def segmento_p_posicao_196_a_220(pagamento)
						''.rjust(25, ' ') 
					end

					# Código para Protesto
					# 1 posição
					#
					def segmento_p_posicao_221_a_221 
						'1'
					end

					# Número de Dias para Protesto 
					# 2 posições
					#
					def segmento_p_posicao_222_a_223
						'00' 
					end

					# Código para Baixa/Devolução 
					# 1 posição
					#
					def segmento_p_posicao_224_a_224
						'0'  
					end

					# Número de Dias para Baixa/Devolução
					# 3 posoções
					#
					def segmento_p_posicao_225_a_227
						'000'
					end

					# Código da Moeda (09 para real)
					# 2 posições
					#
					def segmento_p_posicao_228_a_229
						'09'
					end

					# Nº do Contrato da Operação de Crédito (Uso do banco)
					# 10 posições
					#
					def segmento_p_posicao_230_a_239
						''.rjust(10, '0')
					end

					# Uso livre banco/empresa ou autorização de pagamento parcial 
					# 1 posição
					#
					def segmento_p_posicao_240_a_240
						' '
					end

				end
			end
		end
	end
end