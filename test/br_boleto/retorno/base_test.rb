require 'test_helper'

require 'pry'
describe BrBoleto::Retorno::Base do

	subject { BrBoleto::Retorno::Base.new('') } 

	before do
		BrBoleto::Retorno::Base.any_instance.stubs(:read_file!)
	end

	describe "#initialize" do
		it "Se passar um arquivo por parâmetro deve setar o valor em @file e chamar o metodo read_file!" do
			BrBoleto::Retorno::Base.any_instance.expects(:read_file!)
			retorno = BrBoleto::Retorno::Base.new('file/path.ret')
			retorno.instance_variable_get(:@file).must_equal 'file/path.ret'
		end
		it "quando instanciar um retorno deve setar os pagamentos com um array" do
			retorno = BrBoleto::Retorno::Base.new('file/path.ret')
			retorno.instance_variable_get(:@pagamentos).must_be_kind_of Array
		end
		it "se não passar o caminho de um arquivo por parâmetro não deve tentar ler o arquivo" do
			BrBoleto::Retorno::Base.any_instance.expects(:read_file!).never
			retorno = BrBoleto::Retorno::Base.new('')
			retorno.instance_variable_get(:@file).must_equal ''
		end
	end

	it "deve validar que o file é obrigatório" do
		subject.instance_variable_set(:@file, '')
		subject.valid?
		subject.errors.messages[:file].must_include( I18n.t("errors.messages.blank") )

		subject.instance_variable_set(:@file, 'something')
		subject.valid?
		subject.errors.messages[:file].must_be_nil
	end

	describe "#pagamentos" do
		it "mesmo se setar um valor normal deve retornar um array" do
			subject.pagamentos = 'valor_normal'
			subject.pagamentos.must_equal(['valor_normal'])
		end
		it "se setar valores em Matriz deve retornar um array" do
			subject.pagamentos = [['valor_1'],'valor_2']
			subject.pagamentos.must_equal(['valor_1','valor_2'])
		end
		it "deve ser possível utilizar o operador << para incrementar valores aos pagamentos" do
			subject.pagamentos << 'valor_1'
			subject.pagamentos.must_equal(['valor_1'])
			subject.pagamentos << 'valor_2'
			subject.pagamentos.must_equal(['valor_1','valor_2'])
		end
	end
	
end