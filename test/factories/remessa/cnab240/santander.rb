# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab240_santander, class:  BrBoleto::Remessa::Cnab240::Santander do
		lotes               { FactoryGirl.build(:remessa_lote) }
		conta               { FactoryGirl.build(:conta_santander) }
		sequencial_remessa  1
	end
end