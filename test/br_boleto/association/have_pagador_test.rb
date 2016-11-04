require 'test_helper'

class HavePagadorTest < BrBoleto::ActiveModelBase
	include BrBoleto::HavePagador
end

describe BrBoleto::HavePagador do
	subject { HavePagadorTest.new(pagador: {nome: 'Razão social', cpf_cnpj: '12345678901'}) } 

	it "por padrão nao deve validar nada" do
		wont_be_message_error(:base)
	end

	it "Sempre deve vir instanciado um objeto da classe definida em pagador_class" do
		subject.pagador.must_be_kind_of BrBoleto::Pagador
	end

	it "se setar outro objeto que não seja da class definida em pagador_class deve ignorar e instanciar a classe correta" do
		HavePagadorTest.any_instance.stubs(:pagador_class).returns(String)
		have_pag = HavePagadorTest.new
		have_pag.pagador = 123
		have_pag.pagador.must_equal ''
		have_pag.pagador = '123'
		have_pag.pagador.must_equal '123'

		have_pag.stubs(:pagador_class).returns(Array)
		have_pag.pagador = '123'
		have_pag.pagador.must_equal []
		have_pag.pagador = [123]
		have_pag.pagador.must_equal [123]
	end

	it "Deve ser possivel inicializar o objeto passando a pagador como bloco" do
		result = HavePagadorTest.new do |hav|
			hav.pagador do |co|
				co.nome     = 'Empresa banco'
				co.cpf_cnpj = '074.554.663-87'
			end
		end
		result.pagador.nome.must_equal 'Empresa banco'
		result.pagador.cpf_cnpj.must_equal     '07455466387'
	end

	it "Deve ser possivel editar a pagador com um bloco" do
		subject.pagador.nome = 'razao_1'
		subject.pagador do |co|
			co.nome = 'razao_2'
			co.cep      = '456'
		end
		subject.pagador.nome.must_equal 'razao_2'
		subject.pagador.cep.must_equal '456'
	end

	it "Deve ser possivel inicializar o objeto passando a pagador como hash" do
		result = HavePagadorTest.new({
			pagador: {
				nome:  'Empresa banco',
				cpf_cnpj:      '074.554.663-87',
				endereco:       '456',
			}
		})
		result.pagador.nome.must_equal 'Empresa banco'
		result.pagador.cpf_cnpj.must_equal '07455466387'
		result.pagador.endereco.must_equal '456'
	end

	it "Deve ser possivel editar a pagador com um hash" do
		subject.pagador.cpf_cnpj     = '12345678901'
		subject.pagador.nome = 'razao_1'
		subject.pagador = {
			nome: 'razao_2',
			endereco:      '456',
		}
		subject.pagador.nome.must_equal 'razao_2'
		subject.pagador.endereco.must_equal '456'
		subject.pagador.cpf_cnpj.must_equal '12345678901'
	end

	it 'Validação para endereco' do
		subject.stubs(:valid_endereco_required).returns(true)
		must_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:endereco)} #{get_message(:blank, {})}")
		must_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:bairro)} #{get_message(:blank, {})}")
		must_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:cep)} #{get_message(:blank, {})}")
		must_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:cidade)} #{get_message(:blank, {})}")
		must_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:uf)} #{get_message(:blank, {})}")
	end


	context "o valor setado nas validações devem obedecer a classe que inclui a pagador. Mesmo que a pagador tenha uma validação diferente" do
		before do
			subject.pagador.valid_endereco_required = true
		end

		it "Se os metodos do objeto que temm a pagador tiverem valor nos seus metodos deve permanecer esses valores" do
			subject.stubs(:valid_endereco_required).returns(false)
			wont_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:endereco)} #{get_message(:blank, {})}")
			wont_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:bairro)} #{get_message(:blank, {})}")
			wont_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:cep)} #{get_message(:blank, {})}")
			wont_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:cidade)} #{get_message(:blank, {})}")
			wont_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:uf)} #{get_message(:blank, {})}")
		end

		it "Deve considerar as validações setadas na pagador se não houver os metodos sobrescritos no objeto que tem a pagador" do
			must_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:endereco)} #{get_message(:blank, {})}")
			must_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:bairro)} #{get_message(:blank, {})}")
			must_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:cep)} #{get_message(:blank, {})}")
			must_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:cidade)} #{get_message(:blank, {})}")
			must_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:uf)} #{get_message(:blank, {})}")
		end
	end

	it 'Validação para avalsita' do
		subject.stubs(:valid_avalista_required).returns(true)
		must_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:nome_avalista)} #{get_message(:blank, {})}")
		must_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:documento_avalista)} #{get_message(:blank, {})}")
	end
	context "o valor setado nas validações devem obedecer a classe que inclui a pagador. Mesmo que a pagador tenha uma validação diferente" do
		before do
			subject.pagador.valid_avalista_required = true
		end

		it "Se os metodos do objeto que temm a pagador tiverem valor nos seus metodos deve permanecer esses valores" do
			subject.stubs(:valid_avalista_required).returns(false)
			wont_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:nome_avalista)} #{get_message(:blank, {})}")
			wont_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:documento_avalista)} #{get_message(:blank, {})}")
		end

		it "Deve considerar as validações setadas na pagador se não houver os metodos sobrescritos no objeto que tem a pagador" do
			must_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:nome_avalista)} #{get_message(:blank, {})}")
			must_be_message_error(:base, "#{BrBoleto::Pagador.human_attribute_name(:documento_avalista)} #{get_message(:blank, {})}")
		end
	end
	
end