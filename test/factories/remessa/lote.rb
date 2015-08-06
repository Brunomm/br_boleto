# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_lote, class:  BrBoleto::Remessa::Lote do
		pagamentos { FactoryGirl.build(:remessa_pagamento) }
	end
end