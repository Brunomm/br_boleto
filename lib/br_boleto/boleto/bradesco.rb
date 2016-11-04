# encoding: utf-8
module BrBoleto
	module Boleto
		# Implementação de emissão de boleto bancário pelo Banco Bradesco.
		#
		# === Documentação Implementada
		#
		# A documentação na qual essa implementação foi baseada está localizada na pasta
		# 'documentacoes_dos_boletos/bradesco' dentro dessa biblioteca.
		class Bradesco < Base
			def conta_class
				BrBoleto::Conta::Bradesco
			end

			#################  VALIDAÇÕES DINÂMICAS  #################
				def valid_numero_documento_maximum
					11
				end

				def valid_carteira_inclusion
					%w[06 09 19 21 22]
				end
				
				# Tamanho máximo para o codigo_cedente/Convênio
				def valid_convenio_maximum 
					7
				end				

				# Tamanho máximo de uma conta corrente no Banco Bradesco
				def valid_conta_corrente_maximum 
					7
				end

				# codigo_cedente/Convênio deve ser obrigatório
				def valid_convenio_required
					true
				end
			##########################################################

			# Conforme descrito na documentação, o valor que deve constar em local do pagamento é
			# "PAGÁVEL PREFERENCIALMENTE NA REDE BRADESCO OU NO BRADESCO EXPRESSO"
			def default_values
				super.merge({
					:local_pagamento   => 'PAGÁVEL PREFERENCIALMENTE NA REDE BRADESCO OU NO BRADESCO EXPRESSO'
				})
			end

			# Nosso Número descrito na documentação (Pag. 36).
			# Carteira com 2 (dois) caracteres / N.Número com 11 (onze) caracteres + digito.
			# Exemplo: 99 / 99999999999-D
			def nosso_numero
				"#{conta.carteira}/#{numero_documento}-#{digito_verificador_nosso_numero}"
			end

			# Para o cálculo do dígito, será necessário acrescentar o número da carteira à esquerda
			# antes do Nosso Número (número do documento), e aplicar o módulo 11, com fatores de 2 a 7.
			# @return [String] Retorno do cálculo do módulo 11 na base 7 (2,3,4,5,6,7)
			def digito_verificador_nosso_numero
				BrBoleto::Calculos::Modulo11FatorDe2a7.new("#{conta.carteira}#{numero_documento}")
			end

			#  === Código de barras do banco
			#
			#     ___________________________________________________________________________________________________
			#    | Posição  | Tamanho | Descrição                                                                   |
			#    |----------|---------|-----------------------------------------------------------------------------|
			#    | 20-23    |  04     | Agência (Sem o digito, completar com zeros a esquerda se necessário)        |
			#    | 24-25    |  02     | Carteira                                                                    |
			#    | 26-36    |  11     | Número do Documento - Número do Nosso Número (Sem o digito verificador)     |
			#    | 37-43    |  07     | Conta Corrente (Sem o digito, completar com zeros a esquerda se necessário) |
			#    | 44       |  01     | Zero                                                                        |
			#    ----------------------------------------------------------------------------------------------------
			#
			def codigo_de_barras_do_banco
				conta_corrente = "#{conta.conta_corrente}".adjust_size_to(7, '0', :right)
				"#{conta.agencia}#{conta.carteira}#{numero_documento}#{conta_corrente}0"
			end
		end
	end
end
