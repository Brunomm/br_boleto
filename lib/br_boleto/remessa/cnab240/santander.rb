# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab240
			class Santander < BrBoleto::Remessa::Cnab240::Base
				def conta_class
					BrBoleto::Conta::Santander
				end

				########################### HEADER ARQUIVO ##########################
					#
					#  DESCRIÇÃO               TAMANHO      POSIÇÃO
					# --------------------------------------------------
					# Cód. de Transmissão        15          33-47
					#
					# TOTAL = 15 posições
					def header_arquivo_posicao_033_a_47
						"#{conta.convenio}".adjust_size_to(15, '0', :right)
					end					
					def header_arquivo_posicao_033_a_052
						header_arquivo_posicao_033_a_47
					end

					# Informação da conta
					# DESCRIÇÃO                    TAMANHO   POSIÇÃO
					# -------------------------------------------------
					# Reservado (uso Banco)          25       48-72
					#
					# TOTAL = 25 posições
					def informacoes_da_conta
						''.adjust_size_to(25)
					end

					# Reservado (uso Banco)
					# Para o Santander esse espaço deve ter 'Brancos'
					def header_arquivo_posicao_152_a_157
						''.adjust_size_to(6)
					end

					# Posição 167 a 240 do Header do Arquivo
					# Para o Santander esse espaço deve ter 'Brancos'
					# TOTAL = 74 posições
					def header_arquivo_posicao_167_a_240
						''.adjust_size_to(74)
					end
					def header_arquivo_posicao_167_a_171
						header_arquivo_posicao_167_a_240
					end
					def header_arquivo_posicao_172_a_191
						''
					end
					def header_arquivo_posicao_192_a_211
						''
					end
					def complemento_header_arquivo
						''
					end

				########################### HEADER LOTE #############################
					# 
					# Reservado (uso Banco)
					# 2 posições
					def header_lote_posicao_012_a_013
						''.adjust_size_to(2)
					end

					# Reservado (uso Banco)				
					# TOTAL = 20 posições
					def convenio_lote(lote)
						''.adjust_size_to(20)
					end


					# Cód. de Transmissão (15 posições) + Uso Banco (5 posições)
					# TOTAL = 20 posições
					def header_arquivo_posicao_054_a_68
						"#{conta.convenio}".adjust_size_to(15, '0', :right)
					end					
					def header_lote_posicao_054_a_073
						"#{header_arquivo_posicao_054_a_68}".adjust_size_to(20)
					end

					# Reservado (uso Banco)
					# TOTAL = 41 posições
					def header_lote_posicao_200_a_240
						''.adjust_size_to(41)
					end
					def header_lote_posicao_200_a_207
						header_lote_posicao_200_a_240
					end
					def header_lote_posicao_208_a_240
						''
					end

				######################### SEGMENTO P ################################
					#
					# Agência Mantenedora da Conta 
					# TOTAL = 4 posições
					def segmento_p_posicao_018_a_021
						"#{conta.agencia}".adjust_size_to(4, '0', :right)
					end				
					def segmento_p_posicao_018_a_022
						segmento_p_posicao_018_a_021
					end

					# Dígito Verificador da Agência 
					# TOTAL = 1 posição
					def segmento_p_posicao_022_a_022
						"#{conta.agencia_dv}".adjust_size_to(1, '0')
					end
					def segmento_p_posicao_023_a_023
						segmento_p_posicao_022_a_022
					end
					
					# segmento_p_posicao_023_a_057
					# DESCRIÇÃO                      TAMANHO        POSIÇÃO
					# ---------------------------------------------------------
					# Número da Conta Corrente         09          023 - 031
					# DV da Conta                      01          032 – 032 
					# Conta cobrança                   09          033 - 041  
					# DV da conta cobrança             01          042 - 042   
					# Reservado (uso Banco)            02          043 - 044  
					# Nosso Número                     13          045 - 057    
					#                                                  
					# TOTAL = 35 posições 
					def complemento_p(pagamento)
						complemento = ''
						complemento << "#{conta.conta_corrente}".adjust_size_to(9, '0', :right)
						complemento << "#{conta.conta_corrente_dv}".adjust_size_to(1)   

						complemento << ''.adjust_size_to(9, '0', :right)
						complemento << ''.adjust_size_to(1, '0', :right)  

						complemento << ''.adjust_size_to(2)
						complemento << "#{pagamento.nosso_numero}".adjust_size_to(13, '0', :right)
						complemento
					end

					# Reservado (uso Banco)
					# TOTAL = 1 posição
					def segmento_p_posicao_061_a_061(pagamento)
						''.adjust_size_to(1)
					end

					# Reservado (uso Banco)
					# TOTAL = 1 posição
					def segmento_p_posicao_062_a_062(pagamento)
						''.adjust_size_to(1)
					end

					# segmento_p_posicao_063_a_077
					# DESCRIÇÃO                      TAMANHO     POSIÇÃO
					# ---------------------------------------------------------
					# Número  Doc.                     15          63 - 77
					# TOTAL = 15 posições 
					def segmento_p_numero_do_documento(pagamento)
						"#{pagamento.numero_documento}".adjust_size_to(15, '0', :right)
					end

					# Nº do Contrato da Operação de Crédito (Uso do banco)
					# TOTAL = 10 posições
					def segmento_p_posicao_230_a_239
						''.adjust_size_to(10)
					end

				######################### SEGMENTO R ###############################

					# Reservado (uso Banco)
					def segmento_r_posicao_042_a_065
						''.adjust_size_to(24)
					end
					def segmento_r_posicao_042_a_042(pagamento)
						segmento_r_posicao_042_a_065
					end
					def segmento_r_posicao_043_a_050(pagamento)
						''
					end
					def segmento_r_posicao_051_a_065(pagamento)
						''
					end

					# Reservado
					def segmento_r_posicao_180_a_240
						''.adjust_size_to(61)
					end
					def segmento_r_posicao_180_a_199
						segmento_r_posicao_180_a_240
					end
					def segmento_r_posicao_200_a_207
						''
					end
					def segmento_r_posicao_208_a_210
						''
					end
					def segmento_r_posicao_211_a_215
						''
					end
					def segmento_r_posicao_216_a_216
						''
					end
					def segmento_r_posicao_217_a_228
						''
					end
					def segmento_r_posicao_229_a_229
						''
					end
					def segmento_r_posicao_230_a_230
						''
					end
					def segmento_r_posicao_231_a_231
						''
					end
					def segmento_r_posicao_232_a_240
						''
					end

				######################### SEGMENTO S ###############################
					#
					# segmento_s_posicao_021_a_240_tipo_impressao_1_ou_2
					# DESCRIÇÃO                              TAMANHO     POSIÇÃO
					# ----------------------------------------------------------------
					# Mensagem para recibo do sacado           001       021  -  021
					# Mensagem a ser impressa                  100       022  -  121
					# Reservado (uso Banco)                    119       122  -  240
					#
					# TOTAL = 120 posições 
					#
					def segmento_s_posicao_021_a_240_tipo_impressao_1_ou_2
						segmento = ''
						segmento << '4'
						segmento << ''.adjust_size_to(100)
						segmento << ''.adjust_size_to(119)
						segmento
					end
					def segmento_s_posicao_021_a_160_tipo_impressao_1_ou_2(pagamento)
						segmento_s_posicao_021_a_240_tipo_impressao_1_ou_2
					end
					def segmento_s_posicao_161_a_162_tipo_impressao_1_ou_2(pagamento)
						''
					end
					def segmento_s_posicao_163_a_240_tipo_impressao_1_ou_2
						''
					end

				######################### TRAILER LOTE #############################
					#
					# trailer_lote_posicao_024_a_240(lote, nr_lote)
					# DESCRIÇÃO                              TAMANHO     POSIÇÃO
					# ----------------------------------------------------------------
					# Reservado (uso Banco)                   217       024  -  240
					#
					# TOTAL = 217 posições 
					def complemento_trailer_lote(lote, nr_lote)
						''.adjust_size_to(217)
					end

				######################### TRAILER ARQUIVO ##########################
					#
					# Reservado (uso Banco)
					def trailer_arquivo_posicao_030_a_035
						''.adjust_size_to(6)
					end
			end
		end
	end
end