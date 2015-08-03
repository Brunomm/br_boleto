module Helper
	module SegmentoSTest
		def test_SegmentoSTest_metodo_monta_segmento_s_deve_ter_o_conteudo_dos_metodos_na_sequencia_tipo_imressao_1
			pagamento.tipo_impressao = '1'
			subject.stubs(:segmento_s_posicao_001_a_003).returns(                " 001_a_003")
			subject.stubs(:segmento_s_posicao_004_a_007).with(1).returns(        " 004_a_007")
			subject.stubs(:segmento_s_posicao_008_a_008).returns(                " 008_a_008")
			subject.stubs(:segmento_s_posicao_009_a_013).with(2).returns(        " 009_a_013")
			subject.stubs(:segmento_s_posicao_014_a_014).returns(                " 014_a_014")
			subject.stubs(:segmento_s_posicao_015_a_015).returns(                " 015_a_015")
			subject.stubs(:segmento_s_posicao_016_a_017).returns(                " 016_a_017")
			subject.stubs(:segmento_s_posicao_018_a_018).with(pagamento).returns(" 018_a_018")

			subject.expects(:segmento_s_tipo_impressao_1_ou_2).with(pagamento).returns(" 999")
			# Deve dar um upcase
			subject.monta_segmento_s(pagamento, 1, 2).must_equal(" 001_A_003 004_A_007 008_A_008 009_A_013 014_A_014 015_A_015 016_A_017 018_A_018 999")
		end

		def test_SegmentoSTest_metodo_monta_segmento_s_deve_ter_o_conteudo_dos_metodos_na_sequencia_tipo_imressao_2
			pagamento.tipo_impressao = '2'
			subject.stubs(:segmento_s_posicao_001_a_003).returns(                " 001_a_003")
			subject.stubs(:segmento_s_posicao_004_a_007).with(1).returns(        " 004_a_007")
			subject.stubs(:segmento_s_posicao_008_a_008).returns(                " 008_a_008")
			subject.stubs(:segmento_s_posicao_009_a_013).with(2).returns(        " 009_a_013")
			subject.stubs(:segmento_s_posicao_014_a_014).returns(                " 014_a_014")
			subject.stubs(:segmento_s_posicao_015_a_015).returns(                " 015_a_015")
			subject.stubs(:segmento_s_posicao_016_a_017).returns(                " 016_a_017")
			subject.stubs(:segmento_s_posicao_018_a_018).with(pagamento).returns(" 018_a_018")

			subject.expects(:segmento_s_tipo_impressao_1_ou_2).with(pagamento).returns(" 888")
			# Deve dar um upcase
			subject.monta_segmento_s(pagamento, 1, 2).must_equal(" 001_A_003 004_A_007 008_A_008 009_A_013 014_A_014 015_A_015 016_A_017 018_A_018 888")
		end

		def test_SegmentoSTest_metodo_monta_segmento_s_deve_ter_o_conteudo_dos_metodos_na_sequencia_tipo_imressao_3
			pagamento.tipo_impressao = '3'
			subject.stubs(:segmento_s_posicao_001_a_003).returns(                " 001_a_003")
			subject.stubs(:segmento_s_posicao_004_a_007).with(1).returns(        " 004_a_007")
			subject.stubs(:segmento_s_posicao_008_a_008).returns(                " 008_a_008")
			subject.stubs(:segmento_s_posicao_009_a_013).with(2).returns(        " 009_a_013")
			subject.stubs(:segmento_s_posicao_014_a_014).returns(                " 014_a_014")
			subject.stubs(:segmento_s_posicao_015_a_015).returns(                " 015_a_015")
			subject.stubs(:segmento_s_posicao_016_a_017).returns(                " 016_a_017")
			subject.stubs(:segmento_s_posicao_018_a_018).with(pagamento).returns(" 018_a_018")

			subject.expects(:segmento_s_tipo_impressao_3).with(pagamento).returns(" 777")
			# Deve dar um upcase
			subject.monta_segmento_s(pagamento, 1, 2).must_equal(" 001_A_003 004_A_007 008_A_008 009_A_013 014_A_014 015_A_015 016_A_017 018_A_018 777")
		end
		
		def test_SegmentoSHelper_deve_ter_240_posicoes_com_tipo_impressao_1_ou_2
			pagamento.tipo_impressao = '1'
			subject.stubs(:codigo_banco).returns("123")
			subject.monta_segmento_s(pagamento, 1, 2).size.must_equal 240			
		end

		def test_SegmentoSHelper_deve_ter_240_posicoes_com_tipo_impressao_3
			pagamento.tipo_impressao = '3'
			subject.stubs(:codigo_banco).returns("123")
			subject.monta_segmento_s(pagamento, 1, 2).size.must_equal 240			
		end

		# Código do banco
		# 3 posições
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_001_a_003 
			subject.expects(:codigo_banco).returns("123")
			subject.segmento_s_posicao_001_a_003 .must_equal '123'
		end

		# Lote de Serviço: Número seqüencial para identificar univocamente um lote de serviço. 
		# Criado e controlado pelo responsável pela geração magnética dos dados contidos no arquivo.
		# Preencher com '0001' para o primeiro lote do arquivo. 
		# Para os demais: número do lote anterior acrescido de 1. O número não poderá ser repetido dentro do arquivo.
		# 4 posições
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_004_a_007
			subject.segmento_s_posicao_004_a_007(5).must_equal '0005'
		end

		# Tipo do registro -> Padrão 3
		# 1 posição
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_008_a_008
			subject.segmento_s_posicao_008_a_008.must_equal '3'
		end

		# Nº Sequencial do Registro no Lote
		# 5 posições
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_009_a_013#(sequencial)
			subject.segmento_s_posicao_009_a_013('4').must_equal '00004'
		end

		# Cód. Segmento do Registro Detalhe
		# 1 posição
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_014_a_014
			subject.segmento_s_posicao_014_a_014.must_equal 'S'
		end

		# Uso Exclusivo FEBRABAN/CNAB 
		# 1 posição
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_015_a_015
			subject.segmento_s_posicao_015_a_015.must_equal ' '
		end

		# Código de Movimento Remessa - 01 = Entrada de Titulos
		# 2 posições
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_016_a_017
			subject.segmento_s_posicao_016_a_017.must_equal '01'
		end

		# Tipo de impressão
		#     1 - Frente do Bloqueto
		#     2 - Verso do Bloauqto
		#     3 - Corpo de instruções da Ficha de Complansação
		# 1 posição
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_018_a_018#(pagamento)
			pagamento.expects(:tipo_impressao).returns('999')
			subject.segmento_s_posicao_018_a_018(pagamento).must_equal '9'
		end

	###########     TIPO DE IMPRESÃO 1 OU 2 ################
		def test_SegmentoSHelper_metodo_segmento_s_tipo_impressao_1_ou_2#(pagamento)
			subject.stubs(:segmento_s_posicao_019_a_020_tipo_impressao_1_ou_2).with(pagamento).returns(" 019_a_020")
			subject.stubs(:segmento_s_posicao_021_a_160_tipo_impressao_1_ou_2).with(pagamento).returns(" 021_a_160")
			subject.stubs(:segmento_s_posicao_161_a_162_tipo_impressao_1_ou_2).with(pagamento).returns(" 161_a_162")
			subject.stubs(:segmento_s_posicao_163_a_240_tipo_impressao_1_ou_2).returns(" 163_a_240")
			subject.segmento_s_tipo_impressao_1_ou_2(pagamento).must_equal(" 019_a_020 021_a_160 161_a_162 163_a_240")
		end
		# Numero da Linha a ser impressa
		# 2 posições
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_019_a_020_tipo_impressao_1_ou_2#(pagamento)
			subject.segmento_s_posicao_019_a_020_tipo_impressao_1_ou_2(pagamento).must_equal '01'
		end
		# Mensagem a ser impresas
		# 140 posições
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_021_a_160_tipo_impressao_1_ou_2#(pagamento)
			subject.segmento_s_posicao_021_a_160_tipo_impressao_1_ou_2(pagamento).must_equal ''.rjust(140, ' ')
		end

		# Tipo de caractere a ser impresso
		#     '01' = Normal
		#     '02' = Itálico
		#     '03' = Normal Negrito
		#     '04' = Itálico Negrito
		# 2 posições
		def test_SegmentoSHelper_metodo_segmento_s_posicao_161_a_162_tipo_impressao_1_ou_2#(pagamento)
			subject.segmento_s_posicao_161_a_162_tipo_impressao_1_ou_2(pagamento).must_equal '01'
		end

		# Uso exclusivo
		# 78 posições
		def test_SegmentoSHelper_metodo_segmento_s_posicao_163_a_240_tipo_impressao_1_ou_2
			subject.segmento_s_posicao_163_a_240_tipo_impressao_1_ou_2.must_equal ''.rjust(78, ' ')
		end
	########################################################
	############## TIPO DE IMPRESSÃO 3 #####################
		def test_SegmentoSHelper_metodo_segmento_s_tipo_impressao_3#(pagamento)
			subject.stubs(:segmento_s_posicao_019_a_058_tipo_impressao_3).with(pagamento).returns(" 019_a_058")
			subject.stubs(:segmento_s_posicao_059_a_098_tipo_impressao_3).with(pagamento).returns(" 059_a_098")
			subject.stubs(:segmento_s_posicao_099_a_138_tipo_impressao_3).with(pagamento).returns(" 099_a_138")
			subject.stubs(:segmento_s_posicao_139_a_178_tipo_impressao_3).with(pagamento).returns(" 139_a_178")
			subject.stubs(:segmento_s_posicao_179_a_218_tipo_impressao_3).with(pagamento).returns(" 179_a_218")
			subject.stubs(:segmento_s_posicao_219_a_240_tipo_impressao_3).returns(" 219_a_240")
			subject.segmento_s_tipo_impressao_3(pagamento).must_equal(" 019_a_058 059_a_098 099_a_138 139_a_178 179_a_218 219_a_240")
		end
		# Informação 5
		# 40 posições
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_019_a_058_tipo_impressao_3#(pagamento)
			subject.segmento_s_posicao_019_a_058_tipo_impressao_3(pagamento).must_equal ''.rjust(40, ' ')
		end

		# Informação 6
		# 40 posições
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_059_a_098_tipo_impressao_3#(pagamento)
			subject.segmento_s_posicao_059_a_098_tipo_impressao_3(pagamento).must_equal ''.rjust(40, ' ')
		end

		# Informação 7
		# 40 posições
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_099_a_138_tipo_impressao_3#(pagamento)
			subject.segmento_s_posicao_099_a_138_tipo_impressao_3(pagamento).must_equal ''.rjust(40, ' ')
		end

		# Informação 8
		# 40 posições
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_139_a_178_tipo_impressao_3#(pagamento)
			subject.segmento_s_posicao_139_a_178_tipo_impressao_3(pagamento).must_equal ''.rjust(40, ' ')
		end

		# Informação 9
		# 40 posições
		#
		def test_SegmentoSHelper_metodo_segmento_s_posicao_179_a_218_tipo_impressao_3#(pagamento)
			subject.segmento_s_posicao_179_a_218_tipo_impressao_3(pagamento).must_equal ''.rjust(40, ' ')
		end
		
		# Uso exclusivo
		# 78 posições
		def test_SegmentoSHelper_metodo_segmento_s_posicao_219_a_240_tipo_impressao_3
			subject.segmento_s_posicao_219_a_240_tipo_impressao_3.must_equal ''.rjust(22, ' ')
		end
	########################################################
	
	end
end