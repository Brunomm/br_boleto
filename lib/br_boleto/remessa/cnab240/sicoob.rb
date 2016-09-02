# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab240
			class Sicoob < BrBoleto::Remessa::Cnab240::Base
				def conta_class
					BrBoleto::Conta::Sicoob
				end
				
				#       Tipo Formulário - 01 posição  (15 a 15):
				#            "1" -auto-copiativo
				#            "3" -auto-envelopável
				#            "4" -A4 sem envelopamento
				#            "6" -A4 sem envelopamento 3 vias
				attr_accessor :tipo_formulario

				validates :tipo_formulario, presence: true
				
				def default_values
					super.merge({
						emissao_boleto:      '2',
						distribuicao_boleto: '2',
						tipo_formulario:     '4'
					})
				end

				def codigo_convenio
					# CAMPO                TAMANHO
					# num. convenio        20 BRANCOS
					''.rjust(20, ' ')
				end

				def convenio_lote(lote)
					codigo_convenio
				end

				def informacoes_da_conta
					# CAMPO                  TAMANHO
					# agencia                5
					# digito agencia         1
					# conta corrente         12
					# digito conta           1
					# digito agencia/conta   1
					"#{conta.agencia.rjust(5, '0')}#{conta.agencia_dv}#{conta.conta_corrente.rjust(12, '0')}#{conta.conta_corrente_dv}".adjust_size_to(20)
				end

				def complemento_header_arquivo
					''.rjust(29, ' ')
				end

				def complemento_p(pagamento)
					# CAMPO                   TAMANHO
					# conta corrente          12
					# digito conta            1
					# digito agencia/conta    1
					# ident. titulo no banco  20
					"#{conta.conta_corrente.to_s.rjust(12, '0')}#{conta.conta_corrente_dv} #{formata_nosso_numero(pagamento.nosso_numero)}"
				end

				# Tipo de cobrança
				# Ex: :simples, :caucionada
				#
				# Obs: O VALOR DESSE METODO NÃO INFLUÊNCIA NA GERAÇÃO DO BOLETO
				# É APENAS PARA QUESTÃO DE INFORMAÇÃO CASO PRECISE PARA OUTRAS COISAS.
				#
				def tipo_cobranca_formatada
					case "#{conta.modalidade}".rjust(2, "0")
					when '01', '02'
						:simples
					when '03'
						:caucionada
					end
				end

				# Retorna o nosso numero
				#
				# @return [String]
				#
				# Nosso Número:
				#  - Se emissão a cargo do Cedente (vide planilha "Capa" deste arquivo):
				#       NumTitulo - 10 posições (1 a 10)
				#       Parcela - 02 posições (11 a 12) - "01" se parcela única
				#       Modalidade - 02 posições (13 a 14) - vide planilha "Capa" deste arquivo
				#       Tipo Formulário - 01 posição  (15 a 15):
				#            "1" -auto-copiativo
				#            "3" -auto-envelopável
				#            "4" -A4 sem envelopamento
				#            "6" -A4 sem envelopamento 3 vias
				#       Em branco - 05 posições (16 a 20)
				def formata_nosso_numero(nosso_numero)
					"#{nosso_numero.to_s.rjust(10, '0')}#{parcela}#{conta.modalidade}#{tipo_formulario}".adjust_size_to(20)
				end

				def complemento_trailer_lote(lote, nr_lote)
					complemento = ''
					complemento << complemento_trailer_lote_posicao_024_a_029(lote)
					complemento << complemento_trailer_lote_posicao_030_a_046(lote)
					complemento << complemento_trailer_lote_posicao_047_a_052(lote)
					complemento << complemento_trailer_lote_posicao_053_a_069(lote)
					complemento << complemento_trailer_lote_posicao_070_a_075(lote)
					complemento << complemento_trailer_lote_posicao_076_a_092(lote)
					complemento << complemento_trailer_lote_posicao_093_a_098(lote)
					complemento << complemento_trailer_lote_posicao_099_a_115(lote)
					complemento << complemento_trailer_lote_posicao_116_a_123(lote)
					complemento << complemento_trailer_lote_posicao_124_a_240
					complemento.upcase
				end

				# Quantidade de titulos de cobrança simples
				# 6 posições
				#
				def complemento_trailer_lote_posicao_024_a_029(lote)
					tipo_cobranca_formatada == :simples ? lote.pagamentos.count.to_s.rjust(6, '0') : ''.rjust(6, '0')
				end

				# Valor total dos titulos de cobrança simples
				# 17 posições
				#
				def complemento_trailer_lote_posicao_030_a_046(lote)
					if tipo_cobranca_formatada == :simples
						BrBoleto::Helper::Number.new(lote.pagamentos.map(&:valor_documento).sum).formata_valor_monetario(17)
					else
						''.rjust(17, '0')
					end
				end

				# Quantidade de titulos de cobrança Vinculada
				# 6 posições
				#
				def complemento_trailer_lote_posicao_047_a_052(lote)
					''.rjust(6, '0')
				end

				# Valor total dos titulos de cobrança Vinculada
				# 17 posições
				#
				def complemento_trailer_lote_posicao_053_a_069(lote)
					''.rjust(17, '0')
				end


				# Quantidade de titulos de cobrança Caucionada
				# 6 posições
				#
				def complemento_trailer_lote_posicao_070_a_075(lote)
					tipo_cobranca_formatada == :caucionada ? lote.pagamentos.count.to_s.rjust(6, '0') : ''.rjust(6, '0')
				end

				# Valor total dos titulos de cobrança Caucionada
				# 17 posições
				#
				def complemento_trailer_lote_posicao_076_a_092(lote)
					if tipo_cobranca_formatada == :caucionada
						BrBoleto::Helper::Number.new(lote.pagamentos.map(&:valor_documento).sum).formata_valor_monetario(17)
					else
						''.rjust(17, '0')
					end
				end

				# Quantidade de titulos de cobrança Descontada
				# 6 posições
				#
				def complemento_trailer_lote_posicao_093_a_098(lote)
					''.rjust(6, '0')
				end

				# Valor total dos titulos de cobrança Descontada
				# 17 posições
				#
				def complemento_trailer_lote_posicao_099_a_115(lote)
					''.rjust(17, '0')
				end

				# Número do aviso de lançamento
				# 8 posições
				#
				def complemento_trailer_lote_posicao_116_a_123(lote)
					''.rjust(8, ' ')
				end

				# Exclusivo FEBRABAN
				# 117 posições
				#
				def complemento_trailer_lote_posicao_124_a_240
					''.rjust(117, ' ')
				end

				# Codigo da multa 
				# Padrão pela FEBRABAN = (1 = Valor fixo e 2 = Percentual, 3 = isento)
				# Padrão do SICOOB     = (1 = Valor fixo e 2 = Percentual, 0 = isento)
				# 1 posição
				#
				def segmento_r_posicao_066_a_066(pagamento)
					cod = "#{pagamento.codigo_multa}".adjust_size_to(1, '0')
					cod.in?(['1','2']) ? cod : '0'
				end

				# Codigo do Juros
				# Padrão pela FEBRABAN = (1 = Valor fixo e 2 = Percentual, 3 = isento)
				# Padrão do SICOOB     = (1 = Valor fixo e 2 = Percentual, 0 = isento)
				# 1 posição
				#
				def segmento_p_posicao_118_a_118(pagamento)
					cod = "#{pagamento.codigo_juros}".adjust_size_to(1, '0')
					cod.in?(['1','2']) ? cod : '0'
				end

			end
		end
	end
end