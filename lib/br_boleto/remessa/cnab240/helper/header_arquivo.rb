module BrBoleto
	module Remessa
		module Cnab240
			module Helper
				module HeaderArquivo
					# Monta o registro header do arquivo
					#
					# @return [String]
					#
					def monta_header_arquivo
						header_arquivo = ''                                 # CAMPO                         TAMANHO
						header_arquivo << header_arquivo_posicao_001_a_003  # codigo do banco               3
						header_arquivo << header_arquivo_posicao_004_a_007  # lote do servico               4
						header_arquivo << header_arquivo_posicao_008_a_008  # tipo de registro              1
						header_arquivo << header_arquivo_posicao_009_a_017  # uso exclusivo FEBRABAN        9
						header_arquivo << header_arquivo_posicao_018_a_018  # tipo inscricao                1
						header_arquivo << header_arquivo_posicao_019_a_032  # numero de inscricao           14
						header_arquivo << header_arquivo_posicao_033_a_052  # codigo do convenio no banco   20
						header_arquivo << header_arquivo_posicao_053_a_072  # informacoes da conta          20
						header_arquivo << header_arquivo_posicao_073_a_102  # nome da empresa               30
						header_arquivo << header_arquivo_posicao_103_a_132  # nome do banco                 30
						header_arquivo << header_arquivo_posicao_133_a_142  # uso exclusivo FEBRABAN        10
						header_arquivo << header_arquivo_posicao_143_a_143  # codigo remessa                1
						header_arquivo << header_arquivo_posicao_144_a_151  # data geracao                  8
						header_arquivo << header_arquivo_posicao_152_a_157  # hora geracao                  6
						header_arquivo << header_arquivo_posicao_158_a_163  # numero seq. arquivo           6
						header_arquivo << header_arquivo_posicao_164_a_166  # num. versao                   3
						header_arquivo << header_arquivo_posicao_167_a_171  # densidade gravacao            5
						header_arquivo << header_arquivo_posicao_172_a_191  # Para Uso Reservado do Banco   20
						header_arquivo << header_arquivo_posicao_192_a_211  # Para Uso Reservado da Empresa 20
						header_arquivo << header_arquivo_posicao_212_a_240  # complemento do arquivo        29
						header_arquivo.upcase
					end
					
					# Código do banco
					# 3 posições
					#
					def header_arquivo_posicao_001_a_003
						codigo_banco
					end

					# Lote de serviço
					# 4 posições
					#
					def header_arquivo_posicao_004_a_007
						'0000'
					end

					# Tipo do registro
					# 1 posição
					#
					def header_arquivo_posicao_008_a_008 
						'0'
					end

					# Uso Exclusivo FEBRABAN / CNAB
					# 09 posições
					#
					def header_arquivo_posicao_009_a_017
						''.rjust(9, ' ') 
					end

					# Tipo de Inscrição da Empresa
					# 1 posição
					#
					def header_arquivo_posicao_018_a_018
						tipo_inscricao 
					end

					# Número de Inscrição da Empresa (CPF/CNPJ)
					# 14 Posições
					#
					def header_arquivo_posicao_019_a_032
						documento_cedente.to_s.rjust(14, '0')
					end

					# Código do Convênio no Banco
					# 20 posições
					# 
					def header_arquivo_posicao_033_a_052
						codigo_convenio
					end
					
					# Informações da conta bancária
					# O padrão da FEBRABAN é: 
					#      Posição de 53 até 57 com 05 posições = Agência Mantenedora da Conta
					#      Posição de 58 até 58 com 01 posições = DV    -> Dígito Verificador da Agência
					#      Posição de 59 até 70 com 12 posições = Conta -> Número Número da Conta Corrente
					#      Posição de 71 até 71 com 01 posições = DV    -> Dígito Verificador da Conta
					#      Posição de 72 até 72 com 01 posições = DV    -> Dígito Verificador da Ag/Conta
					#
					# Porém como no Brasil os bancos não conseguem seguir um padrão, cada banco faz da sua maneira
					# 20 posições
					#
					def header_arquivo_posicao_053_a_072
						informacoes_da_conta
					end

					# Nome da Empresa
					# 30 posições
					# 
					def header_arquivo_posicao_073_a_102
						nome_empresa_formatada
					end

					# Nome do Banco
					# 30 posições
					#
					def header_arquivo_posicao_103_a_132
						nome_banco
					end

					# Uso Exclusivo FEBRABAN / CNAB
					# 10 posições
					#
					def header_arquivo_posicao_133_a_142 
						''.rjust(10, ' ')
					end

					# Código Remessa / Retorno (1 para remessa)
					# 1 posição
					# 
					def header_arquivo_posicao_143_a_143
						'1'
					end

					# Data de Geração do Arquivo no formato (DDMMYYYY)
					# 8 posições
					# 
					def header_arquivo_posicao_144_a_151
						data_geracao
					end

					# Hora de Geração do Arquivo no formato (HHMMSS)
					# 6 posições
					# 
					def header_arquivo_posicao_152_a_157
						hora_geracao 
					end

					# Número Seqüencial do Arquivo
					# 6 posições
					#
					def header_arquivo_posicao_158_a_163
						"#{sequencial_remessa}".rjust(6, '0')
					end

					# Numero da Versão do Layout do Arquivo
					# 3 posições
					#
					def header_arquivo_posicao_164_a_166
						versao_layout_do_arquivo
					end
					
					# Densidade de Gravação do Arquivo 
					# 5 posições
					#
					def header_arquivo_posicao_167_a_171
						''.rjust(5, '0')
					end

					# Espaço reservado para o Banco
					# 20 posições
					#
					def header_arquivo_posicao_172_a_191
						''.rjust(20, '0')
					end

					# Espaço reservado para a Empresa
					# 20 posições
					#
					def header_arquivo_posicao_192_a_211
						''.rjust(20, '0')
					end

					# Para Uso Exclusivo FEBRABAN / CNAB
					# 29 posições
					#
					def header_arquivo_posicao_212_a_240 
						complemento_header
					end
				end
			end
		end
	end
end