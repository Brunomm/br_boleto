# encoding: UTF-8

FactoryBot.define do
	factory :remessa_cnab240_caixa, class:  BrBoleto::Remessa::Cnab240::Caixa do
		lotes               { FactoryBot.build(:remessa_lote) }
		conta               { FactoryBot.build(:conta_caixa) }
		sequencial_remessa  1
	end
end
