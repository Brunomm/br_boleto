# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		module Cnab400
			class Caixa < BrBoleto::Retorno::Cnab400::Base
			private
				def detalhe_fields #:doc:
					{ #    ATRIBUTO               POSIÇÃO DA LINHA

						sacado_documento:              4..17,
						agencia_sem_dv:                18..21,
						codigo_cedente:                22..27,
						carteira:                      57..58,
						nosso_numero_sem_dv:           57..73,
						cod_carteira:                  107..108,
						codigo_ocorrencia_retorno:     109..110,
						data_ocorrencia:               111..116,
						data_ocorrencia_sacado:        111..116,
						numero_documento:              117..126,
						data_vencimento:               147..152,
						valor_titulo:                  153..165,
						banco_recebedor:               166..168,
						agencia_recebedora_com_dv:     169..173,
						especie_titulo:                174..175,
						valor_tarifa:                  176..188,
						valor_iof:                     215..227,
						valor_abatimento:              228..240,
						valor_desconto:                241..253,
						valor_pago:                    254..266,
						valor_ocorrencia_sacado:       254..266,
						valor_liquido:                 254..266,
						valor_juros_multa:             267..279,
						valor_multa:                   280..292,
						codigo_moeda:                  293..293,
						data_credito:                  294..299,
						# valor_outras_despesas:         189..201,
						# valor_outros_creditos:         280..292,

						motivo_ocorrencia_original_1:  80..82,
						# motivo_ocorrencia_original_2:  321..322,
						# motivo_ocorrencia_original_3:  323..324,
						# motivo_ocorrencia_original_4:  325..326,
						# motivo_ocorrencia_original_5:  327..328,
					}
				end
			end
		end
	end
end