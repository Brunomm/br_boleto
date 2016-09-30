module BrBoleto
	module Helper
		module DefaultCodes

			# Espécie do Título :
			# Código adotado pela FEBRABAN para identificar o tipo de título de cobrança
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
				{
					'01' => '01', #  Duplicata Mercantil
					'02' => '02', #  Nota Promissória
					'03' => '03', #  Nota de Seguro
					'05' => '05', #  Recibo
					'06' => '06', #  Duplicata Rural
					'08' => '08', #  Letra de Câmbio
					'09' => '09', #  Warrant
					'10' => '10', #  Cheque
					'12' => '12', #  Duplicata de Serviço
					'13' => '13', #  Nota de Débito
					'14' => '14', #  Triplicata Mercantil
					'15' => '15', #  Triplicata de Serviço
					'18' => '18', #  Fatura
					'20' => '20', #  Apólice de Seguro
					'21' => '21', #  Mensalidade Escolar
					'22' => '22', #  Parcela de Consórcio
					'99' => '99', #  Outros"
				}
			end	

			
			# Código de Movimento Remessa:
			# Código adotado pela FEBRABAN, para identificar o tipo de movimentação 
			# enviado nos registros do arquivo de remessa.
			def get_codigo_movimento_remessa(code)
				"#{code}".adjust_size_to(2, '0', :right)
				equivalent_codigo_movimento_remessa[code] || ''
			end
			def equivalent_codigo_movimento_remessa
				{
					'01' => '01', # Entrada de Títulos
					'02' => '02', # Pedido de Baixa
					'03' => '03', # Protesto para Fins Falimentares
					'04' => '04', # Concessão de Abatimento
					'05' => '05', # Cancelamento de Abatimento
					'06' => '06', # Alteração de Vencimento
					'07' => '07', # Concessão de Desconto
					'08' => '08', # Cancelamento de Desconto (NÃO TRATADO PELO BANCO)
					'09' => '09', # Protestar
					'10' => '10', # Sustar Protesto e Baixar Título
					'11' => '11', # Sustar Protesto e Manter em Carteira
					'12' => '12', # Alteração de Juros de Mora
					'13' => '13', # Dispensar Cobrança de Juros de Mora
					'14' => '14', # Alteração de Valor/Percentual de Multa
					'15' => '15', # Dispensar Cobrança de Multa
					'16' => '16', # Alteração do Valor de Desconto
					'17' => '17', # Não conceder Desconto (NÃO TRATADO PELO BANCO)
					'18' => '18', # Alteração do Valor de Abatimento
					'19' => '19', # Prazo Limite de Recebimento – Alterar (NÃO TRATADO PELO BANCO)
					'20' => '20', # Prazo Limite de Recebimento – Dispensar (NÃO TRATADO PELO BANCO)
					'21' => '21', # Alterar número do título dado pelo beneficiario
					'22' => '22', # Alterar número controle do Participante
					'23' => '23', # Alterar dados do Pagador
					'24' => '24', # Alterar dados do Sacador/Avalista
					'30' => '30', # Recusa da Alegação do Pagador (NÃO TRATADO PELO BANCO)
					'31' => '31', # Alteração de Outros Dados
					'33' => '33', # Alteração dos Dados do Rateio de Crédito
					'34' => '34', # Pedido de Cancelamento dos Dados do Rateio de Crédito
					'35' => '35', # Pedido de Desagendamento do Débito Automático
					'40' => '40', # Alteração de Carteira (NÃO TRATADO PELO BANCO)
					'41' => '41', # Cancelar protesto (NÃO TRATADO PELO BANCO)
					'42' => '42', # Alteração de Espécie de Título
					'43' => '43', # Transferência de carteira/modalidade de cobrança (NÃO TRATADO PELO BANCO)
					'44' => '44', # Alteração de contrato de cobrança (NÃO TRATADO PELO BANCO)
					'45' => '45', # Negativação Sem Protesto
					'46' => '46', # Solicitação de Baixa de Título Negativado Sem Protesto
					'47' => '47', # Alteração do Valor Nominal do Título
					'48' => '48', # Alteração do Valor Mínimo/ Percentual
					'49' => '49', # Alteração do Valor Máximo/Percentua
				}
			end


			# Código da Carteira :
			def get_codigo_carteira(code)
				"#{code}".adjust_size_to(1, '0', :right)
				equivalent_codigo_carteira[code] || ''
			end
			# Código adotado pela FEBRABAN, para identificar a característica dos títulos
         # dentro das modalidades de cobrança existentes no banco.
			def equivalent_codigo_carteira
				{
					'1' => '1', # Cobrança Simples
					'2' => '2', # Cobrança Vinculada
					'3' => '3', # Cobrança Caucionada
					'4' => '4', # Cobrança Descontada
					'5' => '5', # Cobrança Vendor
				}
			end	


			# Identificação da Emissão do Boleto de Pagamento :
			def get_identificacao_emissao(code)
				"#{code}".adjust_size_to(1, '0', :right)
				equivalent_identificacao_emissao[code] || ''
			end
			# Código adotado pela FEBRABAN para identificar o responsável e a forma de emissão do  Boleto de Pagamento.
			# Os códigos '4' e '5' só serão aceitos para código de movimento para remessa '31'
			def equivalent_identificacao_emissao
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


			# Identificação da Distribuição :
			def get_identificacao_distribuicao(code)
				"#{code}".adjust_size_to(1, '0', :right)
				equivalent_identificacao_distribuicao[code] || ''
			end
			# Código adotado pela FEBRABAN para identificar o responsável pela distribuição do bloqueto.
			def equivalent_identificacao_distribuicao
				{
					'1' => '1', # Banco Distribui
					'2' => '2', # Cliente Distribui
					'3' => '3', # Banco envia e-mail
					'4' => '4', # Banco envia SMS
				}
			end

			# Código dos Juros de Mora :
			def get_codigo_juros_mora(code)
				"#{code}".adjust_size_to(1, '0', :right)
				equivalent_codigo_juros_mora[code] || ''
			end
			# Código adotado pela FEBRABAN para identificação do tipo de pagamento de juros de mora.
			def equivalent_codigo_juros_mora
				{
					'1' => '1', # Valor por Dia
					'2' => '2', # Taxa Mensal
					'3' => '3', # Isento
				}
			end


			# Código do Desconto 1 / 2 / 3 :
			def get_codigo_desconto(code)
				"#{code}".adjust_size_to(1, '0', :right)
				equivalent_codigo_desconto[code] || ''
			end
			# Código adotado pela FEBRABAN para identificação do tipo de desconto que deverá ser concedido.
			def equivalent_codigo_desconto
				{
					'1' => '1', # Valor Fixo Até a Data Informada
					'2' => '2', # Percentual Até a Data Informada
					'3' => '3', # Valor por Antecipação Dia Corrido
					'4' => '4', # Valor por Antecipação Dia Úti
					'5' => '5', # Percentual Sobre o Valor Nominal Dia Corrido
					'6' => '6', # Percentual Sobre o Valor Nominal Dia Útil
					'7' => '7', # Cancelamento de Desconto
				}
			end

			# Código para Protesto :
			def get_codigo_protesto(code)
				"#{code}".adjust_size_to(1, '0', :right)
				equivalent_codigo_protesto[code] || ''
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


		end
	end
end