# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_base, class:  BrBoleto::Remessa::Base do
		pagamentos         { FactoryGirl.build(:remessa_pagamento) }
		nome_empresa       "Nome da empresa"
		agencia            "3069"
		conta_corrente     "123456"
		digito_conta       "5"
		carteira           "1"
		sequencial_remessa 1
	end
end