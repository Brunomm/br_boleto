# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		class Pagamento
			# Seguindo a interface do Active Model para:
			# * Validações;
			# * Internacionalização;
			# * Nomes das classes para serem manipuladas;
			#
			include ActiveModel::Model

			# <b>REQUERIDO</b>: nosso numero
			attr_accessor :nosso_numero

			# <b>REQUERIDO</b>: data do vencimento do boleto
			attr_accessor :data_vencimento

			# <b>REQUERIDO</b>: data de emissao do boleto
			attr_accessor :data_emissao

			# <b>REQUERIDO</b>: valor_documento do boleto
			attr_accessor :valor_documento

			# <b>REQUERIDO</b>: documento do sacado (cliente)
			attr_accessor :documento_sacado

			# <b>REQUERIDO</b>: nome do sacado (cliente)
			attr_accessor :nome_sacado

			# <b>REQUERIDO</b>: endereco do sacado (cliente)
			attr_accessor :endereco_sacado

			# <b>REQUERIDO</b>: bairro do sacado (cliente)
			attr_accessor :bairro_sacado

			# <b>REQUERIDO</b>: CEP do sacado (cliente)
			attr_accessor :cep_sacado

			# <b>REQUERIDO</b>: cidade do sacado (cliente)
			attr_accessor :cidade_sacado

			# <b>REQUERIDO</b>: UF do sacado (cliente)
			attr_accessor :uf_sacado

			# <b>OPCIONAL</b>: nome do avalista
			attr_accessor :nome_avalista

			# <b>OPCIONAL</b>: documento do avalista
			attr_accessor :documento_avalista

			# <b>OPCIONAL</b>: codigo da 1a instrucao
			attr_accessor :cod_primeira_instrucao

			# <b>OPCIONAL</b>: codigo da 2a instrucao
			attr_accessor :cod_segunda_instrucao

			# <b>OPCIONAL</b>: valor da mora ao dia
			attr_accessor :valor_mora

			# <b>OPCIONAL</b>: data limite para o desconto
			attr_accessor :data_desconto

			# <b>OPCIONAL</b>: valor a ser concedido de desconto
			attr_accessor :valor_desconto

			# <b>OPCIONAL</b>: codigo do desconto (para CNAB240)
			attr_accessor :cod_desconto

			# <b>OPCIONAL</b>: valor do IOF
			attr_accessor :valor_iof
			
			# <b>OPCIONAL</b>: valor do abatimento
			attr_accessor :valor_abatimento

			validates :nosso_numero, :data_vencimento, :valor_documento, :documento_sacado, :nome_sacado, 
			          :endereco_sacado, :cep_sacado, :cidade_sacado, :uf_sacado, :bairro_sacado, presence: true

			validates :cep_sacado,   length: {is: 8, message: 'deve ter 8 dígitos.'}
			validates :cod_desconto, length: {is: 1, message: 'deve ter 1 dígito.'}

			# Nova instancia da classe Pagamento
			#
			# @param campos [Hash]
			#
			def initialize(attributes = {})
				attributes = default_values.merge!(attributes)
				assign_attributes(attributes)
				yield self if block_given?
			end

			def assign_attributes(attributes={})
				attributes ||= {}
				attributes.each do |name, value|
					send("#{name}=", value)
				end
			end

			def default_values
				{
					data_emissao:     Date.today,
					valor_mora:       0.0,
					valor_desconto:   0.0,
					valor_iof:        0.0,
					valor_abatimento: 0.0,
					nome_avalista:    '',
					cod_desconto:     '0'
				}
			end

			# Formata a data de desconto de acordo com o formato passado
			#
			# @return [String]
			#
			def data_desconto_formatado(formato = '%d%m%y')
				data_desconto.strftime(formato)
			rescue
				return (formato == '%d%m%y' ?  '000000' : '00000000')
			end

			# Formata o campo valor
			# referentes as casas decimais
			# exe. R$199,90 => 0000000019990
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			#
			def valor_documento_formatado(tamanho = 13)
				formata_valor_monetario(valor_documento, tamanho)
			end

			# Formata o campo valor da mora
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			#
			def valor_mora_formatado(tamanho = 13)
				formata_valor_monetario(valor_mora, tamanho)
			end

			# Formata o campo valor do desconto
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			#
			def valor_desconto_formatado(tamanho = 13)
				formata_valor_monetario(valor_desconto, tamanho)
			end

			# Formata o campo valor do IOF
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			#
			def valor_iof_formatado(tamanho = 13)
				formata_valor_monetario(valor_iof, tamanho)
			end

			# Formata o campo valor do IOF
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			#
			def valor_abatimento_formatado(tamanho = 13)
				formata_valor_monetario(valor_abatimento, tamanho)
			end

			# Retorna a identificacao do pagador
			# Se for pessoa fisica (CPF com 11 digitos) é 1
			# Se for juridica (CNPJ com 14 digitos) é 2
			#
			def tipo_documento_sacado(tamanho = 2)
				BrBoleto::Helper::CpfCnpj.new(documento_sacado).tipo_documento(tamanho)
			end

			# Retorna a identificacao do avalista
			# Se for pessoa fisica (CPF com 11 digitos) é 1
			# Se for juridica (CNPJ com 14 digitos) é 2
			#
			def tipo_documento_avalista(tamanho = 2)
				BrBoleto::Helper::CpfCnpj.new(documento_avalista).tipo_documento(tamanho)
			end
		private

			def formata_valor_monetario(value, size=13)
				return ''.rjust(size, '0') if value.blank?
				sprintf('%.2f', value).delete('.').rjust(size, '0')
			end
		end
	end
end