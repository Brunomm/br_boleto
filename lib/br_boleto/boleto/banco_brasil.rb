# encoding: utf-8
module BrBoleto
	module Boleto
		# Implementação de emissão de boleto bancário pelo Banco BancoBrasil.
		#
		# === Documentação Implementada
		#
		# A documentação na qual essa implementação foi baseada está localizada na pasta
		# 'documentacoes_dos_boletos/bradesco' dentro dessa biblioteca.
		class BancoBrasil < Base
			def conta_class
				BrBoleto::Conta::BancoBrasil
			end

			#################  VALIDAÇÕES DINÂMICAS  #################
				def valid_numero_documento_maximum
					numero_documento_esperado[conta.convenio.to_s.size]
				end

				def valid_carteira_inclusion
					%w[11 12 15 16 17 18 31 51]
				end
				
				# Tamanho máximo de uma conta corrente no Banco BancoBrasil
				def valid_conta_corrente_maximum 
					8
				end

				# Tamanho máximo para o codigo_cedente/Convênio
				# def valid_convenio_maximum 
				# 	8
				# end	

				# codigo_cedente/Convênio deve ser obrigatório
				def valid_convenio_required
					true
				end
			##########################################################

			# === Código do Convênio VS. Número do Documento
			#
			# No caso do Banco do Brasil, o tamanho do código do cedente ditará o tamanho do número do documento.
			# Ou seja, quando o código do cedente for X, o tamanho do número do documento deverá ser Y.
			# Segue abaixo:
			#     ______________________________________________________________
			#    | Tamanho do Código Cedente  | Tamanho do Número do documento |
			#    |----------------------------|--------------------------------|
			#    |          04                |           07                   |
			#    |          06                |           05                   |
			#    |          07                |           10                   |
			#    |          08                |           09                   |
			#    ---------------------------------------------------------------
			#
			def numero_documento_esperado
				{ 0 => 0, 4 => 7, 6 => 5, 7 => 10, 8 => 9 }
			end


			# Conforme descrito na documentação, o valor que deve constar em local do pagamento é
			# "Pagável em qualquer banco até o vencimento. Após, atualize o boleto no site bb.com.br"
			def default_values
				super.merge({
					:local_pagamento   => 'Pagável em qualquer banco até o vencimento. Após, atualize o boleto no site bb.com.br'
				})
			end

			# Nosso Número descrito na documentação (Pag. 18 a 22):
			#
			# ==== Código do Convênio (4 dígitos) Número do Documento (7 dígitos) - Nosso número DV
			# Exemplo: 44447777777-D 
			#
			# ==== Código do Convênio (6 dígitos) Número do Documento (5 dígitos) - Nosso número DV
			# Exemplo: 66666655555-D
			#
			# ==== Código do Convênio (7 dígitos) Número do Documento (10 digitos)
			# Exemplo: 77777771010101010
			#
			# ==== Código do Convênio (8 dígitos) Número do Documento (9 dígitos)
			# Exemplo: 88888888999999999
			#
			def nosso_numero
				tamanho = conta.convenio.to_s.size
				if tamanho == 7 or tamanho == 8
					"#{conta.convenio}#{numero_documento}"
				else
					"#{conta.convenio}#{numero_documento}-#{digito_verificador_nosso_numero}"
				end
			end

			# Para o cálculo do dígito, será necessário acrescentar o código do convenio
			# antes do Nosso Número (número do documento), e aplicar o módulo 11, com fatores de 2 a 7.
			# @return [String] Retorno do cálculo do módulo 11 na base 7 (2,3,4,5,6,7)
			def digito_verificador_nosso_numero
				BrBoleto::Calculos::Modulo11FatorDe9a2RestoX.new("#{conta.convenio}#{numero_documento}")
			end

			#  === Código de barras do banco com Convênio de 4 e 6 dígitos
	      #     ___________________________________________________________________________
	      #    | Posição         |   Tamanho     | Descrição                               |
	      #    |-----------------|---------------|-----------------------------------------|
	      #    | 20-30           |     11          | Nosso-Número, sem dígito verificador  |
	      #    | 20-23 ou 20-25  |   4 ou 6      | Código do cedente fornecido pelo Banco  |
	      #    | 24-30 ou 26-30  |   7 ou 5      | Nosso-Número, sem dígito verificador    |
	      #    | 31-34           |     04          | Agência (sem o dígito)                |
	      #    | 35-42           |     08          | Conta corrente (sem o dígito)         |
	      #    | 43-44           |     02          | Carteira                              |
	      #    -----------------------------------------------------------------------------
	      #
	      # === Código de barras do banco com Convênio de 7 e 8 dígitos
	      #     ___________________________________________________________________________
	      #    | Posição         |   Tamanho     | Descrição                               |
	      #    |-----------------|---------------|-----------------------------------------|
	      #    | 20-30           |     17        | Nosso-Número, sem dígito verificador    |
	      #    | 20-32 ou 20-33  |  7 ou 8       | Código do cedente fornecido pelo Banco  |
	      #    | 33-42 ou 34-42  |  9 ou 10      | Nosso-Número, sem dígito verificador    |
	      #    | 43-44           |    02         | Carteira                                |
	      #    ----------------------------------------------------------------------------
	      #
			def codigo_de_barras_do_banco
				tamanho = conta.convenio.to_s.size
				if tamanho == 7 or tamanho == 8
					"000000#{conta.convenio}#{numero_documento}#{conta.carteira}"
				else
					"#{conta.convenio}#{numero_documento}#{conta.agencia}#{conta.conta_corrente}#{conta.carteira}"
				end
			end

		end
	end
end
