module BrBoleto
	module HaveConta
		extend ActiveSupport::Concern
		
		included do 
			validate :conta_validations
		end

		def conta
			yield conta if block_given?
			get_conta
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

		def get_conta
			@conta.is_a?(conta_class) ? @conta : @conta = conta_class.new()
			set_regras_tamanho_e_validations!
			@conta
		end

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
		def valid_codigo_cedente_length;   end
		def valid_codigo_cedente_minimum;  end
		def valid_codigo_cedente_maximum;  end
		def valid_codigo_cedente_required; end
		def valid_codigo_cedente_inclusion; end
		def valid_endereco_required;       end
		def valid_carteira_length;         end
		def valid_carteira_minimum;        end
		def valid_carteira_maximum;        end
		def valid_carteira_required;       end
		def valid_convenio_length;         end
		def valid_convenio_minimum;        end
		def valid_convenio_maximum;        end
		def valid_convenio_required;       end
		def valid_modalidade_inclusion;    end
		def valid_carteira_inclusion;      end
		def valid_convenio_inclusion;      end
		def valid_versao_aplicativo_required; end # Banco da Caixa


		def set_regras_tamanho_e_validations!
			@conta ||= conta_class.new()
			@conta.valid_conta_corrente_length   = valid_conta_corrente_length   if "#{valid_conta_corrente_length}".present?
			@conta.valid_conta_corrente_minimum  = valid_conta_corrente_minimum  if "#{valid_conta_corrente_minimum}".present?
			@conta.valid_conta_corrente_maximum  = valid_conta_corrente_maximum  if "#{valid_conta_corrente_maximum}".present?
			@conta.valid_conta_corrente_required = valid_conta_corrente_required if "#{valid_conta_corrente_required}".present?
			
			@conta.valid_modalidade_length       = valid_modalidade_length       if "#{valid_modalidade_length}".present?
			@conta.valid_modalidade_minimum      = valid_modalidade_minimum      if "#{valid_modalidade_minimum}".present?
			@conta.valid_modalidade_maximum      = valid_modalidade_maximum      if "#{valid_modalidade_maximum}".present?
			@conta.valid_modalidade_required     = valid_modalidade_required     if "#{valid_modalidade_required}".present?
			@conta.valid_modalidade_inclusion    = valid_modalidade_inclusion    if "#{valid_modalidade_inclusion}".present?
			
			@conta.valid_endereco_required       = valid_endereco_required       if "#{valid_endereco_required}".present?
			
			@conta.valid_carteira_length         = valid_carteira_length         if "#{valid_carteira_length}".present?
			@conta.valid_carteira_minimum        = valid_carteira_minimum        if "#{valid_carteira_minimum}".present?
			@conta.valid_carteira_maximum        = valid_carteira_maximum        if "#{valid_carteira_maximum}".present?
			@conta.valid_carteira_required       = valid_carteira_required       if "#{valid_carteira_required}".present?
			@conta.valid_carteira_inclusion      = valid_carteira_inclusion      if "#{valid_carteira_inclusion}".present?
			
			# Se tiver alguma validação setada em convênio é o que deve prevalecer
			@conta.valid_codigo_cedente_length   = valid_codigo_cedente_length     if "#{valid_codigo_cedente_length}".present?
			@conta.valid_codigo_cedente_minimum  = valid_codigo_cedente_minimum    if "#{valid_codigo_cedente_minimum}".present?
			@conta.valid_codigo_cedente_maximum  = valid_codigo_cedente_maximum    if "#{valid_codigo_cedente_maximum}".present?
			@conta.valid_codigo_cedente_required = valid_codigo_cedente_required   if "#{valid_codigo_cedente_required}".present?
			@conta.valid_codigo_cedente_inclusion = valid_codigo_cedente_inclusion if "#{valid_codigo_cedente_inclusion}".present?
			
			@conta.valid_convenio_length         = valid_convenio_length         if "#{valid_convenio_length}".present?
			@conta.valid_convenio_minimum        = valid_convenio_minimum        if "#{valid_convenio_minimum}".present?
			@conta.valid_convenio_maximum        = valid_convenio_maximum        if "#{valid_convenio_maximum}".present?
			@conta.valid_convenio_required       = valid_convenio_required       if "#{valid_convenio_required}".present?
			@conta.valid_convenio_inclusion      = valid_convenio_inclusion      if "#{valid_convenio_inclusion}".present?
			
			@conta.valid_versao_aplicativo_required = valid_versao_aplicativo_required if "#{valid_versao_aplicativo_required}".present?

		end

		def conta_validations
			set_regras_tamanho_e_validations!
			if conta.invalid?
				conta.errors.full_messages.each do |msg|
					errors.add(:base, msg)
				end
			end
		end
	end
end