# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab240
			class Bradesco < BrBoleto::Remessa::Cnab240::Base
				def conta_class
					BrBoleto::Conta::Bradesco
				end

				########################### HEADER ARQUIVO #############################
					#
					#  DESCRIÇÃO               TAMANHO      POSIÇÃO
					# ---------------------------------------------------------
					# Cód. Cedente (convênio)    20          33-52
					# TOTAL = 20 posições
					def codigo_convenio
						"#{conta.convenio}".adjust_size_to(20, '0', :right)
					end

					# Posição 212 a 240 do Header do Arquivo
					# Para o Bradesco esse espaço deve ter 'Brancos'
					# TOTAL = 29 posições
					def complemento_header_arquivo
						''.rjust(29, ' ')
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
						if (conta.conta_corrente_dv.to_s).size == 2                            # Para os Bancos que se utilizam de duas posições para o Dígito Verificador do Número da Conta Corrente.
							informacoes << "#{(conta.conta_corrente_dv.to_s)[0]}"               # Preencher este campo com a 1a posição deste dígito.
							informacoes << "#{(conta.conta_corrente_dv.to_s)[1]}"               # Preencher este campo com a 2a posição deste dígito.
						else
							informacoes << "#{conta.conta_corrente_dv}".adjust_size_to(2)       # Caso contrário ajustar o conta_corrente_dv para 2 digitos adicionando espaço em branco no final
						end
						informacoes.adjust_size_to(20, '0')
					end

				########################### HEADER LOTE #############################
					# 
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
					# DESCRIÇÃO                      TAMANHO     POSIÇÃO
					# ---------------------------------------------------------
					# Número da Conta Corrente         12          24 - 35
					# DV da Conta                      01          36 - 36 
					# DV da Ag/Conta                   01          37 - 37  
					# Identificação do Produto         03          38 - 40   
					# Zeros                            05          41 - 45   
					# Número  Doc.                     11          46 - 56    
					# DV Nosso Número                  01          57 - 57   
					#                                                  
					# TOTAL = 34 posições 
					def complemento_p(pagamento)
						complemento = ''
						complemento << "#{conta.conta_corrente}".adjust_size_to(12, '0', :right)
						if (conta.conta_corrente_dv.to_s).size == 2                             # Para os Bancos que se utilizam de duas posições para o Dígito Verificador do Número da Conta Corrente.
							complemento << "#{(conta.conta_corrente_dv.to_s)[0]}"                # Preencher este campo com a 1a posição deste dígito.
							complemento << "#{(conta.conta_corrente_dv.to_s)[1]}"                # Preencher este campo com a 2a posição deste dígito.
						else
							complemento << "#{conta.conta_corrente_dv}".adjust_size_to(2)        # Caso contrário ajustar o conta_corrente_dv para 2 digitos adicionando espaço em branco no final
						end
						complemento << "#{conta.carteira}".adjust_size_to(3, '0', :right)
						complemento << ''.rjust(5, '0')
						complemento << "#{pagamento.numero_documento}".adjust_size_to(11, '0', :right)
						complemento << "#{pagamento.nosso_numero}".split('').last
						complemento.adjust_size_to(34, '0')
					end

					# segmento_p_posicao_059_a_059
					# POSIÇÃO      TAMANHO     DESCRIÇÃO
					# -------------------------------------------------------------------
					# 59 - 59        01        Forma de Cadastramento do Título no Banco
					#
					# TOTAL = 1 posição 
					def segmento_p_posicao_059_a_059(pagamento)
						'1' 
					end

					# segmento_p_posicao_063_a_077
					# DESCRIÇÃO                      TAMANHO     POSIÇÃO
					# ---------------------------------------------------------
					# Número  Doc.                     10          63 - 72
					# Zeros                            05          73 - 77
					# TOTAL = 15 posições 
					def segmento_p_numero_do_documento(pagamento)
						segmento = ''
						segmento << "#{pagamento.numero_documento}".adjust_size_to(15, '0', :right)
						segmento
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