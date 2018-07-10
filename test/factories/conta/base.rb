# encoding: UTF-8

FactoryBot.define do
	factory :conta_base, class:  BrBoleto::Conta::Base do
		nome_banco  'Conta Base'
		razao_social 'Emitente'
		cpf_cnpj     '98137264000196' # Gerado pelo gerador de cnpj
		agencia      '5874'
	end
end
