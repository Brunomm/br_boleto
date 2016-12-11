# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		module Cnab400
			class Sicredi < BrBoleto::Retorno::Cnab400::Base
			private
				# O valor da posição que representa o nosso_numero está 
				# subdividido em várias partes para o sicredi.
				#
				# Nosso Numero (Posição 048 a 062) conforme exemplo informações abaixo:
				# - Ano             - 02 posições (48 a 49) - Ano Atual 
				# - Byte Idt.       - 01 posições (50 a 50) - Byte de identificação
				# - Número Seq.     - 05 posições (51 a 55) - Número sequencial
				# - DV nosso num.   - 01 posição  (56 a 56) - Dígito verificador nosso número
				# - Em branco       - 06 posições (57 a 62)
				#
				# 13 - ano atual
				# 2  - byte
				# xxxxx - número sequencial
				# D - dígito verificador calculado
				# Ex: 132xxxxxD
				#
				def detalhe_fields #:doc:
					{ #    ATRIBUTO               POSIÇÃO DA LINHA

						carteira:                      14..14,
						codigo_pagador_cooperativa:    15..19,
						codigo_pagador_associado:      20..24,
						nosso_numero_sem_dv:           48..55,
						nosso_numero_dv:               56,
						data_ocorrencia:               111..116,
						data_ocorrencia_sacado:        111..116,
						numero_documento:              117..126,
						data_vencimento:               147..152,
						valor_titulo:                  153..165,
						especie_titulo:                175..175,
						valor_tarifa:                  176..188,
						valor_outras_despesas:         189..201,
						valor_abatimento:              228..240,
						valor_desconto:                241..253,
						valor_pago:                    254..266,
						valor_ocorrencia_sacado:       254..266,
						valor_liquido:                 254..266,
						valor_juros_multa:             267..279,
						valor_outros_creditos:         280..292,

						# sacado_documento:              4..17,
						# agencia_sem_dv:                25..29,
						# agencia_recebedora_com_dv:     169..173,
						# banco_recebedor:               166..168,
						# data_credito:                  296..301,
					}
				end
			end
		end
	end
end