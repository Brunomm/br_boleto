module BrBoleto
	module Helper
		module DefaultCodes
			########################################################################################
			##############################  ESPÉCIE DO TÍTULO  #####################################
				# Espécie do Título :
				# Código adotado pela FEBRABAN para identificar o tipo de título de cobrança
				# Códigos padrões da GEM
				#     01 =  CH   –  Cheque
				#     02 =  DM   –  Duplicata Mercantil
				#     03 =  DMI  –  Duplicata Mercantil p/ Indicação
				#     04 =  DS   –  Duplicata de Serviço
				#     05 =  DSI  –  Duplicata de Serviço p/ Indicação
				#     06 =  DR   –  Duplicata Rural
				#     07 =  LC   –  Letra de Câmbio
				#     08 =  NCC  –  Nota de Crédito Comercial
				#     09 =  NCE  –  Nota de Crédito a Exportação
				#     10 =  NCI  –  Nota de Crédito Industrial
				#     11 =  NCR  –  Nota de Crédito Rural
				#     12 =  NP   –  Nota Promissória
				#     13 =  NPR  –  Nota Promissória Rural
				#     14 =  TM   –  Triplicata Mercantil
				#     15 =  TS   –  Triplicata de Serviço
				#     16 =  NS   –  Nota de Seguro
				#     17 =  RC   –  Recibo
				#     18 =  FAT  –  Fatura
				#     19 =  ND   –  Nota de Débito
				#     20 =  AP   –  Apólice de Seguro
				#     21 =  ME   –  Mensalidade Escolar
				#     22 =  PC   –  Parcela de Consórcio
				#     23 =  NF   –  Nota Fiscal
				#     24 =  DD   –  Documento de Dívida
				#     25 =  Cédula de Produto Rural
				#     26 =  Warrant 
				#     27 =  Dívida Ativa de Estado
				#     28 =  Dívida Ativa de Município
				#     29 =  Dívida Ativa da União
				#     30 =  Encargos condominiais
				#     31 =  CC  –  Cartão de Crédito
				#     32 =  BDP –  Boleto de Proposta
				#     99 =  Outros
				#
				def get_especie_titulo(code, cnab)
					send("equivalent_especie_titulo_#{cnab}")[code] || '99'
				end 	
				def equivalent_especie_titulo_240
					{
						'01'  => '01',  # CH   –  Cheque
						'02'  => '02',  # DM   –  Duplicata Mercantil
						'03'  => '03',  # DMI  –  Duplicata Mercantil p/ Indicação
						'04'  => '04',  # DS   –  Duplicata de Serviço
						'05'  => '05',  # DSI  –  Duplicata de Serviço p/ Indicação
						'06'  => '06',  # DR   –  Duplicata Rural
						'07'  => '07',  # LC   –  Letra de Câmbio
						'08'  => '08',  # NCC  –  Nota de Crédito Comercial
						'09'  => '09',  # NCE  –  Nota de Crédito a Exportação
						'10'  => '10',  # NCI  –  Nota de Crédito Industrial
						'11'  => '11',  # NCR  –  Nota de Crédito Rural
						'12'  => '12',  # NP   –  Nota Promissória
						'13'  => '13',  # NPR  –  Nota Promissória Rural
						'14'  => '14',  # TM   –  Triplicata Mercantil
						'15'  => '15',  # TS   –  Triplicata de Serviço
						'16'  => '16',  # NS   –  Nota de Seguro
						'17'  => '17',  # RC   –  Recibo
						'18'  => '18',  # FAT  –  Fatura
						'19'  => '19',  # ND   –  Nota de Débito
						'20'  => '20',  # AP   –  Apólice de Seguro
						'21'  => '21',  # ME   –  Mensalidade Escolar
						'22'  => '22',  # PC   –  Parcela de Consórcio
						'23'  => '23',  # NF   –  Nota Fiscal
						'24'  => '24',  # DD   –  Documento de Dívida
						'25'  => '25',  # Cédula de Produto Rural
						'26'  => '26',  # Warrant 
						'27'  => '27',  # Dívida Ativa de Estado
						'28'  => '28',  # Dívida Ativa de Município
						'29'  => '29',  # Dívida Ativa da União
						'30'  => '30',  # Encargos condominiais
						'31'  => '31',  # CC  –  Cartão de Crédito
						'32'  => '32',  # BDP –  Boleto de Proposta
						'99'  => '99',  # Outros
					}
				end		
				def equivalent_especie_titulo_400
					#  Padrão    Código para  
					{# da GEM     o Banco
						'01'    =>   '10' , #  Cheque
						'02'    =>   '01' , #  Duplicata Mercantil
						'04'    =>   '12' , #  Duplicata de Serviço
						'06'    =>   '06' , #  Duplicata Rural
						'07'    =>   '08' , #  Letra de Câmbio
						'12'    =>   '02' , #  Nota Promissória
						'14'    =>   '14' , #  Triplicata Mercantil
						'15'    =>   '15' , #  Triplicata de Serviço
						'16'    =>   '03' , #  Nota de Seguro
						'17'    =>   '05' , #  Recibo
						'18'    =>   '18' , #  Fatura
						'19'    =>   '13' , #  Nota de Débito
						'20'    =>   '20' , #  Apólice de Seguro
						'21'    =>   '21' , #  Mensalidade Escolar
						'22'    =>   '22' , #  Parcela de Consórcio
						'26'    =>   '09' , #  Warrant
						'99'    =>   '99' , #  Outros"
					}
				end

			########################################################################################
			###########################  CÓDIGO DA MOVIMENTAÇÃO  ###################################
				# Código de Movimento Remessa / Identificacao Ocorrência:
				# Código adotado pela FEBRABAN, para identificar o tipo de movimentação enviado nos registros do arquivo de remessa.
				# Default: 01
				# Códigos padrões da GEM
				#     01 =  Entrada de Títulos
				#     02 =  Pedido de Baixa
				#     03 =  Protesto para Fins Falimentares
				#     04 =  Concessão de Abatimento
				#     05 =  Cancelamento de Abatimento
				#     06 =  Alteração de Vencimento
				#     07 =  Concessão de Desconto
				#     08 =  Cancelamento de Desconto
				#     09 =  Pedido de protesto (Protestar)
				#     10 =  Sustar Protesto e Baixar Título
				#     11 =  Sustar Protesto e Manter em Carteira
				#     12 =  Alteração de Juros de Mora
				#     13 =  Dispensar Cobrança de Juros de Mora
				#     14 =  Alteração de Valor/Percentual de Multa
				#     15 =  Dispensar Cobrança de Multa
				#     16 =  Alteração do Valor de Desconto
				#     17 =  Não conceder Desconto
				#     18 =  Alteração do Valor de Abatimento
				#     19 =  Prazo Limite de Recebimento – Alterar
				#     20 =  Prazo Limite de Recebimento – Dispensar
				#     21 =  Alterar número do título dado pelo beneficiario (nosso número)
				#     22 =  Alterar número controle do Participante (seu número / número documento)
				#     23 =  Alterar dados do Pagador
				#     24 =  Alterar dados do Sacador/Avalista
				#     30 =  Recusa da Alegação do Pagador
				#     31 =  Alteração de Outros Dados
				#     33 =  Alteração dos Dados do Rateio de Crédito
				#     34 =  Pedido de Cancelamento dos Dados do Rateio de Crédito
				#     35 =  Pedido de Desagendamento do Débito Automático
				#     40 =  Alteração de Carteira
				#     41 =  Cancelar protesto
				#     42 =  Alteração de Espécie de Título
				#     43 =  Transferência de carteira/modalidade de cobrança
				#     44 =  Alteração de contrato de cobrança
				#     45 =  Negativação Sem Protesto
				#     46 =  Solicitação de Baixa de Título Negativado Sem Protesto
				#     47 =  Alteração do Valor Nominal do Título
				#     48 =  Alteração do Valor Mínimo/ Percentual
				#     49 =  Alteração do Valor Máximo/Percentua

				def get_codigo_movimento_remessa(code, cnab)
					send("equivalent_codigo_movimento_remessa_#{cnab}")[code] || '31'
				end
				def equivalent_codigo_movimento_remessa_240
					#  Padrão    Código para    Descrição 
					{# da GEM     o Banco
						'01'   =>   '01' ,     # Entrada de Títulos
						'02'   =>   '02' ,     # Pedido de Baixa
						'03'   =>   '03' ,     # Protesto para Fins Falimentares
						'04'   =>   '04' ,     # Concessão de Abatimento
						'05'   =>   '05' ,     # Cancelamento de Abatimento
						'06'   =>   '06' ,     # Alteração de Vencimento
						'07'   =>   '07' ,     # Concessão de Desconto
						'08'   =>   '08' ,     # Cancelamento de Desconto
						'09'   =>   '09' ,     # Pedido de protesto (Protestar)
						'10'   =>   '10' ,     # Sustar Protesto e Baixar Título
						'11'   =>   '11' ,     # Sustar Protesto e Manter em Carteira
						'12'   =>   '12' ,     # Alteração de Juros de Mora
						'13'   =>   '13' ,     # Dispensar Cobrança de Juros de Mora
						'14'   =>   '14' ,     # Alteração de Valor/Percentual de Multa
						'15'   =>   '15' ,     # Dispensar Cobrança de Multa
						'16'   =>   '16' ,     # Alteração do Valor de Desconto
						'17'   =>   '17' ,     # Não conceder Desconto
						'18'   =>   '18' ,     # Alteração do Valor de Abatimento
						'19'   =>   '19' ,     # Prazo Limite de Recebimento – Alterar
						'20'   =>   '20' ,     # Prazo Limite de Recebimento – Dispensar
						'21'   =>   '21' ,     # Alterar número do título dado pelo beneficiario (nosso número)
						'22'   =>   '22' ,     # Alterar número controle do Participante (seu número / número documento)
						'23'   =>   '23' ,     # Alterar dados do Pagador
						'24'   =>   '24' ,     # Alterar dados do Sacador/Avalista
						'30'   =>   '30' ,     # Recusa da Alegação do Pagador
						'31'   =>   '31' ,     # Alteração de Outros Dados
						'33'   =>   '33' ,     # Alteração dos Dados do Rateio de Crédito
						'34'   =>   '34' ,     # Pedido de Cancelamento dos Dados do Rateio de Crédito
						'35'   =>   '35' ,     # Pedido de Desagendamento do Débito Automático
						'40'   =>   '40' ,     # Alteração de Carteira
						'41'   =>   '41' ,     # Cancelar protesto
						'42'   =>   '42' ,     # Alteração de Espécie de Título
						'43'   =>   '43' ,     # Transferência de carteira/modalidade de cobrança
						'44'   =>   '44' ,     # Alteração de contrato de cobrança
						'45'   =>   '45' ,     # Negativação Sem Protesto
						'46'   =>   '46' ,     # Solicitação de Baixa de Título Negativado Sem Protesto
						'47'   =>   '47' ,     # Alteração do Valor Nominal do Título
						'48'   =>   '48' ,     # Alteração do Valor Mínimo/ Percentual
						'49'   =>   '49' ,     # Alteração do Valor Máximo/Percentua
					}
				end
				def equivalent_codigo_movimento_remessa_400
					#  Padrão    Código para    Descrição 
					{# da GEM     o Banco
						'01'   =>   '01' ,     # Registro de títulos / Remessa
						'02'   =>   '02' ,     # Pedido de Baixa
						'03'   =>   '03' ,     # Pedido de Protesto Falimentar 
						'04'   =>   '04' ,     # Concessão de abatimento
						'05'   =>   '05' ,     # Cancelamento de abatimento concedido
						'06'   =>   '06' ,     # Alteração de vencimento
						'09'   =>   '09' ,     # Pedido de protesto (Protestar)
						'21'   =>   '07' ,     # Alterar número do título dado pelo beneficiario (nosso número)
						'22'   =>   '08' ,     # Alterar número controle do Participante (seu número / número documento)
						'31'   =>   '31' ,     # Alteração de outros dados
					}
				end

			########################################################################################
			###############################  CÓDIGO DA CARTEIRA  ###################################
				# Código da Carteira :
				# Default: 1
				# Códigos padrões da GEM
					# 1 = Cobrança Simples
					# 2 = Cobrança Vinculada
					# 3 = Cobrança Caucionada
					# 4 = Cobrança Descontada
					# 5 = Cobrança Vendor
					#
				def get_tipo_cobranca(code, cnab)
					send("equivalent_tipo_cobranca_#{cnab}")[code] || code
				end
				# Código adotado pela FEBRABAN, para identificar a característica dos títulos
	         # dentro das modalidades de cobrança existentes no banco.
				def equivalent_tipo_cobranca_240
					{
						'1' => '1', # Cobrança Simples
						'2' => '2', # Cobrança Vinculada
						'3' => '3', # Cobrança Caucionada
						'4' => '4', # Cobrança Descontada
						'5' => '5', # Cobrança Vendor
					}
				end	
				def equivalent_tipo_cobranca_400
					equivalent_tipo_cobranca_240
				end	

			########################################################################################
			#####################  CÓDIGO DO TIPO DE IMPRESSÃO DO BLOQUETO  ########################
				# Identificação do Tipo de Impressão :
				# Default: 2
				# Códigos padrões da GEM
					# 1 = Frente do Bloqueto
					# 2 = Verso do Bloqueto
					# 3 = Corpo de Instruções da Ficha de Compensação do Bloqueto
					#
				def get_tipo_impressao(code, cnab)
					send("equivalent_tipo_impressao_#{cnab}")[code] || code
				end
				# Código adotado pela FEBRABAN para identificar o responsável e a forma de emissão do  Boleto de Pagamento.
				# Os códigos '4' e '5' só serão aceitos para código de movimento para remessa '31'
				def equivalent_tipo_impressao_240
					{
						'1' => '1', # Frente do Bloqueto
						'2' => '2', # Verso do Bloqueto
						'3' => '3', # Corpo de Instruções da Ficha de Compensação do Bloqueto
					}
				end
				def equivalent_tipo_impressao_400
					equivalent_tipo_impressao_240
				end

			########################################################################################
			#####################  CÓDIGO DA IDENTIFICAÇÃO EMISSÃO DO BOLETO  ######################
				# Identificação da Emissão do Boleto de Pagamento :
				# Default: 2
				# Códigos padrões da GEM
					# 1 = Banco Emite
					# 2 = Cliente Emite
					# 3 = Banco Pré-emite e Cliente Complementa
					# 4 = Banco Reemite
					# 5 = Banco Não Reemite
					# 7 = Banco Emitente - Aberta
					# 8 = Banco Emitente - Auto-envelopável
					#
				def get_identificacao_emissao(code, cnab)
					"#{code}".adjust_size_to(1, '0', :right)
					send("equivalent_identificacao_emissao_#{cnab}")[code] || code
				end
				# Código adotado pela FEBRABAN para identificar o responsável e a forma de emissão do  Boleto de Pagamento.
				# Os códigos '4' e '5' só serão aceitos para código de movimento para remessa '31'
				def equivalent_identificacao_emissao_240
					{
						'1' => '1', # Banco Emite
						'2' => '2', # Cliente Emite
						'3' => '3', # Banco Pré-emite e Cliente Complementa
						'4' => '4', # Banco Reemite
						'5' => '5', # Banco Não Reemite
						'7' => '7', # Banco Emitente - Aberta
						'8' => '8', # Banco Emitente - Auto-envelopável
					}
				end
				def equivalent_identificacao_emissao_400
					equivalent_identificacao_emissao_240
				end

			########################################################################################
			#####################  CÓDIGO IDENTIFICAÇÃO DA DISTRIBUIÇÃO  ###########################
				# Identificação da Distribuição :
				# Default: 2
				# Códigos padrões da GEM
					# 1 = Banco Distribui
					# 2 = Cliente Distribui
					# 3 = Banco envia e-mail
					# 4 = Banco envia SMS
					#
				def get_distribuicao_boleto(code)
					equivalent_distribuicao_boleto[code] || code
				end
				# Código adotado pela FEBRABAN para identificar o responsável pela distribuição do bloqueto.
				def equivalent_distribuicao_boleto
					{
						'1' => '1', # Banco Distribui
						'2' => '2', # Cliente Distribui
						'3' => '3', # Banco envia e-mail
						'4' => '4', # Banco envia SMS
					}
				end

			########################################################################################
			##################################  CÓDIGO JUROS  ######################################
				# Código dos Juros de Mora :
				# O cálculo de juros para cada código funciona da seguinte maneira:
				# Valor  do boleto = R$ 100,00
				# Vencimento = dia 10
				# 1 - Valor por Dia
				#     juros = R$ 1,00
				#     Valor no dia 10 = R$ 100,00 (Sem juros)
				#     Valor no dia 11 = R$ 101,00 (Juros de R$ 1,00)
				#     Valor no dia 12 = R$ 102,00 (Juros de R$ 2,00)
				# 2 = Taxa Mensal
				#     juros = 5,00 %
				#     calculo juros/dia = (R$ 100,00*5%) / 30 dias(1 mês)
				#     juros ao dia = R$ 5,00
				#     Valor no dia 10 = R$ 100,00 (Sem juros)
				#     Valor no dia 11 = R$ 105,00 (Juros de R$ 5,00)
				#     Valor no dia 12 = R$ 110,00 (Juros de R$ 10,00)
				# 
				# Default: 3
				# Códigos padrões da GEM
				#   1 = Valor por Dia (R$/dia)
				#   2 = Taxa Mensal (%/mês)
				#   3 = Isento
				#
				def get_codigo_juros(code)
					equivalent_codigo_juros[code] || default_codigo_juros
				end
				# Código adotado pela FEBRABAN para identificação do tipo de pagamento de juros de mora.
				def equivalent_codigo_juros
					{
						'1' => '1', # Valor por Dia
						'2' => '2', # Taxa Mensal
						'3' => '3', # Isento
					}
				end
				def default_codigo_juros
					'3'
				end

			########################################################################################
			##################################  CÓDIGO MULTA  ######################################
				# Código de Multa :
				# Default: 3
				# Códigos padrões da GEM
					# 1 = Valor fixo
					# 2 = Percentual
					# 3 = Isento
					#
				def get_codigo_multa(code)
					equivalent_codigo_multa[code] || default_codigo_multa
				end
				# Código adotado pela FEBRABAN para identificação do tipo de pagamento de multa.
				def equivalent_codigo_multa
					{
						'1' => '1', # Valor fixo
						'2' => '2', # Percentual
						'3' => '3', # Isento
					}
				end
				def default_codigo_multa
					'3'
				end

			########################################################################################
			################################  CÓDIGO DESCONTO  #####################################
				# Código do Desconto 1 / 2 / 3 :
				# Default: 0
				# Códigos padrões da GEM
					# 0 = Sem Desconto
					# 1 = Valor Fixo Até a Data Informada
					# 2 = Percentual Até a Data Informada
					# 3 = Valor por Antecipação Dia Corrido
					# 4 = Valor por Antecipação Dia Úti
					# 5 = Percentual Sobre o Valor Nominal Dia Corrido
					# 6 = Percentual Sobre o Valor Nominal Dia Útil
					# 7 = Cancelamento de Desconto
					#
				def get_codigo_desconto(code)
					equivalent_codigo_desconto[code] || code
				end
				# Código adotado pela FEBRABAN para identificação do tipo de desconto que deverá ser concedido.
				def equivalent_codigo_desconto
					{
						'0' => '0', # Sem Desconto
						'1' => '1', # Valor Fixo Até a Data Informada
						'2' => '2', # Percentual Até a Data Informada
						'3' => '3', # Valor por Antecipação Dia Corrido
						'4' => '4', # Valor por Antecipação Dia Úti
						'5' => '5', # Percentual Sobre o Valor Nominal Dia Corrido
						'6' => '6', # Percentual Sobre o Valor Nominal Dia Útil
						'7' => '7', # Cancelamento de Desconto
					}
				end

			########################################################################################
			#################################  CÓDIGO PROTESTO  ####################################
				# Código para Protesto :
				# Default: 1
				# Códigos padrões da GEM
					# 1 = Protestar Dias Corridos
					# 2 = Protestar Dias Úteis
					# 3 = Não Protesta
					# 4 = Protestar Fim Falimentar - Dias Úteis
					# 5 = Protestar Fim Falimentar - Dias Corridos
					# 8 = Negativação sem Protesto
					# 9 = Cancelamento Protesto Automático 
					# 99 = Outros
					#
				def get_codigo_protesto(code)
					equivalent_codigo_protesto[code] || code
				end
				# Código adotado pela FEBRABAN para identificar o tipo de prazo a ser considerado para o protesto.
				# O código '9' só sera aceito para código de movimento para remessa '31'
				def equivalent_codigo_protesto
					{
						'1' => '1', # Protestar Dias Corridos
						'2' => '2', # Protestar Dias Úteis
						'3' => '3', # Não Protesta
						'4' => '4', # Protestar Fim Falimentar - Dias Úteis
						'5' => '5', # Protestar Fim Falimentar - Dias Corridos
						'8' => '8', # Negativação sem Protesto
						'9' => '9', # Cancelamento Protesto Automático
						'99' => '99', # Outros
					}
				end

			########################################################################################
			####################################  CÓDIGO MOEDA  ####################################
				# Código da Moeda :
				# Default: 09
				# Códigos padrões da GEM
					# 01 =  Reservado para Uso Futuro
					# 02 =  Dólar Americano Comercial (Venda)
					# 03 =  Dólar Americano Turismo (Venda)
					# 04 =  ITRD
					# 05 =  IDTR
					# 06 =  UFIR Diária
					# 07 =  UFIR Mensal
					# 08 =  FAJ - TR
					# 09 =  Real
					# 10 =  TR
					# 11 =  IGPM
					# 12 =  CDI
					# 13 =  Percentual do CDI
					# 14 =  Euro
					#
				def get_codigo_moeda(code, cnab)
					send("equivalent_codigo_moeda_#{cnab}")[code] || code
				end
				# Código adotado pela FEBRABAN para identificar a moeda referenciada no Título
				def equivalent_codigo_moeda_240
					{
						'01'  => '01', # Reservado para Uso Futuro
						'02'  => '02', # Dólar Americano Comercial (Venda)
						'03'  => '03', # Dólar Americano Turismo (Venda)
						'04'  => '04', # ITRD
						'05'  => '05', # IDTR
						'06'  => '06', # UFIR Diária
						'07'  => '07', # UFIR Mensal
						'08'  => '08', # FAJ - TR
						'09'  => '09', # Real
						'10'  => '10', # TR
						'11'  => '11', # IGPM
						'12'  => '12', # CDI
						'13'  => '13', # Percentual do CDI
						'14'  => '14', # Euro
					}
				end
				def equivalent_codigo_moeda_400
					equivalent_codigo_moeda_240
				end

			########################################################################################
			###########################  CÓDIGO DE MOVIMENTO DE RETORNO  ###########################
				# Código de Movimento Retorno :
				# Códigos padrões da GEM
					# 02 = Entrada Confirmada
					# 03 = Entrada Rejeitada
					# 04 = Transferência de Carteira/Entrada
					# 05 = Transferência de Carteira/Baixa
					# 06 = Liquidação
					# 07 = Confirmação do Recebimento da Instrução de Desconto
					# 08 = Confirmação do Recebimento do Cancelamento do Desconto
					# 09 = Baixa
					# 10 = Baixa Solicitada
					# 11 = Títulos em Carteira (Em Ser)
					# 12 = Confirmação Recebimento Instrução de Abatimento
					# 13 = Confirmação Recebimento Instrução de Cancelamento Abatimento
					# 14 = Confirmação Recebimento Instrução Alteração de Vencimento
					# 15 = Franco de Pagamento
					# 17 = Liquidação Após Baixa ou Liquidação Título Não Registrado
					# 19 = Confirmação Recebimento Instrução de Protesto
					# 20 = Confirmação Recebimento Instrução de Sustação/Cancelamento de Protesto
					# 23 = Remessa a Cartório (Aponte em Cartório) / Entrada do Título em Cartório 
					# 24 = Retirada de Cartório e Manutenção em Carteira
					# 25 = Protestado e Baixado (Baixa por Ter Sido Protestado)
					# 26 = Instrução Rejeitada
					# 27 = Confirmação do Pedido de Alteração de Outros Dados
					# 28 = Débito de Tarifas/Custas
					# 29 = Ocorrências do Pagador
					# 30 = Alteração de Dados Rejeitada
					# 33 = Confirmação da Alteração dos Dados do Rateio de Crédito
					# 34 = Confirmação do Cancelamento dos Dados do Rateio de Crédito
					# 35 = Confirmação do Desagendamento do Débito Automático
					# 36 = Confirmação de envio de e-mail/SMS
					# 37 = Envio de e-mail/SMS rejeitado
					# 38 = Confirmação de alteração do Prazo Limite de Recebimento (a data deve ser informada no campo 28.3.p)
					# 39 = Confirmação de Dispensa de Prazo Limite de Recebimento
					# 40 = Confirmação da alteração do número do título dado pelo Beneficiário
					# 41 = Confirmação da alteração do número controle do Participante
					# 42 = Confirmação da alteração dos dados do Pagador
					# 43 = Confirmação da alteração dos dados do Sacador/Avalista
					# 44 = Título pago com cheque devolvido
					# 45 = Título pago com cheque compensado
					# 46 = Instrução para cancelar protesto confirmada
					# 47 = Instrução para protesto para fins falimentares confirmada
					# 48 = Confirmação de instrução de transferência de carteira/modalidade de cobrança
					# 49 = Alteração de contrato de cobrança
					# 50 = Título pago com cheque pendente de liquidação
					# 51 = Título DDA reconhecido pelo Pagador
					# 52 = Título DDA não reconhecido pelo Pagador
					# 53 = Título DDA recusado pela CIP
					# 54 = Confirmação da Instrução de Baixa de Título Negativado sem Protesto
					# 55 = Confirmação de Pedido de Dispensa de Multa
					# 56 = Confirmação do Pedido de Cobrança de Multa
					# 57 = Confirmação do Pedido de Alteração de Cobrança de Juros
					# 58 = Confirmação do Pedido de Alteração do Valor/Data de Desconto
					# 59 = Confirmação do Pedido de Alteração do Beneficiário do Título
					# 60 = Confirmação do Pedido de Dispensa de Juros de Mora
					# 61 = Confirmação de Alteração do Valor Nominal do Título
					# 63 = Título Sustado Judicialmente
					# 99  = Rejeição do Título – Código rejeição informado nas pos. 80 a 82
					# 100 = Baixa Rejeitada
					# 101 = Liquidação Em Cartório
					# 102 = Liquidação por Conta/Parcial
					# 103 = Liquidação por Saldo
					# 104 = Título não existe
					# 105 = Aceite do pagador
					# 106 = Entrada rejeitada por CEP irregular
					# 107 = Tarifa De Manutenção De Títulos Vencidos
					#
					# BANCO DO BRASIL:
					# 72 = Alteração de tipo de cobrança (específico para títulos das carteiras 11 e 17)
					# 96 = Despesas de Protesto
					# 97 = Despesas de Sustação de Protesto
					# 98 = Débito de Custas Antecipadas
					# 120 = Débito em Conta
					# 121 = Dispensar Indexador
					# 122 = Confirmação de Instrução de Parâmetro de Pagamento Parcial
					#
					# BRADESCO:
					# 16 = Título Pago em Cheque – Vinculado
					# 18 = Acerto de Depositária (sem motivo)
					# 21 = Acerto do Controle do Participante (sem motivo)
					# 22 = Título Com Pagamento Cancelado
					# 73 = Confirmação recebimento pedido de negativação
					# 74 = Confirmação Pedido de Exclusão de Negativação (com ou sem baixa)
					# 170 = Confirmação Receb.Inst.de Protesto Falimentar
					# 171 = Estorno de pagamento
					#
					# CAIXA:
					# 01 = Solicitação de Impressão de Títulos Confirmada
					# 135 = Confirmação de Inclusão Banco de Sacado
					# 136 = Confirmação de Alteração Banco de Sacado
					# 137 = Confirmação de Exclusão Banco de Sacado
					# 138 = Emissão de Bloquetos de Banco de Sacado
					# 139 = Manutenção de Sacado Rejeitada
					# 140 = Entrada de Título via Banco de Sacado Rejeitada
					# 141 = Manutenção de Banco de Sacado Rejeitada
					# 144 = Estorno de Baixa / Liquidação
					# 145 = Alteração de Dados
					# 146 = Uso da Empresa Alterado
					# 147 = Prazo de Devolução Alterado
					# 148 = Alteração com reemissão de Boleto Confirmada
					# 149 = Alteração da opção de Protesto para Devolução Confirmada
					# 150 = Alteração da opção de Devolução para Protesto Confirmada
					# 151 = Baixa por Devolução 
					# 152 = Baixa por Protesto 
					# 153 = Estorno de Protesto 
					# 154 = Estorno de Sustação de Protesto 
					# 155 = Outras Tarifas de Alteração 
					# 156 = Tarifas Diversas 
					#
					# CECRED:
					# 76 = Liquidação de boleto cooperativa emite e expede
					# 77 = Liquidação de boleto após baixa ou não registrado cooperativa emite e expede
					# 91 = Título em aberto não enviado ao pagador
					# 92 = Inconsistência Negativação Serasa
					# 93 = Inclusão Negativação via Serasa
					# 94 = Exclusão Negativação Serasa
					#
					# ITAÚ:
					# 210 = Baixa Por Ter Sido Liquidado
					# 218 = Cobrança Contratual – Instruções/Alterações Rejeitadas/Pendentes
					# 221 = Confirmação Recebimento De Instrução De Não Protestar
					# 225 = Alegações Do Pagador
					# 226 = Tarifa De Aviso De Cobrança
					# 227 = Tarifa De Extrato Posição (B40X)
					# 228 = Tarifa De Relação Das Liquidações
					# 230 = Débito mensal de tarifas (para entradas e baixas)
					# 233 = Custas De Protesto
					# 234 = Custas De Sustação
					# 235 = Custas De Cartório Distribuidor
					# 236 = Custas De Edital
					# 237 = Tarifa De Emissão De Boleto/Tarifa De Envio De Duplicata
					# 238 = Tarifa De Instrução
					# 239 = Tarifa De Ocorrências
					# 240 = Tarifa Mensal De Emissão De Boleto/Tarifa Mensal De Envio De Duplicata
					# 241 = Débito Mensal De Tarifas – Extrato De Posição (B4EP/B4OX)
					# 242 = Débito Mensal De Tarifas – Outras Instruções
					# 243 = Débito Mensal De Tarifas – Manutenção De Títulos Vencidos
					# 244 = Débito Mensal De Tarifas – Outras Ocorrências
					# 245 = Débito Mensal De Tarifas – Protesto
					# 246 = Débito Mensal De Tarifas – Sustação De Protesto
					# 247 = Baixa Com Transferência Para Desconto
					# 248 = Custas De Sustação Judicial
					# 251 = Tarifa Mensal Referente A Entradas Bancos Correspondentes Na Carteira
					# 252 = Tarifa Mensal Baixas Na Carteira
					# 253 = Tarifa Mensal Baixas Em Bancos Correspondentes Na Carteira
					# 254 = Tarifa Mensal De Liquidações Na Carteira
					# 255 = Tarifa Mensal De Liquidações Em Bancos Correspondentes Na Carteira
					# 256 = Custas De Irregularidade
					# 257 = Instrução Cancelada (Nota 20 - Tabela 8)
					# 259 = Baixa por crédito em C/C através do SISPAG
					# 260 = Entrada Rejeitada Carnê
					# 261 = Tarifa Emissão Aviso De Movimentação De Títulos (2154)
					# 262 = Débito Mensal De Tarifa – Aviso De Movimentação De Títulos (2154)
					# 263 = Título Sustado Judicialmente
					# 264 = Entrada Confirmada com Rateio de Crédito
					# 265 = Pagamento com cheque – aguardando compensação
					# 271 = Entrada registrada, aguardando avaliação
					# 272 = Baixa por crédito em c/c através do sispag sem título correspondente
					# 273 = Confirmação de entrada na cobrança simples – entrada não aceita na cobrança contratual
					# 274 = Instrução De Negativação Expressa Rejeitada
					# 275 = Confirma O Recebimento De Instrução De Entrada Em Negativação Expressa
					# 277 = Confirma O Recebimento De Instrução De Exclusão De Entrada Em Negativação Expressa
					# 278 = Confirma O Recebimento De Instrução De Cancelamento Da Negativação Expressa
					# 279 = Negativação Expressa Informacional
					# 280 = Confirmação De Entrada Em Negativação Expressa – Tarifa
					# 282 = Confirmação O Cancelamento De Negativação Expressa - Tarifa
					# 283 = Confirmação Da Exclusão/Cancelamento Da Negativação Expressa Por Liquidação - Tarifa
					# 285 = Tarifa Por Boleto (ATÉ 03 Envios) Cobrança Ativa Eletrônica
					# 286 = Tarifa Email Cobrança Ativa Eletrônica
					# 287 = Tarifa Sms Cobrança Ativa Eletrônica
					# 288 = Tarifa Mensal Por Boleto (ATÉ 03 Envios) Cobrança Ativa Eletrônica
					# 289 = Tarifa Mensal Email Cobrança Ativa Eletrônica
					# 290 = Tarifa Mensal Sms Cobrança Ativa Eletrônica
					# 291 = Tarifa Mensal De Exclusão De Entrada Em Negativação Expressa
					# 292 = Tarifa Mensal De Cancelamento De Negativação Expressa
					# 293 = Tarifa Mensal De Exclusão/Cancelamento De Negativação Expressa Por Liquidação
					# 294 = Confirma Recebimento De Instrução De Não Negativar
					#
					#
				def get_codigo_movimento_retorno(code, cnab)
					send("equivalent_codigo_movimento_retorno_#{cnab}")[code] || code
				end
				# Código adotado pela FEBRABAN, para identificar o tipo de movimentação enviado nos
				# registros do arquivo de retorno.
				def equivalent_codigo_movimento_retorno_400
					equivalent_codigo_movimento_retorno_240
				end
				def equivalent_codigo_movimento_retorno_240
					{
						'01'  => '01',  # Solicitação de Impressão de Títulos Confirmada
						'02'  => '02',  # Entrada Confirmada
						'03'  => '03',  # Entrada Rejeitada
						'04'  => '04',  # Transferência de Carteira/Entrada
						'05'  => '05',  # Transferência de Carteira/Baixa
						'06'  => '06',  # Liquidação
						'07'  => '07',  # Confirmação do Recebimento da Instrução de Desconto
						'08'  => '08',  # Confirmação do Recebimento do Cancelamento do Desconto
						'09'  => '09',  # Baixa
						'10'  => '10',  # Baixa Solicitada
						'11'  => '11',  # Títulos em Carteira (Em Ser)
						'12'  => '12',  # Confirmação Recebimento Instrução de Abatimento
						'13'  => '13',  # Confirmação Recebimento Instrução de Cancelamento Abatimento
						'14'  => '14',  # Confirmação Recebimento Instrução Alteração de Vencimento
						'15'  => '15',  # Franco de Pagamento
						'16'  => '16',  # Título Pago em Cheque – Vinculado
						'17'  => '17',  # Liquidação Após Baixa ou Liquidação Título Não Registrado
						'18'  => '18',  # Acerto de Depositária (sem motivo)
						'19'  => '19',  # Confirmação Recebimento Instrução de Protesto
						'20'  => '20',  # Confirmação Recebimento Instrução de Sustação/Cancelamento de Protesto
						'21'  => '21',  # Acerto do Controle do Participante (sem motivo)
						'22'  => '22',  # Título Com Pagamento Cancelado
						'23'  => '23',  # Remessa a Cartório (Aponte em Cartório)
						'24'  => '24',  # Retirada de Cartório e Manutenção em Carteira
						'25'  => '25',  # Protestado e Baixado (Baixa por Ter Sido Protestado)
						'26'  => '26',  # Instrução Rejeitada
						'27'  => '27',  # Confirmação do Pedido de Alteração de Outros Dados
						'28'  => '28',  # Débito de Tarifas/Custas
						'29'  => '29',  # Ocorrências do Pagador
						'30'  => '30',  # Alteração de Dados Rejeitada
						'33'  => '33',  # Confirmação da Alteração dos Dados do Rateio de Crédito
						'34'  => '34',  # Confirmação do Cancelamento dos Dados do Rateio de Crédito
						'35'  => '35',  # Confirmação do Desagendamento do Débito Automático
						'36'  => '36',  # Confirmação de envio de e-mail/SMS
						'37'  => '37',  # Envio de e-mail/SMS rejeitado
						'38'  => '38',  # Confirmação de alteração do Prazo Limite de Recebimento (a data deve ser informada no campo 28.3.p)
						'39'  => '39',  # Confirmação de Dispensa de Prazo Limite de Recebimento
						'40'  => '40',  # Confirmação da alteração do número do título dado pelo Beneficiário
						'41'  => '41',  # Confirmação da alteração do número controle do Participante
						'42'  => '42',  # Confirmação da alteração dos dados do Pagador
						'43'  => '43',  # Confirmação da alteração dos dados do Sacador/Avalista
						'44'  => '44',  # Título pago com cheque devolvido
						'45'  => '45',  # Título pago com cheque compensado
						'46'  => '46',  # Instrução para cancelar protesto confirmada
						'47'  => '47',  # Instrução para protesto para fins falimentares confirmada
						'48'  => '48',  # Confirmação de instrução de transferência de carteira/modalidade de cobrança
						'49'  => '49',  # Alteração de contrato de cobrança
						'50'  => '50',  # Título pago com cheque pendente de liquidação
						'51'  => '51',  # Título DDA reconhecido pelo Pagador
						'52'  => '52',  # Título DDA não reconhecido pelo Pagador
						'53'  => '53',  # Título DDA recusado pela CIP
						'54'  => '54',  # Confirmação da Instrução de Baixa de Título Negativado sem Protesto
						'55'  => '55',  # Confirmação de Pedido de Dispensa de Multa
						'56'  => '56',  # Confirmação do Pedido de Cobrança de Multa
						'57'  => '57',  # Confirmação do Pedido de Alteração de Cobrança de Juros
						'58'  => '58',  # Confirmação do Pedido de Alteração do Valor/Data de Desconto
						'59'  => '59',  # Confirmação do Pedido de Alteração do Beneficiário do Título
						'60'  => '60',  # Confirmação do Pedido de Dispensa de Juros de Mora
						'61'  => '61',  # Confirmação de Alteração do Valor Nominal do Título
						'63'  => '63',  # Título Sustado Judicialmente
						'72'  => '72',  # Alteração de tipo de cobrança
						'73'  => '73',  # Confirmação recebimento pedido de negativação
						'74'  => '74',  # Confirmação Pedido de Exclusão de Negativação (com ou sem baixa)
						'76'  => '76',  # Liquidação de boleto cooperativa emite e expede
						'77'  => '77',  # Liquidação de boleto após baixa ou não registrado cooperativa emite e expede
						'91'  => '91',  # Título em aberto não enviado ao pagador
						'92'  => '92',  # Inconsistência Negativação Serasa
						'93'  => '93',  # Inclusão Negativação via Serasa
						'94'  => '94',  # Exclusão Negativação Serasa
						'96'  => '96',  # Despesas de Protesto
						'97'  => '97',  # Despesas de Sustação de Protesto
						'98'  => '98',  # Débito de Custas Antecipadas
						'99'  => '99',  # Rejeição do Título
						'100' => '100', # Baixa Rejeitada
						'101' => '101', # Liquidação Em Cartório
						'102' => '102', # Liquidação por Conta/Parcial
						'103' => '103', # Liquidação por Saldo
						'104' => '104', # Título não existe
						'105' => '105', # Aceite do pagador
						'106' => '106', # Entrada rejeitada por CEP irregular
						'107' => '107', # Tarifa De Manutenção De Títulos Vencidos
						'120' => '120', # Débito em Conta
						'121' => '121', # Dispensar Indexador
						'122' => '122', # Confirmação de Instrução de Parâmetro de Pagamento Parcial
						'135' => '135', # Confirmação de Inclusão Banco de Sacado
						'136' => '136', # Confirmação de Alteração Banco de Sacado
						'137' => '137', # Confirmação de Exclusão Banco de Sacado
						'138' => '138', # Emissão de Bloquetos de Banco de Sacado
						'139' => '139', # Manutenção de Sacado Rejeitada
						'140' => '140', # Entrada de Título via Banco de Sacado Rejeitada
						'141' => '141', # Manutenção de Banco de Sacado Rejeitada
						'144' => '144', # Estorno de Baixa / Liquidação
						'145' => '145', # Alteração de Dados
						'146' => '146', # Uso da Empresa Alterado
						'147' => '147', # Prazo de Devolução Alterado
						'148' => '148', # Alteração com reemissão de Boleto Confirmada
						'149' => '149', # Alteração da opção de Protesto para Devolução Confirmada
						'150' => '150', # Alteração da opção de Devolução para Protesto Confirmada
						'151' => '151', # Baixa por Devolução 
						'152' => '152', # Baixa por Protesto 
						'153' => '153', # Estorno de Protesto 
						'154' => '154', # Estorno de Sustação de Protesto 
						'155' => '155', # Outras Tarifas de Alteração 
						'156' => '156', # Tarifas Diversas 
						'170' => '170', # Confirmação Receb.Inst.de Protesto Falimentar
						'171' => '171', # Estorno de pagamento
						'210' => '210', # Baixa Por Ter Sido Liquidado
						'218' => '218', # Cobrança Contratual – Instruções/Alterações Rejeitadas/Pendentes
						'221' => '221', # Confirmação Recebimento De Instrução De Não Protestar
						'225' => '225', # Alegações Do Pagador
						'226' => '226', # Tarifa De Aviso De Cobrança
						'227' => '227', # Tarifa De Extrato Posição (B40X)
						'228' => '228', # Tarifa De Relação Das Liquidações
						'230' => '230', # Débito mensal de tarifas (para entradas e baixas)
						'233' => '233', # Custas De Protesto
						'234' => '234', # Custas De Sustação
						'236' => '236', # Custas De Edital
						'237' => '237', # Tarifa De Emissão De Boleto/Tarifa De Envio De Duplicata
						'238' => '238', # Tarifa De Instrução
						'239' => '239', # Tarifa De Ocorrências
						'240' => '240', # Tarifa Mensal De Emissão De Boleto/Tarifa Mensal De Envio De Duplicata
						'241' => '241', # Débito Mensal De Tarifas – Extrato De Posição (B4EP/B4OX)
						'242' => '242', # Débito Mensal De Tarifas – Outras Instruções
						'243' => '243', # Débito Mensal De Tarifas – Manutenção De Títulos Vencidos
						'244' => '244', # Débito Mensal De Tarifas – Outras Ocorrências
						'245' => '245', # Débito Mensal De Tarifas – Protesto
						'246' => '246', # Débito Mensal De Tarifas – Sustação De Protesto
						'247' => '247', # Baixa Com Transferência Para Desconto
						'248' => '248', # Custas De Sustação Judicial
						'251' => '251', # Tarifa Mensal Referente A Entradas Bancos Correspondentes Na Carteira
						'252' => '252', # Tarifa Mensal Baixas Na Carteira
						'253' => '253', # Tarifa Mensal Baixas Em Bancos Correspondentes Na Carteira
						'254' => '254', # Tarifa Mensal De Liquidações Na Carteira
						'255' => '255', # Tarifa Mensal De Liquidações Em Bancos Correspondentes Na Carteira
						'256' => '256', # Custas De Irregularidade
						'257' => '257', # Instrução Cancelada
						'259' => '259', # Baixa por crédito em C/C através do SISPAG
						'260' => '260', # Entrada Rejeitada Carnê
						'261' => '261', # Tarifa Emissão Aviso De Movimentação De Títulos (2154)
						'262' => '262', # Débito Mensal De Tarifa – Aviso De Movimentação De Títulos (2154)
						'264' => '264', # Entrada Confirmada com Rateio de Crédito
						'265' => '265', # Pagamento com cheque – aguardando compensação
						'271' => '271', # Entrada registrada, aguardando avaliação
						'272' => '272', # Baixa por crédito em c/c através do sispag sem título correspondente
						'273' => '273', # Confirmação de entrada na cobrança simples – entrada não aceita na cobrança contratual
						'274' => '274', # Instrução De Negativação Expressa Rejeitada
						'275' => '275', # Confirma O Recebimento De Instrução De Entrada Em Negativação Expressa
						'277' => '277', # Confirma O Recebimento De Instrução De Exclusão De Entrada Em Negativação Expressa
						'278' => '278', # Confirma O Recebimento De Instrução De Cancelamento Da Negativação Expressa
						'279' => '279', # Negativação Expressa Informacional
						'280' => '280', # Confirmação De Entrada Em Negativação Expressa – Tarifa
						'282' => '282', # Confirmação O Cancelamento De Negativação Expressa - Tarifa
						'283' => '283', # Confirmação Da Exclusão/Cancelamento Da Negativação Expressa Por Liquidação - Tarifa
						'285' => '285', # Tarifa Por Boleto (ATÉ 03 Envios) Cobrança Ativa Eletrônica
						'286' => '286', # Tarifa Email Cobrança Ativa Eletrônica
						'287' => '287', # Tarifa Sms Cobrança Ativa Eletrônica
						'288' => '288', # Tarifa Mensal Por Boleto (ATÉ 03 Envios) Cobrança Ativa Eletrônica
						'289' => '289', # Tarifa Mensal Email Cobrança Ativa Eletrônica
						'290' => '290', # Tarifa Mensal Sms Cobrança Ativa Eletrônica
						'291' => '291', # Tarifa Mensal De Exclusão De Entrada Em Negativação Expressa
						'292' => '292', # Tarifa Mensal De Cancelamento De Negativação Expressa
						'293' => '293', # Tarifa Mensal De Exclusão/Cancelamento De Negativação Expressa Por Liquidação
						'294' => '294', # Confirma Recebimento De Instrução De Não Negativar
					}
				end

			########################################################################################
			###############################  MOTIVO DA OCORRÊNCIA  #################################
				# Código do Motivo da ocorrência :
				# Códigos padrões da GEM
					# A - Códigos de rejeições de '01' a '95' associados aos códigos de movimento '02', '03','26' e '30' 
						# A01 = Código do Banco Inválido
						# A02 = Código do Registro Detalhe Inválido
						# A03 = Código do Segmento Inválido
						# A04 = Código de Movimento Não Permitido para Carteira
						# A05 = Código de Movimento Inválido
						# A06 = Tipo/Número de Inscrição do Beneficiário Inválidos
						# A07 = Agência/Conta/DV Inválido
						# A08 = Nosso Número Inválido
						# A09 = Nosso Número Duplicado
						# A10 = Carteira Inválida
						# A11 = Forma de Cadastramento do Título Inválido
						# A12 = Tipo de Documento Inválido
						# A13 = Identificação da Emissão do Boleto de Pagamento Inválida
						# A14 = Identificação da Distribuição do Boleto de Pagamento Inválida
						# A15 = Características da Cobrança Incompatíveis
						# A16 = Data de Vencimento Inválida
						# A17 = Data de Vencimento Anterior a Data de Emissão
						# A18 = Vencimento Fora do Prazo de Operação
						# A19 = Título a Cargo de Bancos Correspondentes com Vencimento Inferior a XX Dias
						# A20 = Valor do Título Inválido
						# A21 = Espécie do Título Inválida
						# A22 = Espécie do Título Não Permitida para a Carteira
						# A23 = Aceite Inválido
						# A24 = Data da Emissão Inválida
						# A25 = Data da Emissão Posterior a Data de Entrada
						# A26 = Código de Juros de Mora Inválido
						# A27 = Valor/Taxa de Juros de Mora Inválido
						# A28 = Código do Desconto Inválido
						# A29 = Valor do Desconto Maior ou Igual ao Valor do Título
						# A30 = Desconto a Conceder Não Confere
						# A31 = Concessão de Desconto - Já Existe Desconto Anterior
						# A32 = Valor do IOF Inválido
						# A33 = Valor do Abatimento Inválido
						# A34 = Valor do Abatimento Maior ou Igual ao Valor do Título
						# A35 = Valor a Conceder Não Confere
						# A36 = Concessão de Abatimento - Já Existe Abatimento Anterior
						# A37 = Código para Protesto Inválido
						# A38 = Prazo para Protesto Inválido
						# A39 = Pedido de Protesto Não Permitido para o Título
						# A40 = Título com Ordem de Protesto Emitida
						# A41 = Pedido de Cancelamento/Sustação para Títulos sem Instrução de Protesto
						# A42 = Código para Baixa/Devolução Inválido
						# A43 = Prazo para Baixa/Devolução Inválido
						# A44 = Código da Moeda Inválido
						# A45 = Nome do Pagador  Inválido / Não Informado
						# A46 = Tipo/Número de Inscrição do Pagador Inválidos
						# A47 = Endereço do Pagador Não Informado
						# A48 = CEP Inválido
						# A49 = CEP Sem Praça de Cobrança (Não Localizado)
						# A50 = CEP Referente a um Banco Correspondente
						# A51 = CEP incompatível com a Unidade da Federação
						# A52 = Unidade da Federação Inválida
						# A53 = Tipo/Número de Inscrição do Sacador/Avalista Inválidos
						# A54 = Sacador/Avalista Não Informado
						# A55 = Nosso número no Banco Correspondente Não Informado
						# A56 = Código do Banco Correspondente Não Informado
						# A57 = Código da Multa Inválido
						# A58 = Data da Multa Inválida
						# A59 = Valor/Percentual da Multa Inválido
						# A60 = Movimento para Título Não Cadastrado
						# A61 = Alteração da Agência Cobradora/DV Inválida
						# A62 = Tipo de Impressão Inválido
						# A63 = Entrada para Título já Cadastrado
						# A64 = Número da Linha Inválido
						# A65 = Código do Banco para Débito Inválido
						# A66 = Agência/Conta/DV para Débito Inválido
						# A67 = Dados para Débito incompatível com a Identificação da Emissão do Boleto de Pagamento
						# A68 = Débito Automático Agendado
						# A69 = Débito Não Agendado - Erro nos Dados da Remessa
						# A70 = Débito Não Agendado - Pagador Não Consta do Cadastro de Autorizante
						# A71 = Débito Não Agendado - Beneficiário Não Autorizado pelo Pagador
						# A72 = Débito Não Agendado - Beneficiário Não Participa da Modalidade Débito Automático
						# A73 = Débito Não Agendado - Código de Moeda Diferente de Real (R$)
						# A74 = Débito Não Agendado - Data Vencimento Inválida
						# A75 = Débito Não Agendado, Conforme seu Pedido, Título Não Registrado
						# A76 = Débito Não Agendado, Tipo/Num. Inscrição do Debitado, Inválido
						# A77 = Transferência para Desconto Não Permitida para a Carteira do Título
						# A78 = Data Inferior ou Igual ao Vencimento para Débito Automático
						# A79 = Data Juros de Mora Inválido
						# A80 = Data do Desconto Inválida
						# A81 = Tentativas de Débito Esgotadas - Baixado
						# A82 = Tentativas de Débito Esgotadas - Pendente
						# A83 = Limite Excedido
						# A84 = Número Autorização Inexistente
						# A85 = Título com Pagamento Vinculado
						# A86 = Seu Número Inválido
						# A87 = e-mail/SMS enviado
						# A88 = e-mail Lido
						# A89 = e-mail/SMS devolvido - endereço de e-mail ou número do celular incorreto
						# A90 = e-mail devolvido - caixa postal cheia
						# A91 = e-mail/número do celular do Pagador não informado
						# A92 = Pagador optante por Boleto de Pagamento Eletrônico - e-mail não enviado
						# A93 = Código para emissão de Boleto de Pagamento não permite envio de e-mail
						# A94 = Código da Carteira inválido para envio e-mail.
						# A95 = Contrato não permite o envio de e-mail
						# A96 = Número de contrato inválido
						# A97 = Rejeição da alteração do prazo limite de recebimento (a data deve ser informada no campo 28.3.p)
						# A98 = Rejeição de dispensa de prazo limite de recebimento
						# A99 = Rejeição da alteração do número do título dado pelo Beneficiário
						# A100 = Rejeição da alteração do número controle do participante
						# A101 = Rejeição da alteração dos dados do Pagador
						# A102 = Rejeição da alteração dos dados do Sacador/avalista
						# A103 = Pagador DDA
						# A104 = Registro Rejeitado – Título já Liquidado
						# A105 = Código do Convenente Inválido ou Encerrado
						# A106 = Título já se encontra na situação Pretendida
						# A107 = Valor do Abatimento inválido para cancelamento
						# A108 = Não autoriza pagamento parcial
						# A109 = Autoriza recebimento parcial
						# A110 = Valor Nominal do Título Conflitante
						# A111 = Tipo de Pagamento Inválido
						# A112 = Valor Máximo/Percentual Inválido
						# A113 = Valor Mínimo/Percentual Inválido
						# A114 - Enviado Cooperativa Emite e Expede (BANCO CECRED)
						#
						# CAIXA:
						# A115 = Data de Geração Inválida 
						# A116 = Entrada Inválida para Cobrança Caucionada
						# A117 = CEP do Pagador não encontrado
						# A118 = Agencia Cobradora não encontrada
						# A119 = Agencia Beneficiário não encontrada
						# A120 = Movimentação inválida para título
						# A121 = Alteração de dados inválida
						# A122 = Apelido do cliente não cadastrado
						# A123 = Erro na composição do arquivo
						# A124 = Lote de serviço inválido
						# A125 = Beneficiário não pertencente a Cobrança Eletrônica
						# A126 = Nome da Empresa inválido
						# A127 = Nome do Banco inválido
						# A128 = Código da Remessa inválido
						# A129 = Data/Hora Geração do arquivo inválida
						# A130 = Número Sequencial do arquivo inválido
						# A131 = Versão do Lay out do arquivo inválido
						# A132 = Literal REMESSA-TESTE - Válido só p/ fase testes
						# A133 = Literal REMESSA-TESTE - Obrigatório p/ fase testes
						# A134 = Tp Número Inscrição Empresa inválido
						# A135 = Tipo de Operação inválido
						# A136 = Tipo de serviço inválido
						# A137 = Forma de lançamento inválido
						# A138 = Número da remessa inválido
						# A139 = Número da remessa menor/igual remessa anterior
						# A140 = Lote de serviço divergente
						# A141 = Número sequencial do registro inválido
						# A142 = Erro seq de segmento do registro detalhe
						# A143 = Cod movto divergente entre grupo de segm
						# A144 = Qtd registros no lote inválido
						# A145 = Qtd registros no lote divergente
						# A146 = Qtd lotes no arquivo inválido
						# A147 = Qtd lotes no arquivo divergente
						# A148 = Qtd registros no arquivo inválido
						# A149 = Qtd registros no arquivo divergente
						# A150 = Código de DDD inválido
						# A220 = Movimento sem Beneficiário Correspondente
						# A221 = Movimento sem Título Correspondente
						# A222 = Movimento para título já com movimentação no dia
						# A223 = Nosso Número não pertence ao Beneficiário
						# A224 = Inclusão de título já existente na base
						# A225 = Movimento duplicado
						# A226 = Data de Vencimento com prazo superior ao limite
						# A227 = Movimento inválido para título Baixado/Liquidado
						# A228 = Movimento inválido para título enviado a Cartório
						# A229 = Faixa de CEP da Agência Cobradora não abrange CEP do Pagador
						# A230 = Título já com opção de Devolução
						# A231 = Processo de Protesto em andamento
						# A232 = Título já com opção de Protesto
						# A233 = Processo de devolução em andamento
						# A234 = Novo prazo p/ Protesto/Devolução inválido
						# A235 = Alteração do prazo de protesto inválida
						# A236 = Alteração do prazo de devolução inválida
						# A237 = CEP do Pagador inválido
						# A238 = CNPJ/CPF do Pagador inválido (dígito não confere)
						# A239 = Protesto inválido para título sem Número do documento (seu número)
						#
						# Banco do Brasil:
						# A151 = Entrada Por via convencional
						# A152 = Entrada Por alteração do código do cedente
						# A153 = Entrada Por alteração da variação
						# A154 = Entrada Por alteração da carteira
						# A155 = Identificação inválida
						# A156 = Variação da carteira inválida
						# A157 = Espécie de valor invariável inválido
						# A158 = Fora do prazo/só admissível na carteira
						# A159 = Inexistência de margem para desconto
						# A160 = O banco não tem agência na praça do sacado
						# A161 = Razões cadastrais
						# A162 = Sacado interligado com o sacador (só admissível em cobrança simples- cart. 11 e 17)
						# A163 = Título sacado contra órgão do Poder Público (só admissível na carteira 11 e sem ordem de protesto)
						# A164 = Título rasurado
						# A165 = Endereço do sacado não localizado ou incompleto
						# A166 = Qtd de valor variável inválida
						# A167 = Faixa nosso-Número excedida
						# A168 = Nome do sacado/cedente inválido
						# A169 = Data do novo vencimento inválida
						# A170 = Número do borderô inválido
						# A171 = Nome da pessoa autorizada inválido
						# A172 = Número da prestação do contrato inválido
						# A173 = percentual de desconto inválido
						# A174 = Dias para fichamento de protesto inválido
						# A175 = Tipo de moeda inválido
						# A176 = Código de unidade variável incompatível com a data de emissão do título
						# A177 = Dados para débito ao sacado inválidos
						# A178 = Carteira/variação encerrada
						# A179 = Título tem valor diverso do informado
						# A180 = Motivo de baixa inválido para a carteira
						# A181 = Comando incompatível com a carteira
						# A182 = Código do convenente inválido
						# A183 = Título já se encontra na situação pretendida
						# A184 = Título fora do prazo admitido para a conta 1
						# A185 = Novo vencimento fora dos limites da carteira
						# A186 = Título não pertence ao convenente
						# A187 = Variação incompatível com a carteira
						# A188 = Impossível a variação única para a carteira indicada
						# A189 = Título vencido em transferência para a carteira 51
						# A190 = Título com prazo superior a 179 dias em variação única para carteira 51
						# A191 = Título já foi fichado para protesto
						# A192 = Alteração da situação de débito inválida para o código de responsabilidade
						# A193 = DV do nosso número inválido
						# A194 = Título não passível de débito/baixa – situação anormal
						# A195 = Título com ordem de não protestar – não pode ser encaminhado a cartório
						# A196 = Título/carne rejeitado
						# A197 = Título já se encontra isento de juros
						# A198 = Código de Juros Inválido
						# A199 = Prefixo da Ag. cobradora inválido
						# A200 = Número do controle do participante inválido
						# A201 = Cliente não cadastrado no CIOPE (Desconto/Vendor)
						# A202 = Título excluído automaticamente por decurso de prazo CIOPE (Desconto/Vendor)
						# A203 = Título vencido transferido para a conta 1 – Carteira vinculada
						# A204 = Carteira/variação não localizada no cedente
						# A205 = Título não localizado na existência/Baixado por protesto
						# A206 = Recusa do Comando “41” – Parâmetro de Liquidação Parcial.
						# A207 = Por meio magnético
						# A999 = Outros motivos
						#
						# Bradesco:
						# A00 = Ocorrência aceita
						# A208 = Código de ocorrência não numérico
						# A209 = Agência Beneficiário não prevista
						# A210 = E-mail Pagador não lido no prazo 5 dias
						# A211 = Email Pagador não enviado – título com débito automático
						# A212 = Email pagador não enviado – título de cobrança sem registro
						# A213 = E-mail pagador não recebido
						# A214 = Título Penhorado – Instrução Não Liberada pela Agência
						# A215 = Instrução não permitida título negativado
						# A216 = Inclusão Bloqueada face a determinação Judicial
						# A217 = Telefone beneficiário não informado / inconsistente
						# A218 = Cancelado pelo Pagador e Mantido Pendente, conforme negociação
						# A219 = Cancelado pelo pagador e baixado, conforme negociação
						#
						# Itaú:
						# A240 = CEP sem atendimento de protesto no momento
						# A241 = Estado com determinação legal que impede a inscrição de inadimplentes
						# A242 = Valor do título maior que 10.000.000,00
						# A243 = Data de entrada inválida para operar com esta carteira
						# A244 = Ocorrência inválida
						# A245 = Carteira não aceita depositária correspondente estado da agência diferente do estado do pagador ag. cobradora não consta no cadastro ou encerrando
						# A246 = Carteira não permitida (necessário cadastrar faixa livre)
						# A247 = Agência/conta não liberada para operar com cobrança
						# A248 = CNPJ do beneficiário inapto devolução de título em garantia
						# A249 = Categoria da conta inválida
						# A250 = Entradas bloqueadas, conta suspensa em cobrança
						# A251 = Conta não tem permissão para protestar (contate seu gerente)
						# A252 = Qtd de moeda incompatível com valor do título
						# A253 = CNPJ/CPF do Pagador não numérico ou igual a zeros
						# A254 = Empresa não aceita banco correspondente
						# A255 = Empresa não aceita banco correspondente - cobrança mensagem
						# A256 = Banco correspondente - título com vencimento inferior a 15 dias
						# A257 = CEP não pertence à depositária informada
						# A258 = Corresp vencimento superior a 180 dias da data de entrada
						# A259 = CEP só depositária banco do brasil com vencimento inferior a 8 dias
						# A260 = Juros de mora maior que o permitido
						# A261 = Desconto de antecipação, valor da importância por dia de desconto (idd) não permitido
						# A262 = Taxa inválida (vendor)
						# A263 = Carteira inválida para títulos com rateio de crédito
						# A264 = Beneficiário não cadastrado para fazer rateio de crédito
						# A265 = Duplicidade de agência/conta beneficiária do rateio de crédito
						# A266 = Qtd de contas beneficiárias do rateio maior do que o permitido (máximo de 30 contas por título)
						# A267 = Conta para rateio de crédito inválida / não pertence ao itaú
						# A268 = Desconto/abatimento não permitido para títulos com rateio de crédito
						# A269 = Valor do título menor que a soma dos valores estipulados para rateio
						# A270 = Agência/conta beneficiária do rateio é a centralizadora de crédito do beneficiário
						# A271 = Agência/conta do beneficiário é contratual / rateio de crédito não permitido
						# A272 = Código do tipo de valor inválido / não previsto para títulos com rateio de crédito
						# A273 = Registro tipo 4 sem informação de agências/contas beneficiárias do rateio
						# A274 = Cobrança mensagem - número da linha da mensagem inválido ou quantidade de linhas excedidas
						# A275 = Cobrança mensagem sem mensagem (só de campos fixos), porém com registro do tipo 7 ou 8
						# A276 = Registro mensagem sem flash cadastrado ou flash informado diferente do cadastrado
						# A277 = Conta de cobrança com flash cadastrado e sem registro de mensagem correspondente
						# A278 = Instrução/ocorrência não existente
						# A279 = Nosso número igual a zeros
						# A280 = Segunda instrução/ocorrência não existente
						# A281 = Registro em duplicidade
						# A282 = Título não registrado no sistema
						# A283 = Instrução não aceita
						# A284 = Instrução incompatível – existe instrução de protesto para o título
						# A285 = Instrução incompatível – não existe instrução de protesto para o título
						# A286 = Instrução não aceita por já ter sido emitida a ordem de protesto ao cartório
						# A287 = Instrução não aceita por não ter sido emitida a ordem de protesto ao cartório
						# A288 = Já existe uma mesma instrução cadastrada anteriormente para o título
						# A289 = Valor líquido + valor do abatimento diferente do valor do título registrado
						# A290 = Existe uma instrução de não protestar ativa para o título
						# A291 = Existe uma ocorrência do pagador que bloqueia a instrução
						# A292 = Depositária do título = 9999 ou carteira não aceita protesto
						# A293 = Alteração de vencimento igual à registrada no sistema ou que torna o título vencido
						# A294 = Instrução de emissão de aviso de cobrança para título vencido antes do vencimento
						# A295 = Solicitação de cancelamento de instrução inexistente
						# A296 = Título sofrendo alteração de controle (agência/conta/carteira/nosso número)
						# A297 = Instrução não permitida para a carteira
						# A298 = Instrução não permitida para título com rateio de crédito
						# A299 = Instrução incompatível – não existe instrução de negativação expressa para o título
						# A300 = Título com entrada em negativação expressa
						# A301 = Título com negativação expressa concluída
						# A302 = Prazo inválido para negativação expressa – mínimo: 02 dias corridos após o vencimento
						# A303 = Instrução incompatível para o mesmo título nesta data
						# A304 = Confirma recebimento de instrução – pendente de análise
						# A305 = Título com negativação expressa agendada
						# A306 = Valor do título com outra alteração simultânea
						# A307 = Abatimento/alteração do valor do título ou solicitação de baixa bloqueada
						# A308 = Agência cobradora não consta no cadastro de depositária ou em encerramento
						# A309 = Alteração inválida para título vencido
						# A310 = Alteração bloqueada – vencimento já alterado
						# A311 = Instrução com o mesmo conteúdo
						# A312 = Data vencimento para bancos correspondentes inferior ao aceito pelo banco
						# A313 = Alterações iguais para o mesmo controle (agência/conta/carteira/nosso número)
						# A314 = Prazo de vencimento inferior a 15 dias
						# A315 = Valor de iof – alteração não permitida para carteiras de n.s. – moeda variável
						# A316 = Alteração não permitida para carteiras de notas de seguros – moeda variável
						# A317 = Nome inválido do sacador avalista
						# A318 = Endereço inválido – sacador avalista
						# A319 = Bairro inválido – sacador avalista
						# A320 = Cidade inválida – sacador avalista
						# A321 = Sigla estado inválido – sacador avalista
						# A322 = CEP inválido – sacador avalista
						# A323 = Alteração bloqueada – título com negativação expressa / protesto
						# A324 = Alteração bloqueada – título com rateio de crédito
						# A325 = Solicitação de baixa para título já baixado ou liquidado
						# A326 = Solicitação de baixa para título não registrado no sistema
						# A327 = Cobrança prazo curto – solicitação de baixa p/ título não registrado no sistema
						# A328 = Solicitação de baixa para título em floating
						# A329 = Valor do titulo faz parte de garantia de emprestimo
						# A330 = Pago através do SISPAG por crédito em c/c e não baixado
						# A331 = Não aprovada devido ao impacto na elegibilidade de garantias
						# A332 = Automaticamente rejeitada
						#
						# Sicredi:
						# A333 = Título protestado
						# A334 = Aceito
						# A335 = Desprezado
						# A336 = Praça do pagador não cadastrada.
						# A337 = Tipo de cobrança do título divergente com a praça do pagador.
						# A338 = Cooperativa/agência depositária divergente: atualiza o cadastro de praças da Coop./agência beneficiária
						# A339 = Beneficiário não cadastrado ou possui CGC/CIC inválido
						# A340 = Pagador não cadastrado
						# A341 = Ocorrência não pode ser comandada
						# A342 = Recebimento da liquidação fora da rede Sicredi - via compensação eletrônica
						# A343 = Mensagem padrão não cadastrada
						# A344 = Data limite para concessão de desconto inválida
						# A345 = Campo alterado na instrução “31 – alteração de outros dados” inválido
						# A346 = Título ainda não foi confirmado pela centralizadora
						# A347 = Título rejeitado pela centralizadora
						# A348 = Existe mesma instrução pendente de confirmação para este título
						# A349 = Instrução prévia de concessão de abatimento não existe ou não confirmada
						# A350 = Título dentro do prazo de vencimento (em dia)
						# A351 = Espécie de documento não permite protesto de título
						# A352 = Título possui instrução de baixa pendente de confirmação
						# A353 = Qtd de mensagens padrão excede o limite permitido
						# A354 = Qtd inválida no pedido de boletos pré-impressos da cobrança sem registro
						# A355 = Tipo de impressão inválida para cobrança sem registro
						# A356 = Cidade ou Estado do pagador não informado
						# A357 = Seqüência para composição do nosso número do ano atual esgotada
						# A358 = Registro mensagem para título não cadastrado
						# A359 = Registro complementar ao cadastro do título da cobrança com e sem registro não cadastrado
						# A360 = Tipo de postagem inválido, diferente de S, N e branco
						# A361 = Pedido de boletos pré-impressos
						# A362 = Confirmação/rejeição para pedidos de boletos não cadastrado
						# A363 = Pagador/avalista não cadastrado
						# A364 = Informação para atualização do valor do título para protesto inválido
						# A365 = Tipo de impressão inválido, diferente de A, B e branco
						# A366 = Código do pagador do título divergente com o código da cooperativa de crédito
						# A367 = Liquidado no sistema do cliente
						# A368 = Baixado no sistema do cliente
						# A369 = Instrução inválida, este título está caucionado/descontado
						# A370 = Instrução fixa com caracteres inválidos
						# A371 = Nosso número / número da parcela fora de seqüência – total de parcelas inválido
						# A372 = Falta de comprovante de prestação de serviço
						# A373 = Nome do beneficiário incompleto / incorreto.
						# A374 = CNPJ / CPF incompatível com o nome do pagador / Sacador Avalista
						# A375 = CNPJ / CPF do pagador Incompatível com a espécie
						# A376 = Título aceito: sem a assinatura do pagador
						# A377 = Título aceito: rasurado ou rasgado
						# A378 = Título aceito: falta título (cooperativa/ag. beneficiária deverá enviá-lo)
						# A379 = Praça de pagamento incompatível com o endereço
						# A380 = Título aceito: sem endosso ou beneficiário irregular
						# A381 = Título aceito: valor por extenso diferente do valor numérico
						# A382 = Saldo maior que o valor do título
						# A383 = Tipo de endosso inválido
						# A384 = Nome do pagador incompleto / Incorreto
						# A385 = Sustação judicial
						# A386 = Pagador não encontrado
						# A387 = Recebimento de liquidação fora da rede Sicredi – VLB Inferior – Via Compensação
						# A388 = Recebimento de liquidação fora da rede Sicredi – VLB Superior – Via Compensação
						# A389 = Espécie de documento necessita beneficiário ou avalista PJ
						# A390 = Recebimento de liquidação fora da rede Sicredi – Contingência Via Compe
						# A391 = Dados do título não conferem com disquete
						# A392 = Pagador e Sacador Avalista são a mesma pessoa
						# A393 = Aguardar um dia útil após o vencimento para protestar
						# A394 = Data do vencimento rasurada
						# A395 = Vencimento – extenso não confere com número
						# A396 = Falta data de vencimento no título
						# A397 = DM/DMI sem comprovante autenticado ou declaração
						# A398 = Comprovante ilegível para conferência e microfilmagem
						# A399 = Nome solicitado não confere com emitente ou pagador
						# A400 = Confirmar se são 2 emitentes. Se sim, indicar os dados dos 2
						# A401 = Endereço do pagador igual ao do pagador ou do portador
						# A402 = Endereço do apresentante incompleto ou não informado
						# A403 = Rua/número inexistente no endereço
						# A404 = Falta endosso do favorecido para o apresentante
						# A405 = Data da emissão rasurada
						# A406 = Falta assinatura do pagador no título
						# A407 = Nome do apresentante não informado/incompleto/incorreto
						# A408 = Erro de preenchimento do titulo
						# A409 = Titulo com direito de regresso vencido
						# A410 = Titulo apresentado em duplicidade
						# A411 = Titulo já protestado
						# A412 = Letra de cambio vencida – falta aceite do pagador
						# A413 = Falta declaração de saldo assinada no título
						# A414 = Contrato de cambio – Falta conta gráfica
						# A415 = Ausência do documento físico
						# A416 = Pagador falecido
						# A417 = Pagador apresentou quitação do título
						# A418 = Título de outra jurisdição territorial
						# A419 = Título com emissão anterior a concordata do pagador
						# A420 = Pagador consta na lista de falência
						# A421 = Apresentante não aceita publicação de edital
						# A422 = Dados do Pagador em Branco ou inválido
						# A423 = Código do Pagador na agência beneficiária está duplicado
						# A424 = Reconhecimento da dívida pelo pagador
						# A425 = Não reconhecimento da dívida pelo pagador
						# A426 = Regularização centralizadora – Rede Sicredi
						# A427 = Regularização centralizadora – Compensação
						# A428 = Regularização centralizadora – Banco correspondente
						# A429 = Regularização centralizadora - VLB Inferior - via compensação
						# A430 = Regularização centralizadora - VLB Superior - via compensação
						# A431 = Pago com cheque
						# A432 = Pago com cheque – bloqueado 24 horas
						# A433 = Pago com cheque – bloqueado 48 horas
						# A434 = Pago com cheque – bloqueado 72 horas
						# A435 = Pago com cheque – bloqueado 96 horas
						# A436 = Pago com cheque – bloqueado 120 horas
						# A437 = Pago com cheque – bloqueado 144 horas
						#
						# Santander:
						# A438 = Conta cobranca não numérica
						# A439 = Unidade de valor inválida
						# A440 = Valor do titulo em outra unidade
						# A441 = Valor do IOC não numérico
						# A442 = Total parcela não numérico
						# A443 = Codigo banco cobrador inválido
						# A444 = Número parcelas carne não numérico
						# A445 = Número parcelas carne zerado
						# A446 = Movimento excluido por solicitacao
						# A447 = Agência cobradora não encontrada
						# A448 = Não baixar, compl. informado inválido
						# A449 = Não protestar, compl. informado inválido
						# A450 = Qtd de dias de baixa não preenchido
						# A451 = Qtd de dias protesto não preenchido
						# A452 = Tot parc. inf. não bate cl otd parc ger
						# A453 = Carne com parcelas com erro
						# A454 = Número do titulo igual a zero
						# A455 = Titulo não encontrado
						# A456 = Titulo com ordem de protesto já emitida
						# A457 = Ocorrência não acatada, titulo já protestado
						# A458 = Ocorrência não acatada, titulo não vencido
						# A459 = Instrucao aceita so p/ cobranca simples
						# A460 = Especie documento não protestavel
						# A461 = Cedente sem carta de protesto
						# A462 = Sacado não protestavel
						# A463 = Tipo de cobranca não permite protesto
						# A464 = Pedido sustacao já solicitado
						# A465 = Sustacao protesto fora de prazo
						# A466 = Cliente não transmite reg. de ocorrencia
						# A467 = Tipo de vencimento inválido
						# A468 = Produto diferente de cobranca simples
						# A469 = Data prorrogação menor oue data vencimento
						# A470 = Data antecipação maior oue data vencimento
						# A471 = Data documento superior a data instrucao
						# A472 = Desc. por antec. maior/igual vlr titulo
						# A473 = Não existe abatimento p/ cancelar
						# A474 = Não existe prim. desconto p/ cancelar
						# A475 = Não existe seg. desconto p/ cancelar
						# A476 = Não existe terc. desconto p/ cancelar
						# A477 = Não existe desc. por antec. p/ cancelar
						# A478 = Não existe multa por atraso p/ cancelar
						# A479 = Já existe segundo desconto
						# A480 = Já existe terceiro desconto
						# A481 = Data instrucao inválida
						# A482 = Data multa menor/igual oue vencimento
						# A483 = Já existe desconto por dia antecipacao
						# A484 = Valor titulo em outra moeda não informado
						# A485 = Perfil não aceita valor titulo zerado
						# A486 = Especie docto não permite protesto
						# A487 = Especie docto não permite IOC zerado
						# A488 = Registro duplicado no movimento diario
						# A489 = Nome do sacado não informado
						# A490 = Endereço do sacado não informado
						# A491 = Municipio do sacado não informado
						# A492 = Tipo inscrição não existe
						# A493 = Valor mora tem oue ser zero (titulo = zero)
						# A494 = Data multa maior oue data de vencimento
						# A495 = Complemento da instrucao não numérico
						# A496 = Codigo p. baixa/ devol. inválido
						# A497 = Codigo banco na compensação não numérico
						# A498 = Codigo banco na compensação inválido
						# A499 = Num. lote remessa(detalhe) não numérico
						# A500 = Num. seo. reg. do lote não numérico
						# A501 = Codigo p. protesto não numérico
						# A502 = Qtd de dias p. protesto inválido
						# A503 = Qtd dias baixa/dev. inválido p. cod. 1
						# A504 = Qtd dias baixa/dev. inválido p.cod. 2
						# A505 = Qtd dias baixa/dev.inválido p.cod. 3
						# A506 = Indicador de carne não numérico
						# A507 = Num. total de parc.carne não numérico
						# A508 = Número do plano não numérico
						# A509 = Indicador de parcelas carne inválido
						# A510 = N.seo. parcela inv.p.indic. maior 0
						# A511 = N. seo.parcela inv.p.indic.dif.zeros
						# A512 = N.tot.parc.inv.p.indic. maior zeros
						# A513 = Num.tot.parc.inv.p.indic.difer.zeros
						# A514 = Alt.do contr.participanteinválido
						# A515 = Alt. do seu Número inválida
						# A516 = Banco compensação inválido (d30)
						# A517 = Num. do lote remessa não numérico(d30)
						# A518 = Num.seo.reg.no lote(d30)
						# A519 = Tipo insc.sacado inválido (d30)
						# A520 = Num.insc.sac.inv.p.tipo insc.o e 9(d30)
						# A521 = Num.banco compensação inválido (d3r)
						# A522 = Num. lote remessa não numérico (d3r)
						# A523 = Num. seo. reg. lote não numérico (d3r)
						# A524 = Data desc3 não numérica (d3r)
						# A525 = Cod.banco compensação não numérico (d3s)
						# A526 = Cod. banco compensação inválido (d3s)
						# A527 = Num.lote remessa não numérico (d3s)
						# A528 = Num.seo.do reg.lote não numérico (d3s)
						# A529 = Num.ident.de impressao inválido (d3s)
						# A530 = Num.linha impressa não numérico(d3s)
						# A531 = Cod.msg.p.rec.sacado inválido(d3s)
						# A532 = Cad.txperm.sk.inv.p.cod.mora=4(d3p)
						# A533 = Vl.tit(real).inv.p.cod.mora= 1(dep)
						# A534 = Vl.outros inv.p.cod.mora = 1(d3p)
						# A535 = Cad.tx.perm.sk.inv.p.cod.mora=3(d3p)
						# A536 = Titulo com mais de 3 instrucoes financeiras
						# A537 = Código de cedente não cadastrado
						# A538 = Titulo sem ordem de protesto automatica
						# A539 = Data de juros de tolerancia inválido
						# A540 = Data de tolerancia menor data vencimento
						# A541 = Perc. de juros de tolerancia inválido
						# A542 = Titulo rejeitado - operação de desconto
						# A543 = Titulo rejeitado - horário limite op desconto

					# B - Códigos de tarifas / custas de '01' a '20' associados ao código de movimento '28'
						# B01 = Tarifa de Extrato de Posição
						# B02 = Tarifa de Manutenção de Título Vencido
						# B03 = Tarifa de Sustação
						# B04 = Tarifa de Protesto
						# B05 = Tarifa de Outras Instruções
						# B06 = Tarifa de Outras Ocorrências
						# B07 = Tarifa de Envio de Duplicata ao Pagador
						# B08 = Custas de Protesto
						# B09 = Custas de Sustação de Protesto
						# B10 = Custas de Cartório Distribuidor
						# B11 = Custas de Edital
						# B12 = Tarifa Sobre Devolução de Título Vencido
						# B13 = Tarifa Sobre Registro Cobrada na Baixa/Liquidação
						# B14 = Tarifa Sobre Reapresentação Automática
						# B15 = Tarifa Sobre Rateio de Crédito
						# B16 = Tarifa Sobre Informações Via Fax
						# B17 = Tarifa Sobre Prorrogação de Vencimento
						# B18 = Tarifa Sobre Alteração de Abatimento/Desconto
						# B19 = Tarifa Sobre Arquivo mensal (Em Ser)
						# B20 = Tarifa Sobre Emissão de Boleto de Pagamento Pré-Emitido pelo Banco
						#
						# CAIXA:
						# B21 = Redisponibilização de Arquivo Retorno Eletrônico
						# B22 = Banco de Pagadores
						# B23 = Entrega Aviso Disp Boleto via e-amail ao pagador (s/ emissão Boleto)
						# B24 = Emissão de Boleto Pré-impresso CAIXA matricial
						# B25 = Emissão de Boleto Pré-impresso CAIXA A4
						# B26 = Emissão de Boleto Padrão CAIXA
						# B27 = Emissão de Boleto/Carnê
						# B28 = Emissão de Aviso de Vencido
						# B29 = Alteração cadastral de dados do título - sem emissão de aviso
						# B30 = Emissão de 2a via de Boleto Cobrança Registrada
						#
						# Bradesco:
						# B31 = Tarifa de permanência título cadastrado
						# B32 = Tarifa de registro
						# B33 = Tarifa título pago no Bradesco
						# B34 = Tarifa título pago compensação
						# B35 = Tarifa título baixado não pago
						# B36 = Tarifa alteração de vencimento
						# B37 = Tarifa concessão abatimento
						# B38 = Tarifa cancelamento de abatimento
						# B39 = Tarifa concessão desconto
						# B40 = Tarifa cancelamento desconto
						# B41 = Tarifa título pago cics
						# B42 = Tarifa título pago Internet
						# B43 = Tarifa título pago term. gerencial serviços
						# B44 = Tarifa título pago Pág-Contas
						# B45 = Tarifa título pago Fone Fácil
						# B46 = Tarifa título Déb. Postagem
						# B47 = Tarifa impressão de títulos pendentes
						# B48 = Tarifa título pago BDN
						# B49 = Tarifa título pago Term. Multi Função
						# B50 = Impressão de títulos baixados
						# B51 = Impressão de títulos pagos
						# B52 = Tarifa título pago Pagfor
						# B53 = Tarifa reg/pgto – guichê caixa
						# B54 = Tarifa título pago retaguarda
						# B55 = Tarifa título pago Subcentro
						# B56 = Tarifa título pago Cartão de Crédito
						# B57 = Tarifa título pago Comp Eletrônica
						# B58 = Tarifa título Baix. Pg. Cartório
						# B59 = Tarifa título baixado acerto banco
						# B60 = Baixa registro em duplicidade
						# B61 = Tarifa título baixado decurso prazo
						# B62 = Tarifa título baixado Judicialmente
						# B63 = Tarifa título baixado via remessa
						# B64 = Tarifa título baixado rastreamento
						# B65 = Tarifa título baixado conf. Pedido
						# B66 = Tarifa título baixado protestado
						# B67 = Tarifa título baixado p/ devolução
						# B68 = Tarifa título baixado franco pagto
						# B69 = Tarifa título baixado SUST/RET/CARTÓRIO
						# B70 = Tarifa título baixado SUS/SEM/REM/CARTÓRIO
						# B71 = Tarifa título transferido desconto
						# B72 = Cobrado baixa manual
						# B73 = Baixa por acerto cliente
						# B74 = Tarifa baixa por contabilidade
						# B75 = Tr. tentativa cons deb aut
						# B76 = Tr. credito online
						# B77 = Tarifa reg/pagto Bradesco Expresso
						# B78 = Tarifa emissão Papeleta
						# B79 = Tarifa fornec papeleta semi preenchida
						# B80 = Acondicionador de papeletas (RPB)S
						# B81 = Acond. De papelatas (RPB)s PERSONAL
						# B82 = Papeleta formulário branco
						# B83 = Formulário A4 serrilhado
						# B84 = Fornecimento de softwares transmiss
						# B85 = Fornecimento de softwares consulta
						# B86 = Fornecimento Micro Completo
						# B87 = Fornecimento MODEN
						# B88 = Fornecimento de máquinas óticas
						# B89 = Fornecimento de Impressoras
						# B90 = Reativação de título
						# B91 = Alteração de produto negociado
						# B92 = Tarifa emissão de contra recibo
						# B93 = Tarifa emissão 2a via papeleta
						# B94 = Tarifa regravação arquivo retorno
						# B95 = Arq. Títulos a vencer mensal
						# B96 = Listagem auxiliar de crédito
						# B97 = Tarifa cadastro cartela instrução permanente
						# B98 = Canalização de Crédito
						# B99 = Cadastro de Mensagem Fixa
						# B100 = Tarifa registro título déb. Automático
						# B101 = Emissão papeleta sem valor
						# B102 = Sem uso
						# B103 = Cadastro de reembolso de diferença
						# B104 = Relatório fluxo de pagto
						# B105 = Emissão Extrato mov. Carteira
						# B106 = Mensagem campo local de pagto
						# B107 = Cadastro Concessionária serv. Publ.
						# B108 = Classif. Extrato Conta Corrente
						# B109 = Contabilidade especial
						# B110 = Realimentação pagto
						# B111 = Repasse de Créditos
						# B112 = Tarifa reg. Pagto outras mídias
						# B113 = Tarifa Reg/Pagto – Net Empresa
						# B114 = Tarifa título pago vencido
						# B115 = TR Tít. Baixado por decurso prazo
						# B116 = Arquivo Retorno Antecipado
						# B117 = Arq retorno Hora/Hora
						# B118 = TR. Agendamento Déb Aut
						# B119 = TR. Agendamento rat. Crédito
						# B120 = TR Emissão aviso rateio
						# B121 = Extrato de protesto
						#
						# Sicredi:
						# B122 = Tarifa de baixa da carteira
						# B123 = Tarifa de registro de entrada do título
						# B124 = Tarifa de entrada na rede Sicredi

					# C - Códigos de liquidação / baixa de '01' a '15' associados aos códigos de movimento '06', '09' e '17'
						# Liquidação:
							# C01 = Por Saldo
							# C02 = Por Conta
							# C03 = Liquidação no Guichê de Caixa em Dinheiro
							# C04 = Compensação Eletrônica
							# C05 = Compensação Convencional
							# C06 = Por Meio Eletrônico
							# C07 = Após Feriado Local
							# C08 = Em Cartório
							# C30 = Liquidação no Guichê de Caixa em Cheque
							# C31 = Liquidação em banco correspondente
							# C32 = Liquidação Terminal de Auto-Atendimento
							# C33 = Liquidação na Internet (Home banking)
							# C34 = Liquidado Office Banking
							# C35 = Liquidado Correspondente em Dinheiro
							# C36 = Liquidado Correspondente em Cheque
							# C37 = Liquidado por meio de Central de Atendimento (Telefone)
							#
							# CAIXA:
							# C100 = Casa Lotérica
							# C101 = Agências CAIXA
							# C102 = Correspondente Bancário
							#
							# Banco do Brasil:
							# C103 = Liquidação normal
							# C104 = Liquidação parcial
							# C105 = Liquidação com cheque a compensar
							# C106 = Liquidação de título sem registro (carteira 7 tipo 4)
							# C107 = Liquidação na apresentação
							# C110 = Liquidação Parcial com Cheque a Compensar
							# C111 = Liquidação por Saldo com Cheque a Compensar
							#
							# Bradesco:
							# C42 = Rateio não efetuado, cód. Calculo 2 (VLR. Registro) 
							#
							# Itaú:
							# C135  = Acerto online
							# C136  = Outros bancos – recebimento off-line
							# C137  = Outros bancos – pelo código de barras
							# C138  = Outros bancos – pela linha digitável
							# C139  = Outros bancos – pelo auto atendimento
							# C140  = Outros bancos – recebimento em casa lotérica
							# C141  = Outros bancos – correspondente
							# C142  = Outros bancos – telefone
							# C143  = Outros bancos – arquivo eletrônico (pagamento efetuado por meio de troca de arquivos)
							# C144  = Correspondente Itaú
							# C145  = SISPAG – sistema de contas a pagar itaú
							# C146  = Agência itaú – por débito em conta corrente, cheque itaú* ou dinheiro
							# C147  = Agência itaú – capturado em off-line
							# C148  = Pagamento em cartório de protesto com cheque
							# C149  = Agendamento – pagamento agendado via bankline ou outro canal eletrônico e liquidado na data indicada
							# C150  = Digitação – realimentação automática
							# C151  = Pagamento via seltec
						# Baixa:
							# C09 = Comandada Banco
							# C10 = Comandada Cliente Arquivo
							# C11 = Comandada Cliente On-line
							# C12 = Decurso Prazo - Cliente
							# C13 = Decurso Prazo - Banco
							# C14 = Protestado
							# C15 = Título Excluído
							#
							# Banco do Brasil:
							# C46  = Por alteração da variação
							# C47  = Por alteração da variação
							# C51  = Acerto
							# C90  = Baixa automática
							# C118 = Por alteração da carteira
							# C119 = Débito automático
							# C131 = Liquidado anteriormente
							# C132 = Habilitado em processo
							# C133 = Incobrável por nosso intermédio
							# C134 = Transferido para créditos em liquidação
							#
							# Bradesco:
							# C00 = Baixado Conforme Instruções da Agência
							# C16 = Título Baixado pelo Banco por decurso Prazo
							# C17 = Titulo Baixado Transferido Carteira
							# C20 = Titulo Baixado e Transferido para Desconto

					# D - Códigos de confirmação associado ao código de movimento (Exclusivo por banco)
						# SICREDI (código de movimento '27'): 
						# D01 = Alteração de carteira
						#
						# CECRED (código de movimento '93' e '94'):
						# D02 = Sempre que a solicitação (inclusão ou exclusão) for efetuada com sucesso
						# D03 = Sempre que a solicitação for integrada na Serasa com sucesso
						# D04 = Sempre que vier retorno da Serasa por decurso de prazo
						# D05 = Sempre que o documento for integrado na Serasa com sucesso, quando o UF for de São Paulo
						# D06 = Sempre quando houver ação judicial, restringindo a negativação do boleto.
						#
						# Bradesco (código de movimento '29'): 
						# D78 = Pagador alega que faturamento e indevido
						# D95 = Pagador aceita/reconhece o faturamento


				def get_codigo_motivo_ocorrencia(code, codigo_movimento_gem, cnab)
					return if code.blank? || codigo_movimento_gem.blank?

					if codigo_movimento_gem.in? send("codigos_movimento_retorno_para_ocorrencia_A_#{cnab}")
						send("equivalent_codigo_motivo_ocorrencia_A_#{cnab}", codigo_movimento_gem) [code] || 'OUTRO_A'
					elsif codigo_movimento_gem.in? send("codigos_movimento_retorno_para_ocorrencia_B_#{cnab}")
						send("equivalent_codigo_motivo_ocorrencia_B_#{cnab}", codigo_movimento_gem)[code] || 'OUTRO_B'
					elsif codigo_movimento_gem.in? send("codigos_movimento_retorno_para_ocorrencia_C_#{cnab}")
						send("equivalent_codigo_motivo_ocorrencia_C_#{cnab}", codigo_movimento_gem)[code] || 'OUTRO_C'
					elsif codigo_movimento_gem.in? send("codigos_movimento_retorno_para_ocorrencia_D_#{cnab}")
						send("equivalent_codigo_motivo_ocorrencia_D_#{cnab}", codigo_movimento_gem)[code] || 'OUTRO_D'
					else
						'OUTRO_X'
					end
				end

				def codigos_movimento_retorno_para_ocorrencia_A_240
					%w[02 03 26 30]
				end
				def codigos_movimento_retorno_para_ocorrencia_B_240
					%w[28]
				end
				def codigos_movimento_retorno_para_ocorrencia_C_240
					%w[06 09 17]
				end
				def codigos_movimento_retorno_para_ocorrencia_D_240
					# Exclusivo por banco
				end

				def codigos_movimento_retorno_para_ocorrencia_A_400
					codigos_movimento_retorno_para_ocorrencia_A_240
				end
				def codigos_movimento_retorno_para_ocorrencia_B_400
					codigos_movimento_retorno_para_ocorrencia_B_240
				end
				def codigos_movimento_retorno_para_ocorrencia_C_400
					codigos_movimento_retorno_para_ocorrencia_C_240
				end
				def codigos_movimento_retorno_para_ocorrencia_D_400
					codigos_movimento_retorno_para_ocorrencia_D_240
				end

				# Códigos adotados pela FEBRABAN para identificar as ocorrências (rejeições, tarifas,
				# custas, liquidação e baixas) em registros detalhe de títulos de cobrança.
				def equivalent_codigo_motivo_ocorrencia_A_240 codigo_movimento_gem
					#  Código     Padrão para  
					{# do Banco     a Gem
						'A00'   =>   'A00',   # Ocorrência aceita
						'01'    =>   'A01' ,  # Código do Banco Inválido
						'02'    =>   'A02' ,  # Código do Registro Detalhe Inválido
						'03'    =>   'A03' ,  # Código do Segmento Inválido
						'04'    =>   'A04' ,  # Código de Movimento Não Permitido para Carteira
						'05'    =>   'A05' ,  # Código de Movimento Inválido
						'06'    =>   'A06' ,  # Tipo/Número de Inscrição do Beneficiário Inválidos
						'07'    =>   'A07' ,  # Agência/Conta/DV Inválido
						'08'    =>   'A08' ,  # Nosso Número Inválido
						'09'    =>   'A09' ,  # Nosso Número Duplicado
						'10'    =>   'A10' ,  # Carteira Inválida
						'11'    =>   'A11' ,  # Forma de Cadastramento do Título Inválido
						'12'    =>   'A12' ,  # Tipo de Documento Inválido
						'13'    =>   'A13' ,  # Identificação da Emissão do Boleto de Pagamento Inválida
						'14'    =>   'A14' ,  # Identificação da Distribuição do Boleto de Pagamento Inválida
						'15'    =>   'A15' ,  # Características da Cobrança Incompatíveis
						'16'    =>   'A16' ,  # Data de Vencimento Inválida
						'17'    =>   'A17' ,  # Data de Vencimento Anterior a Data de Emissão
						'18'    =>   'A18' ,  # Vencimento Fora do Prazo de Operação
						'19'    =>   'A19' ,  # Título a Cargo de Bancos Correspondentes com Vencimento Inferior a XX Dias
						'20'    =>   'A20' ,  # Valor do Título Inválido
						'21'    =>   'A21' ,  # Espécie do Título Inválida
						'22'    =>   'A22' ,  # Espécie do Título Não Permitida para a Carteira
						'23'    =>   'A23' ,  # Aceite Inválido
						'24'    =>   'A24' ,  # Data da Emissão Inválida
						'25'    =>   'A25' ,  # Data da Emissão Posterior a Data de Entrada
						'26'    =>   'A26' ,  # Código de Juros de Mora Inválido
						'27'    =>   'A27' ,  # Valor/Taxa de Juros de Mora Inválido
						'28'    =>   'A28' ,  # Código do Desconto Inválido
						'29'    =>   'A29' ,  # Valor do Desconto Maior ou Igual ao Valor do Título
						'30'    =>   'A30' ,  # Desconto a Conceder Não Confere
						'31'    =>   'A31' ,  # Concessão de Desconto - Já Existe Desconto Anterior
						'32'    =>   'A32' ,  # Valor do IOF Inválido
						'33'    =>   'A33' ,  # Valor do Abatimento Inválido
						'34'    =>   'A34' ,  # Valor do Abatimento Maior ou Igual ao Valor do Título
						'35'    =>   'A35' ,  # Valor a Conceder Não Confere
						'36'    =>   'A36' ,  # Concessão de Abatimento - Já Existe Abatimento Anterior
						'37'    =>   'A37' ,  # Código para Protesto Inválido
						'38'    =>   'A38' ,  # Prazo para Protesto Inválido
						'39'    =>   'A39' ,  # Pedido de Protesto Não Permitido para o Título
						'40'    =>   'A40' ,  # Título com Ordem de Protesto Emitida
						'41'    =>   'A41' ,  # Pedido de Cancelamento/Sustação para Títulos sem Instrução de Protesto
						'42'    =>   'A42' ,  # Código para Baixa/Devolução Inválido
						'43'    =>   'A43' ,  # Prazo para Baixa/Devolução Inválido
						'44'    =>   'A44' ,  # Código da Moeda Inválido
						'45'    =>   'A45' ,  # Nome do Pagador Inválido / Não Informado
						'46'    =>   'A46' ,  # Tipo/Número de Inscrição do Pagador Inválidos
						'47'    =>   'A47' ,  # Endereço do Pagador Não Informado
						'48'    =>   'A48' ,  # CEP Inválido
						'49'    =>   'A49' ,  # CEP Sem Praça de Cobrança (Não Localizado)
						'50'    =>   'A50' ,  # CEP Referente a um Banco Correspondente
						'51'    =>   'A51' ,  # CEP incompatível com a Unidade da Federação
						'52'    =>   'A52' ,  # Unidade da Federação Inválida
						'53'    =>   'A53' ,  # Tipo/Número de Inscrição do Sacador/Avalista Inválidos
						'54'    =>   'A54' ,  # Sacador/Avalista Não Informado
						'55'    =>   'A55' ,  # Nosso número no Banco Correspondente Não Informado
						'56'    =>   'A56' ,  # Código do Banco Correspondente Não Informado
						'57'    =>   'A57' ,  # Código da Multa Inválido
						'58'    =>   'A58' ,  # Data da Multa Inválida
						'59'    =>   'A59' ,  # Valor/Percentual da Multa Inválido
						'60'    =>   'A60' ,  # Movimento para Título Não Cadastrado
						'61'    =>   'A61' ,  # Alteração da Agência Cobradora/DV Inválida
						'62'    =>   'A62' ,  # Tipo de Impressão Inválido
						'63'    =>   'A63' ,  # Entrada para Título já Cadastrado
						'64'    =>   'A64' ,  # Número da Linha Inválido
						'65'    =>   'A65' ,  # Código do Banco para Débito Inválido
						'66'    =>   'A66' ,  # Agência/Conta/DV para Débito Inválido
						'67'    =>   'A67' ,  # Dados para Débito incompatível com a Identificação da Emissão do Boleto de Pagamento
						'68'    =>   'A68' ,  # Débito Automático Agendado
						'69'    =>   'A69' ,  # Débito Não Agendado - Erro nos Dados da Remessa
						'70'    =>   'A70' ,  # Débito Não Agendado - Pagador Não Consta do Cadastro de Autorizante
						'71'    =>   'A71' ,  # Débito Não Agendado - Beneficiário Não Autorizado pelo Pagador
						'72'    =>   'A72' ,  # Débito Não Agendado - Beneficiário Não Participa da Modalidade Débito Automático
						'73'    =>   'A73' ,  # Débito Não Agendado - Código de Moeda Diferente de Real (R$)
						'74'    =>   'A74' ,  # Débito Não Agendado - Data Vencimento Inválida
						'75'    =>   'A75' ,  # Débito Não Agendado, Conforme seu Pedido, Título Não Registrado
						'76'    =>   'A76' ,  # Débito Não Agendado, Tipo/Num. Inscrição do Debitado, Inválido
						'77'    =>   'A77' ,  # Transferência para Desconto Não Permitida para a Carteira do Título
						'78'    =>   'A78' ,  # Data Inferior ou Igual ao Vencimento para Débito Automático
						'79'    =>   'A79' ,  # Data Juros de Mora Inválido
						'80'    =>   'A80' ,  # Data do Desconto Inválida
						'81'    =>   'A81' ,  # Tentativas de Débito Esgotadas - Baixado
						'82'    =>   'A82' ,  # Tentativas de Débito Esgotadas - Pendente
						'83'    =>   'A83' ,  # Limite Excedido
						'84'    =>   'A84' ,  # Número Autorização Inexistente
						'85'    =>   'A85' ,  # Título com Pagamento Vinculado
						'86'    =>   'A86' ,  # Seu Número Inválido
						'87'    =>   'A87' ,  # e-mail/SMS enviado
						'88'    =>   'A88' ,  # e-mail Lido
						'89'    =>   'A89' ,  # e-mail/SMS devolvido - endereço de e-mail ou número do celular incorreto
						'90'    =>   'A90' ,  # e-mail devolvido - caixa postal cheia
						'91'    =>   'A91' ,  # e-mail/número do celular do Pagador não informado
						'92'    =>   'A92' ,  # Pagador optante por Boleto de Pagamento Eletrônico - e-mail não enviado
						'93'    =>   'A93' ,  # Código para emissão de Boleto de Pagamento não permite envio de e-mail
						'94'    =>   'A94' ,  # Código da Carteira inválido para envio e-mail.
						'95'    =>   'A95' ,  # Contrato não permite o envio de e-mail
						'96'    =>   'A96' ,  # Número de contrato inválido
						'97'    =>   'A97' ,  # Rejeição da alteração do prazo limite de recebimento (a data deve ser informada no campo 28.3.p)
						'98'    =>   'A98' ,  # Rejeição de dispensa de prazo limite de recebimento
						'99'    =>   'A99' ,  # Rejeição da alteração do número do título dado pelo Beneficiário
						'A1'    =>   'A100',  # Rejeição da alteração do número controle do participante
						'A2'    =>   'A101',  # Rejeição da alteração dos dados do Pagador
						'A3'    =>   'A102',  # Rejeição da alteração dos dados do Sacador/avalista
						'A4'    =>   'A103',  # Pagador DDA
						'A5'    =>   'A104',  # Registro Rejeitado – Título já Liquidado
						'A6'    =>   'A105',  # Código do Convenente Inválido ou Encerrado
						'A7'    =>   'A106',  # Título já se encontra na situação Pretendida
						'A8'    =>   'A107',  # Valor do Abatimento inválido para cancelamento
						'A9'    =>   'A108',  # Não autoriza pagamento parcial
						'B1'    =>   'A109',  # Autoriza recebimento parcial
						'B2'    =>   'A110',  # Valor Nominal do Título Conflitante
						'B3'    =>   'A111',  # Tipo de Pagamento Inválido
						'B4'    =>   'A112',  # Valor Máximo/Percentual Inválido
						'B5'    =>   'A113',  # Valor Mínimo/Percentual Inválido

						'A114'  =>   'A114',  # Enviado Cooperativa Emite e Expede (BANCO CECRED)
						'A115'  =>   'A115',  # Data de Geração Inválida 
						'A116'  =>   'A116',  # Entrada Inválida para Cobrança Caucionada
						'A117'  =>   'A117',  # CEP do Pagador não encontrado
						'A118'  =>   'A118',  # Agencia Cobradora não encontrada
						'A119'  =>   'A119',  # Agencia Beneficiário não encontrada
						'A120'  =>   'A120',  # Movimentação inválida para título
						'A121'  =>   'A121',  # Alteração de dados inválida
						'A122'  =>   'A122',  # Apelido do cliente não cadastrado
						'A123'  =>   'A123',  # Erro na composição do arquivo
						'A124'  =>   'A124',  # Lote de serviço inválido
						'A125'  =>   'A125',  # Beneficiário não pertencente a Cobrança Eletrônica
						'A126'  =>   'A126',  # Nome da Empresa inválido
						'A127'  =>   'A127',  # Nome do Banco inválido
						'A128'  =>   'A128',  # Código da Remessa inválido
						'A129'  =>   'A129',  # Data/Hora Geração do arquivo inválida
						'A130'  =>   'A130',  # Número Sequencial do arquivo inválido
						'A131'  =>   'A131',  # Versão do Lay out do arquivo inválido
						'A132'  =>   'A132',  # Literal REMESSA-TESTE - Válido só p/ fase testes
						'A133'  =>   'A133',  # Literal REMESSA-TESTE - Obrigatório p/ fase testes
						'A134'  =>   'A134',  # Tp Número Inscrição Empresa inválido
						'A135'  =>   'A135',  # Tipo de Operação inválido
						'A136'  =>   'A136',  # Tipo de serviço inválido
						'A137'  =>   'A137',  # Forma de lançamento inválido
						'A138'  =>   'A138',  # Número da remessa inválido
						'A139'  =>   'A139',  # Número da remessa menor/igual remessa anterior
						'A140'  =>   'A140',  # Lote de serviço divergente
						'A141'  =>   'A141',  # Número sequencial do registro inválido
						'A142'  =>   'A142',  # Erro seq de segmento do registro detalhe
						'A143'  =>   'A143',  # Cod movto divergente entre grupo de segm
						'A144'  =>   'A144',  # Qtd registros no lote inválido
						'A145'  =>   'A145',  # Qtd registros no lote divergente
						'A146'  =>   'A146',  # Qtd lotes no arquivo inválido
						'A147'  =>   'A147',  # Qtd lotes no arquivo divergente
						'A148'  =>   'A148',  # Qtd registros no arquivo inválido
						'A149'  =>   'A149',  # Qtd registros no arquivo divergente
						'A150'  =>   'A150',  # Código de DDD inválido
						'A151'  =>   'A151',  # Entrada Por via convencional
						'A152'  =>   'A152',  # Entrada Por alteração do código do cedente
						'A153'  =>   'A153',  # Entrada Por alteração da variação
						'A154'  =>   'A154',  # Entrada Por alteração da carteira
						'A155'  =>   'A155',  # identificação inválida
						'A156'  =>   'A156',  # variação da carteira inválida
						'A157'  =>   'A157',  # espécie de valor invariável inválido
						'A158'  =>   'A158',  # fora do prazo/só admissível na carteira
						'A159'  =>   'A159',  # inexistência de margem para desconto
						'A160'  =>   'A160',  # o banco não tem agência na praça do sacado
						'A161'  =>   'A161',  # razões cadastrais
						'A162'  =>   'A162',  # sacado interligado com o sacador (só admissível em cobrança simples- cart. 11 e 17)
						'A163'  =>   'A163',  # Título sacado contra órgão do Poder Público (só admissível na carteira 11 e sem ordem de protesto)
						'A164'  =>   'A164',  # Título rasurado
						'A165'  =>   'A165',  # Endereço do sacado não localizado ou incompleto
						'A166'  =>   'A166',  # Qtd de valor variável inválida
						'A167'  =>   'A167',  # Faixa nosso-Número excedida
						'A168'  =>   'A168',  # Nome do sacado/cedente inválido
						'A169'  =>   'A169',  # Data do novo vencimento inválida
						'A170'  =>   'A170',  # Número do borderô inválido
						'A171'  =>   'A171',  # Nome da pessoa autorizada inválido
						'A172'  =>   'A172',  # Número da prestação do contrato inválido
						'A173'  =>   'A173',  # percentual de desconto inválido
						'A174'  =>   'A174',  # Dias para fichamento de protesto inválido
						'A175'  =>   'A175',  # Tipo de moeda inválido
						'A176'  =>   'A176',  # Código de unidade variável incompatível com a data de emissão do título
						'A177'  =>   'A177',  # Dados para débito ao sacado inválidos
						'A178'  =>   'A178',  # Carteira/variação encerrada
						'A179'  =>   'A179',  # Título tem valor diverso do informado
						'A180'  =>   'A180',  # Motivo de baixa inválido para a carteira
						'A181'  =>   'A181',  # Comando incompatível com a carteira
						'A182'  =>   'A182',  # Código do convenente inválido
						'A183'  =>   'A183',  # Título já se encontra na situação pretendida
						'A184'  =>   'A184',  # Título fora do prazo admitido para a conta 1
						'A185'  =>   'A185',  # Novo vencimento fora dos limites da carteira
						'A186'  =>   'A186',  # Título não pertence ao convenente
						'A187'  =>   'A187',  # Variação incompatível com a carteira
						'A188'  =>   'A188',  # Impossível a variação única para a carteira indicada
						'A189'  =>   'A189',  # Título vencido em transferência para a carteira 51
						'A190'  =>   'A190',  # Título com prazo superior a 179 dias em variação única para carteira 51
						'A191'  =>   'A191',  # Título já foi fichado para protesto
						'A192'  =>   'A192',  # Alteração da situação de débito inválida para o código de responsabilidade
						'A193'  =>   'A193',  # DV do nosso número inválido
						'A194'  =>   'A194',  # Título não passível de débito/baixa – situação anormal
						'A195'  =>   'A195',  # Título com ordem de não protestar – não pode ser encaminhado a cartório
						'A196'  =>   'A196',  # Título/carne rejeitado
						'A197'  =>   'A197',  # Título já se encontra isento de juros
						'A198'  =>   'A198',  # Código de Juros Inválido
						'A199'  =>   'A199',  # Prefixo da Ag. cobradora inválido
						'A200'  =>   'A200',  # Número do controle do participante inválido
						'A201'  =>   'A201',  # Cliente não cadastrado no CIOPE (Desconto/Vendor)
						'A202'  =>   'A202',  # Título excluído automaticamente por decurso de prazo CIOPE (Desconto/Vendor)
						'A203'  =>   'A203',  # Título vencido transferido para a conta 1 – Carteira vinculada
						'A204'  =>   'A204',  # Carteira/variação não localizada no cedente
						'A205'  =>   'A205',  # Título não localizado na existência/Baixado por protesto
						'A206'  =>   'A206',  # Recusa do Comando “41” – Parâmetro de Liquidação Parcial.
						'A207'  =>   'A207',  # Entrada Por meio magnético
						'A208'  =>   'A208',  # Código de ocorrência não numérico
						'A209'  =>   'A209',  # Agência Beneficiário não prevista
						'A210'  =>   'A210',  # E-mail Pagador não lido no prazo 5 dias
						'A211'  =>   'A211',  # Email Pagador não enviado – título com débito automático
						'A212'  =>   'A212',  # Email pagador não enviado – título de cobrança sem registro
						'A213'  =>   'A213',  # E-mail pagador não recebido
						'A214'  =>   'A214',  # Título Penhorado – Instrução Não Liberada pela Agência
						'A215'  =>   'A215',  # Instrução não permitida título negativado
						'A216'  =>   'A216',  # Inclusão Bloqueada face a determinação Judicial
						'A217'  =>   'A217',  # Telefone beneficiário não informado / inconsistente
						'A218'  =>   'A218',  # Cancelado pelo Pagador e Mantido Pendente, conforme negociação
						'A219'  =>   'A219',  # Cancelado pelo pagador e baixado, conforme negociação
						'A220'  =>   'A220',  # Movimento sem Beneficiário Correspondente
						'A221'  =>   'A221',  # Movimento sem Título Correspondente
						'A222'  =>   'A222',  # Movimento para título já com movimentação no dia
						'A223'  =>   'A223',  # Nosso Número não pertence ao Beneficiário
						'A224'  =>   'A224',  # Inclusão de título já existente na base
						'A225'  =>   'A225',  # Movimento duplicado
						'A226'  =>   'A226',  # Data de Vencimento com prazo superior ao limite
						'A227'  =>   'A227',  # Movimento inválido para título Baixado/Liquidado
						'A228'  =>   'A228',  # Movimento inválido para título enviado a Cartório
						'A229'  =>   'A229',  # Faixa de CEP da Agência Cobradora não abrange CEP do Pagador
						'A230'  =>   'A230',  # Título já com opção de Devolução
						'A231'  =>   'A231',  # Processo de Protesto em andamento
						'A232'  =>   'A232',  # Título já com opção de Protesto
						'A233'  =>   'A233',  # Processo de devolução em andamento
						'A234'  =>   'A234',  # Novo prazo p/ Protesto/Devolução inválido
						'A235'  =>   'A235',  # Alteração do prazo de protesto inválida
						'A236'  =>   'A236',  # Alteração do prazo de devolução inválida
						'A237'  =>   'A237',  # CEP do Pagador inválido
						'A238'  =>   'A238',  # CNPJ/CPF do Pagador inválido (dígito não confere)
						'A239'  =>   'A239',  # Protesto inválido para título sem Número do documento (seu número)
						'A240'  =>   'A240', # CEP sem atendimento de protesto no momento
						'A241'  =>   'A241', # Estado com determinação legal que impede a inscrição de inadimplentes
						'A242'  =>   'A242', # Valor do título maior que 10.000.000,00
						'A243'  =>   'A243', # Data de entrada inválida para operar com esta carteira
						'A244'  =>   'A244', # Ocorrência inválida
						'A245'  =>   'A245', # Carteira não aceita depositária correspondente estado da agência diferente do estado do pagador ag. cobradora não consta no cadastro ou encerrando
						'A246'  =>   'A246', # Carteira não permitida (necessário cadastrar faixa livre)
						'A247'  =>   'A247', # Agência/conta não liberada para operar com cobrança
						'A248'  =>   'A248', # CNPJ do beneficiário inapto devolução de título em garantia
						'A249'  =>   'A249', # Categoria da conta inválida
						'A250'  =>   'A250', # Entradas bloqueadas, conta suspensa em cobrança
						'A251'  =>   'A251', # Conta não tem permissão para protestar (contate seu gerente)
						'A252'  =>   'A252', # Qtd de moeda incompatível com valor do título
						'A253'  =>   'A253', # CNPJ/CPF do Pagador não numérico ou igual a zeros
						'A254'  =>   'A254', # Empresa não aceita banco correspondente
						'A255'  =>   'A255', # Empresa não aceita banco correspondente - cobrança mensagem
						'A256'  =>   'A256', # Banco correspondente - título com vencimento inferior a 15 dias
						'A257'  =>   'A257', # CEP não pertence à depositária informada
						'A258'  =>   'A258', # Corresp vencimento superior a 180 dias da data de entrada
						'A259'  =>   'A259', # CEP só depositária banco do brasil com vencimento inferior a 8 dias
						'A260'  =>   'A260', # Juros de mora maior que o permitido
						'A261'  =>   'A261', # Desconto de antecipação, valor da importância por dia de desconto (idd) não permitido
						'A262'  =>   'A262', # Taxa inválida (vendor)
						'A263'  =>   'A263', # Carteira inválida para títulos com rateio de crédito
						'A264'  =>   'A264', # Beneficiário não cadastrado para fazer rateio de crédito
						'A265'  =>   'A265', # Duplicidade de agência/conta beneficiária do rateio de crédito
						'A266'  =>   'A266', # Qtd de contas beneficiárias do rateio maior do que o permitido (máximo de 30 contas por título)
						'A267'  =>   'A267', # Conta para rateio de crédito inválida / não pertence ao itaú
						'A268'  =>   'A268', # Desconto/abatimento não permitido para títulos com rateio de crédito
						'A269'  =>   'A269', # Valor do título menor que a soma dos valores estipulados para rateio
						'A270'  =>   'A270', # Agência/conta beneficiária do rateio é a centralizadora de crédito do beneficiário
						'A271'  =>   'A271', # Agência/conta do beneficiário é contratual / rateio de crédito não permitido
						'A272'  =>   'A272', # Código do tipo de valor inválido / não previsto para títulos com rateio de crédito
						'A273'  =>   'A273', # Registro tipo 4 sem informação de agências/contas beneficiárias do rateio
						'A274'  =>   'A274', # Cobrança mensagem - número da linha da mensagem inválido ou quantidade de linhas excedidas
						'A275'  =>   'A275', # Cobrança mensagem sem mensagem (só de campos fixos), porém com registro do tipo 7 ou 8
						'A276'  =>   'A276', # Registro mensagem sem flash cadastrado ou flash informado diferente do cadastrado
						'A277'  =>   'A277', # Conta de cobrança com flash cadastrado e sem registro de mensagem correspondente
						'A278'  =>   'A278', # Instrução/ocorrência não existente
						'A279'  =>   'A279', # Nosso número igual a zeros
						'A280'  =>   'A280', # Segunda instrução/ocorrência não existente
						'A281'  =>   'A281', # Registro em duplicidade
						'A282'  =>   'A282', # Título não registrado no sistema
						'A283'  =>   'A283', # Instrução não aceita
						'A284'  =>   'A284', # Instrução incompatível – existe instrução de protesto para o título
						'A285'  =>   'A285', # Instrução incompatível – não existe instrução de protesto para o título
						'A286'  =>   'A286', # Instrução não aceita por já ter sido emitida a ordem de protesto ao cartório
						'A287'  =>   'A287', # Instrução não aceita por não ter sido emitida a ordem de protesto ao cartório
						'A288'  =>   'A288', # Já existe uma mesma instrução cadastrada anteriormente para o título
						'A289'  =>   'A289', # Valor líquido + valor do abatimento diferente do valor do título registrado
						'A290'  =>   'A290', # Existe uma instrução de não protestar ativa para o título
						'A291'  =>   'A291', # Existe uma ocorrência do pagador que bloqueia a instrução
						'A292'  =>   'A292', # Depositária do título = 9999 ou carteira não aceita protesto
						'A293'  =>   'A293', # Alteração de vencimento igual à registrada no sistema ou que torna o título vencido
						'A294'  =>   'A294', # Instrução de emissão de aviso de cobrança para título vencido antes do vencimento
						'A295'  =>   'A295', # Solicitação de cancelamento de instrução inexistente
						'A296'  =>   'A296', # Título sofrendo alteração de controle (agência/conta/carteira/nosso número)
						'A297'  =>   'A297', # Instrução não permitida para a carteira
						'A298'  =>   'A298', # Instrução não permitida para título com rateio de crédito
						'A299'  =>   'A299', # Instrução incompatível – não existe instrução de negativação expressa para o título
						'A300'  =>   'A300', # Título com entrada em negativação expressa
						'A301'  =>   'A301', # Título com negativação expressa concluída
						'A302'  =>   'A302', # Prazo inválido para negativação expressa – mínimo: 02 dias corridos após o vencimento
						'A303'  =>   'A303', # Instrução incompatível para o mesmo título nesta data
						'A305'  =>   'A305', # Título com negativação expressa agendada
						'A306'  =>   'A306', # Valor do título com outra alteração simultânea
						'A307'  =>   'A307', # Abatimento/alteração do valor do título ou solicitação de baixa bloqueada
						'A308'  =>   'A308', # Agência cobradora não consta no cadastro de depositária ou em encerramento
						'A309'  =>   'A309', # Alteração inválida para título vencido
						'A310'  =>   'A310', # Alteração bloqueada – vencimento já alterado
						'A311'  =>   'A311', # Instrução com o mesmo conteúdo
						'A312'  =>   'A312', # Data vencimento para bancos correspondentes inferior ao aceito pelo banco
						'A313'  =>   'A313', # Alterações iguais para o mesmo controle (agência/conta/carteira/nosso número)
						'A314'  =>   'A314', # Prazo de vencimento inferior a 15 dias
						'A315'  =>   'A315', # Valor de IOF – alteração não permitida para carteiras de n.s. – moeda variável
						'A316'  =>   'A316', # Alteração não permitida para carteiras de notas de seguros – moeda variável
						'A317'  =>   'A317', # Nome inválido do sacador avalista
						'A318'  =>   'A318', # Endereço inválido – sacador avalista
						'A319'  =>   'A319', # Nairro inválido – sacador avalista
						'A320'  =>   'A320', # Cidade inválida – sacador avalista
						'A321'  =>   'A321', # Sigla estado inválido – sacador avalista
						'A322'  =>   'A322', # CEP inválido – sacador avalista
						'A323'  =>   'A323', # Alteração bloqueada – título com negativação expressa / protesto
						'A324'  =>   'A324', # Alteração bloqueada – título com rateio de crédito
						'A325'  =>   'A325', # Solicitação de baixa para título já baixado ou liquidado
						'A326'  =>   'A326', # Solicitação de baixa para título não registrado no sistema
						'A327'  =>   'A327', # Cobrança prazo curto – solicitação de baixa p/ título não registrado no sistema
						'A328'  =>   'A328', # Solicitação de baixa para título em floating
						'A329'  =>   'A329', # Valor do titulo faz parte de garantia de emprestimo
						'A330'  =>   'A330', # Pago através do SISPAG por crédito em c/c e não baixado
						'A331'  =>   'A331', # Não aprovada devido ao impacto na elegibilidade de garantias
						'A332'  =>   'A332', # Automaticamente rejeitada
						'A333'  =>   'A333', # Título protestado
						'A334'  =>   'A334', # Aceito
						'A335'  =>   'A335', # Desprezado
						'A336'  =>   'A336', # Praça do pagador não cadastrada.
						'A337'  =>   'A337', # Tipo de cobrança do título divergente com a praça do pagador.
						'A338'  =>   'A338', # Cooperativa/agência depositária divergente: atualiza o cadastro de praças da Coop./agência beneficiária
						'A339'  =>   'A339', # Beneficiário não cadastrado ou possui CGC/CIC inválido
						'A340'  =>   'A340', # Pagador não cadastrado
						'A341'  =>   'A341', # Ocorrência não pode ser comandada
						'A342'  =>   'A342', # Recebimento da liquidação fora da rede Sicredi - via compensação eletrônica
						'A343'  =>   'A343', # Mensagem padrão não cadastrada
						'A344'  =>   'A344', # Data limite para concessão de desconto inválida
						'A345'  =>   'A345', # Campo alterado na instrução “31 – alteração de outros dados” inválido
						'A346'  =>   'A346', # Título ainda não foi confirmado pela centralizadora
						'A347'  =>   'A347', # Título rejeitado pela centralizadora
						'A348'  =>   'A348', # Existe mesma instrução pendente de confirmação para este título
						'A349'  =>   'A349', # Instrução prévia de concessão de abatimento não existe ou não confirmada
						'A350'  =>   'A350', # Título dentro do prazo de vencimento (em dia)
						'A351'  =>   'A351', # Espécie de documento não permite protesto de título
						'A352'  =>   'A352', # Título possui instrução de baixa pendente de confirmação
						'A353'  =>   'A353', # Qtd de mensagens padrão excede o limite permitido
						'A354'  =>   'A354', # Qtd inválida no pedido de boletos pré-impressos da cobrança sem registro
						'A355'  =>   'A355', # Tipo de impressão inválida para cobrança sem registro
						'A356'  =>   'A356', # Cidade ou Estado do pagador não informado
						'A357'  =>   'A357', # Seqüência para composição do nosso número do ano atual esgotada
						'A358'  =>   'A358', # Registro mensagem para título não cadastrado
						'A359'  =>   'A359', # Registro complementar ao cadastro do título da cobrança com e sem registro não cadastrado
						'A360'  =>   'A360', # Tipo de postagem inválido, diferente de S, N e branco
						'A361'  =>   'A361', # Pedido de boletos pré-impressos
						'A362'  =>   'A362', # Confirmação/rejeição para pedidos de boletos não cadastrado
						'A363'  =>   'A363', # Pagador/avalista não cadastrado
						'A364'  =>   'A364', # Informação para atualização do valor do título para protesto inválido
						'A365'  =>   'A365', # Tipo de impressão inválido, diferente de A, B e branco
						'A366'  =>   'A366', # Código do pagador do título divergente com o código da cooperativa de crédito
						'A367'  =>   'A367', # Liquidado no sistema do cliente
						'A368'  =>   'A368', # Baixado no sistema do cliente
						'A369'  =>   'A369', # Instrução inválida, este título está caucionado/descontado
						'A370'  =>   'A370', # Instrução fixa com caracteres inválidos
						'A371'  =>   'A371', # Nosso número / número da parcela fora de seqüência – total de parcelas inválido
						'A372'  =>   'A372', # Falta de comprovante de prestação de serviço
						'A373'  =>   'A373', # Nome do beneficiário incompleto / incorreto.
						'A374'  =>   'A374', # CNPJ / CPF incompatível com o nome do pagador / Sacador Avalista
						'A375'  =>   'A375', # CNPJ / CPF do pagador Incompatível com a espécie
						'A376'  =>   'A376', # Título aceito: sem a assinatura do pagador
						'A377'  =>   'A377', # Título aceito: rasurado ou rasgado
						'A378'  =>   'A378', # Título aceito: falta título (cooperativa/ag. beneficiária deverá enviá-lo)
						'A379'  =>   'A379', # Praça de pagamento incompatível com o endereço
						'A380'  =>   'A380', # Título aceito: sem endosso ou beneficiário irregular
						'A381'  =>   'A381', # Título aceito: valor por extenso diferente do valor numérico
						'A382'  =>   'A382', # Saldo maior que o valor do título
						'A383'  =>   'A383', # Tipo de endosso inválido
						'A384'  =>   'A384', # Nome do pagador incompleto / Incorreto
						'A385'  =>   'A385', # Sustação judicial
						'A386'  =>   'A386', # Pagador não encontrado
						'A387'  =>   'A387', # Recebimento de liquidação fora da rede Sicredi – VLB Inferior – Via Compensação
						'A388'  =>   'A388', # Recebimento de liquidação fora da rede Sicredi – VLB Superior – Via Compensação
						'A389'  =>   'A389', # Espécie de documento necessita beneficiário ou avalista PJ
						'A390'  =>   'A390', # Recebimento de liquidação fora da rede Sicredi – Contingência Via Compe
						'A391'  =>   'A391', # Dados do título não conferem com disquete
						'A392'  =>   'A392', # Pagador e Sacador Avalista são a mesma pessoa
						'A393'  =>   'A393', # Aguardar um dia útil após o vencimento para protestar
						'A394'  =>   'A394', # Data do vencimento rasurada
						'A395'  =>   'A395', # Vencimento – extenso não confere com número
						'A396'  =>   'A396', # Falta data de vencimento no título
						'A397'  =>   'A397', # DM/DMI sem comprovante autenticado ou declaração
						'A398'  =>   'A398', # Comprovante ilegível para conferência e microfilmagem
						'A399'  =>   'A399', # Nome solicitado não confere com emitente ou pagador
						'A400'  =>   'A400', # Confirmar se são 2 emitentes. Se sim, indicar os dados dos 2
						'A401'  =>   'A401', # Endereço do pagador igual ao do pagador ou do portador
						'A402'  =>   'A402', # Endereço do apresentante incompleto ou não informado
						'A403'  =>   'A403', # Rua/número inexistente no endereço
						'A404'  =>   'A404', # Falta endosso do favorecido para o apresentante
						'A405'  =>   'A405', # Data da emissão rasurada
						'A406'  =>   'A406', # Falta assinatura do pagador no título
						'A407'  =>   'A407', # Nome do apresentante não informado/incompleto/incorreto
						'A408'  =>   'A408', # Erro de preenchimento do titulo
						'A409'  =>   'A409', # Titulo com direito de regresso vencido
						'A410'  =>   'A410', # Titulo apresentado em duplicidade
						'A411'  =>   'A411', # Titulo já protestado
						'A412'  =>   'A412', # Letra de cambio vencida – falta aceite do pagador
						'A413'  =>   'A413', # Falta declaração de saldo assinada no título
						'A414'  =>   'A414', # Contrato de cambio – Falta conta gráfica
						'A415'  =>   'A415', # Ausência do documento físico
						'A416'  =>   'A416', # Pagador falecido
						'A417'  =>   'A417', # Pagador apresentou quitação do título
						'A418'  =>   'A418', # Título de outra jurisdição territorial
						'A419'  =>   'A419', # Título com emissão anterior a concordata do pagador
						'A420'  =>   'A420', # Pagador consta na lista de falência
						'A421'  =>   'A421', # Apresentante não aceita publicação de edital
						'A422'  =>   'A422', # Dados do Pagador em Branco ou inválido
						'A423'  =>   'A423', # Código do Pagador na agência beneficiária está duplicado
						'A424'  =>   'A424', # Reconhecimento da dívida pelo pagador
						'A425'  =>   'A425', # Não reconhecimento da dívida pelo pagador
						'A426'  =>   'A426', # Regularização centralizadora – Rede Sicredi
						'A427'  =>   'A427', # Regularização centralizadora – Compensação
						'A428'  =>   'A428', # Regularização centralizadora – Banco correspondente
						'A429'  =>   'A429', # Regularização centralizadora - VLB Inferior - via compensação
						'A430'  =>   'A430', # Regularização centralizadora - VLB Superior - via compensação
						'A431'  =>   'A431', # Pago com cheque
						'A432'  =>   'A432', # Pago com cheque – bloqueado 24 horas
						'A433'  =>   'A433', # Pago com cheque – bloqueado 48 horas
						'A434'  =>   'A434', # Pago com cheque – bloqueado 72 horas
						'A435'  =>   'A435', # Pago com cheque – bloqueado 96 horas
						'A436'  =>   'A436', # Pago com cheque – bloqueado 120 horas
						'A437'  =>   'A437', # Pago com cheque – bloqueado 144 horas

						'A438'  =>   'A438', # Conta cobranca não numérica
						'A439'  =>   'A439', # Unidade de valor inválida
						'A440'  =>   'A440', # Valor do titulo em outra unidade
						'A441'  =>   'A441', # Valor do IOC não numérico
						'A442'  =>   'A442', # Total parcela não numérico
						'A443'  =>   'A443', # Codigo banco cobrador inválido
						'A444'  =>   'A444', # Número parcelas carne não numérico
						'A445'  =>   'A445', # Número parcelas carne zerado
						'A446'  =>   'A446', # Movimento excluido por solicitacao
						'A447'  =>   'A447', # Agência cobradora não encontrada
						'A448'  =>   'A448', # Não baixar, compl. informado inválido
						'A449'  =>   'A449', # Não protestar, compl. informado inválido
						'A450'  =>   'A450', # Qtd de dias de baixa não preenchido
						'A451'  =>   'A451', # Qtd de dias protesto não preenchido
						'A452'  =>   'A452', # Tot parc. inf. não bate cl otd parc ger
						'A453'  =>   'A453', # Carne com parcelas com erro
						'A454'  =>   'A454', # Número do titulo igual a zero
						'A455'  =>   'A455', # Titulo não encontrado
						'A456'  =>   'A456', # Titulo com ordem de protesto já emitida
						'A457'  =>   'A457', # Ocorrência não acatada, titulo já protestado
						'A458'  =>   'A458', # Ocorrência não acatada, titulo não vencido
						'A459'  =>   'A459', # Instrucao aceita so p/ cobranca simples
						'A460'  =>   'A460', # Especie documento não protestavel
						'A461'  =>   'A461', # Cedente sem carta de protesto
						'A462'  =>   'A462', # Sacado não protestavel
						'A463'  =>   'A463', # Tipo de cobranca não permite protesto
						'A464'  =>   'A464', # Pedido sustacao já solicitado
						'A465'  =>   'A465', # Sustacao protesto fora de prazo
						'A466'  =>   'A466', # Cliente não transmite reg. de ocorrencia
						'A467'  =>   'A467', # Tipo de vencimento inválido
						'A468'  =>   'A468', # Produto diferente de cobranca simples
						'A469'  =>   'A469', # Data prorrogação menor oue data vencimento
						'A470'  =>   'A470', # Data antecipação maior oue data vencimento
						'A471'  =>   'A471', # Data documento superior a data instrucao
						'A472'  =>   'A472', # Desc. por antec. maior/igual vlr titulo
						'A473'  =>   'A473', # Não existe abatimento p/ cancelar
						'A474'  =>   'A474', # Não existe prim. desconto p/ cancelar
						'A475'  =>   'A475', # Não existe seg. desconto p/ cancelar
						'A476'  =>   'A476', # Não existe terc. desconto p/ cancelar
						'A477'  =>   'A477', # Não existe desc. por antec. p/ cancelar
						'A478'  =>   'A478', # Não existe multa por atraso p/ cancelar
						'A479'  =>   'A479', # Já existe segundo desconto
						'A480'  =>   'A480', # Já existe terceiro desconto
						'A481'  =>   'A481', # Data instrucao inválida
						'A482'  =>   'A482', # Data multa menor/igual oue vencimento
						'A483'  =>   'A483', # Já existe desconto por dia antecipacao
						'A484'  =>   'A484', # Valor titulo em outra moeda não informado
						'A485'  =>   'A485', # Perfil não aceita valor titulo zerado
						'A486'  =>   'A486', # Especie docto não permite protesto
						'A487'  =>   'A487', # Especie docto não permite IOC zerado
						'A488'  =>   'A488', # Registro duplicado no movimento diario
						'A489'  =>   'A489', # Nome do sacado não informado
						'A490'  =>   'A490', # Endereço do sacado não informado
						'A491'  =>   'A491', # Municipio do sacado não informado
						'A492'  =>   'A492', # Tipo inscrição não existe
						'A493'  =>   'A493', # Valor mora tem oue ser zero (titulo = zero)
						'A494'  =>   'A494', # Data multa maior oue data de vencimento
						'A495'  =>   'A495', # Complemento da instrucao não numérico
						'A496'  =>   'A496', # Codigo p. baixa/ devol. inválido
						'A497'  =>   'A497', # Codigo banco na compensação não numérico
						'A498'  =>   'A498', # Codigo banco na compensação inválido
						'A499'  =>   'A499', # Num. lote remessa(detalhe) não numérico
						'A500'  =>   'A500', # Num. seo. reg. do lote não numérico
						'A501'  =>   'A501', # Codigo p. protesto não numérico
						'A502'  =>   'A502', # Qtd de dias p. protesto inválido
						'A503'  =>   'A503', # Qtd dias baixa/dev. inválido p. cod. 1
						'A504'  =>   'A504', # Qtd dias baixa/dev. inválido p.cod. 2
						'A505'  =>   'A505', # Qtd dias baixa/dev.inválido p.cod. 3
						'A506'  =>   'A506', # Indicador de carne não numérico
						'A507'  =>   'A507', # Num. total de parc.carne não numérico
						'A508'  =>   'A508', # Número do plano não numérico
						'A509'  =>   'A509', # Indicador de parcelas carne inválido
						'A510'  =>   'A510', # N.seo. parcela inv.p.indic. maior 0
						'A511'  =>   'A511', # N. seo.parcela inv.p.indic.dif.zeros
						'A512'  =>   'A512', # N.tot.parc.inv.p.indic. maior zeros
						'A513'  =>   'A513', # Num.tot.parc.inv.p.indic.difer.zeros
						'A514'  =>   'A514', # Alt.do contr.participanteinválido
						'A515'  =>   'A515', # Alt. do seu Número inválida
						'A516'  =>   'A516', # Banco compensação inválido (d30)
						'A517'  =>   'A517', # Num. do lote remessa não numérico(d30)
						'A518'  =>   'A518', # Num.seo.reg.no lote(d30)
						'A519'  =>   'A519', # Tipo insc.sacado inválido (d30)
						'A520'  =>   'A520', # Num.insc.sac.inv.p.tipo insc.o e 9(d30)
						'A521'  =>   'A521', # Num.banco compensação inválido (d3r)
						'A522'  =>   'A522', # Num. lote remessa não numérico (d3r)
						'A523'  =>   'A523', # Num. seo. reg. lote não numérico (d3r)
						'A524'  =>   'A524', # Data desc3 não numérica (d3r)
						'A525'  =>   'A525', # Cod.banco compensação não numérico (d3s)
						'A526'  =>   'A526', # Cod. banco compensação inválido (d3s)
						'A527'  =>   'A527', # Num.lote remessa não numérico (d3s)
						'A528'  =>   'A528', # Num.seo.do reg.lote não numérico (d3s)
						'A529'  =>   'A529', # Num.ident.de impressao inválido (d3s)
						'A530'  =>   'A530', # Num.linha impressa não numérico(d3s)
						'A531'  =>   'A531', # Cod.msg.p.rec.sacado inválido(d3s)
						'A532'  =>   'A532', # Cad.txperm.sk.inv.p.cod.mora=4(d3p)
						'A533'  =>   'A533', # Vl.tit(real).inv.p.cod.mora= 1(dep)
						'A534'  =>   'A534', # Vl.outros inv.p.cod.mora = 1(d3p)
						'A535'  =>   'A535', # Cad.tx.perm.sk.inv.p.cod.mora=3(d3p)
						'A536'  =>   'A536', # Titulo com mais de 3 instrucoes financeiras
						'A537'  =>   'A537', # Código de cedente não cadastrado
						'A538'  =>   'A538', # Titulo sem ordem de protesto automatica
						'A539'  =>   'A539', # Data de juros de tolerancia inválido
						'A540'  =>   'A540', # Data de tolerancia menor data vencimento
						'A541'  =>   'A541', # Perc. de juros de tolerancia inválido
						'A542'  =>   'A542', # Titulo rejeitado - operação de desconto
						'A543'  =>   'A543', # Titulo rejeitado - horário limite op desconto

						'A999'  =>   'A999',  # Outros motivos
					}
				end
				def equivalent_codigo_motivo_ocorrencia_B_240 codigo_movimento_gem
					#  Código     Padrão para  
					{# do Banco     a Gem
						'01'    =>   'B01',  # Tarifa de Extrato de Posição
						'02'    =>   'B02',  # Tarifa de Manutenção de Título Vencido
						'03'    =>   'B03',  # Tarifa de Sustação
						'04'    =>   'B04',  # Tarifa de Protesto
						'05'    =>   'B05',  # Tarifa de Outras Instruções
						'06'    =>   'B06',  # Tarifa de Outras Ocorrências
						'07'    =>   'B07',  # Tarifa de Envio de Duplicata ao Pagador
						'08'    =>   'B08',  # Custas de Protesto
						'09'    =>   'B09',  # Custas de Sustação de Protesto
						'10'    =>   'B10',  # Custas de Cartório Distribuidor
						'11'    =>   'B11',  # Custas de Edital
						'12'    =>   'B12',  # Tarifa Sobre Devolução de Título Vencido
						'13'    =>   'B13',  # Tarifa Sobre Registro Cobrada na Baixa/Liquidação
						'14'    =>   'B14',  # Tarifa Sobre Reapresentação Automática
						'15'    =>   'B15',  # Tarifa Sobre Rateio de Crédito
						'16'    =>   'B16',  # Tarifa Sobre Informações Via Fax
						'17'    =>   'B17',  # Tarifa Sobre Prorrogação de Vencimento
						'18'    =>   'B18',  # Tarifa Sobre Alteração de Abatimento/Desconto
						'19'    =>   'B19',  # Tarifa Sobre Arquivo mensal (Em Ser)
						'20'    =>   'B20',  # Tarifa Sobre Emissão de Boleto de Pagamento Pré-Emitido pelo Banco

						'B21'   =>   'B21',  # Redisponibilização de Arquivo Retorno Eletrônico
						'B22'   =>   'B22',  # Banco de Pagadores
						'B23'   =>   'B23',  # Entrega Aviso Disp Boleto via e-amail ao pagador (s/ emissão Boleto)
						'B24'   =>   'B24',  # Emissão de Boleto Pré-impresso CAIXA matricial
						'B25'   =>   'B25',  # Emissão de Boleto Pré-impresso CAIXA A4
						'B26'   =>   'B26',  # Emissão de Boleto Padrão CAIXA
						'B27'   =>   'B27',  # Emissão de Boleto/Carnê
						'B28'   =>   'B28',  # Emissão de Aviso de Vencido
						'B29'   =>   'B29',  # Alteração cadastral de dados do título - sem emissão de aviso
						'B30'   =>   'B30',  # Emissão de 2a via de Boleto Cobrança Registrada
						'B31'   =>   'B31',  # Tarifa de permanência título cadastrado
						'B32'   =>   'B32',  # Tarifa de registro
						'B33'   =>   'B33',  # Tarifa título pago no Bradesco
						'B34'   =>   'B34',  # Tarifa título pago compensação
						'B35'   =>   'B35',  # Tarifa título baixado não pago
						'B36'   =>   'B36',  # Tarifa alteração de vencimento
						'B37'   =>   'B37',  # Tarifa concessão abatimento
						'B38'   =>   'B38',  # Tarifa cancelamento de abatimento
						'B39'   =>   'B39',  # Tarifa concessão desconto
						'B40'   =>   'B40',  # Tarifa cancelamento desconto
						'B41'   =>   'B41',  # Tarifa título pago cics
						'B42'   =>   'B42',  # Tarifa título pago Internet
						'B43'   =>   'B43',  # Tarifa título pago term. gerencial serviços
						'B44'   =>   'B44',  # Tarifa título pago Pág-Contas
						'B45'   =>   'B45',  # Tarifa título pago Fone Fácil
						'B46'   =>   'B46',  # Tarifa título Déb. Postagem
						'B47'   =>   'B47',  # Tarifa impressão de títulos pendentes
						'B48'   =>   'B48',  # Tarifa título pago BDN
						'B49'   =>   'B49',  # Tarifa título pago Term. Multi Função
						'B50'   =>   'B50',  # Impressão de títulos baixados
						'B51'   =>   'B51',  # Impressão de títulos pagos
						'B52'   =>   'B52',  # Tarifa título pago Pagfor
						'B53'   =>   'B53',  # Tarifa reg/pgto – guichê caixa
						'B54'   =>   'B54',  # Tarifa título pago retaguarda
						'B55'   =>   'B55',  # Tarifa título pago Subcentro
						'B56'   =>   'B56',  # Tarifa título pago Cartão de Crédito
						'B57'   =>   'B57',  # Tarifa título pago Comp Eletrônica
						'B58'   =>   'B58',  # Tarifa título Baix. Pg. Cartório
						'B59'   =>   'B59',  # Tarifa título baixado acerto banco
						'B60'   =>   'B60',  # Baixa registro em duplicidade
						'B61'   =>   'B61',  # Tarifa título baixado decurso prazo
						'B62'   =>   'B62',  # Tarifa título baixado Judicialmente
						'B63'   =>   'B63',  # Tarifa título baixado via remessa
						'B64'   =>   'B64',  # Tarifa título baixado rastreamento
						'B65'   =>   'B65',  # Tarifa título baixado conf. Pedido
						'B66'   =>   'B66',  # Tarifa título baixado protestado
						'B67'   =>   'B67',  # Tarifa título baixado p/ devolução
						'B68'   =>   'B68',  # Tarifa título baixado franco pagto
						'B69'   =>   'B69',  # Tarifa título baixado SUST/RET/CARTÓRIO
						'B70'   =>   'B70',  # Tarifa título baixado SUS/SEM/REM/CARTÓRIO
						'B71'   =>   'B71',  # Tarifa título transferido desconto
						'B72'   =>   'B72',  # Cobrado baixa manual
						'B73'   =>   'B73',  # Baixa por acerto cliente
						'B74'   =>   'B74',  # Tarifa baixa por contabilidade
						'B75'   =>   'B75',  # Tr. tentativa cons deb aut
						'B76'   =>   'B76',  # Tr. credito online
						'B77'   =>   'B77',  # Tarifa reg/pagto Bradesco Expresso
						'B78'   =>   'B78',  # Tarifa emissão Papeleta
						'B79'   =>   'B79',  # Tarifa fornec papeleta semi preenchida
						'B80'   =>   'B80',  # Acondicionador de papeletas (RPB)S
						'B81'   =>   'B81',  # Acond. De papelatas (RPB)s PERSONAL
						'B82'   =>   'B82',  # Papeleta formulário branco
						'B83'   =>   'B83',  # Formulário A4 serrilhado
						'B84'   =>   'B84',  # Fornecimento de softwares transmiss
						'B85'   =>   'B85',  # Fornecimento de softwares consulta
						'B86'   =>   'B86',  # Fornecimento Micro Completo
						'B87'   =>   'B87',  # Fornecimento MODEN
						'B88'   =>   'B88',  # Fornecimento de máquinas óticas
						'B89'   =>   'B89',  # Fornecimento de Impressoras
						'B90'   =>   'B90',  # Reativação de título
						'B91'   =>   'B91',  # Alteração de produto negociado
						'B92'   =>   'B92',  # Tarifa emissão de contra recibo
						'B93'   =>   'B93',  # Tarifa emissão 2a via papeleta
						'B94'   =>   'B94',  # Tarifa regravação arquivo retorno
						'B95'   =>   'B95',  # Arq. Títulos a vencer mensal
						'B96'   =>   'B96',  # Listagem auxiliar de crédito
						'B97'   =>   'B97',  # Tarifa cadastro cartela instrução permanente
						'B98'   =>   'B98',  # Canalização de Crédito
						'B99'   =>   'B99',  # Cadastro de Mensagem Fixa
						'B100'  =>   'B100', # Tarifa registro título déb. Automático
						'B101'  =>   'B101', # Emissão papeleta sem valor
						'B102'  =>   'B102', # Sem uso
						'B103'  =>   'B103', # Cadastro de reembolso de diferença
						'B104'  =>   'B104', # Relatório fluxo de pagto
						'B105'  =>   'B105', # Emissão Extrato mov. Carteira
						'B106'  =>   'B106', # Mensagem campo local de pagto
						'B107'  =>   'B107', # Cadastro Concessionária serv. Publ.
						'B108'  =>   'B108', # Classif. Extrato Conta Corrente
						'B109'  =>   'B109', # Contabilidade especial
						'B110'  =>   'B110', # Realimentação pagto
						'B111'  =>   'B111', # Repasse de Créditos
						'B112'  =>   'B112', # Tarifa reg. Pagto outras mídias
						'B113'  =>   'B113', # Tarifa Reg/Pagto – Net Empresa
						'B114'  =>   'B114', # Tarifa título pago vencido
						'B115'  =>   'B115', # TR Tít. Baixado por decurso prazo
						'B116'  =>   'B116', # Arquivo Retorno Antecipado
						'B117'  =>   'B117', # Arq retorno Hora/Hora
						'B118'  =>   'B118', # TR. Agendamento Déb Aut
						'B119'  =>   'B119', # TR. Agendamento rat. Crédito
						'B120'  =>   'B120', # TR Emissão aviso rateio
						'B121'  =>   'B121', # Extrato de protesto
						'B122'  =>   'B122', # Tarifa de baixa da carteira
						'B123'  =>   'B123', # Tarifa de registro de entrada do título
						'B124'  =>   'B124', # Tarifa de entrada na rede Sicredi
					}
				end
				def equivalent_codigo_motivo_ocorrencia_C_240 codigo_movimento_gem
					#  Código     Padrão para  
					{# do Banco     a Gem
						'01'    =>   'C01',  # Por Saldo
						'02'    =>   'C02',  # Por Conta
						'03'    =>   'C03',  # Liquidação no Guichê de Caixa em Dinheiro
						'04'    =>   'C04',  # Compensação Eletrônica
						'05'    =>   'C05',  # Compensação Convencional
						'06'    =>   'C06',  # Por Meio Eletrônico
						'07'    =>   'C07',  # Após Feriado Local
						'08'    =>   'C08',  # Em Cartório
						'30'    =>   'C30',  # Liquidação no Guichê de Caixa em Cheque
						'31'    =>   'C31',  # Liquidação em banco correspondente
						'32'    =>   'C32',  # Liquidação Terminal de Auto-Atendimento
						'33'    =>   'C33',  # Liquidação na Internet (Home banking)
						'34'    =>   'C34',  # Liquidado Office Banking
						'35'    =>   'C35',  # Liquidado Correspondente em Dinheiro
						'36'    =>   'C36',  # Liquidado Correspondente em Cheque
						'37'    =>   'C37',  # Liquidado por meio de Central de Atendimento (Telefone)
						'09'    =>   'C09',  # Comandada Banco
						'10'    =>   'C10',  # Comandada Cliente Arquivo
						'11'    =>   'C11',  # Comandada Cliente On-line
						'12'    =>   'C12',  # Decurso Prazo - Cliente
						'13'    =>   'C13',  # Decurso Prazo - Banco
						'14'    =>   'C14',  # Protestado
						'15'    =>   'C15',  # Título Excluído

						'C00'   =>   'C00',  # Baixado Conforme Instruções da Agência
						'C16'   =>   'C16',  # Título Baixado pelo Banco por decurso Prazo
						'C17'   =>   'C17',  # Titulo Baixado Transferido Carteira
						'C20'   =>   'C20',  # Titulo Baixado e Transferido para Desconto
						'C42'   =>   'C42',  # Rateio não efetuado, cód. Calculo 2 (VLR. Registro) 
						'C46'   =>   'C46',  # Baixa Por alteração da variação
						'C47'   =>   'C47',  # Baixa Por alteração da variação
						'C51'   =>   'C51',  # Baixa Acerto
						'C90'   =>   'C90',  # Baixa automática
						'C100'  =>   'C100', # Casa Lotérica
						'C101'  =>   'C101', # Agências CAIXA
						'C102'  =>   'C102', # Correspondente Bancário
						'C103'  =>   'C103', # Liquidação normal
						'C104'  =>   'C104', # Liquidação parcial
						'C105'  =>   'C105', # Liquidação com cheque a compensar
						'C106'  =>   'C106', # Liquidação de título sem registro (carteira 7 tipo 4)
						'C107'  =>   'C107', # Liquidação na apresentação
						'C110'  =>   'C110', # Liquidação Parcial com Cheque a Compensar
						'C111'  =>   'C111', # Liquidação por Saldo com Cheque a Compensar
						'C118'  =>   'C118', # Baixa Por alteração da carteira
						'C119'  =>   'C119', # Baixa Débito automático
						'C131'  =>   'C131', # Baixa Liquidado anteriormente
						'C132'  =>   'C132', # Baixa Habilitado em processo
						'C133'  =>   'C133', # Baixa Incobrável por nosso intermédio
						'C134'  =>   'C134', # Baixa Transferido para créditos em liquidação
						'C135'  =>   'C135', # Acerto online
						'C136'  =>   'C136', # Outros bancos – recebimento off-line
						'C137'  =>   'C137', # Outros bancos – pelo código de barras
						'C138'  =>   'C138', # Outros bancos – pela linha digitável
						'C139'  =>   'C139', # Outros bancos – pelo auto atendimento
						'C140'  =>   'C140', # Outros bancos – recebimento em casa lotérica
						'C141'  =>   'C141', # Outros bancos – correspondente
						'C142'  =>   'C142', # Outros bancos – telefone
						'C143'  =>   'C143', # Outros bancos – arquivo eletrônico (pagamento efetuado por meio de troca de arquivos)
						'C144'  =>   'C144', # Correspondente Itaú
						'C145'  =>   'C145', # SISPAG – sistema de contas a pagar itaú
						'C146'  =>   'C146', # Agência itaú – por débito em conta corrente, cheque itaú* ou dinheiro
						'C147'  =>   'C147', # Agência itaú – capturado em off-line
						'C148'  =>   'C148', # Pagamento em cartório de protesto com cheque
						'C149'  =>   'C149', # Agendamento – pagamento agendado via bankline ou outro canal eletrônico e liquidado na data indicada
						'C150'  =>   'C150', # Digitação – realimentação automática
						'C151'  =>   'C151', # Pagamento via seltec
					}
				end				
				def equivalent_codigo_motivo_ocorrencia_D_240 codigo_movimento_gem
					 # Exclusivo por banco
				end

				def equivalent_codigo_motivo_ocorrencia_A_400 codigo_movimento_gem
					equivalent_codigo_motivo_ocorrencia_A_240 codigo_movimento_gem
				end
				def equivalent_codigo_motivo_ocorrencia_B_400 codigo_movimento_gem
					equivalent_codigo_motivo_ocorrencia_B_240 codigo_movimento_gem
				end
				def equivalent_codigo_motivo_ocorrencia_C_400 codigo_movimento_gem
					equivalent_codigo_motivo_ocorrencia_C_240 codigo_movimento_gem
				end
				def equivalent_codigo_motivo_ocorrencia_D_400 codigo_movimento_gem
					equivalent_codigo_motivo_ocorrencia_D_240 codigo_movimento_gem
				end

			########################################################################################	
			########################## CÓDIGO DE OCORRÊNCIA DO PAGADOR #############################
				# Código de Ocorrência do Pagador :
				# Códigos padrões da GEM
					# 0101 = Pagador alega que não recebeu a mercadoria 
					# 0102 = Pagador alega que a mercadoria chegou atrasada 
					# 0103 = Pagador alega que a mercadoria chegou avariada 
					# 0104 = Pagador alega que a mercadoria não confere com o pedido 
					# 0105 = Pagador alega que a mercadoria chegou incompleta 
					# 0106 = Pagador alega que a mercadoria está à disposição do cedente 
					# 0107 = Pagador alega que devolveu a mercadoria 
					# 0108 = Pagador alega que a mercadoria está em desacordo com a Nota Fiscal    
					# 0109 = Pagador alega que nada deve ou comprou
					# 0201 = Pagador alega que não recebeu a fatura 
					# 0202 = Pagador alega que o pedido de compra foi cancelado 
					# 0203 = Pagador alega que a duplicata foi cancelada 
					# 0204 = Pagador alega não ter recebido a mercadoria, nota fiscal, fatura 
					# 0205 = Pagador alega que a duplicata/fatura está incorreta 
					# 0206 = Pagador alega que o valor está incorreto 
					# 0207 = Pagador alega que o faturamento é indevido 
					# 0208 = Pagador alega que não localizou o pedido de compra 
					# 0301 = Pagador alega que o vencimento correto é: 
					# 0302 = Pagador solicita a prorrogação do vencimento para: 
					# 0303 = Pagador aceita se o vencimento prorrogado para: 
					# 0304 = Pagador alega que pagará o título em: 
					# 0305 = Pagador pagou o título diretamente ao cedente em: 
					# 0306 = Pagador pagará o título diretamente ao cedente em: 
					# 0401 = Pagador não foi localizado, confirmar endereço 
					# 0402 = Pagador mudou-se, transferiu de domicílio 
					# 0403 = Pagador não recebe no endereço indicado 
					# 0404 = Pagador desconhecido no local 
					# 0405 = Pagador reside fora do perímetro 
					# 0406 = Pagador com endereço incompleto 
					# 0407 = Não foi localizado o número constante no endereço do título 
					# 0408 = Endereço não localizado/não consta nos guias da cidade 
					# 0409 = Endereço do Pagador alterado para: 
					# 0501 = Pagador alega que tem desconto ou abatimento de: 
					# 0502 = pagador solicita desconto ou abatimento de:
					# 0503 = Pagador solicita dispensa dos juros de mora 
					# 0504 = Pagador se recusa a pagar juros 
					# 0505 = Pagador se recusa a pagar comissão de permanência 
					# 0601 = Pagador está em regime de concordata 
					# 0602 = Pagador está em regime de falência 
					# 0603 = Pagador alega que mantém entendimentos com Pagador
					# 0604 = Pagador está em entendimentos com o cedente 
					# 0605 = Pagador está viajando 
					# 0606 = Pagador recusou-se a aceitar o título 
					# 0607 = Pagador sustou protesto judicialmente 
					# 0608 = Empregado recusou-se a receber título 
					# 0609 = Título reapresentado ao Pagador 
					# 0610 = Estamos nos dirigindo ao nosso correspondente 
					# 0611 = Correspondente não se interessa pelo protesto 
					# 0612 = Pagador não atende aos avisos de nossos correspondentes 
					# 0613 = Título está sendo encaminhado ao correspondente 
					# 0614 = Entrega franco de pagamento ao Pagador 
					# 0615 = Entrega franco de pagamento ao representante 
					# 0616 = A entrega franco de pagamento é difícil 
					# 0617 = Título recusado pelo cartório 
					#
					# Itaú:
					# 1776 = Não foi possível a entrega do boleto ao pagador
					# 1784 = Boleto não entregue, mudou-se / desconhecido
					# 1792 = Boleto não entregue, CEP errado / incompleto
					# 1800 = Boleto não entregue, número não existe/endereço incompleto
					# 1818 = Boleto não retirado pelo pagador. reenviado pelo correio para carteiras com emissão pelo banco
					# 1826 = Endereço de e-mail inválido/cobrança mensagem. boleto enviado pelo correio
					# 1834 = Boleto DDA, divida reconhecida pelo pagador
					# 1842 = Boleto DDA, divida não reconhecida pelo pagador

				def get_codigo_ocorrencia_pagador(code, cnab)
					send("equivalent_codigo_ocorrencia_pagador_#{cnab}")[code] || code
				end
				# Código adotado pela FEBRABAN para identificar o tipo de ocorrência do Pagador.
				def equivalent_codigo_ocorrencia_pagador_240
					{
						'0101' => '0101', # Pagador alega que não recebeu a mercadoria 
						'0102' => '0102', # Pagador alega que a mercadoria chegou atrasada 
						'0103' => '0103', # Pagador alega que a mercadoria chegou avariada 
						'0104' => '0104', # Pagador alega que a mercadoria não confere com o pedido 
						'0105' => '0105', # Pagador alega que a mercadoria chegou incompleta 
						'0106' => '0106', # Pagador alega que a mercadoria está à disposição do cedente 
						'0107' => '0107', # Pagador alega que devolveu a mercadoria 
						'0108' => '0108', # Pagador alega que a mercadoria está em desacordo com a Nota Fiscal    
						'0109' => '0109', # Pagador alega que nada deve ou comprou
						'0201' => '0201', # Pagador alega que não recebeu a fatura 
						'0202' => '0202', # Pagador alega que o pedido de compra foi cancelado 
						'0203' => '0203', # Pagador alega que a duplicata foi cancelada 
						'0204' => '0204', # Pagador alega não ter recebido a mercadoria, nota fiscal, fatura 
						'0205' => '0205', # Pagador alega que a duplicata/fatura está incorreta 
						'0206' => '0206', # Pagador alega que o valor está incorreto 
						'0207' => '0207', # Pagador alega que o faturamento é indevido 
						'0208' => '0208', # Pagador alega que não localizou o pedido de compra 
						'0301' => '0301', # Pagador alega que o vencimento correto é: 
						'0302' => '0302', # Pagador solicita a prorrogação do vencimento para: 
						'0303' => '0303', # Pagador aceita se o vencimento prorrogado para: 
						'0304' => '0304', # Pagador alega que pagará o título em: 
						'0305' => '0305', # Pagador pagou o título diretamente ao cedente em: 
						'0306' => '0306', # Pagador pagará o título diretamente ao cedente em: 
						'0401' => '0401', # Pagador não foi localizado, confirmar endereço 
						'0402' => '0402', # Pagador mudou-se, transferiu de domicílio 
						'0403' => '0403', # Pagador não recebe no endereço indicado 
						'0404' => '0404', # Pagador desconhecido no local 
						'0405' => '0405', # Pagador reside fora do perímetro 
						'0406' => '0406', # Pagador com endereço incompleto 
						'0407' => '0407', # Não foi localizado o número constante no endereço do título 
						'0408' => '0408', # Endereço não localizado/não consta nos guias da cidade 
						'0409' => '0409', # Endereço do Pagador alterado para: 
						'0501' => '0501', # Pagador alega que tem desconto ou abatimento de: 
						'0502' => '0502', # Pagador solicita desconto ou abatimento de:
						'0503' => '0503', # Pagador solicita dispensa dos juros de mora 
						'0504' => '0504', # Pagador se recusa a pagar juros 
						'0505' => '0505', # Pagador se recusa a pagar comissão de permanência 
						'0601' => '0601', # Pagador está em regime de concordata 
						'0602' => '0602', # Pagador está em regime de falência 
						'0603' => '0603', # Pagador alega que mantém entendimentos com Pagadorr 
						'0604' => '0604', # Pagador está em entendimentos com o cedente 
						'0605' => '0605', # Pagador está viajando 
						'0606' => '0606', # Pagador recusou-se a aceitar o título 
						'0607' => '0607', # Pagador sustou protesto judicialmente 
						'0608' => '0608', # Empregado recusou-se a receber título 
						'0609' => '0609', # Título reapresentado ao Pagador 
						'0610' => '0610', # Estamos nos dirigindo ao nosso correspondente 
						'0611' => '0611', # Correspondente não se interessa pelo protesto 
						'0612' => '0612', # Pagador não atende aos avisos de nossos correspondentes 
						'0613' => '0613', # Título está sendo encaminhado ao correspondente 
						'0614' => '0614', # Entrega franco de pagamento ao Pagador 
						'0615' => '0615', # Entrega franco de pagamento ao representante 
						'0616' => '0616', # A entrega franco de pagamento é difícil 
						'0617' => '0617', # Título recusado pelo cartório 

						'1776' => '1776', # Não foi possível a entrega do boleto ao pagador
						'1784' => '1784', # Boleto não entregue, mudou-se / desconhecido
						'1792' => '1792', # Boleto não entregue, CEP errado / incompleto
						'1800' => '1800', # Boleto não entregue, número não existe/endereço incompleto
						'1818' => '1818', # Boleto não retirado pelo pagador. reenviado pelo correio para carteiras com emissão pelo banco
						'1826' => '1826', # Endereço de e-mail inválido/cobrança mensagem. boleto enviado pelo correio
						'1834' => '1834', # Boleto DDA, divida reconhecida pelo pagador
						'1842' => '1842', # Boleto DDA, divida não reconhecida pelo pagador
					}
				end

				def equivalent_codigo_ocorrencia_pagador_400
					equivalent_codigo_ocorrencia_pagador_240
				end
		end
	end
end