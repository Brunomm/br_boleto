# encoding: UTF-8

FactoryBot.define do
	factory :remessa_cnab240_cecred, class:  BrBoleto::Remessa::Cnab240::Cecred do
		lotes               { FactoryBot.build(:remessa_lote) }
		conta               { FactoryBot.build(:conta_cecred) }
		sequencial_remessa  1
	end
end
