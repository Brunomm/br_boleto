module BrBoleto
	module Remessa
		class Base
			# Seguindo a interface do Active Model para:
			# * Validações;
			# * Internacionalização;
			# * Nomes das classes para serem manipuladas;
			#
			include ActiveModel::Model

			# variavel que terá os pagamentos no qual será gerado o arquivo de remessa
			# Pode haver 1 ou vários pagamentos para o mesmo arquivo
			attr_accessor :pagamentos

			# Razão social da empresa
			attr_accessor :nome_empresa

			# agencia (sem digito verificador)
			attr_accessor :agencia

			# numero da conta corrente
			attr_accessor :conta_corrente

			# digito verificador da conta corrente
			attr_accessor :digito_conta

			# carteira do cedente
			attr_accessor :carteira

			# sequencial remessa (num. sequencial que nao pode ser repetido nem zerado)
			attr_accessor :sequencial_remessa

			# aceite (A = ACEITO/N = NAO ACEITO)
			attr_accessor :aceite

			def initialize(attributes = {})
				attributes = default_values.merge!(attributes)
				assign_attributes(attributes)
				yield self if block_given?
			end

			def assign_attributes(attributes)
				attributes ||= {}
				attributes.each do |name, value|
					send("#{name}=", value)
				end
			end

			validates :nome_empresa, presence: true
			validates :aceite,       inclusion: { in: %w(A a n N), message: "valor deve ser A(aceito) ou N(não ceito)" }

			validates_each :pagamentos do |record, attr, value|
				record.errors.add(attr, 'não pode estar vazio.') if value.empty?
				value.each do |pagamento|
					if pagamento.is_a? BrBoleto::Remessa::Pagamento
						if pagamento.invalid?
							pagamento.errors.full_messages.each { |msg| record.errors.add(attr, msg) }
						end
					else
						record.errors.add(attr, 'cada item deve ser um objeto Pagamento.')
					end
				end				
			end

			# O atributo pagamentos sempre irá retornar umm Array 
			def pagamentos
				@pagamentos = [@pagamentos].flatten
			end

			def default_values
				{aceite: "N"}
			end

			def persisted?
				false
			end

			def nome_empresa_formatada
				"#{nome_empresa}".adjust_size_to(30)
			end			
		end
	end
end