# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab400_caixa, class:  BrBoleto::Remessa::Cnab400::Caixa do
		pagamentos         { FactoryGirl.build(:remessa_pagamento) }
		sequencial_remessa 1
	end
end