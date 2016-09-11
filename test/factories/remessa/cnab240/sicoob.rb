# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab240_sicoob, class:  BrBoleto::Remessa::Cnab240::Sicoob do
		lotes               { FactoryGirl.build(:remessa_lote) }
		conta               { FactoryGirl.build(:conta_sicoob) }
		sequencial_remessa  1
	end
end