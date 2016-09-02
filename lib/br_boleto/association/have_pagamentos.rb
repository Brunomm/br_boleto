module BrBoleto
	module HavePagamentos
		def pagamentos=(value)
			@pagamentos = value
		end

		def pagamentos
			@pagamentos = [@pagamentos].flatten.compact
		end
	end	
end