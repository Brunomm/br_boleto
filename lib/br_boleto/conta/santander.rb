# encoding: utf-8
module BrBoleto
	module Conta
		class Santander < BrBoleto::Conta::Base

			# MODALIDADE CARTEIRA:
			#   ___________________________________________
			#  | Carteira | Descrição                     | 
			#  |   101    | Cobrança Simples com registro | 
			#  |   102    | Cobrança Simples sem registro | 
			#  |   121    | Penhor Rápida com registro    | 
			#  --------------------------------------------

			# Código de Transmissão
			# Consultar seu gerente para pegar esse código. Geralmente está no e-mail enviado pelo banco.
			attr_accessor :codigo_transmissao

			###############################  VALIDAÇÕES DINÂMICAS ###############################
				# Código de Transmissão
				attr_accessor :valid_codigo_transmissao_required

				validates :codigo_transmissao, custom_length: { maximum: 20 }
				# validates :codigo_transmissao, presence: true, if: :valid_codigo_transmissao_required
			#####################################################################################

			def default_values
				super.merge({
					carteira:                      '101', 			 
					valid_carteira_required:       true, # <- Validação dinâmica que a modalidade é obrigatória
					valid_carteira_length:         3,    # <- Validação dinâmica que a modalidade deve ter 3 digitos
					valid_carteira_inclusion:      %w[101 102 121], # <- Validação dinâmica de valores aceitos para a modalidade
					codigo_carteira:               '1',   # Cobrança Simples
					valid_codigo_carteira_length:   1,    # <- Validação dinâmica que a modalidade deve ter 1 digito
					valid_conta_corrente_required: true,  # <- Validação dinâmica que a conta_corrente é obrigatória
					valid_conta_corrente_maximum:  9,     # <- Validação que a conta_corrente deve ter no máximo 9 digitos
					valid_convenio_required:       true,  # <- Validação que a convenio deve ter obrigatório
					valid_convenio_maximum:        7,     # <- Validação que a convenio deve ter no máximo 7 digitos
				})
			end

			def codigo_banco
				'033'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'7'
			end

			def nome_banco
				@nome_banco ||= 'SANTANDER'
			end

			def versao_layout_arquivo_cnab_240
				'040'
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
				@conta_corrente_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(conta_corrente).to_s
			end

			def codigo_transmissao
				"#{@codigo_transmissao}".rjust(20, '0') if @codigo_transmissao.present?
			end

			# Campo Agência / Código do Cedente
			# @return [String] Agência com 4 caracteres / Convênio com 7 caracteres
			# Exemplo: 9999 / 9999999
			def agencia_codigo_cedente
				"#{agencia} / #{convenio}"
			end

			# Formata a carteira dependendo se ela é registrada ou não.
			# Para cobrança COM registro usar: COBRANCA SIMPLES ECR
			# Para Cobrança SEM registro usar: COBRANCA SIMPLES CSR
			def carteira_formatada
				if @carteira.to_s.in?(carteiras_com_registro)
					"COBRANÇA SIMPLES ECR"
				else
					'COBRANÇA SIMPLES CSR'
				end
			end

			# Retorna as carteiras com registro do banco Santander.
			# Você pode sobrescrever esse método na subclasse caso exista mais
			# carteiras com registro no Santander.
			def carteiras_com_registro
				%w(101 121)
			end

			################################# DEFAULT CODES ###############################################

				# Espécie do Título :
				def equivalent_especie_titulo_240
					#  Padrão    Código para    Descrição 
					{# da GEM     o Banco
						'02'	 =>	'02' ,       # DM  - DUPLICATA MERCANTIL
						'04'	 =>	'04' ,       # DS  - DUPLICATA DE SERVICO
						'07'	 =>	'07' ,       # LC  - LETRA DE CÂMBIO
						'12'	 =>	'12' ,       # NP  - NOTA PROMISSORIA
						'13'	 =>	'13' ,       # NR  - NOTA PROMISSORIA RURAL
						'17'	 =>	'17' ,       # RC  - RECIBO
						'20'	 =>	'20' ,       # AP  - APOLICE DE SEGURO
						'01'	 =>	'97' ,       # CH  - CHEQUE
						'98'	 =>	'98' ,       # NPD - NOTA PROMISSORIA DIRETA
					}
				end
				def equivalent_especie_titulo_400
					#  Padrão    Código para    Descrição 
					{# da GEM     o Banco
						'02'	 =>	'01' ,       # DM  - DUPLICATA MERCANTIL
						'04'	 =>	'06' ,       # DS  - DUPLICATA DE SERVICO
						'07'	 =>	'07' ,       # LC  - LETRA DE CÂMBIO
						'12'	 =>	'02' ,       # NP  - NOTA PROMISSORIA
						'17'	 =>	'05' ,       # RC  - RECIBO
						'20'	 =>	'03' ,       # AP  - APOLICE DE SEGURO
					}
				end

				# Código Movimento da Remessa CNAB240
				def equivalent_codigo_movimento_remessa_240
					#  Padrão    Código para    Descrição 
					{# da GEM     o Banco
						'01'	 =>	'01' ,       # Entrada de título
						'02'	 =>	'02' ,       # Pedido de baixa
						'04'	 =>	'04' ,       # Concessão de abatimento
						'05'	 =>	'05' ,       # Cancelamento de abatimento
						'06'	 =>	'06' ,       # Alteração de vencimento
						'07'	 =>	'10' ,       # Concessão de Desconto
						'08'	 =>	'11' ,       # Cancelamento de desconto
						'09'	 =>	'09' ,       # Pedido de Protesto
						'10'	 =>	'18' ,       # Pedido de Sustação de Protesto
						'21'	 =>	'07' ,       # Alteração da identificação do título na empresa
						'22'	 =>	'08' ,       # Alteração seu número
						'31'	 =>	'31' ,       # Alteração de outros dados
						'41'	 =>	'98' ,       # Não Protestar
					}
				end

				# Código Movimento da Remessa CNAB400
				def equivalent_codigo_movimento_remessa_400
					#  Padrão    Código para    Descrição 
					{# da GEM     o Banco
						'01'	 =>	'01' ,       # Entrada de título
						'02'	 =>	'02' ,       # Pedido de baixa
						'04'	 =>	'04' ,       # Concessão de abatimento
						'05'	 =>	'05' ,       # Cancelamento de abatimento
						'06'	 =>	'06' ,       # Alteração de vencimento
						'21'	 =>	'07' ,       # Alteração da identificação do título na empresa
						'22'	 =>	'08' ,       # Alteração seu número
						'09'	 =>	'09' ,       # Pedido de Protesto
						'10'	 =>	'18' ,       # Sustar Protesto e Baixar Título
						'11'	 =>	'18' ,       # Sustar Protesto e Manter em Carteira
					}
				end

				# Código de Multa
				def equivalent_codigo_multa
					#  Padrão    Código para    Descrição 
					{# da GEM     o Banco
						'1'    =>    '4',        # Com Multa
						'2'    =>    '4',        # Com Multa
						'3'    =>    '0',        # Sem Multa (Isento)
					}
				end
				def default_codigo_multa
					'0'
				end

				# Código da Carteira
				def equivalent_tipo_cobranca_240
					super.merge({
					#  Padrão    Código para 
					# da GEM     o Banco
						'1'    =>   '5',   # Cobrança Simples (Rápida com Registro)
						'3'    =>   '3',   # Cobrança Caucionada (Eletrônica com Registro e Convencional com Registro)
						'4'    =>   '4',   # Cobrança Descontada (Eletrônica com Registro)
						'6'    =>   '6',   # Cobrança Caucionada (Rápida com Registro)
						'7'    =>   '1',   # Cobrança Simples (Sem Registro / Eletrônica com Registro)
					}) 
				end
				def equivalent_tipo_cobranca_400
					super.merge({
					#  Padrão    Código para
					# da GEM     o Banco
						'7'    =>    '4',  # Cobrança Sem Registro
						'4'    =>    '7',  # Cobrança Descontada
					})
				end

				# Código para Protesto
				def equivalent_codigo_protesto
					super.merge({
					#  Padrão    Código para
					# da GEM     o Banco
						'3'    =>    '0',  # Não Protestar
						'99'   =>    '3',  # Utilizar perfil cedente
					})
				end

				# Código da Moeda CNAB240
				def equivalent_codigo_moeda_240
					super.merge({'09' => '00' }) # 00 = Real
				end

				# Identificações de Ocorrência / Código de ocorrência:
				def equivalent_codigo_movimento_retorno_400
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'01'   =>  '104',  # título não existe
							'07'   =>  '102',  # liquidação por conta
							'08'   =>  '103',  # liquidação por saldo
							'15'   =>  '23',   # Enviado para Cartório
							'16'   =>  '25' ,  # tít. já baixado/liquidado
							'17'   =>  '101',  # liquidado em cartório
							'21'   =>  '23' ,  # Entrada em Cartório
							'22'   =>  '24' ,  # Retirado de cartório
							'24'   =>  '235',  # Custas de Cartório
							'25'   =>  '19' ,  # Protestar Título
							'26'   =>  '20' ,  # Sustar Protestonhado a Protesto: Identifica o recebimento da instrução de protesto
						})
				end

				# Código do Motivo da ocorrência :
				def equivalent_codigo_motivo_ocorrencia_A_400 codigo_movimento_gem
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'001'  =>  'A08',  # NOSSO NUMERO NAO NUMERICO
							'002'  =>  'A33',  # VALOR DO ABATIMENTO NAO NUMERICO
							'003'  =>  'A16',  # DATA VENCIMENTO NAO NUMERICA
							'005'  =>  'A10',  # CODIGO DA CARTEIRA NAO NUMERICO
							'006'  =>  'A10',  # CODIGO DA CARTEIRA INVALIDO
							'007'  =>  'A21',  # ESPECIE DO DOCUMENTO INVALIDA
							'010'  =>  'A278', # CODIGO PRIMEIRA INSTRUCAO NAO NUMERICA
							'011'  =>  'A280', # CODIGO SEGUNDA INSTRUCAO NAO NUMERICA
							'013'  =>  'A20',  # VALOR DO TITULO NAO NUMERICO
							'014'  =>  'A27',  # VALOR DE MORA NAO NUMERICO
							'015'  =>  'A24',  # DATA EMISSAO NAO NUMERICA
							'016'  =>  'A16',  # DATA DE VENCIMENTO INVALIDA
							'017'  =>  'A61',  # CODIGO DA AGENCIA COBRADORA NAO NUMERICA
							'019'  =>  'A48',  # NUMERO DO CEP NAO NUMERICO
							'020'  =>  'A46',  # TIPO INSCRICAO NAO NUMERICO
							'021'  =>  'A46',  # NUMERO DO CGC OU CPF NAO NUMERICO
							'022'  =>  'A244', # CODIGO OCORRENCIA INVALIDO
							'023'  =>  'A08',  # NOSSO NUMERO INV.P/MODALIDADE
							'025'  =>  'A28',  # VALOR DESCONTO NAO NUMERICO
							'029'  =>  'A27',  # VALOR DE MORA INVALIDO
							'030'  =>  'A256', # DT VENC MENOR DE 15 DIAS DA DT PROCES
							'039'  =>  'A254', # PERFIL NAO ACEITA TITULO EM BCO CORRESP
							'040'  =>  'A255', # COBR RAPIDA NAO ACEITA-SE BCO CORRESP
							'042'  =>  'A07',  # CONTA COBRANCA INVALIDA
							'049'  =>  'A86',  # SEU NUMERO NAO CONFERE COM O CARNE
							'052'  =>  'A227', # OCOR. NAO ACATADA,TITULO LIOUIDADO
							'053'  =>  'A227', # OCOR. NAO ACATADA, TITULO BAIXADO
							'057'  =>  'A322', # CEP DO SACADO INCORRETO
							'058'  =>  'A06',  # CGC/CPF INCORRETO
							'063'  =>  'A49',  # CEP NAO ENCONTRADO NA TABELA DE PRACAS
							'073'  =>  'A34',  # ABATIMENTO MAIOR/IGUAL AO VALOR TITULO
							'074'  =>  'A29',  # PRIM. DESCONTO MAIOR/IGUAL VALOR TITULO
							'075'  =>  'A29',  # SEG. DESCONTO MAIOR/IGUAL VALOR TITULO
							'076'  =>  'A29',  # TERC. DESCONTO MAIOR/IGUAL VALOR TITULO
							'086'  =>  'A80',  # DATA SEGUNDO DESCONTO INVALIDA
							'087'  =>  'A80',  # DATA TERCEIRO DESCONTO INVALIDA
							'091'  =>  'A31',  # JA EXISTE CONCESSAO DE DESCONTO
							'092'  =>  'A09',  # NOSSO NUMERO JA CADASTRADO
							'093'  =>  'A20',  # VALOR DO TITULO NAO INFORMADO
							'098'  =>  'A24',  # DATA EMISSAO INVALIDA
							'100'  =>  'A17',  # DATA EMISSAO MAIOR OUE A DATA VENCIMENTO
							'104'  =>  'A52',  # UNIDADE DA FEDERACAO NAO INFORMADA
							'106'  =>  'A06',  # CGCICPF NAO INFORMADO
							'107'  =>  'A52',  # UNIDADE DA FEDERACAO INCORRETA 00108 DIGITO CGC/CPF INCORRETO
							'110'  =>  'A80',  # DATA PRIMEIRO DESCONTO INVALIDA
							'111'  =>  'A80',  # DATA DESCONTO NAO NUMERICA
							'112'  =>  'A28',  # VALOR DESCONTO NAO INFORMADO
							'113'  =>  'A28',  # VALOR DESCONTO INVALIDO
							'114'  =>  'A33',  # VALOR ABATIMENTO NAO INFORMADO
							'115'  =>  'A34',  # VALOR ABATIMENTO MAIOR VALOR TITULO
							'116'  =>  'A58',  # DATA MULTA NAO NUMERICA
							'117'  =>  'A29',  # VALOR DESCONTO MAIOR VALOR TITULO
							'118'  =>  'A58',  # DATA MULTA NAO INFORMADA
							'120'  =>  'A59',  # PERCENTUAL MULTA NAO NUMERICO
							'121'  =>  'A59',  # PERCENTUAL MULTA NAO INFORMADO
							'122'  =>  'A32',  # VALOR IOF MAIOR OUE VALOR TITULO
							'123'  =>  'A322', # CEP DO SACADO NAO NUMERICO
							'124'  =>  'A48',  # CEP SACADO NAO ENCONTRADO
							'129'  =>  'A21',  # ESPEC DE DOCUMENTO NAO NUMERICA
							'130'  =>  'A11',  # FORMA DE CADASTRAMENTO NAO NUMERICA
							'131'  =>  'A11',  # FORMA DE CADASTRAMENTO INVALIDA
							'132'  =>  'A11',  # FORMA CADAST. 2 INVALIDA PARA CARTEIRA 3
							'133'  =>  'A11',  # FORMA CADAST. 2 INVALIDA PARA CARTEIRA 4
							'134'  =>  'A05',  # CODIGO DO MOV. REMESSA NAO NUMERICO
							'135'  =>  'A05',  # CODIGO DO MOV. REMESSA INVALIDO
							'139'  =>  'A02',  # TIPO DE REGISTRO INVALIDO
							'140'  =>  'A03',  # COD. SEOUEC.DO REG. DETALHE INVALIDO
							'142'  =>  'A07',  # NUM.AG.CEDENTE/DIG.NAO NUMERICO
							'143'  =>  'A07',  # NUM. CONTA CEDENTE/DIG. NAO NUMERICO
							'144'  =>  'A12',  # TIPO DE DOCUMENTO NAO NUMERICO
							'145'  =>  'A12',  # TIPO DE DOCUMENTO INVALIDO
							'149'  =>  'A26',  # CODIGO DE MORA INVALIDO
							'150'  =>  'A26',  # CODIGO DE MORA NAO NUMERICO
							'151'  =>  'A27',  # VL.MORA IGUAL A ZEROS P. COD.MORA 1
							'152'  =>  'A27',  # VL. TAXA MORA IGUAL A ZEROS P.COD MORA 2
							'153'  =>  'A27',  # VL. MORA DIFERENTE DE ZEROS P.COD.MORA 3
							'154'  =>  'A27',  # VL. MORA NAO NUMERICO P. COD MORA 2
							'155'  =>  'A27',  # VL. MORA INVALIDO P. COD.MORA 4
							'160'  =>  'A319', # BAIRRO DO SACADO NAO INFORMADO
							'161'  =>  'A53',  # TIPO INSC.CPF/CGC SACADOR/AVAL.NAO NUM.
							'170'  =>  'A11',  # FORMA DE CADASTRAMENTO 2 INV.P.CART.5
							'199'  =>  'A53',  # TIPO INSC.CGC/CPF SACADOR.AVAL.INVAL.
							'200'  =>  'A53',  # NUM.INSC.(CGC)SACADOR/AVAL.NAO NUMERICO
							'212'  =>  'A79',  # DATA DO JUROS DE MORA NAO NUMERICO (D3P)
							'242'  =>  'A57',  # COD. DA MULTA NAO NUMERICO (D3R)
							'243'  =>  'A57',  # COD. MULTA INVALIDO (D3R)
							'244'  =>  'A59',  # VALOR DA MULTA NAO NUMERICO (D3R)
							'245'  =>  'A58',  # DATA DA MULTA NAO NUMERICO (D3R)
							'258'  =>  'A27',  # VL.MORA NAO NUMERICO P.COD=4(D3P)
							'263'  =>  'A278', # INSTRUCAO PARA TITULO NAO REGISTRADO
							'264'  =>  'A23',  # CODIGO DE ACEITE (A/N) INVALIDO.
						})
				end
		end
	end
end
