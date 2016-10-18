# encoding: utf-8
module BrBoleto
	class Pagador < BrBoleto::ActiveModelBase
		attr_accessor :nome
		attr_accessor :cpf_cnpj
		attr_accessor :endereco
		attr_accessor :bairro
		attr_accessor :cep
		attr_accessor :cidade
		attr_accessor :uf

		attr_accessor :nome_avalista
		attr_accessor :documento_avalista
		attr_accessor :endereco_avalista

		###################### CUSTOM VALIDATIONS #################
		attr_accessor :valid_endereco_required
		validates :endereco, :bairro, :cep, :cidade, :uf, presence: true, if: :valid_endereco_required

		attr_accessor :valid_avalista_required
		validates :nome_avalista, :documento_avalista, presence: true, if: :valid_avalista_required
		###########################################################

		validates :nome, :cpf_cnpj, presence: true

		def endereco_formatado
			addr = []
			addr << endereco unless endereco.blank?
			addr << bairro   unless bairro.blank?
			addr << @cep     unless cep.blank?
			addr << "#{cidade}-#{uf}" unless cidade.blank?
			addr.join(' - ')
		end

		def cep
			"#{@cep}".only_numbers
		end

		def cpf_cnpj
			BrBoleto::Helper::CpfCnpj.new(@cpf_cnpj).sem_formatacao
		end
		
		def tipo_cpf_cnpj(tamanho = 2)
			BrBoleto::Helper::CpfCnpj.new(cpf_cnpj).tipo_documento(tamanho)
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

		def tipo_documento_avalista(tamanho = 2)
			BrBoleto::Helper::CpfCnpj.new(documento_avalista).tipo_documento(tamanho)
		end
		def documento_avalista
			BrBoleto::Helper::CpfCnpj.new(@documento_avalista).sem_formatacao
		end
		# Utiliado para sempre retornar numero do CPF/CNPJ com a formatação correta
		# EX:
		#   self.documento_avalista = 07475688798
		#   puts self.documento_avalista_formatado
		#      ~> '074.756.887-98'
		def documento_avalista_formatado
			BrBoleto::Helper::CpfCnpj.new(documento_avalista).com_formatacao
		end

		# Retorna o cpf ou cnpj com a formatação de pontos com label
		# EX:
		#  'CNPJ: 12.345.678/0001-88'
		#  'CPF:  074.345.456-83'
		def documento_avalista_formatado_com_label
			BrBoleto::Helper::CpfCnpj.new(documento_avalista).formatado_com_label
		end
	end
end