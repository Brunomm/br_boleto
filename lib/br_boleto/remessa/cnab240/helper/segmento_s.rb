module BrBoleto
	module Remessa
		module Cnab240
			module Helper
				module SegmentoS
					# Monta o registro segmento S do arquivo
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
					def monta_segmento_s(pagamento, nr_lote, sequencial)
						segmento_s = ''
						segmento_s << segmento_s_posicao_001_a_003 
						segmento_s << segmento_s_posicao_004_a_007(nr_lote)
						segmento_s << segmento_s_posicao_008_a_008
						segmento_s << segmento_s_posicao_009_a_013(sequencial)
						segmento_s << segmento_s_posicao_014_a_014
						segmento_s << segmento_s_posicao_015_a_015
						segmento_s << segmento_s_posicao_016_a_017
						segmento_s << segmento_s_posicao_018_a_018(pagamento)
						if pagamento.tipo_impressao == '3'
							segmento_s << segmento_s_tipo_impressao_3(pagamento)
						else
							segmento_s << segmento_s_tipo_impressao_1_ou_2(pagamento)
						end
						segmento_s.upcase
					end

					# Código do banco
					# 3 posições
					#
					def segmento_s_posicao_001_a_003 
						codigo_banco
					end

					# Lote de Serviço: Número seqüencial para identificar univocamente um lote de serviço. 
					# Criado e controlado pelo responsável pela geração magnética dos dados contidos no arquivo.
					# Preencher com '0001' para o primeiro lote do arquivo. 
					# Para os demais: número do lote anterior acrescido de 1. O número não poderá ser repetido dentro do arquivo.
					# 4 posições
					#
					def segmento_s_posicao_004_a_007(numero_do_lote)
						numero_do_lote.to_s.rjust(4, '0')
					end

					# Tipo do registro -> Padrão 3
					# 1 posição
					#
					def segmento_s_posicao_008_a_008
						'3'
					end

					# Nº Sequencial do Registro no Lote
					# 5 posições
					#
					def segmento_s_posicao_009_a_013(sequencial)
						sequencial.to_s.rjust(5, '0')
					end

					# Cód. Segmento do Registro Detalhe
					# 1 posição
					#
					def segmento_s_posicao_014_a_014
						'S'
					end

					# Uso Exclusivo FEBRABAN/CNAB 
					# 1 posição
					#
					def segmento_s_posicao_015_a_015
						' '
					end

					# Código de Movimento Remessa - 01 = Entrada de Titulos
					# 2 posições
					#
					def segmento_s_posicao_016_a_017
						'01'
					end

					# Tipo de impressão
					#     1 - Frente do Bloqueto
					#     2 - Verso do Bloauqto
					#     3 - Corpo de instruções da Ficha de Complansação
					# 1 posição
					#
					def segmento_s_posicao_018_a_018(pagamento)
						"#{pagamento.tipo_impressao}".adjust_size_to(1)
					end

				###########     TIPO DE IMPRESÃO 1 OU 2 ################
					def segmento_s_tipo_impressao_1_ou_2(pagamento)
						segmento = ''
						segmento << segmento_s_posicao_019_a_020_tipo_impressao_1_ou_2(pagamento)
						segmento << segmento_s_posicao_021_a_160_tipo_impressao_1_ou_2(pagamento)
						segmento << segmento_s_posicao_161_a_162_tipo_impressao_1_ou_2(pagamento)
						segmento << segmento_s_posicao_163_a_240_tipo_impressao_1_ou_2
						segmento
					end
					# Numero da Linha a ser impressa
					# 2 posições
					#
					def segmento_s_posicao_019_a_020_tipo_impressao_1_ou_2(pagamento)
						'01'
					end
					# Mensagem a ser impresas
					# 140 posições
					#
					def segmento_s_posicao_021_a_160_tipo_impressao_1_ou_2(pagamento)
						''.rjust(140, ' ')
					end

					# Tipo de caractere a ser impresso
					#     '01' = Normal
					#     '02' = Itálico
					#     '03' = Normal Negrito
					#     '04' = Itálico Negrito
					# 2 posições
					def segmento_s_posicao_161_a_162_tipo_impressao_1_ou_2(pagamento)
						'01'
					end

					# Uso exclusivo
					# 78 posições
					def segmento_s_posicao_163_a_240_tipo_impressao_1_ou_2
						''.rjust(78, ' ')
					end

				########################################################
				############## TIPO DE IMPRESSÃO 3 #####################
					def segmento_s_tipo_impressao_3(pagamento)
						segmento = ''
						segmento << segmento_s_posicao_019_a_058_tipo_impressao_3(pagamento)
						segmento << segmento_s_posicao_059_a_098_tipo_impressao_3(pagamento)
						segmento << segmento_s_posicao_099_a_138_tipo_impressao_3(pagamento)
						segmento << segmento_s_posicao_139_a_178_tipo_impressao_3(pagamento)
						segmento << segmento_s_posicao_179_a_218_tipo_impressao_3(pagamento)
						segmento << segmento_s_posicao_219_a_240_tipo_impressao_3
						segmento
					end
					# Informação 5
					# 40 posições
					#
					def segmento_s_posicao_019_a_058_tipo_impressao_3(pagamento)
						''.rjust(40, ' ')
					end

					# Informação 6
					# 40 posições
					#
					def segmento_s_posicao_059_a_098_tipo_impressao_3(pagamento)
						''.rjust(40, ' ')
					end

					# Informação 7
					# 40 posições
					#
					def segmento_s_posicao_099_a_138_tipo_impressao_3(pagamento)
						''.rjust(40, ' ')
					end

					# Informação 8
					# 40 posições
					#
					def segmento_s_posicao_139_a_178_tipo_impressao_3(pagamento)
						''.rjust(40, ' ')
					end

					# Informação 9
					# 40 posições
					#
					def segmento_s_posicao_179_a_218_tipo_impressao_3(pagamento)
						''.rjust(40, ' ')
					end
					
					# Uso exclusivo
					# 78 posições
					def segmento_s_posicao_219_a_240_tipo_impressao_3
						''.rjust(22, ' ')
					end
				########################################################

				end
			end
		end
	end
end