# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab240
			class Cecred < BrBoleto::Remessa::Cnab240::Base
				def conta_class
					BrBoleto::Conta::Cecred
				end

				########################### HEADER ARQUIVO #############################
					#
					#  DESCRIÇÃO               TAMANHO      POSIÇÃO
					# ---------------------------------------------------------
					# Cód. Cedente (convênio)    20          33-52
					# TOTAL = 20 posições
					def codigo_convenio
						"#{conta.convenio}".adjust_size_to(20)
					end

					# Informação da conta
					# DESCRIÇÃO                    TAMANHO   POSIÇÃO
					# ---------------------------------------------------------
					# agencia                        05      53 - 57
					# digito Verif. agencia          01      58 - 58
					# Número da Conta Corrente       12      59 - 70
					# DV da Conta                    01      71 - 71
					# DV da Ag/Conta                 01      72 - 72
					#
					# TOTAL = 20 posições
					def informacoes_da_conta
						informacoes =  "#{conta.agencia}".adjust_size_to(5, '0', :right)
						informacoes << "#{conta.agencia_dv}"
						informacoes << "#{conta.conta_corrente}".adjust_size_to(12, '0', :right)
						informacoes << "#{conta.conta_corrente_dv}".adjust_size_to(2)
						informacoes
					end

					# Espaço reservado para o Banco
					# TOTAL = 20 posições
					def header_arquivo_posicao_172_a_191
						''.rjust(20, ' ')
					end

					# Espaço reservado para a Empresa
					# TOTAL = 20 posições
					def header_arquivo_posicao_192_a_211
						''.rjust(20, ' ')
					end

					# Para o Cecred esse espaço deve ter 'Brancos'
					# TOTAL = 29 posições
					def complemento_header_arquivo
						''.rjust(29, ' ')
					end

				########################### HEADER LOTE #############################

					# Forma de Lançamento
					# Para o Cecred esse espaço deve ter 'Brancos'
					def header_lote_posicao_012_a_013
						''.adjust_size_to(2)
					end

					# Convenio -> Código do Cedente no Banco
					# Posicao 034 a 053
					# TOTAL = 20 posições
					def convenio_lote(lote)
						codigo_convenio
					end

				######################### SEGMENTO P #############################
					#
					# segmento_p_posicao_024_a_057
					# DESCRIÇÃO                                     TAMANHO     POSIÇÃO
					# -----------------------------------------------------------------------
					# Número da Conta Corrente                        12          24 - 35
					# DV da Conta                                     01          36 - 36 
					# DV da Ag/Conta                                  01          37 - 37  
					# Identificação do Título na Cooperativa          20          38 - 57    
					#                                                  
					# TOTAL = 34 posições 
					def complemento_p(pagamento)
						complemento = ''
						complemento << "#{conta.conta_corrente}".adjust_size_to(12, '0', :right)
						complemento << "#{conta.conta_corrente_dv}".adjust_size_to(2)
						complemento << ''.adjust_size_to(20, '0', :right)
						complemento
					end

					# Forma de Cadastr. do Título no Banco
					# TOTAL = 1 posição 
					def segmento_p_posicao_059_a_059(pagamento)
						'1' 
					end

					# Tipo de Documento
					# TOTAL = 1 posição 
					def segmento_p_posicao_060_a_060
						'1'
					end

					# Número do Documento de Cobrança
					# Posição 063 a 077
					# TOTAL = 15 posições 
					def segmento_p_numero_do_documento(pagamento)
						segmento = "#{pagamento.numero_documento}".adjust_size_to(15, '0', :right)
					end


					# Número de Dias para Baixa/Devolução
					# Para o Cecred esse espaço deve ter 'Brancos'
					# TOTAL =  3 posoções
					def segmento_p_posicao_225_a_227
						''.adjust_size_to(3)
					end

				######################### SEGMENTO R #############################
					#
					# Tipo de Inscrição
					# TOTAL = 1 posição
					def segmento_q_posicao_154_a_154(pagamento)
						'0'
					end

					# CNPF/CNPJ Avalista
					# Para o Cecred esse espaço deve ter 'Zeros'
					# # TOTAL = 15 posições
					def segmento_q_posicao_155_a_169(pagamento)
						''.adjust_size_to(15, '0', :right)
					end

					# Nome do avalista
					# Para o Cecred esse espaço deve ter 'Brancos'
					# # TOTAL = 40 posições
					def segmento_q_posicao_170_a_209(pagamento)
						''.adjust_size_to(40)
					end

				######################### TRAILER LOTE #############################
					# trailer_lote_posicao_024_a_240(lote, nr_lote)
					# DESCRIÇÃO                              TAMANHO     POSIÇÃO
					# ----------------------------------------------------------------
					# Qtd. Títulos em Cobrança                 006       024  -  029
					# Val. Tot. Títulos em Carteiras           017       030  -  046
					# Qtd. Títulos em Cobrança                 006       047  -  052
					# Val. Tot. Títulos em Carteiras           017       053  -  069
					# Qtd. Títulos em Cobrança                 006       070  -  075
					# Qtd. Títulos em Carteiras                017       076  -  092
					# Qtd. de Títulos em Cobrança              006       093  -  098
					# Val. Tot. dos Títulos em Carteiras       017       099  -  115
					# N. Aviso de Lançamento                   008       116  -  123
					# Uso FEBRABAN                             117       124  -  240 
					#
					# TOTAL = 217 posições 
					#
					def complemento_trailer_lote(lote, nr_lote)
						complemento = ''
						complemento << ''.rjust(92, '0')  # VALORES UTILIZADOS APENAS PARA ARQUIVO DE RETORNO
						complemento << ''.rjust(8, '0')   # Número do aviso de lançamento do crédito referente a(os) título(s) de cobrança, que poderá ser utilizado no extrato de conta corrente.
						complemento << ''.rjust(117, ' ') # USO EXCLUSIVO FEBRABAN
						complemento
					end

			end
		end
	end
end