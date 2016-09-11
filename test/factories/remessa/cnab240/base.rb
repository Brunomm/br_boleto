# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab240_base, class:  BrBoleto::Remessa::Cnab240::Base do
		lotes              { FactoryGirl.build(:remessa_lote) }
		sequencial_remessa 1
	end
end