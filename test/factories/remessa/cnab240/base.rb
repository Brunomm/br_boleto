# encoding: UTF-8

FactoryGirl.define do
	factory :remessa_cnab240_base, class:  BrBoleto::Remessa::Cnab240::Base do
		lotes              { FactoryGirl.build(:remessa_lote) }
		nome_empresa       "Nome da empresa"
		agencia            "3069"
		conta_corrente     "123456"
		digito_conta       "5"
		carteira           "1"
		sequencial_remessa 1
		documento_cedente  '12345678901'
		convenio           '1'
		emissao_boleto     '1'
		distribuicao_boleto '1'
		especie_titulo     '02'
	end
end