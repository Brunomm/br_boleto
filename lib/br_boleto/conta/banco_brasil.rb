# encoding: utf-8
module BrBoleto
	module Conta
		class BancoBrasil < BrBoleto::Conta::Base

			# MODALIDADE CARTEIRA:
			#      _________________________________________________________________
			#     | Carteira  | Descrição                                          |
			#     |   11      | Cobrança Simples - Com Registro                    |
			#     |   12      | Cobrança Indexada - Com Registro                   |
			#     |   15      | Cobrança de Prêmios de Seguro - Com Registro       |
			#     |   16      | Cobranca Simples                                   |
			#     |   17      | Cobranca Direta Especial - Com Registro            |
			#     |   18      | Cobranca Simples  (Nosso Número 11 Dígitos)        |
			#     |   31      | Cobrança Caucionada/Vinculada - Com Registro       |
			#     |   51      | Cobrança Descontada - Com Registro                 |
			#     -----------------------------------------------------------------


			def default_values
				super.merge({
					carteira:                      '18', 			 
					valid_carteira_required:       true, # <- Validação dinâmica que a modalidade é obrigatória
					valid_carteira_length:         2,    # <- Validação dinâmica que a modalidade deve ter 2 digitos
					valid_carteira_inclusion:      carteiras_suportadas, # <- Validação dinâmica de valores aceitos para a modalidade
					codigo_carteira:               '1',   # Cobrança Simples
					valid_codigo_carteira_length:   1,    # <- Validação dinâmica que a modalidade deve ter 1 digito
					valid_conta_corrente_required: true,  # <- Validação dinâmica que a conta_corrente é obrigatória
					valid_conta_corrente_maximum:  8,     # <- Validação que a conta_corrente deve ter no máximo 8 digitos
					valid_convenio_required:       true,  # <- Validação que a convenio deve ter obrigatório
					# valid_convenio_maximum:        8,     # <- Validação que a convenio deve ter no máximo 8 digitos
				})
			end

			def codigo_banco
				'001'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'9'
			end

			def nome_banco
				@nome_banco ||= 'BANCO DO BRASIL S.A.'
			end

			def versao_layout_arquivo_cnab_240
				'083'
			end

			def versao_layout_lote_cnab_240
				'042'
			end

			# Carteiras suportadas
			def carteiras_suportadas
				%w[11 12 15 16 17 18 31 51]
			end

			def agencia_dv
				# utilizando a agencia com 4 digitos
				# para calcular o digito
				@agencia_dv ||= BrBoleto::Calculos::Modulo11FatorDe9a2RestoX.new(agencia).to_s
			end

			def conta_corrente_dv
				@conta_corrente_dv ||= BrBoleto::Calculos::Modulo11FatorDe9a2RestoX.new(conta_corrente).to_s
			end

			# Campo Agência / Código do Cedente
			# @return [String] Agência com 4 caracteres - digito da agência / Conta de Cobrança com 8 caracteres - Digito da Conta
			# Exemplo: 9999-D / 99999999-D
			def agencia_codigo_cedente
				"#{agencia}-#{agencia_dv} / #{conta_corrente}-#{conta_corrente_dv}"
			end

		end
	end
end
