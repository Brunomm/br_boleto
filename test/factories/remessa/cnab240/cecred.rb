# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab240_cecred, class:  BrBoleto::Remessa::Cnab240::Cecred do
		lotes               { FactoryGirl.build(:remessa_lote) }
		conta               { FactoryGirl.build(:conta_cecred) }
		sequencial_remessa  1
	end
end