# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		class Pagamento < BrBoleto::ActiveModelBase
			
			# conté o metodo 'pagador'
			# CNAB: 240 e 400
			include BrBoleto::HavePagador

			include BrBoleto::Helper::DefaultCodes
			
			# <b>REQUERIDO</b>: nosso numero
			# CNAB: 240 e 400
			attr_accessor :nosso_numero

			# <b>OPCIONAL</b>: Número do Documento de Cobrança - Número adotado e controlado pelo Cliente,
			# para identificar o título de cobrança.
			# Informação utilizada para referenciar a identificação do documento objeto de cobrança.
			# Poderá conter número de duplicata, no caso de cobrança de duplicatas; número da apólice,
			# no caso de cobrança de seguros, etc
			# CNAB: 240 e 400
			attr_accessor :numero_documento

			# <b>REQUERIDO</b>: data do vencimento do boleto
			# CNAB: 240 e 400
			attr_accessor :data_vencimento

			# <b>REQUERIDO</b>: data de emissao do boleto
			# CNAB: 240 e 400
			attr_accessor :data_emissao

			# <b>REQUERIDO</b>: valor_documento do boleto
			# CNAB: 240 e 400
			attr_accessor :valor_documento

			# <b>REQUERIDO</b>: Tipor de impressão
			#                   1 - Frente do Bloqueto
			#                   2 - Verso do Bloauqto
			#                   3 - Corpo de instruções da Ficha de Complansação
			# 
			attr_accessor :tipo_impressao # Default '1'

			# <b>OPCIONAL</b>: codigo da 1a instrucao
			attr_accessor :cod_primeira_instrucao

			# <b>OPCIONAL</b>: codigo da 2a instrucao
			attr_accessor :cod_segunda_instrucao

			# <b>OPCIONAL</b>: valor da mora ao dia
			# Dependendo do banco será o valor percentual ou valor em reais
			# CNAB: 240 e 400
			attr_accessor :valor_mora

			# <b>OPCIONAL</b>: data limite para o desconto
			# CNAB: 240 e 400
			attr_accessor :data_desconto

			# <b>OPCIONAL</b>: valor a ser concedido de desconto
			# CNAB: 240 e 400
			attr_accessor :valor_desconto

			# <b>OPCIONAL</b>: codigo do desconto (para CNAB240)
			attr_accessor :cod_desconto

			# <b>OPCIONAL</b>: valor do IOF
			attr_accessor :valor_iof
			
			# <b>OPCIONAL</b>: valor do abatimento
			attr_accessor :valor_abatimento

			# <b>OPCIONAL</b>: Informações para o desconto 2
			attr_accessor :desconto_2_codigo, :desconto_2_data, :desconto_2_valor

			# <b>OPCIONAL</b>: Informações para o desconto 3
			attr_accessor :desconto_3_codigo, :desconto_3_data, :desconto_3_valor

			# <b>OPCIONAL</b>: Informações para multa
			#  Código da multa pode ser:
			#      - '1' Valor por Dia
			#      - '2' Taxa Mensal
			#      - '3' Isento
			#      - E Ainda alguns bancos como o SICOOB não conseguem seguir o padrão e usam o cód '0' para Isento
			attr_accessor :codigo_multa, :data_multa
			#CNAB 240 e 400
			attr_accessor :valor_multa      # Valor R$
			def percentual_multa # Valor % Ex: 2.5% = 2.5
				BrBoleto::Helper::Number.new(valor_multa).get_percent_by_total(valor_documento)
			end

			# <b>OPCIONAL</b>: Informações para Juros
			#  Código do juros pode ser:
			#      - '1' Valor por Dia
			#      - '2' Taxa Mensal
			#      - '3' Isento
			#      - E Ainda alguns bancos como o SICOOB não conseguem seguir o padrão e usam o cód '0' para Isento
			attr_accessor :codigo_juros, :data_juros
			attr_accessor :valor_juros      # Valor R$			
			# É calculado em base no valor do juros 
			def percentual_juros # Valor % Ex: 2.5% = 2.5
				BrBoleto::Helper::Number.new(valor_juros).get_percent_by_total(valor_documento)
			end
			
			# <b>OPCIONAL</b>: Número da parquela que o pagamento representa
			# Padrão: 1
			# CNAB: 240 e 400
			attr_accessor :parcela
			
			# Tipo de Emissão: 1-Banco/Cooperativa 2-Cliente
			# Banco Sicoob utiliza
			# CNAB: 240 e 400
			attr_accessor :tipo_emissao

			# Comando/Identificação da cobrança/Movimento
			# Default: '01'
			# Exemplos de valores
			#  01 = Entrada de Títulos
			#  02 = Pedido de Baixa
			#  03 = Protesto para Fins Falimentares
			#  04 = Concessão de Abatimento
			#  05 = Cancelamento de Abatimento
			#  06 = Alteração de Vencimento
			#  07 = Concessão de Desconto
			#  08 = Cancelamento de Desconto
			#  09 = Pedido de protesto (Protestar)
			#  10 = Sustar Protesto e Baixar Título
			#  11 = Sustar Protesto e Manter em Carteira
			#  12 = Alteração de Juros de Mora
			#  13 = Dispensar Cobrança de Juros de Mora
			#  14 = Alteração de Valor/Percentual de Multa
			#  15 = Dispensar Cobrança de Multa
			#  16 = Alteração do Valor de Desconto
			#  17 = Não conceder Desconto
			#  18 = Alteração do Valor de Abatimento
			#  19 = Prazo Limite de Recebimento – Alterar
			#  20 = Prazo Limite de Recebimento – Dispensar
			#  21 = Alterar número do título dado pelo beneficiario (nosso número)
			#  22 = Alterar número controle do Participante (seu número / número documento)
			#  23 = Alterar dados do Pagador
			#  24 = Alterar dados do Sacador/Avalista
			#  30 = Recusa da Alegação do Pagador
			#  31 = Alteração de Outros Dados
			#  33 = Alteração dos Dados do Rateio de Crédito
			#  34 = Pedido de Cancelamento dos Dados do Rateio de Crédito
			#  35 = Pedido de Desagendamento do Débito Automático
			#  40 = Alteração de Carteira
			#  41 = Cancelar protesto
			#  42 = Alteração de Espécie de Título
			#  43 = Transferência de carteira/modalidade de cobrança
			#  44 = Alteração de contrato de cobrança
			#  45 = Negativação Sem Protesto
			#  46 = Solicitação de Baixa de Título Negativado Sem Protesto
			#  47 = Alteração do Valor Nominal do Título
			#  48 = Alteração do Valor Mínimo/ Percentual
			#  49 = Alteração do Valor Máximo/Percentua
			#  CNAB: 240 e 400
			attr_accessor :identificacao_ocorrencia

			# Espécie do Título:
			# Default: 01
				# 01 =  Cheque
				# 02 =  Duplicata Mercantil
				# 03 =  Duplicata Mercantil p/ Indicação
				# 04 =  Duplicata de Serviço
				# 05 =  Duplicata de Serviço p/ Indicação
				# 06 =  Duplicata Rural
				# 07 =  Letra de Câmbio
				# 08 =  Nota de Crédito Comercial
				# 09 =  Nota de Crédito a Exportação
				# 10 =  Nota de Crédito Industrial
				# 11 =  Nota de Crédito Rural
				# 12 =  Nota Promissória
				# 13 =  Nota Promissória Rural
				# 14 =  Triplicata Mercantil
				# 15 =  Triplicata de Serviço
				# 16 =  Nota de Seguro
				# 17 =  Recibo
				# 18 =  Fatura
				# 19 =  Nota de Débito
				# 20 =  Apólice de Seguro
				# 21 =  Mensalidade Escolar
				# 22 =  Parcela de Consórcio
				# 23 =  Nota Fiscal
				# 24 =  Documento de Dívida
				# 25 =  Cédula de Produto Rural
				# 26 =  Warrant 
				# 27 =  Dívida Ativa de Estado
				# 28 =  Dívida Ativa de Município
				# 29 =  Dívida Ativa da União
				# 30 =  Encargos condominiais
				# 31 =  Cartão de Crédito
				# 32 =  Boleto de Proposta
				# 99 =  Outros
			#  CNAB: 240 e 400
			attr_accessor :especie_titulo

			# Aceite título
			# "0" = Sem aceite / "1" = Com aceite" / Depende de
			# "N" = Sem aceite / "S" = Com aceite" \ cada banco
			# "N" = Sem aceite / "A" = Com aceite" \ 
			#  CNAB: 240 e 400
			# Setar true para Aceite e false para Não aceite
			attr_accessor :aceite

			# Moeda
			# '9' = Real
			#  CNAB: 400
			attr_accessor :codigo_moeda

			# forma de cadastramento dos titulos (campo nao tratado pelo Banco do Brasil)
			#   opcoes:
			#     1 - com cadastramento (cobrança registrada)
			#     2 - sem cadastramento (cobrança sem registro)
			attr_accessor :forma_cadastramento

			# Identificação da Emissão do Boleto de Pagamento
			# Código adotado pela FEBRABAN para identificar o responsável e a forma de emissão do
			# Boleto de Pagamento.
			# Domínio:
			# '1' = Banco Emite
			# '2' = Cliente Emite
			# '3' = Banco Pré-emite e Cliente Complementa
			# '4' = Banco Reemite
			# '5' = Banco Não Reemite
			# '7' = Banco Emitente - Aberta
			# '8' = Banco Emitente - Auto-envelopável
			# Os códigos '4' e '5' só serão aceitos para código de movimento para remessa '31'
			attr_accessor :emissao_boleto

			# Identificação da Distribuição
			# Código adotado pela FEBRABAN para identificar o responsável pela distribuição do
			# Boleto de Pagamento.
			# Domínio:
			# '1' = Banco Distribui
			# '2' = Cliente Distribui
			# ‘3’ = Banco envia e-mail
			# ‘4’ = Banco envia SMS
			attr_accessor :distribuicao_boleto

			# Código para Protesto
			# Código adotado pela FEBRABAN para identificar o tipo de prazo a ser considerado para o protesto.
			# '1' =  Protestar Dias Corridos
			# '2' =  Protestar Dias Úteis
			# '3' =  Não Protestar
			# '4' = Protestar Fim Falimentar - Dias Úteis
			# '5' = Protestar Fim Falimentar - Dias Corridos
			# '8' = Negativação sem Protesto
			# '9' =  Cancelamento Protesto Automático (somente válido p/ Código Movimento Remessa = '31')
			attr_accessor :codigo_protesto

			########################  VALIDAÇÕES PERSONALIZADAS  ########################
				attr_accessor :valid_tipo_impressao_required
				validates :tipo_impressao, presence: true, if: :valid_tipo_impressao_required
				
				attr_accessor :valid_cod_desconto_length
				validates :cod_desconto, custom_length: {is: :valid_cod_desconto_length}, if: :valid_cod_desconto_length

				attr_accessor :valid_emissao_boleto_length
				validates :emissao_boleto, custom_length: {is: :valid_emissao_boleto_length}, if: :valid_emissao_boleto_length
				
				attr_accessor :valid_distribuicao_boleto_length
				validates :distribuicao_boleto, custom_length: {is: :valid_distribuicao_boleto_length}, if: :valid_distribuicao_boleto_length
			#############################################################################

			def moeda_real?
				"#{codigo_moeda}" == '9'
			end
			def codigo_moeda
				@codigo_moeda = '9' if @codigo_moeda.blank?
				@codigo_moeda
			end

			def parcela
				@parcela = '1' if @parcela.blank?
				@parcela
			end

			def nosso_numero
				"#{@nosso_numero}".gsub(/[^0-9]/, "")
			end

			validates :nosso_numero, :data_vencimento, :valor_documento, presence: true

			def default_values
				{
					data_emissao:      Date.today,
					valor_mora:        0.0,
					valor_desconto:    0.0,
					valor_iof:         0.0,
					valor_abatimento:  0.0,
					cod_desconto:      '0',
					desconto_2_codigo: '0',
					desconto_2_valor:  0.0,
					desconto_3_codigo: '0',
					desconto_3_valor:  0.0,
					codigo_multa:      '3', # Isento
					codigo_juros:      '3', # Isento
					valor_multa:       0.0,
					valor_juros:       0.0,
					parcela:           '1',
					tipo_impressao:    '1',
					tipo_emissao:      '2',
					identificacao_ocorrencia: '01',
					especie_titulo:           '01',
					codigo_moeda:             '9',
					forma_cadastramento:      '0',
					emissao_boleto:           '2', # Cliente Emite
					distribuicao_boleto:      '2', # Cliente Distribui
					codigo_protesto:          '3', # Não protestar
				}
			end

			def data_vencimento_formatado(formato='%d%m%Y')
				formata_data(data_vencimento, formato)
			end
			def data_emissao_formatado(formato='%d%m%Y')
				formata_data(data_emissao, formato)
			end

			# Formata a data de descontos de acordo com o formato passado
			#
			# @return [String]
			#
			def data_desconto_formatado(formato = '%d%m%Y')
				formata_data(data_desconto, formato)
			end
			def desconto_2_data_formatado(formato = '%d%m%Y')
				formata_data(desconto_2_data, formato)
			end
			def desconto_3_data_formatado(formato = '%d%m%Y')
				formata_data(desconto_3_data, formato)
			end

			# Formatação para campos da multa
			def data_multa_formatado(formato = '%d%m%Y')
				formata_data(data_multa, formato)
			end
			def valor_multa_formatado(tamanho=13)
				BrBoleto::Helper::Number.new(valor_multa).formata_valor_monetario(tamanho) 
			end

			# Formatação para campos da juros
			def data_juros_formatado(formato = '%d%m%Y')
				formata_data(data_juros, formato)
			end
			def valor_juros_formatado(tamanho=13)
				BrBoleto::Helper::Number.new(valor_juros).formata_valor_monetario(tamanho) 
			end

			# Formata o campo valor
			# referentes as casas decimais
			# exe. R$199,90 => 0000000019990
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			#
			def valor_documento_formatado(tamanho = 13)
				BrBoleto::Helper::Number.new(valor_documento).formata_valor_monetario(tamanho) 
			end

			# Formata o campo valor da mora
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			#
			def valor_mora_formatado(tamanho = 13)
				BrBoleto::Helper::Number.new(valor_mora).formata_valor_monetario(tamanho) 
			end

			# Formata o campo valor dos descontos
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			#
			def valor_desconto_formatado(tamanho = 13)
				BrBoleto::Helper::Number.new(valor_desconto).formata_valor_monetario(tamanho) 
			end
			def desconto_2_valor_formatado(tamanho = 13)
				BrBoleto::Helper::Number.new(desconto_2_valor).formata_valor_monetario(tamanho) 
			end
			def desconto_3_valor_formatado(tamanho = 13)
				BrBoleto::Helper::Number.new(desconto_3_valor).formata_valor_monetario(tamanho) 
			end

			# Formata o campo valor do IOF
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			#
			def valor_iof_formatado(tamanho = 13)
				BrBoleto::Helper::Number.new(valor_iof).formata_valor_monetario(tamanho) 
			end

			# Formata o campo valor do IOF
			#
			# @param tamanho [Integer]
			#   quantidade de caracteres a ser retornado
			# CNAB: 240 e 400
			def valor_abatimento_formatado(tamanho = 13)
				BrBoleto::Helper::Number.new(valor_abatimento).formata_valor_monetario(tamanho) 
			end

			# Formata o valor percentual da multa
			# Ex:
			#   2.5%    = 2.5  = 025000
			#   21.567% = 21.5 = 215670
			#
			def percentual_multa_formatado(tamanho = 6)
				BrBoleto::Helper::Number.new(percentual_multa).formata_valor_percentual(tamanho).adjust_size_to(tamanho, '0')
			end
			
			# Formata o valor percentual do juros
			# Ex:
			#   2.5%    = 2.5  = 025000
			#   21.567% = 21.5 = 215670
			#
			def percentual_juros_formatado(tamanho = 6)
				BrBoleto::Helper::Number.new(percentual_juros).formata_valor_percentual(tamanho).adjust_size_to(tamanho, '0')
			end

			
		private

			def formata_data(value, formato="%d%m%Y")
				value.strftime(formato)
			rescue
				return (formato == '%d%m%y' ?  '000000' : '00000000')
			end
		end
	end
end