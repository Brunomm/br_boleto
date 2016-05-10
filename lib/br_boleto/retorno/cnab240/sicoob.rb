# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		module Cnab240
			class Sicoob < BrBoleto::Retorno::Cnab240::Base

			private
				# O valor da posição que representa o nosso_numero está 
				# subdividido e várias partes para o sicoob.
				#
				# Pelo Layout da FEBRABAN o valor para a informação do nosso_numero
				# Está localizado entre as posições 38 a 57 contendo 20 caracteres.
				#
				# Nosso Número:
				# - NumTitulo       - 10 posições (01 a 10) 
				# - Parcela         - 02 posições (11 a 12) - "01" se parcela única
				# - Modalidade      - 02 posições (13 a 14) - vide planilha "Capa" deste arquivo
				# - Tipo Formulário - 01 posição  (15 a 15):
				#    - "1" = auto-copiativo
				#    - "3" = auto-envelopável
				#    - "4" = A4 sem envelopamento
				#    - "6" = A4 sem envelopamento 3 vias
				# - Em branco - 05 posições (16 a 20)
				#
				def segmento_t_fields #:doc:
					super.merge({ 
					#    ATRIBUTO               POSIÇÃO DA LINHA
						nosso_numero:                 38..47,
						modalidade:                   50..51
					})
				end
			end
		end
	end
end