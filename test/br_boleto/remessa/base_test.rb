require 'test_helper'

describe BrBoleto::Remessa::Base do
	subject { FactoryGirl.build(:remessa_base) }
	let(:lote) { FactoryGirl.build(:remessa_lote) } 
	describe "validations" do
		it { must validate_presence_of(:nome_empresa) }
		
		it { must validate_inclusion_of(:aceite).in_array(%w(a A n N)).with_message("valor deve ser A(aceito) ou N(não ceito)") }
		it { wont allow_value('x').for(:aceite) }
		it { wont allow_value('q').for(:aceite) }
	end

	describe "#lotes" do
		it "deve haver ao menos 1 lote" do
			wont allow_value([]).for(:lotes).with_message("não pode estar vazio.")
		end
		it "deve ser um objeto lote" do
			wont allow_value(FactoryGirl.build(:boleto_sicoob)).for(:lotes).with_message("cada item deve ser um objeto Lote.")
		end
		it "deve ser válido com um lote válido" do
			must allow_value([lote]).for(:lotes)
		end
		it "não deve ser válido se houver algum lote inválido" do
			wont allow_value([FactoryGirl.build(:remessa_lote, pagamentos: [])]).for(:lotes)
		end
		it "deve ser válido se passar apenas um lote sem Array" do
			must allow_value(lote).for(:lotes)
		end
		it "se setar apenas 1 lote sem array deve retornar um array de 1 posicao" do
			subject.lotes = lote
			subject.lotes.size.must_equal 1
			subject.lotes.is_a?(Array).must_equal true
			subject.lotes[0].must_equal lote
		end
		it "posso setar mais que 1 lote" do
			lote2 = FactoryGirl.build(:remessa_lote)
			subject.lotes = [lote, lote2]
			subject.lotes.size.must_equal 2
			subject.lotes.is_a?(Array).must_equal true
			subject.lotes[0].must_equal lote
			subject.lotes[1].must_equal lote2
		end

		it "posso incrementar os lotes com <<" do
			lote2 = FactoryGirl.build(:remessa_lote)
			subject.lotes = lote
			subject.lotes.size.must_equal 1
			subject.lotes << lote2
			subject.lotes.size.must_equal 2
			subject.lotes.is_a?(Array).must_equal true
			subject.lotes[0].must_equal lote
			subject.lotes[1].must_equal lote2
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