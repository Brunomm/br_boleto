module BrBoleto
	module Remessa
		module Cnab240
			module Helper
				module HeaderLote
					# Monta o registro header do lote
					#
					# @param nro_lote [Integer]
					#   numero do lote no arquivo (iterar a cada novo lote)
					#
					# @return [String]
					#
					def monta_header_lote(lote, nr_lote)
						header_lote = ''                                        # CAMPO              TAMANHO
						header_lote << header_lote_posicao_001_a_003         # codigo banco           3
						header_lote << header_lote_posicao_004_a_007(nr_lote)# lote servico           4
						header_lote << header_lote_posicao_008_a_008         # tipo de registro       1
						header_lote << header_lote_posicao_009_a_009         # tipo de operacao       1
						header_lote << header_lote_posicao_010_a_011         # tipo de servico        2
						header_lote << header_lote_posicao_012_a_013         # uso exclusivo          2
						header_lote << header_lote_posicao_014_a_016         # versao layout do lote  3
						header_lote << header_lote_posicao_017_a_017         # uso exclusivo          1
						header_lote << header_lote_posicao_018_a_018         # tipo de inscricao      1
						header_lote << header_lote_posicao_019_a_033         # inscricao cedente      15
						header_lote << header_lote_posicao_034_a_053(lote)   # codigo do convenio     20
						header_lote << header_lote_posicao_054_a_073         # informacoes conta      20
						header_lote << header_lote_posicao_074_a_103         # nome empresa           30
						header_lote << header_lote_posicao_104_a_143         # 1a mensagem            40
						header_lote << header_lote_posicao_144_a_183         # 2a mensagem            40
						header_lote << header_lote_posicao_184_a_191         # numero remessa         8
						header_lote << header_lote_posicao_192_a_199         # data gravacao          8
						header_lote << header_lote_posicao_200_a_207         # data do credito        8
						header_lote << header_lote_posicao_208_a_240         # complemento            33
						header_lote.upcase
					end
					# Código do Banco na Compensação
					# 3 posições
					# 
					def header_lote_posicao_001_a_003
						codigo_banco
					end

					# Lote de Serviço 
					# 4 posições
					# 
					def header_lote_posicao_004_a_007(numero_do_lote)
						"#{numero_do_lote}".rjust(4, '0')
					end

					# Tipo de Registro 
					# 1 posição
					# 
					def header_lote_posicao_008_a_008
						'1'						
					end

					# Tipo da Operação
					# 1 posição
					#
					def header_lote_posicao_009_a_009
						'R'
					end

					# Tipo do Serviço
					# 2 posições
					#
					def header_lote_posicao_010_a_011
						'01'
					end

					# Forma de Lançamento
					# 2 posições
					#
					def header_lote_posicao_012_a_013
						'00'
					end

					# Nº da Versão do Layout do Lote
					# 3 posições
					#
					def header_lote_posicao_014_a_016
						versao_layout_lote
					end

					# Uso Exclusivo da FEBRABAN/CNAB
					# 1 posição
					#
					def header_lote_posicao_017_a_017
						' '
					end
					
					# Tipo de Inscrição da Empresa 
					# 1 posição
					#
					def header_lote_posicao_018_a_018
						tipo_inscricao
					end

					# Número de Inscrição da Empresa 
					# 15 posições
					#
					def header_lote_posicao_019_a_033
						documento_cedente.to_s.rjust(15, '0')
					end

					# Convenio -> Código do Cedente no Banco
					# 20 posições
					#
					def header_lote_posicao_034_a_053(lote)
						convenio_lote(lote)
					end

					# Informações da conta bancária
					# O padrão da FEBRABAN é: 
					#      Posição de 54 até 58 com 05 posições = Agência Mantenedora da Conta
					#      Posição de 59 até 59 com 01 posições = DV    -> Dígito Verificador da Agência
					#      Posição de 60 até 71 com 12 posições = Conta -> Número Número da Conta Corrente
					#      Posição de 72 até 72 com 01 posições = DV    -> Dígito Verificador da Conta
					#      Posição de 73 até 73 com 01 posições = DV    -> Dígito Verificador da Ag/Conta
					#
					# Porém como no Brasil os bancos não conseguem seguir um padrão, cada banco faz da sua maneira
					# 20 posições
					#
					def header_lote_posicao_054_a_073
						informacoes_da_conta
					end

					# Nome da Empresa
					# 30 posições
					#
					def header_lote_posicao_074_a_103
						nome_empresa_formatada
					end

					# Mensagem 1 
					# 40 posições
					#
					def header_lote_posicao_104_a_143
						mensagem_1.to_s.adjust_size_to(40)
					end

					# Mensagem 2
					# 40 posições
					#
					def header_lote_posicao_144_a_183
						mensagem_2.to_s.adjust_size_to(40)
					end

					# Número Remessa/Retorno 
					# 8 posições
					#
					def header_lote_posicao_184_a_191
						sequencial_remessa.to_s.rjust(8, '0')
					end

					# Data de Gravação Remessa/Retorno 
					# 8 posições
					#
					def header_lote_posicao_192_a_199
						data_geracao
					end

					# Data do Crédito 
					# 8 posições
					#
					def header_lote_posicao_200_a_207
						''.rjust(8, '0')
					end

					# Uso Exclusivo FEBRABAN/CNAB
					# 33 posições
					# 
					def header_lote_posicao_208_a_240
						''.rjust(33, ' ')
					end
				end
			end
		end
	end
end