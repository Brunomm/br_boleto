# encoding: utf-8
module BrBoleto
	module Boleto
		# Implementação de emissão de boleto bancário pelo Banco Sicoob.
		#
		# === Documentação Implementada
		#
		# A documentação na qual essa implementação foi baseada está localizada na pasta
		# 'documentacoes_dos_boletos/sicoob' dentro dessa biblioteca.
		#
		class Sicoob < Base
			def conta_class
				BrBoleto::Conta::Sicoob
			end

			#################  VALIDAÇÕES DINÂMICAS  #################
				def valid_numero_documento_maximum
					7
				end
				def valid_modalidade_inclusion
					%w{01 02 03}
				end

				def valid_carteira_inclusion
					%w[1 3]
				end
				
				# Tamanho máximo para o codigo_cedente/Convênio
				def valid_convenio_maximum 
					6
				end

				# codigo_cedente/Convênio deve ser obrigatório
				def valid_convenio_required
					true
				end
			##########################################################

			def default_values
				super.merge({
					local_pagamento: "PREFERENCIALMENTE COOPERATIVAS DA REDE SICOOB"
				})
			end

			# O nosso número descrino na documentação é formado pelo numero do documento mais o digito
			# verificador no nosso_numero, que é um cálculo descrito na documentação.
			#
			# @return [String]
			#
			def nosso_numero
				"#{numero_documento}-#{digito_verificador_nosso_numero}"
			end

			#  === Código de barras do banco
			#
			#     ___________________________________________________________
			#    | Posição | Tamanho | Descrição                             |
			#    |---------|---------|---------------------------------------|
			#    | 20 - 20 |    01   | Código da carteira                    |
			#    | 21 - 24 |    04   | Código da agência                     |
			#    | 25 - 26 |    02   | Código da modalidade de cobrança (01) |
			#    | 27 - 33 |    07   | Código do Cedente                     |
			#    | 34 - 41 |    08   | Nosso Número do título                |
			#    | 42 - 44 |    03   | Número da Parcela do Título (001)     |
			#    |___________________________________________________________|
			#   Tamanho total: 25 
			#
			# @return [String]
			#
			def codigo_de_barras_do_banco
				"#{conta.carteira}#{conta.agencia}#{conta.modalidade}#{conta.codigo_cedente}#{conta.codigo_cedente_dv}#{nosso_numero.gsub('-','')}#{parcelas}"
			end

			def digito_verificador_nosso_numero
				BrBoleto::Calculos::Modulo11Fator3197.new("#{conta.agencia}#{conta.codigo_cedente.rjust(9, '0')}#{conta.codigo_cedente_dv}#{numero_documento}")
			end
		end
	end
end
