module BrBoleto
	module Remessa
		module Cnab400
			module Helper
				module Detalhe
					# Monta o registro segmento P do arquivo
					#
					# @param pagamento [BrBoleto::Remessa::Pagamento]
					#   objeto contendo os detalhes do boleto (valor, vencimento, sacado, etc)
					# @param nr_lote [Integer]
					#   numero do lote que o segmento esta inserido
					# @param sequencial [Integer]
					#   numero sequencial do registro no lote
					#
					# @return [String]
					#
					def monta_detalhe(pagamento, sequencial)
						# campos com * na frente nao foram implementados
						#                                                      # DESCRICAO                             TAMANHO
						detalhe =  ''

						detalhe << detalhe_posicao_001_001                        # Identificação do Registro Detalhe
						detalhe << detalhe_posicao_002_003(pagamento)             # Tipo de inscrição do beneficiario
						detalhe << detalhe_posicao_004_017(pagamento, sequencial) # CNPJ do beneficiario
						detalhe << detalhe_posicao_018_037(pagamento, sequencial) # Informações da conta (porém depende de cada banco)
						detalhe << detalhe_posicao_038_062(pagamento)             # Numero de controle do participante
						detalhe << detalhe_posicao_063_076(pagamento, sequencial) # Nosso número com DV
						detalhe << detalhe_posicao_077_108(pagamento, sequencial) # Diferente para cada banco
						detalhe << detalhe_posicao_109_110(pagamento, sequencial) # Comando/Movimento
						detalhe << detalhe_posicao_111_120(pagamento, sequencial) # Seu número
						detalhe << detalhe_posicao_121_160(pagamento, sequencial) # Informações do pagamento
						detalhe << detalhe_posicao_161_218(pagamento, sequencial) # Informações de multa e juros
						detalhe << detalhe_posicao_219_394(pagamento, sequencial) # Informações do sacado/pagador
						detalhe << detalhe_posicao_395_400(pagamento, sequencial) # Sequencial
						detalhe.upcase
					end

					# Identificação do Registro Detalhe
					# Padrão: 1
					# Tipo: Numero
					# Tamanho: 001
					def detalhe_posicao_001_001
						'1'
					end

					# Tipo de inscrição do beneficiario
					# 01 = CPF
					# 02 = CNPJ
					# Tipo: Numero
					# Tamanho: 002
					def detalhe_posicao_002_003(pagamento)
						conta.tipo_cpf_cnpj
					end

					# CNPJ/CPF do beneficiário
					# Tipo: Numero
					# Tamanho: 014
					def detalhe_posicao_004_017(pagamento, sequencial)
						"#{conta.cpf_cnpj}".adjust_size_to(14, '0', :right)
					end

					# Informações da conta
					# Tipo: Numero
					# Tamanho: 20
					def detalhe_posicao_018_037(pagamento, sequencial)
						informacoes_da_conta(:detalhe)
					end

					# Numero de controle do participante
					# Padrão: " " Brancos
					# Tipo: String
					# Tamanho: 25
					def detalhe_posicao_038_062(pagamento)
						''.adjust_size_to(25)
					end

					# Nosso numero e informações do pagaemnto
					# Tamanho: 14
					def detalhe_posicao_063_076(pagamento, sequencial)
						dados_do_pagamento(pagamento)
					end

					# Diferente para cada banco
					# Tipo: X N
					# Tamanho: 32
					def detalhe_posicao_077_108(pagamento, sequencial)
						raise NotImplementedError.new("Sobreescreva o metodo #detalhe_posicao_077_108 para a class #{self}")
					end

					# Comando/Movimento
					# Tipo: N
					# Padrão: '01' = Registro de títulos
					# Tamanho: 2
					def detalhe_posicao_109_110(pagamento, sequencial)
						code = "#{pagamento.identificacao_ocorrencia}".rjust(2, '0')
						"#{conta.get_codigo_movimento_remessa(code, 400)}".adjust_size_to(2, '0')
					end

					# Seu número
					# Tipo: N
					# Tamanho: 10
					def detalhe_posicao_111_120(pagamento, sequencial)
						"#{pagamento.numero_documento}".adjust_size_to(10, '0', :right)
					end

					# Informações do pagamento
					# Tipo: XN
					# Tamanho: 40
					def detalhe_posicao_121_160(pagamento, sequencial)
						informacoes_do_pagamento(pagamento, sequencial)
					end

					# Informações de multa e juros
					# Tipo: XN
					# Tamanho: 58
					def detalhe_posicao_161_218(pagamento, sequencial)
						detalhe_multas_e_juros_do_pagamento(pagamento, sequencial)
					end

					# Informações do sacado
					# Tipo: XN
					# Tamanho: 176
					def detalhe_posicao_219_394(pagamento, sequencial)
						informacoes_do_sacado(pagamento, sequencial)
					end

					# Sequencial do registro
					# Tipo: N
					# Tamanho: 6
					def detalhe_posicao_395_400(pagamento, sequencial)
						"#{sequencial}".adjust_size_to(6, '0', :right)
					end
				end
			end
		end
	end
end