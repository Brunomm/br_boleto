# encoding: UTF-8

FactoryBot.define do
	factory :boleto_itau, class:  BrBoleto::Boleto::Itau do
		conta             { FactoryBot.build(:conta_itau) }
		pagador          { FactoryBot.build(:pagador) }
		numero_documento  '712'
		data_vencimento   { Date.tomorrow }
		data_documento    { Date.current }
		valor_documento   10.15
		instrucoes1       'instrucoes1'
		instrucoes2       'instrucoes2'
		instrucoes3       'instrucoes3'
		instrucoes4       'instrucoes4'
		instrucoes5       'instrucoes5'
		instrucoes6       'instrucoes6'
	end
end
