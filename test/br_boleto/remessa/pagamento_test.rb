# encoding: utf-8
require 'test_helper'

describe BrBoleto::Remessa::Pagamento do
	
	class Shoulda::Matchers::ActiveModel::ValidateLengthOfMatcher
		# Sobrescrevo o método que gera a string para validar o tamanho
		# Pois o CEP só aceita números
		def string_of_length(length)
			'8' * length
		end
	end

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
		it { must validate_presence_of(:tipo_impressao) }
		
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
		it "for tipo_impressao" do
			object = subject.class.new()
			object.tipo_impressao.must_equal '1'
		end
		it "for desconto_2_codigo" do
			object = subject.class.new()
			object.desconto_2_codigo.must_equal  '0'
		end
		it "for desconto_2_valor" do
			object = subject.class.new()
			object.desconto_2_valor.must_equal  0.0
		end
		it "for desconto_3_codigo" do
			object = subject.class.new()
			object.desconto_3_codigo.must_equal  '0'
		end
		it "for desconto_3_valor" do
			object = subject.class.new()
			object.desconto_3_valor.must_equal  0.0
		end
		it "for codigo_multa" do
			object = subject.class.new()
			object.codigo_multa.must_equal  '0'
		end
		it "for valor_multa" do
			object = subject.class.new()
			object.valor_multa.must_equal  0.0
		end

	end

	describe "#assign_attributes" do
		it "posso setar varios atributos" do
			subject.assign_attributes({cep_sacado: "89809-360", cidade_sacado: "Valor", uf_sacado: "OK"})
			subject.cep_sacado.must_equal '89809360'
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

	describe "#formata_data" do
		it "quando passar um valor nil" do
			subject.send(:formata_data, nil).must_equal '00000000'
		end
		it "quando passar um valor nil mas passar outro formato para a data" do
			subject.send(:formata_data, nil, "%d%m%y").must_equal '000000'
		end
		it "deve formatar a data com padrão ddmmyyyy" do
			subject.send(:formata_data, Date.parse('30/12/2017')).must_equal '30122017'
		end
		it "deve formatar a data com formato passado por parametro" do
			subject.send(:formata_data, Date.parse('30/12/2017'), "%d%m%y").must_equal '301217'
		end
	end

	describe "#data_desconto_formatado" do
		it "deve chamar o metodo formata_data com padrão de formato %d%m%y" do
			subject.data_desconto = Date.today
			subject.expects(:formata_data).with(Date.today, "%d%m%y").returns("123456")
			subject.data_desconto_formatado.must_equal '123456'
		end
		it "deve chamar o metodo formata_data com o parametro passado" do
			subject.data_desconto = Date.today
			subject.expects(:formata_data).with(Date.today, "%d%m%Y").returns("123456")
			subject.data_desconto_formatado("%d%m%Y").must_equal '123456'
		end
	end

	describe "#desconto_2_data_formatado" do
		it "deve chamar o metodo formata_data com padrão de formato %d%m%y" do
			subject.desconto_2_data = Date.today
			subject.expects(:formata_data).with(Date.today, "%d%m%y").returns("123456")
			subject.desconto_2_data_formatado.must_equal '123456'
		end
		it "deve chamar o metodo formata_data com o parametro passado" do
			subject.desconto_2_data = Date.today
			subject.expects(:formata_data).with(Date.today, "%d%m%Y").returns("123456")
			subject.desconto_2_data_formatado("%d%m%Y").must_equal '123456'
		end
	end

	describe "#desconto_3_data_formatado" do
		it "deve chamar o metodo formata_data com padrão de formato %d%m%y" do
			subject.desconto_3_data = Date.today
			subject.expects(:formata_data).with(Date.today, "%d%m%y").returns("123456")
			subject.desconto_3_data_formatado.must_equal '123456'
		end
		it "deve chamar o metodo formata_data com o parametro passado" do
			subject.desconto_3_data = Date.today
			subject.expects(:formata_data).with(Date.today, "%d%m%Y").returns("123456")
			subject.desconto_3_data_formatado("%d%m%Y").must_equal '123456'
		end
	end

	describe "#data_multa_formatado" do
		it "deve chamar o metodo formata_data com padrão de formato %d%m%y" do
			subject.data_multa = Date.today
			subject.expects(:formata_data).with(Date.today, "%d%m%y").returns("123456")
			subject.data_multa_formatado.must_equal '123456'
		end
		it "deve chamar o metodo formata_data com o parametro passado" do
			subject.data_multa = Date.today
			subject.expects(:formata_data).with(Date.today, "%d%m%Y").returns("123456")
			subject.data_multa_formatado("%d%m%Y").must_equal '123456'
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