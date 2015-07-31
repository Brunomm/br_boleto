# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab240
			class Sicoob < BrBoleto::Remessa::Cnab240::Base
				attr_accessor :modalidade_carteira
				# identificacao da emissao do boleto (attr na classe base)
				#   opcoes:
				#     ‘1’ = Banco Emite
				#     ‘2’ = Cliente Emite
				#
				# identificacao da distribuicao do boleto (attr na classe base)
				#   opcoes:
				#     ‘1’ = Banco distribui
				#     ‘2’ = Cliente distribui

				attr_accessor :tipo_formulario
				#       Tipo Formulário - 01 posição  (15 a 15):
				#            "1" -auto-copiativo
				#            "3" -auto-envelopável
				#            "4" -A4 sem envelopamento
				#            "6" -A4 sem envelopamento 3 vias

				attr_accessor :parcela
				#       Parcela - 02 posições (11 a 12) - "01" se parcela única

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
						especie_titulo: '02',
						tipo_formulario: '4',
						parcela: '01',
						modalidade_carteira: '01',
						forma_cadastramento: '0'
					})
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
					BrBoleto::Calculos::Modulo11FatorDe2a7.new(agencia).to_s
				end

				def digito_conta
					# utilizando a conta corrente com 5 digitos
					# para calcular o digito
					BrBoleto::Calculos::Modulo11FatorDe2a7.new(conta_corrente).to_s
				end

				def codigo_convenio
					# CAMPO                TAMANHO
					# num. convenio        20 BRANCOS
					''.rjust(20, ' ')
				end

				alias_method :convenio_lote, :codigo_convenio

				def informacoes_da_conta
					# CAMPO                  TAMANHO
					# agencia                5
					# digito agencia         1
					# conta corrente         12
					# digito conta           1
					# digito agencia/conta   1
					"#{agencia.rjust(5, '0')}#{digito_agencia}#{conta_corrente.rjust(12, '0')}#{digito_conta}".adjust_size_to(20)
				end

				def complemento_header
					''.rjust(29, ' ')
				end

				def complemento_trailer
					''.rjust(217, ' ')
				end

				def complemento_p(pagamento)
					# CAMPO                   TAMANHO
					# conta corrente          12
					# digito conta            1
					# digito agencia/conta    1
					# ident. titulo no banco  20
					"#{conta_corrente.to_s.rjust(12, '0')}#{digito_conta} #{formata_nosso_numero(pagamento.nosso_numero)}"
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
			end
		end
	end
end