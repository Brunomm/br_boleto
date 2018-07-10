# encoding: UTF-8

FactoryBot.define do
	factory :boleto_unicred, class:  BrBoleto::Boleto::Unicred do
		conta             { FactoryBot.build(:conta_unicred) }
		pagador          { FactoryBot.build(:pagador) }
		numero_documento  '458'
		data_vencimento   { Date.tomorrow }
		data_documento    { Date.current }
		valor_documento   750.27
		instrucoes1       'instrucoes1'
		instrucoes2       'instrucoes2'
		instrucoes3       'instrucoes3'
		instrucoes4       'instrucoes4'
		instrucoes5       'instrucoes5'
		instrucoes6       'instrucoes6'
	end
end
