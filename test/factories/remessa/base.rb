# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_base, class:  BrBoleto::Remessa::Base do
		sequencial_remessa 1
	end
end