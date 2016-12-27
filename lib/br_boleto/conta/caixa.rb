# encoding: utf-8
module BrBoleto
	module Conta
		class Caixa < BrBoleto::Conta::Base
			
			# MODALIDADE CARTEIRA
			#  Opcoes:
			#    14: Cobrança Simples com registro
			#    24: Cobrança Simples sem registro
			#
			#  Carteira/Modalidade:
			#    1/4 = Registrada   / Emissão do boleto(4-Beneficiário) 
			#    2/4 = Sem Registro / Emissão do boleto(4-Beneficiário) 

			# versão do aplicativo da caixa
			attr_accessor :versao_aplicativo

			###############################  VALIDAÇÕES DINÂMICAS ###############################
				# Versão do aplicativo
				attr_accessor :valid_versao_aplicativo_required
			#####################################################################################

			validates :versao_aplicativo, custom_length: { maximum: 4 }
			validates :versao_aplicativo, presence: true, if: :valid_versao_aplicativo_required

			def default_values
				super.merge({
					carteira:                     '14',      # Com registro
					valid_carteira_required:      true,      # <- Validação dinâmica que a carteira é obrigatória
					valid_carteira_length:        2,         # <- Validação dinâmica que a carteira deve ter 2 digitos
					valid_carteira_inclusion:     %w[14 24], # <- Validação dinâmica de valores aceitos para a modalidade
					codigo_carteira:              '1',  # Cobrança Simples
					valid_codigo_carteira_length: 1,         # <- Validação dinâmica que a carteira deve ter 1 digito
					valid_convenio_required:      true, # <- Validação que a convenio deve ter obrigatório
					valid_convenio_maximum:       6,    # <- Validação que a convenio deve ter no máximo 6 digitos
					versao_aplicativo:            '0',
				})
			end

			def codigo_banco
				'104'
			end

			# Dígito do código do banco descrito na documentação
			def codigo_banco_dv
				'0'
			end

			def nome_banco
				@nome_banco ||= 'CAIXA ECONOMICA FEDERAL'
			end

			def versao_layout_arquivo_cnab_240
				'050'
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

			def convenio_dv
				@convenio_dv ||= BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(convenio).to_s
			end

			def versao_aplicativo
				"#{@versao_aplicativo}".rjust(4, '0') if @versao_aplicativo.present?
			end

			# Formata a carteira da carteira dependendo se ela é registrada ou não.
			#
			# Para cobrança COM registro usar: <b>RG</b>
			# Para Cobrança SEM registro usar: <b>SR</b>
			#
			# @return [String]
			#
			def carteira_formatada
				if carteira.in?(carteiras_com_registro)
					'RG'
				else
					'SR'
				end
			end

			# Retorna as carteiras com registro da Caixa Econômica Federal.
			# <b>Você pode sobrescrever esse método na subclasse caso exista mais
			# carteiras com registro na Caixa Econômica Federal.</b>
			#
			# @return [Array]
			#
			def carteiras_com_registro
				%w(14)
			end

			# Campo Agência / Código do Cedente
			#
			# @return [String]
			#
			def agencia_codigo_cedente
				"#{agencia} / #{codigo_cedente}-#{codigo_cedente_dv}"
			end

			# Identificação da Distribuição exclusiva da CAIXA
			def equivalent_distribuicao_boleto
				super.merge({'0' => '0' }) # 0 = Postagem pelo Beneficiário
			end

			# Código de Movimento Retorno 
			def equivalent_codigo_movimento_retorno_240
				super.merge(
					#  Padrão    Código para  
					{# do Banco    a GEM
						'35'   =>   '135',     # Confirmação de Inclusão Banco de Sacado
						'36'   =>   '136',     # Confirmação de Alteração Banco de Sacado
						'37'   =>   '137',     # Confirmação de Exclusão Banco de Sacado
						'38'   =>   '138',     # Emissão de Bloquetos de Banco de Sacado
						'39'   =>   '139',     # Manutenção de Sacado Rejeitada
						'40'   =>   '140',     # Entrada de Título via Banco de Sacado Rejeitada
						'41'   =>   '141',     # Manutenção de Banco de Sacado Rejeitada
						'44'   =>   '144',     # Estorno de Baixa / Liquidação
						'45'   =>   '145',     # Alteração de Dados
					})
			end

			# Código do Motivo da Ocorrência Retorno
			def equivalent_codigo_motivo_ocorrencia_A_240 codigo_movimento_gem
				super.merge(
				#  Padrão    Código para  
				{# do Banco    a GEM
					'11'   =>   'A115', # Data de Geração Inválida 
					'64'   =>   'A116', # Entrada Inválida para Cobrança Caucionada
					'65'   =>   'A117', # CEP do Pagador não encontrado
					'66'   =>   'A118', # Agencia Cobradora não encontrada
					'67'   =>   'A119', # Agencia Beneficiário não encontrada
					'68'   =>   'A120', # Movimentação inválida para título
					'69'   =>   'A121', # Alteração de dados inválida
					'70'   =>   'A122', # Apelido do cliente não cadastrado
					'71'   =>   'A123', # Erro na composição do arquivo
					'73'   =>   'A105', # Código do Beneficiário inválido
					'72'   =>   'A124', # Lote de serviço inválido
					'74'   =>   'A125', # Beneficiário não pertencente a Cobrança Eletrônica
					'75'   =>   'A126', # Nome da Empresa inválido
					'76'   =>   'A127', # Nome do Banco inválido
					'77'   =>   'A128', # Código da Remessa inválido
					'78'   =>   'A129', # Data/Hora Geração do arquivo inválida
					'79'   =>   'A130', # Número Sequencial do arquivo inválido
					'80'   =>   'A131', # Versão do Lay out do arquivo inválido
					'81'   =>   'A132', # Literal REMESSA-TESTE - Válido só p/ fase testes
					'82'   =>   'A133', # Literal REMESSA-TESTE - Obrigatório p/ fase testes
					'83'   =>   'A134', # Tp Número Inscrição Empresa inválido
					'84'   =>   'A135', # Tipo de Operação inválido
					'85'   =>   'A136', # Tipo de serviço inválido
					'86'   =>   'A137', # Forma de lançamento inválido
					'87'   =>   'A138', # Número da remessa inválido
					'88'   =>   'A139', # Número da remessa menor/igual remessa anterior
					'89'   =>   'A140', # Lote de serviço divergente
					'90'   =>   'A141', # Número sequencial do registro inválido
					'91'   =>   'A142', # Erro seq de segmento do registro detalhe
					'92'   =>   'A143', # Cod movto divergente entre grupo de segm
					'93'   =>   'A144', # Qtde registros no lote inválido
					'94'   =>   'A145', # Qtde registros no lote divergente
					'95'   =>   'A146', # Qtde lotes no arquivo inválido
					'96'   =>   'A147', # Qtde lotes no arquivo divergente
					'97'   =>   'A148', # Qtde registros no arquivo inválido
					'98'   =>   'A149', # Qtde registros no arquivo divergente
					'99'   =>   'A150', # Código de DDD inválido
				})
			end
			def equivalent_codigo_motivo_ocorrencia_B_240 codigo_movimento_gem
				super.merge(
				#  Padrão    Código para  
				{# do Banco    a GEM
					'12'	 =>   'B21', # Redisponibilização de Arquivo Retorno Eletrônico
					'15'	 =>   'B22', # Banco de Pagadores
					'17'	 =>   'B23', # Entrega Aviso Disp Boleto via e-amail ao pagador (s/ emissão Boleto)
					'18'	 =>   'B24', # Emissão de Boleto Pré-impresso CAIXA matricial
					'19'	 =>   'B25', # Emissão de Boleto Pré-impresso CAIXA A4
					'20'	 =>   'B26', # Emissão de Boleto Padrão CAIXA
					'21'	 =>   'B27', # Emissão de Boleto/Carnê
					'31'	 =>   'B28', # Emissão de Aviso de Vencido
					'42'	 =>   'B29', # Alteração cadastral de dados do título - sem emissão de aviso
					'45'	 =>   'B30', # Emissão de 2a via de Boleto Cobrança Registrada
				})
			end
			def codigos_movimento_retorno_para_ocorrencia_C_240
				%w[06 08 09 17]
			end
			def equivalent_codigo_motivo_ocorrencia_C_240 codigo_movimento_gem
				if codigo_movimento_gem == '08'
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
						'01'     =>    'C35',  # Liquidação em Dinheiro
						'02'     =>    'C36',  # Liquidação em Cheque
					})
				else
					super.merge(
						#  Padrão    Código para  
						{# do Banco    a GEM
						'02'     =>    'C100', # Casa Lotérica
						'03'     =>    'C101', # Agências CAIXA
						'07'     =>    'C102', # Correspondente Bancário
					})
				end
			end

			def equivalent_codigo_motivo_ocorrencia_A_400 codigo_movimento_gem
				super.merge(
					#  Padrão    Código para  
					{# do Banco    a GEM
						'01'   =>   'A220',  # Movimento sem Beneficiário Correspondente
						'02'   =>   'A221',  # Movimento sem Título Correspondente
						'08'   =>   'A222',  # Movimento para título já com movimentação no dia
						'09'   =>   'A223',  # Nosso Número não pertence ao Beneficiário
						'10'   =>   'A224',  # Inclusão de título já existente na base
						'12'   =>   'A225',  # Movimento duplicado
						'13'   =>   'A116',  # Entrada Inválida para Cobrança Caucionada (Beneficiário não possui conta Caução)
						'20'   =>   'A117',  # CEP do Pagador não encontrado (não foi possível a determinação da Agência Cobradora para o título)
						'21'   =>   'A118',  # Agência cobradora não encontrada (agência designada para cobradora não cadastrada no sistema)
						'22'   =>   'A119',  # Agência Beneficiário não encontrada (Agência do Beneficiário não cadastrada no sistema)
						'45'   =>   'A226',  # Data de Vencimento com prazo superior ao limite
						'49'   =>   'A227',  # Movimento inválido para título Baixado/Liquidado
						'50'   =>   'A228',  # Movimento inválido para título enviado a Cartório
						'54'   =>   'A229',  # Faixa de CEP da Agência Cobradora não abrange CEP do Pagador
						'55'   =>   'A230',  # Título já com opção de Devolução
						'56'   =>   'A231',  # Processo de Protesto em andamento
						'57'   =>   'A232',  # Título já com opção de Protesto
						'58'   =>   'A233',  # Processo de devolução em andamento
						'59'   =>   'A234',  # Novo prazo p/ Protesto/Devolução inválido
						'76'   =>   'A235',  # Alteração do prazo de protesto inválida
						'77'   =>   'A236',  # Alteração do prazo de devolução inválida
						'81'   =>   'A237',  # CEP do Pagador inválido
						'82'   =>   'A238',  # CNPJ/CPF do Pagador inválido (dígito não confere)
						'83'   =>   'A86' ,  # Número do Documento (seu número) inválido
						'84'   =>   'A239',  # Protesto inválido para título sem Número do documento (seu número)
				})
			end

			def codigos_movimento_retorno_para_ocorrencia_C_400
				%w[06 09 101 151 152]
			end
			def equivalent_codigo_motivo_ocorrencia_C_400 codigo_movimento_gem
				super.merge(
					#  Padrão    Código para  
					{# do Banco    a GEM
						'002'  =>  'C100', # Unidade Lotérica
						'003'  =>  'C101', # Agências CAIXA
						'004'  =>  'C04',  # Compensação Eletrônica
						'006'  =>  'C06',  # Internet Banking
						'007'  =>  'C102', # Correspondente CAIXA aqui
						'008'  =>  'C08',  # Em Cartório
						'009'  =>  'C09',  # Comandada Banco
						'010'  =>  'C10',  # Comandada Cliente via Arquivo
						'011'  =>  'C11',  # Comandada Cliente On-line
				})
			end

			# Identificações de Ocorrência / Código de ocorrência:
			def equivalent_codigo_movimento_retorno_400
				super.merge(
					#  Padrão    Código para  
					{# do Banco    a GEM
						'01'   =>   '02',	  # Entrada Confirmada
						'02'   =>   '09',	  # Baixa Manual Confirmada
						'03'   =>   '12',	  # Abatimento Concedido
						'04'   =>   '13',	  # Abatimento Cancelado
						'05'   =>   '14',	  # Vencimento Alterado
						'06'   =>   '146',  # Uso da Empresa Alterado
						'08'   =>   '147',  # Prazo de Devolução Alterado
						'09'   =>   '27',	  # Alteração Confirmada
						'10'   =>   '148',  # Alteração com reemissão de Boleto Confirmada
						'11'   =>   '149',  # Alteração da opção de Protesto para Devolução Confirmada
						'12'   =>   '150',  # Alteração da opção de Devolução para Protesto Confirmada
						'20'   =>   '11',	  # Em Ser
						'21'   =>   '06',	  # Liquidação 
						'22'   =>   '101',  # Liquidação em Cartório 
						'23'   =>   '151',  # Baixa por Devolução 
						'25'   =>   '152',  # Baixa por Protesto 
						'26'   =>   '23',   # Título enviado para Cartório 
						'27'   =>   '20',	  # Sustação de Protesto 
						'28'   =>   '153',  # Estorno de Protesto 
						'29'   =>   '154',  # Estorno de Sustação de Protesto 
						'30'   =>   '61',	  # Alteração de Título 
						'31'   =>   '108',  # Tarifa sobre Título Vencido 
						'32'   =>   '155',  # Outras Tarifas de Alteração 
						'33'   =>   '144',  # Estorno de Baixa / Liquidação 
						'34'   =>   '156',  # Tarifas Diversas 
					})
			end
		end
	end
end
