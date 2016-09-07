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
		def valid_conta_corrente_length;   end
		def valid_conta_corrente_minimum;  end
		def valid_conta_corrente_maximum;  end
		def valid_conta_corrente_required; end
		def valid_modalidade_length;       end
		def valid_modalidade_minimum;      end
		def valid_modalidade_maximum;      end
		def valid_modalidade_required;     end
		def codigo_cedente_length;   end
		def codigo_cedente_minimum;  end
		def codigo_cedente_maximum;  end
		def codigo_cedente_required; end
		def endereco_required;       end
		def valid_carteira_length;         end
		def valid_carteira_minimum;        end
		def valid_carteira_maximum;        end
		def valid_carteira_required;       end
		def convenio_length;         end
		def convenio_minimum;        end
		def convenio_maximum;        end
		def convenio_required;       end
		def valid_modalidade_inclusion;    end
		def valid_carteira_inclusion;      end
		def convenio_inclusion;      end
		def valid_versao_aplicativo_required; end # Banco da Caixa

		def conta_validations
			conta.valid_conta_corrente_length   = valid_conta_corrente_length   if "#{valid_conta_corrente_length}".present?
			conta.valid_conta_corrente_minimum  = valid_conta_corrente_minimum  if "#{valid_conta_corrente_minimum}".present?
			conta.valid_conta_corrente_maximum  = valid_conta_corrente_maximum  if "#{valid_conta_corrente_maximum}".present?
			conta.valid_conta_corrente_required = valid_conta_corrente_required if "#{valid_conta_corrente_required}".present?
			
			conta.valid_modalidade_length       = valid_modalidade_length       if "#{valid_modalidade_length}".present?
			conta.valid_modalidade_minimum      = valid_modalidade_minimum      if "#{valid_modalidade_minimum}".present?
			conta.valid_modalidade_maximum      = valid_modalidade_maximum      if "#{valid_modalidade_maximum}".present?
			conta.valid_modalidade_required     = valid_modalidade_required     if "#{valid_modalidade_required}".present?
			conta.valid_modalidade_inclusion    = valid_modalidade_inclusion    if "#{valid_modalidade_inclusion}".present?
			
			conta.endereco_required       = endereco_required       if "#{endereco_required}".present?
			
			conta.valid_carteira_length         = valid_carteira_length         if "#{valid_carteira_length}".present?
			conta.valid_carteira_minimum        = valid_carteira_minimum        if "#{valid_carteira_minimum}".present?
			conta.valid_carteira_maximum        = valid_carteira_maximum        if "#{valid_carteira_maximum}".present?
			conta.valid_carteira_required       = valid_carteira_required       if "#{valid_carteira_required}".present?
			conta.valid_carteira_inclusion      = valid_carteira_inclusion      if "#{valid_carteira_inclusion}".present?
			
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