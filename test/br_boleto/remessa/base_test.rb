require 'test_helper'

describe BrBoleto::Remessa::Base do
	subject { FactoryGirl.build(:remessa_base) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento) } 
	describe "validations" do
		it { must validate_presence_of(:nome_empresa) }
		
		it { must validate_inclusion_of(:aceite).in_array(%w(a A n N)).with_message("valor deve ser A(aceito) ou N(não ceito)") }
		it { wont allow_value('x').for(:aceite) }
		it { wont allow_value('q').for(:aceite) }
	end

	describe "#pagamentos" do
		it "deve haver ao menos 1 pagamento" do
			wont allow_value([]).for(:pagamentos).with_message("não pode estar vazio.")
		end
		it "deve ser um objeto pagamento" do
			wont allow_value([BrBoleto::Boleto::Base.new()]).for(:pagamentos).with_message("cada item deve ser um objeto Pagamento.")
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
	end

	describe "#default_values" do
		it "for aceite" do
			object = subject.class.new()
			object.aceite.must_equal 'N'
		end
	end

	it "wont be persisted?" do
		subject.persisted?.must_equal false
	end

	describe "#nome_empresa_formatada" do
		it "deve adicionar valor em branco no final se for menor que 30 caracteres" do
			subject.nome_empresa = '1234567890'
			subject.nome_empresa_formatada.size.must_equal 30
			subject.nome_empresa_formatada.must_equal('1234567890'.ljust(30, ' '))
		end
		it "deve retornar no maximo 30 caracteres se for maior que 30" do
			subject.nome_empresa = '0123456'.ljust(35, 'A')
			subject.nome_empresa_formatada.size.must_equal 30
			subject.nome_empresa_formatada.must_equal('0123456'.ljust(30, 'A'))
		end
	end
end