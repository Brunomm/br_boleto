# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab400_unicred, class:  BrBoleto::Remessa::Cnab400::Unicred do
		pagamentos         { FactoryGirl.build(:remessa_pagamento) }
		sequencial_remessa 1
	end
end