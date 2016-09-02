module BrBoleto
	module Remessa
		module Cnab400
			module Helper
				module Header
					# Monta o registro header do arquivo
					#
					# @return [String]
					#
					def monta_header
						header = ''                         # TAMANHO       INFORMAÇÃO
						header << header_posicao_001_a_001  #  001     Código do registro
						header << header_posicao_002_a_002  #  001     Código da remessa
						header << header_posicao_003_a_009  #  007     Literal de transmissão
						header << header_posicao_010_a_011  #  002     Código do serviço
						header << header_posicao_012_a_026  #  015     Literal de serviço
						header << header_posicao_027_a_046  #  020     Informações da conta <- Específico para cada banco
						header << header_posicao_047_a_076  #  030     Nome do cedente
						header << header_posicao_077_a_094  #  018     Informações do banco
						header << header_posicao_095_a_100  #  006     Data de Gravação
						header << header_posicao_101_a_394  #  294     Complemento do registro
						header << header_posicao_395_a_400  #  006     Número sequencial do registro no arquivo
						header.upcase
					end

					# Código do registro
					# Padrão: 0
					# Tipo: Numérico
					# Tamanho: 001
					def header_posicao_001_a_001
						'0'
					end

					# Código da remessa
					# Padrão: 1
					# Tipo: Numérico
					# Tamanho: 001
					def header_posicao_002_a_002
						'0'
					end

					# Literal de transmissão
					# Padrão: REMESSA
					# Tipo: Caracteres
					# Tamanho: 007
					def header_posicao_003_a_009
						'REMESSA'
					end

					# Código do serviço
					# Padrão: 01
					# Tipo: Numérico
					# Tamanho: 002
					def header_posicao_010_a_011
						'01'
					end

					# Literal de serviço
					# Padrão: COBRANÇA
					# Tipo: Caracteres
					# Tamanho: 015
					def header_posicao_012_a_026
						'COBRANÇA'.ljust(15, ' ')
					end

					# Informações da conta <- Específico para cada banco
					# Tipo: Numérico
					# Tamanho: 020
					def header_posicao_027_a_046
						informacoes_da_conta(:header)
					end
					
					# Nome do cedente
					# Tipo: Caracteres
					# Tamanho: 030
					def header_posicao_047_a_076
						"#{conta.razao_social}".adjust_size_to(30)
					end

					# Informações do banco
					# Padrão:
					#   077 a 079 = Código do banco com 3 posições
					#   080 a 094 = Nome do banco com 15 posições
					# Tamanho: 018
					def header_posicao_077_a_094
						informacoes_do_banco
					end

					# Data de Gravação
					# Tipo: Numérico
					# Tamanho: 006
					def header_posicao_095_a_100
						data_geracao('%d%m%y')
					end

					# Complemento do registro
					# Vai na posição 101 até 394
					# Tamanho: 294
					def header_posicao_101_a_394
						complemento_registro
					end

					# Número sequencial do registro no arquivo
					# Padrão: 000001 
					# Tipo: Numérico
					# Tamanho: 006
					def header_posicao_395_a_400
						'000001'
					end
				end
			end
		end
	end
end