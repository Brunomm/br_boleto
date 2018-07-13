# encoding: UTF-8

FactoryBot.define do
	factory :remessa_cnab400_santander, class:  BrBoleto::Remessa::Cnab400::Santander do
		pagamentos         { FactoryBot.build(:remessa_pagamento) }
		sequencial_remessa 1
	end
end
