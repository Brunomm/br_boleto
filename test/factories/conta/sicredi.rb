# encoding: UTF-8

FactoryBot.define do
	factory :conta_sicredi, class:  BrBoleto::Conta::Sicredi do
		codigo_cedente    '90901'
		conta_corrente    '89755'
		agencia           '4697'
		posto             '02'
		carteira          '1'
		razao_social      'Razao Social emitente'
		cpf_cnpj          '98137264000196' # Gerado pelo gerador de cnpj
		endereco          'Rua nome da rua, 9999'
		codigo_empresa    '1234'
	end
end
