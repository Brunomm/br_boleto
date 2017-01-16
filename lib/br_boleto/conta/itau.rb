# encoding: utf-8
module BrBoleto
	module Conta
		class Itau < BrBoleto::Conta::Base

			# MODALIDADE CARTEIRA:
			#      _______________________________________________________________________
			#     | Carteira |  Descrição                                                |
			#		|	104     |  Escritural Eletrônica - Carnê                            |
			#		|	105     |  Escritural Eletrônica - Dólar - Carnê                    |
			#		|	107     |  Sem registro com emissão integral - 15 posições          |
			#		|	108     |  Direta eletrônica emissão integral – carnê               |
			#		|	109     |  Direta eletrônica sem emissão - simples                  |
			#		|	112     |  Escritural eletrônica - simples/contratual               |
			#		|	113     |  Escritural Eletrônica - TR - Carnê                       |
			#		|	116     |  Escritural Carnê com IOF 0,38%                           |
			#		|	117     |  Escritural Carnê com IOF 2,38%                           |
			#		|	119     |  Escritural Carnê com IOF 7,38%                           |
			#		|	121     |  Direta eletrônica emissão parcial - simples/contratual   |
			#		|	122     |  Sem registro - 15 posições                               |
			#		|	126     |  Direta Eletrônica Sem Emissão - Seguros                  |
			#		|	131     |  Direta Eletrônica com Valor em Aberto                    |
			#		|	134     |  Escritural com IOF 0,38%                                 |
			#		|	135     |  Escritural com IOF 2,38%                                 |
			#		|	136     |  Escritural com IOF 7,38%                                 |
			#		|	142     |  Sem registro - 15 posições                               |
			#		|	143     |  Sem registro - 15 posições                               |
			#		|	146     |  Direta eletrônica                                        |
			#		|	147     |  Escritural eletrônica – Dolar                            |
			#		|	150     |  Direta eletrônica sem emissão - Dolar                    |
			#		|	168     |  Direta eletrônica sem emissão - TR                       |
			#		|	169     |  Sem registro emissão Parcial Seguros C/IOF 7%            |
			#		|	174     |  Sem registro emissão parcial com protesto borderô        |
			#		|	175     |  Sem registro sem emissão com protesto eletrônico         |
			#		|	180     |  Direta Eletrônica emissão integral - simples/contratual  |
			#		|	191     |  Duplicatas - Transferência de Desconto                   |
			#		|	196     |  Sem registro com emissão e entrega – 15 posições         |
			#		|	198     |  Sem registro sem emissão 15 dígitos                      |
			#     ------------------------------------------------------------------------

			def default_values
				super.merge({
					carteira:                      '109', 			 
					valid_carteira_required:       true, # <- Validação dinâmica que a modalidade é obrigatória
					valid_carteira_length:         3,    # <- Validação dinâmica que a modalidade deve ter 2 digitos
					valid_carteira_inclusion:      carteiras_suportadas, # <- Validação dinâmica de valores aceitos para a modalidade
					codigo_carteira:               '1',   # Cobrança Simples
					valid_codigo_carteira_length:   1,    # <- Validação dinâmica que a modalidade deve ter 1 digito
					valid_conta_corrente_required: true,  # <- Validação dinâmica que a conta_corrente é obrigatória
					valid_conta_corrente_maximum:  5,     # <- Validação que a conta_corrente deve ter no máximo 7 digitos
					valid_convenio_required:       true,  # <- Validação que a convenio deve ter obrigatório
					valid_convenio_maximum:        5,     # <- Validação que a convenio deve ter no máximo 7 digitos
				})
			end

			def codigo_banco
				'341'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'7'
			end

			def nome_banco
				@nome_banco ||= 'ITAU'
			end

			def versao_layout_arquivo_cnab_240
				'040'
			end

			def versao_layout_lote_cnab_240
				'030'
			end

			def agencia_dv
				@agencia_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(agencia).to_s
			end

			# Dígito da conta corrente calculado apartir do Modulo10.
			def conta_corrente_dv
				@conta_corrente_dv ||= BrBoleto::Calculos::Modulo10.new("#{agencia}#{conta_corrente}").to_s
			end

			# Campo Agência / Código do Cedente
			# @return [String] Agência com 4 caracteres  / Conta de Cobrança com 5 caracteres - Digito da Conta
			# Exemplo: 9999 / 99999-D
			def agencia_codigo_cedente
				"#{agencia}/#{conta_corrente}-#{conta_corrente_dv}"
			end

      	# Carteiras suportadas
			def carteiras_suportadas
				%w[104 105 107 108 109 112 113 116 117 119 121 122 126 131 134 135 136 142 143 146 147 150 168 169 174 175 180 191 196 198]
			end

			# As carteiras de cobrança 107, 122, 142, 143, 196 e 198 são carteiras especiais,
			# na qual são utilizadas 15 posições numéricas para identificação do título
			# liquidado (8 do Nosso Número e 7 do Seu Número).
			def carteiras_especiais_codigo_barras
				%w(107 122 142 143 196 198)
			end

			# Carteiras que devem ser calculadas o módulo 10 usando carteira e número do documento.
			def carteiras_especiais_nosso_numero_dv
				%w(126 131 146 150 168)
			end

			# Espécie do Título
			def equivalent_especie_titulo_240
				super.merge(
					#  Padrão    Código para  
					{# da GEM     o Banco
						'02'    =>   '01' , # DUPLICATA MERCANTIL
						'12'    =>   '02' , # NOTA PROMISSÓRIA
						'16'    =>   '03' , # NOTA DE SEGURO
						'21'    =>   '04' , # MENSALIDADE ESCOLAR
						'17'    =>   '05' , # RECIBO
						'66'    =>   '06' , # CONTRATO
						'77'    =>   '07' , # COSSEGUROS
						'04'    =>   '08' , # DUPLICATA DE SERVIÇO
						'07'    =>   '09' , # LETRA DE CÂMBIO
						'19'    =>   '13' , # NOTA DE DÉBITOS
						'24'    =>   '15' , # DOCUMENTO DE DÍVIDA
						'30'    =>   '16' , # ENCARGOS CONDOMINIAIS
						'88'    =>   '17' , # CONTA DE PRESTAÇÃO DE SERVIÇOS
						'32'    =>   '18' , # BOLETO DE PROPOSTA
					})
			end
			def equivalent_especie_titulo_400
				super.merge(
					#  Padrão    Código para  
					{# da GEM     o Banco
						'02'    =>   '01' , # DUPLICATA MERCANTIL
						'12'    =>   '02' , # NOTA PROMISSÓRIA
						'16'    =>   '03' , # NOTA DE SEGURO
						'21'    =>   '04' , # MENSALIDADE ESCOLAR
						'17'    =>   '05' , # RECIBO
						'66'    =>   '06' , # CONTRATO
						'77'    =>   '07' , # COSSEGUROS
						'04'    =>   '08' , # DUPLICATA DE SERVIÇO
						'07'    =>   '09' , # LETRA DE CÂMBIO
						'19'    =>   '13' , # NOTA DE DÉBITOS
						'24'    =>   '15' , # DOCUMENTO DE DÍVIDA
						'30'    =>   '16' , # ENCARGOS CONDOMINIAIS
						'88'    =>   '17' , # CONTA DE PRESTAÇÃO DE SERVIÇOS
						'32'    =>   '18' , # BOLETO DE PROPOSTA
					})
			end

			# Códigos de Movimento Remessa / Identificacao Ocorrência específicos do Banco
			def equivalent_codigo_movimento_remessa_240
				super.merge(
					#  Padrão    Código para  
					{# da GEM     o Banco
						'10'   =>   '18' , # SUSTAR O PROTESTO
						'38'   =>   '38' , # BENEFICIÁRIO NÃO CONCORDA COM A ALEGAÇÃO DO PAGADOR CÓDIGO DA ALEGAÇÃO
						'41'   =>   '41' , # EXCLUSÃO DE SACADOR AVALISTA
						'66'   =>   '66' , # ENTRADA EM NEGATIVAÇÃO EXPRESSA
						'67'   =>   '67' , # NÃO NEGATIVAR (INIBE ENTRADA EM NEGATIVAÇÃO EXPRESSA
						'68'   =>   '68' , # EXCLUIR NEGATIVAÇÃO EXPRESSA (ATÉ 15 DIAS CORRIDOS APÓS A ENTRADA EM NEGATIVAÇÃO EXPRESSA)
						'69'   =>   '69' , # CANCELAR NEGATIVAÇÃO EXPRESSA (APÓS TÍTULO TER SIDO NEGATIVADO)
						'93'   =>   '93' , # DESCONTAR TÍTULOS ENCAMINHADOS NO DIA
					})
			end

			# Código para Protesto
			def equivalent_codigo_protesto
				super.merge(
					#  Padrão    Código para  
					{# da GEM     o Banco
						'0'    =>   '0' ,  # Sem instrução
						'07'   =>   '07' , # Negativar (Dias Corridos)
					})
			end

			# Código para Multa, que representa a isenção de juros e multa deve ser '0'
			# Diferentemente do padrão da FEBRABAN que é '3'
			# Ou seja, se passar o código 3 deve considerar '0'
			def equivalent_codigo_multa
				super.merge({ '3' => '0','0' => '0' }) # NÃO REGISTRA A MULTA
			end
			def default_codigo_multa
				'0'
			end

			# Codigo da carteira de acordo com a documentacao o Itau (Pag. 18, Nota 5)
        	# se a carteira nao forem as testadas (147, 150 e 191 )
			# retorna 'I' que é o codigo das carteiras restantes na documentacao
			def get_codigo_carteira
				equivalent_codigo_carteira[carteira] || 'I' 
			end
			def equivalent_codigo_carteira
				{
					'147' => 'E',  # ESCRITURAL ELETRÔNICA – DÓLAR
					'150' => 'U',  # DIRETA ELETRÔNICA SEM EMISSÃO – DÓLAR
					'191' => '1',  # DUPLICATAS - TRANSFERÊNCIA DE DESCONTO
				}
			end

			# Código de Movimento Retorno 
			def equivalent_codigo_movimento_retorno_240
				super.merge(
					#  Padrão    Código para  
					{# do Banco    a GEM
						'08'   =>   '101',  # LIQUIDAÇÃO EM CARTÓRIO
						'10'   =>   '210',  # BAIXA POR TER SIDO LIQUIDADO
						'15'   =>   '100',  # BAIXAS REJEITADAS
						'16'   =>   '26',   # INSTRUÇÕES REJEITADAS
						'17'   =>   '30',   # ALTERAÇÃO/EXCLUSÃO DE DADOS REJEITADA 
						'18'   =>   '218',  # COBRANÇA CONTRATUAL – INSTRUÇÕES/ALTERAÇÕES REJEITADAS/PENDENTES
						'21'   =>   '221',  # CONFIRMAÇÃO RECEBIMENTO DE INSTRUÇÃO DE NÃO PROTESTAR
						'25'   =>   '225',  # ALEGAÇÕES DO PAGADOR
						'26'   =>   '226',  # TARIFA DE AVISO DE COBRANÇA
						'27'   =>   '227',  # TARIFA DE EXTRATO POSIÇÃO (B40X)
						'28'   =>   '228',  # TARIFA DE RELAÇÃO DAS LIQUIDAÇÕES
						'29'   =>   '107',  # TARIFA DE MANUTENÇÃO DE TÍTULOS VENCIDOS
						'30'   =>   '28',   # DÉBITO MENSAL DE TARIFAS (PARA ENTRADAS E BAIXAS)
						'32'   =>   '25',   # BAIXA POR TER SIDO PROTESTADO
						'33'   =>   '233',  # CUSTAS DE PROTESTO
						'34'   =>   '234',  # CUSTAS DE SUSTAÇÃO
						'35'   =>   '235',  # CUSTAS DE CARTÓRIO DISTRIBUIDOR
						'36'   =>   '236',  # CUSTAS DE EDITAL
						'37'   =>   '237',  # TARIFA DE EMISSÃO DE BOLETO/TARIFA DE ENVIO DE DUPLICATA
						'38'   =>   '238',  # TARIFA DE INSTRUÇÃO
						'39'   =>   '239',  # TARIFA DE OCORRÊNCIAS
						'40'   =>   '240',  # TARIFA MENSAL DE EMISSÃO DE BOLETO/TARIFA MENSAL DE ENVIO DE DUPLICATA
						'41'   =>   '241',  # DÉBITO MENSAL DE TARIFAS – EXTRATO DE POSIÇÃO (B4EP/B4OX)
						'42'   =>   '242',  # DÉBITO MENSAL DE TARIFAS – OUTRAS INSTRUÇÕES
						'43'   =>   '243',  # DÉBITO MENSAL DE TARIFAS – MANUTENÇÃO DE TÍTULOS VENCIDOS
						'44'   =>   '244',  # DÉBITO MENSAL DE TARIFAS – OUTRAS OCORRÊNCIAS
						'45'   =>   '245',  # DÉBITO MENSAL DE TARIFAS – PROTESTO
						'46'   =>   '246',  # DÉBITO MENSAL DE TARIFAS – SUSTAÇÃO DE PROTESTO
						'47'   =>   '247',  # BAIXA COM TRANSFERÊNCIA PARA DESCONTO
						'48'   =>   '248',  # CUSTAS DE SUSTAÇÃO JUDICIAL
						'51'   =>   '251',  # TARIFA MENSAL REFERENTE A ENTRADAS BANCOS CORRESPONDENTES NA CARTEIRA
						'52'   =>   '252',  # TARIFA MENSAL BAIXAS NA CARTEIRA
						'53'   =>   '253',  # TARIFA MENSAL BAIXAS EM BANCOS CORRESPONDENTES NA CARTEIRA
						'54'   =>   '254',  # TARIFA MENSAL DE LIQUIDAÇÕES NA CARTEIRA
						'55'   =>   '255',  # TARIFA MENSAL DE LIQUIDAÇÕES EM BANCOS CORRESPONDENTES NA CARTEIRA
						'56'   =>   '256',  # CUSTAS DE IRREGULARIDADE
						'57'   =>   '257',  # INSTRUÇÃO CANCELADA
						'60'   =>   '260',  # ENTRADA REJEITADA CARNÊ
						'61'   =>   '261',  # TARIFA EMISSÃO AVISO DE MOVIMENTAÇÃO DE TÍTULOS (2154)
						'62'   =>   '262',  # DÉBITO MENSAL DE TARIFA – AVISO DE MOVIMENTAÇÃO DE TÍTULOS (2154)
						'74'   =>   '274',  # INSTRUÇÃO DE NEGATIVAÇÃO EXPRESSA REJEITADA
						'75'   =>   '275',  # CONFIRMA O RECEBIMENTO DE INSTRUÇÃO DE ENTRADA EM NEGATIVAÇÃO EXPRESSA
						'77'   =>   '277',  # CONFIRMA O RECEBIMENTO DE INSTRUÇÃO DE EXCLUSÃO DE ENTRADA EM NEGATIVAÇÃO EXPRESSA
						'78'   =>   '278',  # CONFIRMA O RECEBIMENTO DE INSTRUÇÃO DE CANCELAMENTO DA NEGATIVAÇÃO EXPRESSA
						'79'   =>   '279',  # NEGATIVAÇÃO EXPRESSA INFORMACIONAL
						'80'   =>   '280',  # CONFIRMAÇÃO DE ENTRADA EM NEGATIVAÇÃO EXPRESSA – TARIFA
						'82'   =>   '282',  # CONFIRMAÇÃO O CANCELAMENTO DE NEGATIVAÇÃO EXPRESSA - TARIFA
						'83'   =>   '283',  # CONFIRMAÇÃO DA EXCLUSÃO/CANCELAMENTO DA NEGATIVAÇÃO EXPRESSA POR LIQUIDAÇÃO - TARIFA
						'85'   =>   '285',  # TARIFA POR BOLETO (ATÉ 03 ENVIOS) COBRANÇA ATIVA ELETRÔNICA
						'86'   =>   '286',  # TARIFA EMAIL COBRANÇA ATIVA ELETRÔNICA
						'87'   =>   '287',  # TARIFA SMS COBRANÇA ATIVA ELETRÔNICA
						'88'   =>   '288',  # TARIFA MENSAL POR BOLETO (ATÉ 03 ENVIOS) COBRANÇA ATIVA ELETRÔNICA
						'89'   =>   '289',  # TARIFA MENSAL EMAIL COBRANÇA ATIVA ELETRÔNICA
						'90'   =>   '290',  # TARIFA MENSAL SMS COBRANÇA ATIVA ELETRÔNICA
						'91'   =>   '291',  # TARIFA MENSAL DE EXCLUSÃO DE ENTRADA EM NEGATIVAÇÃO EXPRESSA
						'92'   =>   '292',  # TARIFA MENSAL DE CANCELAMENTO DE NEGATIVAÇÃO EXPRESSA
						'93'   =>   '293',  # TARIFA MENSAL DE EXCLUSÃO/CANCELAMENTO DE NEGATIVAÇÃO EXPRESSA POR LIQUIDAÇÃO
						'94'   =>   '294',  # CONFIRMA RECEBIMENTO DE INSTRUÇÃO DE NÃO NEGATIVAR
					})
			end

			# Identificações de Ocorrência / Código de ocorrência:
			def equivalent_codigo_movimento_retorno_400
				super.merge(
					#  Padrão    Código para  
					{# do Banco    a GEM
						'07'   =>   '102',  # LIQUIDAÇÃO PARCIAL – COBRANÇA INTELIGENTE (B2B)
						'24'   =>   '20',   # INSTRUÇÃO DE PROTESTO REJEITADA / SUSTADA / PENDENTE (NOTA 20 – TABELA 7)
						'25'   =>   '29',   # ALEGAÇÕES DO PAGADOR (NOTA 20 – TABELA 6)
						'59'   =>   '259',  # BAIXA POR CRÉDITO EM C/C ATRAVÉS DO SISPAG
						'64'   =>   '264',  # ENTRADA CONFIRMADA COM RATEIO DE CRÉDITO
						'65'   =>   '265',  # PAGAMENTO COM CHEQUE – AGUARDANDO COMPENSAÇÃO
						'69'   =>   '44',   # CHEQUE DEVOLVIDO (NOTA 20 – TABELA 9)
						'71'   =>   '271',  # ENTRADA REGISTRADA, AGUARDANDO AVALIAÇÃO
						'72'   =>   '272',  # BAIXA POR CRÉDITO EM C/C ATRAVÉS DO SISPAG SEM TÍTULO CORRESPONDENTE
						'73'   =>   '273',  # CONFIRMAÇÃO DE ENTRADA NA COBRANÇA SIMPLES – ENTRADA NÃO ACEITA NA COBRANÇA CONTRATUAL
						'76'   =>   '45',   # CHEQUE COMPENSADO
					})
			end

			# Código do Motivo da Ocorrência Retorno
			def equivalent_codigo_motivo_ocorrencia_A_240 codigo_movimento_gem
				case codigo_movimento_gem
				when '03'
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'03'   =>   'A49',  # CEP INVÁLIDO OU NÃO FOI POSSÍVEL ATRIBUIR A AGÊNCIA PELO CEP 
							'04'   =>   'A52',  # SIGLA DO ESTADO INVÁLIDA
							'08'   =>   'A45',  # NÃO INFORMADO OU DESLOCADO
							'09'   =>   'A07',  # AGÊNCIA ENCERRADA
							'10'   =>   'A47',  # NÃO INFORMADO OU DESLOCADO
							'11'   =>   'A49',  # CEP NÃO NUMÉRICO
							'12'   =>   'A54',  # NOME NÃO INFORMADO OU DESLOCADO (BANCOS CORRESPONDENTES)
							'13'   =>   'A51',  # CEP INCOMPATÍVEL COM A SIGLA DO ESTADO
							'14'   =>   'A08',  # NOSSO NÚMERO JÁ REGISTRADO NO CADASTRO DO BANCO OU FORA DA FAIXA
							'15'   =>   'A09',  # NOSSO NÚMERO EM DUPLICIDADE NO MESMO MOVIMENTO
							'35'   =>   'A32',  # IOF MAIOR QUE 5%
							'42'   =>   'A08',  # NOSSO NÚMERO FORA DE FAIXA
							'60'   =>   'A33',  # VALOR DO ABATIMENTO INVÁLIDO
							'62'   =>   'A29',  # VALOR DO DESCONTO MAIOR QUE O VALOR DO TÍTULO
							'64'   =>   'A24',  # DATA DE EMISSÃO DO TÍTULO INVÁLIDA (VENDOR)
							'66'   =>   'A74',  # INVALIDA/FORA DE PRAZO DE OPERAÇÃO (MÍNIMO OU MÁXIMO)
							'67'   =>   'A20',  # VALOR DO TÍTULO/QUANTIDADE DE MOEDA INVÁLIDO
							'68'   =>   'A10',  # CARTEIRA INVÁLIDA OU NÃO CADASTRADA NO INTERCÂMBIO DA COBRANÇA
						})
				when '26'
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'09'   =>   'A53',  # CNPJ/CPF DO SACADOR/AVALISTA INVÁLIDO
							'15'   =>   'A54',  # CNPJ/CPF INFORMADO SEM NOME DO SACADOR/AVALISTA
							'19'   =>   'A34',  # VALOR DO ABATIMENTO MAIOR QUE 90% DO VALOR DO TÍTULO
							'20'   =>   'A41',  # EXISTE SUSTACAO DE PROTESTO PENDENTE PARA O TITULO
							'22'   =>   'A106', # TÍTULO BAIXADO OU LIQUIDADO
							'50'   =>   'A24',  # DATA DE EMISSÃO DO TÍTULO INVÁLIDA
						})
				when '30'
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'11'   =>   'A48',  # CEP INVÁLIDO
							'12'   =>   'A53',  # NÚMERO INSCRIÇÃO INVÁLIDO DO SACADOR AVALISTA
							'13'   =>   'A86',  # SEU NÚMERO COM O MESMO CONTEÚDO
							'67'   =>   'A317',  # NOME INVÁLIDO DO SACADOR AVALISTA
							'72'   =>   'A318',  # ENDEREÇO INVÁLIDO – SACADOR AVALISTA
							'73'   =>   'A319',  # BAIRRO INVÁLIDO – SACADOR AVALISTA
							'74'   =>   'A320',  # CIDADE INVÁLIDA – SACADOR AVALISTA
							'75'   =>   'A321',  # SIGLA ESTADO INVÁLIDO – SACADOR AVALISTA
							'76'   =>   'A322',  # CEP INVÁLIDO – SACADOR AVALISTA
						})
				else
					super(codigo_movimento_gem)
				end
			end
			def equivalent_codigo_motivo_ocorrencia_C_240 codigo_movimento_gem
				super.merge(
					#  Padrão    Código para  
					{# do Banco    a GEM
						'AA'  =>   'C32',   # CAIXA ELETRÔNICO ITAÚ
						'AC'  =>   'C08',   # PAGAMENTO EM CARTÓRIO AUTOMATIZADO
						'AO'  =>   'C135',  # ACERTO ONLINE
						'BC'  =>   'C31',   # BANCOS CORRESPONDENTES
						'BF'  =>   'C37',   # ITAÚ BANKFONE
						'BL'  =>   'C33',   # ITAÚ BANKLINE
						'B0'  =>   'C136',  # OUTROS BANCOS – RECEBIMENTO OFF-LINE
						'B1'  =>   'C137',  # OUTROS BANCOS – PELO CÓDIGO DE BARRAS
						'B2'  =>   'C138',  # OUTROS BANCOS – PELA LINHA DIGITÁVEL
						'B3'  =>   'C139',  # OUTROS BANCOS – PELO AUTO ATENDIMENTO
						'B4'  =>   'C140',  # OUTROS BANCOS – RECEBIMENTO EM CASA LOTÉRICA
						'B5'  =>   'C141',  # OUTROS BANCOS – CORRESPONDENTE
						'B6'  =>   'C142',  # OUTROS BANCOS – TELEFONE
						'B7'  =>   'C143',  # OUTROS BANCOS – ARQUIVO ELETRÔNICO (PAGAMENTO EFETUADO POR MEIO DE TROCA DE ARQUIVOS)
						'CC'  =>   'C36',   # AGÊNCIA ITAÚ – COM CHEQUE DE OUTRO BANCO ou (CHEQUE ITAÚ)
						'CI'  =>   'C144',  # CORRESPONDENTE ITAÚ
						'CK'  =>   'C145',  # SISPAG – SISTEMA DE CONTAS A PAGAR ITAÚ
						'CP'  =>   'C146',  # AGÊNCIA ITAÚ – POR DÉBITO EM CONTA CORRENTE, CHEQUE ITAÚ* OU DINHEIRO
						'DG'  =>   'C147',  # AGÊNCIA ITAÚ – CAPTURADO EM OFF-LINE
						'LC'  =>   'C148',  # PAGAMENTO EM CARTÓRIO DE PROTESTO COM CHEQUE
						'EA'  =>   'C03',   # TERMINAL DE CAIXA
						'Q0'  =>   'C149',  # AGENDAMENTO – PAGAMENTO AGENDADO VIA BANKLINE OU OUTRO CANAL ELETRÔNICO E LIQUIDADO NA DATA INDICADA
						'RA'  =>   'C150',  # DIGITAÇÃO – REALIMENTAÇÃO AUTOMÁTICA
						'ST'  =>   'C151',  # PAGAMENTO VIA SELTEC
				})
			end

			def codigos_movimento_retorno_para_ocorrencia_A_400
				%w[02 03 26 30 100 218]
			end
			def equivalent_codigo_motivo_ocorrencia_A_400 codigo_movimento_gem
				case codigo_movimento_gem
				when '02'
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'01'   =>   'A240',   # CEP SEM ATENDIMENTO DE PROTESTO NO MOMENTO
							'02'   =>   'A241',   # ESTADO COM DETERMINAÇÃO LEGAL QUE IMPEDE A INSCRIÇÃO DE INADIMPLENTES
						})
				when '03'
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'03'   =>   'A240',  # CEP SEM ATENDIMENTO DE PROTESTO NO MOMENTO
							'04'   =>   'A52',   # SIGLA DO ESTADO INVÁLIDA
							'05'   =>   'A241',  # DATA VENCIMENTO COM PRAZO DA OPERAÇÃO MENOR QUE PRAZO MÍNIMO OU MAIOR QUE O MÁXIMO
							'07'   =>   'A242',  # VALOR DO TÍTULO MAIOR QUE 10.000.000,00
							'08'   =>   'A45',   # OME DO PAGADOR NÃO INFORMADO OU DESLOCADO
							'09'   =>   'A17',   # AGÊNCIA ENCERRADA
							'10'   =>   'A47',   # LOGRADOURO NÃO INFORMADO OU DESLOCADO
							'11'   =>   'A49',   # CEP NÃO NUMÉRICO OU CEP INVÁLIDO
							'12'   =>   'A54',   # SACADOR / AVALISTA NOME NÃO INFORMADO OU DESLOCADO (BANCOS CORRESPONDENTES)
							'13'   =>   'A51',   # CEP INCOMPATÍVEL COM A SIGLA DO ESTADO
							'14'   =>   'A08',   # NOSSO NÚMERO JÁ REGISTRADO NO CADASTRO DO BANCO OU FORA DA FAIXA
							'15'   =>   'A09',   # NOSSO NÚMERO EM DUPLICIDADE NO MESMO MOVIMENTO
							'18'   =>   'A243',  # DATA DE ENTRADA INVÁLIDA PARA OPERAR COM ESTA CARTEIRA
							'19'   =>   'A244',  # OCORRÊNCIA INVÁLIDA
							'21'   =>   'A245',  # CARTEIRA NÃO ACEITA DEPOSITÁRIA CORRESPONDENTE ESTADO DA AGÊNCIA DIFERENTE DO ESTADO DO PAGADOR AG. COBRADORA NÃO CONSTA NO CADASTRO OU ENCERRANDO
							'22'   =>   'A246',  # CARTEIRA NÃO PERMITIDA (NECESSÁRIO CADASTRAR FAIXA LIVRE)
							'26'   =>   'A247',  # AGÊNCIA/CONTA NÃO LIBERADA PARA OPERAR COM COBRANÇA
							'27'   =>   'A248',  # CNPJ DO BENEFICIÁRIO INAPTO DEVOLUÇÃO DE TÍTULO EM GARANTIA
							'29'   =>   'A249',  # CATEGORIA DA CONTA INVÁLIDA
							'30'   =>   'A250',  # ENTRADAS BLOQUEADAS, CONTA SUSPENSA EM COBRANÇA
							'31'   =>   'A251',  # CONTA NÃO TEM PERMISSÃO PARA PROTESTAR (CONTATE SEU GERENTE)
							'35'   =>   'A32',   # IOF MAIOR QUE 5%
							'36'   =>   'A252',  # QUANTIDADE DE MOEDA INCOMPATÍVEL COM VALOR DO TÍTULO
							'37'   =>   'A253',  # CNPJ/CPF DO PAGADOR NÃO NUMÉRICO OU IGUAL A ZEROS
							'42'   =>   'A08',   # NOSSO NÚMERO FORA DE FAIXA
							'52'   =>   'A254',  # EMPRESA NÃO ACEITA BANCO CORRESPONDENTE
							'53'   =>   'A255',  # EMPRESA NÃO ACEITA BANCO CORRESPONDENTE - COBRANÇA MENSAGEM
							'54'   =>   'A256',  # BANCO CORRESPONDENTE - TÍTULO COM VENCIMENTO INFERIOR A 15 DIAS
							'55'   =>   'A257',  # CEP NÃO PERTENCE À DEPOSITÁRIA INFORMADA
							'56'   =>   'A258',  # CORRESP VENCTO SUPERIOR A 180 DIAS DA DATA DE ENTRADA
							'57'   =>   'A259',  # CEP SÓ DEPOSITÁRIA BCO DO BRASIL COM VENCTO INFERIOR A 8 DIAS
							'60'   =>   'A33',   # VALOR DO ABATIMENTO INVÁLIDO
							'61'   =>   'A260',  # JUROS DE MORA MAIOR QUE O PERMITIDO
							'62'   =>   'A29',   # VALOR DO DESCONTO MAIOR QUE VALOR DO TÍTULO
							'63'   =>   'A261',  # DESCONTO DE ANTECIPAÇÃO, VALOR DA IMPORTÂNCIA POR DIA DE DESCONTO (IDD) NÃO PERMITIDO
							'64'   =>   'A24',   # DATA DE EMISSÃO DO TÍTULO INVÁLIDA
							'65'   =>   'A262',  # TAXA INVÁLIDA (VENDOR)
							'66'   =>   'A74',   # INVALIDA/FORA DE PRAZO DE OPERAÇÃO (MÍNIMO OU MÁXIMO)
							'67'   =>   'A20',   # VALOR DO TÍTULO/QUANTIDADE DE MOEDA INVÁLIDO
							'68'   =>   'A10',   # CARTEIRA INVÁLIDA OU NÃO CADASTRADA NO INTERCÂMBIO DA COBRANÇA
							'69'   =>   'A263',  # CARTEIRA INVÁLIDA PARA TÍTULOS COM RATEIO DE CRÉDITO
							'70'   =>   'A264',  # BENEFICIÁRIO NÃO CADASTRADO PARA FAZER RATEIO DE CRÉDITO
							'78'   =>   'A265',  # DUPLICIDADE DE AGÊNCIA/CONTA BENEFICIÁRIA DO RATEIO DE CRÉDITO
							'80'   =>   'A266',  # QUANTIDADE DE CONTAS BENEFICIÁRIAS DO RATEIO MAIOR DO QUE O PERMITIDO (MÁXIMO DE 30 CONTAS POR TÍTULO)
							'81'   =>   'A267',  # CONTA PARA RATEIO DE CRÉDITO INVÁLIDA / NÃO PERTENCE AO ITAÚ
							'82'   =>   'A268',  # DESCONTO/ABATIMENTO NÃO PERMITIDO PARA TÍTULOS COM RATEIO DE CRÉDITO
							'83'   =>   'A269',  # VALOR DO TÍTULO MENOR QUE A SOMA DOS VALORES ESTIPULADOS PARA RATEIO
							'84'   =>   'A270',  # AGÊNCIA/CONTA BENEFICIÁRIA DO RATEIO É A CENTRALIZADORA DE CRÉDITO DO BENEFICIÁRIO
							'85'   =>   'A271',  # AGÊNCIA/CONTA DO BENEFICIÁRIO É CONTRATUAL / RATEIO DE CRÉDITO NÃO PERMITIDO
							'86'   =>   'A272',  # CÓDIGO DO TIPO DE VALOR INVÁLIDO / NÃO PREVISTO PARA TÍTULOS COM RATEIO DE CRÉDITO
							'87'   =>   'A273',  # REGISTRO TIPO 4 SEM INFORMAÇÃO DE AGÊNCIAS/CONTAS BENEFICIÁRIAS DO RATEIO
							'90'   =>   'A274',  # COBRANÇA MENSAGEM - NÚMERO DA LINHA DA MENSAGEM INVÁLIDO OU QUANTIDADE DE LINHAS EXCEDIDAS
							'97'   =>   'A275',  # COBRANÇA MENSAGEM SEM MENSAGEM (SÓ DE CAMPOS FIXOS), PORÉM COM REGISTRO DO TIPO 7 OU 8
							'98'   =>   'A276',  # REGISTRO MENSAGEM SEM FLASH CADASTRADO OU FLASH INFORMADO DIFERENTE DO CADASTRADO
							'99'   =>   'A277',  # CONTA DE COBRANÇA COM FLASH CADASTRADO E SEM REGISTRO DE MENSAGEM CORRESPONDENTE
						})
				when '26'
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'01'   =>   'A278',  # INSTRUÇÃO/OCORRÊNCIA NÃO EXISTENTE
							'03'   =>   'A251',  # CONTA NÃO TEM PERMISSÃO PARA PROTESTAR (CONTATE SEU GERENTE)
							'06'   =>   'A279',  # NOSSO NÚMERO IGUAL A ZEROS
							'09'   =>   'A53',   # CNPJ/CPF DO SACADOR/AVALISTA INVÁLIDO
							'10'   =>   'A34',   # VALOR DO ABATIMENTO IGUAL OU MAIOR QUE O VALOR DO TÍTULO
							'11'   =>   'A280',  # SEGUNDA INSTRUÇÃO/OCORRÊNCIA NÃO EXISTENTE
							'14'   =>   'A281',  # REGISTRO EM DUPLICIDADE
							'15'   =>   'A54',   # CNPJ/CPF INFORMADO SEM NOME DO SACADOR/AVALISTA
							'19'   =>   'A34',   # VALOR DO ABATIMENTO MAIOR QUE 90% DO VALOR DO TÍTULO
							'20'   =>   'A41',   # EXISTE SUSTACAO DE PROTESTO PENDENTE PARA O TITULO
							'21'   =>   'A282',  # TÍTULO NÃO REGISTRADO NO SISTEMA
							'22'   =>   'A106',  # TÍTULO BAIXADO OU LIQUIDADO
							'23'   =>   'A283',  # INSTRUÇÃO NÃO ACEITA
							'24'   =>   'A284',  # INSTRUÇÃO INCOMPATÍVEL – EXISTE INSTRUÇÃO DE PROTESTO PARA O TÍTULO
							'25'   =>   'A285',  # INSTRUÇÃO INCOMPATÍVEL – NÃO EXISTE INSTRUÇÃO DE PROTESTO PARA O TÍTULO
							'26'   =>   'A286',  # INSTRUÇÃO NÃO ACEITA POR JÁ TER SIDO EMITIDA A ORDEM DE PROTESTO AO CARTÓRIO
							'27'   =>   'A287',  # INSTRUÇÃO NÃO ACEITA POR NÃO TER SIDO EMITIDA A ORDEM DE PROTESTO AO CARTÓRIO
							'28'   =>   'A288',  # JÁ EXISTE UMA MESMA INSTRUÇÃO CADASTRADA ANTERIORMENTE PARA O TÍTULO
							'29'   =>   'A289',  # VALOR LÍQUIDO + VALOR DO ABATIMENTO DIFERENTE DO VALOR DO TÍTULO REGISTRADO
							'30'   =>   'A290',  # EXISTE UMA INSTRUÇÃO DE NÃO PROTESTAR ATIVA PARA O TÍTULO
							'31'   =>   'A291',  # EXISTE UMA OCORRÊNCIA DO PAGADOR QUE BLOQUEIA A INSTRUÇÃO
							'32'   =>   'A292',  # DEPOSITÁRIA DO TÍTULO = 9999 OU CARTEIRA NÃO ACEITA PROTESTO
							'33'   =>   'A293',  # ALTERAÇÃO DE VENCIMENTO IGUAL À REGISTRADA NO SISTEMA OU QUE TORNA O TÍTULO VENCIDO
							'34'   =>   'A294',  # INSTRUÇÃO DE EMISSÃO DE AVISO DE COBRANÇA PARA TÍTULO VENCIDO ANTES DO VENCIMENTO
							'35'   =>   'A295',  # SOLICITAÇÃO DE CANCELAMENTO DE INSTRUÇÃO INEXISTENTE
							'36'   =>   'A296',  # TÍTULO SOFRENDO ALTERAÇÃO DE CONTROLE (AGÊNCIA/CONTA/CARTEIRA/NOSSO NÚMERO)
							'37'   =>   'A297',  # INSTRUÇÃO NÃO PERMITIDA PARA A CARTEIRA
							'38'   =>   'A298',  # INSTRUÇÃO NÃO PERMITIDA PARA TÍTULO COM RATEIO DE CRÉDITO
							'40'   =>   'A299',  # INSTRUÇÃO INCOMPATÍVEL – NÃO EXISTE INSTRUÇÃO DE NEGATIVAÇÃO EXPRESSA PARA O TÍTULO
							'41'   =>   'A300',  # INSTRUÇÃO NÃO PERMITIDA – TÍTULO COM ENTRADA EM NEGATIVAÇÃO EXPRESSA
							'42'   =>   'A301',  # INSTRUÇÃO NÃO PERMITIDA – TÍTULO COM NEGATIVAÇÃO EXPRESSA CONCLUÍDA
							'43'   =>   'A302',  # PRAZO INVÁLIDO PARA NEGATIVAÇÃO EXPRESSA – MÍNIMO: 02 DIAS CORRIDOS APÓS O VENCIMENTO
							'45'   =>   'A303',  # INSTRUÇÃO INCOMPATÍVEL PARA O MESMO TÍTULO NESTA DATA
							'47'   =>   'A21',   # INSTRUÇÃO NÃO PERMITIDA – ESPÉCIE INVÁLIDA
							'48'   =>   'A46',   # DADOS DO PAGADOR INVÁLIDOS ( CPF / CNPJ / NOME )
							'49'   =>   'A47',   # DADOS DO ENDEREÇO DO PAGADOR INVÁLIDOS
							'50'   =>   'A24',   # DATA DE EMISSÃO DO TÍTULO INVÁLIDA
							'51'   =>   'A305',  # INSTRUÇÃO NÃO PERMITIDA – TÍTULO COM NEGATIVAÇÃO EXPRESSA AGENDADA

						})
				when '30'
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'02'   =>    'A61',   # AGÊNCIA COBRADORA INVÁLIDA OU COM O MESMO CONTEÚDO
							'04'   =>    'A52',   # SIGLA DO ESTADO INVÁLIDA
							'05'   =>    'A16',   # DATA DE VENCIMENTO INVÁLIDA OU COM O MESMO CONTEÚDO
							'06'   =>    'A306',  # VALOR DO TÍTULO COM OUTRA ALTERAÇÃO SIMULTÂNEA
							'08'   =>    'A45',   # NOME DO PAGADOR COM O MESMO CONTEÚDO
							'09'   =>    'A07',   # AGÊNCIA/CONTA INCORRETA
							'11'   =>    'A48',   # CEP INVÁLIDO
							'12'   =>    'A53',   # NÚMERO INSCRIÇÃO INVÁLIDO DO SACADOR AVALISTA
							'13'   =>    'A86',   # SEU NÚMERO COM O MESMO CONTEÚDO
							'16'   =>    'A307',  # ABATIMENTO/ALTERAÇÃO DO VALOR DO TÍTULO OU SOLICITAÇÃO DE BAIXA BLOQUEADA
							'20'   =>    'A21',   # ESPÉCIE INVÁLIDA
							'21'   =>    'A308',  # AGÊNCIA COBRADORA NÃO CONSTA NO CADASTRO DE DEPOSITÁRIA OU EM ENCERRAMENTO
							'23'   =>    'A24',   # DATA DE EMISSÃO DO TÍTULO INVÁLIDA OU COM MESMO CONTEÚDO
							'41'   =>    'A23',   # CAMPO ACEITE INVÁLIDO OU COM MESMO CONTEÚDO
							'42'   =>    'A309',  # ALTERAÇÃO INVÁLIDA PARA TÍTULO VENCIDO
							'43'   =>    'A310',  # ALTERAÇÃO BLOQUEADA – VENCIMENTO JÁ ALTERADO
							'53'   =>    'A311',  # INSTRUÇÃO COM O MESMO CONTEÚDO
							'54'   =>    'A312',  # DATA VENCIMENTO PARA BANCOS CORRESPONDENTES INFERIOR AO ACEITO PELO BANCO
							'55'   =>    'A313',  # ALTERAÇÕES IGUAIS PARA O MESMO CONTROLE (AGÊNCIA/CONTA/CARTEIRA/NOSSO NÚMERO)
							'56'   =>    'A06',   # CNPJ/CPF INVÁLIDO NÃO NUMÉRICO OU ZERADO
							'57'   =>    'A314',  # PRAZO DE VENCIMENTO INFERIOR A 15 DIAS
							'60'   =>    'A315',  # VALOR DE IOF – ALTERAÇÃO NÃO PERMITIDA PARA CARTEIRAS DE N.S. – MOEDA VARIÁVEL
							'61'   =>    'A104',  # TÍTULO JÁ BAIXADO OU LIQUIDADO OU NÃO EXISTE TÍTULO CORRESPONDENTE NO SISTEMA
							'66'   =>    'A316',  # ALTERAÇÃO NÃO PERMITIDA PARA CARTEIRAS DE NOTAS DE SEGUROS – MOEDA VARIÁVEL
							'67'   =>    'A317',  # NOME INVÁLIDO DO SACADOR AVALISTA
							'72'   =>    'A318',  # ENDEREÇO INVÁLIDO – SACADOR AVALISTA
							'73'   =>    'A319',  # BAIRRO INVÁLIDO – SACADOR AVALISTA
							'74'   =>    'A320',  # CIDADE INVÁLIDA – SACADOR AVALISTA
							'75'   =>    'A321',  # SIGLA ESTADO INVÁLIDO – SACADOR AVALISTA
							'76'   =>    'A322',  # CEP INVÁLIDO – SACADOR AVALISTA
							'81'   =>    'A323',  # ALTERAÇÃO BLOQUEADA – TÍTULO COM NEGATIVAÇÃO EXPRESSA / PROTESTO
							'87'   =>    'A324',  # ALTERAÇÃO BLOQUEADA – TÍTULO COM RATEIO DE CRÉDITO
						})
				when '100'
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'01'   =>   'A10', # CARTEIRA/No NÚMERO NÃO NUMÉRICO
							'04'   =>   'A09', # NOSSO NÚMERO EM DUPLICIDADE NO MESMO MOVIMENTO
							'05'   =>   'A325', # SOLICITAÇÃO DE BAIXA PARA TÍTULO JÁ BAIXADO OU LIQUIDADO
							'06'   =>   'A326', # SOLICITAÇÃO DE BAIXA PARA TÍTULO NÃO REGISTRADO NO SISTEMA
							'07'   =>   'A327', # COBRANÇA PRAZO CURTO – SOLICITAÇÃO DE BAIXA P/ TÍTULO NÃO REGISTRADO NO SISTEMA
							'08'   =>   'A328', # SOLICITAÇÃO DE BAIXA PARA TÍTULO EM FLOATING
							'10'   =>   'A329', # VALOR DO TITULO FAZ PARTE DE GARANTIA DE EMPRESTIMO
							'11'   =>   'A330', # PAGO ATRAVÉS DO SISPAG POR CRÉDITO EM C/C E NÃO BAIXADO
						})				
				when '218'
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'16'   =>   'A307', # ABATIMENTO/ALTERAÇÃO DO VALOR DO TÍTULO OU SOLICITAÇÃO DE BAIXA BLOQUEADOS
							'40'   =>   'A331', # NÃO APROVADA DEVIDO AO IMPACTO NA ELEGIBILIDADE DE GARANTIAS
							'41'   =>   'A332', # AUTOMATICAMENTE REJEITADA
							'42'   =>   'A304', # CONFIRMA RECEBIMENTO DE INSTRUÇÃO – PENDENTE DE ANÁLISE
						})
				else
					super
				end
			end

			def equivalent_codigo_ocorrencia_pagador_240
				super.merge(
					#  Padrão    Código para  
					{# do Banco    a GEM
						'1313' => '0302',  # SOLICITA A PRORROGAÇÃO DO VENCIMENTO PARA:
						'1321' => '0503',  # SOLICITA A DISPENSA DOS JUROS DE MORA
						'1339' => '0101',  # NÃO RECEBEU A MERCADORIA
						'1347' => '0102',  # A MERCADORIA CHEGOU ATRASADA
						'1354' => '0103',  # A MERCADORIA CHEGOU AVARIADA
						'1362' => '0105',  # A MERCADORIA CHEGOU INCOMPLETA
						'1370' => '0104',  # A MERCADORIA NÃO CONFERE COM O PEDIDO
						'1388' => '0106',  # A MERCADORIA ESTÁ À DISPOSIÇÃO
						'1396' => '0107',  # DEVOLVEU A MERCADORIA
						'1404' => '0201',  # NÃO RECEBEU A FATURA
						'1412' => '0108',  # A FATURA ESTÁ EM DESACORDO COM A NOTA FISCAL
						'1420' => '0202',  # O PEDIDO DE COMPRA FOI CANCELADO
						'1438' => '0203',  # A DUPLICATA FOI CANCELADA
						'1446' => '0109',  # QUE NADA DEVE OU COMPROU
						'1453' => '0603',  # QUE MANTÉM ENTENDIMENTOS COM O SACADOR
						'1461' => '0304',  # QUE PAGARÁ O TÍTULO EM:
						'1479' => '0305',  # QUE PAGOU O TÍTULO DIRETAMENTE AO BENEFICIÁRIO EM:
						'1487' => '0306',  # QUE PAGARÁ O TÍTULO DIRETAMENTE AO BENEFICIÁRIO EM:
						'1495' => '0301',  # QUE O VENCIMENTO CORRETO É:
						'1503' => '0501',  # QUE TEM DESCONTO OU ABATIMENTO DE:
						'1719' => '0401',  # PAGADOR NÃO FOI LOCALIZADO; CONFIRMAR ENDEREÇO
						'1727' => '0601',  # PAGADOR ESTÁ EM REGIME DE CONCORDATA
						'1735' => '0602',  # PAGADOR ESTÁ EM REGIME DE FALÊNCIA
						'1750' => '0504',  # PAGADOR SE RECUSA A PAGAR JUROS BANCÁRIOS
						'1768' => '0505',  # PAGADOR SE RECUSA A PAGAR COMISSÃO DE PERMANÊNCIA

						'1776' => '1776',  # NÃO FOI POSSÍVEL A ENTREGA DO BOLETO AO PAGADOR
						'1784' => '1784',  # BOLETO NÃO ENTREGUE, MUDOU-SE/DESCONHECIDO
						'1792' => '1792',  # BOLETO NÃO ENTREGUE, CEP ERRADO/INCOMPLETO
						'1800' => '1800',  # BOLETO NÃO ENTREGUE, NÚMERO NÃO EXISTE/ENDEREÇO INCOMPLETO
						'1818' => '1818',  # BOLETO NÃO RETIRADO PELO PAGADOR. REENVIADO PELO CORREIO PARA CARTEIRAS COM EMISSÃO PELO BANCO
						'1826' => '1826',  # ENDEREÇO DE E-MAIL INVÁLIDO/COBRANÇA MENSAGEM. BOLETO ENVIADO PELO CORREIO
						'1834' => '1834',  # BOLETO DDA, DIVIDA RECONHECIDA PELO PAGADOR
						'1842' => '1842',  # BOLETO DDA, DIVIDA NÃO RECONHECIDA PELO PAGADOR
				})
			end
		end
	end
end
