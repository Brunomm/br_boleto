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
					"#{code}".adjust_size_to(2, '0', :right)
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
					"#{code}".adjust_size_to(2, '0', :right)
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
					"#{code}".adjust_size_to(1, '0', :right)
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
					"#{code}".adjust_size_to(1, '0', :right)
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
					"#{code}".rjust(1, '0')
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
					"#{code}".adjust_size_to(1, '0', :right)
					equivalent_codigo_juros[code] || '3'
				end
				# Código adotado pela FEBRABAN para identificação do tipo de pagamento de juros de mora.
				def equivalent_codigo_juros
					{
						'1' => '1', # Valor por Dia
						'2' => '2', # Taxa Mensal
						'3' => '3', # Isento
					}
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
					"#{code}".adjust_size_to(1, '0', :right)
					equivalent_codigo_multa[code] || '3'
				end
				# Código adotado pela FEBRABAN para identificação do tipo de pagamento de multa.
				def equivalent_codigo_multa
					{
						'1' => '1', # Valor fixo
						'2' => '2', # Percentual
						'3' => '3', # Isento
					}
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
					"#{code}".adjust_size_to(1, '0', :right)
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
					"#{code}".adjust_size_to(1, '0', :right)
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
					"#{code}".adjust_size_to(2, '0', :right)
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

		end
	end
end