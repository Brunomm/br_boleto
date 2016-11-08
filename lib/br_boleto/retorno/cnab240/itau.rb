# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		module Cnab240
			class Itau < BrBoleto::Retorno::Cnab240::Base


				def segmento_t_fields #:doc:
					super.merge({ 
					#    ATRIBUTO                 POSIÇÃO DA LINHA
						#agencia_com_dv:               19..23, # ITAU não utiliza o DV da agencia
						agencia_sem_dv:                19..22,
						numero_conta_dv:               37,
						numero_conta:                  31..35,
						dv_conta_e_agencia:            36,
						carteira:                      38..40,
						numero_documento:              41..48,
					})
				end

			end
		end
	end
end