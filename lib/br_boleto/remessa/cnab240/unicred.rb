# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab240
			# A Unicred (através do CobExpress) utiliza e o layout de boleto os arquivos de remessa/retorno disponibilizados pelo Banco Bradesco.
			class Unicred < BrBoleto::Remessa::Cnab240::Bradesco
				def conta_class
					BrBoleto::Conta::Unicred
				end

				# segmento_p_posicao_024_a_057
				# DESCRIÇÃO                      TAMANHO     POSIÇÃO
				# ---------------------------------------------------------
				# Número da Conta Corrente         12          24 - 35
				# DV da Conta                      01          36 - 36 
				# DV da Ag/Conta (Branco)          01          37 - 37  
				# Número  Doc.                     11          38 - 48    
				# Nosso Número                     01          49 - 49
				# Brancos                          08          50 - 57
				#                                                  
				# TOTAL = 34 posições 
				def complemento_p(pagamento)
					complemento = ''
					complemento << "#{conta.conta_corrente}".adjust_size_to(12, '0', :right)
					complemento << "#{conta.conta_corrente_dv}".adjust_size_to(1)
					complemento << ''.adjust_size_to(1)
					complemento << "#{pagamento.numero_documento}".adjust_size_to(11, '0', :right)
					complemento << "#{pagamento.nosso_numero}".split('').last
					complemento << ''.adjust_size_to(8)
					complemento.adjust_size_to(34)
				end

			end
		end
	end
end