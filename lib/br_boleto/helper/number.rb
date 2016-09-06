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

			# Formata o valor percentual.
			# Exemplos:
			#   1 - 
			#    @numero = 2.5 (%)
			#    formata_valor_percentual(6)
			#    Resultado:  025000
			#   2 - 
			#    @numero = 12.34 (%)
			#    formata_valor_percentual(4)
			#    Resultado:  1234
			#
			def formata_valor_percentual(size=6)
				return ''.rjust(size, '0') if @numero.blank?
				if @numero >= 10
					sprintf("%.#{size-2}f", @numero).delete('.').adjust_size_to(size, '0')
				else
					sprintf("0%.#{size-2}f", @numero).delete('.').adjust_size_to(size, '0')
				end
			end

			# Retorna o percentual que o @numero representa do total
			# Exemplo:
			#   @numero = 407.5
			#   get_percent_by_total(4750.68, precision=2)
			#   Resultado =>  8.58 %
			# Ou seja, R$ 407.5 Representa uma fatia de 8.58% de R$ 4750.68
			def get_percent_by_total(total, precision=6)
				(@numero.to_f*100.0/total.to_f).round(precision.to_i)
			end

		end
	end
end