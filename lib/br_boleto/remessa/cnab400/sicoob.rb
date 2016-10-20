# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab400
			class Sicoob < BrBoleto::Remessa::Cnab400::Base
				def conta_class
					BrBoleto::Conta::Sicoob
				end

				# Informações da conta <- Específico para cada banco
				# Posição: 027 até 046
				# Tipo: Numérico
				# Tamanho: 020				
				def informacoes_da_conta(local)
					#  POSIÇÂO  TAM.  Descrição
					# 027  030  004  Prefixo da Cooperativa: vide planilha "Capa" deste arquivo
					# 031  031  001  Dígito Verificador do Prefixo: vide planilha "Capa" deste arquivo
					# 032  039  008  Código do Cliente/Beneficiário: vide planilha "Capa" deste arquivo
					# 040  040  001  Dígito Verificador do Código: vide planilha "Capa" deste arquivo
					# 041  046  006  Número do convênio líder: Brancos
					info =  "#{conta.agencia}".adjust_size_to(4, '0')
					info << "#{conta.agencia_dv}".adjust_size_to(1,'0')
					info << "#{conta.codigo_cedente}".adjust_size_to(8,'0', :right)
					info << "#{conta.codigo_cedente_dv}".adjust_size_to(1,'0')

					# A unica diferença entre o header e o delathe é que no
					# header é preenchido com valores em branco, e no
					# detalhe é preenchido com 0(zero)
					conv = if local == :detalhe then '0' else ' ' end
					info << ''.rjust(6, conv)

					info.adjust_size_to(20)
				end


				# Complemento do registro
				# Posição: 101 até 394
				# Tamanho total: 294
				def complemento_registro
					# Posição   TAM.    Descrição
					# 101 107   007   Seqüencial da Remessa: número seqüencial acrescido de 1 a cada remessa. Inicia com "0000001"
					# 108 394   287   Complemento do Registro: Brancos
					"#{sequencial_remessa}".rjust(7, '0').adjust_size_to(294)
				end

				# Nosso numero do pagamento e outras informações
				# Posição: 063 até 076
				# Tamanho: 14
				def dados_do_pagamento(pagamento)
					# 063	074	012	9(12)	"Nosso Número:
					#                       - Para comando 01 com emissão a cargo do Sicoob (vide e-mail enviado com os dados do processo de homologação e lista de comandos seq. 23): Preencher com zeros
					#                       - Para comando 01 com emissão a cargo do Beneficiário ou para os demais comandos (vide e-mail enviado com os dados do processo de homologação e lista de comandos seq. 23): 
					#                       Preencher da seguinte forma:
					#                       - Posição 063 a 073 – Número seqüencial a partir de ""0000000001"", não sendo admitida reutilização ou duplicidade.
					#                       - Posição 074 a 074 – DV do Nosso-Número, calculado pelo módulo 11."
					# 075	076	002	9(02)	Número da Parcela: "01" se parcela única
					dados =  "#{pagamento.nosso_numero}".adjust_size_to(12, '0', :right)
					dados << "#{pagamento.parcela}".adjust_size_to(2, '0', :right)
					dados
				end

				# Informações diferenciadas para cada banco
				# Posição: 077 até 108
				# Tamanho: 32
				def detalhe_posicao_077_108(pagamento, sequencial)
					dados = ''
					dados << '00'               # 077  078  002  9(02)  Grupo de Valor: "00"
					
					dados << ''.rjust(3, ' ')   # 079  081  003  X(03)  Complemento do Registro: Brancos
					dados << ' '                # 082  082  001  X(01)  "Indicativo de Mensagem ou Sacador/Avalista: 
					#                                                    Brancos: Poderá ser informada nas posições 352 a 391 (SEQ 50) qualquer mensagem para ser impressa no boleto; 
					#                                                    “A”: Deverá ser informado nas posições 352 a 391 (SEQ 50) o nome e CPF/CNPJ do sacador"
					dados << ''.rjust(3, ' ')   # 083  085  003  X(03)  Prefixo do Título: Brancos
					dados << '000'              # 086  088  003  9(03)  Variação da Carteira: "000"
					dados << '0'                # 089  089  001  9(01)  Conta Caução: "0"
					
					dados << ''.rjust(5, '0')   # 090  094  005  9(05)  "Número do Contrato Garantia: Para Carteira 1 preencher ""00000""; Para Carteira 3 preencher com o  número do contrato sem DV."
					dados << '0'                # 095  095  001  X(01)  "DV do contrato:  Para Carteira 1 preencher ""0""; Para Carteira 3 preencher com o Dígito Verificador."
					
					dados << ''.rjust(6, '0')   # 096  101  006  9(06)  Numero do borderô: preencher em caso de carteira 3
					dados << ''.rjust(4, ' ')   # 102  105  004  X(04)  Complemento do Registro: Brancos
					
					dados << "#{conta.get_identificacao_emissao(pagamento.tipo_emissao)}".adjust_size_to(1, '2') # 106  106  001  9(01)  "Tipo de Emissão: 1-Cooperativa 2-Cliente"
					dados << "#{conta.modalidade}".adjust_size_to(2, '0', :right)   # 107  108  002  9(02)  "Carteira/Modalidade: 01 = Simples Com Registro 02 = Simples Sem Registro 03 = Garantida Caucionada "
					dados
				end

				# Informações referente ao pagamento
				# Posição 121 até 160
				# Tamanho: 40
				def informacoes_do_pagamento(pagamento, sequencial)
					dados = ''
					#  POSIÇÂO   TAM. TIPO
					# 121  126  006  A(06)  "Data Vencimento: Formato DDMMAA Normal ""DDMMAA"" A vista = ""888888"" Contra Apresentação = ""999999"""
					dados << pagamento.data_vencimento_formatado('%d%m%y')

					# 127  139  013  9(11)  Valor do Titulo 
					dados << pagamento.valor_documento_formatado(13)

					# 140  142  003  9(03)  Número Banco: "756"
					dados << conta.codigo_banco

					# 143  146  004  9(04)  Prefixo da Cooperativa: vide e-mail enviado com os dados do processo de homologação
					dados << "#{conta.agencia}".adjust_size_to(4,'0', :right)
					
					# 147  147  001  X(01)  Dígito Verificador do Prefixo: vide e-mail enviado com os dados do processo de homologação
					dados << "#{conta.agencia_dv}".adjust_size_to(1, '0')

					# 148  149  002  9(02)  
					# "Espécie do Título :
					#    01 = Duplicata Mercantil
					#    02 = Nota Promissória
					#    03 = Nota de Seguro
					#    05 = Recibo
					#    06 = Duplicata Rural
					#    08 = Letra de Câmbio
					#    09 = Warrant
					#    10 = Cheque
					#    12 = Duplicata de Serviço
					#    13 = Nota de Débito
					#    14 = Triplicata Mercantil
					#    15 = Triplicata de Serviço
					#    18 = Fatura
					#    20 = Apólice de Seguro
					#    21 = Mensalidade Escolar
					#    22 = Parcela de Consórcio
					#    99 = Outros"
					dados << "#{conta.get_especie_titulo(pagamento.especie_titulo, 400)}".adjust_size_to(2, '0', :right)
					
					# 150  150  001  X(01)  "Aceite do Título:  "0" = Sem aceite "1" = Com aceite"
					dados << "#{pagamento.aceite ? '1' : '0'}".adjust_size_to(1, '0')

					# 151  156  006  9(06)  Data de Emissão do Título: formato ddmmaa
					dados << pagamento.data_emissao_formatado('%d%m%y')

					# 157  158  002  9(02)  "Primeira instrução codificada:
					#   Regras de impressão de mensagens nos boletos:
					#   * Primeira instrução (SEQ 34) = 00 e segunda (SEQ 35) = 00, não imprime nada.
					#   * Primeira instrução (SEQ 34) = 01 e segunda (SEQ 35) = 01, desconsidera-se as instruções CNAB e imprime as mensagens relatadas no trailler do arquivo.
					#   * Primeira e segunda instrução diferente das situações acima, imprimimos o conteúdo CNAB:
					#     00 = AUSENCIA DE INSTRUCOES
					#     01 = COBRAR JUROS
					#     03 = PROTESTAR 3 DIAS UTEIS APOS VENCIMENTO
					#     04 = PROTESTAR 4 DIAS UTEIS APOS VENCIMENTO
					#     05 = PROTESTAR 5 DIAS UTEIS APOS VENCIMENTO
					#     07 = NAO PROTESTAR
					#     10 = PROTESTAR 10 DIAS UTEIS APOS VENCIMENTO
					#     15 = PROTESTAR 15 DIAS UTEIS APOS VENCIMENTO
					#     20 = PROTESTAR 20 DIAS UTEIS APOS VENCIMENTO
					#     22 = CONCEDER DESCONTO SO ATE DATA ESTIPULADA
					#     42 = DEVOLVER APOS 15 DIAS VENCIDO
					#     43 = DEVOLVER APOS 30 DIAS VENCIDO"
					dados << '00'

					# 159  160  002  9(02)  Segunda instrução: vide SEQ 33
					dados << '00'

					dados
				end

				# Informações referente aos juros e multas do pagamento
				# Posição: 161 a 218
				# Tamanho: 58
				def detalhe_multas_e_juros_do_pagamento(pagamento, sequencial)
					detalhe = ''
					
					# 161  166  006  9(02)  "Taxa de mora mês  Ex: 022000 = 2,20%)"
					detalhe << pagamento.percentual_juros_formatado(6)

					# 167  172  006  9(02)  "Taxa de multa Ex: 022000 = 2,20%)"
					detalhe << pagamento.percentual_multa_formatado(6)
					
					# 173  173  001  9(01)  "Tipo Distribuição: 1 – Cooperativa 2 - Cliente"
					detalhe << "#{conta.get_identificacao_emissao(pagamento.tipo_emissao)}".adjust_size_to(1, '2')
					
					# 174  179  006  9(06)  "Data primeiro desconto:
					#                          Informar a data limite a ser observada pelo cliente para o pagamento 
					#                          do título com Desconto no formato ddmmaa.
					#                          Preencher com zeros quando não for concedido nenhum desconto.
					#                          Obs: A data limite não poderá ser superior a data de vencimento do título."
					detalhe << "#{pagamento.data_desconto_formatado('%d%m%y')}".adjust_size_to(6,'0')
					
					# 180  192  013  9(11)V99  "Valor primeiro desconto:
					#                              Informar o valor do desconto, com duas casa decimais.
					#                              Preencher com zeros quando não for concedido nenhum desconto."
					detalhe << "#{pagamento.valor_desconto_formatado}".adjust_size_to(13,'0', :right)
					
					# 193  205  013  9(13)  "193-193 – Código da moeda
					#                        194-205 – Valor IOF / Quantidade Monetária: ""000000000000""
					#                      Se o código da moeda for REAL, o valor restante representa o IOF. 
					#                      Se o código da moeda for diferente de REAL, o valor restante será a quantidade monetária.
					detalhe << "#{pagamento.codigo_moeda}".adjust_size_to(1,'9')
					detalhe << (pagamento.moeda_real? ? ''.ljust(12 ,'0') : pagamento.valor_iof_formatado(12))
					
					# 206	218	013	9(11)V99	Valor Abatimento
					detalhe << "#{pagamento.valor_abatimento_formatado}".adjust_size_to(13,'0', :right)

					detalhe
				end

				# Informações referente aos dados do sacado/pagador
				# Posição: 219 a 394
				# Tamanho: 176
				def informacoes_do_sacado(pagamento, sequencial)
					info = ''
					# 219  220  002  9(01)  "Tipo de Inscrição do Pagador: "01" = CPF / "02" = CNPJ
					info << "#{pagamento.pagador.tipo_cpf_cnpj}".adjust_size_to(2, '0', :right)
					
					# 221  234  014  9(14)  Número do CNPJ ou CPF do Pagador
					info << "#{pagamento.pagador.cpf_cnpj}".adjust_size_to(14, '0', :right)
					
					# 235  274  040  A(40)  Nome do Pagador
					info << "#{pagamento.pagador.nome}".adjust_size_to(40)

					# 275  311  037  A(37)  Endereço do Pagador
					info << "#{pagamento.pagador.endereco}".adjust_size_to(37)

					# 312  326  015  X(15)  Bairro do Pagador
					info << "#{pagamento.pagador.bairro}".adjust_size_to(15)

					# 327  334  008  9(08)  CEP do Pagador
					info << "#{pagamento.pagador.cep}".adjust_size_to(8, '0')

					# 335  349  015  A(15)  Cidade do Pagador
					info << "#{pagamento.pagador.cidade}".adjust_size_to(15)

					# 350  351  002  A(02)  UF do Pagador
					info << "#{pagamento.pagador.uf}".adjust_size_to(2)
					
					# 352  391  040  X(40)  "Observações/Mensagem ou Sacador/Avalista:
					#                          Quando o SEQ 14 – Indicativo de Mensagem ou Sacador/Avalista - for preenchido com Brancos, 
					#                            as informações constantes desse campo serão impressas no campo “texto de responsabilidade 
					#                            da Empresa, no Recibo do Sacado e na Ficha de Compensação do boleto de cobrança.
					#                          Quando o SEQ 14 – Indicativo de Mensagem ou Sacador/Avalista - for preenchido com “A” , 
					#                            este campo deverá ser preenchido com o nome/razão social do Sacador/Avalista
					info << "#{pagamento.pagador.nome_avalista}".adjust_size_to(40)

					# 392  393  002  X(02)  "Número de Dias Para Protesto: Quantidade dias para envio protesto. Se = "0", utilizar dias protesto padrão do cliente cadastrado na cooperativa
					info << "00"

					# 394  395  001  X(01)  Complemento do Registro: Brancos
					info << " "

					info
				end
			end
		end
	end
end