# encoding: UTF-8

FactoryGirl.define do
	factory :conta_cecred, class:  BrBoleto::Conta::Cecred do
		codigo_cedente    '909014'
		conta_corrente    '8975599'
		conta_corrente_dv '8'
		agencia           '4697'
		carteira          '1'
		razao_social      'Razao Social emitente'
		cpf_cnpj          '98137264000196' # Gerado pelo gerador de cnpj
		endereco          'Rua nome da rua, 9999'
		codigo_empresa    '1234'
	end
end