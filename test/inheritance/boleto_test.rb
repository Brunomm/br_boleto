# encoding: utf-8
require 'test_helper'

class TesteBoleto < BrBoleto::Boleto
  def self.valor_documento_tamanho_maximo
    9_999.99 # Default 99999999.99
  end
end

describe TesteBoleto do
	subject { TesteBoleto.new() }
	context "on validations" do
		it { must validate_numericality_of(:valor_documento).is_less_than_or_equal_to(9_999.99) }
	end
end
