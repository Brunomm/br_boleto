module Helper
	module SegmentoPTest
		def test_SegmentoPTest_metodo_monta_segmento_p_deve_ter_o_conteudo_dos_metodos_na_sequencia
			subject.stubs(:segmento_p_posicao_001_a_003).returns(" 001_a_003")
			subject.stubs(:segmento_p_posicao_004_a_007).with(1).returns(" 004_a_007")
			subject.stubs(:segmento_p_posicao_008_a_008).returns(" 008_a_008")
			subject.stubs(:segmento_p_posicao_009_a_013).with(2).returns(" 009_a_013")
			subject.stubs(:segmento_p_posicao_014_a_014).returns(" 014_a_014")
			subject.stubs(:segmento_p_posicao_015_a_015).returns(" 015_a_015")
			subject.stubs(:segmento_p_posicao_016_a_017).returns(" 016_a_017")
			subject.stubs(:segmento_p_posicao_018_a_022).returns(" 018_a_022")
			subject.stubs(:segmento_p_posicao_023_a_023).returns(" 023_a_023")
			subject.stubs(:segmento_p_posicao_024_a_057).with(pagamento).returns(" 024_a_057")
			subject.stubs(:segmento_p_posicao_058_a_058).returns(" 058_a_058")
			subject.stubs(:segmento_p_posicao_059_a_059).returns(" 059_a_059")
			subject.stubs(:segmento_p_posicao_060_a_060).returns(" 060_a_060")
			subject.stubs(:segmento_p_posicao_061_a_061).returns(" 061_a_061")
			subject.stubs(:segmento_p_posicao_062_a_062).returns(" 062_a_062")
			subject.stubs(:segmento_p_posicao_063_a_077).with(pagamento).returns(" 063_a_077")
			subject.stubs(:segmento_p_posicao_078_a_085).with(pagamento).returns(" 078_a_085")
			subject.stubs(:segmento_p_posicao_086_a_100).with(pagamento).returns(" 086_a_100")
			subject.stubs(:segmento_p_posicao_101_a_105).returns(" 101_a_105")
			subject.stubs(:segmento_p_posicao_106_a_106).returns(" 106_a_106")
			subject.stubs(:segmento_p_posicao_107_a_108).returns(" 107_a_108")
			subject.stubs(:segmento_p_posicao_109_a_109).returns(" 109_a_109")
			subject.stubs(:segmento_p_posicao_110_a_117).with(pagamento).returns(" 110_a_117")
			subject.stubs(:segmento_p_posicao_118_a_118).with(pagamento).returns(" 118_a_118")
			subject.stubs(:segmento_p_posicao_119_a_126).with(pagamento).returns(" 119_a_126")
			subject.stubs(:segmento_p_posicao_127_a_141).with(pagamento).returns(" 127_a_141")
			subject.stubs(:segmento_p_posicao_142_a_142).with(pagamento).returns(" 142_a_142")
			subject.stubs(:segmento_p_posicao_143_a_150).with(pagamento).returns(" 143_a_150")
			subject.stubs(:segmento_p_posicao_151_a_165).with(pagamento).returns(" 151_a_165")
			subject.stubs(:segmento_p_posicao_166_a_180).with(pagamento).returns(" 166_a_180")
			subject.stubs(:segmento_p_posicao_181_a_195).with(pagamento).returns(" 181_a_195")
			subject.stubs(:segmento_p_posicao_196_a_220).returns(" 196_a_220")
			subject.stubs(:segmento_p_posicao_221_a_221).returns(" 221_a_221")
			subject.stubs(:segmento_p_posicao_222_a_223).returns(" 222_a_223")
			subject.stubs(:segmento_p_posicao_224_a_224).returns(" 224_a_224")
			subject.stubs(:segmento_p_posicao_225_a_227).returns(" 225_a_227")
			subject.stubs(:segmento_p_posicao_228_a_229).returns(" 228_a_229")
			subject.stubs(:segmento_p_posicao_230_a_239).returns(" 230_a_239")
			subject.stubs(:segmento_p_posicao_240_a_240).returns(" 240_a_240")
			# Deve dar um upcase
			subject.monta_segmento_p(pagamento, 1, 2).must_equal(" 001_A_003 004_A_007 008_A_008 009_A_013 014_A_014 015_A_015 016_A_017 018_A_022 023_A_023 024_A_057 058_A_058 059_A_059 060_A_060 061_A_061 062_A_062 063_A_077 078_A_085 086_A_100 101_A_105 106_A_106 107_A_108 109_A_109 110_A_117 118_A_118 119_A_126 127_A_141 142_A_142 143_A_150 151_A_165 166_A_180 181_A_195 196_A_220 221_A_221 222_A_223 224_A_224 225_A_227 228_A_229 230_A_239 240_A_240")
		end

		# Código do banco
		# 3 posições
		# Por padrão deve retornar o "codigo_banco"
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_001_a_003
			subject.conta.expects(:codigo_banco).returns("669")
			subject.segmento_p_posicao_001_a_003.must_equal("669")
		end

		# Lote de Serviço: Número seqüencial para identificar univocamente um lote de serviço. 
		# Criado e controlado pelo responsável pela geração magnética dos dados contidos no arquivo.
		# Preencher com '0001' para o primeiro lote do arquivo. 
		# Para os demais: número do lote anterior acrescido de 1. O número não poderá ser repetido dentro do arquivo.
		# 4 posições
		# Padrão recebe o nro do lote por parametro e ajusta para 4 caracteres
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_004_a_007
			subject.segmento_p_posicao_004_a_007(5).to_s.rjust(4, '0')
		end

		# Tipo do registro -> Padrão 3
		# 1 posição
		# Por padrão retorna '3'
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_008_a_008
			subject.segmento_p_posicao_008_a_008.must_equal '3'
		end

		# Nº Sequencial do Registro no Lote: 
		# Número adotado e controlado pelo responsável pela geração magnética dos dados contidos no arquivo, 
		# para identificar a seqüência de registros encaminhados no lote. 
		# Deve ser inicializado sempre em '1', em cada novo lote.
		# 5 posições
		# recebe o sequencial por parâmetro e ajusta para 5 posições incluindo 0 na frente
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_009_a_013
			subject.segmento_p_posicao_009_a_013(88).must_equal '00088'
		end

		# Cód. Segmento do Registro - Default: "P"
		# 1 posição
		# Por padrão é a letra P
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_014_a_014
			subject.segmento_p_posicao_014_a_014.must_equal "P"
		end

		# Uso Exclusivo FEBRABAN/CNAB
		# 1 posição
		# Por padrão é valor em branco
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_015_a_015
			subject.segmento_p_posicao_015_a_015.must_equal ' '
		end

		# cod. movimento remessa -> Padrão 01 = Entrada de Titulos
		# 2 posições
		# Por padrão é o valor '01'
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_016_a_017
			subject.segmento_p_posicao_016_a_017.must_equal '01'
		end

		# Agência Mantenedora da Conta 
		# 5 posições
		# Deve pegar a "agencia" e ajustar para 5 caracteres incluindo 0 na frente
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_018_a_022
			subject.conta.expects(:agencia).returns(89)
			subject.segmento_p_posicao_018_a_022.must_equal '00089'
		end

		# Dígito Verificador da Agência 
		# 1 posição
		# Deve pegar o "digito_agencia"
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_023_a_023
			subject.conta.expects(:agencia_dv).returns(1)
			subject.segmento_p_posicao_023_a_023.must_equal '1'
		end

		# O padrão da FEBRABAN é: 
		#      Posição de 24 até 35 com 12 posições = Número da Conta Corrente
		#      Posição de 36 até 36 com 01 posições = DV -> Dígito Verificador da Conta 
		#      Posição de 37 até 37 com 01 posições = DV -> Dígito Verificador da Ag/Conta
		#      Posição de 38 até 57 com 20 posições = Nosso Número -> Identificação do Título no Banco
		# Mas cada banco tem seu padrão
		# 34 posições
		# Deve pegar o "complemento_p" passando o "pagamento" por parametro
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_024_a_057
			subject.expects(:complemento_p).with('pagamento').returns("complemento_p")
			subject.segmento_p_posicao_024_a_057('pagamento').must_equal 'complemento_p'
		end

		# Código da carteira
		# 1 posição
		# Deve pegar o valor do metodo "codigo_carteira"
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_058_a_058
			subject.conta.expects(:tipo_cobranca).returns('3')
			subject.segmento_p_posicao_058_a_058.must_equal '3'
		end

		# Forma de Cadastr. do Título no Banco
		# 1 posição
		# Deve pegar o valor da "forma_cadastramento"
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_059_a_059
			pagamento.expects(:forma_cadastramento).returns('56')
			subject.segmento_p_posicao_059_a_059(pagamento).must_equal '5'
		end

		# Tipo de Documento
		# 1 posição
		# Retorna o valor '2' por padrão
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_060_a_060
			subject.segmento_p_posicao_060_a_060.must_equal '2'
		end

		# Identificação da Emissão do Bloqueto 
		# 1 posição
		# Deve pegar o valor do metodo "emissao_boleto"
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_061_a_061
			pagamento.expects(:emissao_boleto).returns('123')
			subject.segmento_p_posicao_061_a_061(pagamento).must_equal '123'
		end

		# Identificação da Distribuição
		# 1 posição
		# Deve pegar o valor do metodo "distribuicao_boleto"
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_062_a_062
			pagamento.expects(:distribuicao_boleto).returns('distribuicao_boleto')
			subject.segmento_p_posicao_062_a_062(pagamento).must_equal 'distribuicao_boleto'
		end

		# Número do Documento de Cobrança 
		# Cada banco tem seu padrão
		# 15 Posições
		# Deve retornar o valor do metodo "segmento_p_numero_do_documento" com o pagamento
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_063_a_077#(pagamento)
			subject.expects(:segmento_p_numero_do_documento).with('pagamento').returns('vpagamento')
			subject.segmento_p_posicao_063_a_077('pagamento').must_equal 'vpagamento'
		end

		# Data de Vencimento do Título
		# 8 posições
		# Deve retornar a "data_vencimento" formatada do pagamento 
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_078_a_085#(pagamento)
			pagamento.data_vencimento = Date.today
			subject.segmento_p_posicao_078_a_085(pagamento).must_equal Date.today.strftime('%d%m%Y')
		end

		# Valor Nominal do Título 
		# 15 posições (13 posições para valor inteiro e 2 posições para valor quebrado)
		# Deve retornar o "valor_documento_formatado" com 15 posições
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_086_a_100#(pagamento)
			pagamento.expects(:valor_documento_formatado).with(15).returns("123456789")
			subject.segmento_p_posicao_086_a_100(pagamento).must_equal '123456789'
		end

		# Agencia cobradora
		# 5 posições
		# Por padrão é 5 posições em branco
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_101_a_105
			subject.segmento_p_posicao_101_a_105.must_equal ''.rjust(5, '0')
		end

		# Dígito Verificador da Agência cobradora
		# 1 posição
		# Padrão é valor em branco
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_106_a_106
			subject.segmento_p_posicao_106_a_106.must_equal ' '
		end

		# Espécie do Título
		# 2 posições
		# Deve retornar o valro do metodo "especie_titulo"
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_107_a_108 
			pagamento.expects(:especie_titulo).returns('123')
			subject.segmento_p_posicao_107_a_108(pagamento).must_equal '12'
		end

		# Identific. de Título Aceito/Não Aceito (A ou N)
		# 1 posição
		# Deve retornar o valor do "aceite"
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_109_a_109
			pagamento.aceite = true
			subject.segmento_p_posicao_109_a_109(pagamento).must_equal 'A'
			pagamento.aceite = false
			subject.segmento_p_posicao_109_a_109(pagamento).must_equal 'N'
		end

		# Data da Emissão do Título 
		# 8 posições
		# deve pegar a "data_emissao" do pagamento e formatar
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_110_a_117#(pagamento)
			pagamento.data_emissao = Date.today
			subject.segmento_p_posicao_110_a_117(pagamento).must_equal Date.today.strftime('%d%m%Y')
		end

		# Código do Juros de Mora 
		# 1 posição
		# Por padrão é o valor '0'
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_118_a_118#(pagamento) 
			subject.segmento_p_posicao_118_a_118(pagamento).must_equal '3'
		end
		def test_SegmentoPTest_metodo_segmento_p_posicao_118_a_118_aceita_apenas_1_2_ou_3_com_padrao_3
			pagamento.codigo_juros = '1'
			subject.segmento_p_posicao_118_a_118(pagamento).must_equal '1'
			pagamento.codigo_juros = '2'
			subject.segmento_p_posicao_118_a_118(pagamento).must_equal '2'
			pagamento.codigo_juros = '3'
			subject.segmento_p_posicao_118_a_118(pagamento).must_equal '3'

			pagamento.codigo_juros = nil
			subject.segmento_p_posicao_118_a_118(pagamento).must_equal '3'
			
			pagamento.codigo_juros = '4'
			subject.segmento_p_posicao_118_a_118(pagamento).must_equal '3'
			pagamento.codigo_juros = '0'
			subject.segmento_p_posicao_118_a_118(pagamento).must_equal '3'
		end

		# Data do Juros de Mora 
		# 8 posições
		# Por padrão é 8 posições em branco
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_119_a_126#(pagamento) 
			pagamento.expects(:data_juros_formatado).with('%d%m%Y').returns('1234567890')
			subject.segmento_p_posicao_119_a_126(pagamento).must_equal '12345678'
		end

		# Juros de Mora por Dia/Taxa 
		# 15 posições
		# Por padrão é 15 posições em branco
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_127_a_141#(pagamento) 
			pagamento.expects(:valor_juros_formatado).with(15).returns('123456')
			subject.segmento_p_posicao_127_a_141(pagamento).must_equal '123456'
		end

		# Código do Desconto 1 
		# 1 posição
		# Deve pegar o "cod_desconto" do pagamento
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_142_a_142#(pagamento)
			pagamento.expects(:cod_desconto).returns('123')
			subject.segmento_p_posicao_142_a_142(pagamento).must_equal '1'
		end

		# Data do Desconto 1 
		# 8 posições
		# Deve retornar a "data_desconto_formatado" com formato ddmmyyyy do pagamento
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_143_a_150#(pagamento)
			pagamento.expects(:data_desconto_formatado).with('%d%m%Y').returns('12345678')
			subject.segmento_p_posicao_143_a_150(pagamento).must_equal '12345678'
		end

		# Valor/Percentual a ser Concedido 
		# 15 posições
		# Deve trazer o 'valor_desconto_formatado' com 15 posições do pagamento
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_151_a_165#(pagamento)
			pagamento.expects(:valor_desconto_formatado).with(15).returns('132')
			subject.segmento_p_posicao_151_a_165(pagamento).must_equal '132'
		end

		# Valor do IOF a ser Recolhido
		# 15 posições
		# Deve retornar o "valor_iof_formatado" com 15 posições do pagamento
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_166_a_180#(pagamento)
			pagamento.expects(:valor_iof_formatado).with(15).returns('123')
			subject.segmento_p_posicao_166_a_180(pagamento).must_equal '123'
		end

		# Valor do Abatimento
		# 15 posições
		# Deve retornar o "valor_abatimento_formatado" com 15 posições do pagamento
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_181_a_195#(pagamento)
			pagamento.expects(:valor_abatimento_formatado).with(15).returns('123')
			subject.segmento_p_posicao_181_a_195(pagamento).must_equal '123'
		end

		# Identificação do Título na Empresa 
		# 25 posições
		# Deve retornar 25 posições em branco
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_196_a_220
			subject.segmento_p_posicao_196_a_220(pagamento).must_equal ''.rjust(25, ' ') 
		end

		# Código para Protesto
		# 1 posição
		# Por padrão é o valor '1'
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_221_a_221 
			subject.segmento_p_posicao_221_a_221 .must_equal '1'
		end

		# Número de Dias para Protesto 
		# 2 posições
		# Por padrão é o valor '00'
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_222_a_223
			subject.segmento_p_posicao_222_a_223.must_equal '00' 
		end

		# Código para Baixa/Devolução 
		# 1 posição
		# Por padrão é o valor '0'
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_224_a_224
			subject.segmento_p_posicao_224_a_224.must_equal '0'  
		end

		# Número de Dias para Baixa/Devolução
		# 3 posoções
		# Por padrão é o valor '000'
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_225_a_227
			subject.segmento_p_posicao_225_a_227.must_equal '000'
		end

		# Código da Moeda (09 para real)
		# 2 posições
		# Por padrão é o valor '09'
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_228_a_229
			subject.segmento_p_posicao_228_a_229.must_equal '09'
		end

		# Nº do Contrato da Operação de Crédito (Uso do banco)
		# 10 posições
		# Por padrão é 10 pposições em branco
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_230_a_239
			subject.segmento_p_posicao_230_a_239.must_equal ''.rjust(10, '0')
		end

		# Uso livre banco/empresa ou autorização de pagamento parcial 
		# 1 posição
		# Por padrão é 1 campo em branco
		#
		def test_SegmentoPTest_metodo_segmento_p_posicao_240_a_240
			subject.segmento_p_posicao_240_a_240.must_equal ' '
		end		
	end
end