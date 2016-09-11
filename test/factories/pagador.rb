# encoding: UTF-8

FactoryGirl.define do
	factory :pagador, class:  BrBoleto::Pagador do
		nome      'João da Silva'
		cpf_cnpj  '33.669.170/0001-12' # Gerado pelo gerador de cnpj
		endereco  'RUA DO PAGADOR'
		bairro    'Bairro do pagador'
		cep       '89885-000'
		cidade    'Chapecó'
		uf        'SC'
		nome_avalista      'Maria avalista'
		documento_avalista '840.106.990-43' # Gerado pelo gerador de CPF
	end
end