# encoding: utf-8
module BrBoleto
	module Boleto
		# @abstract Métodos {  #nosso_numero, #codigo_de_barras_do_banco}
		# Métodos para serem escritos nas subclasses (exitem outros opcionais, conforme visto nessa documentação).
		#
		class Base < BrBoleto::ActiveModelBase
			include BrBoleto::Calculos
			include BrBoleto::HaveConta
			include BrBoleto::HavePagador

			# Data do vencimento do boleto. Campo auto explicativo.
			#
			# <b>Campo Obrigatório</b>
			#
			attr_accessor :data_vencimento

			# Número do documento que será mostrado no boleto.
			# Campo de resposabilidade do Cedente e cada banco possui um tamanho esperado.
			#
			attr_accessor :numero_documento
			def numero_documento
				if valid_numero_documento_maximum && @numero_documento.present?
					@numero_documento.to_s.rjust(valid_numero_documento_maximum, '0')
				else
					@numero_documento
				end
			end

			# Valor total do documento. Campo auto explicativo.
			#
			# <b>Campo Obrigatório</b>.
			#
			attr_accessor :valor_documento
			

			# Número da Conta corrente. Campo auto explicativo.
			#
			attr_accessor :conta_corrente

			# Código da moeda. Campo auto explicativo.
			# Padrão '9' (Real).
			#
			attr_accessor :codigo_moeda

			# Essencial para identificação da moeda em que a operação foi efetuada.
			#
			# Padrão 'R$' (Real).
			#
			attr_accessor :especie

			# Normalmente se vê neste campo a informação "DM" que quer dizer duplicata mercantil,
			# mas existem inúmeros tipos de espécie, <b>neste caso é aconselhável discutir com o banco
			# qual a espécie de documento será utilizada</b>, a identificação incorreta da espécie do documento
			# não vai impedir que o boleto seja pago e nem que o credito seja efetuado na conta do cliente,
			# mas <b>pode ocasionar na impossibilidade de se protestar o boleto caso venha a ser necessário.</b>
			#
			# Segue a sigla e descrição do campo especie do documento:
			#
			#     ---------------------------------
			#    | Sigla  | Descrição             |
			#    ----------------------------------
			#    |  NP    | Nota Promissória      |
			#    |  NS    | Nota de Seguro        |
			#    |  CS    | Cobrança Seriada      |
			#    |  REC   | Recibo                |
			#    |  LC    | Letras de Câmbio      |
			#    |  ND    | Notas de débito       |
			#    |  DS    | Duplicata de Serviços |
			#    |  DM    | Duplicata Mercantil   |
			#    ---------------------------------|
			#
			# Padrão 'DM' (Duplicata Mercantil)
			#
			attr_accessor :especie_documento

			# Data em que o documento foi gerado. Campo auto explicativo.
			#
			attr_accessor :data_documento

			# Descrição do local do pagamento.
			#
			attr_accessor :local_pagamento

			# Aceitar após o vencimento.
			# Nessa gem utilizamos o campo aceite como Boolean.
			# Obviamente, true para 'S' e false/nil para 'N'.
			#
			attr_accessor :aceite

			# Campos de instruções.
			# São permitidas até seis linhas de instruções a serem mostradas no boleto

			attr_accessor :instrucoes1,
			              :instrucoes2,
			              :instrucoes3,
			              :instrucoes4,
			              :instrucoes5,
			              :instrucoes6

			# Caminho do logo do banco.
			#
			attr_accessor :logo

			# Quantidade de parcelas que o boleto possui
			# Liberando a possibilidade de edição
			attr_accessor :parcelas
			def parcelas
				if @parcelas.present?
					@parcelas.to_s.rjust(3, '0')
				else
					'001'
				end
			end

			#################  VALIDAÇÕES DINÂMICAS  #################
				
				def valid_numero_documento_maximum;  6 end
				validates :numero_documento, custom_length: {maximum: :valid_numero_documento_maximum}, if: :valid_numero_documento_maximum

				# Tamanho maximo do valor do documento do boleto.
				# Acredito que não existirá valor de documento nesse valor,
				# <b>porém a biblioteca precisa manter a consistência</b>.
				#
				# No código de barras o valor do documento precisa
				# ter um tamanho de 8 caracteres para os reais (acrescentando zeros à esquerda),
				# e 2 caracteres nos centavos (acrescentando zeros à esquerda).
				#
				# @return [Float] 99999999.99
				#
				def valid_valor_documento_tamanho_maximo; 99999999.99 end
				validates :valor_documento, numericality: { less_than_or_equal_to: ->(obj) { obj.valid_valor_documento_tamanho_maximo } }, if: :valid_valor_documento_tamanho_maximo
			##########################################################
			validates :valor_documento, :numero_documento, :data_vencimento, presence: true
			validate  :data_vencimento_deve_ser_uma_data

			# Opções default.
			#
			# Caso queira sobrescrever as opções, você pode simplesmente instanciar o objeto passando a opção desejada:
			#
			#   class Bradesco < BrBoleto::Bradesco
			#   end
			#
			#   Bradesco.new do |bradesco|
			#     bradesco.codigo_moeda      = 'outro_codigo_da_moeda'
			#     bradesco.especie           = 'outra_especie_que_nao_seja_em_reais'
			#     bradesco.especie_documento = 'outra_especie_do_documento'
			#     bradesco.data_documento    = Date.tomorrow
			#     bradesco.aceite            = false
			#   end
			#
			# @return [Hash] Código da Moeda sendo '9' (real). Espécie sendo 'R$' (real).
			#
			def default_values
				{
					codigo_moeda:      '9',
					especie:           'R$',
					especie_documento: 'DM',
					local_pagamento:   'PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO',
					data_documento:    Date.current,
					aceite:            false
				}
			end

			# O Nosso Número é o número que identifica unicamente um boleto para uma conta.
			# O tamanho máximo do Nosso Número depende do banco e carteira.
			#
			# <b>Para carteiras registradas, você deve solicitar ao seu banco um intervalo de números para utilização.</b>
			# Quando estiver perto do fim do intervalo, deve solicitar um novo intervalo.
			#
			# <b>Para carteiras não registradas o Nosso Número é livre</b>.
			# Ao receber o retorno do banco, é através do Nosso Número que será possível identificar os boletos pagos.
			#
			# <b>Esse campo é específico para cada banco</b>.
			#
			# @return [String] Corresponde ao formato específico de cada banco.
			# @raise [NotImplementedError] Precisa implementar nas subclasses.
			#
			def nosso_numero
				raise NotImplementedError.new("Not implemented #nosso_numero in #{self}.")
			end

			# Formata o valor do documentado para ser mostrado no código de barras
			# e na linha digitável com 08 dígitos na casa dos Reais e 02 dígitos nas casas dos centavos.
			#
			# @example
			#
			#    Bradesco.new(:valor_documento => 123.45).valor_formatado_para_codigo_de_barras
			#    # => "0000012345"
			#
			# @return [String] Precisa retornar 10 dígitos para o código de barras (incluindo os centavos).
			#
			def valor_formatado_para_codigo_de_barras
				valor_documento_formatado = (Integer(valor_documento.to_f * 100) / Float(100))
				real, centavos            = valor_documento_formatado.to_s.split(/\./)
				"#{real.rjust(8, '0')}#{centavos.ljust(2, '0')}"
			end

			# Se o aceite for 'true', retorna 'S'.
			# Retorna 'N', caso contrário.
			#
			# @return [String]
			#
			def aceite_formatado
				if @aceite.present?
					'S'
				else
					'N'
				end
			end

			# Fator de vencimento que é calculado a partir de uma data base.
			# Veja <b>FatorVencimento</b> para mais detalhes.
			#
			# @return [String] 4 caracteres.
			#
			def fator_de_vencimento
				FatorVencimento.new(data_vencimento)
			end

			# === Código de Barras
			#
			# O código de barras contêm exatamente 44 posições nessa sequência:
			#
			#     ____________________________________________________________
			#    | Posição  | Tamanho | Descrição                            |
			#    |----------|---------|--------------------------------------|
			#    | 01-03    |  03     | Código do banco                      |
			#    | 04       |  01     | Código da moeda                      |
			#    | 05       |  01     | Dígito do código de barras (DAC)     |
			#    | 06-09    |  04     | Fator de vencimento                  |
			#    | 10-19    |  10     | Valor do documento                   |
			#    | 20-44    |  25     | Critério de cada Banco (Campo livre) |
			#    -------------------------------------------------------------
			#
			# @return [String] Código de barras com 44 posições.
			#
			def codigo_de_barras
				"#{codigo_de_barras_padrao}#{codigo_de_barras_do_banco}".insert(4, digito_codigo_de_barras)
			end

			# Primeira parte do código de barras.
			# <b>Essa parte do código de barras é padrão para todos os bancos.</b>.
			#
			# @return [String] Primeiras 18 posições do código de barras (<b>Não retorna o DAC do código de barras</b>).
			#
			def codigo_de_barras_padrao
				"#{conta.codigo_banco}#{codigo_moeda}#{fator_de_vencimento}#{valor_formatado_para_codigo_de_barras}"
			end

			# Segunda parte do código de barras.
			# <b>Esse campo é específico para cada banco</b>.
			#
			# @return [String] 25 últimas posições do código de barras.
			# @raise [NotImplementedError] Precisa implementar nas subclasses.
			#
			def codigo_de_barras_do_banco
				raise NotImplementedError.new("Not implemented #codigo_de_barras_do_banco in #{self}.")
			end

			# Dígito verificador do código de barras (DAC).
			#
			# Por definição da FEBRABAN e do Banco Central do Brasil,
			# na <b>5º posição do Código de Barras</b>, deve ser indicado obrigatoriamente
			# o “dígito verificador” (DAC), calculado através do módulo 11.
			#
			# <b>OBS.:</b> Para mais detalhes deste cálculo,
			# veja a descrição em <b>BrBoleto::Calculos::Modulo11FatorDe2a9</b>.
			#
			# @return [String] Dígito calculado do código de barras.
			#
			def digito_codigo_de_barras
				Modulo11FatorDe2a9.new("#{codigo_de_barras_padrao}#{codigo_de_barras_do_banco}")
			end

			# Representação numérica do código de barras, mais conhecida como linha digitável! :p
			#
			# A representação numérica do código de barras é composta, por cinco campos.
			# Sendo os três primeiros campos, amarrados por DAC's (dígitos verificadores),
			# todos calculados pelo módulo 10.
			#
			# <b>OBS.:</b> Para mais detalhes deste cálculo, veja a descrição em Modulo10.
			#
			# === Linha Digitável
			#
			# A linha digitável contêm exatamente 47 posições nessa sequência:
			#
			#     _______________________________________________________________________________________________________
			#    |Campo | Posição  | Tamanho | Descrição                                                                |
			#    |------|----------|---------|--------------------------------------------------------------------------|
			#    | 1º   | 01-03    |  03     | Código do banco (posições 1 a 3 do código de barras)                     |
			#    |      | 04       |  01     | Código da moeda (posição 4 do código de barras)                          |
			#    |      | 05-09    |  5      | Cinco posições do campo livre (posições 20 a 24 do código de barras)     |
			#    |      | 10       |  1      | Dígito verificador do primeiro campo (Módulo10)                          |
			#    |------------------------------------------------------------------------------------------------------|
			#    | 2º   | 11-20    |  10     | 6º a 15º posições do campo livre (posições 25 a 34 do código de barras)  |
			#    |      | 21       |  01     | Dígito verificador do segundo campo  (Módulo10)                          |
			#    |------------------------------------------------------------------------------------------------------|
			#    | 3º   | 22-31    |  10     | 16º a 25º posições do campo livre (posições 35 a 44 do código de barras) |
			#    |      | 32       |  01     | Dígito verificador do terceiro campo  (Módulo10)                         |
			#    |------------------------------------------------------------------------------------------------------|
			#    | 4º   | 33       |  01     | Dígito verificador do código de barras (posição 5 do código de barras)   |
			#    |------------------------------------------------------------------------------------------------------|
			#    | 5ª   | 34-37    |  04     | Fator de vencimento (posições 6 a 9 do código de barras)                 |
			#    |      | 38-47    |  10     | Valor nominal do documento (posições 10 a 19 do código de barras)        |
			#    -------------------------------------------------------------------------------------------------------|
			#
			# @return [String] Contêm a representação numérica do código de barras formatado com pontos e espaços.
			#
			def linha_digitavel
				LinhaDigitavel.new(codigo_de_barras)
			end

			# Returns a string that <b>identifying the render path associated with the object</b>.
			#
			# <b>ActionPack uses this to find a suitable partial to represent the object.</b>
			#
			# @return [String]
			#
			def to_partial_path
				"br_boleto/#{self.class.name.demodulize.underscore}"
			end

			# Seguindo a interface do Active Model.
			#
			# @return [False]
			#
			def persisted?
				false
			end

			# Verifica e valida se a data do vencimento deve ser uma data válida.
			# <b>Precisa ser uma data para o cálculo do fator do vencimento.</b>
			#
			def data_vencimento_deve_ser_uma_data
				errors.add(:data_vencimento, :invalid) unless data_vencimento.kind_of?(Date)
			end
		end
	end
end
