# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab240_sicredi, class:  BrBoleto::Remessa::Cnab240::Sicredi do
		lotes               { FactoryGirl.build(:remessa_lote) }
		conta               { FactoryGirl.build(:conta_sicredi) }
		sequencial_remessa  1
	end
end