require 'test_helper'

describe BrBoleto::Remessa::Base do
	subject { FactoryBot.build(:conta_base) }

	describe "Validations" do
		it { must validate_presence_of(:agencia) }
		it { must validate_presence_of(:razao_social) }
		it { must validate_presence_of(:cpf_cnpj) }

		context '#endereco' do
			it "por padrão não deve validar nada" do
				subject.endereco = nil
				wont_be_message_error(:endereco)
			end

			context "#valid_endereco_required" do
				it "quando setado deve validar a obrigatoriedade" do
					wont validate_presence_of(:endereco)

					subject.valid_endereco_required = true
					must validate_presence_of(:endereco)
				end
			end
		end

		context "#conta_corrente" do
			it "por padrão não deve validar nada" do
				subject.conta_corrente = nil
				wont_be_message_error(:conta_corrente)
			end

			context "#valid_conta_corrente_required" do
				it "quando setado deve validar a obrigatoriedade" do
					wont validate_presence_of(:conta_corrente)

					subject.valid_conta_corrente_required = true
					must validate_presence_of(:conta_corrente)
				end
			end
			context "#valid_conta_corrente_length" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_conta_corrente_length = 7
					subject.conta_corrente = '12345678'
					must_be_message_error(:conta_corrente, :custom_length_is, {count: 7})
					subject.conta_corrente = '1234567'
					wont_be_message_error(:conta_corrente, :custom_length_is, {count: 7})
				end
			end
			context "#valid_conta_corrente_minimum" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_conta_corrente_minimum = 5
					subject.conta_corrente = '1'
					must_be_message_error(:conta_corrente, :custom_length_minimum, {count: 5})
					subject.conta_corrente = '1234567'
					wont_be_message_error(:conta_corrente, :custom_length_minimum, {count: 5})
				end
			end
			context "#valid_conta_corrente_maximum" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_conta_corrente_maximum = 3
					subject.conta_corrente = '1234'
					must_be_message_error(:conta_corrente, :custom_length_maximum, {count: 3})
					subject.conta_corrente = '123'
					wont_be_message_error(:conta_corrente, :custom_length_maximum, {count: 3})
				end
			end
			context "sempre retorna o valor ajustado para o tamanho máximo" do
				it "se tiver valor setado deve formatar o tamanho maximo" do
					subject.valid_conta_corrente_maximum = 5
					subject.conta_corrente = '123'
					subject.conta_corrente.must_equal '00123'

					subject.valid_conta_corrente_maximum = 7
					subject.conta_corrente.must_equal '0000123'
				end
				it "se não tiver valor setado não ajusta os digitos para o tamanho maximo" do
					subject.valid_conta_corrente_maximum = 5
					subject.conta_corrente = ''
					subject.conta_corrente.must_equal ''
				end
				it "se não tiver tamanho maximo definido deve retornar o valor setado" do
					subject.valid_conta_corrente_maximum = nil
					subject.conta_corrente = 456
					subject.conta_corrente.must_equal '456'
				end
			end
		end

		context "#modalidade" do
			it "por padrão não deve validar nada" do
				subject.modalidade = nil
				wont_be_message_error(:modalidade)
			end

			context "#valid_modalidade_required" do
				it "quando setado deve validar a obrigatoriedade" do
					wont validate_presence_of(:modalidade)

					subject.valid_modalidade_required = true
					must validate_presence_of(:modalidade)
				end
			end
			context "#valid_modalidade_length" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_modalidade_length = 7
					subject.modalidade = '12345678'
					must_be_message_error(:modalidade, :custom_length_is, {count: 7})
					subject.modalidade = '1234567'
					wont_be_message_error(:modalidade, :custom_length_is, {count: 7})
				end
			end
			context "#valid_modalidade_minimum" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_modalidade_minimum = 5
					subject.modalidade = '1'
					must_be_message_error(:modalidade, :custom_length_minimum, {count: 5})
					subject.modalidade = '1234567'
					wont_be_message_error(:modalidade, :custom_length_minimum, {count: 5})
				end
			end
			context "#valid_modalidade_maximum" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_modalidade_maximum = 3
					subject.modalidade = '1234'
					must_be_message_error(:modalidade, :custom_length_maximum, {count: 3})
					subject.modalidade = '123'
					wont_be_message_error(:modalidade, :custom_length_maximum, {count: 3})
				end
			end

			context "#valid_modalidade_inclusion" do
				it "deve validar que o valor deve estar entre um dos valores passados" do
					subject.valid_modalidade_inclusion = 3
					subject.modalidade = '4'
					must_be_message_error(:modalidade, :custom_inclusion, {list: '3'})
					subject.valid_modalidade_inclusion = [1,2,'03']
					subject.modalidade = '04'
					must_be_message_error(:modalidade, :custom_inclusion, {list: '1, 2, 03'})

					subject.modalidade = '2'
					wont_be_message_error(:modalidade)
				end
			end

			context "sempre retorna o valor ajustado para o tamanho máximo" do
				it "se tiver valor setado deve formatar o tamanho maximo" do
					subject.valid_modalidade_maximum = 5
					subject.modalidade = '123'
					subject.modalidade.must_equal '00123'

					subject.valid_modalidade_maximum = 7
					subject.modalidade.must_equal '0000123'
				end
				it "se não tiver valor setado não ajusta os digitos para o tamanho maximo" do
					subject.valid_modalidade_maximum = 5
					subject.modalidade = ''
					subject.modalidade.must_equal ''
				end
				it "se não tiver tamanho maximo definido deve retornar o valor setado" do
					subject.valid_modalidade_maximum = nil
					subject.modalidade = 456
					subject.modalidade.must_equal '456'
				end
			end
		end

		context "#codigo_cedente" do
			it "por padrão não deve validar nada" do
				subject.codigo_cedente = nil
				wont_be_message_error(:codigo_cedente)
				wont_be_message_error(:convenio)
			end

			context "#valid_codigo_cedente_required" do
				it "quando setado deve validar a obrigatoriedade" do
					wont validate_presence_of(:convenio)

					subject.valid_codigo_cedente_required = true
					must validate_presence_of(:convenio)
				end
			end
			context "#valid_codigo_cedente_length" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_codigo_cedente_length = 7
					subject.codigo_cedente = '12345678'
					must_be_message_error(:convenio, :custom_length_is, {count: 7})
					subject.codigo_cedente = '1234567'
					wont_be_message_error(:convenio, :custom_length_is, {count: 7})
				end
			end
			context "#valid_codigo_cedente_minimum" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_codigo_cedente_minimum = 5
					subject.codigo_cedente = '1'
					must_be_message_error(:convenio, :custom_length_minimum, {count: 5})
					subject.codigo_cedente = '1234567'
					wont_be_message_error(:convenio, :custom_length_minimum, {count: 5})
				end
			end
			context "#valid_codigo_cedente_maximum" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_codigo_cedente_maximum = 3
					subject.codigo_cedente = '1234'
					must_be_message_error(:convenio, :custom_length_maximum, {count: 3})
					subject.codigo_cedente = '123'
					wont_be_message_error(:convenio, :custom_length_maximum, {count: 3})
				end
			end
		end

		context "#carteira" do
			it "por padrão não deve validar nada" do
				subject.carteira = nil
				wont_be_message_error(:carteira)
			end

			context "#valid_carteira_required" do
				it "quando setado deve validar a obrigatoriedade" do
					wont validate_presence_of(:carteira)

					subject.valid_carteira_required = true
					must validate_presence_of(:carteira)
				end
			end
			context "#valid_carteira_length" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_carteira_length = 7
					subject.carteira = '12345678'
					must_be_message_error(:carteira, :custom_length_is, {count: 7})
					subject.carteira = '1234567'
					wont_be_message_error(:carteira, :custom_length_is, {count: 7})
				end
			end
			context "#valid_carteira_minimum" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_carteira_minimum = 5
					subject.carteira = '1'
					must_be_message_error(:carteira, :custom_length_minimum, {count: 5})
					subject.carteira = '1234567'
					wont_be_message_error(:carteira, :custom_length_minimum, {count: 5})
				end
			end
			context "#valid_carteira_maximum" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_carteira_maximum = 3
					subject.carteira = '1234'
					must_be_message_error(:carteira, :custom_length_maximum, {count: 3})
					subject.carteira = '123'
					wont_be_message_error(:carteira, :custom_length_maximum, {count: 3})
				end
			end
			context "#valid_carteira_inclusion" do
				it "deve validar que o valor deve estar entre um dos valores passados" do
					subject.valid_carteira_inclusion = 3
					subject.carteira = '4'
					must_be_message_error(:carteira, :custom_inclusion, {list: '3'})
					subject.valid_carteira_inclusion = [1,2,'03']
					subject.carteira = '04'
					must_be_message_error(:carteira, :custom_inclusion, {list: '1, 2, 03'})

					subject.carteira = '2'
					wont_be_message_error(:carteira)
				end
			end
			context "sempre retorna o valor ajustado para o tamanho máximo" do
				it "se tiver valor setado deve formatar o tamanho maximo" do
					subject.valid_carteira_maximum = 5
					subject.carteira = '123'
					subject.carteira.must_equal '00123'

					subject.valid_carteira_maximum = 7
					subject.carteira.must_equal '0000123'
				end
				it "se não tiver valor setado não ajusta os digitos para o tamanho maximo" do
					subject.valid_carteira_maximum = 5
					subject.carteira = ''
					subject.carteira.must_equal ''
				end
				it "se não tiver tamanho maximo definido deve retornar o valor setado" do
					subject.valid_carteira_maximum = nil
					subject.carteira = 456
					subject.carteira.must_equal '456'
				end
			end
		end
		context "#codigo_carteira" do
			it "por padrão não deve validar nada" do
				subject.codigo_carteira = nil
				wont_be_message_error(:codigo_carteira)
			end

			context "#valid_codigo_carteira_required" do
				it "quando setado deve validar a obrigatoriedade" do
					wont validate_presence_of(:codigo_carteira)

					subject.valid_codigo_carteira_required = true
					must validate_presence_of(:codigo_carteira)
				end
			end
			context "#valid_codigo_carteira_length" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_codigo_carteira_length = 7
					subject.codigo_carteira = '12345678'
					must_be_message_error(:codigo_carteira, :custom_length_is, {count: 7})
					subject.codigo_carteira = '1234567'
					wont_be_message_error(:codigo_carteira, :custom_length_is, {count: 7})
				end
			end
		end
		context "#convenio" do
			it "por padrão não deve validar nada" do
				subject.convenio = nil
				wont_be_message_error(:convenio)
			end

			context "#valid_convenio_required" do
				it "quando setado deve validar a obrigatoriedade" do
					wont validate_presence_of(:convenio)

					subject.valid_convenio_required = true
					must validate_presence_of(:convenio)
				end
			end
			context "#valid_convenio_length" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_convenio_length = 7
					subject.convenio = '12345678'
					must_be_message_error(:convenio, :custom_length_is, {count: 7})
					subject.convenio = '1234567'
					wont_be_message_error(:convenio, :custom_length_is, {count: 7})
				end
			end
			context "#valid_convenio_minimum" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_convenio_minimum = 5
					subject.convenio = '1'
					must_be_message_error(:convenio, :custom_length_minimum, {count: 5})
					subject.convenio = '1234567'
					wont_be_message_error(:convenio, :custom_length_minimum, {count: 5})
				end
			end
			context "#valid_convenio_maximum" do
				it "quando setado um valor deve validar através do valor setado" do
					subject.valid_convenio_maximum = 3
					subject.convenio = '1234'
					must_be_message_error(:convenio, :custom_length_maximum, {count: 3})
					subject.convenio = '123'
					wont_be_message_error(:convenio, :custom_length_maximum, {count: 3})
				end
			end
			context "#valid_convenio_inclusion" do
				it "deve validar que o valor deve estar entre um dos valores passados" do
					subject.valid_convenio_inclusion = 3
					subject.convenio = '4'
					must_be_message_error(:convenio, :custom_inclusion, {list: '3'})
					subject.valid_convenio_inclusion = [1,2,'03']
					subject.convenio = '04'
					must_be_message_error(:convenio, :custom_inclusion, {list: '1, 2, 03'})

					subject.convenio = '2'
					wont_be_message_error(:convenio)
				end
			end
			context "sempre retorna o valor ajustado para o tamanho máximo" do
				it "se tiver valor setado deve formatar o tamanho maximo" do
					subject.valid_convenio_maximum = 5
					subject.convenio = '123'
					subject.convenio.must_equal '00123'

					subject.valid_convenio_maximum = 7
					subject.convenio.must_equal '0000123'
				end
				it "se não tiver valor setado não ajusta os digitos para o tamanho maximo" do
					subject.valid_convenio_maximum = 5
					subject.convenio = ''
					subject.convenio.must_equal ''
				end
				it "se não tiver tamanho maximo definido deve retornar o valor setado" do
					subject.valid_convenio_maximum = nil
					subject.convenio = 456
					subject.convenio.must_equal '456'
				end
			end
		end
	end

	it "carteira deve retornar sempre uma string se tiver um valor" do
		subject.carteira = 123
		subject.carteira.must_equal '123'
		subject.carteira = nil
		subject.carteira.must_be_nil
	end

	it "agencia deve retornar sempre uma string se tiver um valor" do
		subject.agencia = 1230
		subject.agencia.must_equal '1230'
		subject.agencia = nil
		subject.agencia.must_be_nil
	end

	it "codigo_cedente deve retornar sempre uma string se tiver um valor" do
		subject.codigo_cedente = 123
		subject.codigo_cedente.must_equal '123'
		subject.codigo_cedente = nil
		subject.codigo_cedente.must_be_nil
	end

	describe "NotImplementedError" do
		it "codigo_banco" do
			assert_raises NotImplementedError do
				subject.codigo_banco
			end
		end

		it "nome_banco" do
			subject.nome_banco = nil
			assert_raises NotImplementedError do
				subject.nome_banco
			end
		end

		it "codigo_banco_dv" do
			assert_raises NotImplementedError do
				subject.codigo_banco_dv
			end
		end
		it "versao_layout_arquivo_cnab_240" do
			assert_raises NotImplementedError do
				subject.versao_layout_lote_cnab_240
			end
		end
		it "versao_layout_lote_cnab_240" do
			assert_raises NotImplementedError do
				subject.versao_layout_lote_cnab_240
			end
		end
	end

	describe "#codigo_banco_formatado" do
		it "deve trazer o codigo do banco e o dv separados por ifen" do
			subject.expects(:codigo_banco).returns(6578)
			subject.expects(:codigo_banco_dv).returns(9)
			subject.codigo_banco_formatado.must_equal '6578-9'
		end
	end

	describe "#agencia_codigo_cedente" do
		it "deve trazer a agencia e o dv separados por /" do
			subject.expects(:agencia).returns(956781)
			subject.expects(:codigo_cedente).returns(999)
			subject.expects(:codigo_cedente_dv).returns(7)
			subject.agencia_codigo_cedente.must_equal '956781 / 999-7'
		end
	end

		describe "#cpf_cnpj" do
		it "se setar o cnpj com a pontuação deve sempre retornar apenas os numeros" do
			subject.cpf_cnpj = '84.059.146/0001-00'
			subject.cpf_cnpj.must_equal '84059146000100'
		end
		it "se setar o CPF com a pontuação deve sempre retornar apenas os numeros" do
			subject.cpf_cnpj = '725.211.506-22'
			subject.cpf_cnpj.must_equal '72521150622'
		end
	end

	describe "#tipo_cpf_cnpj" do
		context "#CPF retorna 01" do
			it "por padrão deve retornar 01 (com 2 digitos)" do
				subject.cpf_cnpj = '725.211.506-22'
				subject.tipo_cpf_cnpj.must_equal '01'
			end
			it "posso passar a quantidade de digitos a retornar" do
				subject.cpf_cnpj = '83944180313'
				subject.tipo_cpf_cnpj(1).must_equal '1'
			end
		end
		context "#CNPJ retorna 02" do
			it "por padrão deve retornar 02 (com 2 digitos)" do
				subject.cpf_cnpj = '84059146000100'
				subject.tipo_cpf_cnpj.must_equal '02'
			end
			it "posso passar a quantidade de digitos a retornar" do
				subject.cpf_cnpj = '32.131.445/0001-05'
				subject.tipo_cpf_cnpj(1).must_equal '2'
			end
		end
	end

	describe "#cpf_cnpj_formatado" do
		it "deve retornar o cnpj com a pontuação correta" do
			subject.cpf_cnpj = '84059146000100'
			subject.cpf_cnpj_formatado.must_equal '84.059.146/0001-00'
		end
		it "deve retornar o CPF com a pontuação correta" do
			subject.cpf_cnpj = '72521150622'
			subject.cpf_cnpj_formatado.must_equal '725.211.506-22'
		end
	end

	describe "#cpf_cnpj_formatado_com_label" do
		it "deve retornar o cnpj com a pontuação correta e com o label CNPJ" do
			subject.cpf_cnpj = '84059146000100'
			subject.cpf_cnpj_formatado_com_label.must_equal 'CNPJ 84.059.146/0001-00'
		end
		it "deve retornar o CPF com a pontuação correta e com o label CPF" do
			subject.cpf_cnpj = '72521150622'
			subject.cpf_cnpj_formatado_com_label.must_equal 'CPF 725.211.506-22'
		end
	end

	describe "#tipo_cobranca" do
		it "deve retornar o codigo_carteira se existir" do
			subject.codigo_carteira = '1'
			subject.tipo_cobranca.must_equal '1'
			subject.codigo_carteira = '2'
			subject.tipo_cobranca.must_equal '2'
		end
		it "deve pegar o primeiro caracter da carteira se não houver valor no codigo_carteira" do
			subject.carteira = 'X7'
			subject.tipo_cobranca.must_equal 'X'
			subject.carteira = 'A7'
			subject.tipo_cobranca.must_equal 'A'
		end
		it "se carteira for nil não deve dar erro" do
			subject.carteira = nil
			subject.tipo_cobranca.must_be_nil
		end
	end

	context "defalt_codes" do
		describe "#get_especie_titulo" do
			context "CÓDIGOS para o cnab 240" do
				it { subject.get_especie_titulo('01', 240).must_equal '01' } #  CH   –  Cheque
				it { subject.get_especie_titulo('02', 240).must_equal '02' } #  DM   –  Duplicata Mercantil
				it { subject.get_especie_titulo('03', 240).must_equal '03' } #  DMI  –  Duplicata Mercantil p/ Indicação
				it { subject.get_especie_titulo('04', 240).must_equal '04' } #  DS   –  Duplicata de Serviço
				it { subject.get_especie_titulo('05', 240).must_equal '05' } #  DSI  –  Duplicata de Serviço p/ Indicação
				it { subject.get_especie_titulo('06', 240).must_equal '06' } #  DR   –  Duplicata Rural
				it { subject.get_especie_titulo('07', 240).must_equal '07' } #  LC   –  Letra de Câmbio
				it { subject.get_especie_titulo('08', 240).must_equal '08' } #  NCC  –  Nota de Crédito Comercial
				it { subject.get_especie_titulo('09', 240).must_equal '09' } #  NCE  –  Nota de Crédito a Exportação
				it { subject.get_especie_titulo('10', 240).must_equal '10' } #  NCI  –  Nota de Crédito Industrial
				it { subject.get_especie_titulo('11', 240).must_equal '11' } #  NCR  –  Nota de Crédito Rural
				it { subject.get_especie_titulo('12', 240).must_equal '12' } #  NP   –  Nota Promissória
				it { subject.get_especie_titulo('13', 240).must_equal '13' } #  NPR  –  Nota Promissória Rural
				it { subject.get_especie_titulo('14', 240).must_equal '14' } #  TM   –  Triplicata Mercantil
				it { subject.get_especie_titulo('15', 240).must_equal '15' } #  TS   –  Triplicata de Serviço
				it { subject.get_especie_titulo('16', 240).must_equal '16' } #  NS   –  Nota de Seguro
				it { subject.get_especie_titulo('17', 240).must_equal '17' } #  RC   –  Recibo
				it { subject.get_especie_titulo('18', 240).must_equal '18' } #  FAT  –  Fatura
				it { subject.get_especie_titulo('19', 240).must_equal '19' } #  ND   –  Nota de Débito
				it { subject.get_especie_titulo('20', 240).must_equal '20' } #  AP   –  Apólice de Seguro
				it { subject.get_especie_titulo('21', 240).must_equal '21' } #  ME   –  Mensalidade Escolar
				it { subject.get_especie_titulo('22', 240).must_equal '22' } #  PC   –  Parcela de Consórcio
				it { subject.get_especie_titulo('23', 240).must_equal '23' } #  NF   –  Nota Fiscal
				it { subject.get_especie_titulo('24', 240).must_equal '24' } #  DD   –  Documento de Dívida
				it { subject.get_especie_titulo('25', 240).must_equal '25' } #  Cédula de Produto Rural
				it { subject.get_especie_titulo('26', 240).must_equal '26' } #  Warrant
				it { subject.get_especie_titulo('27', 240).must_equal '27' } #  Dívida Ativa de Estado
				it { subject.get_especie_titulo('28', 240).must_equal '28' } #  Dívida Ativa de Município
				it { subject.get_especie_titulo('29', 240).must_equal '29' } #  Dívida Ativa da União
				it { subject.get_especie_titulo('30', 240).must_equal '30' } #  Encargos condominiais
				it { subject.get_especie_titulo('31', 240).must_equal '31' } #  CC  –  Cartão de Crédito
				it { subject.get_especie_titulo('32', 240).must_equal '32' } #  BDP –  Boleto de Proposta
				it { subject.get_especie_titulo('99', 240).must_equal '99' } #  Outros
				it { subject.get_especie_titulo('00', 240).must_equal '99' }
			end
			context "CÓDIGOS para o cnab 400" do
				it { subject.get_especie_titulo('01', 400).must_equal '10' } #  Cheque
				it { subject.get_especie_titulo('02', 400).must_equal '01' } #  Duplicata Mercantil
				it { subject.get_especie_titulo('04', 400).must_equal '12' } #  Duplicata de Serviço
				it { subject.get_especie_titulo('06', 400).must_equal '06' } #  Duplicata Rural
				it { subject.get_especie_titulo('07', 400).must_equal '08' } #  Letra de Câmbio
				it { subject.get_especie_titulo('12', 400).must_equal '02' } #  Nota Promissória
				it { subject.get_especie_titulo('14', 400).must_equal '14' } #  Triplicata Mercantil
				it { subject.get_especie_titulo('15', 400).must_equal '15' } #  Triplicata de Serviço
				it { subject.get_especie_titulo('16', 400).must_equal '03' } #  Nota de Seguro
				it { subject.get_especie_titulo('17', 400).must_equal '05' } #  Recibo
				it { subject.get_especie_titulo('18', 400).must_equal '18' } #  Fatura
				it { subject.get_especie_titulo('19', 400).must_equal '13' } #  Nota de Débito
				it { subject.get_especie_titulo('20', 400).must_equal '20' } #  Apólice de Seguro
				it { subject.get_especie_titulo('21', 400).must_equal '21' } #  Mensalidade Escolar
				it { subject.get_especie_titulo('22', 400).must_equal '22' } #  Parcela de Consórcio
				it { subject.get_especie_titulo('26', 400).must_equal '09' } #  Warrant
				it { subject.get_especie_titulo('99', 400).must_equal '99' } #  Outros"
				it { subject.get_especie_titulo('00', 400).must_equal '99' }
			end
		end
		describe "#get_codigo_movimento_remessa" do
			context "CÓDIGOS para o cnab 240" do
				it { subject.get_codigo_movimento_remessa('01',240).must_equal '01' } # Entrada de Títulos
				it { subject.get_codigo_movimento_remessa('02',240).must_equal '02' } # Pedido de Baixa
				it { subject.get_codigo_movimento_remessa('03',240).must_equal '03' } # Protesto para Fins Falimentares
				it { subject.get_codigo_movimento_remessa('04',240).must_equal '04' } # Concessão de Abatimento
				it { subject.get_codigo_movimento_remessa('05',240).must_equal '05' } # Cancelamento de Abatimento
				it { subject.get_codigo_movimento_remessa('06',240).must_equal '06' } # Alteração de Vencimento
				it { subject.get_codigo_movimento_remessa('07',240).must_equal '07' } # Concessão de Desconto
				it { subject.get_codigo_movimento_remessa('08',240).must_equal '08' } # Cancelamento de Desconto
				it { subject.get_codigo_movimento_remessa('09',240).must_equal '09' } # Pedido de protesto (Protestar)
				it { subject.get_codigo_movimento_remessa('10',240).must_equal '10' } # Sustar Protesto e Baixar Título
				it { subject.get_codigo_movimento_remessa('11',240).must_equal '11' } # Sustar Protesto e Manter em Carteira
				it { subject.get_codigo_movimento_remessa('12',240).must_equal '12' } # Alteração de Juros de Mora
				it { subject.get_codigo_movimento_remessa('13',240).must_equal '13' } # Dispensar Cobrança de Juros de Mora
				it { subject.get_codigo_movimento_remessa('14',240).must_equal '14' } # Alteração de Valor/Percentual de Multa
				it { subject.get_codigo_movimento_remessa('15',240).must_equal '15' } # Dispensar Cobrança de Multa
				it { subject.get_codigo_movimento_remessa('16',240).must_equal '16' } # Alteração do Valor de Desconto
				it { subject.get_codigo_movimento_remessa('17',240).must_equal '17' } # Não conceder Desconto
				it { subject.get_codigo_movimento_remessa('18',240).must_equal '18' } # Alteração do Valor de Abatimento
				it { subject.get_codigo_movimento_remessa('19',240).must_equal '19' } # Prazo Limite de Recebimento – Alterar
				it { subject.get_codigo_movimento_remessa('20',240).must_equal '20' } # Prazo Limite de Recebimento – Dispensar
				it { subject.get_codigo_movimento_remessa('21',240).must_equal '21' } # Alterar número do título dado pelo beneficiario
				it { subject.get_codigo_movimento_remessa('22',240).must_equal '22' } # Alterar número controle do Participante (seu número)
				it { subject.get_codigo_movimento_remessa('23',240).must_equal '23' } # Alterar dados do Pagador
				it { subject.get_codigo_movimento_remessa('24',240).must_equal '24' } # Alterar dados do Sacador/Avalista
				it { subject.get_codigo_movimento_remessa('30',240).must_equal '30' } # Recusa da Alegação do Pagador
				it { subject.get_codigo_movimento_remessa('31',240).must_equal '31' } # Alteração de Outros Dados
				it { subject.get_codigo_movimento_remessa('33',240).must_equal '33' } # Alteração dos Dados do Rateio de Crédito
				it { subject.get_codigo_movimento_remessa('34',240).must_equal '34' } # Pedido de Cancelamento dos Dados do Rateio de Crédito
				it { subject.get_codigo_movimento_remessa('35',240).must_equal '35' } # Pedido de Desagendamento do Débito Automático
				it { subject.get_codigo_movimento_remessa('40',240).must_equal '40' } # Alteração de Carteira
				it { subject.get_codigo_movimento_remessa('41',240).must_equal '41' } # Cancelar protesto
				it { subject.get_codigo_movimento_remessa('42',240).must_equal '42' } # Alteração de Espécie de Título
				it { subject.get_codigo_movimento_remessa('43',240).must_equal '43' } # Transferência de carteira/modalidade de cobrança
				it { subject.get_codigo_movimento_remessa('44',240).must_equal '44' } # Alteração de contrato de cobrança
				it { subject.get_codigo_movimento_remessa('45',240).must_equal '45' } # Negativação Sem Protesto
				it { subject.get_codigo_movimento_remessa('46',240).must_equal '46' } # Solicitação de Baixa de Título Negativado Sem Protesto
				it { subject.get_codigo_movimento_remessa('47',240).must_equal '47' } # Alteração do Valor Nominal do Título
				it { subject.get_codigo_movimento_remessa('48',240).must_equal '48' } # Alteração do Valor Mínimo/ Percentual
				it { subject.get_codigo_movimento_remessa('49',240).must_equal '49' } # Alteração do Valor Máximo/Percentua
				it { subject.get_codigo_movimento_remessa('00', 240).must_equal '31' }
			end
			context "CÓDIGOS para o cnab 400" do
				it { subject.get_codigo_movimento_remessa('01', 400).must_equal '01' } # Registro de títulos / Remessa
				it { subject.get_codigo_movimento_remessa('02', 400).must_equal '02' } # Pedido de Baixa
				it { subject.get_codigo_movimento_remessa('03', 400).must_equal '03' } # Pedido de Protesto Falimentar
				it { subject.get_codigo_movimento_remessa('04', 400).must_equal '04' } # Concessão de abatimento
				it { subject.get_codigo_movimento_remessa('05', 400).must_equal '05' } # Cancelamento de abatimento concedido
				it { subject.get_codigo_movimento_remessa('06', 400).must_equal '06' } # Alteração de vencimento
				it { subject.get_codigo_movimento_remessa('09', 400).must_equal '09' } # Pedido de protesto (Protestar)
				it { subject.get_codigo_movimento_remessa('22', 400).must_equal '08' } # Alterar número controle do Participante (seu número)
				it { subject.get_codigo_movimento_remessa('31', 400).must_equal '31' } # Alteração de outros dados
				it { subject.get_codigo_movimento_remessa('00', 400).must_equal '31' }
			end
		end
		describe "#get_tipo_cobranca_240" do
			it { subject.get_tipo_cobranca('1', 240).must_equal '1' } # Cobrança Simples
			it { subject.get_tipo_cobranca('2', 240).must_equal '2' } # Cobrança Vinculada
			it { subject.get_tipo_cobranca('3', 240).must_equal '3' } # Cobrança Caucionada
			it { subject.get_tipo_cobranca('4', 240).must_equal '4' } # Cobrança Descontada
			it { subject.get_tipo_cobranca('5', 240).must_equal '5' } # Cobrança Vendor
			it { subject.get_tipo_cobranca('00', 240).must_equal '00' }
		end
		describe "#get_tipo_cobranca_400" do
			it { subject.get_tipo_cobranca('1', 400).must_equal '1' } # Cobrança Simples
			it { subject.get_tipo_cobranca('2', 400).must_equal '2' } # Cobrança Vinculada
			it { subject.get_tipo_cobranca('3', 400).must_equal '3' } # Cobrança Caucionada
			it { subject.get_tipo_cobranca('4', 400).must_equal '4' } # Cobrança Descontada
			it { subject.get_tipo_cobranca('5', 400).must_equal '5' } # Cobrança Vendor
			it { subject.get_tipo_cobranca('00', 400).must_equal '00' }
		end
		describe "#get_identificacao_emissao_240" do
			it { subject.get_identificacao_emissao('1', 240).must_equal '1' } # Banco Emite
			it { subject.get_identificacao_emissao('2', 240).must_equal '2' } # Cliente Emite
			it { subject.get_identificacao_emissao('3', 240).must_equal '3' } # Banco Pré-emite e Cliente Complementa
			it { subject.get_identificacao_emissao('4', 240).must_equal '4' } # Banco Reemite
			it { subject.get_identificacao_emissao('5', 240).must_equal '5' } # Banco Não Reemite
			it { subject.get_identificacao_emissao('7', 240).must_equal '7' } # Banco Emitente - Aberta
			it { subject.get_identificacao_emissao('8', 240).must_equal '8' } # Banco Emitente - Auto-envelopável
			it { subject.get_identificacao_emissao('99', 240).must_equal '99' }
		end
		describe "#get_identificacao_emissao_400" do
			it { subject.get_identificacao_emissao('1', 400).must_equal '1' } # Banco Emite
			it { subject.get_identificacao_emissao('2', 400).must_equal '2' } # Cliente Emite
			it { subject.get_identificacao_emissao('3', 400).must_equal '3' } # Banco Pré-emite e Cliente Complementa
			it { subject.get_identificacao_emissao('4', 400).must_equal '4' } # Banco Reemite
			it { subject.get_identificacao_emissao('5', 400).must_equal '5' } # Banco Não Reemite
			it { subject.get_identificacao_emissao('7', 400).must_equal '7' } # Banco Emitente - Aberta
			it { subject.get_identificacao_emissao('8', 400).must_equal '8' } # Banco Emitente - Auto-envelopável
			it { subject.get_identificacao_emissao('00', 400).must_equal '00' }
		end
		describe "#get_distribuicao_boleto" do
			it { subject.get_distribuicao_boleto('1').must_equal '1' } # Banco Distribui
			it { subject.get_distribuicao_boleto('2').must_equal '2' } # Cliente Distribui
			it { subject.get_distribuicao_boleto('3').must_equal '3' } # Banco envia e-mail
			it { subject.get_distribuicao_boleto('4').must_equal '4' } # Banco envia SMS
			it { subject.get_distribuicao_boleto('00').must_equal '00' }
		end
		describe "#get_tipo_impressao_240" do
			it { subject.get_tipo_impressao('1', 240).must_equal '1' } # Frente do Bloqueto
			it { subject.get_tipo_impressao('2', 240).must_equal '2' } # Verso do Bloqueto
			it { subject.get_tipo_impressao('3', 240).must_equal '3' } # Corpo de Instruções da Ficha de Compensação do Bloqueto
			it { subject.get_tipo_impressao('7', 240).must_equal '7' } # Outros
			it { subject.get_tipo_impressao('999', 240).must_equal '999' } # Outros
		end
		describe "#get_tipo_impressao_400" do
			it { subject.get_tipo_impressao('1', 400).must_equal '1' } # Frente do Bloqueto
			it { subject.get_tipo_impressao('2', 400).must_equal '2' } # Verso do Bloqueto
			it { subject.get_tipo_impressao('3', 400).must_equal '3' } # Corpo de Instruções da Ficha de Compensação do Bloqueto
			it { subject.get_tipo_impressao('7', 400).must_equal '7' } # Outros
			it { subject.get_tipo_impressao('999', 400).must_equal '999' } # Outros
		end
		describe "#get_codigo_juros" do
			it { subject.get_codigo_juros('1').must_equal '1' } # Valor por Dia
			it { subject.get_codigo_juros('2').must_equal '2' } # Taxa Mensal
			it { subject.get_codigo_juros('3').must_equal '3' } # Isento
			it 'se passar um valor inexistente deve pegar o valor padrão' do
				subject.expects(:default_codigo_juros).returns(8)
				subject.get_codigo_juros('00').must_equal 8
			end
			it '#default_codigo_juros deve ter o valor 3 por padrão' do
				subject.default_codigo_juros.must_equal '3'
			end
		end
		describe "#get_codigo_multa" do
			it { subject.get_codigo_multa('1').must_equal '1' } # Valor fixo
			it { subject.get_codigo_multa('2').must_equal '2' } # Percentual
			it { subject.get_codigo_multa('3').must_equal '3' } # Isento
			it { subject.get_codigo_multa('9').must_equal '3' }
			it 'se passar um valor inexistente deve pegar o valor padrão' do
				subject.expects(:default_codigo_multa).returns(8)
				subject.get_codigo_multa('9').must_equal 8
			end
			it '#default_codigo_multa deve ter o valor 3 por padrão' do
				subject.default_codigo_multa.must_equal '3'
			end
		end
		describe "#get_codigo_desconto" do
			it { subject.get_codigo_desconto('0').must_equal '0' } # Sem Desconto
			it { subject.get_codigo_desconto('1').must_equal '1' } # Valor Fixo Até a Data Informada
			it { subject.get_codigo_desconto('2').must_equal '2' } # Percentual Até a Data Informada
			it { subject.get_codigo_desconto('3').must_equal '3' } # Valor por Antecipação Dia Corrido
			it { subject.get_codigo_desconto('4').must_equal '4' } # Valor por Antecipação Dia Úti
			it { subject.get_codigo_desconto('5').must_equal '5' } # Percentual Sobre o Valor Nominal Dia Corrido
			it { subject.get_codigo_desconto('6').must_equal '6' } # Percentual Sobre o Valor Nominal Dia Útil
			it { subject.get_codigo_desconto('7').must_equal '7' } # Cancelamento de Desconto
			it { subject.get_codigo_desconto('55').must_equal '55' }
		end
		describe "#get_codigo_protesto" do
			it { subject.get_codigo_protesto('1', 240).must_equal '1' } # Protestar Dias Corridos
			it { subject.get_codigo_protesto('2', 240).must_equal '2' } # Protestar Dias Úteis
			it { subject.get_codigo_protesto('3', 240).must_equal '3' } # Não Protesta
			it { subject.get_codigo_protesto('4', 240).must_equal '4' } # Protestar Fim Falimentar - Dias Úteis
			it { subject.get_codigo_protesto('5', 240).must_equal '5' } # Protestar Fim Falimentar - Dias Corridos
			it { subject.get_codigo_protesto('8', 240).must_equal '8' } # Negativação sem Protesto
			it { subject.get_codigo_protesto('9', 240).must_equal '9' } # Cancelamento Protesto Automático
			it { subject.get_codigo_protesto('55', 240).must_equal '55' }
		end
		describe "#get_codigo_moeda_240" do
			it { subject.get_codigo_moeda('01', 240).must_equal '01' } # Reservado para Uso Futuro
			it { subject.get_codigo_moeda('02', 240).must_equal '02' } # Dólar Americano Comercial (Venda)
			it { subject.get_codigo_moeda('03', 240).must_equal '03' } # Dólar Americano Turismo (Venda)
			it { subject.get_codigo_moeda('04', 240).must_equal '04' } # ITRD
			it { subject.get_codigo_moeda('05', 240).must_equal '05' } # IDTR
			it { subject.get_codigo_moeda('06', 240).must_equal '06' } # UFIR Diária
			it { subject.get_codigo_moeda('07', 240).must_equal '07' } # UFIR Mensal
			it { subject.get_codigo_moeda('08', 240).must_equal '08' } # FAJ - TR
			it { subject.get_codigo_moeda('09', 240).must_equal '09' } # Real
			it { subject.get_codigo_moeda('10', 240).must_equal '10' } # TR
			it { subject.get_codigo_moeda('11', 240).must_equal '11' } # IGPM
			it { subject.get_codigo_moeda('12', 240).must_equal '12' } # CDI
			it { subject.get_codigo_moeda('13', 240).must_equal '13' } # Percentual do CDI
			it { subject.get_codigo_moeda('14', 240).must_equal '14' } # Euro
			it { subject.get_codigo_moeda('55', 240).must_equal '55' }
		end
		describe "#get_codigo_moeda_400" do
			it { subject.get_codigo_moeda('01', 400).must_equal '01' } # Reservado para Uso Futuro
			it { subject.get_codigo_moeda('02', 400).must_equal '02' } # Dólar Americano Comercial (Venda)
			it { subject.get_codigo_moeda('03', 400).must_equal '03' } # Dólar Americano Turismo (Venda)
			it { subject.get_codigo_moeda('04', 400).must_equal '04' } # ITRD
			it { subject.get_codigo_moeda('05', 400).must_equal '05' } # IDTR
			it { subject.get_codigo_moeda('06', 400).must_equal '06' } # UFIR Diária
			it { subject.get_codigo_moeda('07', 400).must_equal '07' } # UFIR Mensal
			it { subject.get_codigo_moeda('08', 400).must_equal '08' } # FAJ - TR
			it { subject.get_codigo_moeda('09', 400).must_equal '09' } # Real
			it { subject.get_codigo_moeda('10', 400).must_equal '10' } # TR
			it { subject.get_codigo_moeda('11', 400).must_equal '11' } # IGPM
			it { subject.get_codigo_moeda('12', 400).must_equal '12' } # CDI
			it { subject.get_codigo_moeda('13', 400).must_equal '13' } # Percentual do CDI
			it { subject.get_codigo_moeda('14', 400).must_equal '14' } # Euro
			it { subject.get_codigo_moeda('55', 400).must_equal '55' }
		end
	end
end
