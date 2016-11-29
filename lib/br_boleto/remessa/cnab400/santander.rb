# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab400
			class Santander < BrBoleto::Remessa::Cnab400::Base
				def conta_class
					BrBoleto::Conta::Santander
				end

			########## VALIDAÇÕES ESPECÍFICAS DESTE OBJETO PARA A CONTA ############
				def valid_codigo_transmissao_required; true end # <= Código de Transmissão é obrigatória


			############################## HEADER ######################################

				# Código da remessa
				# Tipo: Numérico
				# Tamanho: 001
				def header_posicao_002_a_002
					'1'
				end

				# Complemento do registro
				# POSIÇÂO    TAM.  Descrição
				#--------------------------------
				# 101 a 116  016   Zeros
				# 117 a 391  274   Brancos
				# 392 a 394  003   Zeros
				#
				# Tamanho: 294
				def complemento_registro
					complemento = ''
					complemento << ''.adjust_size_to(16, '0', :right)
					complemento << ''.adjust_size_to(275)
					complemento << ''.adjust_size_to(3, '0', :right)
					complemento
				end

			############################# DETALHE #################################

				# Informações da conta <- Específico para cada banco
				# Posição: 018 até 037 (Detalhe) = Código de Transmissão
				# Posição: 027 até 046 (Header)  = Código de Transmissão
				# Tamanho: 020				
				def informacoes_da_conta(local)
					"#{conta.codigo_transmissao}".adjust_size_to(20, '0', :right)
				end

				# Nosso numero do pagamento e outras informações
				# Posição: 063 até 108
				# POSIÇÂO    TAM.  Descrição
				# -----------------------------------------------------
				# 063 a 070  008   Nosso Número
				# 071 a 076  006   Data do segundo desconto
				# 077 a 077  001   Branco
				# 078 a 078  001   Informação de multa
				# 079 a 082  004   Percentual multa por atraso %
				# 083 a 084  002   Unidade de valor moeda corrente (00)
				# 085 a 097  013   Valor do título em outra unidade
				# 098 a 101  004   Brancos
				# 102 a 107  006   Data para cobrança de multa
				# 108 a 108  001   Cod. Carteira
				#
				# Tamanho: 46
				def detalhe_posicao_063_076(pagamento, sequencial)
					detalhe_posicao_063_108(pagamento)
				end
				def detalhe_posicao_077_108(pagamento, sequencial)
					''
				end
				def detalhe_posicao_063_108(pagamento)
					info = ''
					info << "#{nosso_numero_formatado(pagamento)}".adjust_size_to(8, '0', :right)
					info << ''.adjust_size_to(6, '0', :right)
					info << ''.adjust_size_to(1)
					info << "#{conta.get_codigo_multa(pagamento.codigo_multa)}".adjust_size_to(1, '0', :right)
					info << "#{pagamento.valor_multa_formatado(4)}".adjust_size_to(4, '0', :right)
					info << '00'
					info << ''.adjust_size_to(13, '0', :right)
					info << ''.adjust_size_to(4)
					info << "#{pagamento.data_multa_formatado}".adjust_size_to(6, '0', :right)
					info << "#{conta.get_tipo_cobranca(conta.codigo_carteira, 400)}".adjust_size_to(1, '1') 
					info
				end
				def nosso_numero_formatado(pagamento)
					nosso_numero = "#{pagamento.nosso_numero}".adjust_size_to(13, '0', :right)
					#nosso_numero.reverse.adjust_size_to(8, '0', :right).reverse
					nosso_numero[5..12]
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

					# 1a / 2a Instrução, conforme documentação (pag. 20, Nota 11):
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
				# 235 a 274    040    Nome do Pagador
				# 275 a 314    040    Endereço Pagador
				# 315 a 326    012    Bairro Pagador
				# 327 a 331    005    CEP
				# 332 a 334    003    Sufixo do CEP
				# 335 a 349    015    Cidade Pagador
				# 350 a 351    002    UF Pagador
				# 352 a 381    030    Nome Sacador/Avalista
				# 382 a 382    001    Complemento Registro (Brancos)

				# 383 a 383    001    Identificador do Complemento (I)
				# 384 a 385    002    Complemento
				# 386 a 391    006    Brancos
				# 392 a 393    002    Quantidade de dias
				# 394 a 394    001    Complemento Registro (Branco)


				# Tamanho: 176
				def informacoes_do_sacado(pagamento, sequencial)
					info = ''
					# Tipo de Inscrição do Pagador: "01" = CPF , "02" = CNPJ , "03" = PIS/PASEP , "98" = Não tem , "99" = Outros
					info << "#{pagamento.pagador.tipo_cpf_cnpj}".adjust_size_to(2, '0', :right)
					info << "#{pagamento.pagador.cpf_cnpj}".adjust_size_to(14, '0', :right)
					info << "#{pagamento.pagador.nome}".adjust_size_to(40)
					info << "#{pagamento.pagador.endereco}".adjust_size_to(40)           
					info << "#{pagamento.pagador.bairro}".adjust_size_to(12)             
					info << "#{pagamento.pagador.cep}".adjust_size_to(8, '0', :right)    # CEP + Sufixo do CEP
					info << "#{pagamento.pagador.cidade}".adjust_size_to(15)             
					info << "#{pagamento.pagador.uf}".adjust_size_to(2)                  
					info << "#{pagamento.pagador.nome_avalista}".adjust_size_to(30)      # Sacador/Avalista (Nome)
					info << ''.adjust_size_to(1)                                         # Complemento Registro (Brancos)
					info << 'I'                                                          # Identificador do Complemento (I)

					info << complemento_remessa
					info << ''.adjust_size_to(6)                                         # Brancos
					info << '00'                                                         # Quantidade de dias
					info << ''.adjust_size_to(1)                                         # Complemento Registro (Brancos)
					info                                                
				end

				# Ultimo digito da conta corrente +  digito da conta corrente
				def complemento_remessa
					"#{conta.conta_corrente[-1]}#{conta.conta_corrente_dv}"
				end

			############################# TRAILER #################################
				# 
				# Posição: 002 a 394
				# POSIÇÂO      TAM.   Descrição
				# 002 a 007    006    Quantidade total de linhas no arquivo
				# 008 a 020    013    Valor total dos títulos
				# 021 a 394    374    Zeros
				#
				# Tamanho: 393
				def trailer_arquivo_posicao_002_a_394(sequencial)
					trailer = ''
					trailer << "#{sequencial}".adjust_size_to(6, '0', :right)
					trailer << "#{valor_documento(13)}".adjust_size_to(13, '0', :right)
					trailer << ''.adjust_size_to(374, '0')
					trailer
				end
				def valor_documento(tamanho)
					valor_doc = pagamentos.map(&:valor_documento).sum 
					BrBoleto::Helper::Number.new(valor_doc).formata_valor_monetario(tamanho) 
				end

			end
		end
	end
end