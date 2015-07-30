# encoding: utf-8
require 'test_helper'

describe BrBoleto::Remessa::Pagamento do
	subject { FactoryGirl.build(:remessa_pagamento) }
	
	describe "validations" do
		it { must validate_presence_of(:nosso_numero) }
		it { must validate_presence_of(:data_vencimento) }
		it { must validate_presence_of(:valor_documento) }
		it { must validate_presence_of(:documento_sacado) }
		it { must validate_presence_of(:nome_sacado) }
		it { must validate_presence_of(:endereco_sacado) }
		it { must validate_presence_of(:cep_sacado) }
		it { must validate_presence_of(:cidade_sacado) }
		it { must validate_presence_of(:uf_sacado) }
		it { must validate_presence_of(:bairro_sacado) }
		
		it { must validate_length_of(:cep_sacado).is_equal_to(8).with_message("deve ter 8 dígitos.") }
		it { must validate_length_of(:cod_desconto).is_equal_to(1).with_message("deve ter 1 dígito.") }
	end

	context "default_values" do
		it "for data_emissao" do
			object = subject.class.new()
			object.data_emissao.must_equal Date.today
		end
		it "for valor_mora" do
			object = subject.class.new()
			object.valor_mora.must_equal 0.0
		end
		it "for valor_desconto" do
			object = subject.class.new()
			object.valor_desconto.must_equal 0.0
		end
		it "for valor_iof" do
			object = subject.class.new()
			object.valor_iof.must_equal 0.0
		end
		it "for valor_abatimento" do
			object = subject.class.new()
			object.valor_abatimento.must_equal 0.0
		end
		it "for nome_avalista" do
			object = subject.class.new()
			object.nome_avalista.must_equal ''
		end
		it "for cod_desconto" do
			object = subject.class.new()
			object.cod_desconto.must_equal '0'
		end
	end

	describe "#assign_attributes" do
		it "posso setar varios atributos" do
			subject.assign_attributes({cep_sacado: "NOVO", cidade_sacado: "Valor", uf_sacado: "OK"})
			subject.cep_sacado.must_equal 'NOVO'
			subject.cidade_sacado.must_equal 'Valor'
			subject.uf_sacado.must_equal 'OK'
		end
		it "nao deve sobrescrever os valores já setados com os valores padrões" do
			subject.cod_desconto = '9'
			subject.assign_attributes(valor_desconto: 500.88)
			subject.cod_desconto.must_equal '9'
			subject.valor_desconto.must_equal 500.88
		end
	end

	describe "initialize com bloco" do
		subject do 
			BrBoleto::Remessa::Pagamento.new do |bl|
				bl.nosso_numero = "999777"
				bl.valor_documento = 789.44
			end
		end
		it { subject.nosso_numero.must_equal '999777' }
		it { subject.valor_documento.must_equal 789.44 }
	end

	describe "#data_desconto_formatado" do
		it "quando data_desconto for nil" do
			subject.data_desconto = nil
			subject.data_desconto_formatado.must_equal '000000'
		end
		it "quando data_desconto for nil mas passar outro formato para a data" do
			subject.data_desconto = nil
			subject.data_desconto_formatado("%d%m%Y").must_equal '00000000'
		end
		it "deve formatar a data com padrão ddmmyy" do
			subject.data_desconto = Date.parse('30/12/2017')
			subject.data_desconto_formatado.must_equal '301217'
		end
		it "deve formatar a data com formato passado por parametro" do
			subject.data_desconto = Date.parse('30/12/2017')
			subject.data_desconto_formatado("%d%m%Y").must_equal '30122017'
		end
	end

	describe "#valor_documento_formatado" do
		context "com padrao de tamanho = 13 digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.valor_documento = 7856.888
				subject.valor_documento_formatado.must_equal "0000000785689"
			end
		end
		context "passando a quantidade de digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.valor_documento = 7856.888
				subject.valor_documento_formatado(10).must_equal "0000785689"
			end
		end
	end

	describe "#valor_mora_formatado" do
		context "com padrao de tamanho = 13 digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.valor_mora = 7856.123
				subject.valor_mora_formatado.must_equal "0000000785612"
			end
		end
		context "passando a quantidade de digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.valor_mora = 7856.123
				subject.valor_mora_formatado(10).must_equal "0000785612"
			end
		end
	end

	describe "#valor_desconto_formatado" do
		context "com padrao de tamanho = 13 digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.valor_desconto = 7856.123
				subject.valor_desconto_formatado.must_equal "0000000785612"
			end
		end
		context "passando a quantidade de digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.valor_desconto = 7856.123
				subject.valor_desconto_formatado(10).must_equal "0000785612"
			end
		end
	end

	describe "#valor_iof_formatado" do
		context "com padrao de tamanho = 13 digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.valor_iof = 7856.123
				subject.valor_iof_formatado.must_equal "0000000785612"
			end
		end
		context "passando a quantidade de digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.valor_iof = 7856.123
				subject.valor_iof_formatado(10).must_equal "0000785612"
			end
		end
	end

	describe "#valor_abatimento_formatado" do
		context "com padrao de tamanho = 13 digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.valor_abatimento = 7856.123
				subject.valor_abatimento_formatado.must_equal "0000000785612"
			end
		end
		context "passando a quantidade de digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.valor_abatimento = 7856.123
				subject.valor_abatimento_formatado(10).must_equal "0000785612"
			end
		end
	end

	describe "#tipo_documento_sacado" do
		it "quand documento_sacado for nil" do
			subject.documento_sacado = nil
			subject.tipo_documento_sacado.must_equal '0'
		end
		context "com padrao de tamanho = 2" do
			it "deve ser 02 (CPF) se for menor que 14 digitos e maior que 11" do
				subject.documento_sacado = '123456789012'
				subject.tipo_documento_sacado.must_equal '02'
			end
			it "deve ser 01 (CPF) se for igual a 11" do
				subject.documento_sacado = '12345678901'
				subject.tipo_documento_sacado.must_equal '01'
			end
			it "deve ser 01 (CPF) se for menor que 11" do
				subject.documento_sacado = '1234567890'
				subject.tipo_documento_sacado.must_equal '01'
			end
			it "deve ser 02 (CNPJ/CGC) se for igual a 14 digitos" do
				subject.documento_sacado = '12345678901234'
				subject.tipo_documento_sacado.must_equal '02'
			end
			it "deve ser 02 (CNPJ/CGC) se for maior a 14 digitos" do
				subject.documento_sacado = '123456789012345'
				subject.tipo_documento_sacado.must_equal '02'
			end
		end
		context "passando um tamanho por parâmetro" do
			it "deve ser 2 (CNPJ) se for menor que 14 digitos e maior que 11 com tamanho=1" do
				subject.documento_sacado = '1234567890123'
				subject.tipo_documento_sacado(1).must_equal '2'
			end
			it "deve ser 002 (CNPJ/CGC) se for igual a 14 digitos e tamanho = 3" do
				subject.documento_sacado = '12345678901234'
				subject.tipo_documento_sacado(3).must_equal '002'
			end
			it "deve ser 02 (CNPJ/CGC) se for maior a 14 digitos e tamanho = 2" do
				subject.documento_sacado = '123456789012345'
				subject.tipo_documento_sacado(2).must_equal '02'
			end
		end
	end

	describe "#tipo_documento_avalista" do
		it "quand documento_avalista for nil" do
			subject.documento_avalista = nil
			subject.tipo_documento_avalista.must_equal '0'
		end
		context "com padrao de tamanho = 2" do
			it "deve ser 02 (CNPJ) se for menor que 14 digitos e maior que 11" do
				subject.documento_avalista = '1234567890123'
				subject.tipo_documento_avalista.must_equal '02'
			end
			it "deve ser 01 (CPF) se for igual a 11" do
				subject.documento_avalista = '12345678901'
				subject.tipo_documento_avalista.must_equal '01'
			end
			it "deve ser 01 (CPF) se for menor que 11" do
				subject.documento_avalista = '1234567890'
				subject.tipo_documento_avalista.must_equal '01'
			end
			it "deve ser 02 (CNPJ/CGC) se for igual a 14 digitos" do
				subject.documento_avalista = '12345678901234'
				subject.tipo_documento_avalista.must_equal '02'
			end
			it "deve ser 02 (CNPJ/CGC) se for maior a 14 digitos" do
				subject.documento_avalista = '123456789012345'
				subject.tipo_documento_avalista.must_equal '02'
			end
		end
		context "passando um tamanho por parâmetro" do
			it "deve ser 2 (CNPJ) se for menor que 14 digitos e maior que 11 com tamanho=1" do
				subject.documento_avalista = '1234567890123'
				subject.tipo_documento_avalista(1).must_equal '2'
			end
			it "deve ser 002 (CNPJ/CGC) se for igual a 14 digitos e tamanho = 3" do
				subject.documento_avalista = '12345678901234'
				subject.tipo_documento_avalista(3).must_equal '002'
			end
			it "deve ser 02 (CNPJ/CGC) se for maior a 14 digitos e tamanho = 2" do
				subject.documento_avalista = '123456789012345'
				subject.tipo_documento_avalista(2).must_equal '02'
			end
		end
	end
end