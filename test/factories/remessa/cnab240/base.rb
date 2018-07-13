# encoding: UTF-8

FactoryBot.define do
	factory :remessa_cnab240_base, class:  BrBoleto::Remessa::Cnab240::Base do
		lotes              { FactoryBot.build(:remessa_lote) }
		sequencial_remessa 1
	end
end
