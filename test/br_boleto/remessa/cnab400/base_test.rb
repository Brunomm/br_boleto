require 'test_helper'

describe BrBoleto::Remessa::Cnab400::Base do
	subject { FactoryGirl.build(:remessa_cnab400_base, pagamentos: pagamento, conta: conta) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento) }
	let(:conta)     { FactoryGirl.build(:conta_sicoob) }
	let(:sequence_1) { sequence('sequence_1') }

	before do
		BrBoleto::Remessa::Cnab400::Base.any_instance.stubs(:conta_class).returns(conta.class)
	end

	it "deve ter incluso o module de pagamentos" do
		subject.class.must_include BrBoleto::HavePagamentos
	end

	context "métodos que devem ser implementados nas subclasses" do
		it '#informacoes_da_conta' do # (local)
			assert_raises NotImplementedError do
				subject.informacoes_da_conta(:any)
			end
		end

		it '#complemento_registro' do
			assert_raises NotImplementedError do
				subject.complemento_registro
			end
		end

		it '#dados_do_pagamento' do
			assert_raises NotImplementedError do
				subject.dados_do_pagamento(pagamento)
			end
		end

		it '#informacoes_do_pagamento' do # (pagamento, sequencial)
			assert_raises NotImplementedError do
				subject.informacoes_do_pagamento(pagamento, 3)
			end
		end

		it '#detalhe_multas_e_juros_do_pagamento' do # (pagamento, sequencial)
			assert_raises NotImplementedError do
				subject.detalhe_multas_e_juros_do_pagamento(pagamento, 4)
			end
		end

		it '#informacoes_do_sacado' do # (pagamento, sequencial)
			assert_raises NotImplementedError do
				subject.informacoes_do_sacado(pagamento, 5)
			end
		end
	end

	describe '#informacoes_do_banco' do
		it "deve trazer o código e nome do banco - não deixando passar de 18 caracteres" do
			conta.expects(:codigo_banco).returns('789')
			conta.expects(:nome_banco).returns('NOME DO BANCO COM 31 CARACTERES')
			subject.informacoes_do_banco.must_equal '789NOME DO BANCO C'
		end
		it "deve trazer o código e nome do banco - sempre retornando com 18 caracteres" do
			conta.expects(:codigo_banco).returns('789')
			conta.expects(:nome_banco).returns('NOMEBANCO')
			subject.informacoes_do_banco.must_equal '789NOMEBANCO      '
		end
	end


	describe '#Header' do
		it '#monta_header deve chamar os metodos para montar o header' do
			subject.expects(:header_posicao_001_a_001).in_sequence(sequence_1).returns('001_a_001-')
			subject.expects(:header_posicao_002_a_002).in_sequence(sequence_1).returns('002_b_002-')
			subject.expects(:header_posicao_003_a_009).in_sequence(sequence_1).returns('003_c_009-')
			subject.expects(:header_posicao_010_a_011).in_sequence(sequence_1).returns('010_d_011-')
			subject.expects(:header_posicao_012_a_026).in_sequence(sequence_1).returns('012_e_026-')
			subject.expects(:header_posicao_027_a_046).in_sequence(sequence_1).returns('027_f_046-')
			subject.expects(:header_posicao_047_a_076).in_sequence(sequence_1).returns('047_g_076-')
			subject.expects(:header_posicao_077_a_094).in_sequence(sequence_1).returns('077_h_094-')
			subject.expects(:header_posicao_095_a_100).in_sequence(sequence_1).returns('095_i_100-')
			subject.expects(:header_posicao_101_a_394).in_sequence(sequence_1).returns('101_j_394-')
			subject.expects(:header_posicao_395_a_400).in_sequence(sequence_1).returns('395_k_400-')

			subject.monta_header.must_equal '001_A_001-002_B_002-003_C_009-010_D_011-012_E_026-027_F_046-047_G_076-077_H_094-095_I_100-101_J_394-395_K_400-'
		end
		it "#header_posicao_001_a_001 - deve retornar o valor '0'" do
			subject.header_posicao_001_a_001.must_equal '0'
		end

		it "#header_posicao_002_a_002 - deve retornar o valor '0'" do
			subject.header_posicao_002_a_002.must_equal '0'
		end

		it "#header_posicao_003_a_009 - deve retornar o valor 'REMESSA'" do
			subject.header_posicao_003_a_009.must_equal 'REMESSA'
		end

		it "#header_posicao_010_a_011 - deve retornar o valor '01'" do
			subject.header_posicao_010_a_011.must_equal '01'
		end

		it "#header_posicao_012_a_026 - deve retornar o valor 'COBRANÇA' ajustado com 15 posições" do
			subject.header_posicao_012_a_026.must_equal 'COBRANÇA'.ljust(15, ' ')
		end

		it "#header_posicao_027_a_046 - deve retornar o valor informacoes_da_conta com :header por parametro" do
			subject.expects(:informacoes_da_conta).with(:header).returns('informacoes_da_conta')
			subject.header_posicao_027_a_046.must_equal 'informacoes_da_conta'
		end

		it "#header_posicao_047_a_076 - deve retornar o valor a razao_social da conta ajustado apra 30 posições" do
			conta.expects(:razao_social).returns('tem razão')
			subject.header_posicao_047_a_076.must_equal "tem razão".ljust(30, ' ')
		end

		it "#header_posicao_077_a_094 - deve retornar o valor informacoes_do_banco" do
			subject.expects(:informacoes_do_banco).returns('informacoes_do_banco')
			subject.header_posicao_077_a_094.must_equal 'informacoes_do_banco'
		end

		it "#header_posicao_095_a_100 - deve retornar o valor data_geracao('%d%m%y')" do
			subject.expects(:data_geracao).with('%d%m%y').returns('010916')
			subject.header_posicao_095_a_100.must_equal ('010916')
		end

		it "#header_posicao_101_a_394 - deve retornar o valor complemento_registro" do
			subject.expects(:complemento_registro).returns('complemento_registro')
			subject.header_posicao_101_a_394.must_equal 'complemento_registro'
		end

		it "#header_posicao_395_a_400 - deve retornar o valor '000001'" do
			subject.header_posicao_395_a_400.must_equal '000001'
		end
	end

	describe '#Detalhe' do
		it "#monta_detalhe - deve montar as 400 posições do com as informações do pagamento" do
			subject.expects(:detalhe_posicao_001_001).returns('001_001 a-').in_sequence(sequence_1)
			subject.expects(:detalhe_posicao_002_003).returns('002_003 b-').in_sequence(sequence_1)
			subject.expects(:detalhe_posicao_004_017).returns('004_017 c-').in_sequence(sequence_1).with(pagamento, 4)
			subject.expects(:detalhe_posicao_018_037).returns('018_037 d-').in_sequence(sequence_1).with(pagamento, 4)
			subject.expects(:detalhe_posicao_038_062).returns('038_062 e-').in_sequence(sequence_1)
			subject.expects(:detalhe_posicao_063_076).returns('063_076 f-').in_sequence(sequence_1).with(pagamento, 4)
			subject.expects(:detalhe_posicao_077_108).returns('077_108 g-').in_sequence(sequence_1).with(pagamento, 4)
			subject.expects(:detalhe_posicao_109_110).returns('109_110 h-').in_sequence(sequence_1).with(pagamento, 4)
			subject.expects(:detalhe_posicao_111_120).returns('111_120 i-').in_sequence(sequence_1).with(pagamento, 4)
			subject.expects(:detalhe_posicao_121_160).returns('121_160 j-').in_sequence(sequence_1).with(pagamento, 4)
			subject.expects(:detalhe_posicao_161_218).returns('161_218 k-').in_sequence(sequence_1).with(pagamento, 4)
			subject.expects(:detalhe_posicao_219_394).returns('219_394 l-').in_sequence(sequence_1).with(pagamento, 4)
			subject.expects(:detalhe_posicao_395_400).returns('395_400 m' ).in_sequence(sequence_1).with(pagamento, 4)
			subject.monta_detalhe(pagamento, 4).must_equal('001_001 A-002_003 B-004_017 C-018_037 D-038_062 E-063_076 F-077_108 G-109_110 H-111_120 I-121_160 J-161_218 K-219_394 L-395_400 M')
		end
		it '#detalhe_posicao_001_001 - deve retornar 1' do
			# '1'
			subject.detalhe_posicao_001_001.must_equal '1'
		end

		it '#detalhe_posicao_002_003 - deve retornar o tipo do cnpj da conta' do
			conta.expects(:tipo_cpf_cnpj).returns('5')
			subject.detalhe_posicao_002_003(pagamento).must_equal '5'
		end

		it '#detalhe_posicao_004_017 - deve retornar o cnpj da conta ajustado para 14 digitos' do
			conta.expects(:cpf_cnpj).returns('1234567890')
			subject.detalhe_posicao_004_017(pagamento, 3).must_equal '00001234567890'
		end

		it '#detalhe_posicao_018_037 - deve retornar as informações da conta' do
			subject.expects(:informacoes_da_conta).with(:detalhe).returns('informacoes_da_conta')
			subject.detalhe_posicao_018_037(pagamento, 5).must_equal 'informacoes_da_conta'

		end

		it '#detalhe_posicao_038_062 - deve retornar 25 caracteres vazios' do
			subject.detalhe_posicao_038_062(pagamento).must_equal ''.rjust(25, ' ')

		end

		it '#detalhe_posicao_063_076 - devre retornar os dados do pagamento' do
			subject.expects(:dados_do_pagamento).with(pagamento).returns('dados_do_pagamento')
			subject.detalhe_posicao_063_076(pagamento, 1).must_equal 'dados_do_pagamento'

		end

		it '#detalhe_posicao_077_108 - deve retornar um erro para sobrescrever o metodo' do # (pagamento, sequencial)
			assert_raises NotImplementedError do
				subject.detalhe_posicao_077_108(pagamento, 1)
			end
		end

		it '#detalhe_posicao_109_110 - deve retornar a identificacao da ocorrencia ajustando o tamanho para 2' do # (pagamento, sequencial)
			pagamento.expects(:identificacao_ocorrencia).returns('5')
			subject.detalhe_posicao_109_110(pagamento, 1).must_equal '05'
		end

		it '#detalhe_posicao_111_120 - deve retornar o numero do documento do pagamento' do # (pagamento, sequencial)
			pagamento.expects(:numero_documento).returns('15554')
			subject.detalhe_posicao_111_120(pagamento, 1).must_equal '0000015554'
		end

		it '#detalhe_posicao_121_160 - deve retornar as informações do pagamento' do # (pagamento, sequencial)
			subject.expects(:informacoes_do_pagamento).with(pagamento, 78).returns('informacoes_do_pagamento')
			subject.detalhe_posicao_121_160(pagamento, 78).must_equal 'informacoes_do_pagamento'
		end

		it '#detalhe_posicao_161_218 - deve retornar os detalhes de juros e multa do pagamento' do # (pagamento, sequencial)
			subject.expects(:detalhe_multas_e_juros_do_pagamento).with(pagamento, 78).returns('detalhe_multas_e_juros_do_pagamento')
			subject.detalhe_posicao_161_218(pagamento, 78).must_equal 'detalhe_multas_e_juros_do_pagamento'
		end

		it '#detalhe_posicao_219_394 - deve retornar as informações do sacado' do # (pagamento, sequencial)
			subject.expects(:informacoes_do_sacado).with(pagamento, 78).returns('informacoes_do_sacado')
			subject.detalhe_posicao_219_394(pagamento, 78).must_equal 'informacoes_do_sacado'
		end

		it '#detalhe_posicao_395_400 - deve retornar o sequencial do arquivo com 6 posições' do # (pagamento, sequencial)
			subject.detalhe_posicao_395_400(pagamento, 78).must_equal '000078'
		end
	end

	describe '#Trailer' do
		it '#monta_trailer deve chamar os metodos para montar o header' do
			subject.expects(:trailer_arquivo_posicao_001_a_001).in_sequence(sequence_1).returns('001_a_001-')
			subject.expects(:trailer_arquivo_posicao_002_a_394).in_sequence(sequence_1).returns('002_b_394-').with(5)
			subject.expects(:trailer_arquivo_posicao_394_a_400).in_sequence(sequence_1).returns('394_c_400-').with(5)

			subject.monta_trailer(5).must_equal '001_A_001-002_B_394-394_C_400-'
		end
		it '#trailer_arquivo_posicao_001_a_001 - deve retornar o valor 9' do
			subject.trailer_arquivo_posicao_001_a_001.must_equal '9'
		end

		it '#trailer_arquivo_posicao_002_a_394 - deve retornar  393 posições em branco' do
			subject.trailer_arquivo_posicao_002_a_394(4).must_equal ''.rjust(393, ' ')
		end

		it '#trailer_arquivo_posicao_394_a_400 - deve retornar  o seuqnecial do item com 6 posições' do
			subject.trailer_arquivo_posicao_394_a_400(8).must_equal '000008'
		end
	end

	describe '#dados_do_arquivo' do

		it "deve montar os dados do arquivo setando o sequencial e os pagamentos corretamente - com 1 pagamento" do
			subject.expects(:monta_header).returns('montã_header')
			subject.expects(:monta_detalhe).with(pagamento, 2).returns('mônta_detalhe')
			subject.expects(:monta_trailer).with(3).returns('monta_tráiler')

			subject.dados_do_arquivo.must_equal "MONTA_HEADER\r\nMONTA_DETALHE\r\nMONTA_TRAILER\r\n"
		end
		it "deve montar os dados do arquivo setando o sequencial e os pagamentos corretamente - com 2 pagamentos" do
			pagamento2 = FactoryGirl.build(:remessa_pagamento)
			subject.pagamentos << pagamento2

			subject.expects(:monta_header).returns('montã_header').in_sequence(sequence_1)
			subject.expects(:monta_detalhe).with(pagamento, 2).returns('mônta_detalhe_pgto1').in_sequence(sequence_1)
			subject.expects(:monta_detalhe).with(pagamento2, 3).returns('mônta_détalhe_pgto2').in_sequence(sequence_1)
			subject.expects(:monta_trailer).with(4).returns('monta_tráiler').in_sequence(sequence_1)

			subject.dados_do_arquivo.must_equal "MONTA_HEADER\r\nMONTA_DETALHE_PGTO1\r\nMONTA_DETALHE_PGTO2\r\nMONTA_TRAILER\r\n"
		end
	end

end