# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab240_itau, class:  BrBoleto::Remessa::Cnab240::Itau do
		lotes               { FactoryGirl.build(:remessa_lote) }
		conta               { FactoryGirl.build(:conta_itau) }
		sequencial_remessa  1
	end
end