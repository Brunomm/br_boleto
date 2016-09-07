require 'test_helper'

class HaveContaTest < BrBoleto::ActiveModelBase
	include BrBoleto::HaveConta
end

describe BrBoleto::HaveConta do
	subject { HaveContaTest.new(conta: {agencia_dv: 1, agencia: '1235', razao_social: 'Razao', cpf_cnpj: '12345678901'}) } 

	before { HaveContaTest.any_instance.stubs(:conta_class).returns(BrBoleto::Conta::Base) }

	it "Sempre deve vir instanciado um objeto da classe definida em conta_class" do
		subject.conta.must_be_kind_of BrBoleto::Conta::Base
	end

	it "se setar outro objeto que não seja da class definida em conta_class deve ignorar e instanciar a classe correta" do
		HaveContaTest.any_instance.stubs(:conta_class).returns(String)
		have_conta = HaveContaTest.new
		have_conta.conta = 123
		have_conta.conta.must_equal ''
		have_conta.conta = '123'
		have_conta.conta.must_equal '123'

		have_conta.stubs(:conta_class).returns(Array)
		have_conta.conta = '123'
		have_conta.conta.must_equal []
		have_conta.conta = [123]
		have_conta.conta.must_equal [123]
	end

	it "Deve ser possivel inicializar o objeto passando a conta como bloco" do
		result = HaveContaTest.new do |hav|
			hav.conta do |co|
				co.razao_social = 'Empresa banco'
				co.cpf_cnpj     = '074.554.663-87'
				co.agencia      = '456'
			end
		end
		result.conta.razao_social.must_equal 'Empresa banco'
		result.conta.cpf_cnpj.must_equal     '07455466387'
		result.conta.agencia.must_equal      '456'
	end

	it "Deve ser possivel editar a conta com um bloco" do
		subject.conta.razao_social = 'razao_1'
		subject.conta do |co|
			co.razao_social = 'razao_2'
			co.agencia      = '456'
		end
		subject.conta.razao_social.must_equal 'razao_2'
		subject.conta.agencia.must_equal '456'
	end

	it "Deve ser possivel inicializar o objeto passando a conta como hash" do
		result = HaveContaTest.new({
			conta: {
				razao_social:  'Empresa banco',
				cpf_cnpj:      '074.554.663-87',
				agencia:       '456',
			}
		})
		result.conta.razao_social.must_equal 'Empresa banco'
		result.conta.cpf_cnpj.must_equal '07455466387'
		result.conta.agencia.must_equal '456'
	end

	it "Deve ser possivel editar a conta com um hash" do
		subject.conta.cpf_cnpj     = '12345678901'
		subject.conta.razao_social = 'razao_1'
		subject.conta = {
			razao_social: 'razao_2',
			agencia:      '456',
		}
		subject.conta.razao_social.must_equal 'razao_2'
		subject.conta.agencia.must_equal '456'
		subject.conta.cpf_cnpj.must_equal '12345678901'
	end

	it "#conta_class deve ser implementada nas subclasses" do
		HaveContaTest.any_instance.unstub(:conta_class)
		assert_raises NotImplementedError do
			subject.conta_class
		end
	end

	it "por padrão nao deve validar nada" do
		wont_be_message_error(:base)
	end

	it 'Validação para conta_corrente' do
		subject.stubs(:conta_corrente_length).returns  (5)
		subject.stubs(:conta_corrente_minimum).returns (5)
		subject.stubs(:conta_corrente_maximum).returns (5)
		subject.stubs(:conta_corrente_required).returns(true)
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:conta_corrente)} #{get_message(:blank, {})}")
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:conta_corrente)} #{get_message(:custom_length_is,       {count: 5}) }")
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:conta_corrente)} #{get_message(:custom_length_minimum,  {count: 5}) }")
		subject.conta.conta_corrente = '123456'
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:conta_corrente)} #{get_message(:custom_length_maximum,  {count: 5}) }")
	end

	it 'Validação para modalidade' do
		subject.stubs(:valid_modalidade_length).returns      (5)
		subject.stubs(:valid_modalidade_minimum).returns     (5)
		subject.stubs(:valid_modalidade_maximum).returns     (5)
		subject.stubs(:valid_modalidade_required).returns    (true)
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:blank, {})}")
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:custom_length_is,       {count: 5}) }")
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:custom_length_minimum,  {count: 5}) }")
		subject.conta.modalidade = '123456'
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:custom_length_maximum,  {count: 5}) }")
		
		subject.stubs(:valid_modalidade_inclusion).returns(['50','60'])
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:custom_inclusion,  {list: '50, 60'}) }")

	end

	it 'Validação para codigo_cedente (convênio)' do
		subject.stubs(:codigo_cedente_length).returns  (5)
		subject.stubs(:codigo_cedente_minimum).returns (5)
		subject.stubs(:codigo_cedente_maximum).returns (5)
		subject.stubs(:codigo_cedente_required).returns(true)
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:blank, {})}")
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_is,       {count: 5}) }")
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_minimum,  {count: 5}) }")
		subject.conta.codigo_cedente = '123456'
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_maximum,  {count: 5}) }")
	end

	it 'Validação para endereco' do
		subject.stubs(:endereco_required).returns(true)
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:endereco)} #{get_message(:blank, {})}")
	end

	it 'Validação para carteira' do
		subject.stubs(:valid_carteira_length).returns        (5)
		subject.stubs(:carteira_minimum).returns       (5)
		subject.stubs(:carteira_maximum).returns       (5)
		subject.stubs(:carteira_required).returns      (true)
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:blank, {})}")
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:custom_length_is,       {count: 5}) }")
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:custom_length_minimum,  {count: 5}) }")
		subject.conta.carteira = '123456'
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:custom_length_maximum,  {count: 5}) }")

		subject.stubs(:carteira_inclusion).returns(['50','60'])
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:custom_inclusion,  {list: '50, 60'}) }")
	end

	it 'Validação para convenio' do
		subject.stubs(:convenio_length).returns        (5)
		subject.stubs(:convenio_minimum).returns       (5)
		subject.stubs(:convenio_maximum).returns       (5)
		subject.stubs(:convenio_required).returns      (true)
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:blank, {})}")
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_is,       {count: 5}) }")
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_minimum,  {count: 5}) }")
		subject.conta.convenio = '123456'
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_maximum,  {count: 5}) }")

		subject.stubs(:convenio_inclusion).returns(['50','60'])
		must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_inclusion,  {list: '50, 60'}) }")
	end


	context "o valor setado nas validações devem obedecer a classe que inclui a conta. Mesmo que a conta tenha uma validação diferente" do
		before do
			subject.conta.conta_corrente_length   = 2
			subject.conta.conta_corrente_minimum  = 3
			subject.conta.conta_corrente_maximum  = 4
			subject.conta.conta_corrente_required = false
			subject.conta.valid_modalidade_length       = 6
			subject.conta.valid_modalidade_minimum      = 7
			subject.conta.valid_modalidade_maximum      = 8
			subject.conta.valid_modalidade_required     = true
			subject.conta.endereco_required       = false
			subject.conta.valid_carteira_length         = 15
			subject.conta.carteira_minimum        = 16
			subject.conta.carteira_maximum        = 17
			subject.conta.carteira_required       = false
			subject.conta.convenio_length         = 19
			subject.conta.convenio_minimum        = 20
			subject.conta.convenio_maximum        = 21
			subject.conta.convenio_required       = false
			
			subject.conta.valid_modalidade_inclusion  = ['10','20']
			subject.conta.carteira_inclusion    = ['10','20']
			subject.conta.convenio_inclusion    = ['10','20']
		end

		context "Se os metodos do objeto que temm a conta tiverem valor nos seus metodos deve permanecer esses valores" do
			it '#conta_corrente' do
				subject.stubs(:conta_corrente_length).returns  (13)
				subject.stubs(:conta_corrente_minimum).returns (14)
				subject.stubs(:conta_corrente_maximum).returns (15)
				subject.stubs(:conta_corrente_required).returns(true)
				
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:conta_corrente)} #{get_message(:blank, {})}")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:conta_corrente)} #{get_message(:custom_length_is,       {count: 13}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:conta_corrente)} #{get_message(:custom_length_minimum,  {count: 14}) }")
				subject.conta.conta_corrente = '1'.rjust(16, '0')
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:conta_corrente)} #{get_message(:custom_length_maximum,  {count: 15}) }")
			end
			it '#modalidade' do
				subject.stubs(:valid_modalidade_length).returns      (16)
				subject.stubs(:valid_modalidade_minimum).returns     (17)
				subject.stubs(:valid_modalidade_maximum).returns     (18)
				subject.stubs(:valid_modalidade_required).returns    (false)				
				subject.stubs(:valid_modalidade_inclusion).returns  ['30','40']
				
				wont_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:blank, {})}")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:custom_length_is,       {count: 16}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:custom_length_minimum,  {count: 17}) }")
				subject.conta.modalidade = '1'.rjust(19, '0')
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:custom_length_maximum,  {count: 18}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:custom_inclusion, {list: '30, 40'}) }")
			end
			it '#codigo_cedente (convênio)' do
				subject.stubs(:codigo_cedente_length).returns  (19)
				subject.stubs(:codigo_cedente_minimum).returns (20)
				subject.stubs(:codigo_cedente_maximum).returns (21)
				subject.stubs(:codigo_cedente_required).returns(false)

				wont_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:blank, {})}")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_is,       {count: 19}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_minimum,  {count: 20}) }")
				subject.conta.codigo_cedente = '1'.rjust(22, '0')
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_maximum,  {count: 21}) }")
			end
			it '#endereco' do
				subject.stubs(:endereco_required).returns(true)
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:endereco)} #{get_message(:blank, {})}")
			end
			it '#carteira' do
				subject.stubs(:valid_carteira_length).returns        (22)
				subject.stubs(:carteira_minimum).returns       (23)
				subject.stubs(:carteira_maximum).returns       (24)
				subject.stubs(:carteira_required).returns      (true)
				subject.stubs(:carteira_inclusion).returns    ['30','40']
				
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:blank, {})}")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:custom_length_is,       {count: 22}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:custom_length_minimum,  {count: 23}) }")
				subject.conta.carteira = '1'.rjust(25, '0')
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:custom_length_maximum,  {count: 24}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:custom_inclusion,   {list: '30, 40'}) }")
			end
			it '#convenio' do
				subject.stubs(:convenio_length).returns        (25)
				subject.stubs(:convenio_minimum).returns       (26)
				subject.stubs(:convenio_maximum).returns       (27)
				subject.stubs(:convenio_required).returns      (true)
				subject.stubs(:convenio_inclusion).returns    ['30','40']
				
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:blank, {})}")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_is,       {count: 25}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_minimum,  {count: 26}) }")
				subject.conta.convenio = '1'.rjust(28, '0')
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_maximum,  {count: 27}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_inclusion,   {list: '30, 40'}) }")
			end
		end

		context "Deve considerar as validações setadas na conta se não houver os metodos sobrescritos no objeto que tem a conta" do
			it '#conta_corrente' do
				wont_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:conta_corrente)} #{get_message(:blank, {})}")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:conta_corrente)} #{get_message(:custom_length_is,       {count: 2}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:conta_corrente)} #{get_message(:custom_length_minimum,  {count: 3}) }")
				subject.conta.conta_corrente = '1'.rjust(16, '0')
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:conta_corrente)} #{get_message(:custom_length_maximum,  {count: 4}) }")
			end
			
			it '#modalidade' do
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:blank, {})}")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:custom_length_is,       {count: 6}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:custom_length_minimum,  {count: 7}) }")
				subject.conta.modalidade = '1'.rjust(19, '0')
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:custom_length_maximum,  {count: 8}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:modalidade)} #{get_message(:custom_inclusion, {list: '10, 20'}) }")
			end
			
			it '#codigo_cedente (convenio)' do
				subject.conta.codigo_cedente_length   = 10
				subject.conta.codigo_cedente_minimum  = 11
				subject.conta.codigo_cedente_maximum  = 12
				subject.conta.codigo_cedente_required = true

				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:blank, {})}")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_is,       {count: 10}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_minimum,  {count: 11}) }")
				subject.conta.codigo_cedente = '1'.rjust(22, '0')
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_maximum,  {count: 12}) }")
			end
			
			it '#endereco' do
				wont_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:endereco)} #{get_message(:blank, {})}")
			end
			
			it '#carteira' do
				wont_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:blank, {})}")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:custom_length_is,       {count: 15}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:custom_length_minimum,  {count: 16}) }")
				subject.conta.carteira = '1'.rjust(25, '0')
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:custom_length_maximum,  {count: 17}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:carteira)} #{get_message(:custom_inclusion,   {list: '10, 20'}) }")
			end
			
			it '#convenio' do
				wont_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:blank, {})}")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_is,       {count: 19}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_minimum,  {count: 20}) }")
				subject.conta.convenio = '1'.rjust(28, '0')
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_length_maximum,  {count: 21}) }")
				must_be_message_error(:base, "#{BrBoleto::Conta::Base.human_attribute_name(:convenio)} #{get_message(:custom_inclusion,   {list: '10, 20'}) }")
			end
			
		end
	end
end