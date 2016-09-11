module BrBoleto
	module HavePagamentos
		extend ActiveSupport::Concern

		included do 
			attr_accessor :pagamento_valid_tipo_impressao_required
			attr_accessor :pagamento_valid_cod_desconto_length
			attr_accessor :pagamento_valid_emissao_boleto_length
			attr_accessor :pagamento_valid_distribuicao_boleto_length

			validates :pagamentos, presence: true
			validates_each :pagamentos do |record, attr, value|
				value.each_with_index do |pagamento, i|
					pagamento.valid_tipo_impressao_required    = record.pagamento_valid_tipo_impressao_required    if "#{record.pagamento_valid_tipo_impressao_required}".present?
					pagamento.valid_cod_desconto_length        = record.pagamento_valid_cod_desconto_length        if "#{record.pagamento_valid_cod_desconto_length}".present?
					pagamento.valid_emissao_boleto_length      = record.pagamento_valid_emissao_boleto_length      if "#{record.pagamento_valid_emissao_boleto_length}".present?
					pagamento.valid_distribuicao_boleto_length = record.pagamento_valid_distribuicao_boleto_length if "#{record.pagamento_valid_distribuicao_boleto_length}".present?
					
					if pagamento.invalid?
						pagamento.errors.full_messages.each { |msg| record.errors.add(:pagamentos, "#{pagamento.nosso_numero || i+1}: #{msg}") }
					end
					
				end
			end
			class << self
				def class_for_pagamentos
					BrBoleto::Remessa::Pagamento
				end
			end
			
			def pagamentos=(value)
				@pagamentos = value
			end

			def pagamentos
				@pagamentos = [@pagamentos].flatten.compact.select{|p| p.is_a?(self.class.class_for_pagamentos)}
			end

		end



	end	
end