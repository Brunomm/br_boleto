# encoding: UTF-8

FactoryBot.define do
	factory :remessa_cnab400_banco_brasil, class:  BrBoleto::Remessa::Cnab400::BancoBrasil do
		pagamentos         { FactoryBot.build(:remessa_pagamento) }
		sequencial_remessa 1
	end
end
