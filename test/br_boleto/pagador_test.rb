require 'test_helper'

describe BrBoleto::Pagador do
	subject { FactoryGirl.build(:pagador) } 

	describe "validations" do
		it { must validate_presence_of(:nome) }
		it { must validate_presence_of(:cpf_cnpj) }
		context "validação de presença do endereço" do
			context "por padrão não deve ser obrigatorio" do
				it { wont validate_presence_of(:endereco) } 
				it { wont validate_presence_of(:bairro) }
				it { wont validate_presence_of(:cep) } 
				it { wont validate_presence_of(:cidade) } 
				it { wont validate_presence_of(:uf) }
			end
			context "se setar o valid_endereco_required então valida a presença do endereço" do
				before { subject.valid_endereco_required = true }
				it { must validate_presence_of(:endereco) } 
				it { must validate_presence_of(:bairro) }
				it { must validate_presence_of(:cep) } 
				it { must validate_presence_of(:cidade) } 
				it { must validate_presence_of(:uf) }
			end
		end
		context "validação de presença do avalsita" do
			context "por padrão não deve ser obrigatorio" do
				it { wont validate_presence_of(:nome_avalista) } 
				it { wont validate_presence_of(:documento_avalista) }
				it { wont validate_presence_of(:endereco_avalista) }
			end
			context "se setar o valid_avalista_required então valida a presença do avalista" do
				before { subject.valid_avalista_required = true }
				it { must validate_presence_of(:nome_avalista) } 
				it { must validate_presence_of(:documento_avalista) }
			end
		end

	end

	it "cep deve retornar apenas numeros" do
		subject.cep = '89A885-3L69'
		subject.cep.must_equal '89885369'		
	end

	describe "#cpf_cnpj" do
		it "se setar o cnpj com a pontuação deve sempre retornar apenas os numeros" do
			subject.cpf_cnpj = '84.059.146/0001-00'
			subject.cpf_cnpj.must_equal '84059146000100'
		end
		it "se setar o CPF com a pontuação deve sempre retornar apenas os numeros" do
			subject.cpf_cnpj = '725.211.506-22'
			subject.cpf_cnpj.must_equal '72521150622'
		end
	end

	describe "#tipo_cpf_cnpj" do
		context "#CPF retorna 01" do
			it "por padrão deve retornar 01 (com 2 digitos)" do
				subject.cpf_cnpj = '725.211.506-22'
				subject.tipo_cpf_cnpj.must_equal '01'
			end
			it "posso passar a quantidade de digitos a retornar" do
				subject.cpf_cnpj = '83944180313'
				subject.tipo_cpf_cnpj(1).must_equal '1'
			end
		end
		context "#CNPJ retorna 02" do
			it "por padrão deve retornar 02 (com 2 digitos)" do
				subject.cpf_cnpj = '84059146000100'
				subject.tipo_cpf_cnpj.must_equal '02'
			end
			it "posso passar a quantidade de digitos a retornar" do
				subject.cpf_cnpj = '32.131.445/0001-05'
				subject.tipo_cpf_cnpj(1).must_equal '2'
			end
		end
	end

	describe "#cpf_cnpj_formatado" do
		it "deve retornar o cnpj com a pontuação correta" do
			subject.cpf_cnpj = '84059146000100'
			subject.cpf_cnpj_formatado.must_equal '84.059.146/0001-00'
		end
		it "deve retornar o CPF com a pontuação correta" do
			subject.cpf_cnpj = '72521150622'
			subject.cpf_cnpj_formatado.must_equal '725.211.506-22'
		end
	end

	describe "#cpf_cnpj_formatado_com_label" do
		it "deve retornar o cnpj com a pontuação correta e com o label CNPJ" do
			subject.cpf_cnpj = '84059146000100'
			subject.cpf_cnpj_formatado_com_label.must_equal 'CNPJ 84.059.146/0001-00'
		end
		it "deve retornar o CPF com a pontuação correta e com o label CPF" do
			subject.cpf_cnpj = '72521150622'
			subject.cpf_cnpj_formatado_com_label.must_equal 'CPF 725.211.506-22'
		end
	end

	describe "Avalista" do
		describe "#documento_avalista" do
			it "se setar o cnpj com a pontuação deve sempre retornar apenas os numeros" do
				subject.documento_avalista = '84.059.146/0001-00'
				subject.documento_avalista.must_equal '84059146000100'
			end
			it "se setar o CPF com a pontuação deve sempre retornar apenas os numeros" do
				subject.documento_avalista = '725.211.506-22'
				subject.documento_avalista.must_equal '72521150622'
			end		
		end
		
		describe "#tipo_documento_avalista" do
			context "#CPF retorna 01" do
				it "por padrão deve retornar 01 (com 2 digitos)" do
					subject.documento_avalista = '725.211.506-22'
					subject.tipo_documento_avalista.must_equal '01'
				end
				it "posso passar a quantidade de digitos a retornar" do
					subject.documento_avalista = '83944180313'
					subject.tipo_documento_avalista(1).must_equal '1'
				end
			end
			context "#CNPJ retorna 02" do
				it "por padrão deve retornar 02 (com 2 digitos)" do
					subject.documento_avalista = '84059146000100'
					subject.tipo_documento_avalista.must_equal '02'
				end
				it "posso passar a quantidade de digitos a retornar" do
					subject.documento_avalista = '32.131.445/0001-05'
					subject.tipo_documento_avalista(1).must_equal '2'
				end
			end
		end

		describe "#documento_avalista_formatado" do
			it "deve retornar o cnpj com a pontuação correta" do
				subject.documento_avalista = '84059146000100'
				subject.documento_avalista_formatado.must_equal '84.059.146/0001-00'
			end
			it "deve retornar o CPF com a pontuação correta" do
				subject.documento_avalista = '72521150622'
				subject.documento_avalista_formatado.must_equal '725.211.506-22'
			end
		end

		describe "#documento_avalista_formatado_com_label" do
			it "deve retornar o cnpj com a pontuação correta e com o label CNPJ" do
				subject.documento_avalista = '84059146000100'
				subject.documento_avalista_formatado_com_label.must_equal 'CNPJ 84.059.146/0001-00'
			end
			it "deve retornar o CPF com a pontuação correta e com o label CPF" do
				subject.documento_avalista = '72521150622'
				subject.documento_avalista_formatado_com_label.must_equal 'CPF 725.211.506-22'
			end
		end

		describe "#endereco_avalista" do
			it "deve retornar o endereço do avalista" do
				subject.endereco_avalista = 'RUA - BAIRRO - CEP - CIDADE-UF'
				subject.endereco_avalista.must_equal 'RUA - BAIRRO - CEP - CIDADE-UF'
			end
		end

	end

	describe '#endereco_formatado' do
		it "deve trazer todo o endereço se estiver completo" do
			subject.assign_attributes(endereco: 'RUA 45', bairro: 'BAIRRO', cep: '89885-000', cidade: 'São Carlos', uf: 'SC')
			subject.endereco_formatado.must_equal 'RUA 45 - BAIRRO - 89885-000 - São Carlos-SC'
		end
		it "Desconsidera os valores vazios" do
			subject.assign_attributes(endereco: 'RUA 45', bairro: '', cep: '', cidade: 'São Carlos', uf: 'SC')
			subject.endereco_formatado.must_equal 'RUA 45 - São Carlos-SC'
		end
	end
end