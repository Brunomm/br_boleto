# encoding: UTF-8

FactoryBot.define do
	factory :boleto_caixa, class:  BrBoleto::Boleto::Caixa do
		conta             { FactoryBot.build(:conta_caixa) }
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
