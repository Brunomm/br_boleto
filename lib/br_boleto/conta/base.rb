# encoding: utf-8
module BrBoleto
	module Conta
		class Base < BrBoleto::ActiveModelBase
			include BrBoleto::Calculos
			include BrBoleto::Helper::DefaultCodes

			#                ATRIBUTOS
			# razao_social
			# cpf_cnpj
			# convenio OU codigo_cedente    OU codigo_beneficiario
			# convenio OU codigo_cedente_dv OU codigo_beneficiario_dv
			# endereco
			# carteira
			# agencia
			# agencia_dv
			# conta_corrente
			# conta_corrente_dv
			# nome_banco
			# modalidade

			# Nome/Razão social que aparece no campo 'Cedente' no boleto.
			attr_accessor :razao_social

			# Documento do Cedente (CPF ou CNPJ).
			attr_accessor :cpf_cnpj

			# Uma carteira de cobrança define o modo como o boleto é tratado pelo banco.
			# Existem duas grandes divisões: carteiras não registradas e carteiras registradas.
			#
			# === Carteiras Não Registradas
			#
			# Significa que não há registro no banco sobre os boletos gerados, ou seja, você não precisa
			# notificar o banco a cada boleto gerado.
			# Neste caso a cobrança de taxa bancária é feita por boleto pago.
			#
			# === Carteiras Registradas
			#
			# Você precisa notificar o banco sobre todos os boletos gerados, em geral enviando um
			# arquivo chamado "arquivo de remessa".
			# Neste caso, normalmente existe uma taxa bancária por boleto gerado, independentemente de ele ser pago.
			# Nestas carteiras também se encaixam serviços bancários adicionais, como protesto em caso de não pagamento.
			#
			# <b>Campo Obrigatório</b>
			#
			attr_accessor :carteira

			# Modalidade da carteira
			# Alguns bancos utilizam campos separados para definir a modalidade e a carteira
			# porém normalmente é utilizado a nomenclatura "MODALIDADE DA CARTEIRA". Quando utilizado essa
			# nomenclatura apenas, e não separa a carteira da modalidade, então deve se usar apenas a carteira
			# 
			attr_accessor :modalidade


			# <b>Código do Convênio é o código do cliente, fornecido pelo banco.</b>
			#
			# Alguns bancos, dependendo do banco e da carteira, precisam desse campo preenchido.
			# A nomenclatura para essa informação varia em cada banco, pode ser também:
			# codigo_beneficiario OU codigo_cedente OU contrato
			# Por isso foi criado um alias para que cada um utilize a nomenclatura que preferir.
			attr_accessor :convenio
			attr_accessor :convenio_dv
			alias_attribute :codigo_cedente,         :convenio
			alias_attribute :codigo_cedente_dv,      :convenio_dv
			alias_attribute :codigo_beneficiario,    :convenio
			alias_attribute :codigo_beneficiario_dv, :convenio_dv


			# Deve ser informado o endereço completo do Cedente.
			#
			# <b>Campo Obrigatório</b>
			attr_accessor :endereco			

			# Número da agência. Campo auto explicativo.
			#
			attr_accessor :agencia
			# Digito verificador da agência
			attr_accessor :agencia_dv
			
			# Número da Conta corrente. Campo auto explicativo.
			attr_accessor :conta_corrente
			attr_accessor :conta_corrente_dv
			

			# Pode ser customizado o nome da conta.
			# Se não passar nenhum valor irá pegar um nome padrão
			# definido em cada banco
			attr_accessor :nome_banco

			###############################  VALIDAÇÕES DINÂMICAS ###############################
			# => Modalidade
				attr_accessor :valid_modalidade_length
				attr_accessor :valid_modalidade_minimum
				attr_accessor :valid_modalidade_maximum
				attr_accessor :valid_modalidade_required
				attr_accessor :valid_modalidade_inclusion
				validates :modalidade, custom_length: {is:      :valid_modalidade_length},  if: :valid_modalidade_length
				validates :modalidade, custom_length: {minimum: :valid_modalidade_minimum}, if: :valid_modalidade_minimum
				validates :modalidade, custom_length: {maximum: :valid_modalidade_maximum}, if: :valid_modalidade_maximum
				validates :modalidade, presence: true, if: :valid_modalidade_required
				validates :modalidade, custom_inclusion: {in: :valid_modalidade_inclusion}, if: :valid_modalidade_inclusion

			# => CARTEIRA
				attr_accessor :valid_carteira_length
				attr_accessor :valid_carteira_minimum
				attr_accessor :valid_carteira_maximum
				attr_accessor :valid_carteira_required
				attr_accessor :valid_carteira_inclusion
				validates :carteira, custom_length: {is:      :valid_carteira_length},  if: :valid_carteira_length
				validates :carteira, custom_length: {minimum: :valid_carteira_minimum}, if: :valid_carteira_minimum
				validates :carteira, custom_length: {maximum: :valid_carteira_maximum}, if: :valid_carteira_maximum
				validates :carteira, presence: true, if: :valid_carteira_required
				validates :carteira, custom_inclusion: {in: :valid_carteira_inclusion}, if: :valid_carteira_inclusion
			
			# => CONTA CORRENTE
				attr_accessor :conta_corrente_length
				attr_accessor :conta_corrente_minimum
				attr_accessor :conta_corrente_maximum
				attr_accessor :conta_corrente_required
				validates :conta_corrente, custom_length: {is:      :conta_corrente_length},  if: :conta_corrente_length
				validates :conta_corrente, custom_length: {minimum: :conta_corrente_minimum}, if: :conta_corrente_minimum
				validates :conta_corrente, custom_length: {maximum: :conta_corrente_maximum}, if: :conta_corrente_maximum
				validates :conta_corrente, presence: true, if: :conta_corrente_required

			
			# => CONVÊNIO / CODIGO CEDENTE / CONTRATO / CODIGO BENEFICIÁRIO
				attr_accessor :convenio_length
				attr_accessor :convenio_minimum
				attr_accessor :convenio_maximum
				attr_accessor :convenio_required
				attr_accessor :convenio_inclusion
				alias_attribute :codigo_beneficiario_length,    :convenio_length
				alias_attribute :codigo_beneficiario_minimum,   :convenio_minimum
				alias_attribute :codigo_beneficiario_maximum,   :convenio_maximum
				alias_attribute :codigo_beneficiario_required,  :convenio_required
				alias_attribute :codigo_beneficiario_inclusion, :convenio_inclusion
				alias_attribute :codigo_cedente_length,         :convenio_length
				alias_attribute :codigo_cedente_minimum,        :convenio_minimum
				alias_attribute :codigo_cedente_maximum,        :convenio_maximum
				alias_attribute :codigo_cedente_required,       :convenio_required
				alias_attribute :codigo_cedente_inclusion,      :convenio_inclusion

				validates :convenio, custom_length: {is:      :convenio_length},  if: :convenio_length
				validates :convenio, custom_length: {minimum: :convenio_minimum}, if: :convenio_minimum
				validates :convenio, custom_length: {maximum: :convenio_maximum}, if: :convenio_maximum
				validates :convenio, presence: true, if: :convenio_required
				validates :convenio, custom_inclusion: {in: :convenio_inclusion}, if: :convenio_inclusion
			
			# => ENDEREÇO
				attr_accessor :endereco_required
				validates :endereco, presence: true, if: :endereco_required
			#####################################################################################

			validates :agencia, :razao_social, :cpf_cnpj, presence: true
			validates :agencia_dv, custom_length: {is: 1}

			# Força valores para retornar como string
			def carteira
				@carteira.try(:to_s)
			end			
			def agencia
				@agencia.try(:to_s)
			end			
			def codigo_cedente
				@convenio.try(:to_s)
			end

			# Código do Banco.
			# <b>Esse campo é específico para cada banco</b>.
			#
			# @return [String] Corresponde ao código do banco.
			def codigo_banco
				raise NotImplementedError.new("Not implemented #codigo_banco in #{self}.")
			end

			# Nome do banco.
			def nome_banco
				@nome_banco || raise(NotImplementedError.new("Not implemented #nome_banco in #{self}."))
			end

			# Dígito do código do banco.
			# <b>Esse campo é específico para cada banco</b>.
			#
			# @return [String] Corresponde ao dígito do código do banco.
			# @raise [NotImplementedError] Precisa implementar nas subclasses.
			#
			def codigo_banco_dv
				raise NotImplementedError.new("Not implemented #codigo_banco_dv in #{self}.")
			end

			# Formata o código do banco com o dígito do código do banco.
			# Método usado para o campo de código do banco localizado no cabeçalho do boleto.
			#
			# @return [String]
			def codigo_banco_formatado
				"#{codigo_banco}-#{codigo_banco_dv}"
			end

			# Agência, código do cedente ou nosso número.
			# <b>Esse campo é específico para cada banco</b>.
			#
			# @return [String] - Corresponde aos campos "Agencia / Codigo do Cedente".
			def agencia_codigo_cedente
				"#{agencia} / #{codigo_cedente}"
			end
			
			# Embora o padrão seja mostrar o número da carteira no boleto,
			# <b>alguns bancos</b> requerem que seja mostrado um valor diferente na carteira.
			# <b>Para essas exceções, sobrescreva esse método na subclasse.</b>
			#
			# @return [String] retorna o número da carteira
			def carteira_formatada
				carteira
			end

			# Utiliado para sempre retornar apenas os numero dos CPF/CNPJ
			# EX:
			#   self.cpf_cnpj = 074.756.887-98
			#   puts self. cpf_cnpj
			#      ~> '07475688798'
			def cpf_cnpj
				return "" unless @cpf_cnpj.present?
				BrBoleto::Helper::CpfCnpj.new(@cpf_cnpj).sem_formatacao
			end

			# Utiliado para sempre retornar numero do CPF/CNPJ com a formatação correta
			# EX:
			#   self.cpf_cnpj = 07475688798
			#   puts self.cpf_cnpj_formatado
			#      ~> '074.756.887-98'
			def cpf_cnpj_formatado
				BrBoleto::Helper::CpfCnpj.new(cpf_cnpj).com_formatacao
			end

			# Retorna o cpf ou cnpj com a formatação de pontos com label
			# EX:
			#  'CNPJ: 12.345.678/0001-88'
			#  'CPF:  074.345.456-83'
			def cpf_cnpj_formatado_com_label
				BrBoleto::Helper::CpfCnpj.new(cpf_cnpj).formatado_com_label
			end

			def tipo_cpf_cnpj(tamanho = 2)
				BrBoleto::Helper::CpfCnpj.new(cpf_cnpj).tipo_documento(tamanho)
			end

			# Versões de layout para CNAB 240
			def versao_layout_arquivo_cnab_240
				raise NotImplementedError.new("Not implemented #versao_layout_arquivo_cnab_240 in #{self}.")
			end
			def versao_layout_lote_cnab_240
				raise NotImplementedError.new("Not implemented #versao_layout_lote_cnab_240 in #{self}.")
			end
		end
	end
end
