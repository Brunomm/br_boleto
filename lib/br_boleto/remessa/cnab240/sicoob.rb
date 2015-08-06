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
						especie_titulo: '02',
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

			#################### CUSTOMIZAÇÃO PARA O BANCO SICOOB ##########################
			# Na homologação do arquivo de remessa, o consultor que me atendeu falou que no arquivo de remessa
			# Não pode haver mais que 1 lote, ou seja, deve ter 1 HEADER_ARQUIVO, 1 HEADER_LOTE, N SEGMENTO_P
			# N SEGMENTO_Q, N SEGMENTO_R, N SEGMENTO_R, 1 TRAILER_LOTE E 1 TRAILER_ARQUIVO.
			# não quer dizer que cada pagamento será um lote diferente (COMO SERIA O PADRÃO), 
			# é tudo um lote só mas com vários registros de detalhe.
			# Estrutura:
			#       HEADER_ARQUIVO
			#       	HEADER_LOTE
			#       		SEGMENTO_P
			#       		SEGMENTO_Q
			#       		SEGMENTO_R
			#       		SEGMENTO_S
			#       		SEGMENTO_P
			#       		SEGMENTO_Q
			#       		SEGMENTO_R
			#       		SEGMENTO_S
			#       	TRAILER_LOTE
			#       TRAILER_ARQUIVO


				def monta_lote(pagamento, nro_lote)
					return if pagamento.invalid?
				
					# Metodo 'monta_segmento_p' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::SegmentoP
					lote = [monta_segmento_p(pagamento, 1, 1)]
					
					# Metodo 'monta_segmento_q' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::SegmentoQ
					lote << monta_segmento_q(pagamento, 1, 2)

					# Metodo 'monta_segmento_r' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::SegmentoR
					lote << monta_segmento_r(pagamento, 1, 3)

					# Metodo 'monta_segmento_s' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::SegmentoS
					lote << monta_segmento_s(pagamento, 1, 4)
					

					lote
				end

				
				def dados_do_arquivo
					return if self.invalid?

					# contador dos registros do lote
					contador = 1

					# Metodo 'monta_header_arquivo' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::HeaderArquivo
					arquivo = [monta_header_arquivo] 
					contador += 1
					
					# Metodo 'monta_header_lote' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::HeaderLote
					arquivo << monta_header_lote(1)
					contador += 1

					pagamentos.each_with_index do |pagamento, index|
						novo_lote = monta_lote(pagamento, (index + 1))
						arquivo.push novo_lote
						novo_lote.each { |_lote| contador += 1 }
					end

					# Metodo 'monta_trailer_lote' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::TrailerLote
					arquivo << monta_trailer_lote(1, contador)
					contador +=1 

					# Metodo 'monta_trailer_arquivo' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::TrailerArquivo
					arquivo << monta_trailer_arquivo(pagamentos.count, contador)

					retorno = arquivo.join("\n")
					ActiveSupport::Inflector.transliterate(retorno).upcase
				end
			end
		end
	end
end