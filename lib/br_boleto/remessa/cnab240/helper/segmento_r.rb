module BrBoleto
	module Remessa
		module Cnab240
			module Helper
				module SegmentoR
					# Monta o registro segmento Q do arquivo
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
					def monta_segmento_r(pagamento, nr_lote, sequencial)
						segmento_r = ''
						segmento_r << segmento_r_posicao_001_a_003 
						segmento_r << segmento_r_posicao_004_a_007(nr_lote)
						segmento_r << segmento_r_posicao_008_a_008
						segmento_r << segmento_r_posicao_009_a_013(sequencial)
						segmento_r << segmento_r_posicao_014_a_014
						segmento_r << segmento_r_posicao_015_a_015
						segmento_r << segmento_r_posicao_016_a_017
						segmento_r << segmento_r_posicao_018_a_018(pagamento)
						segmento_r << segmento_r_posicao_019_a_026(pagamento)
						segmento_r << segmento_r_posicao_027_a_041(pagamento)
						segmento_r << segmento_r_posicao_042_a_042(pagamento)
						segmento_r << segmento_r_posicao_043_a_050(pagamento)
						segmento_r << segmento_r_posicao_051_a_065(pagamento)
						segmento_r << segmento_r_posicao_066_a_066(pagamento)
						segmento_r << segmento_r_posicao_067_a_074(pagamento)
						segmento_r << segmento_r_posicao_075_a_089(pagamento)
						segmento_r << segmento_r_posicao_090_a_099
						segmento_r << segmento_r_posicao_100_a_139
						segmento_r << segmento_r_posicao_140_a_179
						segmento_r << segmento_r_posicao_180_a_199
						segmento_r << segmento_r_posicao_200_a_207
						segmento_r << segmento_r_posicao_208_a_210
						segmento_r << segmento_r_posicao_211_a_215
						segmento_r << segmento_r_posicao_216_a_216
						segmento_r << segmento_r_posicao_217_a_228
						segmento_r << segmento_r_posicao_229_a_229
						segmento_r << segmento_r_posicao_230_a_230
						segmento_r << segmento_r_posicao_231_a_231
						segmento_r << segmento_r_posicao_232_a_240   
						segmento_r.upcase
					end

					# Código do banco
					# 3 posições
					#
					def segmento_r_posicao_001_a_003 
						codigo_banco
					end

					# Lote de Serviço: Número seqüencial para identificar univocamente um lote de serviço. 
					# Criado e controlado pelo responsável pela geração magnética dos dados contidos no arquivo.
					# Preencher com '0001' para o primeiro lote do arquivo. 
					# Para os demais: número do lote anterior acrescido de 1. O número não poderá ser repetido dentro do arquivo.
					# 4 posições
					#
					def segmento_r_posicao_004_a_007(numero_do_lote)
						numero_do_lote.to_s.rjust(4, '0')
					end

					# Tipo do registro -> Padrão 3
					# 1 posição
					#
					def segmento_r_posicao_008_a_008
						'3'
					end

					# Nº Sequencial do Registro no Lote
					# 5 posições
					#
					def segmento_r_posicao_009_a_013(sequencial)
						sequencial.to_s.rjust(5, '0')
					end

					# Cód. Segmento do Registro Detalhe
					# 1 posição
					#
					def segmento_r_posicao_014_a_014
						'R'
					end

					# Uso Exclusivo FEBRABAN/CNAB 
					# 1 posição
					#
					def segmento_r_posicao_015_a_015
						' '
					end

					# Código de Movimento Remessa - 01 = Entrada de Titulos
					# 2 posições
					#
					def segmento_r_posicao_016_a_017
						'01'
					end

					# Código do desconto 2
					# 1 posição
					#
					def segmento_r_posicao_018_a_018(pagamento)
						"#{pagamento.desconto_2_codigo}".adjust_size_to(1)
					end

					# Data do desconto 2
					# 8 posições
					#
					def segmento_r_posicao_019_a_026(pagamento)
						"#{pagamento.desconto_2_data_formatado('%d%m%Y')}".adjust_size_to(8, '0')
					end

					# Valor do desconto 2
					# 15 posições
					#
					def segmento_r_posicao_027_a_041(pagamento)
						pagamento.desconto_2_valor_formatado(15)
					end

					# Código do desconto 3
					# 1 posição
					#
					def segmento_r_posicao_042_a_042(pagamento)
						"#{pagamento.desconto_3_codigo}".adjust_size_to(1)
					end

					# Data do desconto 3
					# 8 posições
					#
					def segmento_r_posicao_043_a_050(pagamento)
						"#{pagamento.desconto_3_data_formatado('%d%m%Y')}".adjust_size_to(8, '0')
					end

					# Valor do desconto 3
					# 15 posições
					#
					def segmento_r_posicao_051_a_065(pagamento)
						pagamento.desconto_3_valor_formatado(15)
					end

					# Codigo da multa - (0 = isento, 1 = Valor fixo e 2 = Percentual)
					# 1 posição
					#
					def segmento_r_posicao_066_a_066(pagamento)
						"#{pagamento.codigo_multa}".adjust_size_to(1, '0')
					end

					# Data da multa
					# 8 posição
					#
					def segmento_r_posicao_067_a_074(pagamento)
						"#{pagamento.data_multa_formatado('%d%m%Y')}".adjust_size_to(8, '0')
					end

					# valor da multa
					# 15 posições
					#
					def segmento_r_posicao_075_a_089(pagamento)
						pagamento.valor_multa_formatado(15)
					end

					# Informação ao pagador
					# 10 posições
					#
					def segmento_r_posicao_090_a_099
						''.rjust(10, " ")
					end

					# Informação 3
					# 40 posições
					#
					def segmento_r_posicao_100_a_139
						''.rjust(40, " ")
					end

					# Informação 4
					# 40 posições
					#
					def segmento_r_posicao_140_a_179
						''.rjust(40, " ")
					end

					# CNAB Uso exclusivo FEBRABAN
					# 20 posições
					#
					def segmento_r_posicao_180_a_199
						''.rjust(20, " ")
					end

					# Cod. Ocor. do pagador
					# 8 posições
					#
					def segmento_r_posicao_200_a_207
						''.rjust(8, "0")
					end

					# Cod. do banco para débido
					# 3 posições
					#
					def segmento_r_posicao_208_a_210
						''.rjust(3, "0")
					end

					# Agencia para débido
					# 5 posições
					#
					def segmento_r_posicao_211_a_215
						''.rjust(5, "0")
					end

					# DV agencia para débido
					# 1 posições
					#
					def segmento_r_posicao_216_a_216
						" "
					end

					# Conta corrente para débito
					# 12 posições
					#
					def segmento_r_posicao_217_a_228
						"".rjust(12, '0')
					end

					# DV Conta corrente para débito
					# 1 posições
					#
					def segmento_r_posicao_229_a_229
						" "
					end

					# DV Aencia/Conta
					# 1 posições
					#
					def segmento_r_posicao_230_a_230
						" "
					end

					# Ident. Da emissão do Aviso Debito Automatico
					# 1 posição
					#
					def segmento_r_posicao_231_a_231
						"0"
					end

					# Uso exclusivo
					# 9 posições
					#
					def segmento_r_posicao_232_a_240
						"".rjust(9, " ")
					end

				end
			end
		end
	end
end