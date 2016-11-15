# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab240_bradesco, class:  BrBoleto::Remessa::Cnab240::Bradesco do
		lotes               { FactoryGirl.build(:remessa_lote) }
		conta               { FactoryGirl.build(:conta_bradesco) }
		sequencial_remessa  1
	end
end