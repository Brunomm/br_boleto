# encoding: utf-8
module BrBoleto
	module Conta
		class Sicredi < BrBoleto::Conta::Base
			
			# MODALIDADE CARTEIRA:
			#      _______________________________________________
			#     | Carteira | Descrição                         |
			#     |   1     | Cobrança Simples Com registro      |
			#     |   3     | Cobrança SimplesSem registro       |
			#     ------------------------------------------------

			# Código do posto da cooperativa de crédito
     		attr_accessor :posto

			# Byte de identificação do cedente do bloqueto utilizado para compor o nosso número.
			attr_accessor :byte_idt

			###############################  VALIDAÇÕES DINÂMICAS ###############################
				attr_accessor :valid_posto_required
			#####################################################################################

			validates_length_of :posto, maximum: 2, message: 'deve ser menor ou igual a 2 dígitos.'
			validates_length_of :byte_idt, is: 1,   message: 'deve ser 1 se o numero foi gerado pela agencia ou 2-9 se foi gerado pelo beneficiário'
			validates :posto,    presence: true, if: :valid_posto_required


			def default_values
				super.merge({
					carteira:                      '1', 			 
					valid_carteira_required:       true,    # <- Validação dinâmica que a modalidade é obrigatória
					valid_carteira_length:         1,       # <- Validação dinâmica que a modalidade deve ter 1 digito
					valid_carteira_inclusion:      %w[1 3], # <- Validação dinâmica de valores aceitos para a modalidade
					valid_conta_corrente_required: true,    # <- Validação dinâmica que a conta_corrente é obrigatória
					valid_conta_corrente_maximum:  5,       # <- Validação que a conta_corrente deve ter no máximo 5 digitos
					valid_convenio_required:       true,    # <- Validação que a convenio deve ter obrigatório
					valid_convenio_maximum:        5,       # <- Validação que a convenio deve ter no máximo 5 digitos
				})
			end

			def codigo_banco
				'748'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'X'
			end

			def nome_banco
				@nome_banco ||= 'SICREDI'
			end

			def versao_layout_arquivo_cnab_240
				'081'
			end

			def versao_layout_lote_cnab_240
				'040'
			end

			def posto
				"#{@posto}".rjust(2, '0') if @posto.present?
			end

			# Campo Agência / Código do Cedente
			# @return [String] Agência com 4 caracteres . Posto do beneficiário com 2 caracteres . Código do beneficiário com 5 caracteres 
			# Exemplo: AAAA.PP.CCCCC
			def agencia_codigo_cedente
				"#{agencia}.#{posto}.#{codigo_cedente}"
			end


			# Espécie do Título
			def equivalent_especie_titulo_240
				super.merge(
					#  Padrão    Código para  
					{# da GEM     o Banco
						'03'    =>   'A',  # Duplicata Mercantil por Indicação (DMI)
						'06'    =>   'B',  # Duplicata Rural (DR)
						'12'    =>   'C',  # Nota Promissória (NP)
						'13'    =>   'D',  # Nota Promissória Rural (NR)
						'16'    =>   'E',  # Nota de Seguros (NS)
						'17'    =>   'G',  # Recibo (RC)
						'07'    =>   'H',  # Letra de Câmbio (LC)
						'19'    =>   'I',  # Nota de Débito (ND)
						'05'    =>   'J',  # Duplicata de Serviço por Indicação (DSI)
						'99'    =>   'K',  # Outros (OS)
					})
			end


		end
	end
end
