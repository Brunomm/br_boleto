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
			

			##################################### DEFAULT CODES ###############################################

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
						'21'   =>   '08' ,     # Alteração do número do Título dado pelo cedente
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
				def equivalent_codigo_motivo_ocorrencia_A_240 codigo_movimento_gem
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'52'    =>   'A104' , # Registro Rejeitado – Título já Liquidado
						})
				end

				# Código Motivo Ocorrência Retorno CNAB 400
				def codigos_movimento_retorno_para_ocorrencia_A_400
					%w[02 03]
				end
				def equivalent_codigo_motivo_ocorrencia_A_400 codigo_movimento_gem
					case codigo_movimento_gem
					when '02'
						super.merge(
							#  Padrão    Código para  
							{# do Banco    a GEM
								'00'   =>    'A207',   # Entrada Por meio magnético
								'11'   =>    'A151',   # Entrada Por via convencional
								'16'   =>    'A152',   # Entrada Por alteração do código do cedente
								'17'   =>    'A153',   # Entrada Por alteração da variação
								'18'   =>    'A154',   # Entrada Por alteração da carteira
							})
					when '03'
						super.merge(
							#  Padrão    Código para  
							{# do Banco    a GEM
								'03'   =>    'A27',   # valor dos juros por um dia inválido
								'04'   =>    'A29',   # valor do desconto inválido
								'05'   =>    'A22',   # espécie de título inválida para carteira/variação
								'07'   =>    'A07',   # Prefixo da agência usuária inválido
								'08'   =>    'A20',   # valor do título/apólice inválido
								'09'   =>    'A16',   # data de vencimento inválida
								'16'   =>    'A11',   # Título preenchido de forma irregular
								'19'   =>    'A105',  # Código do cedente inválido
								'20'   =>    'A45',   # Nome/endereço do cliente não informado (ECT)
								'21'   =>    'A10',   # Carteira inválida
								'24'   =>    'A33',   # Valor do abatimento inválido
								'25'   =>    'A86',   # Novo número do título dado pelo cedente inválido (Seu número)
								'26'   =>    'A32',   # Valor do IOF de seguro inválido
								'29'   =>    'A47',   # Endereço não informado
								'30'   =>    'A104',  # Registro de título já liquidado (carteira 17-tipo 4)
								'33'   =>    'A09',   # Nosso número já existente
								'37'   =>    'A24',   # Data de emissão do título inválida
								'38'   =>    'A25',   # Data do vencimento anterior à data da emissão do título
								'39'   =>    'A04',   # Comando de alteração indevido para a carteira
								'41'   =>    'A36',   # Abatimento não permitido
								'42'   =>    'A51',   # CEP/UF inválido/não compatíveis (ECT)
								'46'   =>    'A105',  # Convenio encerrado
								'49'   =>    'A107',  # Abatimento a cancelar não consta do título
								'52'   =>    'A34',   # Abatimento igual ou maior que o valor do Título
								'66'   =>    'A53',   # Número do documento do sacado (CNPJ/CPF) inválido
								'69'   =>    'A59',   # Valor/Percentual de Juros Inválido
								'75'   =>    'A97',   # Qtde. de dias do prazo limite p/ recebimento de título vencido inválido
								'80'   =>    'A08',   # Nosso numero inválido
								'81'   =>    'A80',   # Data para concessão do desconto inválida.
								'82'   =>    'A48',   # CEP do sacado inválido

								'01'   =>    'A155',   # identificação inválida
								'02'   =>    'A156',   # variação da carteira inválida
								'06'   =>    'A157',   # espécie de valor invariável inválido
								'10'   =>    'A158',   # fora do prazo/só admissível na carteira
								'11'   =>    'A159',   # inexistência de margem para desconto
								'12'   =>    'A160',   # o banco não tem agência na praça do sacado
								'13'   =>    'A161',   # razões cadastrais
								'14'   =>    'A162',   # sacado interligado com o sacador (só admissível em cobrança simples- cart. 11 e 17)
								'15'   =>    'A163',   # Título sacado contra órgão do Poder Público (só admissível na carteira 11 e sem ordem de protesto)
								'17'   =>    'A164',   # Título rasurado
								'18'   =>    'A165',   # Endereço do sacado não localizado ou incompleto
								'22'   =>    'A166',   # Quantidade de valor variável inválida
								'23'   =>    'A167',   # Faixa nosso-numero excedida
								'27'   =>    'A168',   # Nome do sacado/cedente inválido
								'28'   =>    'A169',   # Data do novo vencimento inválida
								'31'   =>    'A170',   # Numero do borderô inválido
								'32'   =>    'A171',   # Nome da pessoa autorizada inválido
								'34'   =>    'A172',   # Numero da prestação do contrato inválido
								'35'   =>    'A173',   # percentual de desconto inválido
								'36'   =>    'A174',   # Dias para fichamento de protesto inválido
								'40'   =>    'A175',   # Tipo de moeda inválido
								'43'   =>    'A176',   # Código de unidade variável incompatível com a data de emissão do título
								'44'   =>    'A177',   # Dados para débito ao sacado inválidos
								'45'   =>    'A178',   # Carteira/variação encerrada
								'47'   =>    'A179',   # Título tem valor diverso do informado
								'48'   =>    'A180',   # Motivo de baixa invalido para a carteira
								'50'   =>    'A181',   # Comando incompatível com a carteira
								'51'   =>    'A182',   # Código do convenente invalido
								'53'   =>    'A183',   # Título já se encontra na situação pretendida
								'54'   =>    'A184',   # Título fora do prazo admitido para a conta 1
								'55'   =>    'A185',   # Novo vencimento fora dos limites da carteira
								'56'   =>    'A186',   # Título não pertence ao convenente
								'57'   =>    'A187',   # Variação incompatível com a carteira
								'58'   =>    'A188',   # Impossível a variação única para a carteira indicada
								'59'   =>    'A189',   # Título vencido em transferência para a carteira 51
								'60'   =>    'A190',   # Título com prazo superior a 179 dias em variação única para carteira 51
								'61'   =>    'A191',   # Título já foi fichado para protesto
								'62'   =>    'A192',   # Alteração da situação de débito inválida para o código de responsabilidade
								'63'   =>    'A193',   # DV do nosso número inválido
								'64'   =>    'A194',   # Título não passível de débito/baixa – situação anormal
								'65'   =>    'A195',   # Título com ordem de não protestar – não pode ser encaminhado a cartório
								'67'   =>    'A196',   # Título/carne rejeitado
								'70'   =>    'A197',   # Título já se encontra isento de juros
								'71'   =>    'A198',   # Código de Juros Inválido
								'72'   =>    'A199',   # Prefixo da Ag. cobradora inválido
								'73'   =>    'A200',   # Numero do controle do participante inválido
								'74'   =>    'A201',   # Cliente não cadastrado no CIOPE (Desconto/Vendor)
								'76'   =>    'A202',   # Título excluído automaticamente por decurso de prazo CIOPE (Desconto/Vendor)
								'77'   =>    'A203',   # Título vencido transferido para a conta 1 – Carteira vinculada
								'83'   =>    'A204',   # Carteira/variação não localizada no cedente
								'84'   =>    'A205',   # Título não localizado na existência/Baixado por protesto
								'85'   =>    'A206',   # Recusa do Comando “41” – Parâmetro de Liquidação Parcial.
								'99'   =>    'A999',   # Outros motivos
							})
					else
						super
					end
				end

				def codigos_movimento_retorno_para_ocorrencia_C_400
					%w[06 09 10 17 45 101 102 103 120]
				end
				def equivalent_codigo_motivo_ocorrencia_C_400 codigo_movimento_gem
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'01'   =>   'C103',   # Liquidação normal
							'02'   =>   'C104',   # Liquidação parcial
							'03'   =>   'C01',    # Liquidação por saldo
							'04'   =>   'C105',   # Liquidação com cheque a compensar
							'05'   =>   'C106',   # Liquidação de título sem registro (carteira 7 tipo 4)
							'07'   =>   'C107',   # Liquidação na apresentação
							'09'   =>   'C08',    # Liquidação em cartório
							'10'   =>   'C110',   # Liquidação Parcial com Cheque a Compensar
							'11'   =>   'C111',   # Liquidação por Saldo com Cheque a Compensar

							'00'   =>   'C10',   # Solicitada pelo cliente
							'15'   =>   'C14',   # Protestado
							'18'   =>   'C118',  # Por alteração da carteira
							'19'   =>   'C119',  # Débito automático
							'31'   =>   'C131',  # Liquidado anteriormente
							'32'   =>   'C132',  # Habilitado em processo
							'33'   =>   'C133',  # Incobrável por nosso intermédio
							'34'   =>   'C134',  # Transferido para créditos em liquidação
							'46'   =>   'C46',   # Por alteração da variação
							'47'   =>   'C47',   # Por alteração da variação
							'51'   =>   'C51',   # Acerto
							'90'   =>   'C90',   # Baixa automática
						})
				end

				def codigos_movimento_retorno_para_ocorrencia_D_400
					%w[72]
				end
				def equivalent_codigo_motivo_ocorrencia_D_400 codigo_movimento_gem
					#  Código     Padrão para  
					{# do Banco     a Gem
						'00'    =>    'D00', # Transferência de título de cobrança simples para descontada ou vice-versa
						'52'    =>    'D52', # Reembolso de título vendor ou descontado, quando ocorrerem reembolsos de títulos
						                     # por falta de liquidação. Não há migração de carteira descontada para simples.
					}
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
							'28'   =>   '108',  # Manutenção de Título vencido
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
