# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab400
			class BancoBrasil < BrBoleto::Remessa::Cnab400::Base
				def conta_class
					BrBoleto::Conta::BancoBrasil
				end

			############################## HEADER ######################################

				# Código da remessa
				# Tipo: Numérico
				# Tamanho: 001
				def header_posicao_002_a_002
					'1'
				end

				# Complemento do registro
				# Posição: 101 até 394
				#  POSIÇÂO  TAM.  Descrição
				# 101 a 107  007  No Seqüencial de Remessa (deve iniciar de 0000001 e incrementado de + 1 a cada NOVO Arquivo Remessa)
				# 108 a 129  022  Branco
				# 130 a 136  007  Convênio Lider (Opcional)
				# 137 a 394  258  Branco
				# Tamanho total: 294
				def complemento_registro
					info =  "#{sequencial_remessa}".adjust_size_to(7, '0', :right)
					info << ''.adjust_size_to(22)
					info << "#{conta.convenio}".adjust_size_to(7, '0', :right)
					info << ''.adjust_size_to(258)
					info
				end

			############################# DETALHE #################################

				# Identificação do Registro Detalhe
				def detalhe_posicao_001_001
					'7'
				end

				# Informações da conta <- Específico para cada banco
				# Posição: 018 até 037 (Detalhe)
				# Posição: 027 até 046 (Header)
				# Tamanho: 020				
				def informacoes_da_conta(local)

					# POSIÇÂO:
					#  Detalhe  |  Header       TAM.  Descrição
					#  18 a 21     27 a 30      004   Agência
					#  22 a 22     31 a 31      001   Agência DV
					#  23 a 30     32 a 39      008   Conta Corrente
					#  31 a 31     40 a 40      001   Conta Corrente DV

					info = "#{conta.agencia}".adjust_size_to(4, '0', :right)
					info << "#{conta.agencia_dv}".adjust_size_to(1, '0', :right)
					info << "#{conta.conta_corrente}".adjust_size_to(8, '0', :right)
					info << "#{conta.conta_corrente_dv}".adjust_size_to(1, '0', :right)

					if local == :detalhe 
						# POSIÇÂO    TAM.  Descrição
						# -------------------------------
						# 032 a 038  007   Código Convênio
						info << "#{conta.convenio}".adjust_size_to(7, '0', :right)

					elsif local == :header
						# POSIÇÂO    TAM.  Descrição
						# -------------------------------
						# 041 a 046  006   Brancos
						info << ''.adjust_size_to(6, "0")
					end

					info
				end

				# Nosso numero do pagamento e outras informações
				# Posição: 063 até 108
				# POSIÇÂO    TAM.  Descrição
				# -----------------------------------------------------
				# 039 a 063  025   Cod. Controle da Empresa (Brancos)
				# 064 a 080  017   Nosso Número
				# 081 a 082  002   Número da Prestação (Zeros)
				# 083 a 084  002   Grupo de Valor (Zeros)
				# 085 a 087  003   Complemento do Registro (Brancos)
				# 088 a 088  001   Indicativo de Mensagem ou Sacador/Avalista
				# 089 a 091  003   Prefixo do Título (Brancos)
				# 092 a 094  003   Variação da Carteira
				# 095 a 095  001   Conta Caução (Zero)
				# 096 a 101  006   Número do Borderô (Zeros)
				# 102 a 106  005   Tipo de Cobrança
				# 107 a 108  002   Carteira
				#
				# Tamanho: 70
				def detalhe_posicao_038_062(pagamento)
					detalhe_posicao_039_108(pagamento)
				end
				def detalhe_posicao_063_076(pagamento, sequencial)
					''
				end
				def detalhe_posicao_077_108(pagamento, sequencial)
					''
				end
				def detalhe_posicao_039_108(pagamento)
					detalhe = ''.adjust_size_to(25)
					detalhe << "#{pagamento.nosso_numero}".adjust_size_to(17, '0', :right)
					detalhe << ''.adjust_size_to(2, "0")
					detalhe << ''.adjust_size_to(2, "0")
					detalhe << ''.adjust_size_to(3)
					detalhe << ''.adjust_size_to(1)
					detalhe << ''.adjust_size_to(3)
					detalhe << "#{conta.variacao_carteira}".adjust_size_to(3, '0', :right)
					detalhe << '0'
					detalhe << ''.adjust_size_to(6, "0")
					detalhe << "#{tipo_cobranca}".adjust_size_to(5)
					detalhe << "#{conta.carteira}".adjust_size_to(2, '0', :right)
					detalhe
				end

				# TIPO DE COBRANÇA
				# a) Carteiras 11 ou 17:
				# 	- '04DSC': Solicitação de registro na Modalidade Descontada
				# 	- '08VDR': Solicitação de registro na Modalidade BBVendor
				# 	- '02VIN': solicitação de registro na Modalidade Caucionada/Vinculada
				# 	- BRANCOS: Registro na Modalidade Simples
				# b) Demais Carteiras:
				# 	- Brancos
				def tipo_cobranca
					if conta.carteira.to_i == 11 || conta.carteira.to_i == 17
						case conta.get_tipo_cobranca(conta.codigo_carteira, 400).to_i
						when 3
							'02VIN'
						when 4
							'04DSC'
						when 7
							'08VDR'
						else
							''.adjust_size_to(5)
						end

					else
						''.adjust_size_to(5)
					end
				end
			
				
				# Informações referente ao pagamento
				# Posição 121 até 160
				# POSIÇÂO      TAM.   Descrição
				# 121 a 126    006    Data do Vencimento do Título
				# 127 a 139    013    Valor do Título
				# 140 a 142    003    Banco Encarregado da Cobrança
				# 143 a 147    005    Agência Depositária (preencher com zeros)
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
					dados << "#{conta.codigo_banco}".adjust_size_to(3,'0', :right)
					dados << ''.adjust_size_to(5,'0', :right)
					dados << "#{conta.get_especie_titulo(pagamento.especie_titulo, 400)}".adjust_size_to(2, '0', :right)
					dados << 'N'
					dados << pagamento.data_emissao_formatado('%d%m%y')

					# 1a / 2a Instrução, conforme documentação (pag. 11, Nota 09):
					dados << ''.adjust_size_to(2,'0', :right) # 1a Instrução
					dados << ''.adjust_size_to(2,'0', :right) # 2a Instrução
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
					detalhe << "#{pagamento.valor_mora_formatado}".adjust_size_to(13,'0', :right ) 
					detalhe << "#{pagamento.data_desconto_formatado('%d%m%y')}".adjust_size_to(6,'0', :right )
					detalhe << "#{pagamento.valor_desconto_formatado}".adjust_size_to(13,'0', :right )
					detalhe << "#{pagamento.valor_iof_formatado}".adjust_size_to(13,'0', :right )
					detalhe << "#{pagamento.valor_abatimento_formatado}".adjust_size_to(13,'0', :right )
					detalhe
				end

				# Informações referente aos dados do sacado/pagador
				# Posição: 219 a 394
				# POSIÇÂO      TAM.   Descrição
				# 219 a 220    002    Identificação do Tipo de Inscrição do Pagador
				# 221 a 234    014    No Inscrição do Pagador
				# 235 a 264    030    Nome do Pagador
				# 265 a 274    010    Complemento Registro (Brancos)
				# 275 a 314    040    Endereço Pagador
				# 315 a 326    012    Bairro Pagador
				# 327 a 331    005    CEP
				# 332 a 334    003    Sufixo do CEP
				# 335 a 349    015    Cidade Pagador
				# 350 a 351    002    UF Pagador
				# 352 a 391    040    Observações/Mensagem ou Sacador/Avalista *
				# 292 a 293    002    Número de Dias Para Protesto
				# 294 a 294    001    Complemento Registro (Branco)
				#
				# Tamanho: 176
				def informacoes_do_sacado(pagamento, sequencial)
					info = ''
					# Tipo de Inscrição do Pagador: "01" = CPF , "02" = CNPJ , "03" = PIS/PASEP , "98" = Não tem , "99" = Outros
					info << "#{pagamento.pagador.tipo_cpf_cnpj}".adjust_size_to(2, '0', :right)
					info << "#{pagamento.pagador.cpf_cnpj}".adjust_size_to(14, '0', :right)
					info << "#{pagamento.pagador.nome}".adjust_size_to(30)
					info << ''.adjust_size_to(10)                                         # Complemento Registro (Brancos)
					info << "#{pagamento.pagador.endereco}".adjust_size_to(40)           
					info << "#{pagamento.pagador.bairro}".adjust_size_to(12)             
					info << "#{pagamento.pagador.cep}".adjust_size_to(8, '0', :right)    # CEP + Sufixo do CEP
					info << "#{pagamento.pagador.cidade}".adjust_size_to(15)             
					info << "#{pagamento.pagador.uf}".adjust_size_to(2)                  
					info << "#{sacador_avalista(pagamento)}".adjust_size_to(40)          # Observações/Mensagem ou Sacador/Avalista *
					info << ''.adjust_size_to(2)                                         # Quantidade de dias para Protesto
					info << ''.adjust_size_to(1)                                         # Complemento Registro (Brancos)
					info                                                
				end

				# * Composição dados Sacador/Avalista
				# Para CNPJ:
				#      Posição 352 à 372 - Preencher com o nome do Sacador/Avalista.
				#      Posição 373 - Preencher com "espaço"
				#      Posição 374 à 377 - Preencher com o literal "CNPJ"
				#      Posição 378 à 391 - Preencher com o número do CNPJ do Sacador/Avalista
				#
				# Para CPF:
				#      Posição 352 à 376 - Preencher com o nome do Sacador/Avalista.
				#      Posição 377 - Preencher com "espaço"
				#      Posição 378 à 380 - Preencher com o literal "CPF"
				#      Posição 381 à 391 - Preencher com o número do CPF do Sacador/Avalista
				#
				# Tamanho: 40
				def sacador_avalista(pagamento)
					info = ''
					if "#{pagamento.pagador.tipo_documento_avalista}".to_i == 2
						info << "#{pagamento.pagador.nome_avalista}".adjust_size_to(21)      # Sacador/Avalista (Nome)
						info << ''.adjust_size_to(1)                                         # Complemento Registro (Branco)
						info << "CNPJ"                                                       # CNPJ
						info << "#{pagamento.pagador.documento_avalista}".adjust_size_to(14) # Sacador/Avalista (CNPJ)
					elsif "#{pagamento.pagador.tipo_documento_avalista}".to_i == 1
						info << "#{pagamento.pagador.nome_avalista}".adjust_size_to(25)      # Sacador/Avalista (Nome)
						info << ''.adjust_size_to(1)                                         # Complemento Registro (Branco)
						info << "CPF"                                                        # CPF
						info << "#{pagamento.pagador.documento_avalista}".adjust_size_to(11) # Sacador/Avalista (CPF)
					end
					info
				end

			end
		end
	end
end