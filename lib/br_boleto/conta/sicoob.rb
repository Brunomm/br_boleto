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

			validates :agencia_dv, :modalidade, :carteira, :conta_corrente, presence: true
			validates :agencia,    length: {is: 4, message: 'deve ter 4 dígitos.'}
			validates :modalidade, length: {is: 2, message: 'deve ter 2 dígitos.'}, allow_blank: true
			validates :carteira,   length: {is: 1, message: 'deve ter 1 dígito.'},  allow_blank: true
			validates :agencia_dv, length: {is: 1, message: 'deve ter 1 dígito.'},  allow_blank: true
			validates :conta_corrente, length: {maximum: 8, message: 'deve ter no máximo 8 dígitos.'}

			def default_values
				super.merge({
					carteira:   '1', # Simples
					modalidade: '01' # Com registro
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
				@nome_banco ||= 'BANCOOBCED'
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
