# encoding: UTF-8

FactoryBot.define do
	factory :remessa_cnab240_unicred, class:  BrBoleto::Remessa::Cnab240::Unicred do
		lotes               { FactoryBot.build(:remessa_lote) }
		conta               { FactoryBot.build(:conta_unicred) }
		sequencial_remessa  1
	end
end
