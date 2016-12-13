# encoding: utf-8
module BrBoleto
	module Conta
		class Bradesco < BrBoleto::Conta::Base

			# MODALIDADE CARTEIRA:
			#      _______________________________________________
			#     | Carteira | Descrição                         |
			#     |   06     | Sem registro                      |
			#     |   09     | Com registro                      |
			#     |   19     | Com registro                      |
			#     |   21     | Cobrança Interna Com Registro     |
			#     |   22     | Cobrança Interna Sem Registro     |
			#     ------------------------------------------------


			def default_values
				super.merge({
					carteira:                      '06', 			 
					valid_carteira_required:       true, # <- Validação dinâmica que a modalidade é obrigatória
					valid_carteira_length:         2,    # <- Validação dinâmica que a modalidade deve ter 2 digitos
					valid_carteira_inclusion:      %w[06 09 19 21 22], # <- Validação dinâmica de valores aceitos para a modalidade
					codigo_carteira:               '1',   # Cobrança Simples
					valid_codigo_carteira_length:   1,    # <- Validação dinâmica que a modalidade deve ter 1 digito
					valid_conta_corrente_required: true,  # <- Validação dinâmica que a conta_corrente é obrigatória
					valid_conta_corrente_maximum:  7,     # <- Validação que a conta_corrente deve ter no máximo 7 digitos
					valid_convenio_required:       true,  # <- Validação que a convenio deve ter obrigatório
					valid_convenio_maximum:        7,     # <- Validação que a convenio deve ter no máximo 7 digitos
				})
			end

			def codigo_banco
				'237'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'2'
			end

			def nome_banco
				@nome_banco ||= 'BRADESCO'
			end

			def versao_layout_arquivo_cnab_240
				'084'
			end

			def versao_layout_lote_cnab_240
				'042'
			end

			def agencia_dv
				# utilizando a agencia com 4 digitos
				# para calcular o digito
				@agencia_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(agencia).to_s
			end

			def conta_corrente_dv
				@conta_corrente_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a7.new(conta_corrente).to_s
			end

			# Campo Agência / Código do Cedente
			# @return [String] Agência com 4 caracteres - digito da agência / Conta de Cobrança com 7 caracteres - Digito da Conta
			# Exemplo: 9999-D / 9999999-D
			def agencia_codigo_cedente
				"#{agencia}-#{agencia_dv} / #{conta_corrente}-#{conta_corrente_dv}"
			end

			# Número da Carteira de Cobrança, que a empresa opera no Banco.
			# 21 – Cobrança Interna Com Registro
			# 22 – Cobrança Interna sem registro
			# Para as demais carteiras, retornar o número da carteira.
			def carteira_formatada
				if cobranca_interna_formatada.present?
					cobranca_interna_formatada
				else
					carteira
				end
			end

			# Retorna a mensagem que devera aparecer no campo carteira para cobranca interna.
			# @return [String]
			def cobranca_interna_formatada
				cobranca_interna = { '21' => '21 – Cobrança Interna Com Registro', '22' => '22 – Cobrança Interna sem registro' }
				cobranca_interna[carteira.to_s]
			end

			# Espécie do Título
			def equivalent_especie_titulo_400
				super.merge(
					#  Padrão    Código para  
					{# da GEM     o Banco
						'07'    =>   '10' , # Letra de Câmbio
						'17'    =>   '05' , # Recibo
						'19'    =>   '11' , # Nota de Débito
						'32'    =>   '30' , # Boleto de Proposta
					})
			end

			# Códigos de Movimento Remessa / Identificacao Ocorrência específicos do Banco
			def equivalent_codigo_movimento_remessa_400
				super.merge(
					#  Padrão    Código para  
					{# da GEM     o Banco
						'10'   =>   '18' , # Sustar protesto e baixar Título
						'11'   =>   '19' , # Sustar protesto e manter em carteira
						'31'   =>   '22' , # Transferência Cessão Crédito
						'33'   =>   '68' , # Acerto nos dados do rateio de Crédito
						'43'   =>   '23' , # Transferência entre Carteiras
						'45'   =>   '45' , # Pedido de Negativação
						'46'   =>   '46' , # Excluir Negativação com baixa
						'47'   =>   '47' , # Excluir negativação e manter pendente
						'34'   =>   '69' , # Cancelamento do rateio de crédito.
					})
			end

			# Código de Movimento Retorno 
			def equivalent_codigo_movimento_retorno
				super.merge({'73' => '73'}) # Confirmação recebimento pedido de negativação
			end
		end
	end
end
