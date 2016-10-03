# encoding: utf-8
module BrBoleto
	module Conta
		class Sicoob < BrBoleto::Conta::Base
			
			# MODALIDADE
			# O banco siccob utiliza a combinação da carteira e modalidade para
			# saber se é um pagamento com registro, sem registrou ou caucionada.
			# Carteira / Modalidade  =  Tipo de pagamento
			#    1     /    01       = Simples com Registro
			#    1     /    02       = Simples sem Registro
			#    3     /    03       = Garantia caicionada

			def default_values
				super.merge({
					carteira:                      '1',         # Simples
					modalidade:                    '01',        # Com registro
					valid_modalidade_required:     true,        # <- Validação dinâmica que a modalidade é obrigatória
					valid_modalidade_length:       2,           # <- Validação dinâmica que a modalidade deve ter 2 digitos
					valid_modalidade_inclusion:    %w[01 02 03],# <- Validação dinâmica de valores aceitos para a modalidade
					valid_carteira_required:       true,        # <- Validação dinâmica que a carteira é obrigatória
					valid_carteira_length:         1,           # <- Validação dinâmica que a carteira deve ter 1 digito
					valid_carteira_inclusion:      %w[1 3],     # <- Validação dinâmica de valores aceitos para a carteira
					codigo_carteira:               '1',  # Cobrança Simples
					valid_codigo_carteira_length:   1,           # <- Validação dinâmica que a carteira deve ter 1 digito
					valid_conta_corrente_required: true, # <- Validação dinâmica que a conta_corrente é obrigatória
					valid_conta_corrente_maximum:  8,    # <- Validação que a conta_corrente deve ter no máximo 8 digitos
					valid_codigo_cedente_maximum:  6,    # <- Validação que a codigo_cedente/convênio deve ter no máximo 7 digitos
				})
			end

			def codigo_banco
				'756'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'0'
			end

			def nome_banco
				@nome_banco ||= 'SICOOB'
			end

			def versao_layout_arquivo_cnab_240
				'081'
			end

			def versao_layout_lote_cnab_240
				'040'
			end

			def agencia_dv
				# utilizando a agencia com 4 digitos
				# para calcular o digito
				@agencia_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(agencia).to_s
			end

			def conta_corrente_dv
				# utilizando a conta corrente com 5 digitos
				# para calcular o digito
				@conta_corrente_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(conta_corrente).to_s
			end
		end
	end
end
