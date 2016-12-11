# encoding: utf-8
module BrBoleto
	module Boleto
		# Implementação de emissão de boleto bancário pelo Banco Santander.
		#
		# === Documentação Implementada
		#
		# A documentação na qual essa implementação foi baseada está localizada na pasta
		# 'documentacoes_dos_boletos/bradesco' dentro dessa biblioteca.
		class Santander < Base
			def conta_class
				BrBoleto::Conta::Santander
			end

			#################  VALIDAÇÕES DINÂMICAS  #################
				def valid_numero_documento_maximum
					12
				end

				def valid_carteira_inclusion
					%w[101 102 121]
				end
				
				# Tamanho máximo para o codigo_cedente/Convênio
				def valid_convenio_maximum 
					7
				end				

				# Tamanho máximo de uma conta corrente no Banco Santander
				def valid_conta_corrente_maximum 
					9
				end

				# codigo_cedente/Convênio deve ser obrigatório
				def valid_convenio_required
					true
				end
			##########################################################

			# Conforme descrito na documentação, o valor que deve constar em local do pagamento é
			# "PAGÁVEL PREFERENCIALMENTE NAS AGÊNCIAS DO BANCO SANTANDER"
			def default_values
				super.merge({
					:local_pagamento   => 'PAGÁVEL PREFERENCIALMENTE NAS AGÊNCIAS DO BANCO SANTANDER'
				})
			end

			# Nosso Número descrito na documentação (Pag. 36).
			# Número do Documento com 12 (onze) caracteres + digito.
			# Exemplo: 999999999999-D
			def nosso_numero
				"#{numero_documento}-#{digito_verificador_nosso_numero}"
			end

			# Para o cálculo do dígito, será necessário acrescentar o Nosso Número (número do documento), 
			# e aplicar o módulo 11, com fatores de 2 a 9 com resto 0.
			def digito_verificador_nosso_numero
				BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new("#{numero_documento}")
			end

			#  === Código de barras do banco
			#     __________________________________________________________________
			#    | Posição  | Tamanho | Descrição                                   |
			#    |----------|---------|---------------------------------------------|
			#    | 20       |  01     | Fixo 9                                      |
			#    | 21-27    |  07     | Código do cedente padrão Santander          |
			#    | 28-40    |  13     | Nosso Número (Num. Documeto + DV)           |
			#    | 41       |  01     | IOF (somente para seguradoras)              |
			#    | 42-44    |  03     | Carteira de cobrança                        |
			#    -------------------------------------------------------------------
			#
			def codigo_de_barras_do_banco
				"9#{conta.convenio}#{numero_documento}#{digito_verificador_nosso_numero}0#{conta.carteira}"
			end
		end
	end
end
