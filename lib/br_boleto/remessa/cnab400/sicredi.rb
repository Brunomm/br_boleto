# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab400
			class Sicredi < BrBoleto::Remessa::Cnab400::Base
				def conta_class
					BrBoleto::Conta::Sicredi
				end

         ############################# HEADER ########################################

				# Código da remessa
				# Tipo: Numérico
				# Tamanho: 001
				def header_posicao_002_a_002
					'1'
				end

				# Informações da conta <- Específico para cada banco
				def informacoes_da_conta(local)

					# Detalhe Posição:  017 até 037
					if local == :detalhe 
						# POSIÇÂO    TAM.  Descrição
						# 017 a 017  001  Tipo de moeda     ( “A” – Real )
						# 018 a 018  001  Tipo de desconto  ( “B” – Percentual )
						# 019 a 019  001  Tipo de juros     ( “B” – Percentual )
						# 020 a 037  018  Branco
						info = 'ABB'
						info << ''.adjust_size_to(18)

					# Header Posição: 027 até 046
					elsif local == :header
						# POSIÇÂO    TAM.  Descrição
						# 027 a 031  005  Contas Corrente
						# 032 a 045  014  CPF/CNPJ
						# 046 a 046  001  Branco
						info = ''
						info << "#{conta.conta_corrente}".adjust_size_to(5, '0', :right)
						info << "#{conta.cpf_cnpj}".adjust_size_to(14, '0', :right)
						info << ''.adjust_size_to(1)
						info
					end
				end

				# Nome do cedente
				# Deixar em Brancos (sem preenchimento)
				# Tamanho: 030
				def header_posicao_047_a_076
					''.adjust_size_to(30)
				end

				# Data de Gravação
				# Formato da data = AAAAMMDD
				# Tamanho: 008
				def header_posicao_095_a_102
					data_geracao('%Y%m%d')
				end
				def header_posicao_095_a_100
					header_posicao_095_a_102
				end

				# Complemento do registro
				# Posição 103 até 394
				# POSIÇÂO         TAM.     Descrição
				#-----------------------------------------------
				# 103 a 110       008      Brancos
				# 111 a 117       007      Número da remessa
				# 118 a 390       273      Brancos
				# 391 a 394       004      Versão do sistema (2.00)
				#
				# Tamanho: 292
				def header_posicao_101_a_394
					header_posicao_103_a_394
				end
				def header_posicao_103_a_394
					info = ''.adjust_size_to(8)
					info <<  "#{sequencial_remessa}".adjust_size_to(7, '0', :right)
					info << ''.adjust_size_to(273)
					info << '2.00'
					info
				end

         ############################ DETALHE ########################################

				# Detalhe Posição 002 a 004
				# POSIÇÂO         TAM.     Descrição
				#-----------------------------------------------
				# 002 a 002       001      Tipo de cobrança  (“A” - Sicredi Com Registro)
				# 003 a 003       001      Tipo de carteira  (“A” – Simples)
				# 004 a 004       001      Tipo de Impressão ("A” – Normal)
				#
				# Tamanho: 003
				def detalhe_posicao_002_004(pagamento)
					detalhe = ''
					detalhe << "#{conta.get_tipo_cobranca(conta.carteira)}".adjust_size_to(1, 'A')
					detalhe << "#{conta.get_tipo_cobranca(conta.codigo_carteira)}".adjust_size_to(1, 'A')
					detalhe << "#{conta.get_tipo_impressao(pagamento.tipo_impressao)}".adjust_size_to(1, 'A')
					detalhe
				end
				def detalhe_posicao_002_003(pagamento)
					detalhe_posicao_002_004(pagamento)
				end


				# Detalhe Posição 005 a 016
				# POSIÇÂO         TAM.     Descrição
				#-----------------------------------------------
				# 005 a 016       012      Deixar em Branco
				#
				# Tamanho: 012
				def detalhe_posicao_005_016
					detalhe = ''.adjust_size_to(12)
				end
				def detalhe_posicao_004_017
					detalhe_posicao_005_016
				end

				# Detalhe Posição 038 a 062
				#-----------------------------------------------
				# POSIÇÂO         TAM.     Descrição
				# 038 a 047       010      Deixar em Branco
				# 048 a 056       009      Nosso número Sicredi
				# 057 a 062       006      Deixar em Branco
				#
				# Tamanho: 25
				def detalhe_posicao_038_062(pagamento)
					detalhe = "".adjust_size_to(10)
					detalhe << "#{pagamento.nosso_numero}".adjust_size_to(9, '0', :right)
					detalhe << "".adjust_size_to(6)
					detalhe
				end

				# Detalhe Posição 063 a 108
				# POSIÇÂO         TAM.     Descrição
				#-----------------------------------------------
				# 063 a 070       008      Data da Instrução
				# 071 a 071       001      Campo alterado ( Branco )
				# 072 a 072       001      Postagem do título ( “N” - Não postar e remeter o título para o beneficiário )
				# 073 a 073       001      Branco
				# 074 a 074       001      Emissão do boleto
				# 075 a 076       002      Número da parcela do carnê
				# 077 a 078       002      Número Total de parcelas do carnê
				# 079 a 082       004      Brancos
				# 083 a 092       010      Valor Desconto por dia de antecipação (Preencher com Zeros)
				# 093 a 096       004      % multa por pagamento em atraso (Preencher com Zeros)
				# 097 a 108       012      Brancos
				#
				# Tamanho: 46
				def detalhe_posicao_063_076(pagamento, sequencial)
					detalhe_posicao_063_108(pagamento)
				end
				def detalhe_posicao_077_108(pagamento, sequencial)
					''
				end
				def detalhe_posicao_063_108(pagamento)
					dados = ''
					dados << ''.adjust_size_to(8)
					dados << ''.adjust_size_to(1)
					dados << 'N'
					dados << ''.adjust_size_to(1)
					dados << "#{conta.get_identificacao_emissao(pagamento.emissao_boleto)}".adjust_size_to(1, 'A')
					dados << ''.adjust_size_to(2)
					dados << ''.adjust_size_to(2)
					dados << ''.adjust_size_to(4)
					dados << ''.adjust_size_to(10, '0')
					dados << ''.adjust_size_to(4, '0')
					dados << ''.adjust_size_to(12)
					dados
				end

				# Informações referente ao pagamento
				# POSIÇÂO         TAM.     Descrição
				#-----------------------------------------------
				# 121 a 126    006    Data do Vencimento do Título
				# 127 a 139    013    Valor do Título
				# 140 a 148    009    Brancos
				# 149 a 149    001    Espécie de Título 
				# 150 a 150    001    Identificação (Sempre 'N')
				# 151 a 156    006    Data da emissão do Título
				# 157 a 158    002    1a instrução
				# 159 a 160    002    2a instrução 
				#
				# Tamanho: 40
				def informacoes_do_pagamento(pagamento, sequencial)
					info = ''
					info << pagamento.data_vencimento_formatado('%d%m%y')
					info << pagamento.valor_documento_formatado(13)
					info << ''.adjust_size_to(9)
					info << "#{conta.get_especie_titulo(pagamento.especie_titulo, 240)}".adjust_size_to(1, '0', :right)
					info << 'N'
					info << pagamento.data_emissao_formatado('%d%m%y')
					info << ''.adjust_size_to(2,'0', :right) # 1a Instrução
					info << ''.adjust_size_to(2,'0', :right) # 2a Instrução
					info
				end

				# Informações referente aos juros e multas do pagamento
				# Posição: 161 a 218
				# POSIÇÂO      TAM.   Descrição
				# 161 a 173    013    Valor a ser cobrado por Dia de Atraso
				# 174 a 179    006    Data Limite P/Concessão de Desconto
				# 180 a 192    013    Valor do Desconto
				# 193 a 205    013    Valor do IOF (Preencher com Zeros)
				# 206 a 218    013    Valor do Abatimento a ser concedido ou cancelado
				# Tamanho: 58
				def detalhe_multas_e_juros_do_pagamento(pagamento, sequencial)
					detalhe = ''
					detalhe << "#{pagamento.valor_mora_formatado}".adjust_size_to(13,'0', :right ) 
					detalhe << "#{pagamento.data_desconto_formatado('%d%m%y')}".adjust_size_to(6,'0', :right )
					detalhe << "#{pagamento.valor_desconto_formatado}".adjust_size_to(13,'0', :right )
					detalhe << ''.adjust_size_to(13,'0')
					detalhe << "#{pagamento.valor_abatimento_formatado}".adjust_size_to(13,'0', :right )
					detalhe
				end

				# Informações referente aos dados do sacado/pagador
				# Posição: 219 a 394
				# POSIÇÂO      TAM.   Descrição
				# 219 a 220    002    Identificação do Tipo de Inscrição do Pagador
				# 221 a 234    014    No Inscrição do Pagador
				# 235 a 274    040    Nome do Pagador
				# 275 a 314    040    Endereço Completo
				# 315 a 319    005    Código do Pagador na cooperativa beneficiária ( Preencher com zeros )
				# 320 a 325    006    Preencher com zeros
				# 326 a 326    001    Branco
				# 332 a 334    003    Sufixo do CEP
				# 335 a 339    005    Código do Pagador junto ao cliente (Preencher com Zeros)
				# 340 a 353    014    CPF/CNPJ Sacador/Avalista ou 2a Mensagem
				# 354 a 394    041    Nome Sacador/Avalista
				# Tamanho: 176
				def informacoes_do_sacado(pagamento, sequencial)
					info = ''
					info << "#{pagamento.pagador.tipo_cpf_cnpj}".adjust_size_to(2, '0', :right)
					info << "#{pagamento.pagador.cpf_cnpj}".adjust_size_to(14, '0', :right)
					info << "#{pagamento.pagador.nome}".adjust_size_to(40)
					info << "#{pagamento.pagador.endereco}".adjust_size_to(18)           # Endereço Completo
					info << "#{pagamento.pagador.bairro}".adjust_size_to(10)             # Endereço Completo
					info << "#{pagamento.pagador.cidade}".adjust_size_to(10)             # Endereço Completo
					info << "#{pagamento.pagador.uf}".adjust_size_to(2)                  # Endereço Completo
					info << ''.adjust_size_to(5, '0')                                    # Código do Pagador na cooperativa
					info << ''.adjust_size_to(6, '0')                                    # Preencher com zeros
					info << ''.adjust_size_to(1)                                         # Preencher com Espaço em Branco
					info << "#{pagamento.pagador.cep}".adjust_size_to(8, '0', :right)    # CEP + Sufixo do CEP
					info << ''.adjust_size_to(5, '0')                                    # Código do Pagador
					info << "#{pagamento.pagador.documento_avalista}".adjust_size_to(14) # Sacador/Avalista (CPF/CNPJ)
					info << "#{pagamento.pagador.nome_avalista}".adjust_size_to(41)      # Sacador/Avalista (Nome)
					info                                                
				end

			############################ TRAILER #######################################

				# Detalhe Posição 002 a 0349
				# POSIÇÂO         TAM.     Descrição
				#-----------------------------------------------
				# 002 a 002       001      Identificação do arquivo remessa
				# 003 a 005       003      Número do Sicredi (748)
				# 006 a 010       005      Código do beneficiário
				# 011 a 394       384      Bracos
				#
				# Tamanho: 393
				def trailer_arquivo_posicao_002_a_394(sequencial)
					dados = ''
					dados << '1'                                                         # Identificação do arquivo remessa
					dados << "#{conta.codigo_banco}".adjust_size_to(3, '0', :right)      # Número do Sicredi
					dados << "#{conta.conta_corrente}".adjust_size_to(5, '0', :right)    # Código do beneficiário
					dados << ''.adjust_size_to(384)
					dados
				end

			end
		end
	end
end