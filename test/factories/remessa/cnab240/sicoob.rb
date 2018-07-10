# encoding: UTF-8

FactoryBot.define do
	factory :remessa_cnab240_sicoob, class:  BrBoleto::Remessa::Cnab240::Sicoob do
		lotes               { FactoryBot.build(:remessa_lote) }
		conta               { FactoryBot.build(:conta_sicoob) }
		sequencial_remessa  1
	end
end
