module BrBoleto
	module HaveConta
		extend ActiveSupport::Concern
		
		included do 
			validate :conta_validations
		end

		def conta
			yield conta if block_given?
			@conta.is_a?(conta_class) ? @conta : @conta = conta_class.new()
		end

		def conta=(value)
			if value.is_a?(conta_class) || value.nil?
				@conta = value
			elsif value.is_a?(Hash)
				conta.assign_attributes(value)
			end
		end

		def conta_class
			raise NotImplementedError.new("Not implemented #conta_class in #{self}.")
		end		

	private
		#######################  VALIDAÇÔES DA CONTA #######################
		# Devem ser sobrescrita a cada classe que utilizar, pois pode variar
		def conta_corrente_length;   end
		def conta_corrente_minimum;  end
		def conta_corrente_maximum;  end
		def conta_corrente_required; end
		def modalidade_length;       end
		def modalidade_minimum;      end
		def modalidade_maximum;      end
		def modalidade_required;     end
		def codigo_cedente_length;   end
		def codigo_cedente_minimum;  end
		def codigo_cedente_maximum;  end
		def codigo_cedente_required; end
		def endereco_required;       end
		def carteira_length;         end
		def carteira_minimum;        end
		def carteira_maximum;        end
		def carteira_required;       end
		def convenio_length;         end
		def convenio_minimum;        end
		def convenio_maximum;        end
		def convenio_required;       end
		def modalidade_inclusion;    end
		def carteira_inclusion;      end
		def convenio_inclusion;      end
		def valid_versao_aplicativo_required; end # Banco da Caixa

		def conta_validations
			conta.conta_corrente_length   = conta_corrente_length   if "#{conta_corrente_length}".present?
			conta.conta_corrente_minimum  = conta_corrente_minimum  if "#{conta_corrente_minimum}".present?
			conta.conta_corrente_maximum  = conta_corrente_maximum  if "#{conta_corrente_maximum}".present?
			conta.conta_corrente_required = conta_corrente_required if "#{conta_corrente_required}".present?
			
			conta.modalidade_length       = modalidade_length       if "#{modalidade_length}".present?
			conta.modalidade_minimum      = modalidade_minimum      if "#{modalidade_minimum}".present?
			conta.modalidade_maximum      = modalidade_maximum      if "#{modalidade_maximum}".present?
			conta.modalidade_required     = modalidade_required     if "#{modalidade_required}".present?
			conta.modalidade_inclusion    = modalidade_inclusion    if "#{modalidade_inclusion}".present?
			
			conta.endereco_required       = endereco_required       if "#{endereco_required}".present?
			
			conta.carteira_length         = carteira_length         if "#{carteira_length}".present?
			conta.carteira_minimum        = carteira_minimum        if "#{carteira_minimum}".present?
			conta.carteira_maximum        = carteira_maximum        if "#{carteira_maximum}".present?
			conta.carteira_required       = carteira_required       if "#{carteira_required}".present?
			conta.carteira_inclusion      = carteira_inclusion      if "#{carteira_inclusion}".present?
			
			# Se tiver alguma validação setada em convênio é o que deve prevalecer
			conta.codigo_cedente_length   = codigo_cedente_length   if "#{codigo_cedente_length}".present?
			conta.codigo_cedente_minimum  = codigo_cedente_minimum  if "#{codigo_cedente_minimum}".present?
			conta.codigo_cedente_maximum  = codigo_cedente_maximum  if "#{codigo_cedente_maximum}".present?
			conta.codigo_cedente_required = codigo_cedente_required if "#{codigo_cedente_required}".present?
			
			conta.convenio_length         = convenio_length         if "#{convenio_length}".present?
			conta.convenio_minimum        = convenio_minimum        if "#{convenio_minimum}".present?
			conta.convenio_maximum        = convenio_maximum        if "#{convenio_maximum}".present?
			conta.convenio_required       = convenio_required       if "#{convenio_required}".present?
			conta.convenio_inclusion      = convenio_inclusion      if "#{convenio_inclusion}".present?
			
			conta.valid_versao_aplicativo_required = valid_versao_aplicativo_required if "#{valid_versao_aplicativo_required}".present?
			
			if conta.invalid?
				conta.errors.full_messages.each do |msg|
					errors.add(:base, msg)
				end
			end
		end
	end
end