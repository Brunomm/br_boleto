# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		module Cnab240
			class Santander < BrBoleto::Retorno::Cnab240::Base

				def segmento_t_fields #:doc:
					super.merge({ 
					#    ATRIBUTO                 POSIÇÃO DA LINHA
						agencia_com_dv:                18..22,
						agencia_sem_dv:                18..21,
						numero_conta_sem_dv:           23..31,
						numero_conta_dv:               32,
						nosso_numero_sem_dv:           41..53,
						carteira:                      54..54,
						tipo_cobranca:                 54..54,
						numero_documento:              55..69,
						data_vencimento:               70..77,
						valor_titulo:                  78..92,
						banco_recebedor:               93..95,
						agencia_recebedora_com_dv:     96..100,
						identificacao_titulo_empresa:  101..125,
						codigo_moeda:                  126..127,
						sacado_tipo_documento:         128..128,
						sacado_documento:              129..143,
						sacado_nome:                   144..183,
						valor_tarifa:                  194..208,
						motivo_ocorrencia:             209..218

						# conta_cobranca:                184..193
						# numero_contrato:               189..198,
					})
				end
			end
		end
	end
end