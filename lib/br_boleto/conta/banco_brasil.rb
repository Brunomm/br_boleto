# encoding: utf-8
module BrBoleto
	module Conta
		class BancoBrasil < BrBoleto::Conta::Base

			# MODALIDADE CARTEIRA:
			#      _________________________________________________________________
			#     | Carteira  | Descrição                                          |
			#     |   11      | Cobrança Simples - Com Registro                    |
			#     |   12      | Cobrança Indexada - Com Registro                   |
			#     |   15      | Cobrança de Prêmios de Seguro - Com Registro       |
			#     |   16      | Cobranca Simples                                   |
			#     |   17      | Cobranca Direta Especial - Com Registro            |
			#     |   18      | Cobranca Simples  (Nosso Número 11 Dígitos)        |
			#     |   31      | Cobrança Caucionada/Vinculada - Com Registro       |
			#     |   51      | Cobrança Descontada - Com Registro                 |
			#     -----------------------------------------------------------------

			# VARIAÇÃO DA CARTEIRA
			# O Banco do Brasil utiliza carteiras de cobrança com variações iniciando em 01 até 99 + dígito verificador, exceto aquelas em que o DV seja igual a X.
			# Normalmente as empresas utilizam uma única variação (019), porém podem ter outras variações, dependendo da necessidade.
			# Consultar a agência quando necessitar dessa informação para fins de configuração do sistema, pois o cadastramento é a a cargo da agência.
			attr_accessor :variacao_carteira

			###############################  VALIDAÇÕES DINÂMICAS ###############################
				# Variação da Carteira
				attr_accessor :valid_variacao_carteira_required

				validates :variacao_carteira, custom_length: { maximum: 3 }
				validates :variacao_carteira, presence: true, if: :valid_variacao_carteira_required
			#####################################################################################

			def default_values
				super.merge({
					carteira:                      '18', 			 
					variacao_carteira:             '019', 			 
					valid_carteira_required:       true, # <- Validação dinâmica que a modalidade é obrigatória
					valid_carteira_length:         2,    # <- Validação dinâmica que a modalidade deve ter 2 digitos
					valid_carteira_inclusion:      carteiras_suportadas, # <- Validação dinâmica de valores aceitos para a modalidade
					codigo_carteira:               '1',   # Cobrança Simples
					valid_codigo_carteira_length:   1,    # <- Validação dinâmica que a modalidade deve ter 1 digito
					valid_conta_corrente_required: true,  # <- Validação dinâmica que a conta_corrente é obrigatória
					valid_conta_corrente_maximum:  8,     # <- Validação que a conta_corrente deve ter no máximo 8 digitos
					valid_convenio_required:       true,  # <- Validação que a convenio deve ter obrigatório
					# valid_convenio_maximum:        8,     # <- Validação que a convenio deve ter no máximo 8 digitos
				})
			end

			def codigo_banco
				'001'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'9'
			end

			def nome_banco
				@nome_banco ||= 'BANCO DO BRASIL S.A.'
			end

			def versao_layout_arquivo_cnab_240
				'083'
			end

			def versao_layout_lote_cnab_240
				'042'
			end

			# Carteiras suportadas
			def carteiras_suportadas
				%w[11 12 15 16 17 18 31 51]
			end

			def variacao_carteira
				"#{@variacao_carteira}".rjust(3, '0') if @variacao_carteira.present?
			end

			def agencia_dv
				# utilizando a agencia com 4 digitos
				# para calcular o digito
				@agencia_dv ||= BrBoleto::Calculos::Modulo11FatorDe9a2RestoX.new(agencia).to_s
			end

			def conta_corrente_dv
				@conta_corrente_dv ||= BrBoleto::Calculos::Modulo11FatorDe9a2RestoX.new(conta_corrente).to_s
			end

			# Campo Agência / Código do Cedente
			# @return [String] Agência com 4 caracteres - digito da agência / Conta de Cobrança com 8 caracteres - Digito da Conta
			# Exemplo: 9999-D / 99999999-D
			def agencia_codigo_cedente
				"#{agencia}-#{agencia_dv} / #{conta_corrente}-#{conta_corrente_dv}"
			end

			# Código da Carteira
			def equivalent_tipo_cobranca_400
				{
					'5' => '8', # Cobrança BBVendor
					'7' => '7', # Cobrança Direta Especial
				}
			end

			# Código Movimento da Remessa CNAB400
			def equivalent_codigo_movimento_remessa_400
				#  Padrão    Código para    Descrição 
				{# da GEM     o Banco
					'01'   =>   '01' ,     # Registro de títulos
					'02'   =>   '02' ,     # Solicitação de baixa
					'03'   =>   '03' ,     # Pedido de débito em conta
					'04'   =>   '04' ,     # Concessão de abatimento
					'05'   =>   '05' ,     # Cancelamento de abatimento
					'06'   =>   '06' ,     # Alteração de vencimento de título
					'22'   =>   '07' ,     # Alteração do número de controle do participante
					'21'   =>   '08' ,     # Alteração do número do titulo dado pelo cedente
					'09'   =>   '09' ,     # Instrução para protestar 
					'10'   =>   '10' ,     # Instrução para sustar protesto
					'11'   =>   '11' ,     # Instrução para dispensar juros
					'24'   =>   '12' ,     # Alteração de nome e endereço do Sacado
					'12'   =>   '16' ,     # Alterar Juros de Mora
					'31'   =>   '31' ,     # Conceder desconto
					'32'   =>   '32' ,     # Não conceder desconto
					'33'   =>   '33' ,     # Retificar dados da concessão de desconto
					'34'   =>   '34' ,     # Alterar data para concessão de desconto
					'35'   =>   '35' ,     # Cobrar multa 
					'36'   =>   '36' ,     # Dispensar multa 
					'37'   =>   '37' ,     # Dispensar indexador
					'38'   =>   '38' ,     # Dispensar prazo limite de recebimento
					'39'   =>   '39' ,     # Alterar prazo limite de recebimento
					'40'   =>   '40' ,     # Alterar carteira/modalidade
				}
			end

			# Espécie do Título
			def equivalent_especie_titulo_400
				#  Padrão    Código para  
				{# da GEM     o Banco
					'01'    =>   '10' , #  Cheque
					'02'    =>   '01' , #  Duplicata Mercantil
					'04'    =>   '12' , #  Duplicata de Serviço
					'07'    =>   '08' , #  Letra de Câmbio
					'12'    =>   '02' , #  Nota Promissória
					'16'    =>   '03' , #  Nota de Seguro
					'17'    =>   '05' , #  Recibo
					'19'    =>   '13' , #  Nota de Débito
					'20'    =>   '15' , #  Apólice de Seguro
					'26'    =>   '09' , #  Warrant
					'27'    =>   '26' , #  Dívida Ativa de Estado
					'28'    =>   '27' , #  Dívida Ativa de Município
					'29'    =>   '25' , #  Dívida Ativa da União
					'99'    =>   '99' , #  Outros
				}
			end

			# Código Motivo Ocorrência Retorno
			def equivalent_codigo_motivo_ocorrencia_A codigo_movimento_gem
				super.merge(
					#  Padrão    Código para  
					{# do Banco    a GEM
						'52'    =>   'A104' , # Registro Rejeitado – Título já Liquidado
					})
			end

			# Identificações de Ocorrência / Código de ocorrência:
			def equivalent_codigo_movimento_retorno_400
				super.merge(
					#  Padrão    Código para  
					{# do Banco    a GEM
						'05'   =>   '17',   # Liquidado sem registro (carteira 17=tipo4)
						'07'   =>   '102',  # Liquidação por Conta/Parcial
						'08'   =>   '103',  # Liquidação por Saldo
						'15'   =>   '101',  # Liquidação em Cartório
						'16'   =>   '57',   # Confirmação de alteração de juros de mora
						'20'   =>   '120',  # Débito em Conta
						'21'   =>   '43',   # Alteração do Nome do Sacado
						'22'   =>   '43',   # Alteração do Endereço do Sacado
						'24'   =>   '20',   # Sustar Protesto
						'25'   =>   '60',   # Dispensar Juros de mora
						'26'   =>   '40',   # Alteração do número do título dado pelo Cedente (Seu número) – 10 e 15posições
						'28'   =>   '108',  # Manutenção de titulo vencido
						'31'   =>   '07',   # Conceder desconto
						'32'   =>   '08',   # Não conceder desconto
						'33'   =>   '58',   # Retificar desconto
						'34'   =>   '58',   # Alterar data para desconto
						'35'   =>   '56',   # Cobrar Multa
						'36'   =>   '55',   # Dispensar Multa
						'37'   =>   '121',  # Dispensar Indexador
						'38'   =>   '39',   # Dispensar prazo limite para recebimento
						'39'   =>   '38',   # Alterar prazo limite para recebimento
						'46'   =>   '45',   # Título pago com cheque, aguardando compensação
						'73'   =>   '123',  # Confirmação de Instrução de Parâmetro de Pagamento Parcial
					})
			end
		end
	end
end
