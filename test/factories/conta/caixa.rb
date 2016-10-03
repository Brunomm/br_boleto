# encoding: UTF-8

FactoryGirl.define do
	factory :conta_caixa, class:  BrBoleto::Conta::Caixa do
		codigo_cedente     '653137'
		conta_corrente    '6035'
		conta_corrente_dv '0'
		agencia           '0341'
		carteira          '1'
		modalidade        '14'
		# codigo_carteira   '1'
		razao_social      'Razao Social emitente'
		cpf_cnpj          '98137264000196' # Gerado pelo gerador de cnpj
		endereco          'Rua nome da rua, 9999'
	end
end