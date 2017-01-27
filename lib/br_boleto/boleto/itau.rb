# encoding: utf-8
module BrBoleto
	module Boleto
		# Implementação de emissão de boleto bancário pelo Banco Itau.
		#
		# === Documentação Implementada
		#
		# A documentação na qual essa implementação foi baseada está localizada na pasta
		# 'documentacoes_dos_boletos/itau' dentro dessa biblioteca.
		class Itau < Base
			def conta_class
				BrBoleto::Conta::Itau
			end

			#################  VALIDAÇÕES DINÂMICAS  #################
				def valid_numero_documento_maximum
					8
				end

				def valid_carteira_inclusion
					%w[104 105 107 108 109 112 113 116 117 119 121 122 126 131 134 135 136 142 143 146 147 150 168 169 174 175 180 191 196 198]
				end
				
				# Tamanho máximo para o codigo_cedente/Convênio
				def valid_convenio_maximum 
					5
				end				

				# Tamanho máximo de uma conta corrente no Banco Itau
				def valid_conta_corrente_maximum 
					5
				end

				# codigo_cedente/Convênio deve ser obrigatório
				def valid_convenio_required
					true
				end
			##########################################################

			# Conforme descrito na documentação, o valor que deve constar em local do pagamento é
			# "PAGÁVEL EM QUALQUER BANCO OU CORRESPONDENTE ATÉ O VENCIMENTO."
			def default_values
				super.merge({
					:local_pagamento   => "PAGÁVEL EM QUALQUER BANCO OU CORRESPONDENTE ATÉ O VENCIMENTO."
				})
			end

			# Nosso Número descrito na documentação (Pag. 50).
			# Carteira com 3 caracteres / N.Número com 8 caracteres + digito.
			# Exemplo: 999 / 99999999-D
			def nosso_numero
				"#{conta.carteira}/#{numero_documento}-#{digito_verificador_nosso_numero}"
			end
			
			# No arquivo de retorno a carteira não vem junto com o nosso núemro
			#
			def nosso_numero_retorno
				"#{nosso_numero}".gsub(/[^\w\d]/i, '')[3..-1]
			end

			# Para a grande maioria das carteiras, são considerados para a obtenção do dígito do nosso número,
			# os dados “AGÊNCIA / CONTA (sem dígito) / CARTEIRA / NOSSO NÚMERO”, calculado pelo critério do Módulo 10.
			#
			# À exceção, estão as carteiras 126 - 131 - 146 - 150 e 168 cuja obtenção
			# está baseada apenas nos dados “CARTEIRA/NOSSO NÚMERO” da operação.
			def digito_verificador_nosso_numero
				if conta.carteira.in?(conta.carteiras_especiais_nosso_numero_dv)
					BrBoleto::Calculos::Modulo10.new("#{conta.carteira}#{numero_documento}")
				else
					BrBoleto::Calculos::Modulo10.new("#{conta.agencia}#{conta.conta_corrente}#{conta.carteira}#{numero_documento}")
				end
			end

			# As carteiras de cobrança 107, 122, 142, 143, 196 e 198 são carteiras especiais, sem registro, na qual são utilizadas 15 posições
			# numéricas para identificação do título liquidado (8 do Nosso Número e 7 do Seu Número).
			#
			#  === Código de barras do banco (Carteiras 107, 122, 142, 143, 196 e 198)
			#
			# Para essas carteiras o formato do código de barras é o seguinte:	
			#     ___________________________________________________________________________________________________
			#    | Posição  | Tamanho | Descrição                                                                   |
			#    |----------|---------|-----------------------------------------------------------------------------|
			#    | 20-22    |   03    | Carteira                                                                    |
			#    | 23-30    |   08    | Nosso Número (Sem o digito verificador)                                     |
			#    | 31-37    |   07    | Seu Número (Número do Documento)                                            |
			#    | 38-42    |   05    | Códgigo Cedente (Convênio)                                                  |
			#    | 43-43    |   01    | DAC dos campos acima (posições 20 a 42) MOD 10                                                  |
			#    | 44-44    |   01    | Zero                                                                        |
			#    ----------------------------------------------------------------------------------------------------
			#
			# === Demais Carteiras
			#
			# Para as demais carteiras o formato do código de barras é o seguinte:
			#     _________________________________________________________________________________________
			#    | Posição  | Tamanho | Descrição                                                         |
			#    |----------|---------|-------------------------------------------------------------------|
			#    | 20-22    |  03     | Carteira                                                          |
			#    | 23-30    |  08     | Número do documento                                               |
			#    | 31-31    |  01     | Digito verificador nosso numero                                   |
			#    | 32-35    |  04     | Agência                                                           |
			#    | 36-40    |  05     | Número da conta corrente                                          |
			#    | 41-41    |  01     | Digito verificador conta corrente                                 |
			#    | 42-44    |  03     | Zeros                                                             |
			#    ------------------------------------------------------------------------------------------
			#
			#
			def codigo_de_barras_do_banco
				 if conta.carteira.in?(conta.carteiras_especiais_codigo_barras)
				 	seu_numero = numero_documento.adjust_size_to(7)
					codigo = "#{conta.carteira}#{numero_documento}#{seu_numero}#{conta.codigo_cedente}"
					mod_10 = BrBoleto::Calculos::Modulo10.new(codigo)
					"#{codigo}#{mod_10}0"
				else
					"#{conta.carteira}#{numero_documento}#{digito_verificador_nosso_numero}#{conta.agencia}#{conta.conta_corrente}#{conta.conta_corrente_dv}000"
				end
			end
		end
	end
end
