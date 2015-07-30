module Helper
	module SegmentoQTest
		def test_SegmentoQTest_metodo_monta_segmento_q_deve_ter_o_conteudo_dos_metodos_na_sequencia
			subject.stubs(:segmento_q_posicao_001_a_003).returns(                " 001_a_003")
			subject.stubs(:segmento_q_posicao_004_a_007).with(1).returns(        " 004_a_007")
			subject.stubs(:segmento_q_posicao_008_a_008).returns(                " 008_a_008")
			subject.stubs(:segmento_q_posicao_009_a_013).with(2).returns(        " 009_a_013")
			subject.stubs(:segmento_q_posicao_014_a_014).returns(                " 014_a_014")
			subject.stubs(:segmento_q_posicao_015_a_015).returns(                " 015_a_015")
			subject.stubs(:segmento_q_posicao_016_a_017).returns(                " 016_a_017")
			subject.stubs(:segmento_q_posicao_018_a_018).with(pagamento).returns(" 018_a_018")
			subject.stubs(:segmento_q_posicao_019_a_033).with(pagamento).returns(" 019_a_033")
			subject.stubs(:segmento_q_posicao_034_a_073).with(pagamento).returns(" 034_a_073")
			subject.stubs(:segmento_q_posicao_074_a_113).with(pagamento).returns(" 074_a_113")
			subject.stubs(:segmento_q_posicao_114_a_128).with(pagamento).returns(" 114_a_128")
			subject.stubs(:segmento_q_posicao_129_a_133).with(pagamento).returns(" 129_a_133")
			subject.stubs(:segmento_q_posicao_134_a_136).with(pagamento).returns(" 134_a_136")
			subject.stubs(:segmento_q_posicao_137_a_151).with(pagamento).returns(" 137_a_151")
			subject.stubs(:segmento_q_posicao_152_a_153).with(pagamento).returns(" 152_a_153")
			subject.stubs(:segmento_q_posicao_154_a_154).with(pagamento).returns(" 154_a_154")
			subject.stubs(:segmento_q_posicao_155_a_169).with(pagamento).returns(" 155_a_169")
			subject.stubs(:segmento_q_posicao_170_a_209).with(pagamento).returns(" 170_a_209")
			subject.stubs(:segmento_q_posicao_210_a_210).returns(                " 210_a_210")
			subject.stubs(:segmento_q_posicao_210_a_210).returns(                " 210_a_210")
			subject.stubs(:segmento_q_posicao_210_a_210).returns(                " 210_a_210")
			# Deve dar um upcase
			subject.monta_segmento_q(pagamento, 1, 2).must_equal(" 001_A_003 004_A_007 008_A_008 009_A_013 014_A_014 015_A_015 016_A_017 018_A_018 019_A_033 034_A_073 074_A_113 114_A_128 129_A_133 134_A_136 137_A_151 152_A_153 154_A_154 155_A_169 170_A_209 210_A_210 210_A_210 210_A_210")
		end

		# Código do banco
		# 3 posições
		# Por padrão deve retornar o "codigo_banco"
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_001_a_003
			subject.expects(:codigo_banco).returns("669")
			subject.segmento_q_posicao_001_a_003.must_equal("669")
		end

		# Lote de Serviço: Número seqüencial para identificar univocamente um lote de serviço. 
		# Criado e controlado pelo responsável pela geração magnética dos dados contidos no arquivo.
		# Preencher com '0001' para o primeiro lote do arquivo. 
		# Para os demais: número do lote anterior acrescido de 1. O número não poderá ser repetido dentro do arquivo.
		# 4 posições
		# Padrão recebe o nro do lote por parametro e ajusta para 4 caracteres
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_004_a_007
			subject.segmento_q_posicao_004_a_007(5).to_s.rjust(4, '0')
		end

		# Tipo do registro -> Padrão 3
		# 1 posição
		# Por padrão retorna '3'
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_008_a_008
			subject.segmento_q_posicao_008_a_008.must_equal '3'
		end

		# Nº Sequencial do Registro no Lote
		# 5 posições
		# Deve ajustar o numero sequencial para 5 posições
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_009_a_013#(sequencial)
			subject.segmento_q_posicao_009_a_013(1).must_equal '00001' 
		end

		# Cód. Segmento do Registro Detalhe
		# 1 posição
		# Por padrão retorna o valor 'Q'
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_014_a_014
			subject.segmento_q_posicao_014_a_014.must_equal 'Q'
		end

		# Uso Exclusivo FEBRABAN/CNAB 
		# 1 posição
		# Valor em branco
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_015_a_015
			subject.segmento_q_posicao_015_a_015.must_equal ' '
		end

		# Código de Movimento Remessa 
		# 2 posições
		# Por padrão é o valor '01'
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_016_a_017
			subject.segmento_q_posicao_016_a_017.must_equal '01'
		end

		# Tipo de Inscrição (1=CPF 2=CNPJ)
		# 1 posição
		# Deve pegar o 'tipo_documento_sacado' com 1 posição
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_018_a_018#(pagamento)
			pagamento.expects(:tipo_documento_sacado).with(1).returns('1')
			subject.segmento_q_posicao_018_a_018(pagamento).must_equal '1' 
		end

		# Número de Inscrição
		# 15 posições
		# Deve retornar o "documento_sacado" com 15 posições
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_019_a_033#(pagamento)
			pagamento.documento_sacado = 1234567890
			subject.segmento_q_posicao_019_a_033(pagamento).must_equal '000001234567890'
		end

		# Nome do sacado
		# 40 posições
		# Deve retornar o nome do sacado ajustando para 40 posições
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_034_a_073#(pagamento)
			pagamento.nome_sacado = '556698'
			subject.segmento_q_posicao_034_a_073(pagamento).must_equal '556698'.adjust_size_to(40)
		end

		# Endereço sacado
		# 40 posições
		# Deve pegar o "endereco_sacado" ajsutando para 40 posições
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_074_a_113#(pagamento)
			pagamento.endereco_sacado = '111'.rjust(43, '2')
			subject.segmento_q_posicao_074_a_113(pagamento).must_equal ''.rjust(40, '2')
		end

		# Bairro do sacado
		# 15 posições
		# Deve retornar o 'bairro_sacado' com 15 posições
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_114_a_128#(pagamento)
			pagamento.bairro_sacado = '50'
			subject.segmento_q_posicao_114_a_128(pagamento).must_equal '50'.adjust_size_to(15)
		end

		# CEP (prefixo)
		# 5 posições
		# Deve retornar o CEP com 5 posições
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_129_a_133#(pagamento)
			pagamento.expects(:cep_sacado).returns('12345678')
			subject.segmento_q_posicao_129_a_133(pagamento).must_equal '12345'
		end

		# CEP sufixo
		# 3 posições
		# Deve pegar as ultimas 3 posições do cep
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_134_a_136#(pagamento)
			pagamento.expects(:cep_sacado).returns('12345678')
			subject.segmento_q_posicao_134_a_136(pagamento).must_equal '678'
		end

		# Cidade
		# 15 posições
		# Deve retornar a "cidade_sacado" ajustando para 15 posições
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_137_a_151#(pagamento)
			pagamento.expects(:cidade_sacado).returns('5555')
			subject.segmento_q_posicao_137_a_151(pagamento).must_equal '5555'.adjust_size_to(15)
		end

		# Unidade da Federação
		# 2 posuções
		# Retorna o UF do sacado
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_152_a_153#(pagamento)
			pagamento.expects(:uf_sacado).returns("XX")
			subject.segmento_q_posicao_152_a_153(pagamento).must_equal 'XX'
		end

		# Tipo de Inscrição
		# 1 posição
		# Deve retornar o "tipo_documento_avalista" com 1 posição do pagamento
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_154_a_154#(pagamento)
			pagamento.expects(:tipo_documento_avalista).with(1).returns("6")
			subject.segmento_q_posicao_154_a_154(pagamento).must_equal '6'
		end

		# Número de Inscrição
		# 15 posições
		# Deve pegar o "documento_avalista" com 15 posições
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_155_a_169#(pagamento)
			pagamento.expects(:documento_avalista).returns(123)
			subject.segmento_q_posicao_155_a_169(pagamento).must_equal '123'.rjust(15, '0')
		end

		# Nome do avalista
		# 40 posições
		# Deve retornar o "nome_avalista" ajustando para 40 posições
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_170_a_209#(pagamento)
			pagamento.expects(:nome_avalista).returns('avalista')
			subject.segmento_q_posicao_170_a_209(pagamento).must_equal 'avalista'.adjust_size_to(40)
		end

		# Cód. Bco. Corresp. na Compensação
		# 3 posições
		# Deve retornar '000'
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_210_a_210
			subject.segmento_q_posicao_210_a_210.must_equal ''.rjust(3, '0') 
		end

		# Nosso Nº no Banco Correspondente
		# 20 posições
		# Deve retornar 20 posições em branco
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_210_a_210
			subject.segmento_q_posicao_210_a_210.must_equal ''.rjust(20, ' ')
		end

		# Uso Exclusivo FEBRABAN/CNAB
		# 8 posições
		# Retorna 8 posições em branco
		#
		def test_SegmentoQTest_metodo_segmento_q_posicao_210_a_210
			subject.segmento_q_posicao_210_a_210.must_equal ''.rjust(8, ' ') 
		end
	
	end
end