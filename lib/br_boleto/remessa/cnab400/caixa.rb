# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab400
			class Caixa < BrBoleto::Remessa::Cnab400::Base
				def conta_class
					BrBoleto::Conta::Caixa
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
				# 101 a 389  289  Uso Exclusivo CAIXA (Brancos)
				# 390 a 394  005  No Seqüencial de Remessa (iniciar com '00001' e evoluir de 1 em 1 para cada Header de Arquivo)
				# Tamanho total: 294
				def complemento_registro
					complemento = ''
					complemento << ''.adjust_size_to(289)
					complemento <<  "#{sequencial_remessa}".adjust_size_to(5, '0', :right)
					complemento
				end

			############################# DETALHE #################################
				#
				# Informações da conta <- Específico para cada banco
				# Posição: 018 até 037 (Detalhe)
				# Posição: 027 até 046 (Header)
				# Tamanho: 020				
				def informacoes_da_conta(local)

					# POSIÇÂO:
					#  Detalhe  |  Header       TAM.  Descrição
					#  18 a 21     27 a 30      004   Agência
					#  22 a 27     31 a 36      006   Convênio
				
					info = ''
					info << "#{conta.agencia}".adjust_size_to(4, '0', :right)
					info << "#{conta.convenio}".adjust_size_to(6, '0', :right)

					if local == :header
						# POSIÇÂO    TAM.  Descrição
						# ---------------------------------------------------
						# 037 a 046  010   Uso Exclusivo CAIXA (Brancos)
						info << ''.adjust_size_to(10)
					end

					info
				end

				# detalhe_posicao_028_058
				# POSIÇÂO    TAM.  Descrição
				# -----------------------------------------------------
				# 028 a 028  001   Identificação da Emissão do Boleto
				# 029 a 029  001   ID Entrega/Distribuição do Boleto
				# 030 a 031  002   Comissão de Permanência (Informar '00')
				# 032 a 056  025   Número do Documento
				# 057 a 058  002   Carteira
				#
				# Tamanho: 31
				def detalhe_posicao_028_058(pagamento)
					detalhe = ''
					detalhe << "#{conta.get_identificacao_emissao(pagamento.emissao_boleto, 400)}".adjust_size_to(1, '0', :right)
					detalhe << "#{conta.get_distribuicao_boleto(pagamento.distribuicao_boleto)}".adjust_size_to(1, '0', :right)
					detalhe << "00"
					detalhe << "#{pagamento.numero_documento}".adjust_size_to(25, '0', :right)
					detalhe << "#{conta.carteira}".adjust_size_to(2, '0', :right)
					detalhe
					
				end
				def detalhe_posicao_038_062(pagamento)
					detalhe_posicao_028_058(pagamento)
				end

				# POSIÇÂO    TAM.  Descrição
				# -----------------------------------------------------
				# 059 a 073  015   Número do Documento
				# 074 a 076  003   Campos em branco
				#
				# Tamanho: 18
				def dados_do_pagamento(pagamento)
					detalhe = ''
					detalhe << "#{pagamento.numero_documento}".adjust_size_to(15, '0', :right)
					detalhe << "".adjust_size_to(3)
					detalhe
				end

				# POSIÇÂO    TAM.  Descrição
				# -----------------------------------------------------
				# 077 a 106  030   Mensagem a ser impressa no boleto
				# 107 a 108  002   Código da Carteira
				#
				# Tamanho: 32
				def detalhe_posicao_077_108(pagamento, sequencial)
					detalhe = ''
					detalhe << "".adjust_size_to(30)
					detalhe << "#{conta.get_tipo_cobranca(conta.codigo_carteira, 400)}".adjust_size_to(2, '0', :right)
					detalhe
				end


				# Informações referente ao pagamento
				# Posição 121 até 160
				# POSIÇÂO      TAM.   Descrição
				# 121 a 126    006    Data do Vencimento do Título
				# 127 a 139    013    Valor do Título
				# 140 a 142    003    Banco Encarregado da Cobrança (Preencher '104')
				# 143 a 147    005    Agência Depositária (Preencher com zeros)
				# 148 a 149    002    Espécie de Título 
				# 150 a 150    001    Identificação (Sempre 'N')
				# 151 a 156    006    Data da emissão do Título
				# 157 a 158    002    1a instrução (Código para Protesto / Devolução)
				# 159 a 160    002    2a instrução (Preencher com zeros)
				# Tamanho: 40
				def informacoes_do_pagamento(pagamento, sequencial)
					dados = ''
					dados << pagamento.data_vencimento_formatado('%d%m%y')
					dados << pagamento.valor_documento_formatado(13)
					dados << '104'
					dados << ''.adjust_size_to(5,'0', :right)
					dados << "#{conta.get_especie_titulo(pagamento.especie_titulo, 400)}".adjust_size_to(2, '0', :right)
					dados << 'N'
					dados << pagamento.data_emissao_formatado('%d%m%y')

					dados << "#{conta.get_codigo_protesto(pagamento.codigo_protesto, 400)}".adjust_size_to(2, '0', :right) # 1a Instrução
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
					detalhe << pagamento.valor_juros_monetario_formatado(13)
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
				# 275 a 314    040    Endereço Paagador
				# 315 a 326    012    Bairro do Pagador
				# 327 a 334    008    CEP
				# 335 a 349    015    Cidade do Pagador
				# 350 a 351    002    UF do Pagador
				# 352 a 357    006    Data da Multa
				# 358 a 367    010    Valor da Multa
				# 368 a 389    022    Nome Sacador/Avalista
				# 390 a 391    002    3a instrução (Preencher com '00' = Não imprime mensagem no verso do boleto)
				# 392 a 393    002    Número de dias para início do protesto/devolução
				# 394 a 394    001    Código da Moeda
				# Tamanho: 176
				def informacoes_do_sacado(pagamento, sequencial)
					info = ''
					# Tipo de Inscrição do Pagador: "01" = CPF , "02" = CNPJ , "03" = PIS/PASEP , "98" = Não tem , "99" = Outros
					info << "#{pagamento.pagador.tipo_cpf_cnpj}".adjust_size_to(2, '0', :right)
					info << "#{pagamento.pagador.cpf_cnpj}".adjust_size_to(14, '0', :right)
					info << "#{pagamento.pagador.nome}".adjust_size_to(40)
					info << "#{pagamento.pagador.endereco}".adjust_size_to(40)
					info << "#{pagamento.pagador.bairro}".adjust_size_to(12)
					info << "#{pagamento.pagador.cep}".adjust_size_to(8, '0', :right)
					info << "#{pagamento.pagador.cidade}".adjust_size_to(15)
					info << "#{pagamento.pagador.uf}".adjust_size_to(2)
					info << "#{pagamento.data_multa_formatado}".adjust_size_to(6, '0', :right)                       # Data da Multa
					info << "#{pagamento.valor_multa_formatado(10)}".adjust_size_to(10, '0', :right)                 # Valor da Multa
					info << "#{pagamento.pagador.nome_avalista}".adjust_size_to(22)                                  # Sacador/Avalista (Nome)
					info << "00"                                                                                     # 3a instrução
					info << "#{pagamento.dias_protesto}".adjust_size_to(2, '0', :right)                              # Número de dias protesto/devolução
					info << "#{conta.get_codigo_moeda(pagamento.codigo_moeda, 400)}".adjust_size_to(1, '1', :right)  # Código da Moeda
					info                                                
				end
			end
		end
	end
end