# encoding: UTF-8

FactoryBot.define do
	factory :remessa_cnab400_base, class:  BrBoleto::Remessa::Cnab400::Base do
		pagamentos         { FactoryBot.build(:remessa_pagamento) }
		sequencial_remessa 1
	end
end
