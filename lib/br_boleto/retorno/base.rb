# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		class Base < BrBoleto::ActiveModelBase
			
			attr_reader    :file
			attr_accessor :pagamentos
			attr_accessor :codigo_banco

			def initialize(file)
				self.pagamentos = []
				@file = file
				read_file! if @file.present?
			end

			validates :file, presence: true

			# O atributo pagamentos sempre irá retornar um Array 
			def pagamentos
				@pagamentos = [@pagamentos].flatten
			end

			def file
				@file
			end
		
		private

			def read_file!
				raise NotImplementedError.new('Sobreescreva este método na classe referente ao CNAB 240 ou 400')
			end
		end
	end
end