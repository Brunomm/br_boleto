# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab240_unicred, class:  BrBoleto::Remessa::Cnab240::Unicred do
		lotes               { FactoryGirl.build(:remessa_lote) }
		conta               { FactoryGirl.build(:conta_unicred) }
		sequencial_remessa  1
	end
end