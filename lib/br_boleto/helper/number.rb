module BrBoleto
	module Helper
		class Number
			def initialize(numero)
				@numero = numero
			end

			def formata_valor_monetario(size=13)
				return ''.rjust(size, '0') if @numero.blank?
				sprintf('%.2f', @numero).delete('.').rjust(size, '0')
			end

			def formata_valor_percentual(size=6)
				return ''.rjust(size, '0') if @numero.blank?
				if @numero >= 10
					sprintf("%.#{size-2}f", @numero).delete('.').rjust(size, '0')
				else
					sprintf("0%.#{size-2}f", @numero).delete('.').rjust(size, '0')
				end
			end

		end
	end
end