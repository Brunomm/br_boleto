# encoding: UTF-8

FactoryGirl.define do
	factory :boleto_santander, class:  BrBoleto::Boleto::Santander do
		conta             { FactoryGirl.build(:conta_santander) }
		pagador          { FactoryGirl.build(:pagador) }
		numero_documento  '111'
		data_vencimento   { Date.tomorrow }
		data_documento    { Date.current }
		valor_documento   700.00
		instrucoes1       'instrucoes1'
		instrucoes2       'instrucoes2'
		instrucoes3       'instrucoes3'
		instrucoes4       'instrucoes4'
		instrucoes5       'instrucoes5'
		instrucoes6       'instrucoes6'
	end
end