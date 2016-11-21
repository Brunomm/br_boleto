# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab240_banco_brasil, class:  BrBoleto::Remessa::Cnab240::BancoBrasil do
		lotes               { FactoryGirl.build(:remessa_lote) }
		conta               { FactoryGirl.build(:conta_banco_brasil) }
		sequencial_remessa  1
	end
end