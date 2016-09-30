# encoding: utf-8
module BrBoleto
	module Conta
		class Caixa < BrBoleto::Conta::Base
			
			# MODALIDADE CARTEIRA
			#  Opcoes:
			#    14: Cobrança Simples com registro
			#    24: Cobrança Simples sem registro
			#
			#  Carteira/Modalidade:
			#    1/4 = Registrada   / Emissão do boleto(4-Beneficiário) 
			#    2/4 = Sem Registro / Emissão do boleto(4-Beneficiário) 

			# versão do aplicativo da caixa
			attr_accessor :versao_aplicativo

			###############################  VALIDAÇÕES DINÂMICAS ###############################
				# Versão do aplicativo
				attr_accessor :valid_versao_aplicativo_required
			#####################################################################################

			validates :versao_aplicativo, custom_length: { maximum: 4 }
			validates :versao_aplicativo, presence: true, if: :valid_versao_aplicativo_required

			def default_values
				super.merge({
					carteira:                 '14',         # Com registro
					valid_carteira_required:  true,         # <- Validação dinâmica que a carteira é obrigatória
					valid_carteira_length:    2,            # <- Validação dinâmica que a carteira deve ter 2 digitos
					valid_carteira_inclusion: %w[14 24],    # <- Validação dinâmica de valores aceitos para a modalidade
					valid_convenio_required:  true,         # <- Validação que a convenio deve ter obrigatório
					valid_convenio_maximum:   6,            # <- Validação que a convenio deve ter no máximo 6 digitos
					versao_aplicativo:        '0',
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
				@conta_corrente_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(conta_corrente).to_s
			end

			def convenio_dv
				@convenio_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(convenio).to_s
			end

			def versao_aplicativo
				"#{@versao_aplicativo}".rjust(4, '0') if @versao_aplicativo.present?
			end

			# Formata a carteira da carteira dependendo se ela é registrada ou não.
			#
			# Para cobrança COM registro usar: <b>RG</b>
			# Para Cobrança SEM registro usar: <b>SR</b>
			#
			# @return [String]
			#
			def carteira_formatada
				if carteira.in?(carteiras_com_registro)
					'RG'
				else
					'SR'
				end
			end

			# Retorna as carteiras com registro da Caixa Econômica Federal.
			# <b>Você pode sobrescrever esse método na subclasse caso exista mais
			# carteiras com registro na Caixa Econômica Federal.</b>
			#
			# @return [Array]
			#
			def carteiras_com_registro
				%w(14)
			end

			# Campo Agência / Código do Cedente
			#
			# @return [String]
			#
			def agencia_codigo_cedente
				"#{agencia} / #{codigo_cedente}-#{codigo_cedente_dv}"
			end

		end
	end
end
