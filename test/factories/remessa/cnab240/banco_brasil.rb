# encoding: UTF-8

FactoryBot.define do
	factory :remessa_cnab240_banco_brasil, class:  BrBoleto::Remessa::Cnab240::BancoBrasil do
		lotes               { FactoryBot.build(:remessa_lote) }
		conta               { FactoryBot.build(:conta_banco_brasil) }
		sequencial_remessa  1
	end
end
