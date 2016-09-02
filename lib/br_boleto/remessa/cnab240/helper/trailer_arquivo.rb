module BrBoleto
	module Remessa
		module Cnab240
			module Helper
				module TrailerArquivo

					# Monta o registro trailer do arquivo
					#
					# @param nro_lotes [Integer]
					#   numero de lotes no arquivo
					# @param sequencial [Integer]
					#   numero de registros(linhas) no arquivo
					#
					# @return [String]
					#
					def monta_trailer_arquivo(nro_lotes, sequencial)
						trailer_arquivo =  ''                                               # CAMPO              TAMANHO
						trailer_arquivo << trailer_arquivo_posicao_001_a_003                 # Código banco          3
						trailer_arquivo << trailer_arquivo_posicao_004_a_007(nro_lotes)     # Lote Serviço          4
						trailer_arquivo << trailer_arquivo_posicao_008_a_008                # Tipo registro         1
						trailer_arquivo << trailer_arquivo_posicao_009_a_017                # Exclusivo             9
						trailer_arquivo << trailer_arquivo_posicao_018_a_023(nro_lotes)     # Qtd. Lotes            6
						trailer_arquivo << trailer_arquivo_posicao_024_a_029(sequencial)    # Qtd. Registros        6
						trailer_arquivo << trailer_arquivo_posicao_030_a_035                # Qtde Contas           6
						trailer_arquivo << trailer_arquivo_posicao_036_a_240                # Exclusivo            205
						trailer_arquivo.upcase                                               
					end
					
					# Código do banco
					# 3 posições
					#
					def trailer_arquivo_posicao_001_a_003 
						conta.codigo_banco
					end

					# Lote de Serviço -> Padrão 9999
					# 4 posições
					#
					def trailer_arquivo_posicao_004_a_007(nro_lotes)
						'9999'
					end

					# Tipo do registro -> Padrão 9
					# Código adotado pela FEBRABAN para identificar o tipo de registro:
					#     0 = Header de Arquivo
					#     1 = Header de Lote
					#     3 = Detalhe
					#     5 = Trailer de Lote
					#     9 = Trailer de Arquivo
					#
					# 1 posição
					#
					def trailer_arquivo_posicao_008_a_008
						'9'
					end

					# Uso Exclusivo FEBRABAN/CNAB
					# 9 posições
					#
					def trailer_arquivo_posicao_009_a_017
						''.rjust(9, ' ')
					end

					# Quantidade de Lotes do Arquivo
					# 6 posições
					#
					def trailer_arquivo_posicao_018_a_023(nro_lotes)
						"#{nro_lotes}".adjust_size_to(6, '0', :right)
					end

					# Quantidade de Registros do Arquivo
					# 6 posições
					#
					def trailer_arquivo_posicao_024_a_029(sequencial)
						"#{sequencial}".adjust_size_to(6, '0', :right)
					end

					# Qtde de Contas p/ Conc. (Lotes)
					# 6 posições
					#
					def trailer_arquivo_posicao_030_a_035
						''.rjust(6, '0')
					end

					# Uso Exclusivo FEBRABAN/CNAB
					# 205 posições
					#
					def trailer_arquivo_posicao_036_a_240
						''.rjust(205, ' ')
					end
				end
			end
		end
	end
end