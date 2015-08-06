require 'test_helper'

describe BrBoleto::Remessa::Lote do
	subject { FactoryGirl.build(:remessa_lote) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento) } 
	
	describe "#pagamentos" do
		it "deve haver ao menos 1 pagamento" do
			wont allow_value([]).for(:pagamentos).with_message("não pode estar vazio.")
		end
		it "deve ser um objeto pagamento" do
			wont allow_value([subject.class.new()]).for(:pagamentos).with_message("cada item deve ser um objeto Pagamento.")
		end
		it "deve ser válido com um pagamento válido" do
			must allow_value([pagamento]).for(:pagamentos)
		end
		it "não deve ser válidose houver algum pagamento inválido" do
			wont allow_value([FactoryGirl.build(:remessa_pagamento, cep_sacado: nil)]).for(:pagamentos)
		end
		it "deve ser válido se passar apenas um pagamento sem Array" do
			must allow_value(pagamento).for(:pagamentos)
		end
		it "se setar apenas 1 pagamento sem array deve retornar um array de 1 posicao" do
			subject.pagamentos = pagamento
			subject.pagamentos.size.must_equal 1
			subject.pagamentos.is_a?(Array).must_equal true
			subject.pagamentos[0].must_equal pagamento
		end
		it "posso setar mais que 1 pagamento" do
			pagamento2 = FactoryGirl.build(:remessa_pagamento)
			subject.pagamentos = [pagamento, pagamento2]
			subject.pagamentos.size.must_equal 2
			subject.pagamentos.is_a?(Array).must_equal true
			subject.pagamentos[0].must_equal pagamento
			subject.pagamentos[1].must_equal pagamento2
		end

		it "posso incrementar os pagamentos com <<" do
			pagamento2 = FactoryGirl.build(:remessa_pagamento, valor_documento: 0.50)
			subject.pagamentos = pagamento
			subject.pagamentos.size.must_equal 1
			subject.pagamentos << pagamento2
			subject.pagamentos.size.must_equal 2
			subject.pagamentos.is_a?(Array).must_equal true
			subject.pagamentos[0].must_equal pagamento
			subject.pagamentos[1].must_equal pagamento2
		end
	end
end