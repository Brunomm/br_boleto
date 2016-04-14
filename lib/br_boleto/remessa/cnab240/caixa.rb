# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab240
			class Caixa < BrBoleto::Remessa::Cnab240::Base
				
				# modalidade da carteira
				#   opcoes:
				#     11: título Registrado emissão CAIXA
				#     14: título Registrado emissão Cedente
				#     21: título Sem Registro emissão CAIXA
				attr_accessor :modalidade_carteira
				
				# versão do aplicativo da caixa
				attr_accessor :versao_aplicativo

				validates :modalidade_carteira, :agencia, :versao_aplicativo, presence: true
				validates :convenio,            length: {maximum: 6, message: 'deve ter no máximo 6 dígitos.'}
				validates :versao_aplicativo,   length: {maximum: 4, message: 'deve ter no máximo 4 dígitos.'}
				validates :agencia,             length: {maximum: 5, message: 'deve ter no máximo 5 dígitos.'}
				validates :modalidade_carteira, length: {is: 2, message: 'deve ter 2 dígitos.'}

				def default_values
					super.merge({
						emissao_boleto: '2',
						distribuicao_boleto: '2',
						especie_titulo: '02', # 02 = DM Duplicata mercantil
						modalidade_carteira: '14',
						forma_cadastramento: '0',
						versao_aplicativo:   '0'
					})
				end

				def codigo_banco
					'104'
				end

				def nome_banco
					'CAIXA ECONOMICA FEDERAL'.ljust(30, ' ')
				end

				def versao_layout_arquivo
					'050'
				end

				def versao_layout_lote
					'030'
				end

				def versao_aplicativo
					"#{@versao_aplicativo}".rjust(4, '0') if @versao_aplicativo.present?
				end

				def digito_agencia
					# utilizando a agencia com 5 digitos
					# para calcular o digito
					BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(agencia).to_s
				end

				
				# Uso exclusivo caixa
				# CAMPO                TAMANHO
				# ---------------------------------------------------------
				# num. convenio        20 Zeros
				#
				# TOTAL = 20 posições
				#
				def codigo_convenio
					''.rjust(20, '0')
				end

				# Convênio do Lote
				#  DESCRIÇÃO               TAMANHO      POSIÇÃO
				# ---------------------------------------------------------
				# Cód. Cedente (convênio)    06          34-39
				# Uso CAIXA                  14          40-53
				#
				# TOTAL = 20 posições
				#
				def convenio_lote(lote)
					conv_lote = convenio.to_s.rjust(6, '0')
					conv_lote << ''.to_s.rjust(14, '0') #Padrão '0'
					conv_lote
				end

				# Informação da conta
				# DESCRIÇÃO              TAMANHO   POSIÇÃO
				# ---------------------------------------------------------
				# agencia                  05      54 - 58
				# digito Verif. agencia    01      59 - 59
				# código convenio          06      60 - 65
				# código modelo pers.      07      66 - 72
				# uso exclusivo CAIXA      01      73 - 73
				#
				# TOTAL = 20 posições
				#
				def informacoes_da_conta
					informacoes =   agencia.rjust(5, '0')
					informacoes <<  digito_agencia
					informacoes <<  "#{convenio}".rjust(6, '0')
					informacoes <<  ''.rjust(7, '0')
					informacoes <<  '0'
					informacoes
				end

				# Complemento do header do arquivo - Chamado em header_arquivo_posicao_212_a_240
				# DESCRIÇÃO                TAMANHO   POSIÇÃO
				# ---------------------------------------------------------
				# Versão aplicativo CAIXA    04      212 - 215
				# USO FEBRABAN               25      216 - 240
				#
				# TOTAL = 29 posições
				#
				def complemento_header_arquivo
					complemento =  "#{versao_aplicativo}".rjust(4, '0') # 04 digitos já ajustado no método
					complemento << ''.rjust(25, ' ')
					complemento
				end

				# segmento_p_posicao_024_a_057
				# DESCRIÇÃO              TAMANHO     POSIÇÃO
				# ---------------------------------------------------------
				# codigo cedente          06          24 - 29
				# Uso Caixa               11          30 - 40
				# Modalidade carteira     02          41 - 42
				# nosso_numero            15          43 - 57
				#
				# TOTAL = 34 posições 
				#
				def complemento_p(pagamento)
					complemento  = "#{convenio}".rjust(6, '0')
					complemento << ''.rjust(11, '0')
					complemento << modalidade_carteira
					complemento << pagamento.nosso_numero.rjust(15, '0')
					complemento
				end

				# Segmento P para numero do documento
				# DESCRIÇÃO              TAMANHO     POSIÇÃO
				# ---------------------------------------------------------
				# Nr Doc. cobrança          11       63 - 73
				# Uso da CAIXA              04       74 - 77
				#
				# TOTAL = 15 posições 
				#
				def segmento_p_numero_do_documento(pagamento)
					complemento =  pagamento.numero_documento.to_s.rjust(11, '0')
					complemento << ''.rjust(4, ' ')
					complemento
				end

				# Digito verificador da agência
				# Segundo a documentação nessa posição vai o valor '0'
				#
				# TOTAL = 01 posição 
				#
				def segmento_p_posicao_106_a_106
					'0'
				end

				# Identificação do Título na Empresa 
				# Campo destinado para uso da Empresa Cedente para identificação do Título.
				# Informar o Número do Documento - Seu Número (mesmo das posições 63-73 do Segmento P)
				#
				# TOTAL = 25 posições
				#
				def segmento_p_posicao_196_a_220(pagamento)
					pagamento.numero_documento.to_s.rjust(25, '0')
				end
				
				def segmento_s_posicao_019_a_020_tipo_impressao_1_ou_2(pagamento)
					'00'
				end
				def segmento_s_posicao_161_a_162_tipo_impressao_1_ou_2(pagamento)
					'00'
				end

				# trailer_lote_posicao_024_a_240(lote, nr_lote)
				# DESCRIÇÃO              TAMANHO     POSIÇÃO
				# ---------------------------------------------------------
				# Qtd. cobr. Simples        06       24  -  29  _
				# Val. Tot Cobr. Simples    17       30  -  46	 \
				# Qtd. cobr. Caucionada     06       47  -  52    \
				# Val. Tot Cobr. Caucionada 17       53  -  69     >  VALORES UTILIZADOS APENAS PARA ARQUIVO DE RETORNO
				# Qtd. cobr. Descontada     06       70  -  75    /
				# Val. Tot Cobr. Descontada 17       76  -  92  _/
				# Uso FEBRABAN              148      93  - 240 
				#
				# TOTAL = 217 posições 
				#
				def complemento_trailer_lote(lote, nr_lote)
					complemento = ''
					complemento << ''.rjust(69, '0')  # VALORES UTILIZADOS APENAS PARA ARQUIVO DE RETORNO
					complemento << ''.rjust(148, ' ') # USO EXCLUSIVO FEBRABAN
					complemento
				end

			end
		end
	end
end