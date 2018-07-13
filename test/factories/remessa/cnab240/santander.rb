# encoding: UTF-8

FactoryBot.define do
	factory :remessa_cnab240_santander, class:  BrBoleto::Remessa::Cnab240::Santander do
		lotes               { FactoryBot.build(:remessa_lote) }
		conta               { FactoryBot.build(:conta_santander) }
		sequencial_remessa  1
	end
end
