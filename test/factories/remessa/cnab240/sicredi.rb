# encoding: UTF-8

FactoryBot.define do
	factory :remessa_cnab240_sicredi, class:  BrBoleto::Remessa::Cnab240::Sicredi do
		lotes               { FactoryBot.build(:remessa_lote) }
		conta               { FactoryBot.build(:conta_sicredi) }
		sequencial_remessa  1
	end
end
