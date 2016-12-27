# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab240
			class BancoBrasil < BrBoleto::Remessa::Cnab240::Base
				def conta_class
					BrBoleto::Conta::BancoBrasil
				end

				########## VALIDAÇÕES ESPECÍFICAS DESTE OBJETO PARA A CONTA ############
					def valid_variacao_carteira_required; true end # <= Variacao da carteira é obrigatória

				########################### HEADER ARQUIVO #############################
					#
					# Código do Convênio no Banco
					# 20 posições
					def header_arquivo_posicao_033_a_052
						codigo_convenio
					end

					# DESCRIÇÃO                    TAMANHO   POSIÇÃO
					# ---------------------------------------------------------
					# Cod. Convênio                  09      33 - 41
					# Cobrança Cedente               04      42 - 45
					# Carteira                       02      46 - 47
					# Variacao carteira              03      48 - 50
					# Brancos                        02      51 - 52
					def codigo_convenio
						cod = "#{conta.convenio}".adjust_size_to(9, '0', :right)
						cod << '0014'
						cod << "#{conta.carteira}".adjust_size_to(2, '0', :right)
						cod << "#{conta.variacao_carteira}".adjust_size_to(3, '0', :right)
						cod << ''.adjust_size_to(2)
						cod
					end

					# Informação da conta
					# DESCRIÇÃO                    TAMANHO   POSIÇÃO
					# ---------------------------------------------------------
					# agencia                        05      54 - 58
					# digito Verif. agencia          01      59 - 59
					# Número da Conta Corrente       12      60 - 71
					# DV da Conta                    01      72 - 72
					# DV da Ag/Conta                 01      73 - 73
					#
					# TOTAL = 20 posições
					def informacoes_da_conta
						informacoes =  "#{conta.agencia}".adjust_size_to(5, '0', :right)
						informacoes << "#{conta.agencia_dv}"
						informacoes << "#{conta.conta_corrente}".adjust_size_to(12, '0', :right)
						informacoes << "#{conta.conta_corrente_dv}".adjust_size_to(2)
						informacoes
					end

					# Posição 212 a 240 do Header do Arquivo
					# Para o Banco do Brasil esse espaço deve ter 'Brancos'
					# TOTAL = 29 posições
					def complemento_header_arquivo
						''.adjust_size_to(29)
					end

				########################### HEADER LOTE #############################
					# 
					# Forma de Lançamento
					# Informar 'brancos' (espaços)
					# 2 posições
					def header_lote_posicao_012_a_013
						''.adjust_size_to(2)
					end

					#  DESCRIÇÃO               TAMANHO      POSIÇÃO
					# ---------------------------------------------------------
					# Cód. Cedente (convênio)    20          34-53
					# TOTAL = 20 posições
					def convenio_lote(lote)
						codigo_convenio
					end

				######################### SEGMENTO P #############################
					#
					# segmento_p_posicao_024_a_057
					# TAMANHO     POSIÇÃO          DESCRIÇÃO                      
					# ---------------------------------------------------------
					#   12          24 - 35        Número da Conta Corrente       
					#   01          36 - 36        DV da Conta                    
					#   01          37 - 37        DV da Ag/Conta (Campo não tratado pelo Banco do Brasil. Informar 'branco')
					#   20          38 - 57        Nosso Número                   
					#                                                  
					# TOTAL = 34 posições 
					def complemento_p(pagamento)
						complemento = ''
						complemento << "#{conta.conta_corrente}".adjust_size_to(12, '0', :right)
						complemento << "#{conta.conta_corrente_dv}"
						complemento << ' '
						complemento << "#{pagamento.nosso_numero}".adjust_size_to(20)
						complemento
					end

					# segmento_p_posicao_063_a_077
					# DESCRIÇÃO                      TAMANHO     POSIÇÃO
					# ---------------------------------------------------------
					# Número  Doc.                     10          63 - 77
					# TOTAL = 15 posições 
					def segmento_p_numero_do_documento(pagamento)
						segmento = "#{pagamento.numero_documento}".adjust_size_to(15)
					end

				######################### SEGMENTO S #############################

					# Numero da Linha a ser impressa
					# Campo não tratado pelo Banco do Brasil, informar 'zeros'.
					def segmento_s_posicao_019_a_020_tipo_impressao_1_ou_2(pagamento)
						'00'
					end

					# Tipo de caractere a ser impresso
					# Campo não tratado pelo Banco do Brasil, informar 'zeros'.
					def segmento_s_posicao_161_a_162_tipo_impressao_1_ou_2(pagamento)
						'00'
					end

				######################### TRAILER LOTE #############################
					#
					# trailer_lote_posicao_024_a_240(lote, nr_lote)
					# TOTAL = 217 posições 
					def complemento_trailer_lote(lote, nr_lote)
						complemento = ''.rjust(217, ' ') # USO EXCLUSIVO FEBRABAN
					end

			end
		end
	end
end