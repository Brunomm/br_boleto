module Helper
	module HeaderArquivoTest
		def test_HeaderArquivoTest_metodo_monta_header_arquivo_deve_ter_o_conteudo_dos_metodos_na_sequencia
			subject.stubs(:header_arquivo_posicao_001_a_003).returns(" 001_a_003")
			subject.stubs(:header_arquivo_posicao_004_a_007).returns(" 004_a_007")
			subject.stubs(:header_arquivo_posicao_008_a_008).returns(" 008_a_008")
			subject.stubs(:header_arquivo_posicao_009_a_017).returns(" 009_a_017")
			subject.stubs(:header_arquivo_posicao_018_a_018).returns(" 018_a_018")
			subject.stubs(:header_arquivo_posicao_019_a_032).returns(" 019_a_032")
			subject.stubs(:header_arquivo_posicao_033_a_052).returns(" 033_a_052")
			subject.stubs(:header_arquivo_posicao_053_a_072).returns(" 053_a_072")
			subject.stubs(:header_arquivo_posicao_073_a_102).returns(" 073_a_102")
			subject.stubs(:header_arquivo_posicao_103_a_132).returns(" 103_a_132")
			subject.stubs(:header_arquivo_posicao_133_a_142).returns(" 133_a_142")
			subject.stubs(:header_arquivo_posicao_143_a_143).returns(" 143_a_143")
			subject.stubs(:header_arquivo_posicao_144_a_151).returns(" 144_a_151")
			subject.stubs(:header_arquivo_posicao_152_a_157).returns(" 152_a_157")
			subject.stubs(:header_arquivo_posicao_158_a_163).returns(" 158_a_163")
			subject.stubs(:header_arquivo_posicao_164_a_166).returns(" 164_a_166")
			subject.stubs(:header_arquivo_posicao_167_a_171).returns(" 167_a_171")
			subject.stubs(:header_arquivo_posicao_172_a_191).returns(" 172_a_191")
			subject.stubs(:header_arquivo_posicao_192_a_211).returns(" 192_a_211")
			subject.stubs(:header_arquivo_posicao_212_a_240).returns(" 212_a_240")
			# Deve dar um upcase
			subject.monta_header_arquivo.must_equal(" 001_A_003 004_A_007 008_A_008 009_A_017 018_A_018 019_A_032 033_A_052 053_A_072 073_A_102 103_A_132 133_A_142 143_A_143 144_A_151 152_A_157 158_A_163 164_A_166 167_A_171 172_A_191 192_A_211 212_A_240")
		end

		# Código do banco
		# 3 posições
		# Por padrão deve retornar o "codigo_banco"
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_001_a_003
			subject.conta.expects(:codigo_banco).returns("669")
			subject.header_arquivo_posicao_001_a_003.must_equal("669")
		end

		# Lote de serviço
		# 4 posições
		# Por padrão retorna 0000
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_004_a_007
			subject.header_arquivo_posicao_004_a_007.must_equal('0000')
		end

		# Tipo do registro
		# 1 posição
		# Por padrão retorna '0'
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_008_a_008
			subject.header_arquivo_posicao_008_a_008.must_equal('0')
		end

		# Uso Exclusivo FEBRABAN / CNAB
		# 09 posições
		# Por padrão retorna 9 posições em branco
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_009_a_017
			subject.header_arquivo_posicao_009_a_017.must_equal( ''.rjust(9, ' ')  )
		end

		# Tipo de Inscrição da Empresa
		# 1 posição
		# retorna o valor do metodo "tipo_inscricao"
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_018_a_018
			subject.conta.expects(:tipo_cpf_cnpj).with(1).returns("5")
			subject.header_arquivo_posicao_018_a_018.must_equal("5")
		end

		# Número de Inscrição da Empresa (CPF/CNPJ)
		# 14 Posições
		# Retorna o documento_cedente com 14 posições preenchendo com zeros
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_019_a_032
			subject.conta.expects(:cpf_cnpj).returns("1234567890")
			subject.header_arquivo_posicao_019_a_032.must_equal("00001234567890")
		end

		# Código do Convênio no Banco
		# 20 posições
		# Deve retornar o valor do metodo "codigo_convenio"
		# 
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_033_a_052
			subject.expects(:codigo_convenio).returns("123456789012345")
			subject.header_arquivo_posicao_033_a_052.must_equal("123456789012345     ")
		end

		# Informações da conta bancária
		# O padrão da FEBRABAN é: 
		#      Posição de 53 até 57 com 05 posições = Agência Mantenedora da Conta
		#      Posição de 58 até 58 com 01 posições = DV    -> Dígito Verificador da Agência
		#      Posição de 59 até 70 com 12 posições = Conta -> Número Número da Conta Corrente
		#      Posição de 71 até 71 com 01 posições = DV    -> Dígito Verificador da Conta
		#      Posição de 72 até 72 com 01 posições = DV    -> Dígito Verificador da Ag/Conta
		#
		# Porém como no Brasil os bancos não conseguem seguir um padrão, cada banco faz da sua maneira
		# 20 posições
		# Retorna o valor contido no metodo "informacoes_da_conta"
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_053_a_072
			subject.expects(:informacoes_da_conta).returns("INFO_CONTA")
			subject.header_arquivo_posicao_053_a_072.must_equal("INFO_CONTA")
		end

		# Nome da Empresa
		# 30 posições
		# retorna o valor do metodo "nome_empresa_formatada"
		# 
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_073_a_102
			subject.conta.expects(:razao_social).returns("EMPRESA")
			subject.header_arquivo_posicao_073_a_102.must_equal("EMPRESA".ljust(30, ' '))
		end

		# Nome do Banco
		# 30 posições
		# retorna o valor do metodo "nome_banco"
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_103_a_132
			subject.conta.expects(:nome_banco).returns("nome_banco")
			subject.header_arquivo_posicao_103_a_132.must_equal('nome_banco'.ljust(30, ' '))
		end

		# Uso Exclusivo FEBRABAN / CNAB
		# 10 posições
		# Valores em branco
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_133_a_142
			subject.header_arquivo_posicao_133_a_142.must_equal(''.rjust(10, ' '))
		end

		# Código Remessa / Retorno (1 para remessa)
		# 1 posição
		# Padrão retorna o valor 1
		# 
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_143_a_143
			subject.header_arquivo_posicao_143_a_143.must_equal("1")
		end

		# Data de Geração do Arquivo no formato (DDMMYYYY)
		# 8 posições
		# Deve pegar o valor contido no metodo "data_geracao"
		# 
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_144_a_151
			subject.expects(:data_geracao).returns("data_geracao")
			subject.header_arquivo_posicao_144_a_151.must_equal("data_geracao")
		end

		# Hora de Geração do Arquivo no formato (HHMMSS)
		# 6 posições
		# Deve pegar o valor contido no metodo "hora_geracao"
		# 
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_152_a_157
			subject.expects(:hora_geracao).returns("hora_geracao")
			subject.header_arquivo_posicao_152_a_157.must_equal("hora_geracao")
		end

		# Número Seqüencial do Arquivo
		# 6 posições
		# Por padrão pega o valor contido no metodo "sequencial_remessa" ajsutando para 6 posições
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_158_a_163
			subject.expects(:sequencial_remessa).returns("1234")
			subject.header_arquivo_posicao_158_a_163.must_equal("001234")
		end

		# Numero da Versão do Layout do Arquivo
		# 3 posições
		# Deve pegar o valor contido no metodo "versao_layout_arquivo"
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_164_a_166
			subject.conta.expects(:versao_layout_arquivo_cnab_240).returns("1")
			subject.header_arquivo_posicao_164_a_166.must_equal("001")
		end

		# Densidade de Gravação do Arquivo 
		# 5 posições
		# Por padrão retorna 5 zeros
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_167_a_171
			subject.header_arquivo_posicao_167_a_171.must_equal(''.rjust(5, '0'))
		end

		# Espaço reservado para o Banco
		# 20 posições
		# Por padrão retorna 20 zeros
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_172_a_191
			subject.header_arquivo_posicao_172_a_191.must_equal(''.rjust(20, '0'))
		end

		# Espaço reservado para a Empresa
		# 20 posições
		# Por padrão retorna 20 zeros
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_192_a_211
			subject.header_arquivo_posicao_192_a_211.must_equal(''.rjust(20, '0'))
		end

		# Para Uso Exclusivo FEBRABAN / CNAB
		# 29 posições
		# Padrão pega o valor do metodo "complemento_header_arquivo"
		#
		def test_HeaderArquivoTest_metodo_header_arquivo_posicao_212_a_240
			subject.expects(:complemento_header_arquivo).returns("123456")
			subject.header_arquivo_posicao_212_a_240.must_equal("123456")
		end
	end
end