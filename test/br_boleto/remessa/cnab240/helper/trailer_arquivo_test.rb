module Helper
	module TrailerArquivoTest
		def test_TrailerArquivo_metodo_monta_trailer_arquivo_deve_ter_o_conteudo_dos_metodos_na_sequencia
			subject.stubs(:trailer_arquivo_posicao_001_a_003).returns(        " 001_a_003")
			subject.stubs(:trailer_arquivo_posicao_004_a_007).with(1).returns(" 004_a_007")
			subject.stubs(:trailer_arquivo_posicao_008_a_008).returns(        " 008_a_008")
			subject.stubs(:trailer_arquivo_posicao_009_a_017).returns(        " 009_a_017")
			subject.stubs(:trailer_arquivo_posicao_018_a_023).with(1).returns(" 018_a_023")
			subject.stubs(:trailer_arquivo_posicao_024_a_029).with(2).returns(" 024_a_029")
			subject.stubs(:trailer_arquivo_posicao_030_a_035).returns(        " 030_a_035")
			subject.stubs(:trailer_arquivo_posicao_036_a_240).returns(        " 036_a_240")
			# Deve dar um upcase
			subject.monta_trailer_arquivo(1, 2).must_equal(" 001_A_003 004_A_007 008_A_008 009_A_017 018_A_023 024_A_029 030_A_035 036_A_240")
		end

		# Código do banco
		# 3 posições
		# Por padrão deve retornar o "codigo_banco"
		#
		def test_TrailerArquivo_metodo_trailer_arquivo_posicao_001_a_003
			subject.expects(:codigo_banco).returns("669")
			subject.trailer_arquivo_posicao_001_a_003.must_equal("669")
		end

		# Lote de Serviço -> Padrão 9999
		# 4 posições
		# Padrão retorna 9999
		#
		def test_TrailerArquivo_metodo_trailer_arquivo_posicao_004_a_007#(nro_lotes)
			subject.trailer_arquivo_posicao_004_a_007('tato faz').must_equal '9999'
		end

		# Tipo do registro -> Padrão 9
		# 1 posição
		# Retorna '9'
		#
		def test_TrailerArquivo_metodo_trailer_arquivo_posicao_008_a_008
			subject.trailer_arquivo_posicao_008_a_008.must_equal '9'
		end

		# Uso Exclusivo FEBRABAN/CNAB
		# 9 posições
		# todas as posições em branco
		#
		def test_TrailerArquivo_metodo_trailer_arquivo_posicao_009_a_017
			subject.trailer_arquivo_posicao_009_a_017.must_equal ''.rjust(9, ' ')
		end

		# Quantidade de Lotes do Arquivo
		# 6 posições
		# deve retornar o numero de lotes com 6 posições
		#
		def test_TrailerArquivo_metodo_trailer_arquivo_posicao_018_a_023#(nro_lotes)
			subject.trailer_arquivo_posicao_018_a_023(123).must_equal '123'.rjust(6, '0')
		end

		# Quantidade de Registros do Arquivo
		# 6 posições
		# Deve retornar o sequencial com 6 posições
		#
		def test_TrailerArquivo_metodo_trailer_arquivo_posicao_024_a_029#(sequencial)
			subject.trailer_arquivo_posicao_024_a_029(888).must_equal '888'.to_s.rjust(6, '0')
		end

		# Qtde de Contas p/ Conc. (Lotes)
		# 6 posições
		# Retorna 6 posições em branco
		#
		def test_TrailerArquivo_metodo_trailer_arquivo_posicao_030_a_035
			subject.trailer_arquivo_posicao_030_a_035.must_equal ''.rjust(6, ' ')
		end

		# Uso Exclusivo FEBRABAN/CNAB
		# 205 posições
		# Retorna todas as posições em branco
		#
		def test_TrailerArquivo_metodo_trailer_arquivo_posicao_036_a_240
			subject.trailer_arquivo_posicao_036_a_240.must_equal ''.rjust(205, ' ')
		end
		
	end
end