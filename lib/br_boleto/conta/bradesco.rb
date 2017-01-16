# encoding: utf-8
module BrBoleto
	module Conta
		class Bradesco < BrBoleto::Conta::Base

			# MODALIDADE CARTEIRA:
			#      _______________________________________________
			#     | Carteira | Descrição                         |
			#     |   06     | Sem registro                      |
			#     |   09     | Com registro                      |
			#     |   19     | Com registro                      |
			#     |   21     | Cobrança Interna Com Registro     |
			#     |   22     | Cobrança Interna Sem Registro     |
			#     ------------------------------------------------


			def default_values
				super.merge({
					carteira:                      '06', 			 
					valid_carteira_required:       true, # <- Validação dinâmica que a modalidade é obrigatória
					valid_carteira_length:         2,    # <- Validação dinâmica que a modalidade deve ter 2 digitos
					valid_carteira_inclusion:      %w[06 09 19 21 22], # <- Validação dinâmica de valores aceitos para a modalidade
					codigo_carteira:               '1',   # Cobrança Simples
					valid_codigo_carteira_length:   1,    # <- Validação dinâmica que a modalidade deve ter 1 digito
					valid_conta_corrente_required: true,  # <- Validação dinâmica que a conta_corrente é obrigatória
					valid_conta_corrente_maximum:  7,     # <- Validação que a conta_corrente deve ter no máximo 7 digitos
					valid_convenio_required:       true,  # <- Validação que a convenio deve ter obrigatório
					valid_convenio_maximum:        7,     # <- Validação que a convenio deve ter no máximo 7 digitos
				})
			end

			def codigo_banco
				'237'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'2'
			end

			def nome_banco
				@nome_banco ||= 'BRADESCO'
			end

			def versao_layout_arquivo_cnab_240
				'084'
			end

			def versao_layout_lote_cnab_240
				'042'
			end

			def agencia_dv
				# utilizando a agencia com 4 digitos
				# para calcular o digito
				@agencia_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(agencia).to_s
			end

			def conta_corrente_dv
				@conta_corrente_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a7.new(conta_corrente).to_s
			end

			# Campo Agência / Código do Cedente
			# @return [String] Agência com 4 caracteres - digito da agência / Conta de Cobrança com 7 caracteres - Digito da Conta
			# Exemplo: 9999-D / 9999999-D
			def agencia_codigo_cedente
				"#{agencia}-#{agencia_dv} / #{conta_corrente}-#{conta_corrente_dv}"
			end

			# Número da Carteira de Cobrança, que a empresa opera no Banco.
			# 21 – Cobrança Interna Com Registro
			# 22 – Cobrança Interna sem registro
			# Para as demais carteiras, retornar o número da carteira.
			def carteira_formatada
				if cobranca_interna_formatada.present?
					cobranca_interna_formatada
				else
					carteira
				end
			end

			# Retorna a mensagem que devera aparecer no campo carteira para cobranca interna.
			# @return [String]
			def cobranca_interna_formatada
				cobranca_interna = { '21' => '21 – Cobrança Interna Com Registro', '22' => '22 – Cobrança Interna sem registro' }
				cobranca_interna[carteira.to_s]
			end


			##################################### DEFAULT CODES ###############################################

				# Espécie do Título
				def equivalent_especie_titulo_400
					super.merge(
						#  Padrão    Código para  
						{# da GEM     o Banco
							'07'    =>   '10' , # Letra de Câmbio
							'17'    =>   '05' , # Recibo
							'19'    =>   '11' , # Nota de Débito
							'32'    =>   '30' , # Boleto de Proposta
						})
				end

				# Códigos de Movimento Remessa / Identificacao Ocorrência específicos do Banco
				def equivalent_codigo_movimento_remessa_400
					super.merge(
						#  Padrão    Código para  
						{# da GEM     o Banco
							'10'   =>   '18' , # Sustar protesto e baixar Título
							'11'   =>   '19' , # Sustar protesto e manter em carteira
							'31'   =>   '22' , # Transferência Cessão Crédito
							'33'   =>   '68' , # Acerto nos dados do rateio de Crédito
							'43'   =>   '23' , # Transferência entre Carteiras
							'45'   =>   '45' , # Pedido de Negativação
							'46'   =>   '46' , # Excluir Negativação com baixa
							'47'   =>   '47' , # Excluir negativação e manter pendente
							'34'   =>   '69' , # Cancelamento do rateio de crédito.
						})
				end

				# Código de Movimento Retorno 
				def equivalent_codigo_movimento_retorno_240
					super.merge({'73' => '73'}) # Confirmação recebimento pedido de negativação
				end

				# Identificações de Ocorrência / Código de ocorrência:
				def equivalent_codigo_movimento_retorno_400
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'15'   =>   '101',  # Liquidação em Cartório (sem motivo)
							'24'   =>   '106',  # Entrada rejeitada por CEP Irregular
							'25'   =>   '170',  # Confirmação Receb.Inst.de Protesto Falimentar
							'27'   =>   '100',  # Baixa Rejeitada
							'32'   =>   '26',   # Instrução Rejeitada
							'33'   =>   '27',   # Confirmação Pedido Alteração Outros Dados (sem motivo)
							'40'   =>   '171',  # Estorno de pagamento
							'55'   =>   '63',   # Sustado judicial
							'68'   =>   '33',   # Acerto dos dados do rateio de Crédito
							'69'   =>   '34',   # Cancelamento dos dados do rateio
						})
				end

				# Código Motivo Ocorrência Retorno CNAB 400
				def codigos_movimento_retorno_para_ocorrencia_A_400
					%w[02 03 26 30 35 100 106]
				end
				def equivalent_codigo_motivo_ocorrencia_A_400 codigo_movimento_gem
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'00'   =>   'A00',    # Ocorrência aceita
							'03'   =>   'A05',    # Código da ocorrência inválida
							'05'   =>   'A208',   # Código de ocorrência não numérico
							'44'   =>   'A209',   # Agência Beneficiário não prevista
							'65'   =>   'A83',    # Limite excedido
							'66'   =>   'A84',    # Número autorização inexistente
							'67'   =>   'A68',    # Débito automático agendado
							'68'   =>   'A69',    # Débito não agendado - erro nos dados de remessa
							'69'   =>   'A70',    # Débito não agendado - Pagador não consta no cadastro de autorizante
							'70'   =>   'A71',    # Débito não agendado - Beneficiário não autorizado pelo Pagador
							'71'   =>   'A72',    # Débito não agendado - Beneficiário não participa da modalidade de déb.automático
							'72'   =>   'A73',    # Débito não agendado - Código de moeda diferente de R$
							'73'   =>   'A74',    # Débito não agendado - Data de vencimento inválida/vencida
							'74'   =>   'A75',    # Débito não agendado - Conforme seu pedido, Título não registrado
							'75'   =>   'A76',    # Débito não agendado - Tipo do número de inscrição do pagador debitado inválido
							'76'   =>   'A103',   # Pagador Eletrônico DDA
							'83'   =>   'A218',   # Cancelado pelo Pagador e Mantido Pendente, conforme negociação
							'84'   =>   'A219',   # Cancelado pelo pagador e baixado, conforme negociação
							'88'   =>   'A210',   # E-mail Pagador não lido no prazo 5 dias
							'89'   =>   'A211',   # Email Pagador não enviado – título com débito automático
							'90'   =>   'A212',   # Email pagador não enviado – título de cobrança sem registro
							'91'   =>   'A213',   # E-mail pagador não recebido
							'94'   =>   'A214',   # Título Penhorado – Instrução Não Liberada pela Agência
							'97'   =>   'A215',   # Instrução não permitida título negativado
							'98'   =>   'A216',   # Inclusão Bloqueada face a determinação Judicial
							'99'   =>   'A217',   # Telefone beneficiário não informado / inconsistente
						})
				end
				
				def equivalent_codigo_motivo_ocorrencia_B_400 codigo_movimento_gem
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
							'68'   =>   'B16',   # Fornecimento de máquina FAX
							'81'   =>   'B14',   # Tarifa reapresentação automática título
							'83'   =>   'B15',   # Tarifa Rateio de Crédito

							'02'   =>   'B31',  # Tarifa de permanência título cadastrado
							'12'   =>   'B32',  # Tarifa de registro
							'13'   =>   'B33',  # Tarifa título pago no Bradesco
							'14'   =>   'B34',  # Tarifa título pago compensação
							'15'   =>   'B35',  # Tarifa título baixado não pago
							'16'   =>   'B36',  # Tarifa alteração de vencimento
							'17'   =>   'B37',  # Tarifa concessão abatimento
							'18'   =>   'B38',  # Tarifa cancelamento de abatimento
							'19'   =>   'B39',  # Tarifa concessão desconto
							'20'   =>   'B40',  # Tarifa cancelamento desconto
							'21'   =>   'B41',  # Tarifa título pago cics
							'22'   =>   'B42',  # Tarifa título pago Internet
							'23'   =>   'B43',  # Tarifa título pago term. gerencial serviços
							'24'   =>   'B44',  # Tarifa título pago Pág-Contas
							'25'   =>   'B45',  # Tarifa título pago Fone Fácil
							'26'   =>   'B46',  # Tarifa título Déb. Postagem
							'27'   =>   'B47',  # Tarifa impressão de títulos pendentes
							'28'   =>   'B48',  # Tarifa título pago BDN
							'29'   =>   'B49',  # Tarifa título pago Term. Multi Função
							'30'   =>   'B50',  # Impressão de títulos baixados
							'31'   =>   'B51',  # Impressão de títulos pagos
							'32'   =>   'B52',  # Tarifa título pago Pagfor
							'33'   =>   'B53',  # Tarifa reg/pgto – guichê caixa
							'34'   =>   'B54',  # Tarifa título pago retaguarda
							'35'   =>   'B55',  # Tarifa título pago Subcentro
							'36'   =>   'B56',  # Tarifa título pago Cartão de Crédito
							'37'   =>   'B57',  # Tarifa título pago Comp Eletrônica
							'38'   =>   'B58',  # Tarifa título Baix. Pg. Cartório
							'39'   =>   'B59',  # Tarifa título baixado acerto BCO
							'40'   =>   'B60',  # Baixa registro em duplicidade
							'41'   =>   'B61',  # Tarifa título baixado decurso prazo
							'42'   =>   'B62',  # Tarifa título baixado Judicialmente
							'43'   =>   'B63',  # Tarifa título baixado via remessa
							'44'   =>   'B64',  # Tarifa título baixado rastreamento
							'45'   =>   'B65',  # Tarifa título baixado conf. Pedido
							'46'   =>   'B66',  # Tarifa título baixado protestado
							'47'   =>   'B67',  # Tarifa título baixado p/ devolução
							'48'   =>   'B68',  # Tarifa título baixado franco pagto
							'49'   =>   'B69',  # Tarifa título baixado SUST/RET/CARTÓRIO
							'50'   =>   'B70',  # Tarifa título baixado SUS/SEM/REM/CARTÓRIO
							'51'   =>   'B71',  # Tarifa título transferido desconto
							'52'   =>   'B72',  # Cobrado baixa manual
							'53'   =>   'B73',  # Baixa por acerto cliente
							'54'   =>   'B74',  # Tarifa baixa por contabilidade
							'55'   =>   'B75',  # Tr. tentativa cons deb aut
							'56'   =>   'B76',  # Tr. credito online
							'57'   =>   'B77',  # Tarifa reg/pagto Bradesco Expresso
							'58'   =>   'B78',  # Tarifa emissão Papeleta
							'59'   =>   'B79',  # Tarifa fornec papeleta semi preenchida
							'60'   =>   'B80',  # Acondicionador de papeletas (RPB)S
							'61'   =>   'B81',  # Acond. De papelatas (RPB)s PERSONAL
							'62'   =>   'B82',  # Papeleta formulário branco
							'63'   =>   'B83',  # Formulário A4 serrilhado
							'64'   =>   'B84',  # Fornecimento de softwares transmiss
							'65'   =>   'B85',  # Fornecimento de softwares consulta
							'66'   =>   'B86',  # Fornecimento Micro Completo
							'67'   =>   'B87',  # Fornecimento MODEN
							'69'   =>   'B88',  # Fornecimento de máquinas óticas
							'70'   =>   'B89',  # Fornecimento de Impressoras
							'71'   =>   'B90',  # Reativação de título
							'72'   =>   'B91',  # Alteração de produto negociado
							'73'   =>   'B92',  # Tarifa emissão de contra recibo
							'74'   =>   'B93',  # Tarifa emissão 2a via papeleta
							'75'   =>   'B94',  # Tarifa regravação arquivo retorno
							'76'   =>   'B95',  # Arq. Títulos a vencer mensal
							'77'   =>   'B96',  # Listagem auxiliar de crédito
							'78'   =>   'B97',  # Tarifa cadastro cartela instrução permanente
							'79'   =>   'B98',  # Canalização de Crédito
							'80'   =>   'B99',  # Cadastro de Mensagem Fixa
							'82'   =>   'B100', # Tarifa registro título déb. Automático
							'84'   =>   'B101', # Emissão papeleta sem valor
							'85'   =>   'B102', # Sem uso
							'86'   =>   'B103', # Cadastro de reembolso de diferença
							'87'   =>   'B104', # Relatório fluxo de pagto
							'88'   =>   'B105', # Emissão Extrato mov. Carteira
							'89'   =>   'B106', # Mensagem campo local de pagto
							'90'   =>   'B107', # Cadastro Concessionária serv. Publ.
							'91'   =>   'B108', # Classif. Extrato Conta Corrente
							'92'   =>   'B109', # Contabilidade especial
							'93'   =>   'B110', # Realimentação pagto
							'94'   =>   'B111', # Repasse de Créditos
							'96'   =>   'B112', # Tarifa reg. Pagto outras mídias
							'97'   =>   'B113', # Tarifa Reg/Pagto – Net Empresa
							'98'   =>   'B114', # Tarifa título pago vencido
							'99'   =>   'B115', # TR Tít. Baixado por decurso prazo
							'100'  =>   'B116', # Arquivo Retorno Antecipado
							'101'  =>   'B117', # Arq retorno Hora/Hora
							'102'  =>   'B118', # TR. Agendamento Déb Aut
							'105'  =>   'B119', # TR. Agendamento rat. Crédito
							'106'  =>   'B120', # TR Emissão aviso rateio
							'107'  =>   'B121', # Extrato de protesto
						})
				end

				def codigos_movimento_retorno_para_ocorrencia_C_400
					%w[06 09 10 17]
				end
				def equivalent_codigo_motivo_ocorrencia_C_400 codigo_movimento_gem
					if codigo_movimento_gem == '10'
						super.merge(
							#  Padrão    Código para  
							{# do Banco    a GEM
								'00'   =>   'C00',   # Baixado Conforme Instruções da Agência
								'16'   =>   'C16',   # Título Baixado pelo Banco por decurso Prazo
								'17'   =>   'C17',   # Titulo Baixado Transferido Carteira
								'20'   =>   'C20',   # Titulo Baixado e Transferido para Desconto
			
							})
					else
						super.merge(
							#  Padrão    Código para  
							{# do Banco    a GEM
								'00'   =>   'C35',  # Título pago com dinheiro
								'15'   =>   'C36',  # Título pago com cheque
								'10'   =>   'C10',  # Baixa Comandada pelo cliente
								'42'   =>   'C42',  # Rateio não efetuado, cód. Calculo 2 (VLR. Registro) e v (NOVO)
							})
					end
				end

				def codigos_movimento_retorno_para_ocorrencia_D_400
					%w[29]
				end
				def equivalent_codigo_motivo_ocorrencia_D_400 codigo_movimento_gem
					#  Padrão    Código para  
					{# do Banco    a GEM
						'78'   =>   'D78',  # Pagador alega que faturamento e indevido
						'95'   =>   'D95',  # Pagador aceita/reconhece o faturamento
					}
				end
				
		end
	end
end
