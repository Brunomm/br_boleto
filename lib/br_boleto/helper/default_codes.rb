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
					{
						'1' => '1', # Cobrança Simples
						'2' => '2', # Cobrança Vinculada
						'3' => '3', # Cobrança Caucionada
						'4' => '4', # Cobrança Descontada
						'5' => '5', # Cobrança Vendor
					}
				end	

			#######################################################################################
			#####################  CÓDIGO DO TIPO DE IMPRESSÃO DO BLOQUETO  ######################
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
					{
						'1' => '1', # Frente do Bloqueto
						'2' => '2', # Verso do Bloqueto
						'3' => '3', # Corpo de Instruções da Ficha de Compensação do Bloqueto
					}
				end

			#######################################################################################
			#####################  CÓDIGO DA IDENTIFICAÇÃO EMISSÃO DO BOLETO  #####################
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
					# 11 = Títulos em Carteira (Em Ser)
					# 12 = Confirmação Recebimento Instrução de Abatimento
					# 13 = Confirmação Recebimento Instrução de Cancelamento Abatimento
					# 14 = Confirmação Recebimento Instrução Alteração de Vencimento
					# 15 = Franco de Pagamento
					# 17 = Liquidação Após Baixa ou Liquidação Título Não Registrado
					# 19 = Confirmação Recebimento Instrução de Protesto
					# 20 = Confirmação Recebimento Instrução de Sustação/Cancelamento de Protesto
					# 23 = Remessa a Cartório (Aponte em Cartório)
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
					#
					# BRADESCO:
					# 73 = Confirmação recebimento pedido de negativação
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
					# 208 = Liquidação Em Cartório
					# 210 = Baixa Por Ter Sido Liquidado
					# 230 = Alteração/Exclusão De Dados Rejeitada 
					# 218 = Cobrança Contratual – Instruções/Alterações Rejeitadas/Pendentes
					# 221 = Confirmação Recebimento De Instrução De Não Protestar
					# 225 = Alegações Do Pagador
					# 226 = Tarifa De Aviso De Cobrança
					# 227 = Tarifa De Extrato Posição (B40X)
					# 228 = Tarifa De Relação Das Liquidações
					# 229 = Tarifa De Manutenção De Títulos Vencidos
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
					# 257 = Instrução Cancelada
					# 260 = Entrada Rejeitada Carnê
					# 261 = Tarifa Emissão Aviso De Movimentação De Títulos (2154)
					# 262 = Débito Mensal De Tarifa – Aviso De Movimentação De Títulos (2154)
					# 263 = Título Sustado Judicialmente
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
					# SICREDI:
					# 100 = Baixa Rejeitada
					#
				def get_codigo_movimento_retorno(code)
					equivalent_codigo_movimento_retorno[code] || code
				end
				# Código adotado pela FEBRABAN, para identificar o tipo de movimentação enviado nos
				# registros do arquivo de retorno.
				def equivalent_codigo_movimento_retorno
					{
						'02'  => '02',  # Entrada Confirmada
						'03'  => '03',  # Entrada Rejeitada
						'04'  => '04',  # Transferência de Carteira/Entrada
						'05'  => '05',  # Transferência de Carteira/Baixa
						'06'  => '06',  # Liquidação
						'07'  => '07',  # Confirmação do Recebimento da Instrução de Desconto
						'08'  => '08',  # Confirmação do Recebimento do Cancelamento do Desconto
						'09'  => '09',  # Baixa
						'11'  => '11',  # Títulos em Carteira (Em Ser)
						'12'  => '12',  # Confirmação Recebimento Instrução de Abatimento
						'13'  => '13',  # Confirmação Recebimento Instrução de Cancelamento Abatimento
						'14'  => '14',  # Confirmação Recebimento Instrução Alteração de Vencimento
						'15'  => '15',  # Franco de Pagamento
						'17'  => '17',  # Liquidação Após Baixa ou Liquidação Título Não Registrado
						'19'  => '19',  # Confirmação Recebimento Instrução de Protesto
						'20'  => '20',  # Confirmação Recebimento Instrução de Sustação/Cancelamento de Protesto
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

						'01'  => '01',  # Solicitação de Impressão de Títulos Confirmada
						'73'  => '73',  # Confirmação recebimento pedido de negativação
						'76'  => '76',  # Liquidação de boleto cooperativa emite e expede
						'77'  => '77',  # Liquidação de boleto após baixa ou não registrado cooperativa emite e expede
						'91'  => '91',  # Título em aberto não enviado ao pagador
						'92'  => '92',  # Inconsistência Negativação Serasa
						'93'  => '93',  # Inclusão Negativação via Serasa
						'94'  => '94',  # Exclusão Negativação Serasa
						'100' => '100', # Baixa Rejeitada
						'135' => '135', # Confirmação de Inclusão Banco de Sacado
						'136' => '136', # Confirmação de Alteração Banco de Sacado
						'137' => '137', # Confirmação de Exclusão Banco de Sacado
						'138' => '138', # Emissão de Bloquetos de Banco de Sacado
						'139' => '139', # Manutenção de Sacado Rejeitada
						'140' => '140', # Entrada de Título via Banco de Sacado Rejeitada
						'141' => '141', # Manutenção de Banco de Sacado Rejeitada
						'144' => '144', # Estorno de Baixa / Liquidação
						'145' => '145', # Alteração de Dados
						'208' => '208', # Liquidação Em Cartório
						'210' => '210', # Baixa Por Ter Sido Liquidado
						'230' => '230', # Alteração/Exclusão De Dados Rejeitada 
						'218' => '218', # Cobrança Contratual – Instruções/Alterações Rejeitadas/Pendentes
						'221' => '221', # Confirmação Recebimento De Instrução De Não Protestar
						'225' => '225', # Alegações Do Pagador
						'226' => '226', # Tarifa De Aviso De Cobrança
						'227' => '227', # Tarifa De Extrato Posição (B40X)
						'228' => '228', # Tarifa De Relação Das Liquidações
						'229' => '229', # Tarifa De Manutenção De Títulos Vencidos
						'233' => '233', # Custas De Protesto
						'234' => '234', # Custas De Sustação
						'235' => '235', # Custas De Cartório Distribuidor
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
						'260' => '260', # Entrada Rejeitada Carnê
						'261' => '261', # Tarifa Emissão Aviso De Movimentação De Títulos (2154)
						'262' => '262', # Débito Mensal De Tarifa – Aviso De Movimentação De Títulos (2154)
						'263' => '263', # Título Sustado Judicialmente
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
						# A45 = Nome do Pagador Não Informado
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
						# A115 a 151 (EXCLUSIVO CAIXA)
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
						# B21 a B30 (EXCLUSIVO CAIXA)
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
						# Baixa:
							# C09 = Comandada Banco
							# C10 = Comandada Cliente Arquivo
							# C11 = Comandada Cliente On-line
							# C12 = Decurso Prazo - Cliente
							# C13 = Decurso Prazo - Banco
							# C14 = Protestado
							# C15 = Título Excluído
						# Outros:
							# C100 a C102 (EXCLUSIVO CAIXA)

					# D - Códigos de confirmação associado ao código de movimento (Exclusivo por banco)
						# SICREDI (código de movimento '27'): 
							# D01 = Alteração de carteira
						# CECRED (código de movimento '93' e '94'):
							# D02 = Sempre que a solicitação (inclusão ou exclusão) for efetuada com sucesso
							# D03 = Sempre que a solicitação for integrada na Serasa com sucesso
							# D04 = Sempre que vier retorno da Serasa por decurso de prazo
							# D05 = Sempre que o documento for integrado na Serasa com sucesso, quando o UF for de São Paulo
							# D06 = Sempre quando houver ação judicial, restringindo a negativação do boleto.
						# CAIXA (código de movimento '08'):
							# D07 = Liquidação em Dinheiro
							# D08 = Liquidação em Cheque

				def get_codigo_motivo_ocorrencia(code, codigo_movimento_gem)
					return if code.blank? || codigo_movimento_gem.blank?
					if codigo_movimento_gem.in? codigos_movimento_retorno_para_ocorrencia_A
						equivalent_codigo_motivo_ocorrencia_A(codigo_movimento_gem)[code] || 'OUTRO_A'
					elsif codigo_movimento_gem.in? codigos_movimento_retorno_para_ocorrencia_B
						equivalent_codigo_motivo_ocorrencia_B(codigo_movimento_gem)[code] || 'OUTRO_B'
					elsif codigo_movimento_gem.in? codigos_movimento_retorno_para_ocorrencia_C
						equivalent_codigo_motivo_ocorrencia_C(codigo_movimento_gem)[code] || 'OUTRO_C'
					elsif codigo_movimento_gem.in? codigos_movimento_retorno_para_ocorrencia_D
						equivalent_codigo_motivo_ocorrencia_D(codigo_movimento_gem)[code] || 'OUTRO_D'
					else
						'OUTRO_X'
					end
				end

				def codigos_movimento_retorno_para_ocorrencia_A
					%w[02 03 26 30]
				end

				def codigos_movimento_retorno_para_ocorrencia_B
					%w[28]
				end

				def codigos_movimento_retorno_para_ocorrencia_C
					%w[06 09 17]
				end

				def codigos_movimento_retorno_para_ocorrencia_D 
					# Exclusivo por banco
				end

				# Códigos adotados pela FEBRABAN para identificar as ocorrências (rejeições, tarifas,
				# custas, liquidação e baixas) em registros detalhe de títulos de cobrança.
				def equivalent_codigo_motivo_ocorrencia_A codigo_movimento_gem
					#  Código     Padrão para  
					{# do Banco     a Gem
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
						'45'    =>   'A45' ,  # Nome do Pagador Não Informado
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
					}
				end
				def equivalent_codigo_motivo_ocorrencia_B codigo_movimento_gem
					#  Código     Padrão para  
					{# do Banco     a Gem
						'01'  => 'B01',  # Tarifa de Extrato de Posição
						'02'  => 'B02',  # Tarifa de Manutenção de Título Vencido
						'03'  => 'B03',  # Tarifa de Sustação
						'04'  => 'B04',  # Tarifa de Protesto
						'05'  => 'B05',  # Tarifa de Outras Instruções
						'06'  => 'B06',  # Tarifa de Outras Ocorrências
						'07'  => 'B07',  # Tarifa de Envio de Duplicata ao Pagador
						'08'  => 'B08',  # Custas de Protesto
						'09'  => 'B09',  # Custas de Sustação de Protesto
						'10'  => 'B10',  # Custas de Cartório Distribuidor
						'11'  => 'B11',  # Custas de Edital
						'12'  => 'B12',  # Tarifa Sobre Devolução de Título Vencido
						'13'  => 'B13',  # Tarifa Sobre Registro Cobrada na Baixa/Liquidação
						'14'  => 'B14',  # Tarifa Sobre Reapresentação Automática
						'15'  => 'B15',  # Tarifa Sobre Rateio de Crédito
						'16'  => 'B16',  # Tarifa Sobre Informações Via Fax
						'17'  => 'B17',  # Tarifa Sobre Prorrogação de Vencimento
						'18'  => 'B18',  # Tarifa Sobre Alteração de Abatimento/Desconto
						'19'  => 'B19',  # Tarifa Sobre Arquivo mensal (Em Ser)
						'20'  => 'B20',  # Tarifa Sobre Emissão de Boleto de Pagamento Pré-Emitido pelo Banco
					}
				end
				def equivalent_codigo_motivo_ocorrencia_C codigo_movimento_gem
					#  Código     Padrão para  
					{# do Banco     a Gem
						'01'  => 'C01',  # Por Saldo
						'02'  => 'C02',  # Por Conta
						'03'  => 'C03',  # Liquidação no Guichê de Caixa em Dinheiro
						'04'  => 'C04',  # Compensação Eletrônica
						'05'  => 'C05',  # Compensação Convencional
						'06'  => 'C06',  # Por Meio Eletrônico
						'07'  => 'C07',  # Após Feriado Local
						'08'  => 'C08',  # Em Cartório
						'30'  => 'C30',  # Liquidação no Guichê de Caixa em Cheque
						'31'  => 'C31',  # Liquidação em banco correspondente
						'32'  => 'C32',  # Liquidação Terminal de Auto-Atendimento
						'33'  => 'C33',  # Liquidação na Internet (Home banking)
						'34'  => 'C34',  # Liquidado Office Banking
						'35'  => 'C35',  # Liquidado Correspondente em Dinheiro
						'36'  => 'C36',  # Liquidado Correspondente em Cheque
						'37'  => 'C37',  # Liquidado por meio de Central de Atendimento (Telefone)
						'09'  => 'C09',  # Comandada Banco
						'10'  => 'C10',  # Comandada Cliente Arquivo
						'11'  => 'C11',  # Comandada Cliente On-line
						'12'  => 'C12',  # Decurso Prazo - Cliente
						'13'  => 'C13',  # Decurso Prazo - Banco
						'14'  => 'C14',  # Protestado
						'15'  => 'C15',  # Título Excluído
					}
				end				
				def equivalent_codigo_motivo_ocorrencia_D codigo_movimento_gem
					 # Exclusivo por banco
				end
		end
	end
end