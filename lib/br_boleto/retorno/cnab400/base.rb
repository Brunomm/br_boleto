# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		module Cnab400
			class Base < BrBoleto::Retorno::Base
			# Esta classe foi desenvolvida baseando-se no manual disponibilizado pelo Sicoob
			# É necessário sobrescrever o método `detalhe_fields` para cada banco, pois o CNAB 400
			# Não apresenta um padrão definido.
			# 
			private

				# É feito um loop em todas as linhas do arquivo considerando apenas as linhas de detalhe
				# Cada linha representa um pagamento.
				#
				def read_file! #:doc:
					lines = File.readlines(file).map{|l| adjust_encode(l)}
					set_codigo_banco(lines)
					# Ignora a 1ª Linha (Header) e a Última linha (Trailer)
					lines[1..lines.size-2].each do |line|
						instnce_payment(line)
					end
					pagamentos
				end

				# Intsnacia um pagamento através do texto da linha recebida or parâmetro 
				# e adiciona o mesmo no Array de pagamentos
				#
				def instnce_payment(detalhe) #:doc:
					payment = BrBoleto::Retorno::Pagamento.new
					detalhe_fields.each do |column, position |
						payment.send("#{column}=", "_#{detalhe}"[position].try(:strip))
					end
					self.pagamentos << payment
				end

				def detalhe_fields #:doc:
					raise NotImplementedError.new('Sobreescreva este método na classe referente ao banco que você esta criando')
				end

				def set_codigo_banco(lines)
					return if lines.blank?
					self.codigo_banco = "_#{lines[0]}"[77..79]
				end
			end
		end
	end
end