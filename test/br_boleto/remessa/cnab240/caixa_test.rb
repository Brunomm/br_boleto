require 'test_helper'

describe BrBoleto::Remessa::Cnab240::Caixa do
	subject { FactoryGirl.build(:remessa_cnab240_caixa, lotes: lote) }
	let(:pagamento) { FactoryGirl.build(:remessa_pagamento, valor_documento: 879.66) } 
	let(:lote) { FactoryGirl.build(:remessa_lote, pagamentos: pagamento) } 

	# it "deve herdar da class Base" do
	# 	subject.class.superclass.must_equal BrBoleto::Remessa::Cnab240::Base
	# end

	# context "validations" do
	# 	it { must validate_presence_of(:modalidade_carteira) }
	# 	it { must validate_presence_of(:agencia) }
	# 	it { must validate_presence_of(:versao_aplicativo) }
	# 	it { must validate_presence_of(:convenio) }

	# 	it { must validate_length_of(:convenio         ).is_at_most(6).with_message("deve ter no máximo 6 dígitos.") }
	# 	it { must validate_length_of(:versao_aplicativo).is_at_most(4).with_message("deve ter no máximo 4 dígitos.") }
	# 	it { must validate_length_of(:agencia          ).is_at_most(5).with_message("deve ter no máximo 5 dígitos.") }
	# 	it { must validate_length_of(:modalidade_carteira).is_equal_to(2).with_message("deve ter 2 dígitos.") }
	# end

	# describe "#default_values" do
	# 	it "for emissao_boleto" do	
	# 		object = subject.class.new()
	# 		object.emissao_boleto.must_equal '2'
	# 	end

	# 	it "for distribuicao_boleto" do	
	# 		object = subject.class.new()
	# 		object.distribuicao_boleto.must_equal '2'
	# 	end

	# 	it "for especie_titulo" do	
	# 		object = subject.class.new()
	# 		object.especie_titulo.must_equal '02'
	# 	end

	# 	it "for modalidade_carteira" do	
	# 		object = subject.class.new()
	# 		object.modalidade_carteira.must_equal '14'
	# 	end

	# 	it "for forma_cadastramento" do	
	# 		object = subject.class.new()
	# 		object.forma_cadastramento.must_equal '0'
	# 	end

	# 	it "for versao_aplicativo" do	
	# 		object = subject.class.new()
	# 		object.instance_variable_get(:@versao_aplicativo).must_equal '0'
	# 	end

	# 	it "for codigo_carteira" do	
	# 		object = subject.class.new()
	# 		object.codigo_carteira.must_equal '1'
	# 	end

	# 	context "deve manter os defaults da classe Base" do
	# 		it "deve continuar com o default da superclass" do
	# 			object = subject.class.new()
	# 			object.aceite.must_equal 'N'
	# 		end
	# 	end
	# end

	# it "codigo_banco deve ser 104" do
	# 	subject.codigo_banco.must_equal '104'
	# end

	# it "metodo nome_banco deve retornar CAIXA ECONOMICA FEDERAL com 30 posições" do
	# 	subject.nome_banco.must_equal 'CAIXA ECONOMICA FEDERAL'.ljust(30, ' ')
	# end

	# it "metodo versao_layout_arquivo deve retornar 050" do
	# 	subject.versao_layout_arquivo.must_equal '050'
	# end

	# it "metodo versao_layout_lote deve retornar 030" do
	# 	subject.versao_layout_lote.must_equal '030'
	# end

	# describe "#versao_aplicativo" do
	# 	it "se contém algum valor na variavel @versao_aplicativo deve ajustála para 4 posições adicionado zeros a esquerda" do
	# 		subject.instance_variable_set(:@versao_aplicativo, '88')
	# 		subject.versao_aplicativo.must_equal '0088'

	# 		subject.versao_aplicativo = '777'
	# 		subject.versao_aplicativo.must_equal '0777'
	# 	end

	# 	it "se não contém valor na variavel @versao_aplicativo deve retornar nil" do
	# 		subject.instance_variable_set(:@versao_aplicativo, '')
	# 		subject.versao_aplicativo.must_be_nil
	# 	end
	# end

	# it "o digito_agencia deve calcular o modulo11 de 2 a 9 com resto zero " do
	# 	subject.agencia = '33'
	# 	BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.expects(:new).with('33').returns(1)
	# 	subject.digito_agencia.must_equal '1'
	# end
		
	# it "o codigo_convenio deve ter 20 posições com Zeros" do
	# 	subject.codigo_convenio.must_equal '0' * 20
	# end

	# describe "#convenio_lote" do
	# 	it "as 6 primeiras posições deve ser o valor do convenio ajustado com zeros a esquerda" do
	# 		subject.convenio = '88'
	# 		subject.convenio_lote(lote)[0..5].must_equal '000088'

	# 		subject.convenio = '2878'
	# 		subject.convenio_lote(lote)[0..5].must_equal '002878'
	# 	end
	# 	it "as 14 ultimas posições deve ser tudo Zeros" do
	# 		subject.convenio_lote(lote)[6..19].must_equal '00000000000000'
	# 	end
	# 	it "deve ter 20 caracteres" do
	# 		subject.convenio_lote(lote).size.must_equal 20
	# 	end
	# end
	

	# describe "#informacoes_da_conta" do
	# 	it "deve ter 20 posições" do
	# 		subject.informacoes_da_conta.size.must_equal 20
	# 	end

	# 	it "1 - Primeira parte = agencia 5 posicoes - ajustados com zeros a esquerda" do
	# 		subject.agencia = '123'
	# 		subject.informacoes_da_conta[0..4].must_equal '00123'
		
	# 		subject.agencia = '1234'
	# 		subject.informacoes_da_conta[0..4].must_equal '01234'
	# 	end

	# 	it "2 - Segunda parte = digito_agencia" do
	# 		subject.expects(:digito_agencia).returns("&")
	# 		subject.informacoes_da_conta[5].must_equal "&"			
	# 	end

	# 	it "3 - Terceira parte = convenio 6 posicoes - ajustados com zeros a esquerda" do
	# 		subject.convenio = '123'
	# 		subject.informacoes_da_conta[6..11].must_equal '000123'
		
	# 		subject.convenio = '1234'
	# 		subject.informacoes_da_conta[6..11].must_equal '001234'
	# 	end

	# 	it "4 - Quarta parte = Modelo personalizado - Deve ter 7 zeros" do
	# 		subject.informacoes_da_conta[12..18].must_equal('0000000')			
	# 	end

	# 	it "5 - Quinta parte = Exclusivo caixa - Deve ter 1 zero" do
	# 		subject.informacoes_da_conta[19].must_equal('0')			
	# 	end
	# end

	# describe "#complemento_header_arquivo" do
	# 	it "deve ter 29 posições" do
	# 		subject.complemento_header_arquivo.size.must_equal 29
	# 	end

	# 	it "1 - Primeira parte = versao_aplicativo 4 posicoes - ajustados com zeros a esquerda" do
	# 		subject.versao_aplicativo = '12'
	# 		subject.complemento_header_arquivo[0..3].must_equal '0012'
		
	# 		subject.versao_aplicativo = '123'
	# 		subject.complemento_header_arquivo[0..3].must_equal '0123'
	# 	end

	# 	it "2 - Segunda parte = USO FEBRABAN com 25 posições em branco" do
	# 		subject.complemento_header_arquivo[4..28].must_equal ' ' * 25
	# 	end
	# end

	# describe "#complemento_p" do

	# 	it "deve ter 34 posições" do
	# 		subject.complemento_p(pagamento).size.must_equal 34
	# 	end

	# 	it "1 - Primeira parte = convenio com 6 posicoes - ajustados com zeros a esquerda" do
	# 		subject.convenio = '12'
	# 		subject.complemento_p(pagamento)[0..5].must_equal '000012'
		
	# 		subject.convenio = '123'
	# 		subject.complemento_p(pagamento)[0..5].must_equal '000123'
	# 	end
		
	# 	it "2 - Seguna parte = Uso Caixa com 11 posicoes com zeros" do
	# 		subject.complemento_p(pagamento)[6..16].must_equal '0' * 11
	# 	end

	# 	it "3 - Terceira parte = Modalidade carteira com 2 posicoes" do
	# 		subject.modalidade_carteira = '14'
	# 		subject.complemento_p(pagamento)[17..18].must_equal '14'			
	# 		subject.modalidade_carteira = 'XX'
	# 		subject.complemento_p(pagamento)[17..18].must_equal 'XX'
	# 	end

	# 	it "4 - Quarta parte = nosso_numero com 15 posicoes ajustados com zeros a esquerda" do
	# 		pagamento.nosso_numero = '1234567890'
	# 		subject.complemento_p(pagamento)[19..34].must_equal '000001234567890'
	# 		pagamento.nosso_numero = '1234567890123'
	# 		subject.complemento_p(pagamento)[19..34].must_equal '001234567890123'
	# 	end		
	# end

	# describe "#segmento_p_numero_do_documento" do
	# 	it "deve ter 15 posições" do
	# 		subject.segmento_p_numero_do_documento(pagamento).size.must_equal 15
	# 	end

	# 	it "1 - Primeira parte = Nr Doc. cobrança com 11 posicoes - ajustados com zeros a esquerda" do
	# 		pagamento.numero_documento = '123456789'
	# 		subject.segmento_p_numero_do_documento(pagamento)[0..10].must_equal '00123456789'
		
	# 		pagamento.numero_documento = '1234567890'
	# 		subject.segmento_p_numero_do_documento(pagamento)[0..10].must_equal '01234567890'
	# 	end

	# 	it "2 - Segunda parte = Uso da CAIXA com 4 posicoes em branco" do
	# 		subject.segmento_p_numero_do_documento(pagamento)[11..14].must_equal ' ' * 4
	# 	end
	# end


	# describe "#segmento_p_posicao_106_a_106" do
	# 	it "deve ser '0' - diferente do padrão que é um espaço em branco" do
	# 		subject.segmento_p_posicao_106_a_106.must_equal '0'
	# 	end
	# end

	# describe "#segmento_p_posicao_196_a_220" do
	# 	it "deve ter o numero do documento do pagamento com 25 posições ajustados com zero a esquerda" do
	# 		pagamento.numero_documento = '789798'
	# 		subject.segmento_p_posicao_196_a_220(pagamento).must_equal '789798'.rjust(25, '0')

	# 		pagamento.numero_documento = '99'
	# 		subject.segmento_p_posicao_196_a_220(pagamento).must_equal '99'.rjust(25, '0')
	# 	end
	# end

	# describe "#segmento_s_posicao_019_a_020_tipo_impressao_1_ou_2" do
	# 	it "deve conter o valor '00' conforme a docuemntação" do
	# 		subject.segmento_s_posicao_019_a_020_tipo_impressao_1_ou_2(pagamento).must_equal '00'
	# 	end
	# end
	# describe "#segmento_s_posicao_161_a_162_tipo_impressao_1_ou_2" do
	# 	it "deve conter o valor '00' conforme a docuemntação" do
	# 		subject.segmento_s_posicao_161_a_162_tipo_impressao_1_ou_2(pagamento).must_equal '00'
	# 	end
	# end

	# describe "#complemento_trailer_lote" do
	# 	it "deve ter 217 posições" do
	# 		subject.complemento_trailer_lote(lote, 5).size.must_equal 217
	# 	end

	# 	it "1 - Primeira parte = 69 posições todas preenchidas com zeros" do
	# 		subject.complemento_trailer_lote(lote, 5)[0..68].must_equal '0' * 69
	# 	end

	# 	it "2 - Segunda parte = EXCLUSIVO FEBRABAN com 148 posicoes em branco" do
	# 		subject.complemento_trailer_lote(lote, 5)[69..216].must_equal (' ' * 148)
	# 	end
	# end
end