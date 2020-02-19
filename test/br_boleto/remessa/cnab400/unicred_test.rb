require 'test_helper'

describe BrBoleto::Remessa::Cnab400::Unicred do
	subject { FactoryGirl.build(:remessa_cnab400_unicred, pagamentos: pagamento, conta: conta) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento, pagador: pagador) }
	let(:conta)     { FactoryGirl.build(:conta_unicred) }
	let(:pagador)   { FactoryGirl.build(:pagador) }

	it "deve ter a class para a conta do unicred" do
		BrBoleto::Remessa::Cnab400::Unicred.new.conta_class.must_equal BrBoleto::Conta::Unicred
	end

	it "deve herdar de Cnab400::Bradesco" do
		subject.class.superclass.must_equal BrBoleto::Remessa::Cnab400::Base
	end

	describe '#informacoes_da_conta' do
		it "deve retornar com 20 caracteres" do
			subject.informacoes_da_conta(:header).size.must_equal 20
		end
		it "deve trazer as informações em suas posições quando o parametro for :header" do
			conta.codigo_empresa = 39321235
			result = subject.informacoes_da_conta(:header)

			result[0..20].must_equal  '00000000000039321235'  # Codigo Empresa
		end
		it "deve retornar com 36 caracteres" do
			subject.informacoes_da_conta(:detalhe).size.must_equal 36
		end
		it "deve trazer as informações em suas posições quando o parametro for :detalhe" do
			conta.agencia           = 1234
			conta.agencia_dv        = 1
			conta.conta_corrente    = 89755
			conta.conta_corrente_dv = 7
			conta.carteira          = 21
			result = subject.informacoes_da_conta(:detalhe)

			result[0..2].must_equal    '012'
			result[3].must_equal       '3'
			result[4..6].must_equal    '410'
			result[7..11].must_equal   '00000'
			result[12..18].must_equal  '0897557'
			result[19].must_equal      '0'
		end
	end

	describe '#complemento_registro' do
		it "deve retornar o sequencial da remessa com 12 posições e mais 277 brancos" do
			subject.sequencial_remessa = 4758

			subject.complemento_registro[0..6].must_equal '       '
			subject.complemento_registro[7..16].must_equal '0000004758'
			subject.complemento_registro[17..293].must_equal ''.rjust(277)

			subject.complemento_registro.size.must_equal 294
		end
	end

	describe '#detalhe_posicao_038_062' do
		it "deve ter o tamanho de 25 digitos" do
			subject.detalhe_posicao_038_062(pagamento).size.must_equal 25
		end
		it "deve conter numero de controle do participante nas posições corretas" do
			pagamento.expects(:numero_documento).returns('534423')
			result = subject.detalhe_posicao_038_062(pagamento)

			result[00..13].must_equal "534423        "
			result[14..24].must_equal ''.rjust(11, ' ')
			result.size.must_equal 25
		end
	end

	describe '#detalhe_posicao_063_108' do
		it "deve ter o tamanho de 46 digitos" do
			subject.detalhe_posicao_063_108(pagamento).size.must_equal 46
		end
		it "deve conter as informações nas posições corretas" do
			pagamento.assign_attributes(tipo_emissao: 2)
			result = subject.detalhe_posicao_063_108(pagamento)

			result[0..2].must_equal   '136'
			result[3..4].must_equal   '00'
			result[5..29].must_equal  ''.adjust_size_to(25)
			result[30..45].must_equal '03          10  '

			result.size.must_equal 46
		end
	end

	describe '#informacoes_do_pagamento' do
		it "deve ter o tamanho de 40 digitos" do
			subject.informacoes_do_pagamento(pagamento, 1).size.must_equal 40
		end
		it "deve conter as informações nas posições corretas" do
			conta.agencia    = 4587
			conta.agencia_dv = 45 # Vai retornar apenas o 4
			pagamento.data_vencimento = Date.parse('05/08/2029')
			pagamento.valor_documento = 47.56
			pagamento.especie_titulo  = "12"
			pagamento.aceite = true
			pagamento.data_emissao = Date.parse('15/09/2017')
			result = subject.informacoes_do_pagamento(pagamento, 4)
			result.size.must_equal 40

			result[00..05].must_equal '050829'
			result[06..18].must_equal '0000000004756'
			result[19..21].must_equal '   '
			result[22..26].must_equal "00000"
			result[27..28].must_equal "00"
			result[  29  ].must_equal "0"
			result[30..35].must_equal '150917'
			result[36..37].must_equal '00'
			result[38..39].must_equal '00'
		end
	end

	describe '#informacoes_do_sacado' do
		it "deve ter o tamanho de 176 digitos" do
			subject.informacoes_do_sacado(pagamento, 2).size.must_equal 176
		end
		it "deve conter as informações nas posições corretas" do
			# pagador.tipo_cpf_cnpj =  '1'
			pagador.cpf_cnpj           =  '12345678901'
			pagador.nome               =  'nome pagador'
			pagador.endereco           =  'rua do pagador'
			pagador.cep                =  '89885-001'
			pagador.nome_avalista      =  'Avalista'
			pagador.documento_avalista =  '840.106.990-43'

			result = subject.informacoes_do_sacado(pagamento, 2)
			result.size.must_equal 176

			result[00..01].must_equal "01"                                # Tipo de Inscrição do Pagador: "01" = CPF / "02" = CNPJ
			result[02..15].must_equal '00012345678901'                    # Número do CNPJ ou CPF do Pagador
			result[16..55].must_equal 'nome pagador'.adjust_size_to(40)   # Nome do Pagador
			result[56..95].must_equal 'rua do pagador'.adjust_size_to(40) # Endereço do Pagador
			result[108..115].must_equal '89885001'                        # CEP do Pagador
			result[116..135].must_equal 'Chapecó'.adjust_size_to(20)       # CIDADE
			result[136..137].must_equal 'SC'                  # UF
			result[138..175].must_equal ''.adjust_size_to(38)         # Observações/Mensagem ou Sacador/Avalista
		end
	end
end
