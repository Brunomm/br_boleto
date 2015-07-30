module BrBoleto
	module StringMethods
		 # Formata o tamanho da string
		# para o tamanho passado
		# se a string for menor, adiciona espacos a direita
		# se a string for maior, trunca para o num. de caracteres
		#
		def adjust_size_to(size)
			if self.size > size
				truncate(size, omission: '')
			else
				ljust(size, ' ')
			end
		end
	end
end

[String].each do |klass|
	klass.class_eval { include BrBoleto::StringMethods }
end
