# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab400
			class Bradesco < BrBoleto::Remessa::Cnab400::Base
				def conta_class
					BrBoleto::Conta::Bradesco
				end

				validate :validation_codigo_empresa_is_required

############################## HEADER #########################################################

				# Código da remessa
				# Tipo: Numérico
				# Tamanho: 001
				def header_posicao_002_a_002
					'1'
				end

				# Informações da conta <- Específico para cada banco
				# Será informado pelo Bradesco, quando do cadastramento da Conta beneficiário na sua Agência.
				# Posição: 027 até 046
				# Tipo: Numérico
				# Tamanho: 020				
				def informacoes_da_conta(local)
					info =  "#{conta.codigo_empresa}".rjust(20, '0') if local == :header 
				end

				# Complemento do registro
				# Posição: 101 até 394
				# Tamanho total: 294
				def complemento_registro
					#  POSIÇÂO  TAM.  Descrição
					# 101 a 108  008  Branco
					# 109 a 110  002  Identificação do sistema (MX)
					# 111 a 117  007  No Seqüencial de Remessa (deve iniciar de 0000001 e incrementado de + 1 a cada NOVO Arquivo Remessa)
					# 118 a 394  277  Branco
					info = ''.rjust(8, ' ')
					info << 'MX'
					info <<  "#{sequencial_remessa}".rjust(7, '0')
					info = ''.rjust(277, ' ')
					info.adjust_size_to(294)
				end
###############################################################################################

