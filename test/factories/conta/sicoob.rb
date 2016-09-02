# encoding: UTF-8

FactoryGirl.define do
	factory :conta_sicoob, class:  BrBoleto::Conta::Sicoob do
		codigo_beneficiario     '253167'
		codigo_beneficiario_dv  '4'
		conta_corrente    '887469'
		conta_corrente_dv '7'
		agencia           '3069'
		carteira          '1'
		modalidade        '02'  
		razao_social      'Razao Social emitente'
		cpf_cnpj          '98137264000196' # Gerado pelo gerador de cnpj
		endereco          'Rua nome da rua, 9999'
	end
end