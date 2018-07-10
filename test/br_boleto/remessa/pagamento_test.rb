# encoding: utf-8
require 'test_helper'

describe BrBoleto::Remessa::Pagamento do
	subject { FactoryBot.build(:remessa_pagamento) }

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

	describe "#percentual_multa" do
		it "Quando o codigo_multa for 1, então deve calcular o percentual de multa pois o valor_multa representa o valor em R$" do
			subject.assign_attributes(codigo_multa: '1', valor_multa: 7.47, valor_documento: 78.98)
			subject.percentual_multa.must_equal 9.458091

			subject.assign_attributes(codigo_multa: 1, valor_multa: 8.5, valor_documento: 90.0)
			subject.percentual_multa.must_equal 9.444444
		end

		it "Quando o codigo_multa for 2, então deve retornar o próprio valor que está em valor_multa, pois representa o valor em %" do
			subject.assign_attributes(codigo_multa: '2', valor_multa: 7.47, valor_documento: 78.98)
			subject.percentual_multa.must_equal 7.47

			subject.assign_attributes(codigo_multa: 2, valor_multa: 8.5, valor_documento: 90.0)
			subject.percentual_multa.must_equal 8.5
		end

		it "Quando o codigo_multa for 0 ou 3, então deve retornar zero, pois não tem multa" do
			subject.assign_attributes(codigo_multa: '0', valor_multa: 7.47, valor_documento: 78.98)
			subject.percentual_multa.must_equal 0

			subject.assign_attributes(codigo_multa: 3, valor_multa: 8.5, valor_documento: 90.0)
			subject.percentual_multa.must_equal 0
		end
	end

	describe "#valor_multa_monetario" do
		it "Quando o codigo_multa for 1, então deve retornar o próprio valor que está em valor_multa, pois representa o valor em R$" do
			subject.assign_attributes(codigo_multa: '1', valor_multa: 7.47, valor_documento: 78.98)
			subject.valor_multa_monetario.must_equal 7.47

			subject.assign_attributes(codigo_multa: 1, valor_multa: 8.5, valor_documento: 90.0)
			subject.valor_multa_monetario.must_equal 8.5
		end

		it "Quando o codigo_multa for 2, então deve calcular o valor de multa pois o valor_multa representa o valor em %" do
			subject.assign_attributes(codigo_multa: '2', valor_multa: 7.47, valor_documento: 78.98)
			subject.valor_multa_monetario.must_equal 5.8998

			subject.assign_attributes(codigo_multa: 2, valor_multa: 8.5, valor_documento: 90.0)
			subject.valor_multa_monetario.must_equal 7.65
		end

		it "Quando o codigo_multa for 0 ou 3, então deve retornar zero, pois não tem multa" do
			subject.assign_attributes(codigo_multa: '0', valor_multa: 7.47, valor_documento: 78.98)
			subject.valor_multa_monetario.must_equal 0

			subject.assign_attributes(codigo_multa: 3, valor_multa: 8.5, valor_documento: 90.0)
			subject.valor_multa_monetario.must_equal 0
		end
	end

	describe "#percentual_juros -> Deve retornar a taxa de juros mensal" do
		it "Quando o codigo_juros for 1, então deve calcular o percentual de juros pois o valor_juros representa o valor em R$" do
			subject.assign_attributes(codigo_juros: '1', valor_juros: 0.9, valor_documento: 78.98)
			subject.percentual_juros.must_equal 34.19

			subject.assign_attributes(codigo_juros: 1, valor_juros: 0.0153, valor_documento: 90.0)
			subject.percentual_juros.must_equal 0.51
		end

		it "Quando o codigo_juros for 2, então deve retornar o próprio valor que está em valor_juros, pois representa o valor em %" do
			subject.assign_attributes(codigo_juros: '2', valor_juros: 7.47, valor_documento: 78.98)
			subject.percentual_juros.must_equal 7.47

			subject.assign_attributes(codigo_juros: 2, valor_juros: 8.5, valor_documento: 90.0)
			subject.percentual_juros.must_equal 8.5
		end

		it "Quando o codigo_juros for 0 ou 3, então deve retornar zero, pois não tem juros" do
			subject.assign_attributes(codigo_juros: '0', valor_juros: 7.47, valor_documento: 78.98)
			subject.percentual_juros.must_equal 0

			subject.assign_attributes(codigo_juros: 3, valor_juros: 8.5, valor_documento: 90.0)
			subject.percentual_juros.must_equal 0
		end
	end

	describe "#valor_juros_monetario -> Deve retornar o valor do juros cobrado por dia" do
		it "Quando o codigo_juros for 1, então deve retornar o próprio valor que está em valor_juros, pois representa o valor em R$" do
			subject.assign_attributes(codigo_juros: '1', valor_juros: 1.0, valor_documento: 78.98)
			subject.valor_juros_monetario.must_equal 1.0

			subject.assign_attributes(codigo_juros: 1, valor_juros: 0.50, valor_documento: 90.0)
			subject.valor_juros_monetario.must_equal 0.50
		end

		it "Quando o codigo_juros for 2, então deve calcular o valor de juros por 30 dias pois o valor_juros representa o valor em %" do
			subject.assign_attributes(codigo_juros: '2', valor_juros: 7.47, valor_documento: 78.98)
			subject.valor_juros_monetario.must_equal 0.1967

			subject.assign_attributes(codigo_juros: 2, valor_juros: 8.5, valor_documento: 90.0)
			subject.valor_juros_monetario.must_equal 0.255
		end

		it "Quando o codigo_juros for 0 ou 3, então deve retornar zero, pois não tem juros" do
			subject.assign_attributes(codigo_juros: '0', valor_juros: 7.47, valor_documento: 78.98)
			subject.valor_juros_monetario.must_equal 0

			subject.assign_attributes(codigo_juros: 3, valor_juros: 8.5, valor_documento: 90.0)
			subject.valor_juros_monetario.must_equal 0
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

	describe '#nosso_numero' do
		it "deve retornar apenas numeros e letras" do
			subject.nosso_numero = 'A1!@#$%*()-234vc.,;-56789o0'
			subject.nosso_numero.must_equal 'A1234vc56789o0'
		end
		it "deve retornar corretamente o nosso_numero quando o DV é uma letra" do
			subject.nosso_numero = '001240002-P'
			subject.nosso_numero.must_equal '001240002P'
		end
	end


	describe "default_values" do
		let(:object) { subject.class.new() }
		it "for data_emissao"             do object.data_emissao.must_equal             Date.today end
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
	describe "#valor_multa_monetario_formatado" do
		context "com padrao de tamanho = 13 digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.stubs(:valor_multa_monetario).returns 7856.888
				subject.valor_multa_monetario_formatado.must_equal "0000000785689"
			end
		end
		context "passando a quantidade de digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.stubs(:valor_multa_monetario).returns 6.888
				subject.valor_multa_monetario_formatado(4).must_equal "0689"
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
	describe "#valor_juros_monetario_formatado" do
		context "com padrao de tamanho = 13 digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.stubs(:valor_juros_monetario).returns 7856.888
				subject.valor_juros_monetario_formatado.must_equal "0000000785689"
			end
		end
		context "passando a quantidade de digitos" do
			it "deve formatar o valor removendo separador de casas decimais e aredondando para 2 casas decimais" do
				subject.stubs(:valor_juros_monetario).returns 6.888
				subject.valor_juros_monetario_formatado(4).must_equal "0689"
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
			subject.stubs(:percentual_multa).returns(72.50)
			number
			BrBoleto::Helper::Number.expects(:new).with(72.50).returns(number)
			number.expects(:formata_valor_percentual).with(6).returns('123')
			subject.percentual_multa_formatado.must_equal '123000'
		end
		it "deve considerar o tamanho pelo parametro para formatar o valor" do
			subject.stubs(:percentual_multa).returns(4.0)
			number
			BrBoleto::Helper::Number.expects(:new).with(4.0).returns(number)
			number.expects(:formata_valor_percentual).with(3).returns('1234')
			subject.percentual_multa_formatado(3).must_equal '123'
		end
		it "deve gerar o valor corretamente - Teste sem MOCK" do
			subject.stubs(:percentual_multa).returns(2.87)
			subject.percentual_multa_formatado(5).must_equal '02870'
		end
	end
	describe '#percentual_juros_formatado' do
		let(:number) { BrBoleto::Helper::Number.new(5.47) }
		it "deve formatar o valor no formato de valores em percentual" do
			subject.stubs(:percentual_juros).returns(7.50)
			number
			BrBoleto::Helper::Number.expects(:new).with(7.50).returns(number)
			number.expects(:formata_valor_percentual).with(6).returns('123')
			subject.percentual_juros_formatado.must_equal '123000'
		end
		it "deve considerar o tamanho pelo parametro para formatar o valor" do
			subject.stubs(:percentual_juros).returns(9.87)
			number
			BrBoleto::Helper::Number.expects(:new).with(9.87).returns(number)
			number.expects(:formata_valor_percentual).with(3).returns('1234')
			subject.percentual_juros_formatado(3).must_equal '123'
		end
		it "deve gerar o valor corretamente - Teste sem MOCK" do
			subject.stubs(:percentual_juros).returns(12.438)
			subject.percentual_juros_formatado(7).must_equal '1243800'
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
