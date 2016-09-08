# encoding: UTF-8

FactoryGirl.define do
	factory :boleto_base, class:  BrBoleto::Boleto::Base do
		numero_documento '191075'
		valor_documento  101.99
		data_vencimento  Date.new(2015, 07, 10)
		
		# carteira         '175'
		# agencia          '0098'
		# conta_corrente   '98701'
		# cedente          'Nome da razao social'
		# sacado           'Teste'
		# documento_sacado '725.275.005-10'
		# endereco_sacado  'Rua teste, 23045'
		
		instrucoes1      'Lembrar de algo 1'
		instrucoes2      'Lembrar de algo 2'
		instrucoes3      'Lembrar de algo 3'
		instrucoes4      'Lembrar de algo 4'
		instrucoes5      'Lembrar de algo 5'
		instrucoes6      'Lembrar de algo 6'
	end
end