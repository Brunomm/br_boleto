module BrBoleto
	module HavePagador
		extend ActiveSupport::Concern
		
		included do 
			validate :pagador_validations
		end
		
		def pagador
			yield pagador if block_given?
			@pagador.is_a?(pagador_class) ? @pagador : @pagador = pagador_class.new()
		end

		def pagador=(value)
			if value.is_a?(pagador_class) || value.nil?
				@pagador = value
			elsif value.is_a?(Hash)
				pagador.assign_attributes(value)
			end
		end

	private
		def pagador_class
			BrBoleto::Pagador
		end

		def valid_endereco_required;       end
		def valid_avalista_required;       end
		
		def pagador_validations
			pagador.valid_avalista_required = valid_avalista_required if "#{valid_avalista_required}".present?
			pagador.valid_endereco_required = valid_endereco_required if "#{valid_endereco_required}".present?
			if pagador.invalid?
				pagador.errors.full_messages.each do |msg|
					errors.add(:base, msg)
				end
			end
		end
	end
end