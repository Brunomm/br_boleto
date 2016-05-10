# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab240_caixa, class:  BrBoleto::Remessa::Cnab240::Caixa do
		lotes               { FactoryGirl.build(:remessa_lote) }
		nome_empresa        "Nome da empresa"
		agencia             "3069"
		carteira            '14'
		sequencial_remessa  1
		documento_cedente   '93.671.653/0001-83'
		convenio            '31400'
		modalidade_carteira '14'
	end
end