# encoding: utf-8
module BrBoleto
	module Conta
		class Cecred < BrBoleto::Conta::Base

			# MODALIDADE CARTEIRA:
			#      _________________________________________________________
			#     | Carteira | Descrição                                   |
			#     |   1      | Com Cadastramento (Cobrança Registrada)      |
			#     ---------------------------------------------------------

			def default_values
				super.merge({
					carteira:                      '1', 			 
					valid_carteira_required:       true,  # <- Validação dinâmica que a modalidade é obrigatória
					valid_carteira_length:         1,     # <- Validação dinâmica que a modalidade deve ter 2 digitos
					valid_carteira_inclusion:      %w[1], # <- Validação dinâmica de valores aceitos para a modalidade
					codigo_carteira:               '1',   # Cobrança Simples
					valid_codigo_carteira_length:   1,    # <- Validação dinâmica que a modalidade deve ter 1 digito
					valid_conta_corrente_required: true,  # <- Validação dinâmica que a conta_corrente é obrigatória
					valid_conta_corrente_maximum:  7,     # <- Validação que a conta_corrente deve ter no máximo 7 digitos
					valid_convenio_required:       true,  # <- Validação que a convenio deve ter obrigatório
					valid_convenio_maximum:        6,     # <- Validação que a convenio deve ter no máximo 7 digitos
				})
			end

			def codigo_banco
				'085'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'1'
			end

			def nome_banco
				@nome_banco ||= 'CECRED'
			end

			def versao_layout_arquivo_cnab_240
				'087'
			end

			def versao_layout_lote_cnab_240
				'045'
			end

			def agencia_dv
				# utilizando a agencia com 4 digitos
				# para calcular o digito
				@agencia_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9.new(agencia).to_s
			end

			def conta_corrente_dv
				@conta_corrente_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9.new(conta_corrente).to_s
			end

			# Campo Agência / Código do Cedente
			# @return [String] Agência com 4 caracteres - digito da agência / Conta de Cobrança com 7 caracteres - Digito da Conta
			# Exemplo: 9999-D / 9999999-D
			def agencia_codigo_cedente
				"#{agencia}-#{agencia_dv} / #{conta_corrente}-#{conta_corrente_dv}"
			end

		end
	end
end
