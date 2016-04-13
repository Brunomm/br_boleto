# encoding: UTF-8

FactoryGirl.define do
	factory :boleto_caixa, class:  BrBoleto::Boleto::Caixa do
		cedente           'Fabrica de Materiais LTDA'
		documento_cedente '200.874.0006-87'
		endereco_cedente  'Rua para Testes - Belo Horizonte / MG'  
		sacado            'Cleber Machado dos Santos'
		documento_sacado  '52166727964'
		endereco_sacado   'Rua Teste do Seu Cliente'  
		numero_documento  '458'
		data_vencimento   { Date.tomorrow }
		data_documento    { Date.current }
		agencia           "2391"
		codigo_cedente    '4433'
		valor_documento   750.27
		carteira          '14'
		instrucoes1       'instrucoes1'
		instrucoes2       'instrucoes2'
		instrucoes3       'instrucoes3'
		instrucoes4       'instrucoes4'
		instrucoes5       'instrucoes5'
		instrucoes6       'instrucoes6'
	end
end