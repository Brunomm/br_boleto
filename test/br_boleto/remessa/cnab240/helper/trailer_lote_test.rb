module Helper
	module TrailerLoteTest
		def test_TrailerLote_metodo_monta_trailer_lote_deve_ter_o_conteudo_dos_metodos_na_sequencia
			subject.stubs(:trailer_lote_posicao_001_a_003).returns(        ' 001_a_003')
			subject.stubs(:trailer_lote_posicao_004_a_007).with(1).returns(' 004_a_007')
			subject.stubs(:trailer_lote_posicao_008_a_008).returns(        ' 008_a_008')
			subject.stubs(:trailer_lote_posicao_009_a_017).returns(        ' 009_a_017')
			subject.stubs(:trailer_lote_posicao_018_a_023).with(2).returns(' 018_a_023')
			subject.stubs(:trailer_lote_posicao_024_a_240).returns(        ' 024_a_240')
			# Deve dar um upcase
			subject.monta_trailer_lote(1, 2).must_equal(" 001_A_003 004_A_007 008_A_008 009_A_017 018_A_023 024_A_240")
		end

		# Código do banco
		# 3 posições
		# Por padrão deve retornar o "codigo_banco"
		#
		def test_TrailerLote_metodo_trailer_lote_posicao_001_a_003
			subject.expects(:codigo_banco).returns("669")
			subject.trailer_lote_posicao_001_a_003.must_equal("669")
		end

		# Lote de Serviço: Número seqüencial para identificar univocamente um lote de serviço. 
		# Criado e controlado pelo responsável pela geração magnética dos dados contidos no arquivo.
		# Preencher com '0001' para o primeiro lote do arquivo. 
		# Para os demais: número do lote anterior acrescido de 1. O número não poderá ser repetido dentro do arquivo.
		# 4 posições
		# Padrão recebe o nro do lote por parametro e ajusta para 4 caracteres
		#
		def test_TrailerLote_metodo_trailer_lote_posicao_004_a_007
			subject.trailer_lote_posicao_004_a_007(5).to_s.rjust(4, '0')
		end

		# Tipo do registro -> Padrão 5
		# 1 posição
		# Por padrão retorna '5'
		#
		def test_TrailerLote_metodo_trailer_lote_posicao_008_a_008
			subject.trailer_lote_posicao_008_a_008.must_equal '5'
		end

		# Uso Exclusivo FEBRABAN/CNAB
		# 9 posições
		# Deve ser 9 posiç&#7869;os em branco
		#
		def test_TrailerLote_metodo_trailer_lote_posicao_009_a_017
			subject.trailer_lote_posicao_009_a_017.must_equal ''.rjust(9, ' ')
		end

		# Quantidade de Registros no Lote
		# 6 posições
		# todas as posições em branco
		#
		def test_TrailerLote_metodo_trailer_lote_posicao_018_a_023#(nro_registros)
			subject.trailer_lote_posicao_018_a_023(1).must_equal '1'.to_s.rjust(6, '0')
		end

		# Complemento trailer diferente para cada banco
		# 217 posições
		# Deve pegar o valor do metodo "complemento_trailer_lote"
		#
		def test_TrailerLote_metodo_trailer_lote_posicao_024_a_240
			subject.expects(:complemento_trailer_lote).returns('complemento_trailer_lote')
			subject.trailer_lote_posicao_024_a_240.must_equal 'complemento_trailer_lote'
		end
	end
end