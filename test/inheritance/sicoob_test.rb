# encoding: utf-8
require 'test_helper'

class TesteSicoob < BrBoleto::Sicoob
	def self.valor_documento_tamanho_maximo
		456.50 # Default 99999999.99
	end

	def self.carteiras_suportadas
		%w[1] # Default %w[1 3]
	end
end

describe TesteSicoob do
	subject { TesteSicoob.new() }

	describe "on validations" do
		it { must validate_numericality_of(:valor_documento).is_less_than_or_equal_to(456.50) }

		it { must validate_inclusion_of(:carteira).in_array(%w(1)) }
		it { wont allow_value(3).for(:carteira) }		
		it { wont allow_value(6).for(:carteira) }		
		it { wont allow_value(9).for(:carteira) }
	end
end
