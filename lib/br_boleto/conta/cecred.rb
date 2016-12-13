# encoding: utf-8
module BrBoleto
	module Conta
		class Cecred < BrBoleto::Conta::Base

			# MODALIDADE CARTEIRA:
			#      _________________________________________________________
			#     | Carteira | Descrição                                   |
			#     |   1      | Com Cadastramento (Cobrança Registrada)      |
			#     ---------------------------------------------------------

			def default_values
				super.merge({
					carteira:                      '1', 			 
					valid_carteira_required:       true,  # <- Validação dinâmica que a modalidade é obrigatória
					valid_carteira_length:         1,     # <- Validação dinâmica que a modalidade deve ter 2 digitos
					valid_carteira_inclusion:      %w[1], # <- Validação dinâmica de valores aceitos para a modalidade
					codigo_carteira:               '1',   # Cobrança Simples
					valid_codigo_carteira_length:   1,    # <- Validação dinâmica que a modalidade deve ter 1 digito
					valid_conta_corrente_required: true,  # <- Validação dinâmica que a conta_corrente é obrigatória
					valid_conta_corrente_maximum:  7,     # <- Validação que a conta_corrente deve ter no máximo 7 digitos
					valid_convenio_required:       true,  # <- Validação que a convenio deve ter obrigatório
					valid_convenio_maximum:        6,     # <- Validação que a convenio deve ter no máximo 7 digitos
				})
			end

			def codigo_banco
				'085'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'1'
			end

			def nome_banco
				@nome_banco ||= 'CECRED'
			end

			def versao_layout_arquivo_cnab_240
				'087'
			end

			def versao_layout_lote_cnab_240
				'045'
			end

			def agencia_dv
				# utilizando a agencia com 4 digitos
				# para calcular o digito
				@agencia_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9.new(agencia).to_s
			end

			def conta_corrente_dv
				@conta_corrente_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9.new(conta_corrente).to_s
			end

			# Campo Agência / Código do Cedente
			# @return [String] Agência com 4 caracteres - digito da agência / Conta de Cobrança com 7 caracteres - Digito da Conta
			# Exemplo: 9999-D / 9999999-D
			def agencia_codigo_cedente
				"#{agencia}-#{agencia_dv} / #{conta_corrente}-#{conta_corrente_dv}"
			end

			# Código de Movimento Retorno 
			def equivalent_codigo_movimento_retorno
				super.merge(
					{
						'76' => '76',  # Liquidação de boleto cooperativa emite e expede
						'77' => '77',  # Liquidação de boleto após baixa ou não registrado cooperativa emite e expede
						'91' => '91',  # Título em aberto não enviado ao pagador
						'92' => '92',  # Inconsistência Negativação Serasa
						'93' => '93',  # Inclusão Negativação via Serasa
						'94' => '94',  # Exclusão Negativação Serasa
					})
			end

			# Código do Motivo da ocorrência :
			def codigos_movimento_retorno_para_ocorrencia_D 
				%w[91 93 94]
			end
			def equivalent_codigo_motivo_ocorrencia_D codigo_movimento_gem
				#  Código     Padrão para  
				{# do Banco     a Gem
					'P1'    =>   'A114',  # Enviado Cooperativa Emite e Expede
					'S1'    =>   'D02',   # Sempre que a solicitação (inclusão ou exclusão) for efetuada com sucesso
					'S2'    =>   'D03',   # Sempre que a solicitação for integrada na Serasa com sucesso
					'S3'    =>   'D04',   # Sempre que vier retorno da Serasa por decurso de prazo
					'S4'    =>   'D05',   # Sempre que o documento for integrado na Serasa com sucesso, quando o UF for de São Paulo
					'S5'    =>   'D06',   # Sempre quando houver ação judicial, restringindo a negativação do boleto.
				}
			end

		end
	end
end
