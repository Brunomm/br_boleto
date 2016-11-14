# encoding: utf-8
module BrBoleto
	module Boleto
		# Implementação de emissão de boleto bancário pelo Banco Cecred.
		#
		# === Documentação Implementada
		#
		# A documentação na qual essa implementação foi baseada está localizada na pasta
		# 'documentacoes_dos_boletos/cecred' dentro dessa biblioteca.
		class Cecred < Base
			def conta_class
				BrBoleto::Conta::Cecred
			end

			#################  VALIDAÇÕES DINÂMICAS  #################
				def valid_numero_documento_maximum
					9	
				end

				def valid_carteira_inclusion
					%w[1]
				end
				
				# Tamanho máximo para o codigo_cedente/Convênio
				def valid_convenio_maximum 
					6
				end				

				# Tamanho máximo de uma conta corrente no Banco Cecred
				def valid_conta_corrente_maximum 
					7
				end

				# codigo_cedente/Convênio deve ser obrigatório
				def valid_convenio_required
					true
				end
			##########################################################

			# Conforme descrito na documentação, o valor que deve constar em local do pagamento é
			# "PAGAVEL PREFERENCIALMENTE NAS COOPERATIVAS DO SISTEMA CECRED."
			def default_values
				super.merge({
					:local_pagamento   => 'PAGAVEL PREFERENCIALMENTE NAS COOPERATIVAS DO SISTEMA CECRED.'
				})
			end

			# Nosso Número descrito na documentação (Pag. 9).
			# 17 Dígitos: 8 primeiros dígitos = Conta corrente + dv, 9 dígitos restantes = Número do boleto (Sequencial)
			# Exemplo: 99999998000000001
			def nosso_numero
				"#{conta.conta_corrente}#{conta.conta_corrente_dv}#{numero_documento}".adjust_size_to(17, '0', :right)
			end

			#  === Código de barras do banco
			#
			#     ___________________________________________________________________________________________________
			#    | Posição  | Tamanho | Descrição                                                                   |
			#    |----------|---------|-----------------------------------------------------------------------------|
			#    | 20-25    |  06     | N° convênio da Cooperativa                                                  |
			#    | 26-33    |  08     | N° conta corrente                                                           |
			#    | 34-42    |  09     | Número do Boleto                                                            |
			#    | 43-44    |  02     | Código da carteira                                                          |
			#    ----------------------------------------------------------------------------------------------------
			#
			def codigo_de_barras_do_banco
				convenio         = "#{conta.convenio}".adjust_size_to(6, '0', :right)
				conta_corrente   = "#{conta.conta_corrente}#{conta.conta_corrente_dv}".adjust_size_to(8, '0', :right)
				numero_boleto    = "#{numero_documento}".adjust_size_to(9, '0', :right)
				carteira         = "#{conta.carteira}".adjust_size_to(2, '0', :right)

				"#{convenio}#{conta_corrente}#{numero_boleto}#{carteira}"
			end
		end
	end
end
