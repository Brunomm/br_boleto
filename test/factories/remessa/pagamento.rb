# encoding: UTF-8

FactoryBot.define do
	factory :remessa_pagamento, class:  BrBoleto::Remessa::Pagamento do
		nosso_numero     "123456"
		numero_documento "977897"
		data_vencimento  { Date.tomorrow }
		valor_documento  100.123
		pagador          { FactoryBot.build(:pagador) }
		codigo_juros     '1'
		# documento_sacado "12345678901"
		# nome_sacado      "TESTE NOME DO SACADO"
		# endereco_sacado  "R. TESTE DO SACADO"
		# cep_sacado       "89888000"
		# cidade_sacado    "PIRÁPORA"
		# uf_sacado        "SC"
		# bairro_sacado    "Bairro"
	end
end
