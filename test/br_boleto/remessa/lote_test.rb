require 'test_helper'

describe BrBoleto::Remessa::Lote do
	subject { FactoryGirl.build(:remessa_lote) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento) } 
	
	it "deve ter incluso o module HavePagamentos" do
		subject.class.included_modules.must_include BrBoleto::HavePagamentos
	end
end