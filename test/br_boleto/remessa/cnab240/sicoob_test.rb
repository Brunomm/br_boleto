require 'test_helper'

describe BrBoleto::Remessa::Cnab240::Sicoob do
	subject { FactoryGirl.build(:remessa_cnab240_sicoob, lotes: lote) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento, valor_documento: 100.00) } 
	let(:lote) { FactoryGirl.build(:remessa_lote, pagamentos: pagamento) } 

	it "deve herdar da class Base" do
		subject.class.superclass.must_equal BrBoleto::Remessa::Cnab240::Base
	end

	context "validations" do
		it { must validate_presence_of(:modalidade_carteira) }
		it { must validate_presence_of(:tipo_formulario) }
		it { must validate_presence_of(:parcela) }
		it { must validate_presence_of(:conta_corrente) }
		# Segundo a documentação do Sicoob o convênio deve ter 20 caracteres em branco
		# Então ele não pode ser obrigatorio
		it { wont validate_presence_of(:convenio) } 

		it { must validate_length_of(:conta_corrente     ).is_at_most(12).with_message("deve ter no máximo 12 dígitos.") }
		it { must validate_length_of(:agencia            ).is_equal_to(4).with_message("deve ter 4 dígitos.") }
		it { must validate_length_of(:modalidade_carteira).is_equal_to(2).with_message("deve ter 2 dígitos.") }
	end

	describe "conveio" do
		it "por padrão tem 20 caracteres em branco" do
			subject.convenio = nil
			subject.convenio.must_equal "".rjust(20, ' ')
		end

		it "deve ser possivel setar um valor" do
			subject.convenio = "123"
			subject.convenio.must_equal "123".ljust(20, " ")
		end
	end

	describe "#default_values" do
		it "for emissao_boleto" do	
			object = subject.class.new()
			object.emissao_boleto.must_equal '2'
		end

		it "for distribuicao_boleto" do	
			object = subject.class.new()
			object.distribuicao_boleto.must_equal '2'
		end

		it "for especie_titulo" do	
			object = subject.class.new()
			object.especie_titulo.must_equal '02'
		end

		it "for tipo_formulario" do	
			object = subject.class.new()
			object.tipo_formulario.must_equal '4'
		end

		it "for parcela" do	
			object = subject.class.new()
			object.parcela.must_equal '01'
		end

		it "for modalidade_carteira" do	
			object = subject.class.new()
			object.modalidade_carteira.must_equal '01'
		end

		context "Deve sobrescrever os campos default se houver algum igual" do
			it "forma_cadastramento deve ser sobrescrita" do	
				object = subject.class.new()
				object.forma_cadastramento.must_equal '0' # Na classe base é '1'
			end
		end
		context "deve manter os defaults da classe Base" do
			it "for codigo_carteira" do	
				object = subject.class.new()
				object.codigo_carteira.must_equal '1'
			end
			it "deve continuar com o default da superclass" do
				object = subject.class.new()
				object.aceite.must_equal 'N'
			end
		end
	end

	it "codigo_banco deve ser 756" do
		subject.codigo_banco.must_equal '756'
	end

	it "metodo nome_banco deve retornar SICOOB com 30 posições" do
		subject.nome_banco.must_equal 'SICOOB'.ljust(30, ' ')
	end

	it "metodo versao_layout_arquivo deve retornar 081" do
		subject.versao_layout_arquivo.must_equal '081'
	end

	it "metodo versao_layout_lote deve retornar 040" do
		subject.versao_layout_lote.must_equal '040'
	end

	it "o digito_agencia deve calcular o modulo11 de 2 a 9 com resto zero " do
		subject.agencia = '33'
		BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.expects(:new).with('33').returns(1)
		subject.digito_agencia.must_equal '1'
	end
	
	it "o digito_conta deve calcular o modulo11 de 2 a 9 com resto zero " do
		subject.conta_corrente = '34'
		BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.expects(:new).with('34').returns(1)
		subject.digito_conta.must_equal '1'
	end

	it "o codigo_convenio deve ter 20 posições em branco" do
		subject.codigo_convenio.must_equal ''.rjust(20, ' ')
	end

	it "o convenio_lote deve ser o mesmo valor que o codigo_convenio" do
		subject.stubs(:convenio_lote).returns('qqcoisa')
		subject.convenio_lote.must_equal "qqcoisa"
	end

	describe "#informacoes_da_conta" do
		it "deve ter 20 posições" do
			subject.informacoes_da_conta.size.must_equal 20
		end
		context "1 Primeira parte = agencia 5 posicoes" do
			it "se for menor que 5 deve preencher com zero" do
				subject.agencia = '123'
				subject.informacoes_da_conta[0..4].must_equal '00123'
			end
			it "quando agencia tiver as 5 posições" do
				subject.agencia = '12345'
				subject.informacoes_da_conta[0..4].must_equal '12345'
			end
		end

		context "2 - Segunda parte = digito_agencia" do
			it "deve pegar o digito da agencia" do
				subject.expects(:digito_agencia).returns("&")
				subject.informacoes_da_conta[5].must_equal "&"
			end
		end

		context "3 - Terceira parte = conta_corrente com 12 posições" do
			it "se tiver menos que 12 caracteres deve preencher com zero" do
				subject.stubs(:digito_conta)
				subject.expects(:conta_corrente).returns("123456")
				subject.informacoes_da_conta[6..17].must_equal "123456".rjust(12, '0')
			end
			it "se tiver 12 caracteres deve manter" do
				subject.stubs(:digito_conta)
				subject.expects(:conta_corrente).returns("".rjust(12, '1'))
				subject.informacoes_da_conta[6..17].must_equal "1".rjust(12, '1')
			end
		end

		context "4 - Quarta parte = digito_conta" do
			it "deve buscar o valor do metodo digito_conta" do
				subject.expects(:digito_conta).returns('*')
				subject.informacoes_da_conta[18].must_equal('*')
			end
		end
	end

	describe "#complemento_header_arquivo" do
		it "deve ter 29 posições em branco" do
			subject.complemento_header_arquivo.must_equal ''.rjust(29, ' ')
		end
	end

	describe "#complemento_trailer_lote" do
		let(:pagamento_2) { FactoryGirl.build(:remessa_pagamento, valor_documento: 50.25) } 
		it "deve carregar os dados dos metodos complemento_trailer_lote na sequencia" do
			subject.stubs(:complemento_trailer_lote_posicao_024_a_029).with(lote).returns(" 024_a_029")
			subject.stubs(:complemento_trailer_lote_posicao_030_a_046).with(lote).returns(" 030_a_046")
			subject.stubs(:complemento_trailer_lote_posicao_047_a_052).with(lote).returns(" 047_a_052")
			subject.stubs(:complemento_trailer_lote_posicao_053_a_069).with(lote).returns(" 053_a_069")
			subject.stubs(:complemento_trailer_lote_posicao_070_a_075).with(lote).returns(" 070_a_075")
			subject.stubs(:complemento_trailer_lote_posicao_076_a_092).with(lote).returns(" 076_a_092")
			subject.stubs(:complemento_trailer_lote_posicao_093_a_098).with(lote).returns(" 093_a_098")
			subject.stubs(:complemento_trailer_lote_posicao_099_a_115).with(lote).returns(" 099_a_115")
			subject.stubs(:complemento_trailer_lote_posicao_116_a_123).with(lote).returns(" 116_a_123")
			subject.stubs(:complemento_trailer_lote_posicao_124_a_240).returns(" 124_a_240")
			subject.complemento_trailer_lote(lote, 1).must_equal(" 024_A_029 030_A_046 047_A_052 053_A_069 070_A_075 076_A_092 093_A_098 099_A_115 116_A_123 124_A_240")
		end

		before do
			lote.pagamentos << pagamento_2
		end

		describe "#complemento_trailer_lote_posicao_024_a_029" do
			it "se o tipo_cobranca_formatada for simples, então deve contar o total de pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:simples)
				subject.complemento_trailer_lote_posicao_024_a_029(lote).must_equal "2".rjust(6, "0") 
			end 
			it "se o tipo_cobranca_formatada não for simples, então não deve contar o total de pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:caucionada)
				subject.complemento_trailer_lote_posicao_024_a_029(lote).must_equal "".rjust(6, "0") 
			end 
		end

		describe "#complemento_trailer_lote_posicao_030_a_046" do
			it "se o tipo_cobranca_formatada for simples, então deve somar o valor_documento dos pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:simples)
				subject.complemento_trailer_lote_posicao_030_a_046(lote).must_equal "15025".rjust(17, "0") 
			end 
			it "se o tipo_cobranca_formatada não for simples, então não deve somar o valor_documento dos pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:caucionada)
				subject.complemento_trailer_lote_posicao_030_a_046(lote).must_equal "".rjust(17, "0") 
			end 
		end

		describe "#complemento_trailer_lote_posicao_047_a_052" do
			it { subject.complemento_trailer_lote_posicao_047_a_052(lote).must_equal "".rjust(6, "0") }
		end

		describe "#complemento_trailer_lote_posicao_053_a_069" do
			it { subject.complemento_trailer_lote_posicao_053_a_069(lote).must_equal "".rjust(17, "0") }
		end

		describe "#complemento_trailer_lote_posicao_070_a_075" do
			it "se o tipo_cobranca_formatada for caucionada, então deve contar o total de pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:caucionada)
				subject.complemento_trailer_lote_posicao_070_a_075(lote).must_equal "2".rjust(6, "0") 
			end 
			it "se o tipo_cobranca_formatada não for caucionada, então não deve contar o total de pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:simples)
				subject.complemento_trailer_lote_posicao_070_a_075(lote).must_equal "".rjust(6, "0") 
			end 
		end

		describe "#complemento_trailer_lote_posicao_076_a_092" do
			it "se o tipo_cobranca_formatada for caucionada, então deve somar o valor_documento dos pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:caucionada)
				subject.complemento_trailer_lote_posicao_076_a_092(lote).must_equal "15025".rjust(17, "0") 
			end 
			it "se o tipo_cobranca_formatada não for caucionada, então não deve somar o valor_documento dos pagamentos do lote" do
				subject.expects(:tipo_cobranca_formatada).returns(:simples)
				subject.complemento_trailer_lote_posicao_076_a_092(lote).must_equal "".rjust(17, "0") 
			end 
		end

		describe "#complemento_trailer_lote_posicao_093_a_098" do
			it { subject.complemento_trailer_lote_posicao_093_a_098(lote).must_equal "".rjust(6, "0") }
		end

		describe "#complemento_trailer_lote_posicao_099_a_115" do
			it { subject.complemento_trailer_lote_posicao_099_a_115(lote).must_equal "".rjust(17, "0") }
		end

		describe "#complemento_trailer_lote_posicao_116_a_123" do
			it { subject.complemento_trailer_lote_posicao_116_a_123(lote).must_equal "".rjust(8, " ") }
		end
		
		describe "#complemento_trailer_lote_posicao_124_a_240" do
			it { subject.complemento_trailer_lote_posicao_124_a_240.must_equal "".rjust(117, " ") }
		end

	end

	describe "#formata_nosso_numero" do
		it "posicao 0 até 9 deve pegar o nosso_numero passado por parametro e ajustar para 10 posições" do
			subject.formata_nosso_numero(123)[0..9].must_equal "123".rjust(10, '0')
		end
		it "posicao 10 até 11 deve ter o numero da parcela" do
			subject.expects(:parcela).returns("99")
			subject.formata_nosso_numero(1)[10..11].must_equal "99"
		end
		it "posicao 12 até 13 deve ter a modalidade_carteira" do
			subject.expects(:modalidade_carteira).returns("23")
			subject.formata_nosso_numero(1)[12..13].must_equal "23"
		end
		it "posicao 14 deve ter o tipo_formulario" do
			subject.expects(:tipo_formulario).returns("4")
			subject.formata_nosso_numero(1)[14].must_equal "4"
		end
		it "posição 15 até 19 deve ser valor em branco" do
			subject.formata_nosso_numero(123)[15..19].must_equal "".rjust(5, ' ')
		end
		it "deve ajustar a string para no maximo 20 posições" do
			subject.expects(:modalidade_carteira).returns("".rjust(20, "1"))
			subject.formata_nosso_numero(123456).size.must_equal 20
		end
	end

	describe "#complemento_p" do
		it "posicao 0 até 11 deve ter a conta_corrente" do
			subject.stubs(:digito_conta)
			subject.expects(:conta_corrente).returns(123456789)
			subject.complemento_p(pagamento)[0..11].must_equal "000123456789"
		end
		it "posicao 12 deve te o digito_conta" do
			subject.expects(:digito_conta).returns("%")
			subject.complemento_p(pagamento)[12].must_equal "%"
		end
		it "posição 13 deve ser um caracter em branco" do
			subject.complemento_p(pagamento)[13].must_equal " "
		end
		it "posição 14 até 33 deve ter o valor do metodo formata_nosso_numero passando o nosso_numero do pagamento" do
			subject.expects(:formata_nosso_numero).with(pagamento.nosso_numero).returns("12345678901234567890")
			subject.complemento_p(pagamento)[14..33].must_equal '12345678901234567890'
		end
	end

	describe "#dados_do_arquivo" do
		it "deve gerar os dados do arquivo" do
			subject.dados_do_arquivo.size.must_equal 1927
		end
	end

	describe "#tipo_cobranca_formatada" do
		it "deve ser :simples se modalidade_carteira for 01" do
			subject.modalidade_carteira = '01'
			subject.tipo_cobranca_formatada.must_equal :simples
		end
		it "deve ser :simples se modalidade_carteira for 1" do
			subject.modalidade_carteira = 1
			subject.tipo_cobranca_formatada.must_equal :simples
		end
		it "deve ser :simples se modalidade_carteira for 02" do
			subject.modalidade_carteira = '02'
			subject.tipo_cobranca_formatada.must_equal :simples
		end
		it "deve ser :simples se modalidade_carteira for 2" do
			subject.modalidade_carteira = 2
			subject.tipo_cobranca_formatada.must_equal :simples
		end
		it "deve ser :caucionada se modalidade_carteira for 03" do
			subject.modalidade_carteira = '03'
			subject.tipo_cobranca_formatada.must_equal :caucionada
		end
		it "deve ser :caucionada se modalidade_carteira for 3" do
			subject.modalidade_carteira = 3
			subject.tipo_cobranca_formatada.must_equal :caucionada
		end
		it "deve ser nil se modalidade_carteira for outro numero" do
			subject.modalidade_carteira = 4
			subject.tipo_cobranca_formatada.must_be_nil
		end
		it "deve ser nil se modalidade_carteira for nil" do
			subject.modalidade_carteira = nil
			subject.tipo_cobranca_formatada.must_be_nil
		end
	end

	describe "particularidades do Segmento R" do
		describe "#segmento_r_posicao_066_a_066 - Codigo da multa " do
			# Para o Sicoob o código reference a Isento é '0', diferente do padrão
			# estabelecido pela FEBRABAN onde o código de isento é '3'

			it "Se não tiver valor em codigo_multa deve considerar '0'" do
				pagamento.codigo_multa = nil
				subject.send(:segmento_r_posicao_066_a_066, pagamento).must_equal '0'
			end
			it "Se o valor de codigo_multa tiver mais caracteres que 1 deve ajustar para 1 caractere" do
				pagamento.codigo_multa = '123'
				subject.send(:segmento_r_posicao_066_a_066, pagamento).must_equal '1'
			end
			it "se o código da multa do pagamento for '1' então deve permanecer '1'" do
				pagamento.codigo_multa = '1'
				subject.send(:segmento_r_posicao_066_a_066, pagamento).must_equal '1'
			end
			it "se o código da multa do pagamento for '2' então deve permanecer '2'" do
				pagamento.codigo_multa = '2'
				subject.send(:segmento_r_posicao_066_a_066, pagamento).must_equal '2'
			end
			it "se o código da multa do pagamento for diferente de 1 ou 2 então considera '0'" do
				pagamento.codigo_multa = '3'
				subject.send(:segmento_r_posicao_066_a_066, pagamento).must_equal '0'
				pagamento.codigo_multa = '4'
				subject.send(:segmento_r_posicao_066_a_066, pagamento).must_equal '0'
			end
			
		end
		
	end
end