# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab400_sicredi, class:  BrBoleto::Remessa::Cnab400::Sicredi do
		pagamentos         { FactoryGirl.build(:remessa_pagamento) }
		sequencial_remessa 1
	end
end