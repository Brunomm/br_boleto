require 'test_helper'

class HavePagamentosTest < BrBoleto::ActiveModelBase
	include BrBoleto::HavePagamentos
end

describe BrBoleto::HavePagamentos do
	subject { HavePagamentosTest.new(pagamentos: [pagamento]) }
	let(:pagamento) { BrBoleto::Remessa::Pagamento.new(nosso_numero: '123', data_vencimento: Date.tomorrow, valor_documento: 100.60) }

	it "por padrão nao deve validar nada a não ser o nosso_numero, data_vencimento e valor_documento" do
		wont_be_message_error(:base)
	end

	it "deve haver ao menos 1 pagamento" do
		wont allow_value([]).for(:pagamentos).with_message(:blank)
	end
	it "não deve ser válidose houver algum pagamento inválido" do
		wont allow_value([FactoryBot.build(:remessa_pagamento, nosso_numero: nil)]).for(:pagamentos)
	end
	it "deve ser válido se passar apenas um pagamento sem Array" do
		pagamento_valido = FactoryBot.build(:remessa_pagamento)
		must allow_value(pagamento_valido).for(:pagamentos)
	end
	it "se setar apenas 1 pagamento sem array deve retornar um array de 1 posicao" do
		subject.pagamentos = pagamento
		subject.pagamentos.size.must_equal 1
		subject.pagamentos.is_a?(Array).must_equal true
		subject.pagamentos[0].must_equal pagamento
	end
	it "posso setar mais que 1 pagamento" do
		pagamento2 = FactoryBot.build(:remessa_pagamento)
		subject.pagamentos = [pagamento, pagamento2]
		subject.pagamentos.size.must_equal 2
		subject.pagamentos.is_a?(Array).must_equal true
		subject.pagamentos[0].must_equal pagamento
		subject.pagamentos[1].must_equal pagamento2
	end

	it "posso incrementar os pagamentos com <<" do
		pagamento2 = FactoryBot.build(:remessa_pagamento, valor_documento: 0.50)
		subject.pagamentos = pagamento
		subject.pagamentos.size.must_equal 1
		subject.pagamentos << pagamento2
		subject.pagamentos.size.must_equal 2
		subject.pagamentos.is_a?(Array).must_equal true
		subject.pagamentos[0].must_equal pagamento
		subject.pagamentos[1].must_equal pagamento2
	end

	it "o metodo pagamentos deve considerar apenas objetos'Pagamento" do
		pagamento2 = FactoryBot.build(:remessa_pagamento, valor_documento: 0.50)
		subject.pagamentos << 'abc'
		subject.pagamentos << pagamento2
		subject.pagamentos << 123

		subject.pagamentos.size.must_equal 2
		subject.pagamentos.must_include pagamento
		subject.pagamentos.must_include pagamento2
	end

	context "o valor setado nas validações devem obedecer a classe que inclui a conta. Mesmo que a conta tenha uma validação diferente" do
		before do
			subject.pagamentos = [pagamento]
			pagamento.valid_tipo_impressao_required    = true
			pagamento.valid_cod_desconto_length        = 6
			pagamento.valid_emissao_boleto_length      = 1
			pagamento.valid_distribuicao_boleto_length = 2
		end

		context "Se os metodos do objeto que tem os pagamentos tiverem valor nos seus metodos deve permanecer esses valores" do
			it '#tipo_impressao' do
				subject.pagamento_valid_tipo_impressao_required = false
				pagamento.tipo_impressao = nil
				wont_be_message_error(:pagamentos, "#{pagamento.nosso_numero}: #{BrBoleto::Remessa::Pagamento.human_attribute_name(:tipo_impressao)} #{get_message(:blank, {})}")
			end
			it '#cod_desconto' do
				subject.pagamento_valid_cod_desconto_length = 4
				pagamento.cod_desconto = '123'
				must_be_message_error(:pagamentos, "#{pagamento.nosso_numero}: #{BrBoleto::Remessa::Pagamento.human_attribute_name(:cod_desconto)} #{get_message(:custom_length_is, {count: 4})}")
			end
			it '#emissao_boleto' do
				subject.pagamento_valid_emissao_boleto_length = 4
				pagamento.emissao_boleto = '123'
				must_be_message_error(:pagamentos, "#{pagamento.nosso_numero}: #{BrBoleto::Remessa::Pagamento.human_attribute_name(:emissao_boleto)} #{get_message(:custom_length_is, {count: 4})}")
			end
			it '#distribuicao_boleto' do
				subject.pagamento_valid_distribuicao_boleto_length = 4
				pagamento.distribuicao_boleto = '123'
				must_be_message_error(:pagamentos, "#{pagamento.nosso_numero}: #{BrBoleto::Remessa::Pagamento.human_attribute_name(:distribuicao_boleto)} #{get_message(:custom_length_is, {count: 4})}")
			end
		end

		context "Deve considerar as validações setadas nos pagamentos se não houver os metodos sobrescritos no objeto que tem os pagamentos" do
			it '#tipo_impressao' do
				pagamento.tipo_impressao = nil
				must_be_message_error(:pagamentos, "#{pagamento.nosso_numero}: #{BrBoleto::Remessa::Pagamento.human_attribute_name(:tipo_impressao)} #{get_message(:blank, {})}")
			end
			it '#cod_desconto' do
				pagamento.cod_desconto = '123'
				must_be_message_error(:pagamentos, "#{pagamento.nosso_numero}: #{BrBoleto::Remessa::Pagamento.human_attribute_name(:cod_desconto)} #{get_message(:custom_length_is, {count: 6})}")
			end
			it '#emissao_boleto' do
				pagamento.emissao_boleto = '123'
				must_be_message_error(:pagamentos, "#{pagamento.nosso_numero}: #{BrBoleto::Remessa::Pagamento.human_attribute_name(:emissao_boleto)} #{get_message(:custom_length_is, {count: 1})}")
			end
			it '#distribuicao_boleto' do
				pagamento.distribuicao_boleto = '123'
				must_be_message_error(:pagamentos, "#{pagamento.nosso_numero}: #{BrBoleto::Remessa::Pagamento.human_attribute_name(:distribuicao_boleto)} #{get_message(:custom_length_is, {count: 2})}")
			end
		end
	end
end
