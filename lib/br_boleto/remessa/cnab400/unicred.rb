# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab400
	  		# A Unicred (CobExpress) utiliza o layout de boleto e os arquivos de remessa/retorno disponibilizados pelo Banco Bradesco.
			class Unicred < BrBoleto::Remessa::Cnab400::Bradesco
				def conta_class
					BrBoleto::Conta::Unicred
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
					detalhe = ''.adjust_size_to(14)
					detalhe << "#{pagamento.numero_documento}".adjust_size_to(11, '0', :right)
					detalhe
				end

				# Informações referente aos dados do sacado/pagador
				# Posição: 219 a 394
				# POSIÇÂO      TAM.   Descrição
				# 219 a 220    002    Identificação do Tipo de Inscrição do Pagador
				# 221 a 234    014    No Inscrição do Pagador
				# 235 a 274    040    Nome do Pagador
				# 275 a 314    040    Endereço
				# 315 a 326    012    1a Mensagem
				# 327 a 331    005    CEP
				# 332 a 334    003    Sufixo do CEP
				# 335 a 394    060    Sacador/Avalista ou 2a Mensagem
				#------------------------------------------------------------------------------
				# OBS: Como a impressão é realizada no CobExpress, 
				# então as posições 335 a 394 seguem o seguinte formato:
				# 335 a 349    015    Inscrição do Sacador/Avalista (CPF/CNPJ)
				# 350 a 351    002    Brancos
				# 352 a 394    043    Nome Sacador/Avalista
				#
				# Tamanho: 176
				def informacoes_do_sacado(pagamento, sequencial)
					info = ''
					# Tipo de Inscrição do Pagador: "01" = CPF , "02" = CNPJ , "03" = PIS/PASEP , "98" = Não tem , "99" = Outros
					info << "#{pagamento.pagador.tipo_cpf_cnpj}".adjust_size_to(2, '0', :right)
					info << "#{pagamento.pagador.cpf_cnpj}".adjust_size_to(14, '0', :right)
					info << "#{pagamento.pagador.nome}".adjust_size_to(40)
					info << "#{pagamento.pagador.endereco}".adjust_size_to(40)        # Endereço
					info << ''.adjust_size_to(12)                                     # 1a Mensagem
					info << "#{pagamento.pagador.cep}".adjust_size_to(8, '0', :right) # CEP + Sufixo do CEP
					info << "#{pagamento.pagador.documento_avalista}".rjust(15)       # Sacador/Avalista (CPF/CNPJ)
					info << ''.adjust_size_to(2)                                      # Brancos
					info << "#{pagamento.pagador.nome_avalista}".adjust_size_to(43)   # Sacador/Avalista (Nome)
					info                                                
				end
				
			end
		end
	end
end