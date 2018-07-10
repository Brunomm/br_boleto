# encoding: UTF-8

FactoryBot.define do
	factory :remessa_cnab240_itau, class:  BrBoleto::Remessa::Cnab240::Itau do
		lotes               { FactoryBot.build(:remessa_lote) }
		conta               { FactoryBot.build(:conta_itau) }
		sequencial_remessa  1
	end
end
