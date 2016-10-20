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
			# Valores aceitos de 2 a 9, somente será "1" se forem boletos pré-impressos.
			attr_accessor :byte_id

			###############################  VALIDAÇÕES DINÂMICAS ###############################
				attr_accessor :valid_byte_id_length
				attr_accessor :valid_byte_id_required
				attr_accessor :valid_byte_id_inclusion
				attr_accessor :valid_posto_maximum
				attr_accessor :valid_posto_required
			#####################################################################################

			# Byte de identificação
			validates :byte_id, custom_length:    {is: :valid_byte_id_length},     if: :valid_byte_id_length
			validates :byte_id, custom_inclusion: {in: :valid_byte_id_inclusion},  if: :valid_byte_id_inclusion
			validates :byte_id, presence: true,   if:  :valid_byte_id_required

			# Posto
			validates :posto,    custom_length:    {maximum: :valid_posto_maximum},    if: :valid_posto_maximum
			validates :posto,    presence: true,   if: :valid_posto_required


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
					codigo_carteira:               '1',     # Cobrança Simples
					valid_codigo_carteira_length:   1,      # <- Validação dinâmica que a modalidade deve ter 1 digito
					posto:                         '0',     
					valid_posto_maximum:           2,       # <- Validação que a posto deve ter no máximo 2 digitos
					valid_posto_required:          true,    # <- Validação que a posto deve ter obrigatório
					byte_id:                      '2',
					valid_byte_id_length:         1,        # <- Validação dinâmica que o byte identificador deve ter 1 digito
					valid_byte_id_required:       true,     # <- Validação que a byte_id deve ter obrigatório
					valid_byte_id_inclusion:      %w[2 3 4 5 6 7 8 9], # <- Validação dinâmica de valores aceitos para o byte identificador
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

			def byte_id
				"#{@byte_id}".rjust(1, '2') if @byte_id.present?
			end

			def agencia_dv
				@agencia_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9.new(agencia).to_s
			end

			# Campo Agência / Código do Cedente
			# @return [String] Agência com 4 caracteres . Posto do beneficiário com 2 caracteres . Código do beneficiário com 5 caracteres 
			# Exemplo: AAAA.PP.CCCCC
			def agencia_codigo_cedente
				"#{agencia}.#{posto}.#{codigo_cedente}"
			end

			# Espécie do Título CNAB 240 e 400
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
						'32'    =>   'O'   # Boleto de Proposta (BDP)
					})
			end

			# Código da Carteira 
			def equivalent_tipo_cobranca
				super.merge({ '1' => 'A' }) # Cobrança Simples
			end	

			# Identificação do Tipo de Impressão : 
			def equivalent_tipo_impressao
				super.merge({ '1' => 'A' }) # Frente do Bloqueto
			end	

			# Identificação da Emissão do Boleto de Pagamento
			def equivalent_identificacao_emissao
				super.merge(
					#  Padrão    Código para  
					{# da GEM     o Banco
						'1'    =>   'A',  # Impressão é feita pelo Sicredi
						'2'    =>   'B',  # Impressão é feita pelo Beneficiário
					})
			end
		end
	end
end
