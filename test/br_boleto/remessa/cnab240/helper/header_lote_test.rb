module Helper
	module HeaderLoteTest
		def test_HeaderLoteTest_metodo_monta_header_lote_deve_ter_o_conteudo_dos_metodos_na_sequencia
			subject.stubs(:header_lote_posicao_001_a_003).returns(" 001_a_003")
			subject.stubs(:header_lote_posicao_004_a_007).with(1).returns(" 004_a_007")
			subject.stubs(:header_lote_posicao_008_a_008).returns(" 008_a_008")
			subject.stubs(:header_lote_posicao_009_a_009).returns(" 009_a_009")
			subject.stubs(:header_lote_posicao_010_a_011).returns(" 010_a_011")
			subject.stubs(:header_lote_posicao_012_a_013).returns(" 012_a_013")
			subject.stubs(:header_lote_posicao_014_a_016).returns(" 014_a_016")
			subject.stubs(:header_lote_posicao_017_a_017).returns(" 017_a_017")
			subject.stubs(:header_lote_posicao_018_a_018).returns(" 018_a_018")
			subject.stubs(:header_lote_posicao_019_a_033).returns(" 019_a_033")
			subject.stubs(:header_lote_posicao_034_a_053).with(lote).returns(" 034_a_053")
			subject.stubs(:header_lote_posicao_054_a_073).returns(" 054_a_073")
			subject.stubs(:header_lote_posicao_074_a_103).returns(" 074_a_103")
			subject.stubs(:header_lote_posicao_104_a_143).returns(" 104_a_143")
			subject.stubs(:header_lote_posicao_144_a_183).returns(" 144_a_183")
			subject.stubs(:header_lote_posicao_184_a_191).returns(" 184_a_191")
			subject.stubs(:header_lote_posicao_192_a_199).returns(" 192_a_199")
			subject.stubs(:header_lote_posicao_200_a_207).returns(" 200_a_207")
			subject.stubs(:header_lote_posicao_208_a_240).returns(" 208_a_240")
			# Deve dar um upcase
			subject.monta_header_lote(lote, 1).must_equal(" 001_A_003 004_A_007 008_A_008 009_A_009 010_A_011 012_A_013 014_A_016 017_A_017 018_A_018 019_A_033 034_A_053 054_A_073 074_A_103 104_A_143 144_A_183 184_A_191 192_A_199 200_A_207 208_A_240")
		end

		# Código do banco
		# 3 posições
		# Por padrão deve retornar o "codigo_banco"
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_001_a_003
			subject.conta.expects(:codigo_banco).returns("669")
			subject.header_lote_posicao_001_a_003.must_equal("669")
		end

		# Lote de Serviço
		# 4 posições
		# Deve pegar o numero do lote preenchendo com 0
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_004_a_007
			subject.header_lote_posicao_004_a_007(5).must_equal "0005"
		end

		# Tipo de Registro
		# 1 posição
		# valor padrão 1
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_008_a_008
			subject.header_lote_posicao_008_a_008.must_equal '1'
		end

		# Tipo da Operação
		# 1 posição
		# Valor padrão R
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_009_a_009
			subject.header_lote_posicao_009_a_009.must_equal "R"
		end

		# Tipo do Serviço
		# 2 posições
		# Valor padrão '01'
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_010_a_011
			subject.header_lote_posicao_010_a_011.must_equal '01'
		end

		# Forma de Lançamento
		# 2 posições
		# Valor padrão '00'
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_012_a_013
			subject.header_lote_posicao_012_a_013.must_equal '00'
		end

		# Nº da Versão do Layout do Lote
		# 3 posições
		# Deve pegar o valor do metodo "versao_layout_lote"
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_014_a_016
			subject.conta.expects(:versao_layout_lote_cnab_240).returns('56')
			subject.header_lote_posicao_014_a_016.must_equal "056"
		end

		# Uso Exclusivo da FEBRABAN/CNAB
		# 1 posição
		# Padrão valor em branco
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_017_a_017
			subject.header_lote_posicao_017_a_017.must_equal ' '
		end

		# Tipo de Inscrição da Empresa
		# 1 posição
		# Deve pegar o valor do metodo "tipo_inscricao"
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_018_a_018
			subject.conta.expects(:tipo_cpf_cnpj).with(1).returns('3')
			subject.header_lote_posicao_018_a_018.must_equal '3'
		end

		# Número de Inscrição da Empresa
		# 15 posições
		# Deve pegar o valor do 'documento_cedente' e ajustar com 0 o espaço em branco
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_019_a_033
			subject.conta.expects(:cpf_cnpj).returns('1234567890')
			subject.header_lote_posicao_019_a_033.must_equal '000001234567890'
		end

		# Convenio -> Código do Cedente no Banco
		# 6 posições
		# Deve pegar o valor do metodo 'convenio_lote'
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_034_a_053#lote
			subject.expects(:convenio_lote).with(lote).returns('convenio_lote')
			subject.header_lote_posicao_034_a_053(lote).must_equal 'convenio_lote'
		end

		# Informações da conta bancária
		# O padrão da FEBRABAN é:
		#      Posição de 54 até 58 com 05 posições = Agência Mantenedora da Conta
		#      Posição de 59 até 59 com 01 posições = DV    -> Dígito Verificador da Agência
		#      Posição de 60 até 71 com 12 posições = Conta -> Número Número da Conta Corrente
		#      Posição de 72 até 72 com 01 posições = DV    -> Dígito Verificador da Conta
		#      Posição de 73 até 73 com 01 posições = DV    -> Dígito Verificador da Ag/Conta
		#
		# Porém como no Brasil os bancos não conseguem seguir um padrão, cada banco faz da sua maneira
		# 20 posições
		# Deve pegar o valor do metodo 'informacoes_da_conta'
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_054_a_073
			subject.expects(:informacoes_da_conta).returns('informacoes_da_conta')
			subject.header_lote_posicao_054_a_073.must_equal 'informacoes_da_cont '
		end

		# Nome da Empresa
		# 30 posições
		# deve retornar o valor do metodo 'nome_empresa_formatada'
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_074_a_103
			subject.conta.expects(:razao_social).returns('nome_empresa_formatada')
			subject.header_lote_posicao_074_a_103.must_equal 'nome_empresa_formatada'.ljust(30, ' ')
		end

		# Mensagem 1
		# 40 posições
		# Deve pegar o valor da "mensagem_1" e ajsutar para 40 posiçoes
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_104_a_143
			subject.expects(:mensagem_1).returns('mensagem_1')
			subject.header_lote_posicao_104_a_143.must_equal 'mensagem_1'.ljust(40, ' ')
		end

		# Mensagem 2
		# 40 posições
		# Deve pegar o valor da "mensagem_2" e ajsutar para 40 posiçoes
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_144_a_183
			subject.expects(:mensagem_2).returns('1111'.rjust(44, '2'))
			subject.header_lote_posicao_144_a_183.must_equal ''.rjust(40, '2')
		end

		# Número Remessa/Retorno
		# 8 posições
		# Deve pegar o valor do metodo "sequencial_remessa" e ajustar para 8 posições com zero
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_184_a_191
			subject.expects(:sequencial_remessa).returns("111")
			subject.header_lote_posicao_184_a_191.must_equal "111".rjust(8, '0')
		end

		# Data de Gravação Remessa/Retorno
		# 8 posições
		# Deve retornar o valor do metodo "data_geracao"
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_192_a_199
			subject.expects(:data_geracao).returns("data_geracao")
			subject.header_lote_posicao_192_a_199.must_equal 'data_geracao'
		end

		# Data do Crédito
		# 8 posições
		# Deve conter 8 posições com zeros
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_200_a_207
			subject.header_lote_posicao_200_a_207.must_equal ''.rjust(8, '0')
		end

		# Uso Exclusivo FEBRABAN/CNAB
		# 33 posições
		# Deve conter 33 posições em branco
		#
		def test_HeaderLoteTest_metodo_header_lote_posicao_208_a_240
			subject.header_lote_posicao_208_a_240.must_equal ''.rjust(33, ' ')
		end


	end
end