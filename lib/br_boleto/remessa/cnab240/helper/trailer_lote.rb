module BrBoleto
	module Remessa
		module Cnab240
			module Helper
				module TrailerLote
					# Monta o registro trailer do lote
					#
					# @param nr_lote [Integer]
					#   numero do lote no arquivo (iterar a cada novo lote)
					#
					# @param nro_registros [Integer]
					#   numero de registros(linhas) no lote (contando header e trailer)
					#
					# @return [String]
					#
					def monta_trailer_lote(nr_lote, nro_registros)
						trailer_lote = ''                                            # CAMPO                   # TAMANHO
						trailer_lote << trailer_lote_posicao_001_a_003               # codigo banco            3
						trailer_lote << trailer_lote_posicao_004_a_007(nr_lote)      # lote de servico         4
						trailer_lote << trailer_lote_posicao_008_a_008               # tipo de servico         1
						trailer_lote << trailer_lote_posicao_009_a_017               # uso exclusivo           9
						trailer_lote << trailer_lote_posicao_018_a_023(nro_registros)# qtde de registros lote  6
						trailer_lote << trailer_lote_posicao_024_a_240               # uso exclusivo           217
						trailer_lote.upcase
					end

					# Código do banco
					# 3 posições
					#
					def trailer_lote_posicao_001_a_003 
						codigo_banco
					end

					# Lote de Serviço: Número seqüencial para identificar univocamente um lote de serviço. 
					# Criado e controlado pelo responsável pela geração magnética dos dados contidos no arquivo.
					# Preencher com '0001' para o primeiro lote do arquivo. 
					# Para os demais: número do lote anterior acrescido de 1. O número não poderá ser repetido dentro do arquivo.
					# 4 posições
					#
					def trailer_lote_posicao_004_a_007(numero_do_lote)
						numero_do_lote.to_s.rjust(4, '0')
					end

					# Tipo do registro -> Padrão 5
					# 1 posição
					#
					def trailer_lote_posicao_008_a_008
						'5'
					end

					# Uso Exclusivo FEBRABAN/CNAB
					# 9 posições
					#
					def trailer_lote_posicao_009_a_017
						''.rjust(9, ' ')
					end

					# Quantidade de Registros no Lote
					# 6 posições
					#
					def trailer_lote_posicao_018_a_023(nro_registros)
						nro_registros.to_s.rjust(6, '0')
					end

					# Complemento trailer diferente para cada banco
					# 217 posições
					#
					def trailer_lote_posicao_024_a_240
						complemento_trailer_lote
					end
					
				end
			end
		end
	end
end