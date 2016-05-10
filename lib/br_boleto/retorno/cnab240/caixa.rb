# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		module Cnab240
			class Caixa < BrBoleto::Retorno::Cnab240::Base

			private
				# O Banco da Caixa não tem a capacidade de seguir o padrão da FEBRABAN
				# então tem algumas particularidades nas posições dos valores:
				#  - numero_conta (codigo cedente)
				#  - Modalidade
				#  - Nosso número
				#  - Número documento
				#
				def segmento_t_fields #:doc:
					super.merge({ 
					#    ATRIBUTO               POSIÇÃO DA LINHA
						numero_conta_com_dv:         24..29, # Código do cedente
						numero_conta_sem_dv:         24..29, # Código do cedente
						dv_conta_e_agencia:          250, # Defino como 250 para setar nil ao atributo
						modalidade:                  40..41,
						nosso_numero:                42..56,
						# carteira:                  58..58, # Cartéira segue o padrão da FEBRABAN
						numero_codumento:            59..69,
					})
				end
			end
		end
	end
end