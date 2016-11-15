# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab400
			class Itau < BrBoleto::Remessa::Cnab400::Base
				def conta_class
					BrBoleto::Conta::Itau
				end

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
				# 101 a 394  294   Brancos
				# Tamanho total: 294
				def complemento_registro
					''.adjust_size_to(294)
				end

			############################# DETALHE #################################

				# Informações da conta <- Específico para cada banco
				# Posição: 018 até 037 (Detalhe)
				# Posição: 027 até 046 (Header)
				# Tamanho: 020				
				def informacoes_da_conta(local)

					# POSIÇÂO:
					#  Detalhe  |  Header       TAM.  Descrição
					#  18 a 21     27 a 30      004   Agência
					#  22 a 23     31 a 32      002   Zeros
					#  24 a 28     33 a 37      005   Conta Corrente
					#  29 a 29     38 a 38      001   Conta Corrente DV

					info = "#{conta.agencia}".adjust_size_to(4, '0', :right)
					info << '00'
					info << "#{conta.conta_corrente}".adjust_size_to(5, '0', :right)
					info << "#{conta.conta_corrente_dv}".adjust_size_to(1, '0', :right)

					if local == :detalhe 
						# POSIÇÂO    TAM.  Descrição
						# -------------------------------
						# 030 a 033  004   Brancos
						# 034 a 037  004   Cod. Instrução

						info << ''.adjust_size_to(4)
						info << ''.adjust_size_to(4, "0")

					elsif local == :header
						# POSIÇÂO    TAM.  Descrição
						# -------------------------------
						# 039 a 046  008   Brancos

						info << ''.adjust_size_to(8)
					end

					info
				end

				# Nosso numero do pagamento e outras informações
				# Posição: 063 até 108
				# POSIÇÂO    TAM.  Descrição
				# -----------------------------------------------------
				# 063 a 070  008   Numero Documento
				# 071 a 083  013   QUANTIDADE DE MOEDA VARIÁVEL
				# 084 a 086  003   Carteira
				# 087 a 107  021   Uso do banco
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
					info << "#{pagamento.numero_documento}".adjust_size_to(8, '0', :right)
					info << ''.adjust_size_to(13, '0', :right) # Este campo deverá ser preenchido com zeros caso a moeda seja o Real
					info << "#{conta.carteira}".adjust_size_to(3, '0', :right)
					info << ''.adjust_size_to(21)
					info << "#{conta.get_codigo_carteira}".adjust_size_to(1, 'I') 
					info
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
				# 235 a 264    030    Nome do Pagador
				# 265 a 274    010    Complemento Registro (Brancos)
				# 275 a 314    040    Endereço Pagador
				# 315 a 326    012    Bairro Pagador
				# 327 a 331    005    CEP
				# 332 a 334    003    Sufixo do CEP
				# 335 a 349    015    Cidade Pagador
				# 350 a 351    002    UF Pagador
				# 352 a 381    030    Nome Sacador/Avalista

				# 282 a 285    004    Complemento Registro (Brancos)
				# 286 a 291    006    Data de mora
				# 292 a 293    002    Quantidade de dias
				# 294 a 294    001    Complemento Registro (Branco)

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
					info << "#{pagamento.pagador.nome_avalista}".adjust_size_to(30)      # Sacador/Avalista (Nome)
					info << ''.adjust_size_to(4)                                         # Complemento Registro (Brancos)

					info << ''.adjust_size_to(6, '0')                                    # Data de mora
					info << '03'                                                         # Quantidade de dias
					info << ''.adjust_size_to(1)                                         # Complemento Registro (Brancos)
					info                                                
				end

			end
		end
	end
end