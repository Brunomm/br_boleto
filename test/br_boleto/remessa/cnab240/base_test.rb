require 'test_helper'
require 'br_boleto/remessa/cnab240/helper/header_arquivo_test'
require 'br_boleto/remessa/cnab240/helper/header_lote_test'
require 'br_boleto/remessa/cnab240/helper/segmento_p_test'
require 'br_boleto/remessa/cnab240/helper/segmento_q_test'
require 'br_boleto/remessa/cnab240/helper/segmento_r_test'
require 'br_boleto/remessa/cnab240/helper/segmento_s_test'
require 'br_boleto/remessa/cnab240/helper/trailer_arquivo_test'
require 'br_boleto/remessa/cnab240/helper/trailer_lote_test'

describe BrBoleto::Remessa::Cnab240::Base do
	subject { FactoryGirl.build(:remessa_cnab240_base, lotes: lote) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento) } 
	let(:lote) { FactoryGirl.build(:remessa_lote, pagamentos: pagamento) }

	before do 
		subject.stubs(:conta_class).returns(BrBoleto::Conta::Sicoob)
		subject.stubs(:conta).returns FactoryGirl.build(:conta_sicoob)
	end

	context "TESTE DAS PARTES DO ARQUIVO" do
		# Em cada banco pode incluir esses modules para testar sobrescrevendo os testes específicos
		include Helper::HeaderArquivoTest
		include Helper::HeaderLoteTest
		include Helper::SegmentoPTest
		include Helper::SegmentoQTest
		include Helper::SegmentoRTest
		include Helper::SegmentoSTest
		include Helper::TrailerArquivoTest
		include Helper::TrailerLoteTest
	end

	context "validations" do
		it { must validate_length_of(:emissao_boleto     ).is_equal_to(1).with_message("deve ter 1 dígito.") }
		it { must validate_length_of(:distribuicao_boleto).is_equal_to(1).with_message("deve ter 1 dígito.") }
	end

	describe "#lotes" do
		it "deve haver ao menos 1 lote" do
			wont allow_value([]).for(:lotes).with_message("não pode estar vazio.")
		end
		it "deve ser um objeto lote" do
			wont allow_value(FactoryGirl.build(:boleto_sicoob)).for(:lotes).with_message("cada item deve ser um objeto Lote.")
		end
		it "deve ser válido com um lote válido" do
			must allow_value([lote]).for(:lotes)
		end
		it "não deve ser válido se houver algum lote inválido" do
			wont allow_value([FactoryGirl.build(:remessa_lote, pagamentos: [])]).for(:lotes)
		end
		it "deve ser válido se passar apenas um lote sem Array" do
			must allow_value(lote).for(:lotes)
		end
		it "se setar apenas 1 lote sem array deve retornar um array de 1 posicao" do
			subject.lotes = lote
			subject.lotes.size.must_equal 1
			subject.lotes.is_a?(Array).must_equal true
			subject.lotes[0].must_equal lote
		end
		it "posso setar mais que 1 lote" do
			lote2 = FactoryGirl.build(:remessa_lote)
			subject.lotes = [lote, lote2]
			subject.lotes.size.must_equal 2
			subject.lotes.is_a?(Array).must_equal true
			subject.lotes[0].must_equal lote
			subject.lotes[1].must_equal lote2
		end

		it "posso incrementar os lotes com <<" do
			lote2 = FactoryGirl.build(:remessa_lote)
			subject.lotes = lote
			subject.lotes.size.must_equal 1
			subject.lotes << lote2
			subject.lotes.size.must_equal 2
			subject.lotes.is_a?(Array).must_equal true
			subject.lotes[0].must_equal lote
			subject.lotes[1].must_equal lote2
		end
	end

	describe "#data_hora_arquivo" do
		it "se for nil deve pegar o time now" do
			subject.data_hora_arquivo = nil
			now = Time.now
			Time.stubs(:now).returns(now)
			subject.data_hora_arquivo.must_equal now
		end
		it "se passar um date_time deve converter para time" do
			now = DateTime.now
			subject.data_hora_arquivo = now
			subject.data_hora_arquivo.must_equal now.to_time
		end
	end

	describe "#data_geracao" do
		it "deve pegar a data com 8 posições do atributo data_hora_arquivo" do
			subject.data_hora_arquivo = Time.parse("30/12/2015 01:02:03")
			subject.data_geracao.must_equal "30122015"
		end
	end

	describe "#hora_geracao" do
		it "deve pegar a hora minuto e segundo da data_hora_arquivo" do
			subject.data_hora_arquivo = Time.parse("30/12/2015 01:02:03")
			subject.hora_geracao.must_equal "010203"
		end
	end

	describe "#segmento_p_numero_do_documento" do
		it "deve pegar o numero_documento do pagamento do parametro e ajustar para 15 caracateres" do
			pagamento.numero_documento = '123456'
			subject.segmento_p_numero_do_documento(pagamento).must_equal '123456'.rjust(15, '0')
		end
	end

	context "metodos que devem ser sobrescritos para cada banco" do
		it "#complemento_header_arquivo" do
			assert_raises NotImplementedError do
				subject.complemento_header_arquivo
			end
		end

		it "#convenio_lote" do
			assert_raises NotImplementedError do
				subject.convenio_lote(lote)
			end
		end

		it "#informacoes_da_conta" do
			assert_raises NotImplementedError do
				subject.informacoes_da_conta
			end
		end

		it "#codigo_convenio" do
			assert_raises NotImplementedError do
				subject.codigo_convenio
			end
		end
	end

	context "#complemento_trailer_lote" do
		it "deve ter 217 caracteres em branco por padrão" do
			subject.complemento_trailer_lote(nil, nil).must_equal ''.rjust(217, ' ')
		end
	end
	
	context "MONTAGEM DO ARQUIVO " do
		before do
			# Stub nos metodos que devem ser sobrescritos nos bancos
			subject.stubs(:complemento_header_arquivo).returns(      ''.rjust(29, ' '))
			subject.stubs(:versao_layout_arquivo).returns(   '081')
			subject.stubs(:versao_layout_lote).returns(      '040')
			subject.stubs(:convenio_lote).returns(           ''.rjust(20, ' '))
			subject.stubs(:nome_banco).returns(              'NOMEBANCO'.ljust(30, ' '))
			subject.stubs(:codigo_banco).returns(            '123')
			subject.stubs(:informacoes_da_conta).returns(    ''.rjust(20, ' '))
			subject.stubs(:codigo_convenio).returns(         ''.rjust(20, ' '))
			subject.stubs(:digito_agencia).returns(          '1')
			subject.stubs(:complemento_p).returns(           ''.rjust(34, ' '))
		end
		describe "#dados_do_arquivo#" do
			let(:lote_2) { FactoryGirl.build(:remessa_lote) } 
			before do
				subject.lotes = [lote, lote_2]
			end
			it "se não for valido deve retornar nil" do
				subject.stubs(:valid?).returns(false)
				subject.dados_do_arquivo.must_be_nil
			end
			it "o valor do metodo monta_header_arquivo deve estar nas primeiras posições" do
				subject.expects(:monta_header_arquivo).returns("TESTE_HEADER_ARQUIVO")
				subject.dados_do_arquivo[0..19].must_equal "TESTE_HEADER_ARQUIVO"
			end
			context "deve montar o lote para cada um dos lotes e devem vir depois da montagem do header_arquivo" do
				it "com 2 lotes" do
					subject.stubs(:monta_header_arquivo).returns("1234567890")
					subject.expects(:monta_lote).with(lote, 1).returns(["LOTE_lote_1"])
					subject.expects(:monta_lote).with(lote_2, 2).returns(["LOTE_lote_2"])
					resultado = subject.dados_do_arquivo
					resultado[10..21].must_equal "\nLOTE_LOTE_1"
					resultado[22..33].must_equal "\nLOTE_LOTE_2"
				end

				it "com 1 lote" do
					subject.lotes = lote
					subject.stubs(:monta_header_arquivo).returns("1234567890")
					subject.expects(:monta_lote).with(lote, 1).returns(["LOTE_lote_1"])
					resultado = subject.dados_do_arquivo
					resultado[10..21].must_equal "\nLOTE_LOTE_1"
				end
			end

			it "deve chamar o metodo monta_trailer_arquivo passando o total de lotes e o contador de registros do lote" do
				subject.stubs(:monta_header_arquivo).returns("1234567890")
				subject.stubs(:monta_lote).with(lote, 1).returns(["LOTE_LOTE01234_1", "PARTE 2"])
				subject.stubs(:monta_lote).with(lote_2, 2).returns(["LOTE_LOTE01234_2", "PARTE 2"])
				subject.expects(:monta_trailer_arquivo).with(2, 6).returns("TRAILER_DO_LOTE")
				resultado = subject.dados_do_arquivo
				resultado[10..26].must_equal "\nLOTE_LOTE01234_1"
				resultado[27..34].must_equal "\nPARTE 2"
				resultado[35..51].must_equal "\nLOTE_LOTE01234_2"
				resultado[52..59].must_equal "\nPARTE 2"
				resultado[60..75].must_equal "\nTRAILER_DO_LOTE"
				resultado.size.must_equal 76
			end
		end
		describe "#monta_lote" do
			it "se o lote for inválido deve retornar nil" do
				lote.stubs(:valid?).returns(false)
				subject.monta_lote(lote, 1).must_be_nil
			end
			it "deve retornar um vetor com 6 posições" do
				resultado = subject.monta_lote(lote, 123)
				resultado.is_a?(Array).must_equal true
				resultado.size.must_equal 6
			end
			context "1 - Primeira posição do vetor" do
				it "deve ter o conteudo do metodo monta_header_lote" do
					subject.expects(:monta_header_lote).with(lote, 123).returns("RESULTADO_HEADER_LOTE")
					resultado = subject.monta_lote(lote, 123)
					resultado[0].must_equal "RESULTADO_HEADER_LOTE"
				end
			end
			context "2 - Segunda posição do vetor" do
				it "deve ter o conteudo do metodo monta_segmento_p passando o pagamento, nro_lote e o contador" do
					lote.pagamentos = pagamento
					subject.stubs(:monta_header_lote).with(lote, 123).returns("RESULTADO_HEADER_LOTE")
					subject.expects(:monta_segmento_p).with(pagamento, 123, 1).returns("RESULTADO_SEGMENTO_P")
					resultado = subject.monta_lote(lote, 123)
					resultado[1].must_equal "RESULTADO_SEGMENTO_P"
				end
				it "Se o lote tiver 2 pagamentos deve setar o segmento_p na posição 1 e 5" do
					pagamento_2 = FactoryGirl.build(:remessa_pagamento)
					lote.pagamentos = [pagamento, pagamento_2]
					subject.stubs(:monta_header_lote).with(lote, 123).returns("RESULTADO_HEADER_LOTE")
					subject.expects(:monta_segmento_p).with(pagamento,   123, 1).returns("RESULTADO_SEGMENTO_P_2")
					subject.expects(:monta_segmento_p).with(pagamento_2, 123, 5).returns("RESULTADO_SEGMENTO_P_6")
					resultado = subject.monta_lote(lote, 123)
					resultado[1].must_equal "RESULTADO_SEGMENTO_P_2"
					resultado[5].must_equal "RESULTADO_SEGMENTO_P_6"
				end
			end
			context "3 - Terceira posição do vetor" do
				it "deve ter o conteudo do metodo monta_segmento_q passando o pagamento, nro_lote e o contador" do
					subject.stubs(:monta_header_lote).with(lote, 55).returns("RESULTADO_HEADER_LOTE")
					subject.stubs(:monta_segmento_p).with(pagamento,   55, 1).returns("RESULTADO_SEGMENTO_P")
					subject.expects(:monta_segmento_q).with(pagamento, 55, 2).returns("RESULTADO_SEGMENTO_Q")
					resultado = subject.monta_lote(lote, 55)
					resultado[2].must_equal "RESULTADO_SEGMENTO_Q"
				end
				it "Se o lote tiver 2 pagamentos deve setar o segmento_q na posição 3 e 7" do
					pagamento_2 = FactoryGirl.build(:remessa_pagamento)
					lote.pagamentos = [pagamento, pagamento_2]
					subject.stubs(:monta_header_lote).with(lote, 55).returns("RESULTADO_HEADER_LOTE")
					subject.stubs(:monta_segmento_p).with(pagamento,      55, 1).returns("RESULTADO_SEGMENTO_P")
					subject.stubs(:monta_segmento_p).with(pagamento_2,    55, 5).returns("RESULTADO_SEGMENTO_P")
					subject.expects(:monta_segmento_q).with(pagamento,    55, 2).returns("RESULTADO_SEGMENTO_Q_3")
					subject.expects(:monta_segmento_q).with(pagamento_2,  55, 6).returns("RESULTADO_SEGMENTO_Q_7")
					resultado = subject.monta_lote(lote, 55)
					resultado[2].must_equal "RESULTADO_SEGMENTO_Q_3"
					resultado[6].must_equal "RESULTADO_SEGMENTO_Q_7"
				end
			end

			context "4 - Quarta posição do vetor" do
				it "deve ter o conteudo do metodo monta_segmento_r passando o pagamento, nro_lote e o contador" do
					subject.stubs(:monta_header_lote).with(lote, 55).returns("RESULTADO_HEADER_LOTE")
					subject.stubs(:monta_segmento_p).with(pagamento,   55, 1).returns("RESULTADO_SEGMENTO_P")
					subject.stubs(:monta_segmento_q).with(pagamento,   55, 2).returns("RESULTADO_SEGMENTO_Q")
					subject.expects(:monta_segmento_r).with(pagamento, 55, 3).returns("RESULTADO_SEGMENTO_R")
					resultado = subject.monta_lote(lote, 55)
					resultado[3].must_equal "RESULTADO_SEGMENTO_R"
				end
				it "Se o lote tiver 2 pagamentos deve setar o segmento_r na posição 4 e 8" do
					pagamento_2 = FactoryGirl.build(:remessa_pagamento)
					lote.pagamentos = [pagamento, pagamento_2]
					subject.stubs(:monta_header_lote).with(lote, 55).returns("RESULTADO_HEADER_LOTE")
					subject.stubs(:monta_segmento_p).with(pagamento,      55, 1).returns("RESULTADO_SEGMENTO_P")
					subject.stubs(:monta_segmento_p).with(pagamento_2,    55, 5).returns("RESULTADO_SEGMENTO_P")
					subject.stubs(:monta_segmento_q).with(pagamento,      55, 2).returns("RESULTADO_SEGMENTO_Q")
					subject.stubs(:monta_segmento_q).with(pagamento_2,    55, 6).returns("RESULTADO_SEGMENTO_Q")
					subject.expects(:monta_segmento_r).with(pagamento,    55, 3).returns("RESULTADO_SEGMENTO_R_4")
					subject.expects(:monta_segmento_r).with(pagamento_2,  55, 7).returns("RESULTADO_SEGMENTO_R_8")
					resultado = subject.monta_lote(lote, 55)
					resultado[3].must_equal "RESULTADO_SEGMENTO_R_4"
					resultado[7].must_equal "RESULTADO_SEGMENTO_R_8"
				end
			end

			context "5 - Quinta posição do vetor" do
				it "deve ter o conteudo do metodo monta_segmento_s passando o pagamento, nro_lote e o contador" do
					subject.stubs(:monta_header_lote).with(lote, 55).returns("RESULTADO_HEADER_LOTE")
					subject.stubs(:monta_segmento_p).with(pagamento,   55, 1).returns("RESULTADO_SEGMENTO_P")
					subject.stubs(:monta_segmento_q).with(pagamento,   55, 2).returns("RESULTADO_SEGMENTO_Q")
					subject.stubs(:monta_segmento_r).with(pagamento,   55, 3).returns("RESULTADO_SEGMENTO_R")
					subject.expects(:monta_segmento_s).with(pagamento, 55, 4).returns("RESULTADO_SEGMENTO_S")
					resultado = subject.monta_lote(lote, 55)
					resultado[4].must_equal "RESULTADO_SEGMENTO_S"
				end
				it "Se o lote tiver 2 pagamentos deve setar o monta_segmento_s na posição 5 e 9" do
					pagamento_2 = FactoryGirl.build(:remessa_pagamento)
					lote.pagamentos = [pagamento, pagamento_2]
					subject.stubs(:monta_header_lote).with(lote, 55).returns("RESULTADO_HEADER_LOTE")
					subject.stubs(:monta_segmento_p).with(pagamento,      55, 1).returns("RESULTADO_SEGMENTO_P")
					subject.stubs(:monta_segmento_p).with(pagamento_2,    55, 5).returns("RESULTADO_SEGMENTO_P")
					subject.stubs(:monta_segmento_q).with(pagamento,      55, 2).returns("RESULTADO_SEGMENTO_Q")
					subject.stubs(:monta_segmento_q).with(pagamento_2,    55, 6).returns("RESULTADO_SEGMENTO_Q")
					subject.stubs(:monta_segmento_r).with(pagamento,      55, 3).returns("RESULTADO_SEGMENTO_R")
					subject.stubs(:monta_segmento_r).with(pagamento_2,    55, 7).returns("RESULTADO_SEGMENTO_R")
					subject.expects(:monta_segmento_s).with(pagamento,    55, 4).returns("RESULTADO_SEGMENTO_S_5")
					subject.expects(:monta_segmento_s).with(pagamento_2,  55, 8).returns("RESULTADO_SEGMENTO_S_9")
					resultado = subject.monta_lote(lote, 55)
					resultado[4].must_equal "RESULTADO_SEGMENTO_S_5"
					resultado[8].must_equal "RESULTADO_SEGMENTO_S_9"
				end
			end

			context "6 - Sexta posição do vetor" do
				it "deve ter o conteudo do metodo monta_trailer_lote passando o nro_lote e o contador" do
					subject.stubs(:monta_header_lote).with(lote, 55).returns("RESULTADO_HEADER_LOTE")
					subject.stubs(:monta_segmento_p).with(pagamento, 55, 1).returns("RESULTADO_SEGMENTO_P")
					subject.stubs(:monta_segmento_q).with(pagamento, 55, 2).returns("RESULTADO_SEGMENTO_Q")
					subject.stubs(:monta_segmento_r).with(pagamento, 55, 3).returns("RESULTADO_SEGMENTO_R")
					subject.stubs(:monta_segmento_s).with(pagamento, 55, 4).returns("RESULTADO_SEGMENTO_S")
					subject.expects(:monta_trailer_lote).with(lote,  55, 6).returns("RESULTADO_TRAILER_LOTE")
					resultado = subject.monta_lote(lote, 55)
					resultado[5].must_equal "RESULTADO_TRAILER_LOTE"
				end
				it "Se o lote tiver 2 pagamentos deve setar o monta_trailer_lote 10" do
					pagamento_2 = FactoryGirl.build(:remessa_pagamento)
					lote.pagamentos = [pagamento, pagamento_2]
					subject.stubs(:monta_header_lote).with(lote, 55).returns("RESULTADO_HEADER_LOTE")
					subject.stubs(:monta_segmento_p).with(pagamento,      55, 1).returns("RESULTADO_SEGMENTO_P")
					subject.stubs(:monta_segmento_p).with(pagamento_2,    55, 5).returns("RESULTADO_SEGMENTO_P")
					subject.stubs(:monta_segmento_q).with(pagamento,      55, 2).returns("RESULTADO_SEGMENTO_Q")
					subject.stubs(:monta_segmento_q).with(pagamento_2,    55, 6).returns("RESULTADO_SEGMENTO_Q")
					subject.stubs(:monta_segmento_r).with(pagamento,      55, 3).returns("RESULTADO_SEGMENTO_R")
					subject.stubs(:monta_segmento_r).with(pagamento_2,    55, 7).returns("RESULTADO_SEGMENTO_R")
					subject.stubs(:monta_segmento_s).with(pagamento,      55, 4).returns("RESULTADO_SEGMENTO_S_5")
					subject.stubs(:monta_segmento_s).with(pagamento_2,    55, 8).returns("RESULTADO_SEGMENTO_S_9")
					subject.expects(:monta_trailer_lote).with(lote,       55, 10).returns("RESULTADO_TRAILER_LOTE")
					resultado = subject.monta_lote(lote, 55)
					resultado[9].must_equal "RESULTADO_TRAILER_LOTE"
				end
			end

			context "remoção de caracteres especiais" do
				it "deve remover" do
					subject.stubs(:monta_header_arquivo).returns("AÇÃOíóú")
					subject.dados_do_arquivo[0..6].must_equal "ACAOIOU"
				end
			end
		end
		context "Tamanho de caracteres" do
			it "para monta_header_arquivo deve ter 240 caracteres" do
				subject.monta_header_arquivo.size.must_equal 240
			end
			it "para monta_lote deve ter 1440 caracteres" do
				subject.monta_lote(lote,1).join("").size.must_equal 1440
			end

			it "para monta_header_lote deve ter 240 caracteres" do
				subject.monta_header_lote(lote, 1).size.must_equal 240
			end

			it "para monta_segmento_p deve ter 240 caracteres" do
				subject.monta_segmento_p(pagamento, 1, 2).size.must_equal 240
			end

			it "para monta_segmento_q deve ter 240 caracteres" do
				subject.monta_segmento_q(pagamento, 1, 2).size.must_equal 240
			end

			# Para o segmento R e S esse teste é feito dentro dos modules

			it "para monta_trailer_lote deve ter 240 caracteres" do
				subject.monta_trailer_lote(lote, 1, 2).size.must_equal 240
			end
			it "para monta_trailer_arquivo deve ter 240 caracteres" do
				subject.monta_trailer_arquivo(1, 2).size.must_equal 240
			end
			it "o total de caracteres do arquivo para 1 pagamento deve ser de 1445 caracteres" do
				# 1440 são das montagens e 5 caracteres são das quebras de linha (\n)
				subject.dados_do_arquivo.size.must_equal 1927
			end
		end
	end
	
end