# encoding: UTF-8

FactoryGirl.define do
	factory :boleto_sicoob, class:  BrBoleto::Boleto::Sicoob do
		conta            { FactoryGirl.build(:conta_sicoob) }
		pagador          { FactoryGirl.build(:pagador) }
		numero_documento 1101
		valor_documento  93015.78
		data_vencimento  Date.parse('2019-02-17')
		# agencia          95
		# codigo_cedente   6532
		# carteira         1
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