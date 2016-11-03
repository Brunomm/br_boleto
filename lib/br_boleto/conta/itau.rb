# encoding: utf-8
module BrBoleto
	module Conta
		class Itau < BrBoleto::Conta::Base

			# MODALIDADE CARTEIRA:
			#      __________________________________________________________________
			#     | Carteira |  Descrição                                            |
			#		|	107     |  Sem registro com emissão integral – 15 posições     | 
			#		|	109     |  Direta eletrônica sem emissão – simples             | 
			#		|	112     |  --------------------------------------------------- | 
			#		|	121     |  --------------------------------------------------- | 
			#		|	122     |  --------------------------------------------------- | 
			#		|	126     |  --------------------------------------------------- | 
			#		|	131     |  --------------------------------------------------- | 
			#		|	142     |  --------------------------------------------------- | 
			#		|	143     |  --------------------------------------------------- | 
			#		|	146     |  --------------------------------------------------- | 
			#		|	150     |  --------------------------------------------------- | 
			#		|	168     |  --------------------------------------------------- |
			#		|	169     |  --------------------------------------------------- |
			#		|	174     | Sem registro emissão parcial com protesto borderô    | 
			#		|	175     | Sem registro sem emissão com protesto eletrônico     | 
			#		|	196     | Sem registro com emissão e entrega – 15 posições     | 
			#		|	198     | Sem registro sem emissão 15 dígitos                  |
			#     ------------------------------------------------------------------


			def default_values
				super.merge({
					carteira:                      '109', 			 
					valid_carteira_required:       true, # <- Validação dinâmica que a modalidade é obrigatória
					valid_carteira_length:         3,    # <- Validação dinâmica que a modalidade deve ter 2 digitos
					valid_carteira_inclusion:      carteiras_suportadas, # <- Validação dinâmica de valores aceitos para a modalidade
					codigo_carteira:               '1',   # Cobrança Simples
					valid_codigo_carteira_length:   1,    # <- Validação dinâmica que a modalidade deve ter 1 digito
					valid_conta_corrente_required: true,  # <- Validação dinâmica que a conta_corrente é obrigatória
					valid_conta_corrente_maximum:  5,     # <- Validação que a conta_corrente deve ter no máximo 7 digitos
					valid_convenio_required:       true,  # <- Validação que a convenio deve ter obrigatório
					valid_convenio_maximum:        5,     # <- Validação que a convenio deve ter no máximo 7 digitos
				})
			end

			def codigo_banco
				'341'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'7'
			end

			def nome_banco
				@nome_banco ||= 'ITAU'
			end

			def versao_layout_arquivo_cnab_240
				'040'
			end

			def versao_layout_lote_cnab_240
				'030'
			end

			def agencia_dv
				@agencia_dv ||= ''
			end

			# Dígito da conta corrente calculado apartir do Modulo10.
			def conta_corrente_dv
				@conta_corrente_dv ||= BrBoleto::Calculos::Modulo10.new("#{agencia}#{conta_corrente}").to_s
			end

			# Campo Agência / Código do Cedente
			# @return [String] Agência com 4 caracteres  / Conta de Cobrança com 5 caracteres - Digito da Conta
			# Exemplo: 9999 / 99999-D
			def agencia_codigo_cedente
				"#{agencia} / #{conta_corrente}-#{conta_corrente_dv}"
			end

      	# Carteiras suportadas
			def carteiras_suportadas
				%w[107 109 112 121 122 126 131 142 143 146 150 169 175 176 178 196 198]
			end

			# As carteiras de cobrança 107, 122, 142, 143, 196 e 198 são carteiras especiais,
			# na qual são utilizadas 15 posições numéricas para identificação do título
			# liquidado (8 do Nosso Número e 7 do Seu Número).
			def carteiras_especiais
				%w(107 122 142 143 196 198)
			end

			# Carteiras que devem ser calculadas o módulo 10 usando carteira e número do documento.
			def carteiras_com_calculo_mod_10
				%w(126 131 145 146 150 168)
			end

		end
	end
end
