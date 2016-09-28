# encoding: utf-8
module BrBoleto
	module Conta
		class Bradesco < BrBoleto::Conta::Base

			# codigo da empresa (informado pelo Bradesco no cadastramento)
			attr_accessor :codigo_empresa


			# MODALIDADE CARTEIRA:
			#      _______________________________________________
			#     | Carteira | Descrição                         |
			#     |   06     | Sem registro                      |
			#     |   09     | Com registro                      |
			#     |   19     | Com registro                      |
			#     |   21     | Cobrança Interna Com Registro     |
			#     |   22     | Cobrança Interna Sem Registro     |
			#     ------------------------------------------------


			def default_values
				super.merge({
					carteira:                 '06', 			 
					valid_carteira_required:  true,               # <- Validação dinâmica que a modalidade é obrigatória
					valid_carteira_length:    2,                  # <- Validação dinâmica que a modalidade deve ter 2 digitos
					valid_carteira_inclusion: %w[06 09 19 21 22], # <- Validação dinâmica de valores aceitos para a modalidade
					valid_conta_corrente_required: true,          # <- Validação dinâmica que a conta_corrente é obrigatória
					valid_conta_corrente_maximum:  7,             # <- Validação que a conta_corrente deve ter no máximo 7 digitos
					valid_convenio_required:  true,               # <- Validação que a convenio deve ter obrigatório
					valid_convenio_maximum:   7,                  # <- Validação que a convenio deve ter no máximo 7 digitos
				})
			end

			def codigo_banco
				'237'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'2'
			end

			def nome_banco
				@nome_banco ||= 'BRADESCO'
			end

			def versao_layout_arquivo_cnab_240
				'084'
			end

			def versao_layout_lote_cnab_240
				'042'
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

			# Número da Carteira de Cobrança, que a empresa opera no Banco.
			# 21 – Cobrança Interna Com Registro
			# 22 – Cobrança Interna sem registro
			# Para as demais carteiras, retornar o número da carteira.
			def carteira_formatada
				if cobranca_interna_formatada.present?
					cobranca_interna_formatada
				else
					carteira
				end
			end

			# Retorna a mensagem que devera aparecer no campo carteira para cobranca interna.
			# @return [String]
			def cobranca_interna_formatada
				cobranca_interna = { '21' => '21 – Cobrança Interna Com Registro', '22' => '22 – Cobrança Interna sem registro' }
				cobranca_interna[carteira.to_s]
			end

		end
	end
end
