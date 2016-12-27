# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		module Cnab400
			class BancoBrasil < BrBoleto::Retorno::Cnab400::Base
			private
				def detalhe_fields #:doc:
					{ #    ATRIBUTO                 POSIÇÃO DA LINHA

						agencia_sem_dv:                18..21,
						agencia_com_dv:                18..22,
						numero_conta_sem_dv:           23..30,
						numero_conta_dv:               31,
						#convenio:                     32..38,
						#numero_controle:              39..63,
						nosso_numero_sem_dv:           64..79,
						nosso_numero_dv:               80,
						tipo_cobranca:                 81..81,
						variacao_carteira:             92..94,
						carteira:                      107..108,
						codigo_ocorrencia_retorno:     109..110,
						data_ocorrencia:               111..116,
						data_ocorrencia_sacado:        111..116,
						numero_documento:              117..126,
						data_vencimento:               147..152,
						valor_titulo:                  153..165,
						banco_recebedor:               166..168,
						agencia_recebedora_com_dv:     169..173,
						especie_titulo:                174..175,
						data_credito:                  176..181,
						valor_tarifa:                  182..188,
						valor_outras_despesas:         189..201,
						valor_iof:                     215..227,
						valor_abatimento:              228..240,
						valor_desconto:                241..253,
						valor_pago:                    254..266,
						valor_ocorrencia_sacado:       254..266,
						valor_liquido:                 254..266,
						valor_juros_multa:             267..279,
						valor_outros_creditos:         280..292,
						
						motivo_ocorrencia_original_1:  87..88,
					}
				end
			end
		end
	end
end