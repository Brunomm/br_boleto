# encoding: UTF-8

FactoryBot.define do
	factory :boleto_cecred, class:  BrBoleto::Boleto::Cecred do
		conta             { FactoryBot.build(:conta_cecred) }
		pagador          { FactoryBot.build(:pagador) }
		numero_documento  '875'
		data_vencimento   { Date.tomorrow }
		data_documento    { Date.current }
		valor_documento   50.12
		instrucoes1       'instrucoes1'
		instrucoes2       'instrucoes2'
		instrucoes3       'instrucoes3'
		instrucoes4       'instrucoes4'
		instrucoes5       'instrucoes5'
		instrucoes6       'instrucoes6'
	end
end
