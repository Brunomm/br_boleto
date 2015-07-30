require 'test_helper'
require 'br_boleto/remessa/cnab240/helper/header_arquivo_test'
require 'br_boleto/remessa/cnab240/helper/header_lote_test'
require 'br_boleto/remessa/cnab240/helper/segmento_p_test'
require 'br_boleto/remessa/cnab240/helper/segmento_q_test'
require 'br_boleto/remessa/cnab240/helper/trailer_arquivo_test'
require 'br_boleto/remessa/cnab240/helper/trailer_lote_test'

describe BrBoleto::Remessa::Cnab240::Base do
	subject { FactoryGirl.build(:remessa_cnab240_base, pagamentos: pagamento) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento) } 

	context "validations" do
		it { must validate_presence_of(:documento_cedente) }
		it { must validate_presence_of(:convenio) }

		it { must validate_length_of(:codigo_carteira    ).is_equal_to(1).with_message("deve ter 1 dígito.") }
		it { must validate_length_of(:forma_cadastramento).is_equal_to(1).with_message("deve ter 1 dígito.") }
		it { must validate_length_of(:emissao_boleto     ).is_equal_to(1).with_message("deve ter 1 dígito.") }
		it { must validate_length_of(:distribuicao_boleto).is_equal_to(1).with_message("deve ter 1 dígito.") }
		it { must validate_length_of(:especie_titulo     ).is_equal_to(2).with_message("deve ter 2 dígitos.") }
	end

	describe "#default_values" do
		it "for codigo_carteira" do	
			object = subject.class.new()
			object.codigo_carteira.must_equal '1'
		end
		it "for forma_cadastramento" do	
			object = subject.class.new()
			object.forma_cadastramento.must_equal '1'
		end
		it "deve continuar com o default da superclass" do
			object = subject.class.new()
			object.aceite.must_equal 'N'
		end
	end

	describe "#tipo_inscricao" do
		it "se for cpf deve retornar 1" do
			subject.documento_cedente = '12345678901'
			subject.tipo_inscricao.must_equal '1'
		end
		it "se for cnpj deve retornar 2" do
			subject.documento_cedente = '12345678901234'
			subject.tipo_inscricao.must_equal '2'
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
		it "deve pegar o nosso_numero do pagamento do parametro e ajustar para 15 caracateres" do
			pagamento.nosso_numero = '123456'
			subject.segmento_p_numero_do_documento(pagamento).must_equal '123456'.rjust(15, '0')
		end
	end

	context "metodos que devem ser sobrescritos para cada banco" do
		it "#complemento_header" do
			assert_raises NotImplementedError do
				subject.complemento_header
			end
		end

		it "#versao_layout_do_arquivo" do
			assert_raises NotImplementedError do
				subject.versao_layout_do_arquivo
			end
		end

		it "#versao_layout_lote" do
			assert_raises NotImplementedError do
				subject.versao_layout_lote
			end
		end

		it "#convenio_lote" do
			assert_raises NotImplementedError do
				subject.convenio_lote
			end
		end

		it "#nome_banco" do
			assert_raises NotImplementedError do
				subject.nome_banco
			end
		end

		it "#codigo_banco" do
			assert_raises NotImplementedError do
				subject.codigo_banco
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

		it "#digito_agencia" do
			assert_raises NotImplementedError do
				subject.digito_agencia
			end
		end
	end

	context "#complemento_trailer_lote" do
		it "deve ter 217 caracteres em branco por padrão" do
			subject.complemento_trailer_lote.must_equal ''.rjust(217, ' ')
		end
	end
	context "TESTE DAS PARTES DO ARQUIVO" do
		# Em cada banco pode incluir esses modules para testar sobrescrevendo os testes específicos
		
		include Helper::HeaderArquivoTest
		include Helper::HeaderLoteTest
		include Helper::SegmentoPTest
		include Helper::SegmentoQTest
		include Helper::TrailerArquivoTest
		include Helper::TrailerLoteTest
	end
	context "MONTAGEM DO ARQUIVO " do
		

		before do
			# Stub nos metodos que devem ser sobrescritos nos bancos
			subject.stubs(:complemento_header).returns(      'complemento_header')
			subject.stubs(:versao_layout_do_arquivo).returns('versao_layout_do_arquivo')
			subject.stubs(:versao_layout_lote).returns(      'versao_layout_lote')
			subject.stubs(:convenio_lote).returns(           'convenio_lote')
			subject.stubs(:nome_banco).returns(              'nome_banco')
			subject.stubs(:codigo_banco).returns(            'codigo_banco')
			subject.stubs(:informacoes_da_conta).returns(    'informacoes_da_conta')
			subject.stubs(:codigo_convenio).returns(         'codigo_convenio')
			subject.stubs(:digito_agencia).returns(          'digito_agencia')
			subject.stubs(:complemento_p).returns(           'complemento_p')
		end
		describe "#gera_arquivo#" do
			let(:pagamento_2) { FactoryGirl.build(:remessa_pagamento, valor_documento: 9_999_999.88) } 
			before do
				subject.pagamentos = [pagamento, pagamento_2]
			end
			it "se não for valido deve retornar nil" do
				subject.stubs(:valid?).returns(false)
				subject.gera_arquivo.must_be_nil
			end
			it "o valor do metodo monta_header_arquivo deve estar nas primeiras posições" do
				subject.expects(:monta_header_arquivo).returns("TESTE_HEADER_ARQUIVO")
				subject.gera_arquivo[0..19].must_equal "TESTE_HEADER_ARQUIVO"
			end
			context "deve montar o lote para cada um dos pagamentos e devem vir depois da montagem do header_arquivo" do
				it "com 2 pagamentos" do
					subject.stubs(:monta_header_arquivo).returns("1234567890")
					subject.expects(:monta_lote).with(pagamento, 1).returns(["LOTE_PAGAMENTO_1"])
					subject.expects(:monta_lote).with(pagamento_2, 2).returns(["LOTE_PAGAMENTO_2"])
					resultado = subject.gera_arquivo
					resultado[10..26].must_equal "\nLOTE_PAGAMENTO_1"
					resultado[27..43].must_equal "\nLOTE_PAGAMENTO_2"				
				end

				it "com 1 pagamento" do
					subject.pagamentos = pagamento
					subject.stubs(:monta_header_arquivo).returns("1234567890")
					subject.expects(:monta_lote).with(pagamento, 1).returns(["LOTE_PAGAMENTO_1"])
					resultado = subject.gera_arquivo
					resultado[10..26].must_equal "\nLOTE_PAGAMENTO_1"
				end
			end

			it "deve chamar o metodo monta_trailer_arquivo passando o total de pagamentos e o contador de registros do lote" do
				subject.stubs(:monta_header_arquivo).returns("1234567890")
				subject.stubs(:monta_lote).with(pagamento, 1).returns(["LOTE_PAGAMENTO_1", "PARTE 2"])
				subject.stubs(:monta_lote).with(pagamento_2, 2).returns(["LOTE_PAGAMENTO_2", "PARTE 2"])
				subject.expects(:monta_trailer_arquivo).with(2, 6).returns("TRAILER_DO_LOTE")
				resultado = subject.gera_arquivo
				resultado[10..26].must_equal "\nLOTE_PAGAMENTO_1"
				resultado[27..34].must_equal "\nPARTE 2"
				resultado[35..51].must_equal "\nLOTE_PAGAMENTO_2"
				resultado[52..59].must_equal "\nPARTE 2"
				resultado[60..75].must_equal "\nTRAILER_DO_LOTE"
				resultado.size.must_equal 76
			end
		end
		describe "#monta_lote" do
			it "se o pagamento for inválido deve retornar nil" do
				pagamento.stubs(:valid?).returns(false)
				subject.monta_lote(pagamento, 1).must_be_nil
			end
			it "deve retornar um vetor com 4 posições" do
				resultado = subject.monta_lote(pagamento, 123)
				resultado.is_a?(Array).must_equal true
				resultado.size.must_equal 4
			end
			context "1 - Primeira posição do vetor" do
				it "deve ter o conteudo do metodo monta_header_lote" do
					subject.expects(:monta_header_lote).with(123).returns("RESULTADO_HEADER_LOTE")
					resultado = subject.monta_lote(pagamento, 123)
					resultado[0].must_equal "RESULTADO_HEADER_LOTE"
				end
			end
			context "2 - Segunda posição do vetor" do
				it "deve ter o conteudo do metodo monta_segmento_p passando o pagamento, nro_lote e o contador" do
					subject.stubs(:monta_header_lote).with(123).returns("RESULTADO_HEADER_LOTE")
					subject.expects(:monta_segmento_p).with(pagamento, 123, 2).returns("RESULTADO_SEGMENTO_P")
					resultado = subject.monta_lote(pagamento, 123)
					resultado[1].must_equal "RESULTADO_SEGMENTO_P"
				end
			end
			context "3 - Terceira posição do vetor" do
				it "deve ter o conteudo do metodo monta_segmento_q passando o pagamento, nro_lote e o contador" do
					subject.stubs(:monta_header_lote).with(55).returns("RESULTADO_HEADER_LOTE")
					subject.stubs(:monta_segmento_p).with(pagamento, 55, 2).returns("RESULTADO_SEGMENTO_P")
					subject.expects(:monta_segmento_q).with(pagamento, 55, 3).returns("RESULTADO_SEGMENTO_Q")
					resultado = subject.monta_lote(pagamento, 55)
					resultado[2].must_equal "RESULTADO_SEGMENTO_Q"
				end
			end

			context "4 - Quarta posição do vetor" do
				it "deve ter o conteudo do metodo monta_trailer_lote passando o nro_lote e o contador" do
					subject.stubs(:monta_header_lote).with(55).returns("RESULTADO_HEADER_LOTE")
					subject.stubs(:monta_segmento_p).with(pagamento, 55, 2).returns("RESULTADO_SEGMENTO_P")
					subject.stubs(:monta_segmento_q).with(pagamento, 55, 3).returns("RESULTADO_SEGMENTO_Q")
					subject.expects(:monta_trailer_lote).with(55, 4).returns("RESULTADO_TRAILER_LOTE")
					resultado = subject.monta_lote(pagamento, 55)
					resultado[3].must_equal "RESULTADO_TRAILER_LOTE"
				end
			end
		end
	end
	
end