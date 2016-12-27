# encoding: utf-8
module BrBoleto
	module Conta
		class Sicredi < BrBoleto::Conta::Base
			
			# MODALIDADE CARTEIRA:
			#      _______________________________________________
			#     | Carteira | Descrição                         |
			#     |   1     | Cobrança Simples Com registro      |
			#     |   3     | Cobrança SimplesSem registro       |
			#     ------------------------------------------------

			# Código do posto da cooperativa de crédito
     		attr_accessor :posto

			# Byte de identificação do cedente do bloqueto utilizado para compor o nosso número.
			# Valores aceitos de 2 a 9, somente será "1" se forem boletos pré-impressos.
			attr_accessor :byte_id

			###############################  VALIDAÇÕES DINÂMICAS ###############################
				attr_accessor :valid_byte_id_length
				attr_accessor :valid_byte_id_required
				attr_accessor :valid_byte_id_inclusion
				attr_accessor :valid_posto_maximum
				attr_accessor :valid_posto_required
			#####################################################################################

			# Byte de identificação
			validates :byte_id, custom_length:    {is: :valid_byte_id_length},     if: :valid_byte_id_length
			validates :byte_id, custom_inclusion: {in: :valid_byte_id_inclusion},  if: :valid_byte_id_inclusion
			validates :byte_id, presence: true,   if:  :valid_byte_id_required

			# Posto
			validates :posto,    custom_length:    {maximum: :valid_posto_maximum},    if: :valid_posto_maximum
			validates :posto,    presence: true,   if: :valid_posto_required


			def default_values
				super.merge({
					carteira:                      '1', 			 
					valid_carteira_required:       true,    # <- Validação dinâmica que a modalidade é obrigatória
					valid_carteira_length:         1,       # <- Validação dinâmica que a modalidade deve ter 1 digito
					valid_carteira_inclusion:      %w[1 3], # <- Validação dinâmica de valores aceitos para a modalidade
					valid_conta_corrente_required: true,    # <- Validação dinâmica que a conta_corrente é obrigatória
					valid_conta_corrente_maximum:  5,       # <- Validação que a conta_corrente deve ter no máximo 5 digitos
					valid_convenio_required:       true,    # <- Validação que a convenio deve ter obrigatório
					valid_convenio_maximum:        5,       # <- Validação que a convenio deve ter no máximo 5 digitos
					codigo_carteira:               '1',     # Cobrança Simples
					valid_codigo_carteira_length:   1,      # <- Validação dinâmica que a modalidade deve ter 1 digito
					posto:                         '0',     
					valid_posto_maximum:           2,       # <- Validação que a posto deve ter no máximo 2 digitos
					valid_posto_required:          true,    # <- Validação que a posto deve ter obrigatório
					byte_id:                      '2',
					valid_byte_id_length:         1,        # <- Validação dinâmica que o byte identificador deve ter 1 digito
					valid_byte_id_required:       true,     # <- Validação que a byte_id deve ter obrigatório
					valid_byte_id_inclusion:      %w[2 3 4 5 6 7 8 9], # <- Validação dinâmica de valores aceitos para o byte identificador
				})
			end

			def codigo_banco
				'748'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'X'
			end

			def nome_banco
				@nome_banco ||= 'SICREDI'
			end

			def versao_layout_arquivo_cnab_240
				'081'
			end

			def versao_layout_lote_cnab_240
				'040'
			end

			def posto
				"#{@posto}".rjust(2, '0') if @posto.present?
			end

			def byte_id
				"#{@byte_id}".rjust(1, '2') if @byte_id.present?
			end

			def agencia_dv
				@agencia_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9.new(agencia).to_s
			end

			# Campo Agência / Código do Cedente
			# @return [String] Agência com 4 caracteres . Posto do beneficiário com 2 caracteres . Código do beneficiário com 5 caracteres 
			# Exemplo: AAAA.PP.CCCCC
			def agencia_codigo_cedente
				"#{agencia}.#{posto}.#{codigo_cedente}"
			end

			# Espécie do Título CNAB 240 
			def equivalent_especie_titulo_240
				super.merge(
					#  Padrão    Código para  
					{# da GEM     o Banco
						'01'    =>   '03', # Duplicata Mercantil por Indicação (DMI)
						'02'    =>   '03'  # Duplicata Mercantil por Indicação (DMI)
					})
			end

			# Espécie do Título CNAB 400
			def equivalent_especie_titulo_400
				super.merge(
					#  Padrão    Código para  
					{# da GEM     o Banco
						'01'    =>   'A',
						'02'    =>   'A',
						'03'    =>   'A',  # Duplicata Mercantil por Indicação (DMI)
						'06'    =>   'B',  # Duplicata Rural (DR)
						'12'    =>   'C',  # Nota Promissória (NP)
						'13'    =>   'D',  # Nota Promissória Rural (NR)
						'16'    =>   'E',  # Nota de Seguros (NS)
						'17'    =>   'G',  # Recibo (RC)
						'07'    =>   'H',  # Letra de Câmbio (LC)
						'19'    =>   'I',  # Nota de Débito (ND)
						'05'    =>   'J',  # Duplicata de Serviço por Indicação (DSI)
						'99'    =>   'K',  # Outros (OS)
						'32'    =>   'O'   # Boleto de Proposta (BDP)
					})
			end

			# Código da Carteira 
			def equivalent_tipo_cobranca_400
				super.merge({ '1' => 'A' }) # Cobrança Simples
			end	

			# Identificação do Tipo de Impressão : 
			def equivalent_tipo_impressao_400
				super.merge({ '1' => 'A' }) # Frente do Bloqueto
			end	

			# Código da Moeda : 
			def equivalent_codigo_moeda_400
				super.merge({ '09' => 'A' }) # Real
			end	

			# Identificação da Emissão do Boleto de Pagamento
			def equivalent_identificacao_emissao_400
				super.merge(
					#  Padrão    Código para  
					{# da GEM     o Banco
						'1'    =>   'A',  # Impressão é feita pelo Sicredi
						'2'    =>   'B',  # Impressão é feita pelo Beneficiário
					})
			end

			# Código adotado pelo SICREDI para identificação do tipo de desconto que deverá ser concedido.
			def equivalent_codigo_desconto
				{
					'0' => '1', # Valor Fixo Até a Data Informada
					'1' => '1', # Valor Fixo Até a Data Informada
					'2' => '2', # Percentual Até a Data Informada
					'3' => '3', # Valor por Antecipação Dia Corrido
					'4' => '3', # Valor por Antecipação Dia Úti
					'5' => '2', # Percentual Sobre o Valor Nominal Dia Corrido
					'6' => '2', # Percentual Sobre o Valor Nominal Dia Útil
					'7' => '7', # Cancelamento de Desconto
				}
			end

			# Código de Movimento Retorno 
			def equivalent_codigo_movimento_retorno_240
				super.merge(
					#  Padrão    Código para  
					{# do Banco    a GEM
						'36'   =>   '100',      # Baixa rejeitada
					})
			end

			# Código do Motivo da ocorrência :
			def codigos_movimento_retorno_para_ocorrencia_D_240
				%w[27]
			end
			def equivalent_codigo_motivo_ocorrencia_D_240 codigo_movimento_gem
				#  Código     Padrão para  
				{# do Banco     a Gem
					'01'    =>   'D01',   # Alteração de carteira
				}
			end

			def equivalent_codigo_motivo_ocorrencia_A_400 codigo_movimento_gem
				super.merge(
					#  Padrão    Código para  
					{# do Banco    a GEM
						'01'   =>   'A01',     # Código do banco inválido
						'02'   =>   'A02',     # Código do registro detalhe inválido
						'03'   =>   'A05',     # Código da ocorrência inválido
						'04'   =>   'A04',     # Código de ocorrência não permitida para a carteira
						'05'   =>   'A05',     # Código de ocorrência não numérico
						'07'   =>   'A07',     # Cooperativa/agência/conta/dígito inválidos
						'08'   =>   'A08',     # Nosso número inválido
						'09'   =>   'A09',     # Nosso número duplicado
						'10'   =>   'A10',     # Carteira inválida
						'15'   =>   'A07',     # Cooperativa/carteira/agência/conta/nosso número inválidos
						'16'   =>   'A16',     # Data de vencimento inválida
						'17'   =>   'A17',     # Data de vencimento anterior à data de emissão
						'18'   =>   'A18',     # Vencimento fora do prazo de operação
						'20'   =>   'A20',     # Valor do título inválido
						'21'   =>   'A21',     # Espécie do título inválida
						'22'   =>   'A22',     # Espécie não permitida para a carteira
						'24'   =>   'A24',     # Data de emissão inválida
						'29'   =>   'A29',     # Valor do desconto maior/igual ao valor do título
						'31'   =>   'A31',     # Concessão de desconto - existe desconto anterior
						'33'   =>   'A33',     # Valor do abatimento inválido
						'34'   =>   'A34',     # Valor do abatimento maior/igual ao valor do título
						'36'   =>   'A36',     # Concessão de abatimento - existe abatimento anterior
						'38'   =>   'A38',     # Prazo para protesto inválido
						'39'   =>   'A39',     # Pedido para protesto não permitido para o título
						'40'   =>   'A40',     # Título com ordem de protesto emitida
						'41'   =>   'A41',     # Pedido cancelamento/sustação sem instrução de protesto
						'44'   =>   'A209',    # Cooperativa de crédito/agência beneficiária não prevista
						'45'   =>   'A45',     # Nome do pagador inválido
						'46'   =>   'A46',     # Tipo/número de inscrição do pagador inválidos
						'47'   =>   'A47',     # Endereço do pagador não informado
						'48'   =>   'A48',     # CEP irregular
						'49'   =>   'A46',     # Número de Inscrição do pagador/avalista inválido
						'50'   =>   'A54',     # Pagador/avalista não informado
						'60'   =>   'A60',     # Movimento para título não cadastrado
						'63'   =>   'A63',     # Entrada para título já cadastrado
						'A6'   =>   'A244',    # Data da instrução/ocorrência inválida
						'B4'   =>   'A44',     # Tipo de moeda inválido
						'B5'   =>   'A28',     # Tipo de desconto/juros inválido
						'B7'   =>   'A86',     # Seu número inválido
						'B8'   =>   'A59',     # Percentual de multa inválido
						'B9'   =>   'A27',     # Valor ou percentual de juros inválido
						'C2'   =>   'A23',     # Aceite do título inválido
						'C6'   =>   'A325',    # Título já liquidado
						'C7'   =>   'A325',    # Título já baixado
						'H4'   =>   'D01',     # Alteração de carteira
				})
			end

			def equivalent_codigo_motivo_ocorrencia_B_400 codigo_movimento_gem
				super.merge(
					#  Padrão    Código para  
					{# do Banco    a GEM
						'03'   =>   'B03',     # Tarifa de sustação
						'04'   =>   'B04',     # Tarifa de protesto
						'08'   =>   'B08',     # Tarifa de custas de protesto
						'A9'   =>   'B02',     # Tarifa de manutenção de título vencido
						'B1'   =>   'B122',    # Tarifa de baixa da carteira
						'B3'   =>   'B123',    # Tarifa de registro de entrada do título
						'F5'   =>   'B124',    # Tarifa de entrada na rede Sicredi
				})
			end

			# Identificações de Ocorrência / Código de ocorrência:
			def equivalent_codigo_movimento_retorno_400
				super.merge(
					#  Padrão    Código para  
					{# do Banco    a GEM
						'15'   =>   '101', # Liquidação em cartório
						'24'   =>   '106', # Entrada rejeitada por CEP irregular
						'27'   =>   '100', # Baixa rejeitada
						'32'   =>   '26',  # Instrução rejeitada
						'33'   =>   '27',  # Confirmação de pedido de alteração de outros dados
						'34'   =>   '24',  # Retirado de cartório e manutenção em carteira
						'35'   =>   '105', # Aceite do pagador
					})
			end
		end
	end
end
