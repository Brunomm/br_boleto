# encoding: utf-8
require 'test_helper'

describe BrBoleto::Calculos::Digitos do
  (0..9).each do |number|
		it "should return self when is #{number}" do
			BrBoleto::Calculos::Digitos.new(number).sum.must_equal number
		end
	end
	{ 11 => 2, '18' => 9, 99 => 18, '58' => 13, 112 => 4, '235' => 10 }.each do |number, expecting|
		it "should sum the sum of the digits when is '#{number}', expecting to be '#{expecting}'" do
			BrBoleto::Calculos::Digitos.new(number).sum.must_equal expecting
		end
	end
end