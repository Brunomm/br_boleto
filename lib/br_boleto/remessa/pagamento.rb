# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		class Pagamento < BrBoleto::ActiveModelBase
			
			# conté o metodo 'pagador'
			# CNAB: 240 e 400
			include BrBoleto::HavePagador

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
			attr_accessor :percentual_multa # Valor % Ex: 2.5% = 2.5

			# <b>OPCIONAL</b>: Informações para Juros
			#  Código do juros pode ser:
			#      - '1' Valor por Dia
			#      - '2' Taxa Mensal
			#      - '3' Isento
			#      - E Ainda alguns bancos como o SICOOB não conseguem seguir o padrão e usam o cód '0' para Isento
			attr_accessor :codigo_juros, :data_juros
			attr_accessor :valor_juros      # Valor R$
			attr_accessor :percentual_juros # Valor % Ex: 2.5% = 2.5
			
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
			# 01 - Registro de títulos
			# 02 - Solicitação de baixa
			# 03 - Pedido de débito em conta
			# 04 - Concessão de abatimento
			# 05 - Cancelamento de abatimento
			# 06 - Alteração de vencimento de título
			# 07 - Alteração do número de controle do participante
			# 08 - Alteração do número do titulo dado pelo cedente
			# 09 - Instrução para protestar (Nota 09)
			# 10 - Instrução para sustar protesto
			# 11 - Instrução para dispensar juros
			# 12 - Alteração de nome e endereço do Sacado
			# 16 – Alterar Juros de Mora (Vide Observações)
			# 31 - Conceder desconto
			# 32 - Não conceder desconto
			# 33 - Retificar dados da concessão de desconto
			# 34 - Alterar data para concessão de desconto
			# 35 - Cobrar multa (Nota 11)
			# 36 - Dispensar multa (Nota 11)
			# 37 - Dispensar indexador
			# 38 - Dispensar prazo limite de recebimento (Nota 11)
			# 39 - Alterar prazo limite de recebimento (Nota 11)
			# 40 – Alterar modalidade (Vide Observações) 
			# CNAB: 400
			attr_accessor :identificacao_ocorrencia


			# Espécie do Título:
			# Default: 01
			#  01 = Duplicata Mercantil
			#  02 = Nota Promissória
			#  03 = Nota de Seguro
			#  05 = Recibo
			#  06 = Duplicata Rural
			#  08 = Letra de Câmbio
			#  09 = Warrant
			#  10 = Cheque
			#  12 = Duplicata de Serviço
			#  13 = Nota de Débito
			#  14 = Triplicata Mercantil
			#  15 = Triplicata de Serviço
			#  18 = Fatura
			#  20 = Apólice de Seguro
			#  21 = Mensalidade Escolar
			#  22 = Parcela de Consórcio
			#  99 = Outros
			#  CNAB: 240 e 400
			attr_accessor :especie_titulo

			# Aceite título
			# "0" = Sem aceite / "1" = Com aceite" / Depende de
			# "N" = Sem aceite / "S" = Com aceite" \ cada banco
			# "N" = Sem aceite / "A" = Com aceite" \ 
			#  CNAB: 240 e 400
			# Setar true para Aceite e false para Não aceite
			attr_accessor :aceite

			# Aceite título
			# '9' = Real
			#  CNAB: 400
			attr_accessor :codigo_moeda

			# forma de cadastramento dos titulos (campo nao tratado pelo Banco do Brasil)
			#   opcoes:
			#     1 - com cadastramento (cobrança registrada)
			#     2 - sem cadastramento (cobrança sem registro)
			attr_accessor :forma_cadastramento

			def moeda_real?
				codigo_moeda == '9'
			end
			def codigo_moeda
				@codigo_moeda = '9' if @codigo_moeda.blank?
				@codigo_moeda
			end

			def parcela
				@parcela = '1' if @parcela.blank?
			end

			def nosso_numero
				"#{@nosso_numero}".gsub(/[^0-9]/, "")
			end

			validates :nosso_numero, :data_vencimento, :valor_documento, :tipo_impressao, presence: true
			validates :cod_desconto, length: {is: 1, message: 'deve ter 1 dígito.'}

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
					percentual_multa:  0.0,
					percentual_juros:  0.0,
					parcela:           '1',
					tipo_impressao:    '1',
					tipo_emissao:      '2',
					identificacao_ocorrencia: '01',
					especie_titulo: '01',
					codigo_moeda: '9',
					forma_cadastramento: '0',
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