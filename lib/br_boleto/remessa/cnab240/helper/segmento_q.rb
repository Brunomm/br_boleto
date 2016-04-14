module BrBoleto
	module Remessa
		module Cnab240
			module Helper
				module SegmentoQ
					# Monta o registro segmento Q do arquivo
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
					def monta_segmento_q(pagamento, nr_lote, sequencial)
						#                                                      # DESCRICAO                         TAMANHO
						segmento_q = ''                                        
						segmento_q << segmento_q_posicao_001_a_003             # codigo banco                         3
						segmento_q << segmento_q_posicao_004_a_007(nr_lote)    # lote de servico                      4
						segmento_q << segmento_q_posicao_008_a_008             # tipo de registro                     1
						segmento_q << segmento_q_posicao_009_a_013(sequencial) # num. sequencial do registro no lote  5
						segmento_q << segmento_q_posicao_014_a_014             # cod. segmento                        1
						segmento_q << segmento_q_posicao_015_a_015             # uso exclusivo                        1
						segmento_q << segmento_q_posicao_016_a_017             # cod. movimento remessa               2
						segmento_q << segmento_q_posicao_018_a_018(pagamento)  # tipo insc. sacado                    1
						segmento_q << segmento_q_posicao_019_a_033(pagamento)  # documento sacado                     14
						segmento_q << segmento_q_posicao_034_a_073(pagamento)  # nome cliente                         40
						segmento_q << segmento_q_posicao_074_a_113(pagamento)  # endereco cliente                     40
						segmento_q << segmento_q_posicao_114_a_128(pagamento)  # bairro                               15
						segmento_q << segmento_q_posicao_129_a_133(pagamento)  # cep                                  5
						segmento_q << segmento_q_posicao_134_a_136(pagamento)  # sufixo cep                           3
						segmento_q << segmento_q_posicao_137_a_151(pagamento)  # cidade                               15
						segmento_q << segmento_q_posicao_152_a_153(pagamento)  # uf                                   2
						segmento_q << segmento_q_posicao_154_a_154(pagamento)  # identificacao do sacador             1
						segmento_q << segmento_q_posicao_155_a_169(pagamento)  # documento sacador                    15
						segmento_q << segmento_q_posicao_170_a_209(pagamento)  # nome avalista                         40
						segmento_q << segmento_q_posicao_210_a_212             # cod. banco correspondente            3
						segmento_q << segmento_q_posicao_213_a_232             # nosso numero banco correspondente    20
						segmento_q << segmento_q_posicao_233_a_240             # uso exclusivo                        8
						segmento_q.upcase
					end

					# Código do banco
					# 3 posições
					#
					def segmento_q_posicao_001_a_003 
						codigo_banco
					end

					# Lote de Serviço: Número seqüencial para identificar univocamente um lote de serviço. 
					# Criado e controlado pelo responsável pela geração magnética dos dados contidos no arquivo.
					# Preencher com '0001' para o primeiro lote do arquivo. 
					# Para os demais: número do lote anterior acrescido de 1. O número não poderá ser repetido dentro do arquivo.
					# 4 posições
					#
					def segmento_q_posicao_004_a_007(numero_do_lote)
						numero_do_lote.to_s.rjust(4, '0')
					end

					# Tipo do registro -> Padrão 3
					# 1 posição
					#
					def segmento_q_posicao_008_a_008
						'3'
					end

					# Nº Sequencial do Registro no Lote
					# 5 posições
					#
					def segmento_q_posicao_009_a_013(sequencial)
						sequencial.to_s.rjust(5, '0')
					end

					# Cód. Segmento do Registro Detalhe
					# 1 posição
					#
					def segmento_q_posicao_014_a_014
						'Q'
					end

					# Uso Exclusivo FEBRABAN/CNAB 
					# 1 posição
					#
					def segmento_q_posicao_015_a_015
						' '
					end

					# Código de Movimento Remessa 
					# 2 posições
					#
					def segmento_q_posicao_016_a_017
						'01'
					end

					# Tipo de Inscrição (1=CPF 2=CNPJ)
					# 1 posição
					#
					def segmento_q_posicao_018_a_018(pagamento)
						pagamento.tipo_documento_sacado(1)
					end

					# Número de Inscrição
					# 15 posições
					#
					def segmento_q_posicao_019_a_033(pagamento)
						BrBoleto::Helper::CpfCnpj.new(pagamento.documento_sacado).sem_formatacao.rjust(15, '0')
					end

					# Nome do sacado
					# 40 posições
					#
					def segmento_q_posicao_034_a_073(pagamento)
						pagamento.nome_sacado.adjust_size_to(40)
					end

					# Endereço sacado
					# 40 posições
					#
					def segmento_q_posicao_074_a_113(pagamento)
						pagamento.endereco_sacado.adjust_size_to(40)
					end

					# Bairro do sacado
					# 15 posições
					#
					def segmento_q_posicao_114_a_128(pagamento)
						pagamento.bairro_sacado.adjust_size_to(15)
					end

					# CEP (prefixo)
					# 5 posições
					#
					def segmento_q_posicao_129_a_133(pagamento)
						pagamento.cep_sacado[0..4]
					end

					# CEP sufixo
					# 3 posições
					#
					def segmento_q_posicao_134_a_136(pagamento)
						pagamento.cep_sacado[5..7]
					end

					# Cidade
					# 15 posições
					#
					def segmento_q_posicao_137_a_151(pagamento)
						pagamento.cidade_sacado.adjust_size_to(15)
					end

					# Unidade da Federação
					# 2 posuções
					#
					def segmento_q_posicao_152_a_153(pagamento)
						pagamento.uf_sacado
					end

					# Tipo de Inscrição
					# 1 posição
					#
					def segmento_q_posicao_154_a_154(pagamento)
						pagamento.tipo_documento_avalista(1)
					end

					# Número de Inscrição
					# 15 posições
					#
					def segmento_q_posicao_155_a_169(pagamento)
						BrBoleto::Helper::CpfCnpj.new("#{pagamento.documento_avalista}").sem_formatacao.rjust(15, '0')
					end

					# Nome do avalista
					# 40 posições
					#
					def segmento_q_posicao_170_a_209(pagamento)
						"#{pagamento.nome_avalista}".adjust_size_to(40)
					end

					# Cód. Bco. Corresp. na Compensação
					# 3 posições
					#
					def segmento_q_posicao_210_a_212
						''.rjust(3, '0') 
					end

					# Nosso Nº no Banco Correspondente
					# 20 posições
					#
					def segmento_q_posicao_213_a_232
						''.rjust(20, ' ')
					end

					# Uso Exclusivo FEBRABAN/CNAB
					# 8 posições
					#
					def segmento_q_posicao_233_a_240
						''.rjust(8, ' ') 
					end

				end
			end
		end
	end
end