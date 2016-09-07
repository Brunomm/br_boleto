# encoding: utf-8
module BrBoleto
	module Conta
		class Caixa < BrBoleto::Conta::Base
			
			# MODALIDADE CARTEIRA
			#   opcoes:
			#     11: título Registrado emissão CAIXA
			#     14: título Registrado emissão Cedente
			#     21: título Sem Registro emissão CAIXA

			# versão do aplicativo da caixa
			attr_accessor :versao_aplicativo

			###############################  VALIDAÇÕES DINÂMICAS ###############################
				# Versão do aplicativo
				attr_accessor :valid_versao_aplicativo_required
			#####################################################################################

			validates :agencia,           custom_length: { maximum: 5, minimum: 4 }
			validates :versao_aplicativo, custom_length: { maximum: 4 }
			validates :versao_aplicativo, presence: true, if: :valid_versao_aplicativo_required

			def default_values
				super.merge({
					carteira:             '14', # Com registro
					valid_carteira_required:     true,         # <- Validação dinâmica que a modalidade é obrigatória
					valid_carteira_length:       2,            # <- Validação dinâmica que a modalidade deve ter 2 digitos
					valid_carteira_inclusion:    %w[11 14 21], # <- Validação dinâmica de valores aceitos para a modalidade
					convenio_required:     true,         # <- Validação que a convenio deve ter obrigatório
					convenio_maximum:      6,            # <- Validação que a convenio deve ter no máximo 6 digitos
					versao_aplicativo:     '0',
				})
			end

			def codigo_banco
				'104'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'0'
			end

			def nome_banco
				@nome_banco ||= 'CAIXA ECONOMICA FEDERAL'
			end

			def versao_layout_arquivo_cnab_240
				'050'
			end

			def versao_layout_lote_cnab_240
				'030'
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

			def versao_aplicativo
				"#{@versao_aplicativo}".rjust(4, '0') if @versao_aplicativo.present?
			end
		end
	end
end
