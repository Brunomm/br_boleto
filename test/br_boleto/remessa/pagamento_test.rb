# encoding: utf-8
require 'test_helper'

describe BrBoleto::Remessa::Pagamento do
	subject { FactoryGirl.build(:remessa_pagamento) }

	it "deve conter o mdule HavePagador" do
		subject.class.included_modules.must_include BrBoleto::HavePagador
	end
	
	
	describe "validations" do
		it { must validate_presence_of(:nosso_numero) }
		it { must validate_presence_of(:data_vencimento) }
		it { must validate_presence_of(:valor_documento) }
		
		describe '#tipo_impressao' do
			it { wont validate_presence_of(:tipo_impressao) }

			it "se valid_tipo_impressao_required for true deve validar a obrigatoriedade do tipo de tipo_impressao" do
				subject.valid_tipo_impressao_required = true
				must validate_presence_of(:tipo_impressao)
			end
			
		end
		
		describe '#cod_desconto' do
			before { subject.cod_desconto = '555' }

			it { wont_be_message_error(:cod_desconto) }
			it "se valid_cod_desconto_length tiver valor validar a partir do valor setado" do
				subject.valid_cod_desconto_length = 2
				must_be_message_error(:cod_desconto, :custom_length_is, {count: 2})
			end
		end

		describe '#emissao_boleto' do
			before { subject.emissao_boleto = '555' }

			it { wont_be_message_error(:emissao_boleto) }
			it "se valid_emissao_boleto_length tiver valor validar a partir do valor setado" do
				subject.valid_emissao_boleto_length = 2
				must_be_message_error(:emissao_boleto, :custom_length_is, {count: 2})
			end
		end

		describe '#distribuicao_boleto' do
			before { subject.distribuicao_boleto = '555' }

			it { wont_be_message_error(:distribuicao_boleto) }
			it "se valid_distribuicao_boleto_length tiver valor validar a partir do valor setado" do
				subject.valid_distribuicao_boleto_length = 2
				must_be_message_error(:distribuicao_boleto, :custom_length_is, {count: 2})
			end
		end
	end

	describe '#moeda_real?' do
		it "se a moeda for 9 então deve retornar true" do
			subject.codigo_moeda = 9
			subject.moeda_real?.must_equal true
		end
		it "se a moeda for diferente de 9 então deve retornar false" do
			subject.codigo_moeda = 8
			subject.moeda_real?.must_equal false
		end
	end

	it "se o codigo_moeda não tiver valor setado deve assumir '9'" do
		subject.codigo_moeda = 10
		subject.codigo_moeda.must_equal 10
		subject.codigo_moeda = nil
		subject.codigo_moeda.must_equal '9'
	end

	it "se não for setado uma parcela deve assumir 1" do
		subject.parcela = 10
		subject.parcela.must_equal 10
		subject.parcela = nil
		subject.parcela.must_equal '1'
	end

	it "nosso_numero deve retornar apenas numeros" do
		subject.nosso_numero = 'A1!@#$%*()-234vc.,;-56789o0'
		subject.nosso_numero.must_equal '1234567890'
	end

	describe "default_values" do
		let(:object) { subject.class.new() } 
		it "for data_emissao"             do object.data_emissao.must_equal             Date.today end
		it "for valor_mora"               do object.valor_mora.must_equal               0.0 end
		it "for valor_desconto"           do object.valor_desconto.must_equal           0.0 end
		it "for valor_iof"                do object.valor_iof.must_equal                0.0 end
		it "for valor_abatimento"         do object.valor_abatimento.must_equal         0.0 end
		it "for cod_desconto"             do object.cod_desconto.must_equal             '0' end
		it "for desconto_2_codigo"        do object.desconto_2_codigo.must_equal        '0' end
		it "for desconto_2_valor"         do object.desconto_2_valor.must_equal         0.0 end
		it "for desconto_3_codigo"        do object.desconto_3_codigo.must_equal        '0' end
		it "for desconto_3_valor"         do object.desconto_3_valor.must_equal         0.0 end
		it "for codigo_multa"             do object.codigo_multa.must_equal             '3' end
		it "for codigo_juros"             do object.codigo_juros.must_equal             '3' end
		it "for valor_multa"              do object.valor_multa.must_equal              0.0 end
		it "for valor_juros"              do object.valor_juros.must_equal              0.0 end
		it "for percentual_multa"         do object.percentual_multa.must_equal         0.0 end
		it "for percentual_juros"         do object.percentual_juros.must_equal         0.0 end
		it "for parcela"                  do object.parcela.must_equal                  '1' end
		it "for tipo_impressao"           do object.tipo_impressao.must_equal           '1' end
		it "for tipo_emissao"             do object.tipo_emissao.must_equal             '2' end
		it "for identificacao_ocorrencia" do object.identificacao_ocorrencia.must_equal '01' end
		it "for especie_titulo"           do object.especie_titulo.must_equal           '01' end
		it "for codigo_moeda"             do object.codigo_moeda.must_equal             '9' end
		it "for forma_cadastramento"      do object.forma_cadastramento.must_equal      '0' end
		it "for emissao_boleto"           do object.emissao_boleto.must_equal           '2' end
		it "for distribuicao_boleto"      do object.distribuicao_boleto.must_equal      '2' end
	end

	describe "#data_vencimento_formatado" do
		it "deve chamar o metodo formata_data com padrão de formato %d%m%Y" do
			subject.data_vencimento = Date.current
			subject.expects(:formata_data).with(Date.current, "%d%m%Y").returns("123456")
			subject.data_vencimento_formatado.must_equal '123456'
		end
		it "deve chamar o metodo formata_data com o parametro passado" do
			subject.data_vencimento = Date.current
			subject.expects(:formata_data).with(Date.current, "%d%m%y").returns("123456")
			subject.data_vencimento_formatado("%d%m%y").must_equal '123456'
		end
	end

	describe "#data_emissao_formatado" do
		it "deve chamar o metodo formata_data com padrão de formato %d%m%Y" do
			subject.data_emissao = Date.current
			subject.expects(:formata_data).with(Date.current, "%d%m%Y").returns("123456")
			subject.data_emissao_formatado.must_equal '123456'
		end
		it "deve chamar o metodo formata_data com o parametro passado" do
			subject.data_emissao = Date.current
			subject.expects(:formata_data).with(Date.current, "%d%m%y").returns("123456")
			subject.data_emissao_formatado("%d%m%y").must_equal '123456'
		end
	end

	describe "#data_desconto_formatado" do
		it "deve chamar o metodo formata_data com padrão de formato %d%m%Y" do
			subject.data_desconto = Date.current
			subject.expects(:formata_data).with(Date.current, "%d%m%Y").returns("123456")
			subject.data_desconto_formatado.must_equal '123456'
		end
		it "deve chamar o metodo formata_data com o parametro passado" do
			subject.data_desconto = Date.current
			subject.expects(:formata_data).with(Date.current, "%d%m%y").returns("123456")
			subject.data_desconto_formatado("%d%m%y").must_equal '123456'
		end
	end

	describe "#desconto_2_data_formatado" do
		it "deve chamar o metodo formata_data com padrão de formato %d%m%Y" do
			subject.desconto_2_data = Date.current
			subject.expects(:formata_data).with(Date.current, "%d%m%Y").returns("123456")
			subject.desconto_2_data_formatado.must_equal '123456'
		end
		it "deve chamar o metodo formata_data com o parametro passado" do
			subject.desconto_2_data = Date.current
			subject.expects(:formata_data).with(Date.current, "%d%m%y").returns("123456")
			subject.desconto_2_data_formatado("%d%m%y").must_equal '123456'
		end
	end

	describe "#desconto_3_data_formatado" do
		it "deve chamar o metodo formata_data com padrão de formato %d%m%Y" do
			subject.desconto_3_data = Date.current
			subject.expects(:formata_data).with(Date.current, "%d%m%Y").returns("123456")
			subject.desconto_3_data_formatado.must_equal '123456'
		end
		it "deve chamar o metodo formata_data com o parametro passado" do
			subject.desconto_3_data = Date.current
			subject.expects(:formata_data).with(Date.current, "%d%m%y").returns("123456")
			subject.desconto_3_data_formatado("%d%m%y").must_equal '123456'
		end
	end

	describe "#data_multa_formatado" do
		it "deve chamar o metodo formata_data com padrão de formato %d%m%Y" do
			subject.data_multa = Date.current
			subject.expects(:formata_data).with(Date.current, "%d%m%Y").returns("12345678")
			subject.data_multa_formatado.must_equal '12345678'
		end
		it "deve chamar o metodo formata_data com o parametro passado" do
			subject.data_multa = Date.current
			subject.expects(:formata_data).with(Date.current, "%d%m%y").returns("123456")
			subject.data_multa_formatado("%d%m%y").must_equal '123456'
		end
	end
	describe "#valor_multa_formatado" do
		context "com padrao de tamanho = 13 digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.valor_multa = 7856.888
				subject.valor_multa_formatado.must_equal "0000000785689"
			end
		end
		context "passando a quantidade de digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.valor_multa = 7856.888
				subject.valor_multa_formatado(10).must_equal "0000785689"
			end
		end
	end

	describe "#data_juros_formatado" do
		it "deve chamar o metodo formata_data com padrão de formato %d%m%Y" do
			subject.data_juros = Date.current
			subject.expects(:formata_data).with(Date.current, "%d%m%Y").returns("12345678")
			subject.data_juros_formatado.must_equal '12345678'
		end
		it "deve chamar o metodo formata_data com o parametro passado" do
			subject.data_juros = Date.current
			subject.expects(:formata_data).with(Date.current, "%d%m%y").returns("123456")
			subject.data_juros_formatado("%d%m%y").must_equal '123456'
		end
	end
	describe "#valor_juros_formatado" do
		context "com padrao de tamanho = 13 digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.valor_juros = 7856.888
				subject.valor_juros_formatado.must_equal "0000000785689"
			end
		end
		context "passando a quantidade de digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.valor_juros = 7856.888
				subject.valor_juros_formatado(10).must_equal "0000785689"
			end
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

	describe '#percentual_multa_formatado' do
		let(:number) { BrBoleto::Helper::Number.new(5.47) } 
		it "deve formatar o valor no formato de valores em percentual" do
			number
			BrBoleto::Helper::Number.expects(:new).with(subject.percentual_multa).returns(number)
			number.expects(:formata_valor_percentual).with(6).returns('123')
			subject.percentual_multa_formatado.must_equal '123000'
		end
		it "deve considerar o tamanho pelo parametro para formatar o valor" do
			number
			BrBoleto::Helper::Number.expects(:new).with(subject.percentual_multa).returns(number)
			number.expects(:formata_valor_percentual).with(3).returns('1234')
			subject.percentual_multa_formatado(3).must_equal '123'
		end
	end
	describe '#percentual_juros_formatado' do
		let(:number) { BrBoleto::Helper::Number.new(5.47) } 
		it "deve formatar o valor no formato de valores em percentual" do
			number
			BrBoleto::Helper::Number.expects(:new).with(subject.percentual_juros).returns(number)
			number.expects(:formata_valor_percentual).with(6).returns('123')
			subject.percentual_juros_formatado.must_equal '123000'
		end
		it "deve considerar o tamanho pelo parametro para formatar o valor" do
			number
			BrBoleto::Helper::Number.expects(:new).with(subject.percentual_juros).returns(number)
			number.expects(:formata_valor_percentual).with(3).returns('1234')
			subject.percentual_juros_formatado(3).must_equal '123'
		end
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
end