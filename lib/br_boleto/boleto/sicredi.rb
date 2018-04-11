# encoding: utf-8
module BrBoleto
	module Boleto

		class Sicredi < Base

			def conta_class
				BrBoleto::Conta::Sicredi
			end

				#################  VALIDAÇÕES DINÂMICAS  #################
				def valid_numero_documento_maximum
					5
				end

				def valid_carteira_inclusion
					%w[1 3]
				end

				# Tamanho máximo para o codigo_cedente/Convênio
				def valid_convenio_maximum
					5
				end

				# Tamanho máximo de uma conta corrente no Banco Sicredi
				def valid_conta_corrente_maximum
					5
				end

				# codigo_cedente/Convênio deve ser obrigatório
				def valid_convenio_required
					true
				end
			##########################################################

			# Conforme descrito na documentação, o valor que deve constar em local do pagamento é
			# "PAGÁVEL PREFERENCIALMENTE NAS COOPERATIVAS DE CRÉDITO DO SICREDI"
			def default_values
				super.merge({
					:local_pagamento   => 'PAGÁVEL PREFERENCIALMENTE NAS COOPERATIVAS DE CRÉDITO DO SICREDI'
				})
			end

			# Nosso Número descrito na documentação (Pag. 84).
			# O campo Nosso Número deve ser apresentado no formato AA/BXXXXX-D, onde:
			# AA = Ano atual
			# B = Byte que pode ser de 2 a 9. Somente será 1 se forem boletos pré-impressos.
			# XXXXX = número sequencial
			# D = dígito verificador calculado
			# Exemplo: "14/200022-5"
			def nosso_numero
				"#{ano}/#{conta.byte_id}#{numero_documento}-#{digito_verificador_nosso_numero}"
			end
			def digito_verificador_nosso_numero
				BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new("#{conta.agencia}#{conta.posto}#{conta.codigo_cedente}#{ano}#{conta.byte_id}#{numero_documento}")
			end
			def ano
				data_documento.strftime('%y')
			end

			#  === Código de barras do banco
			#
			#     ___________________________________________________________________________________________________
			#    | Posição | Tamanho | Descrição                                                           |
			#    |---------|---------|---------------------------------------------------------------------|
			#    | 20 – 20 |   01    | Carteira  (1 - Com Registro, 3 - Sem Registro)                      |
			#    | 21 – 21 |   01    | Código da Carteira (1 - Carteira Simples)                           |
			#    | 22 – 30 |   09    | Nosso número com o digito identificador                             |
			#    | 31 – 34 |   04    | Cooperativa de crédito/agência beneficiária                         |
			#    | 35 – 36 |   02    | Posto da cooperativa de crédito/agência beneficiária                |
			#    | 37 – 41 |   05    | Código do beneficiário                                              |
			#    | 42 – 42 |   01    | Será 1 quando houver valor expresso no campo “valor do documento”   |
			#    | 43 – 43 |   01    | Fixo 0                                                              |
			#    | 44 – 44 |   01    | DV do campo livre                                                   |
			#    |_________________________________________________________________________________________|
			#
			def codigo_de_barras_do_banco
				campo_livre =  "#{conta.carteira}"
				campo_livre << "#{conta.codigo_carteira}"
				campo_livre << "#{nosso_numero_codigo_de_barras}"
				campo_livre << "#{conta.agencia}"
				campo_livre << "#{conta.posto}"
				campo_livre << "#{conta.codigo_cedente}"
				campo_livre << "#{valor_expresso}"
				campo_livre << "0"
				campo_livre << "#{codigo_dv(campo_livre)}"
				campo_livre
			end
			def codigo_dv(codigo)
				Modulo11FatorDe2a9RestoZero.new(codigo)
			end
			def nosso_numero_codigo_de_barras
				"#{ano}#{conta.byte_id}#{numero_documento}#{digito_verificador_nosso_numero}"
			end
			def valor_expresso
				@valor_documento.present? ? '1' : '0'
			end

		end
	end
end
