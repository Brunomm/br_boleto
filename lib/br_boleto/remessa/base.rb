module BrBoleto
	module Remessa
		class Base
			# Seguindo a interface do Active Model para:
			# * Validações;
			# * Internacionalização;
			# * Nomes das classes para serem manipuladas;
			#
			include ActiveModel::Model

			# variavel que terá os lotes no qual será gerado o arquivo de remessa
			# um lote deve conter no minimo 1 pagamento
			# Pode haver 1 ou vários lotes para o mesmo arquivo
			attr_accessor :lotes

			def self.class_for_lote
				BrBoleto::Remessa::Lote
			end

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
				self.lotes = [] # Para poder utilizar o << para adicionar lote
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

			validates_each :lotes do |record, attr, value|
				record.errors.add(attr, 'não pode estar vazio.') if value.empty?
				value.each do |lote|
					if lote.is_a? record.class.class_for_lote
						if lote.invalid?
							lote.errors.full_messages.each { |msg| record.errors.add(attr, msg) }
						end
					else
						record.errors.add(attr, 'cada item deve ser um objeto Lote.')
					end
				end				
			end

			# O atributo lotes sempre irá retornar umm Array 
			def lotes
				@lotes = [@lotes].flatten
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