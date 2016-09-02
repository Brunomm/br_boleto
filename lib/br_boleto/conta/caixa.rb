# encoding: utf-8
module BrBoleto
	module Conta
		class Caixa < BrBoleto::Conta::Base
			
			# MODALIDADE
			#   opcoes:
			#     11: título Registrado emissão CAIXA
			#     14: título Registrado emissão Cedente
			#     21: título Sem Registro emissão CAIXA

			# versão do aplicativo da caixa
			attr_accessor :versao_aplicativo

			validates :agencia_dv, :modalidade, :conta_corrente, presence: true
			validates :agencia,    length: {maximum: 5, message: 'deve ter no máximo 5 dígitos.'}
			validates :modalidade, length: {is: 2, message: 'deve ter 2 dígitos.'}, allow_blank: true
			validates :agencia_dv, length: {is: 1, message: 'deve ter 1 dígito.'},  allow_blank: true
			validates :versao_aplicativo,   length: {maximum: 4, message: 'deve ter no máximo 4 dígitos.'}
			validates :convenio,            length: {maximum: 6, message: 'deve ter no máximo 6 dígitos.'}
			
			def default_values
				super.merge({
					modalidade: '14', # Com registro
					versao_aplicativo: '0',
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