############################## DETALHE #########################################################

				# Informações Opcionais no Bradesco. 
				# Somente deverão ser preenchidos, caso o cliente Beneficiário esteja previamente 
				# cadastrado para operar com a modalidade de cobrança com débito automático
				def detalhe_posicao_002_003
					''.rjust(2, ' ')
				end
				def detalhe_posicao_004_017
					''.rjust(14, ' ')
				end

				# Informações da conta <- Específico para cada banco
				# Posição: 018 até 037
				# POSIÇÂO    TAM.  Descrição
				# 018 a 020  003  Branco
				# 021 a 021  001  Zero
				# 022 a 024  003  Códigos da carteira
				# 025 a 029  005  Códigos da Agência Beneficiários (sem o dígito)
				# 030 a 036  007  Contas Corrente
				# 037 a 037  001  Dígito da Conta
				# Tipo: Numérico
				# Tamanho: 020				
				def informacoes_da_conta(local)
					if local == :detalhe 
						info = ''.rjust(3, ' ')
						info << '0'
						info << "#{conta.carteira}".adjust_size_to(3, '0')
						info << "#{conta.agencia}".adjust_size_to(5, '0')
						info << "#{conta.codigo_cedente}".adjust_size_to(7, '0')
						info << "#{conta.codigo_cedente_dv}".adjust_size_to(1, '0')
						info
					end
				end

				# Nosso numero do pagamento e outras informações
				# Posição: 063 até 108
				# POSIÇÂO    TAM.  Descrição
				# 063 a 065  003   Códigos do Banco para Débito - preencher com Zeros (Se for débito automatico adicionar 237)
				# 066 a 066  001   Identificativos de Multa
				# 067 a 070  004   Percentual de Multa por Atraso
				# 071 a 081  011   Identificação do Título no Banco
				# 082 a 082  001   Digito de Auto Conferencia do Número Bancário
				# 083 a 092  010   Desconto Bonificação por dia
				# 093 a 093  001   Condição para Emissão da Papeleta de Cobrança
				# 094 a 094  001   Ident. se emite Boleto Automático
				# 095 a 104  010   Identificação da Operação do Banco (Preencher com Branco)
				# 105 a 105  001   Indicador Rateio Crédito (Opcional)
				# 106 a 106  001   Endereçamento para Aviso do Débito Automático em C.C. (opcional)
				# 107 a 108  002   Branco
				# Tamanho: 46
				def detalhe_posicao_063_076(pagamento, sequencial)
					detalhe_posicao_063_108(pagamento)
				end
				def detalhe_posicao_077_108(pagamento, sequencial)
					''
				end
				def detalhe_posicao_063_108(pagamento)
					info = ''.adjust_size_to(3, '0')
					info << (pagamento.codigo_multa == 1 or pagamento.codigo_multa == 2) ? '2' : '0'  # '0' (sem multa), '2' (tem multa)
					if pagamento.codigo_multa == 1 or pagamento.codigo_multa == 2
						info << (pagamento.percentual_multa_formatado(2)).rjust(4, '0')                # tem multa: preencher com percentual da multa com 2 decimais
					else
						info << ''.rjust(4, '0') 																		 # sem multa: preencher com zeros.
					end
					info << "#{pagamento.numero_documento}".adjust_size_to(11, '0')
					info << "#{pagamento.nosso_numero}".split('').last
					info << "#{pagamento.valor_desconto_formatado}".rjust(10,'0')                     # Valor do desconto bonif./dia
					info << '2'                                                                       # '2' : o Cliente emitiu o Boleto e o Banco somente processa o registro
					info << ' '                                                                       # Espaço em branco ou 'N' caso o boleto possui Condições de Registro para Débito Automático
					info << ''.rjust(10, ' ')
					info << ' '                                                                       # Somente deverá ser preenchido com a Letra “R”, se a Empresa contratou o serviço de rateio de crédito, caso não, informar Branco
					info << ' '                                                                       # Espaço em branco ou '1' se possui Débito Automático (emite aviso e assume o endereço do Pagador constante do Arquivo-Remessa)
					info << ''.rjust(4, ' ')
					info
				end
				

				# Informações referente ao pagamento
				# Posição 121 até 160
				# POSIÇÂO      TAM.   Descrição
				# 121 a 126    006    Data do Vencimento do Título
				# 127 a 139    013    Valor do Título
				# 140 a 142    003    Banco Encarregado da Cobrança (Preencher com zeros)
				# 143 a 147    005    Agência Depositária (Preencher com zeros)
				# 148 a 149    002    Espécie de Título 
				# 150 a 150    001    Identificação (Sempre 'N')
				# 151 a 156    006    Data da emissão do Título
				# 157 a 158    002    1a instrução
				# 159 a 160    002    2a instrução 
				# Tamanho: 40
				def informacoes_do_pagamento(pagamento, sequencial)
					dados = ''
					dados << pagamento.data_vencimento_formatado('%d%m%y')
					dados << pagamento.valor_documento_formatado(13)
					dados << ''.rjust(3,'0')
					dados << ''.rjust(5,'0')

					# Espécie do Título :
					#   01-Duplicata
					#   02-Nota Promissória
					#   03-Nota de Seguro
					#   04-Cobrança Seriada
					#   05-Recibo
					#   10-Letras de Câmbio
					#   11-Nota de Débito
					#   12-Duplicata de Serv.
					#   30-Boleto de Proposta
					#   99-Outros
					dados << "#{pagamento.especie_titulo}".adjust_size_to(2, '0', :right)
					dados << 'N'
					dados << pagamento.data_emissao_formatado('%d%m%y')

					# 1a / 2a Instrução:
					# Campo destinado para pré-determinar o protesto do Título ou a baixa por decurso de prazo, quandodo registro.
					# Não havendo interesse, preencher com Zeros.
					# Porém, caso a Empresa deseje se utilizar da instrução automática de protesto ou da baixa pordecurso de prazo, abaixo os procedimentos:

					# Protesto/Negativação:
					#    - posição 157 a 158 = Indicar o código “06” - (Protestar).
					#    - posição 157 a 158 = Indicar o código “07” - (Negativar) (NOVO)
					#    - posição 159 a 160 = Indicar o número de dias a protestar (mínimo 5 dias).
					# Protesto Falimentar:
					#    - posição 157 a 158 = Indicar o código “05” – (Protesto Falimentar)
					#    - posição 159 a 160 = Indicar o número de dias a protestar (mínimo 5 dias).
					# Decurso de Prazo:
					#    - posição 157 a 158 = Indicar o código “18” – (Decurso de prazo).
					#    - posição 159 a 160 = Indicar o número de dias para baixa por decurso de prazo.

					# Nota: A posição 157 a 158, também poderá ser utilizada para definir as seguintes mensagens, a serem impressas nos Boletos de cobrança, emitidas pelo Banco:
					#    08 Não cobrar juros de mora
					#    09 Não receber após o vencimento
					#    20/5710 Multas de 10% após o 4o dia do Vencimento.
					#    11 Não receber após o 8o dia do vencimento.
					#    12 Cobrar encargos após o 5o dia do vencimento.
					#    13 Cobrar encargos após o 10o dia do vencimento.
					#    14 Cobrar encargos após o 15o dia do vencimento
					#    15 Conceder desconto mesmo se pago após o vencimento.
					dados << ''.rjust(2,'0') # 1a Instrução
					dados << ''.rjust(2,'0') # 2a Instrução
					dados
					
				end

				# Informações referente aos juros e multas do pagamento
				# Posição: 161 a 218
				# POSIÇÂO      TAM.   Descrição
				# 161 a 173    013    Valor a ser cobrado por Dia de Atraso
				# 174 a 179    006    Data Limite P/Concessão de Desconto
				# 180 a 192    013    Valor do Desconto
				# 193 a 205    013    Valor do IOF
				# 206 a 218    013    Valor do Abatimento a ser concedido ou cancelado
				# Tamanho: 58
				def detalhe_multas_e_juros_do_pagamento(pagamento, sequencial)
					detalhe = ''

					# detalhe << "#{pagamento.valor_mora_formatado}".rjust(13,'0') 
					detalhe << "".rjust(13,'0') # Analisar regras documentação pag. 11 e 21

					detalhe << "#{pagamento.data_desconto_formatado('%d%m%y')}".rjust(6,'0')
					detalhe << "#{pagamento.valor_desconto_formatado}".rjust(13,'0')

					# detalhe << "#{pagamento.valor_iof_formatado}".rjust(13,'0')
					detalhe << "".rjust(13,'0') # Analisar regras documentação pag. 11 e 21

					detalhe << "#{pagamento.valor_abatimento_formatado}".rjust(13,'0')
					detalhe
				end

				# Informações referente aos dados do sacado/pagador
				# Posição: 219 a 394
				# POSIÇÂO      TAM.   Descrição
				# 219 a 220    002    Identificação do Tipo de Inscrição do Pagador
				# 221 a 234    014    No Inscrição do Pagador
				# 235 a 274    040    Nome do Pagador
				# 275 a 314    040    Endereço Completo
				# 315 a 326    012    1a Mensagem
				# 327 a 331    005    CEP
				# 332 a 334    003    Sufixo do CEP
				# 335 a 394    060    Sacador/Avalista ou 2a Mensagem
				# Tamanho: 176
				def informacoes_do_sacado(pagamento, sequencial)
					
				end
################################################################################################

############################## TRAILER #########################################################
################################################################################################

			private

				def validation_codigo_empresa_is_required
					errors.add(:base, :column_is_required, column: conta_class.human_attribute_name(:codigo_empresa)) if conta.codigo_empresa.blank?
				end

			end
		end
	end
end