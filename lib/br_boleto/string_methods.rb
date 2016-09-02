# -*- encoding: utf-8 -*-
module BrBoleto
	module StringMethods
		 # Formata o tamanho da string
		# para o tamanho passado
		# se a string for menor, adiciona espacos a direita
		# se a string for maior, trunca para o num. de caracteres
		#
		def adjust_size_to(size, adjust=" ", orientation=:left)
			if self.size > size
				truncate(size, omission: '')
			elsif orientation == :left
				ljust(size, adjust)
			else
				rjust(size, adjust)				
			end
		end

		def only_numbers
			self.gsub(/[^\d]/, '')
		end
	end
end

[String].each do |klass|
	klass.class_eval { include BrBoleto::StringMethods }
end
