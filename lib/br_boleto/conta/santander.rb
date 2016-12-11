# encoding: utf-8
module BrBoleto
	module Conta
		class Santander < BrBoleto::Conta::Base

			# MODALIDADE CARTEIRA:
			#   ___________________________________________
			#  | Carteira | Descrição                     | 
			#  |   101    | Cobrança Simples com registro | 
			#  |   102    | Cobrança Simples sem registro | 
			#  |   121    | Penhor Rápida com registro    | 
			#  --------------------------------------------

			# Código de Transmissão
			# Consultar seu gerente para pegar esse código. Geralmente está no e-mail enviado pelo banco.
			attr_accessor :codigo_transmissao

			###############################  VALIDAÇÕES DINÂMICAS ###############################
				# Código de Transmissão
				attr_accessor :valid_codigo_transmissao_required

				validates :codigo_transmissao, custom_length: { maximum: 20 }
				# validates :codigo_transmissao, presence: true, if: :valid_codigo_transmissao_required
			#####################################################################################

			def default_values
				super.merge({
					carteira:                      '101', 			 
					valid_carteira_required:       true, # <- Validação dinâmica que a modalidade é obrigatória
					valid_carteira_length:         3,    # <- Validação dinâmica que a modalidade deve ter 3 digitos
					valid_carteira_inclusion:      %w[101 102 121], # <- Validação dinâmica de valores aceitos para a modalidade
					codigo_carteira:               '1',   # Cobrança Simples
					valid_codigo_carteira_length:   1,    # <- Validação dinâmica que a modalidade deve ter 1 digito
					valid_conta_corrente_required: true,  # <- Validação dinâmica que a conta_corrente é obrigatória
					valid_conta_corrente_maximum:  9,     # <- Validação que a conta_corrente deve ter no máximo 9 digitos
					valid_convenio_required:       true,  # <- Validação que a convenio deve ter obrigatório
					valid_convenio_maximum:        7,     # <- Validação que a convenio deve ter no máximo 7 digitos
				})
			end

			def codigo_banco
				'033'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'7'
			end

			def nome_banco
				@nome_banco ||= 'SANTANDER'
			end

			def versao_layout_arquivo_cnab_240
				'040'
			end

			def versao_layout_lote_cnab_240
				'030'
			end

			def agencia_dv
				# utilizando a agencia com 4 digitos
				# para calcular o digito
				@agencia_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(agencia).to_s
			end

			def conta_corrente_dv
				@conta_corrente_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(conta_corrente).to_s
			end

			def codigo_transmissao
				"#{@codigo_transmissao}".rjust(20, '0') if @codigo_transmissao.present?
			end

			# Campo Agência / Código do Cedente
			# @return [String] Agência com 4 caracteres / Convênio com 7 caracteres
			# Exemplo: 9999 / 9999999
			def agencia_codigo_cedente
				"#{agencia} / #{convenio}"
			end

			# Formata a carteira dependendo se ela é registrada ou não.
			# Para cobrança COM registro usar: COBRANCA SIMPLES ECR
			# Para Cobrança SEM registro usar: COBRANCA SIMPLES CSR
			def carteira_formatada
				if @carteira.to_s.in?(carteiras_com_registro)
					"COBRANÇA SIMPLES ECR"
				else
					'COBRANÇA SIMPLES CSR'
				end
			end

			# Retorna as carteiras com registro do banco Santander.
			# Você pode sobrescrever esse método na subclasse caso exista mais
			# carteiras com registro no Santander.
			def carteiras_com_registro
				%w(101 121)
			end

			# Espécie do Título :
			def equivalent_especie_titulo_240
				#  Padrão    Código para    Descrição 
				{# da GEM     o Banco
					'02'	 =>	'02' ,       # DM  - DUPLICATA MERCANTIL
					'04'	 =>	'04' ,       # DS  - DUPLICATA DE SERVICO
					'07'	 =>	'07' ,       # LC  - LETRA DE CÂMBIO
					'12'	 =>	'12' ,       # NP  - NOTA PROMISSORIA
					'13'	 =>	'13' ,       # NR  - NOTA PROMISSORIA RURAL
					'17'	 =>	'17' ,       # RC  - RECIBO
					'20'	 =>	'20' ,       # AP  - APOLICE DE SEGURO
					'01'	 =>	'97' ,       # CH  - CHEQUE
					'98'	 =>	'98' ,       # NPD - NOTA PROMISSORIA DIRETA
				}
			end
			def equivalent_especie_titulo_400
				#  Padrão    Código para    Descrição 
				{# da GEM     o Banco
					'02'	 =>	'01' ,       # DM  - DUPLICATA MERCANTIL
					'04'	 =>	'06' ,       # DS  - DUPLICATA DE SERVICO
					'07'	 =>	'07' ,       # LC  - LETRA DE CÂMBIO
					'12'	 =>	'02' ,       # NP  - NOTA PROMISSORIA
					'17'	 =>	'05' ,       # RC  - RECIBO
					'20'	 =>	'03' ,       # AP  - APOLICE DE SEGURO
				}
			end

			# Código Movimento da Remessa CNAB240
			def equivalent_codigo_movimento_remessa_240
				#  Padrão    Código para    Descrição 
				{# da GEM     o Banco
					'01'	 =>	'01' ,       # Entrada de título
					'02'	 =>	'02' ,       # Pedido de baixa
					'04'	 =>	'04' ,       # Concessão de abatimento
					'05'	 =>	'05' ,       # Cancelamento de abatimento
					'06'	 =>	'06' ,       # Alteração de vencimento
					'07'	 =>	'10' ,       # Concessão de Desconto
					'08'	 =>	'11' ,       # Cancelamento de desconto
					'09'	 =>	'09' ,       # Pedido de Protesto
					'10'	 =>	'18' ,       # Pedido de Sustação de Protesto
					'21'	 =>	'07' ,       # Alteração da identificação do título na empresa
					'22'	 =>	'08' ,       # Alteração seu número
					'31'	 =>	'31' ,       # Alteração de outros dados
					'41'	 =>	'98' ,       # Não Protestar
				}
			end

			# Código Movimento da Remessa CNAB400
			def equivalent_codigo_movimento_remessa_400
				#  Padrão    Código para    Descrição 
				{# da GEM     o Banco
					'01'	 =>	'01' ,       # Entrada de título
					'02'	 =>	'02' ,       # Pedido de baixa
					'04'	 =>	'04' ,       # Concessão de abatimento
					'05'	 =>	'05' ,       # Cancelamento de abatimento
					'06'	 =>	'06' ,       # Alteração de vencimento
					'21'	 =>	'07' ,       # Alteração da identificação do título na empresa
					'22'	 =>	'08' ,       # Alteração seu número
					'09'	 =>	'09' ,       # Pedido de Protesto
					'10'	 =>	'18' ,       # Sustar Protesto e Baixar Título
					'11'	 =>	'18' ,       # Sustar Protesto e Manter em Carteira
				}
			end

			# Código de Multa
			def equivalent_codigo_multa
				#  Padrão    Código para    Descrição 
				{# da GEM     o Banco
					'1'    =>    '4',        # Com Multa
					'2'    =>    '4',        # Com Multa
					'3'    =>    '0',        # Sem Multa (Isento)
				}
			end
			def default_codigo_multa
				'0'
			end

			# Código da Carteira CNAB400
			def equivalent_tipo_cobranca_400
				#  Padrão    Código para    Descrição 
				{# da GEM     o Banco
					'1'    =>    '5',        # RÁPIDA COM REGISTRO
					'2'    =>    '2',        # ELETRÔNICA COM REGISTRO
					'3'    =>    '3',        # CAUCIONADA ELETRÔNICA
					'4'    =>    '7',        # DESCONTADA ELETRÔNICA
					'5'    =>    '4',        # COBRANÇA SEM REGISTRO
					'6'    =>    '6',        # CAUCIONADA RAPIDA
				}
			end

			# Código da Carteira CNAB240
			def equivalent_tipo_cobranca_240
				super.merge({'6' => '6' }) # 6 = Cobrança Caucionada (Rápida com Registro)
			end

			# Código para Protesto
			def equivalent_codigo_protesto
				super.merge({'0' => '0' }) # 0 = Não Protestar
			end

			# Código da Moeda CNAB240
			def equivalent_codigo_moeda_240
				super.merge({'09' => '00' }) # 00 = Real
			end

		end
	end
end
