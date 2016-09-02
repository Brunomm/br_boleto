module BrBoleto
	module Remessa
		module Cnab400
			module Helper
				module Trailer

					# Monta o registro trailer do arquivo
					#
					# @param nro_lotes [Integer]
					#   numero de lotes no arquivo
					# @param sequencial [Integer]
					#   numero de registros(linhas) no arquivo
					#
					# @return [String]
					#
					def monta_trailer(sequencial)
						trailer_arquivo =  ''                                                            # CAMPO
						trailer_arquivo << trailer_arquivo_posicao_001_a_001             # Identificação do Trailer
						trailer_arquivo << trailer_arquivo_posicao_002_a_394(sequencial) # Mensagens
						trailer_arquivo << trailer_arquivo_posicao_394_a_400(sequencial) # Sequencial do registro
						trailer_arquivo.upcase                                               
					end
					
					# Identificação do Registro Trailer
					# Padrão: '9'
					# Tipo: N
					# Tamanho: 001
					def trailer_arquivo_posicao_001_a_001 
						'9'
					end

					# Mensagens
					# Padrão: ' ' (393 brancos)
					# Tipo: X
					# Tamanho: 393
					def trailer_arquivo_posicao_002_a_394(sequencial)
						''.rjust(393, ' ')
					end

					# Sequencial do Trailer
					# Tipo: N
					# Tamanho: 6
					def trailer_arquivo_posicao_394_a_400(sequencial)
						"#{sequencial}".adjust_size_to(6, '0', :right)
					end					
				end
			end
		end
	end
end