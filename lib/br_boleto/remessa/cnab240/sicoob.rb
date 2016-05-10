# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab240
			class Sicoob < BrBoleto::Remessa::Cnab240::Base
				
				#O banco siccob utiliza a combinação da carteira e modalidade para
				# saber se é um pagamento com registro, sem registrou ou caucionada.
				# Carteira / Modalidade  =  Tipo de pagamento
 				#    1     /    01       = Simples com Registro
				#    1     /    02       = Simples sem Registro
				#    3     /    03       = Garantia caicionada
				# 
				attr_accessor :modalidade_carteira
				

				attr_accessor :tipo_formulario
				#       Tipo Formulário - 01 posição  (15 a 15):
				#            "1" -auto-copiativo
				#            "3" -auto-envelopável
				#            "4" -A4 sem envelopamento
				#            "6" -A4 sem envelopamento 3 vias

				attr_accessor :parcela
				#       Parcela - 02 posições (11 a 12) - "01" se parcela única

				def convenio_obrigatorio?
					false
				end

				validates :modalidade_carteira, :tipo_formulario, :conta_corrente, :parcela, presence: true
				# Remessa 400 - 8 digitos
				# Remessa 240 - 12 digitos
				validates :conta_corrente,      length: {maximum: 12, message: 'deve ter no máximo 12 dígitos.'}
				validates :agencia,             length: {is: 4, message: 'deve ter 4 dígitos.'}
				validates :modalidade_carteira, length: {is: 2, message: 'deve ter 2 dígitos.'}

				def default_values
					super.merge({
						emissao_boleto: '2',
						distribuicao_boleto: '2',
						especie_titulo: '02', # 02 = DM Duplicata mercantil
						tipo_formulario: '4',
						parcela: '01',
						modalidade_carteira: '01',
						forma_cadastramento: '0'
					})
				end

				def convenio
					"#{@convenio}".adjust_size_to(20)
				end

				def codigo_banco
					'756'
				end

				def nome_banco
					'SICOOB'.ljust(30, ' ')
				end

				def versao_layout_arquivo
					'081'
				end

				def versao_layout_lote
					'040'
				end

				def digito_agencia
					# utilizando a agencia com 4 digitos
					# para calcular o digito
					BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(agencia).to_s
				end

				def digito_conta
					# utilizando a conta corrente com 5 digitos
					# para calcular o digito
					BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(conta_corrente).to_s
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
					"#{agencia.rjust(5, '0')}#{digito_agencia}#{conta_corrente.rjust(12, '0')}#{digito_conta}".adjust_size_to(20)
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
					"#{conta_corrente.to_s.rjust(12, '0')}#{digito_conta} #{formata_nosso_numero(pagamento.nosso_numero)}"
				end

				# Tipo de cobrança
				# Ex: :simples, :caucionada
				#
				# Obs: O VALOR DESSE METODO NÃO INFLUÊNCIA NA GERAÇÃO DO BOLETO
				# É APENAS PARA QUESTÃO DE INFORMAÇÃO CASO PRECISE PARA OUTRAS COISAS.
				#
				def tipo_cobranca_formatada
					case "#{modalidade_carteira}".rjust(2, "0")
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
					"#{nosso_numero.to_s.rjust(10, '0')}#{parcela}#{modalidade_carteira}#{tipo_formulario}".adjust_size_to(20)
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

			end
		end
	end
end