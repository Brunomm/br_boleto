# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		module Cnab400
			class Itau < BrBoleto::Retorno::Cnab400::Base
			private
				def detalhe_fields #:doc:
					{ #    ATRIBUTO                             POSIÇÃO DA LINHA

						sacado_documento:                             4..17,
						agencia_sem_dv:                               18..21,
						numero_conta_sem_dv:                          24..28,
						numero_conta_dv:                              29,
						numero_documento:                             53..70,
						carteira:                                     83..85,
						nosso_numero_sem_dv:                          86..93,
						nosso_numero_dv:                              94,
						cod_carteira:                                 108,
						codigo_ocorrencia_banco_correspondente:       109..110,
						data_ocorrencia:                              111..116,
						data_ocorrencia_sacado:                       111..116,
						data_vencimento:                              147..152,
						valor_titulo:                                 153..165,
						banco_recebedor:                              166..168,
						agencia_recebedora_com_dv:                    169..173,
						especie_titulo:                               174..175,
						valor_tarifa:                                 176..188,
						valor_iof:                                    215..227,
						valor_abatimento:                             228..240,
						valor_desconto:                               241..253,
						valor_pago:                                   254..266,
						valor_ocorrencia_sacado:                      254..266,
						valor_liquido:                                254..266,
						valor_juros_multa:                            267..279,
						valor_outros_creditos:                        280..292,
						data_credito:                                 296..301,
						sacado_nome:                                  325..354,
					}
				end
			end
		end
	end
end