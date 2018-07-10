# encoding: UTF-8

FactoryBot.define do
	factory :remessa_lote, class:  BrBoleto::Remessa::Lote do
		pagamentos { FactoryBot.build(:remessa_pagamento) }
	end
end
