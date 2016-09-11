# encoding: utf-8
module BrBoleto
	class ActiveModelBase
		# Seguindo a interface do Active Model para:
		# * Validações;
		# * Internacionalização;
		# * Nomes das classes para serem manipuladas;
		#
		include ActiveModel::Model

		def initialize(attributes = {})
			attributes = default_values.deep_merge!(attributes)
			assign_attributes(attributes)
			yield self if block_given?
		end

		def assign_attributes(attributes)
			attributes ||= {}
			attributes.each do |name, value|
				send("#{name}=", value)
			end
		end

		def default_values
			{}
		end
	end
end
