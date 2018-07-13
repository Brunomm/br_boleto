# encoding: UTF-8

FactoryBot.define do
	factory :remessa_cnab240_bradesco, class:  BrBoleto::Remessa::Cnab240::Bradesco do
		lotes               { FactoryBot.build(:remessa_lote) }
		conta               { FactoryBot.build(:conta_bradesco) }
		sequencial_remessa  1
	end
end
