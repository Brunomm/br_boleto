# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab240
			class Itau < BrBoleto::Remessa::Cnab240::Base
				def conta_class
					BrBoleto::Conta::Itau
				end

				########################### HEADER ARQUIVO #############################
					#
					# Informação da conta
					# DESCRIÇÃO                       TAMANHO     POSIÇÃO
					# ---------------------------------------------------------
					# Complemento Registro (Zero)       01        53 - 53
					# Agencia                           04        54 - 57
					# Complemento Registro (Branco)     01        58 - 58
					# Complemento Registro (Zeros)      07        59 - 65
					# Conta Corrente                    05        66 - 70
					# Complemento Registro (Branco)     01        71 - 71
					# DV da Conta                       01        72 - 72
					#
					# TOTAL = 20 posições
					def informacoes_da_conta
						informacoes =  ''.rjust(1, '0')
						informacoes << "#{conta.agencia}".adjust_size_to(4, '0', :right)
						informacoes << ''.rjust(1)
						informacoes << ''.rjust(7, '0')
						informacoes << "#{conta.conta_corrente}".adjust_size_to(5, '0', :right)
						informacoes << ''.rjust(1)
						informacoes << "#{conta.conta_corrente_dv}".adjust_size_to(1, '0')
						informacoes
					end

					# Espaço reservado para o Banco
					# Para o Itau esse espaço deve ter 'Brancos'
					# 54 posições
					def header_arquivo_posicao_172_a_225
						''.rjust(54)
					end
					def header_arquivo_posicao_172_a_191
						header_arquivo_posicao_172_a_225
					end
					def header_arquivo_posicao_192_a_211
						''
					end

					# Posição 226 a 228 do Header do Arquivo
					# Para o Itau esse espaço deve ter 'Zeros'
					# 3 posições
					def header_posicao_226_a_228
						''.rjust(3, '0')
					end

					# Posição 229 a 240 do Header do Arquivo
					# Para o Itau esse espaço deve ter 'Brancos'
					# 12 posições
					def header_posicao_229_a_240
						''.rjust(12)
					end

					def complemento_header_arquivo
						"#{header_posicao_226_a_228}#{header_posicao_229_a_240}"
					end

				########################### HEADER LOTE #############################
					# 
					# COMPLEMENTO DE REGISTRO
					# Para o Itau esse espaço deve ter 'Brancos'
					# 20 posições
					def codigo_convenio
						''.adjust_size_to(20)
					end
					def convenio_lote(lote)
						codigo_convenio
					end

				######################### SEGMENTO P #############################
					#
					# segmento_p_posicao_024_a_057
					# DESCRIÇÃO                            TAMANHO      POSIÇÃO
					# -----------------------------------------------------------
					# COMPLEMENTO DE REGISTRO (ZEROS)        07         24 - 30
					# NÚMERO DA CONTA CORRENTE               05         31 - 35
					# COMPLEMENTO DE REGISTRO (BRANCO)       01         36 - 36
					# DV AG./CONTA EMPRESA                   01         37 - 37
					# NÚMERO DA CARTEIRA                     03         38 - 40
					# NÚMERO DOCUMENTO                       08         41 - 48
					# NOSSO NÚMERO DV                        01         49 - 49
					# COMPLEMENTO DE REGISTRO (BRANCOS)      08         50 - 57
					#                                                  
					# TOTAL = 34 posições 
					def complemento_p(pagamento)
						complemento = ''.adjust_size_to(7, '0', :right)
						complemento << "#{conta.conta_corrente}".adjust_size_to(5, '0', :right)
						complemento << ''.rjust(1)
						complemento << "#{conta.conta_corrente_dv}".adjust_size_to(1, '0', :right)
						complemento << "#{conta.carteira}".adjust_size_to(3, '0', :right)
						complemento << "#{pagamento.numero_documento}".adjust_size_to(8, '0', :right)
						complemento << "#{pagamento.nosso_numero}".split('').last
						complemento << ''.rjust(8)
						complemento
					end

					# Segmento P posição 059 a 062
					# Para o Itau esse espaço deve ter 'Zeros'
					# 5 posições
					def segmento_p_posicao_058_a_062
						''.rjust(5, '0')
					end
					def segmento_p_posicao_058_a_058
						segmento_p_posicao_058_a_062
					end
					def segmento_p_posicao_059_a_059(pagamento)
						''
					end
					def segmento_p_posicao_060_a_060
						''
					end
					def segmento_p_posicao_061_a_061(pagamento)
						''
					end
					def segmento_p_posicao_062_a_062(pagamento)
						''
					end

					# segmento_p_posicao_063_a_077
					# DESCRIÇÃO                      TAMANHO     POSIÇÃO
					# ---------------------------------------------------------
					# Número  Doc.                     10          63 - 72
					# Brancos                          05          73 - 77
					# TOTAL = 15 posições 
					def segmento_p_numero_do_documento(pagamento)
						segmento = "#{pagamento.numero_documento}".adjust_size_to(10, '0', :right)
						segmento << ''.rjust(5)
						segmento
					end

					# Código do Juros de Mora
					# Para o Itau esse espaço deve ter 'Zero'
					# 1 posição
					def segmento_p_posicao_118_a_118(pagamento) 
						'0'
					end


					# Código da Moeda
					# Para o Itau esse espaço deve ter 'Zeros'
					# 2 posições
					def segmento_p_posicao_228_a_229(pagamento)
						'00'
					end

				######################### SEGMENTO R #############################
					# Codigo da multa 
					def segmento_r_posicao_066_a_066(pagamento)
						"#{conta.get_codigo_multa('0')}".adjust_size_to(1, '0')
					end

				######################### TRAILER LOTE #############################
					#
					# trailer_lote_posicao_024_a_240(lote, nr_lote)
					# DESCRIÇÃO                              TAMANHO     POSIÇÃO
					# ----------------------------------------------------------------
					# Qtd. Títulos em Cobrança                 006       024  -  029
					# Val. Tot. Títulos em Carteiras           017       030  -  046
					# Qtd. Títulos em Cobrança                 006       047  -  052
					# Val. Tot. Títulos em Carteiras           017       053  -  069
					# Complemento De Registro (Zeros)          046       070  -  115
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