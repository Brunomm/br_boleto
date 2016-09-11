# encoding: utf-8
module BrBoleto
	module Boleto
		# Implementação de emissão de boleto bancário pela Caixa Econômica Federal.
		#
		# === Documentação Implementada
		#
		# A documentação na qual essa implementação foi baseada está localizada na pasta
		# 'documentacoes_dos_boletos/caixa' dentro dessa biblioteca.
		# === Carteiras suportadas
		#
		# Segue abaixo as carteiras suportadas da Caixa Econômica Federal <b>seguindo a documentação</b>:
		#
		#      ___________________________________________
		#     | Carteira | Descrição                     |
		#     |    14    | Cobrança Simples com registro |
		#     |    24    | Cobrança Simples sem registro |
		#     |__________________________________________|
		#     === Carteira/Modalidade:
		#     
		#      1/4 = Registrada   / Emissão do boleto(4-Beneficiário) 
		#      2/4 = Sem Registro / Emissão do boleto(4-Beneficiário) 
		#    
		#
		class Caixa < Base

			def conta_class
				BrBoleto::Conta::Caixa
			end

			#################  VALIDAÇÕES DINÂMICAS  #################
				def valid_numero_documento_maximum
					15
				end

				# Tamanho máximo para o codigo_cedente/Convênio
				def valid_convenio_maximum 
					6
				end

				# codigo_cedente/Convênio deve ser obrigatório
				def valid_convenio_required
					true
				end

				# Carteira deve ter 2 digitos
				def valid_carteira_length
					2
				end
				def valid_carteira_inclusion
					%w{14 24}
				end
			##########################################################

			# Conforme descrito na documentação, o valor que deve constar em local do pagamento é
			# "PREFERENCIALMENTE NAS CASAS LOTÉRICAS ATÉ O VALOR LIMITE"
			#
			def default_values
				super.merge({
					:local_pagamento   => 'PREFERENCIALMENTE NAS CASAS LOTÉRICAS ATÉ O VALOR LIMITE'
				})
			end

			def digito_verificador_nosso_numero
				BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new("#{conta.carteira}#{numero_documento}")
			end

			# Mostra o campo nosso número calculando o dígito verificador do nosso número.
			#
			# @return [String]
			#
			def nosso_numero
				"#{conta.carteira}#{numero_documento}-#{digito_verificador_nosso_numero}"
			end


			def nosso_numero_de_3_a_5
				nosso_numero[2..4]
			end

			def nosso_numero_de_6_a_8
				nosso_numero[5..7]
			end

			def nosso_numero_de_9_a_17
				nosso_numero[8..16]
			end

			# O Tipo de cobrança é o 1° caracter da carteira
			#
			# @return [String]
			#
			def tipo_cobranca
				conta.carteira[0] if conta.carteira.present?
			end

			# O Identificado de Emissão é o 2° e ultimo caracter da carteira
			# Normalmente é 4 onde significa que o Beneficiário emitiu o boleto.
			#
			# @return [String]
			#
			def identificador_de_emissao
				conta.carteira.last if conta.carteira.present?
			end

			#  === Código de barras do banco
			#
			#     ________________________________________________________________________________________
			#    | Posição  | Tamanho | Descrição                                                        |
			#    |----------|---------|------------------------------------------------------------------|
			#    | 20 - 25  |   06    | Código do Beneficiário                                           |
			#    | 26 - 26  |   01    | DV do Código do Beneficiário                                     |
			#    | 27 – 29  |   03    | Nosso Número - 3ª a 5ª posição do Nosso Número                   |
			#    | 30 – 30  |   01    | Constante 1, tipo de cobrança (1-Registrada / 2-Sem Registro)    |
			#    | 31 – 33  |   03    | Nosso Número - 6ª a 8ª posição do Nosso Número                   |
			#    | 34 – 34  |   01    | Constante 2, identificador de emissão do boleto (4-Beneficiário) |
			#    | 35 – 43  |   09    | Nosso Número - 9ª a 17ª posição do Nosso Número                  |
			#    | 44 – 44  |   01    | DV do Campo Livre                                                |
			#    -----------------------------------------------------------------------------------------
			#
			# @return [String]
			#
			def codigo_de_barras_do_banco
				@composicao_codigo_barras = nil				
				codigo_dv = Modulo11FatorDe2a9RestoZero.new(composicao_codigo_barras)
				"#{composicao_codigo_barras}#{codigo_dv}"
			end

			def composicao_codigo_barras
				return @composicao_codigo_barras if @composicao_codigo_barras
				@composicao_codigo_barras =  "#{conta.codigo_cedente}"
				@composicao_codigo_barras << "#{conta.codigo_cedente_dv}"
				@composicao_codigo_barras << "#{nosso_numero_de_3_a_5}"
				@composicao_codigo_barras << "#{tipo_cobranca}"
				@composicao_codigo_barras << "#{nosso_numero_de_6_a_8}"
				@composicao_codigo_barras << "#{identificador_de_emissao}"
				@composicao_codigo_barras << "#{nosso_numero_de_9_a_17}"
				@composicao_codigo_barras
			end
		end
	end
end
