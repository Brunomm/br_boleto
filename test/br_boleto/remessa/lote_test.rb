require 'test_helper'

describe BrBoleto::Remessa::Lote do
	subject { FactoryBot.build(:remessa_lote) }
	let(:pagamento) { FactoryBot.build(:remessa_pagamento) }

	it "deve ter incluso o module HavePagamentos" do
		subject.class.included_modules.must_include BrBoleto::HavePagamentos
	end
end
