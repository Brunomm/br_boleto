# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab240
			class Sicoob < BrBoleto::Remessa::Cnab240::Base
				def conta_class
					BrBoleto::Conta::Sicoob
				end

				# Tipo Formulário - 01 posição  (15 a 15):
				#      "1" -auto-copiativo
				#      "3" -auto-envelopável
				#      "4" -A4 sem envelopamento
				#      "6" -A4 sem envelopamento 3 vias
				attr_accessor :tipo_formulario

				#################### VALIDAÇÕES DA CONTA #####################
					def valid_modalidade_required;     true end # <= Modalidade é obrigatória
					def valid_codigo_cedente_required; true end # <= Código do cedente/beneficiário/convenio deve ser obrigatorio
					def valid_conta_corrente_required; true end # <= Conta corrente obrigatória
					def valid_conta_corrente_maximum;  12   end # <= Máximo de digitos da conta corrente
					def valid_modalidade_length;       2    end # <= Modalidade deve ter 2 digitos
				##############################################################

				validates :tipo_formulario, presence: true

				def default_values
					super.merge({
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
					result =  "#{conta.agencia}".adjust_size_to(5, '0', :right)
					result << "#{conta.agencia_dv}"
					result << "#{conta.conta_corrente}".adjust_size_to(12, '0', :right)
					result << "#{conta.conta_corrente_dv}"
					result << '0'
					result.adjust_size_to(20)
				end

				# Espaço reservado para o Banco
				# 20 posições
				# Brancos
				#
				def header_arquivo_posicao_172_a_191
					''.rjust(20, ' ')
				end

				# Espaço reservado para a Empresa
				# 20 posições
				# Brancos
				#
				def header_arquivo_posicao_192_a_211
					''.rjust(20, ' ')
				end

				# Posição 212 a 240 do Header do Arquivo
				# Para o sicoob esse espaço deve ter 'Brancos'
				# 29 posições
				#
				def complemento_header_arquivo
					''.rjust(29, ' ')
				end

				def complemento_p(pagamento)
					# CAMPO                   TAMANHO
					# conta corrente          12
					# digito conta            1
					# digito agencia/conta    1 # Branco
					# ident. titulo no banco  20
					result =  "#{conta.conta_corrente}".adjust_size_to(12, '0', :right)
					result << "#{conta.conta_corrente_dv}".adjust_size_to(1)
					result << " "
					result << "#{formata_nosso_numero(pagamento)}"
					result
				end

				# Forma de Cadastr. do Título no Banco
				#  Preencher com "0"
				#  1 posição
				#
				def segmento_p_posicao_059_a_059(pagamento)
					'0'
				end

				# Tipo de Documento
				# 1 posição
				# Branco
				#
				def segmento_p_posicao_060_a_060
					' '
				end

				# Número de Dias para Baixa/Devolução
				# Para sicoob deve ser espaçoes em branco.
				# 3 posoções
				#
				def segmento_p_posicao_225_a_227
					''.rjust(3, ' ')
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
				def formata_nosso_numero(pagamento)
					result = "#{pagamento.nosso_numero}".adjust_size_to(10, '0', :right)
					result << "#{pagamento.parcela}".adjust_size_to(2, '0', :right)
					result << "#{conta.modalidade}".adjust_size_to(2, '0', :right)
					result << "#{tipo_formulario}".adjust_size_to(1, '1')
					result.adjust_size_to(20)
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

				# Forma de Lançamento
				# 2 posições
				# Brancos
				#
				def header_lote_posicao_012_a_013
					'  '
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
			end
		end
	end
end
