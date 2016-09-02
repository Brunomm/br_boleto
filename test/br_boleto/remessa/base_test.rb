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