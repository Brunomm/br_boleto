# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab240
			class Sicredi < BrBoleto::Remessa::Cnab240::Base
				def conta_class
					BrBoleto::Conta::Sicredi
				end

				########################### HEADER ARQUIVO #############################

					#  DESCRIÇÃO               TAMANHO      POSIÇÃO
					# ---------------------------------------------------------
					# Cód. Cedente (convênio)    20          33-52
					# TOTAL = 20 posições
					def codigo_convenio
						''.adjust_size_to(20)
					end
				
					# Informação da conta
					# DESCRIÇÃO                    TAMANHO   POSIÇÃO
					# ---------------------------------------------------------
					# agencia                        05      53 - 57
					# digito Verif. agencia          01      58 - 58
					# Número da Conta Corrente       12      59 - 70
					# DV da Conta                    01      71 - 71
					# Branco                         01      72 - 72
					#
					# TOTAL = 20 posições
					def informacoes_da_conta
						informacoes =  "#{conta.agencia}".adjust_size_to(5, '0', :right)
						informacoes << ''.adjust_size_to(1)
						informacoes << "#{conta.conta_corrente}".adjust_size_to(12, '0', :right)
						informacoes << "#{conta.conta_corrente_dv}".adjust_size_to(1, '0', :right)
						informacoes << ''.adjust_size_to(1)
						informacoes.adjust_size_to(20, '0')
					end

					# Densidade de gravação (BPI), do arquivo encaminhado.
					def header_arquivo_posicao_167_a_171
						'01600'
					end

					# Para uso reservado do Banco
					# Para o Sicredi esse espaço deve ter 'Brancos'
					# 20 posições
					def header_arquivo_posicao_172_a_191
						''.rjust(20, ' ')
					end

					# Para uso reservado da Empresa
					# Para o Sicredi esse espaço deve ter 'Brancos'
					# 20 posições
					def header_arquivo_posicao_192_a_211
						''.rjust(20, ' ')
					end

					# Uso exclusivo FEBRABAN/CNAB
					# Para o Sicredi esse espaço deve ter 'Brancos'
					# TOTAL = 29 posições
					def complemento_header_arquivo
						''.rjust(29, ' ')
					end

				############################ HEADER LOTE ###############################

					# Uso exclusivo FEBRABAN/CNAB
					# Para o Sicredi esse espaço deve ter 'Brancos'
					# 2 posições
					def header_lote_posicao_012_a_013
						''.rjust(2, ' ')
					end

					#  DESCRIÇÃO               TAMANHO      POSIÇÃO
					# ---------------------------------------------------------
					# Cód. Cedente (convênio)    20          34-53
					# TOTAL = 20 posições
					def convenio_lote(lote)
						''.rjust(20, ' ')
					end

				############################ SEGMENTO P ################################

					# segmento_p_posicao_024_a_057
					# DESCRIÇÃO                     TAMANHO       POSIÇÃO
					# ---------------------------------------------------------
					# Número da Conta Corrente        12          24 - 35
					# DV da Conta                     01          36 - 36 
					# Branco                          01          37 - 37  
					# Nosso número                    20          38 - 57
					#                                                  
					# TOTAL = 34 posições 
					def complemento_p(pagamento)
					complemento = ''
						complemento << "#{conta.conta_corrente}".adjust_size_to(12, '0', :right)
						complemento << "#{conta.conta_corrente_dv}".adjust_size_to(1, '0', :right)
						complemento << ''.adjust_size_to(1)
						complemento << "#{pagamento.nosso_numero}".adjust_size_to(20, '0', :right)
						complemento.adjust_size_to(34, '0')
					end

					# segmento_p_posicao_063_a_077
					# DESCRIÇÃO                      TAMANHO     POSIÇÃO
					# ---------------------------------------------------------
					# Número  Doc.                     10          63 - 72
					# Brancos                          05          73 - 77
					# TOTAL = 15 posições 
					def segmento_p_numero_do_documento(pagamento)
						segmento = ''
						segmento << "#{pagamento.numero_documento}".adjust_size_to(10, '0', :right)
						segmento << ''.rjust(5, ' ')
						segmento
					end

					# Código para Baixa/Devolução 
					# Sicredi utiliza sempre domínio ‘1’ para esse campo ( '1' => Baixar / devolver ).
					# 1 posição
					def segmento_p_posicao_224_a_224
						'1'  
					end

					# Número de Dias para Baixa/Devolução
					# Sicredi utiliza sempre, nesse campo, 60 dias para baixa/devolução.
					# 3 posoções
					#
					def segmento_p_posicao_225_a_227
						'060'
					end

				############################ SEGMENTO R ################################

					# Codigo da multa 
					# O Sicredi apenas aceita o campo multa preenchido com '2' - Percentual.
					# 1 posição
					def segmento_r_posicao_066_a_066(pagamento)
						"#{conta.get_codigo_multa('2')}".adjust_size_to(1, '2')
					end

				########################### TRAILER LOTE ################################

					# trailer_lote_posicao_024_a_240(lote, nr_lote)
					# DESCRIÇÃO                              TAMANHO       POSIÇÃO
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
						complemento << ''.rjust(92, '0')  # Valores só serão utilizados para informação do arquivo retorno
						complemento << ''.rjust(8, ' ')   # O Sicredi atualmente não utiliza este campo
						complemento << ''.rjust(117, ' ') # USO EXCLUSIVO FEBRABAN
						complemento
					end
			end
		end
	end
end