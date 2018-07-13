# encoding: UTF-8

FactoryBot.define do
	factory :remessa_cnab400_sicoob, class:  BrBoleto::Remessa::Cnab400::Sicoob do
		pagamentos         { FactoryBot.build(:remessa_pagamento) }
		sequencial_remessa 1
	end
end
