# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab400
	  		# A Unicred (CobExpress) utiliza o layout de boleto e os arquivos de remessa/retorno disponibilizados pelo Banco Bradesco.
			class Unicred < BrBoleto::Remessa::Cnab400::Base
				def conta_class
					BrBoleto::Conta::Unicred
				end

############################## HEADER #########################################################

				# Código da remessa
				# Tipo: Numérico
				# Tamanho: 001
				def header_posicao_002_a_002
					'1'
				end

				# Complemento do registro
				# Posição: 101 até 394
				#  POSIÇÂO  TAM.  Descrição
				# 101 a 107  007  Branco
				# 108 a 110  003  Código da Variação carteira da UNICRED (000)
				# 111 a 117  007  No Seqüencial de Remessa (deve iniciar de 0000001 e incrementado de + 1 a cada NOVO Arquivo Remessa)
				# 118 a 394  277  Branco
				# Tamanho total: 294
				def complemento_registro
					info = ''.adjust_size_to(7)
					info << '000'
					info <<  "#{sequencial_remessa}".adjust_size_to(7, '0', :right)
					info << ''.adjust_size_to(277)
					info
				end
###############################################################################################

############################## DETALHE #########################################################

				# Informações Opcionais no Bradesco.
				# Somente deverão ser preenchidos, caso o cliente Beneficiário esteja previamente
				# cadastrado para operar com a modalidade de cobrança com débito automático
				def detalhe_posicao_002_003(pagamento)
					''
				end
				def detalhe_posicao_004_017(pagamento, sequencial)
					''
				end

				# Informações da conta <- Específico para cada banco
				# Posição: 018 até 037
				# Tipo: Numérico
				# Tamanho: 020
				def informacoes_da_conta(local)

					# POSIÇÂO    TAM.  Descrição
					# 002 a 006  005   Agência do BENEFICIÁRIO na UNICRED
					# 007 a 007  001  Dígito da Agência
					# 008 a 019  012  Conta Corrente
					# 020 a 020  001  Dígito Conta Corrente
					# 021 a 021  001  Zero
					# 022 a 024  003  Código da Carteira
					# 025 a 037  013  Zeros
					if local == :detalhe
						info = ''
						info << "#{conta.agencia}".adjust_size_to(5, '0', :right)
						info << "#{conta.agencia_dv}".adjust_size_to(1, '0')
						info << "#{conta.conta_corrente}".adjust_size_to(12, '0', :right)
						info << "#{conta.conta_corrente_dv}".adjust_size_to(1, '0', :right)
						info << '0'
						info << '021'
						info << ''.rjust(13, '0')
						info

					# POSIÇÂO    TAM.  Descrição
					# 027 a 046  020   Codigo da Empresa
					elsif local == :header
						info =  "#{conta.codigo_empresa}".adjust_size_to(20, '0', :right) # Será informado pelo Bradesco, quando do cadastramento da Conta beneficiário na sua Agência.
					end
				end

				# detalhe_posicao_038_062
				# Numero de controle do participante
				# DESCRIÇÃO         TAMANHO     POSIÇÃO
				# ---------------------------------------------------------
				# Brancos             14          38 - 51
				# Numero Doc.         11          52 - 62
				#
				# TOTAL = 25 posições
				def detalhe_posicao_038_062(pagamento)
					"#{pagamento.numero_documento}".adjust_size_to(25, ' ')
				end

				# Nosso numero e informações do pagaemnto
				# Tamanho: 14
				def detalhe_posicao_063_076(pagamento, sequencial)
					dados_do_pagamento(pagamento)
				end

				# Nosso numero do pagamento e outras informações
				# Posição: 063 até 108
				# POSIÇÂO    TAM.  Descrição
				# 063 a 065  003   Numero do banco 136
				# 066 a 067  002  Zeros
				# 068 a 092  025  Branco
				# 093 a 093  001  Filler Zero
				# 094 a 094  001  Código da Multa
				# 095 a 104  010  Valor/Percentual da Multa
				# 105 a 105  001  Tipo de Valor Mora
				# 106 a 106  001  Filler Zeros
				# 107 a 108  002  Branco
				# Tamanho: 46
				def detalhe_posicao_063_076(pagamento, sequencial)
					detalhe_posicao_063_108(pagamento)
				end
				def detalhe_posicao_077_108(pagamento, sequencial)
					''
				end
				def detalhe_posicao_063_108(pagamento)
					info = '136'
					info << '00'
					info << ''.rjust(25, ' ')
					info << '0'
					if "#{pagamento.codigo_multa}".in?(%w[1 2])
						info << '2'
						info << pagamento.percentual_multa_formatado(10) # tem multa: preencher com percentual da multa com 2 decimais
					else
						info << '3'
						info << ''.adjust_size_to(10)
					end

					if "#{pagamento.codigo_juros}".in?(%w[1 2])
						info << '1'
					else
						info << '5'
					end

					info << '0'
					info << ''.adjust_size_to(2)
					info
				end

				# Seu número
				# Tipo: N
				# Tamanho: 10
				def detalhe_posicao_111_120(pagamento, sequencial)
					"#{pagamento.numero_documento}".adjust_size_to(10, ' ')
				end


				# Informações referente ao pagamento
				# Posição 121 até 160
				# POSIÇÂO      TAM.   Descrição
				# 121 a 126    006    Data do Vencimento do Título
				# 127 a 139    013    Valor do Título
				# 140 a 142    003    Filler
				# 143 a 147    005    Filler Zeros
				# 148 a 149    002    Filler Zeros
				# 150 a 150    001    Código do desconto
				# 151 a 156    006    Data da emissão do Título
				# 157 a 160    004    Filler Zeros
				# Tamanho: 40
				def informacoes_do_pagamento(pagamento, sequencial)
					dados = ''
					dados << pagamento.data_vencimento_formatado('%d%m%y')
					dados << pagamento.valor_documento_formatado(13)
					dados << ''.adjust_size_to(3) # 140 a 142
					dados << ''.adjust_size_to(7,'0', :right) # 143 a 149
					dados << "#{pagamento.cod_desconto}".adjust_size_to(1, '0') # 150
					dados << pagamento.data_emissao_formatado('%d%m%y') # 151 a 156
					dados << ''.adjust_size_to(4,'0', :right) # 157 a 160

					# dados << "#{conta.get_especie_titulo(pagamento.especie_titulo, 400)}".adjust_size_to(2, '0', :right)

					dados

				end

				# Informações de multa e juros
				# POSIÇÂO    TAM.   Descrição
				# 161 a 173  013   Valor de Mora  Vide Obs. X
				# 174 a 179  006   Data Limite P/Concessão de Desconto
				# 180 a 192  013   Valor do Desconto
				# 193 a 203  011   Nosso Número na UNICRED
				# 204 a 205  002   Zeros
				# 206 a 218  013   Valor do Abatimento a ser concedido
				# Tamanho: 58
				def detalhe_posicao_161_218(pagamento, sequencial)
					info = ''
					info << pagamento.valor_juros_monetario_formatado(13)
					info << pagamento.data_desconto_formatado
					info << pagamento.valor_desconto_formatado(13)
					info << "#{pagamento.nosso_numero.to_i}".adjust_size_to(11, '0', :right)
					info << '00'
					info << pagamento.valor_abatimento_formatado(13)
					info.adjust_size_to(58, '5', :right)
				end


				# Informações referente aos dados do sacado/pagador
				# Posição: 219 a 394
				# POSIÇÂO    TAM.   Descrição
				#  219 a 220 002  Identificação do Tipo de Inscrição do Pagador
				#  221 a 234 014  Nº Inscrição do Pagador
				#  235 a 274 040  Nome/Razão Social do Pagador
				#  275 a 314 040  Endereço do Pagador
				#  315 a 326 012  Bairro do Pagador
				#  327 a 334 008  CEP do Pagador
				#  335 a 354 020  Cidade do Pagador
				#  355 a 356 002  UF do Pagador
				#  357 a 394 038  Pagador/Avalista
				#
				# Tamanho: 176
				def informacoes_do_sacado(pagamento, sequencial)
					info = ''
					# Tipo de Inscrição do Pagador: "01" = CPF , "02" = CNPJ , "03" = PIS/PASEP , "98" = Não tem , "99" = Outros
					info << "#{pagamento.pagador.tipo_cpf_cnpj}".adjust_size_to(2, '0', :right)
					info << "#{pagamento.pagador.cpf_cnpj}".adjust_size_to(14, '0', :right)
					info << "#{pagamento.pagador.nome}".adjust_size_to(40)
					info << "#{pagamento.pagador.endereco}".adjust_size_to(40) # Endereço
					info << "#{pagamento.pagador.bairro}".adjust_size_to(12) # Bairro
					info << "#{pagamento.pagador.cep}".adjust_size_to(8, '0', :right) # CEP + Sufixo do CEP
					info << "#{pagamento.pagador.cidade}".adjust_size_to(20) # Cidade
					info << "#{pagamento.pagador.uf}".adjust_size_to(2) # UF
					info << ''.adjust_size_to(38)
					info
				end
################################################################################################

			end
		end
	end
end