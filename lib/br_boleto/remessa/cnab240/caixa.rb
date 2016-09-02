# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		module Cnab240
			class Caixa < BrBoleto::Remessa::Cnab240::Base
				def conta_class
					BrBoleto::Conta::Caixa
				end
				
				def default_values
					super.merge({
						emissao_boleto: '2',
						distribuicao_boleto: '2'
					})
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
					conv_lote = "#{conta.convenio}".adjust_size_to(6, '0', :right)
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
					informacoes =   "#{conta.agencia}".adjust_size_to(5, '0', :right)
					informacoes <<  conta.agencia_dv
					informacoes <<  "#{conta.convenio}".adjust_size_to(6, '0', :right)
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
					complemento =  "#{conta.versao_aplicativo}".rjust(4, '0') # 04 digitos já ajustado no método
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
					complemento  = "#{conta.convenio}".adjust_size_to(6, '0', :right)
					complemento << ''.rjust(11, '0')
					complemento << conta.modalidade
					complemento << pagamento.nosso_numero.adjust_size_to(15, '0', :right)
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
					complemento =  "#{pagamento.numero_documento}".adjust_size_to(11, '0', :right)
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
					"#{pagamento.numero_documento}".adjust_size_to(25, '0', :right)
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