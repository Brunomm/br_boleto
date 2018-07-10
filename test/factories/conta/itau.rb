# encoding: UTF-8

FactoryBot.define do
	factory :conta_itau, class:  BrBoleto::Conta::Itau do
		codigo_cedente    '90904'
		conta_corrente    '89755'
		conta_corrente_dv '8'
		agencia           '4697'
		carteira          '109'
		razao_social      'Razao Social emitente'
		cpf_cnpj          '98137264000196' # Gerado pelo gerador de cnpj
		endereco          'Rua nome da rua, 9999'
		codigo_empresa    '1234'
	end
end
