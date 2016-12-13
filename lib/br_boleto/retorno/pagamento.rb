# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		class Pagamento < BrBoleto::ActiveModelBase
			include BrBoleto::HaveConta
			
			#############################################################################################
			############################# VALORES ENCONTRADOS NO SEGMENTO T #############################
			#############################################################################################
			# AGÊNCIA
			attr_accessor :agencia_com_dv # tamanho = 6
			attr_accessor :agencia_sem_dv # tamanho = 5
			
			# NÚMERO DA CONTA CORRENTE/CEDENTE
			attr_accessor :numero_conta_sem_dv     # tamanho = 12
			attr_accessor :numero_conta_dv         # tamanho = 1
			alias_attribute :codigo_cedente, :numero_conta
			def numero_conta
				"#{numero_conta_sem_dv}#{numero_conta_dv}" # tamanho = 13
			end
			
			# CÓDIGO DE MOVIMENTO RETORNO
			# Tamanho    Posição
			#   2         16-17
			attr_accessor :codigo_movimento_retorno
			def codigo_movimento_retorno
				conta.get_codigo_movimento_retorno(@codigo_movimento_retorno)
			end

			# IDENTIFICAÇÃO DO TÍTULO
			# Tamanho    Posição
			#   1         37-37
			attr_accessor :dv_conta_e_agencia

			# IDENTIFICAÇÃO DO TÍTULO
			# Tamanho    Posição
			#   20        38-57
			attr_accessor :nosso_numero_sem_dv

			# DÍGITO VERIFICADOR NOSSO NÚMERO
			attr_accessor :nosso_numero_dv

			# IDENTIFICAÇÃO DO TÍTULO (NOSSO NÚMERO)
			def nosso_numero
				"#{nosso_numero_sem_dv}#{nosso_numero_dv}"
			end
			
			# CARTEIRA DE COBRANÇA
			attr_accessor :carteira

			# CÓDIGO DA CARTEIRA (TIPO DE COBRANÇA)
			attr_accessor :cod_carteira
			alias_attribute :tipo_cobranca, :cod_carteira

			# VARIAÇÃO DA CARTEIRA 
			attr_accessor :variacao_carteira


			# NÚMERO DO DOCUMENTO
			# Tamanho    Posição
			#   15        59-73
			attr_accessor :numero_documento

			# DATA DE VENCIMENTO
			# Tamanho    Posição
			#   8        74-81
			attr_accessor :data_vencimento
			
			# VALRO DO TÍTULO
			# Tamanho    Posição
			#   15        82-96
			attr_accessor :valor_titulo
			
			# CÓDIGO DO BANCO RECEBEDOR DO TÚTULO
			# Tamanho    Posição
			#   3        97-99
			attr_accessor :banco_recebedor

			# AGÊNCIA(com dv) DO BANCO RECEBEDOR DO TÚTULO
			# Tamanho    Posição
			#   6        100-105
			attr_accessor :agencia_recebedora_com_dv

			# IDENTIFICAÇÃO/DESCRIÇÃO DO TÍTULO DA EMPRESA
			# Tamanho    Posição
			#   25        106-130
			attr_accessor :identificacao_titulo_empresa

			# CÓDIGO DA MOEDA
			# Tamanho    Posição
			#   2        131-132
			attr_accessor :codigo_moeda

			# SACADO TIPO DE INSCRIÇÃO
			# '0' = Isento / Não Informado
			# '1' = CPF
			# '2' = CGC / CNPJ
			# '3' = PIS / PASEP
			# '9' = Outros 
			# Tamanho    Posição
			#   1        133-133
			attr_accessor :sacado_tipo_documento

			# NÚMEDO DO DOCUMENTO DO SACADO (CPF/CNPJ)
			# Tamanho    Posição
			#   15       134-148
			attr_accessor :sacado_documento

			# NOME DO SACADO
			# Tamanho    Posição
			#   40       149-188
			attr_accessor :sacado_nome

			# NÚMERO DO CONTRATO DA OPERAÇÃO DE CRÉDITO
			# Tamanho    Posição
			#   10       189-198
			attr_accessor :numero_contrato

			# VALOR DA TARIFA
			# Tamanho    Posição
			#   15       199-213
			attr_accessor :valor_tarifa

			# IDENTIFICAÇÃO PARA REJEIÇÕES, TARIFAS, CUSTOS, LIQUIDAÇÃO E BAIXAS
			# Tamanho    Posição
			#   10       214-223

			attr_accessor :motivo_ocorrencia_original_1
			def motivo_ocorrencia_1
				conta.get_motivo_ocorrencia motivo_ocorrencia_original_1, codigo_movimento_retorno
			end

			attr_accessor :motivo_ocorrencia_original_2
			def motivo_ocorrencia_2
				conta.get_motivo_ocorrencia motivo_ocorrencia_original_2, codigo_movimento_retorno
			end

			attr_accessor :motivo_ocorrencia_original_3
			def motivo_ocorrencia_3
				conta.get_motivo_ocorrencia motivo_ocorrencia_original_3, codigo_movimento_retorno
			end

			attr_accessor :motivo_ocorrencia_original_4
			def motivo_ocorrencia_4
				conta.get_motivo_ocorrencia motivo_ocorrencia_original_4, codigo_movimento_retorno
			end

			attr_accessor :motivo_ocorrencia_original_5
			def motivo_ocorrencia_5
				conta.get_motivo_ocorrencia motivo_ocorrencia_original_5, codigo_movimento_retorno
			end

			def motivo_ocorrencia
				"#{motivo_ocorrencia_1}#{motivo_ocorrencia_2}#{motivo_ocorrencia_3}#{motivo_ocorrencia_4}#{motivo_ocorrencia_5}"	
			end


			# BANCO SICREDI (PAG. 44)
				#  Código do pagador na cooperativa do beneficiário
				#  Tamanho    Posição
				#    05       015-019
				attr_accessor :codigo_pagador_cooperativa

				#  Código do pagador junto ao associado
				#  Tamanho    Posição
				#    05       020-024
				attr_accessor :codigo_pagador_associado

			#############################################################################################
			############################# VALORES ENCONTRADOS NO SEGMENTO U #############################
			#############################################################################################
			# ACRÉSCIMOS COM JUROS E MULTAS
			# Tamanho    Posição
			#   15        18-32
			attr_accessor :valor_juros_multa

			# VALOR DO DESCONTO
			# Tamanho    Posição
			#   15        33-47
			attr_accessor :valor_desconto

			# VALOR DO ABATIMENTO CONCEDIDO/CENCELADO
			# Tamanho    Posição
			#   15        48-62
			attr_accessor :valor_abatimento

			# VALOR DO IOF
			# Tamanho    Posição
			#   15        63-77
			attr_accessor :valor_iof

			# VALOR PAGO PELO SACADO
			# Tamanho    Posição
			#   15        78-92
			attr_accessor :valor_pago

			# VALOR LIQUIDO
			# Tamanho    Posição
			#   15        93-107
			attr_accessor :valor_liquido

			# VALRO COM outras DESPESAS
			# Tamanho    Posição
			#   15        108-122
			attr_accessor :valor_outras_despesas

			# VALRO COM outros CRÉDITOS
			# Tamanho    Posição
			#   15        123-137
			attr_accessor :valor_outros_creditos

			# DATA OCORRÊNCIA
			# Tamanho    Posição
			#   8        138-145
			attr_accessor :data_ocorrencia

			# DATA DA EFETIVAÇÃO DO CRÉDITO
			# Tamanho    Posição
			#   8        146-153
			attr_accessor :data_credito

			# CÓDIGO DA OCORRÊNCIA DO SACADO
			# Tamanho    Posição
			#   4        154-157
			attr_accessor :codigo_ocorrencia_sacado

			# DATA DA OCORRÊNCIA DO SACADO
			# Tamanho    Posição
			#   8        158-165
			attr_accessor :data_ocorrencia_sacado

			# VALOR DA OCORRÊNCIA DO SACADO
			# Tamanho    Posição
			#   15        166-180
			attr_accessor :valor_ocorrencia_sacado

			# COMPLEMENTO DA OCORRÊNCIA DO SACADO
			# Tamanho    Posição
			#   30        181-210
			attr_accessor :complemento_ocorrencia_sacado

			# CÓDIGO DA OCORRÊNCIA DO BANCO CORRESPONDETNTE
			# Tamanho    Posição
			#   3        211-213
			attr_accessor :codigo_ocorrencia_banco_correspondente

			# CÓDIGO DA OCORRÊNCIA DO BANCO CORRESPONDETNTE
			# Tamanho    Posição
			#   3        211-213
			attr_accessor :nosso_numero_banco_correspondente

			# MODALIDADE 
			# O Padrão da FEBRABAN não prevê este valor, porém na maioria dos bancos
			# este valor está incluso junto com a posição do nosso_numero
			# É implementado apenas para os bancos que não conseguem seguir um padrão estabelecido
			attr_accessor :modalidade


			attr_accessor :parcela

			# Prefixo do Título: Informa Espécie do Título
			attr_accessor :especie_titulo
			
			def initialize(attributes = {})
				define_formatted_methods!
				super
			end

			def self.formatted_values
				{
					data_vencimento:         {type: :date},
					data_ocorrencia:         {type: :date},
					data_credito:            {type: :date},
					data_ocorrencia_sacado:  {type: :date},
					valor_titulo:            {type: :float},
					valor_tarifa:            {type: :float},
					valor_juros_multa:       {type: :float},
					valor_desconto:          {type: :float},
					valor_abatimento:        {type: :float},
					valor_iof:               {type: :float},
					valor_pago:              {type: :float},
					valor_liquido:           {type: :float},
					valor_outras_despesas:  {type: :float},
					valor_outros_creditos:  {type: :float},
					valor_ocorrencia_sacado: {type: :float},
				}
			end

			def define_formatted_methods!
				self.class.formatted_values.each do |attr_name, options|
					case options[:type]
					when :date
						define_date_attribute(attr_name)
					when :float
						define_float_attribute(attr_name)
					end						
				end
			end

			def define_float_attribute(attr_name)
				define_singleton_method "#{attr_name}=" do |value|
					self.instance_variable_set("@#{attr_name}", BrBoleto::Helper::FormatValue.string_to_float(value) )
				end
			end

			def define_date_attribute(attr_name)
				define_singleton_method "#{attr_name}=" do |value|
					self.instance_variable_set("@#{attr_name}", BrBoleto::Helper::FormatValue.string_to_date(value) )
				end
			end

			def conta_class= value
				@conta_class = value
			end
			def conta_class
				@conta_class
			end


		end	
	end
end