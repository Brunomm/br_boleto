module Helper
	module SegmentoRTest
		def test_SegmentoRTest_metodo_monta_segmento_r_deve_ter_o_conteudo_dos_metodos_na_sequencia
			subject.stubs(:segmento_r_posicao_001_a_003) .returns(               ' 001_a_003')
			subject.stubs(:segmento_r_posicao_004_a_007).with(1).returns(        ' 004_a_007')
			subject.stubs(:segmento_r_posicao_008_a_008).returns(                ' 008_a_008')
			subject.stubs(:segmento_r_posicao_009_a_013).with(2).returns(        ' 009_a_013')
			subject.stubs(:segmento_r_posicao_014_a_014).returns(                ' 014_a_014')
			subject.stubs(:segmento_r_posicao_015_a_015).returns(                ' 015_a_015')
			subject.stubs(:segmento_r_posicao_016_a_017).returns(                ' 016_a_017')
			subject.stubs(:segmento_r_posicao_018_a_018).with(pagamento).returns(' 018_a_018')
			subject.stubs(:segmento_r_posicao_019_a_026).with(pagamento).returns(' 019_a_026')
			subject.stubs(:segmento_r_posicao_027_a_041).with(pagamento).returns(' 027_a_041')
			subject.stubs(:segmento_r_posicao_042_a_042).with(pagamento).returns(' 042_a_042')
			subject.stubs(:segmento_r_posicao_043_a_050).with(pagamento).returns(' 043_a_050')
			subject.stubs(:segmento_r_posicao_051_a_065).with(pagamento).returns(' 051_a_065')
			subject.stubs(:segmento_r_posicao_066_a_066).with(pagamento).returns(' 066_a_066')
			subject.stubs(:segmento_r_posicao_067_a_074).with(pagamento).returns(' 067_a_074')
			subject.stubs(:segmento_r_posicao_075_a_089).with(pagamento).returns(' 075_a_089')
			subject.stubs(:segmento_r_posicao_090_a_099).returns(                ' 090_a_099')
			subject.stubs(:segmento_r_posicao_100_a_139).returns(                ' 100_a_139')
			subject.stubs(:segmento_r_posicao_140_a_179).returns(                ' 140_a_179')
			subject.stubs(:segmento_r_posicao_180_a_199).returns(                ' 180_a_199')
			subject.stubs(:segmento_r_posicao_200_a_207).returns(                ' 200_a_207')
			subject.stubs(:segmento_r_posicao_208_a_210).returns(                ' 208_a_210')
			subject.stubs(:segmento_r_posicao_211_a_215).returns(                ' 211_a_215')
			subject.stubs(:segmento_r_posicao_216_a_216).returns(                ' 216_a_216')
			subject.stubs(:segmento_r_posicao_217_a_228).returns(                ' 217_a_228')
			subject.stubs(:segmento_r_posicao_229_a_229).returns(                ' 229_a_229')
			subject.stubs(:segmento_r_posicao_230_a_230).returns(                ' 230_a_230')
			subject.stubs(:segmento_r_posicao_231_a_231).returns(                ' 231_a_231')
			subject.stubs(:segmento_r_posicao_232_a_240).returns(                ' 232_a_240')
			# Deve dar um upcase
			subject.monta_segmento_r(pagamento, 1, 2).must_equal(" 001_A_003 004_A_007 008_A_008 009_A_013 014_A_014 015_A_015 016_A_017 018_A_018 019_A_026 027_A_041 042_A_042 043_A_050 051_A_065 066_A_066 067_A_074 075_A_089 090_A_099 100_A_139 140_A_179 180_A_199 200_A_207 208_A_210 211_A_215 216_A_216 217_A_228 229_A_229 230_A_230 231_A_231 232_A_240")
		end
		
		def test_SegmentoRHelper_deve_ter_240_posicoes
			subject.stubs(:codigo_banco).returns("123")
			subject.monta_segmento_r(pagamento, 1, 2).size.must_equal 240
			
		end

		# Código do banco
		# 3 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_001_a_003 
			subject.expects(:codigo_banco).returns("123")
			subject.segmento_r_posicao_001_a_003 .must_equal '123'
		end

		# Lote de Serviço: Número seqüencial para identificar univocamente um lote de serviço. 
		# Criado e controlado pelo responsável pela geração magnética dos dados contidos no arquivo.
		# Preencher com '0001' para o primeiro lote do arquivo. 
		# Para os demais: número do lote anterior acrescido de 1. O número não poderá ser repetido dentro do arquivo.
		# 4 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_004_a_007
			subject.segmento_r_posicao_004_a_007(5).must_equal '0005'
		end

		# Tipo do registro -> Padrão 3
		# 1 posição
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_008_a_008
			subject.segmento_r_posicao_008_a_008.must_equal '3'
		end

		# Nº Sequencial do Registro no Lote
		# 5 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_009_a_013#(sequencial)
			subject.segmento_r_posicao_009_a_013('4').must_equal '00004'
		end

		# Cód. Segmento do Registro Detalhe
		# 1 posição
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_014_a_014
			subject.segmento_r_posicao_014_a_014.must_equal 'R'
		end

		# Uso Exclusivo FEBRABAN/CNAB 
		# 1 posição
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_015_a_015
			subject.segmento_r_posicao_015_a_015.must_equal ' '
		end

		# Código de Movimento Remessa - 01 = Entrada de Titulos
		# 2 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_016_a_017
			subject.segmento_r_posicao_016_a_017.must_equal '01'
		end

		# Código do desconto 2
		# 1 posição
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_018_a_018#(pagamento)
			pagamento.expects(:desconto_2_codigo).returns('789')
			subject.segmento_r_posicao_018_a_018(pagamento).must_equal '7'
		end

		# Data do desconto 2
		# 8 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_019_a_026#(pagamento)
			pagamento.expects(:desconto_2_data_formatado).with('%d%m%Y').returns('02022002')
			subject.segmento_r_posicao_019_a_026(pagamento).must_equal '02022002'
		end

		# Valor do desconto 2
		# 15 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_027_a_041#(pagamento)
			pagamento.expects(:desconto_2_valor_formatado).with(15).returns('123456')
			subject.segmento_r_posicao_027_a_041(pagamento).must_equal '123456'
		end

		# Código do desconto 3
		# 1 posição
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_042_a_042#(pagamento)
			pagamento.expects(:desconto_3_codigo).returns('897')
			subject.segmento_r_posicao_042_a_042(pagamento).must_equal '8'
		end

		# Data do desconto 3
		# 8 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_043_a_050#(pagamento)
			pagamento.expects(:desconto_3_data_formatado).with('%d%m%Y').returns('12345678')
			subject.segmento_r_posicao_043_a_050(pagamento).must_equal '12345678'
		end

		# Valor do desconto 3
		# 15 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_051_a_065#(pagamento)
			pagamento.expects(:desconto_3_valor_formatado).with(15).returns('1234567890')
			subject.segmento_r_posicao_051_a_065(pagamento).must_equal '1234567890'
		end

		# Codigo da multa - (0 = isento, 1 = Valor fixo e 2 = Percentual)
		# 1 posição
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_066_a_066#(pagamento)
			pagamento.expects(:codigo_multa).returns('11111111')
			subject.segmento_r_posicao_066_a_066(pagamento).must_equal '1'
		end
		def test_SegmentoRHelper_metodo_segmento_r_posicao_066_a_066_aceita_apenas_1_2_ou_3_com_padrao_3
			pagamento.codigo_multa = '1'
			subject.segmento_r_posicao_066_a_066(pagamento).must_equal '1'
			pagamento.codigo_multa = '2'
			subject.segmento_r_posicao_066_a_066(pagamento).must_equal '2'
			pagamento.codigo_multa = '3'
			subject.segmento_r_posicao_066_a_066(pagamento).must_equal '3'
			
			pagamento.codigo_multa = '4'
			subject.segmento_r_posicao_066_a_066(pagamento).must_equal '3'
			pagamento.codigo_multa = '0'
			subject.segmento_r_posicao_066_a_066(pagamento).must_equal '3'
		end

		# Data da multa
		# 1 posição
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_067_a_074#(pagamento)
			pagamento.expects(:data_multa_formatado).with('%d%m%Y').returns('12345678')
			subject.segmento_r_posicao_067_a_074(pagamento).must_equal '12345678'
		end

		# valor da multa
		# 15 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_075_a_089#(pagamento)
			pagamento.expects(:valor_multa_formatado).with(15).returns('123456')
			subject.segmento_r_posicao_075_a_089(pagamento).must_equal '123456'
		end

		# Informação ao pagador
		# 10 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_090_a_099
			subject.segmento_r_posicao_090_a_099.must_equal ''.rjust(10, " ")
		end

		# Informação 3
		# 40 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_100_a_139
			subject.segmento_r_posicao_100_a_139.must_equal ''.rjust(40, " ")
		end

		# Informação 4
		# 40 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_140_a_179
			subject.segmento_r_posicao_140_a_179.must_equal ''.rjust(40, " ")
		end

		# CNAB Uso exclusivo FEBRABAN
		# 20 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_180_a_199
			subject.segmento_r_posicao_180_a_199.must_equal ''.rjust(20, " ")
		end

		# Cod. Ocor. do pagador
		# 8 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_200_a_207
			subject.segmento_r_posicao_200_a_207.must_equal ''.rjust(8, "0")
		end

		# Cod. do banco para débido
		# 3 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_208_a_210
			subject.segmento_r_posicao_208_a_210.must_equal ''.rjust(3, "0")
		end

		# Agencia para débido
		# 5 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_211_a_215
			subject.segmento_r_posicao_211_a_215.must_equal ''.rjust(5, "0")
		end

		# DV agencia para débido
		# 1 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_216_a_216
			subject.segmento_r_posicao_216_a_216.must_equal " "
		end

		# Conta corrente para débito
		# 12 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_217_a_228
			subject.segmento_r_posicao_217_a_228.must_equal "".rjust(12, '0')
		end

		# DV Conta corrente para débito
		# 1 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_229_a_229
			subject.segmento_r_posicao_229_a_229.must_equal " "
		end

		# DV Aencia/Conta
		# 1 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_230_a_230
			subject.segmento_r_posicao_230_a_230.must_equal " "
		end

		# Ident. Da emissão do Aviso Debito Automatico
		# 1 posição
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_231_a_231
			subject.segmento_r_posicao_231_a_231.must_equal "0"
		end

		# Uso exclusivo
		# 9 posições
		#
		def test_SegmentoRHelper_metodo_segmento_r_posicao_232_a_240
			subject.segmento_r_posicao_232_a_240.must_equal "".rjust(9, " ")
		end
	
	end
end