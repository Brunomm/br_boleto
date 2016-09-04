# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab240_caixa, class:  BrBoleto::Remessa::Cnab240::Caixa do
		lotes               { FactoryGirl.build(:remessa_lote) }
		conta               { FactoryGirl.build(:conta_caixa) }
		sequencial_remessa  1
	end
end