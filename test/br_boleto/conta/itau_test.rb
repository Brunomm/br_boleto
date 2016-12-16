require 'test_helper'

describe BrBoleto::Conta::Itau do
	subject { FactoryGirl.build(:conta_itau) }

	it "deve herdar de Conta::Base" do
		subject.class.superclass.must_equal BrBoleto::Conta::Base
	end
	context "valores padrões" do
		it "deve setar a carteira com '109' " do
			subject.class.new.carteira.must_equal '109'
		end
		it "deve setar a valid_agencia_length com 4 " do
			subject.class.new.valid_agencia_length.must_equal 4
		end
		it "deve setar a valid_carteira_required com true " do
			subject.class.new.valid_carteira_required.must_equal true
		end
		it "deve setar a valid_carteira_length com 3 " do
			subject.class.new.valid_carteira_length.must_equal 3
		end
		it "deve setar a valid_conta_corrente_required com true " do
			subject.class.new.valid_conta_corrente_required.must_equal true
		end
		it "deve setar a valid_conta_corrente_maximum com 5 " do
			subject.class.new.valid_conta_corrente_maximum.must_equal 5
		end
		it "deve setar a valid_codigo_cedente_maximum com 5 " do
			subject.class.new.valid_codigo_cedente_maximum.must_equal 5
		end
	end
	describe "Validations" do
		it { must validate_presence_of(:agencia) }
		it { must validate_presence_of(:razao_social) }
		it { must validate_presence_of(:cpf_cnpj) }
		it do
			subject.agencia_dv = 21
			must_be_message_error(:agencia_dv, :custom_length_is, {count: 1})
		end
		context 'Validações padrões da carteira' do
			subject { BrBoleto::Conta::Itau.new }
			it { must validate_presence_of(:carteira) }
			it 'Tamanho deve ser de 3' do
				subject.carteira = '1345'
				must_be_message_error(:carteira, :custom_length_is, {count: 3})
			end
			it "valores aceitos" do
				subject.carteira = '04'
				must_be_message_error(:carteira, :custom_inclusion, {list: '104, 105, 107, 108, 109, 112, 113, 116, 117, 119, 121, 122, 126, 131, 134, 135, 136, 142, 143, 146, 147, 150, 168, 169, 174, 175, 180, 191, 196, 198'})
			end
		end
		context 'Validações padrões da conta_corrente' do
			subject { BrBoleto::Conta::Itau.new }
			it { must validate_presence_of(:conta_corrente) }
			it 'Tamanho deve ter o tamanho maximo de 5' do
				subject.conta_corrente = '12345678'
				must_be_message_error(:conta_corrente, :custom_length_maximum, {count: 5})
			end
		end
		context 'Validações padrões da codigo_cedente' do
			subject { BrBoleto::Conta::Itau.new }
			it 'Tamanho deve ter o tamanho maximo de 5' do
				subject.codigo_cedente = '12345678'
				must_be_message_error(:convenio, :custom_length_maximum, {count: 5})
			end
		end
	end

	it "codigo do banco" do
		subject.codigo_banco.must_equal '341'
	end
	it '#codigo_banco_dv' do
		subject.codigo_banco_dv.must_equal '7'
	end

	describe "#nome_banco" do
		it "valor padrão para o nome_banco" do
			subject.nome_banco.must_equal 'ITAU'
		end
		it "deve ser possível mudar o valor do nome do banco" do
			subject.nome_banco = 'MEU'
			subject.nome_banco.must_equal 'MEU'
		end
	end

	it "#versao_layout_arquivo_cnab_240" do
		subject.versao_layout_arquivo_cnab_240.must_equal '040'
	end
	it "#versao_layout_lote_cnab_240" do
		subject.versao_layout_lote_cnab_240.must_equal '030'
	end

	describe '#conta_corrente_dv' do
		it "deve ser personalizavel pelo usuario" do
			subject.conta_corrente_dv = 88
			subject.conta_corrente_dv.must_equal 88
		end
		it "se não passar valor deve calcular automatico" do
			subject.conta_corrente_dv = nil
			subject.conta_corrente = '12345'			
			subject.agencia_dv = nil
			subject.agencia = '1234'
			BrBoleto::Calculos::Modulo10.expects(:new).with('123412345').returns(stub(to_s: 1))

			subject.conta_corrente_dv.must_equal 1
		end
	end

	describe "#get_especie_titulo" do
		context "CÓDIGOS para o cnab 240 do Itau" do
			it { subject.get_especie_titulo('02', 240).must_equal '01' } # DUPLICATA MERCANTIL
			it { subject.get_especie_titulo('12', 240).must_equal '02' } # NOTA PROMISSÓRIA
			it { subject.get_especie_titulo('16', 240).must_equal '03' } # NOTA DE SEGURO
			it { subject.get_especie_titulo('21', 240).must_equal '04' } # MENSALIDADE ESCOLAR
			it { subject.get_especie_titulo('17', 240).must_equal '05' } # RECIBO
			it { subject.get_especie_titulo('04', 240).must_equal '08' } # DUPLICATA DE SERVIÇO
			it { subject.get_especie_titulo('07', 240).must_equal '09' } # LETRA DE CÂMBIO
			it { subject.get_especie_titulo('19', 240).must_equal '13' } # NOTA DE DÉBITOS
			it { subject.get_especie_titulo('24', 240).must_equal '15' } # DOCUMENTO DE DÍVIDA
			it { subject.get_especie_titulo('30', 240).must_equal '16' } # ENCARGOS CONDOMINIAIS
			it { subject.get_especie_titulo('32', 240).must_equal '18' } # BOLETO DE PROPOSTA
			it { subject.get_especie_titulo('66', 240).must_equal '06' } # CONTRATO
			it { subject.get_especie_titulo('77', 240).must_equal '07' } # COSSEGUROS
			it { subject.get_especie_titulo('88', 240).must_equal '17' } # CONTA DE PRESTAÇÃO DE SERVIÇOS
		end
	end
	describe "#get_especie_titulo" do
		context "CÓDIGOS para o cnab 400 do Itau" do
			it { subject.get_especie_titulo('02', 400).must_equal '01' } # DUPLICATA MERCANTIL
			it { subject.get_especie_titulo('12', 400).must_equal '02' } # NOTA PROMISSÓRIA
			it { subject.get_especie_titulo('16', 400).must_equal '03' } # NOTA DE SEGURO
			it { subject.get_especie_titulo('21', 400).must_equal '04' } # MENSALIDADE ESCOLAR
			it { subject.get_especie_titulo('17', 400).must_equal '05' } # RECIBO
			it { subject.get_especie_titulo('04', 400).must_equal '08' } # DUPLICATA DE SERVIÇO
			it { subject.get_especie_titulo('07', 400).must_equal '09' } # LETRA DE CÂMBIO
			it { subject.get_especie_titulo('19', 400).must_equal '13' } # NOTA DE DÉBITOS
			it { subject.get_especie_titulo('24', 400).must_equal '15' } # DOCUMENTO DE DÍVIDA
			it { subject.get_especie_titulo('30', 400).must_equal '16' } # ENCARGOS CONDOMINIAIS
			it { subject.get_especie_titulo('32', 400).must_equal '18' } # BOLETO DE PROPOSTA
			it { subject.get_especie_titulo('66', 400).must_equal '06' } # CONTRATO
			it { subject.get_especie_titulo('77', 400).must_equal '07' } # COSSEGUROS
			it { subject.get_especie_titulo('88', 400).must_equal '17' } # CONTA DE PRESTAÇÃO DE SERVIÇOS
		end
	end

	describe "#get_codigo_movimento_remessa" do
		context "CÓDIGOS para o cnab 240 do Itau" do
			it { subject.get_codigo_movimento_remessa('10', 240).must_equal '18' } # SUSTAR O PROTESTO
			it { subject.get_codigo_movimento_remessa('38', 240).must_equal '38' } # BENEFICIÁRIO NÃO CONCORDA COM A ALEGAÇÃO DO PAGADOR CÓDIGO DA ALEGAÇÃO
			it { subject.get_codigo_movimento_remessa('41', 240).must_equal '41' } # EXCLUSÃO DE SACADOR AVALISTA
			it { subject.get_codigo_movimento_remessa('66', 240).must_equal '66' } # ENTRADA EM NEGATIVAÇÃO EXPRESSA
			it { subject.get_codigo_movimento_remessa('67', 240).must_equal '67' } # NÃO NEGATIVAR (INIBE ENTRADA EM NEGATIVAÇÃO EXPRESSA
			it { subject.get_codigo_movimento_remessa('68', 240).must_equal '68' } # EXCLUIR NEGATIVAÇÃO EXPRESSA (ATÉ 15 DIAS CORRIDOS APÓS A ENTRADA EM NEGATIVAÇÃO EXPRESSA)
			it { subject.get_codigo_movimento_remessa('69', 240).must_equal '69' } # CANCELAR NEGATIVAÇÃO EXPRESSA (APÓS TÍTULO TER SIDO NEGATIVADO)
			it { subject.get_codigo_movimento_remessa('93', 240).must_equal '93' } # DESCONTAR TÍTULOS ENCAMINHADOS NO DIA
		end
	end

	describe "#get_codigo_protesto" do
		it { subject.get_codigo_protesto('0').must_equal '0' } # Sem instrução
		it { subject.get_codigo_protesto('07').must_equal '07' } # Negativar (Dias Corridos)
	end

	describe "#get_codigo_multa" do
		it { subject.get_codigo_multa('0').must_equal '0' } # NÃO REGISTRA A MULTA
	end

	describe "#get_codigo_carteira" do
		it "deve retornar E se a carteira for 147" do 
			subject.carteira = '147'
			subject.get_codigo_carteira.must_equal 'E'  # ESCRITURAL ELETRÔNICA – DÓLAR
		end
		it "deve retornar U se a carteira for 150" do
			subject.carteira = '150'
			subject.get_codigo_carteira.must_equal 'U'  # DIRETA ELETRÔNICA SEM EMISSÃO – DÓLAR
		end
		it "deve retornar 1 se a carteira for 191" do
			subject.carteira = '191'
			subject.get_codigo_carteira.must_equal '1'  # DUPLICATAS - TRANSFERÊNCIA DE DESCONTO
		end
		it "deve retornar I para as demais carteiras" do
			subject.carteira = '109'
			subject.get_codigo_carteira.must_equal 'I'  # DEMAIS CARTEIRAS

			subject.carteira = '999'
			subject.get_codigo_carteira.must_equal 'I'  # DEMAIS CARTEIRAS
		end
	end


	describe "#get_codigo_movimento_retorno" do
		context "CÓDIGOS para o Itau" do
			it { subject.get_codigo_movimento_retorno('08', 240).must_equal '101' }   # LIQUIDAÇÃO EM CARTÓRIO 
			it { subject.get_codigo_movimento_retorno('10', 240).must_equal '210' }   # BAIXA POR TER SIDO LIQUIDADO 
			it { subject.get_codigo_movimento_retorno('15', 240).must_equal '100' }    # BAIXAS REJEITADAS 
			it { subject.get_codigo_movimento_retorno('16', 240).must_equal '26' }    # INSTRUÇÕES REJEITADAS 
			it { subject.get_codigo_movimento_retorno('17', 240).must_equal '30' }   # ALTERAÇÃO/EXCLUSÃO DE DADOS REJEITADA  
			it { subject.get_codigo_movimento_retorno('18', 240).must_equal '218' }   # COBRANÇA CONTRATUAL – INSTRUÇÕES/ALTERAÇÕES REJEITADAS/PENDENTES 
			it { subject.get_codigo_movimento_retorno('21', 240).must_equal '221' }   # CONFIRMAÇÃO RECEBIMENTO DE INSTRUÇÃO DE NÃO PROTESTAR 
			it { subject.get_codigo_movimento_retorno('25', 240).must_equal '225' }   # ALEGAÇÕES DO PAGADOR 
			it { subject.get_codigo_movimento_retorno('26', 240).must_equal '226' }   # TARIFA DE AVISO DE COBRANÇA 
			it { subject.get_codigo_movimento_retorno('27', 240).must_equal '227' }   # TARIFA DE EXTRATO POSIÇÃO (B40X) 
			it { subject.get_codigo_movimento_retorno('28', 240).must_equal '228' }   # TARIFA DE RELAÇÃO DAS LIQUIDAÇÕES 
			it { subject.get_codigo_movimento_retorno('29', 240).must_equal '107' }   # TARIFA DE MANUTENÇÃO DE TÍTULOS VENCIDOS 
			it { subject.get_codigo_movimento_retorno('30', 240).must_equal '28' }    # DÉBITO MENSAL DE TARIFAS (PARA ENTRADAS E BAIXAS) 
			it { subject.get_codigo_movimento_retorno('32', 240).must_equal '25' }    # BAIXA POR TER SIDO PROTESTADO 
			it { subject.get_codigo_movimento_retorno('33', 240).must_equal '233' }   # CUSTAS DE PROTESTO 
			it { subject.get_codigo_movimento_retorno('34', 240).must_equal '234' }   # CUSTAS DE SUSTAÇÃO 
			it { subject.get_codigo_movimento_retorno('35', 240).must_equal '235' }   # CUSTAS DE CARTÓRIO DISTRIBUIDOR 
			it { subject.get_codigo_movimento_retorno('36', 240).must_equal '236' }   # CUSTAS DE EDITAL 
			it { subject.get_codigo_movimento_retorno('37', 240).must_equal '237' }   # TARIFA DE EMISSÃO DE BOLETO/TARIFA DE ENVIO DE DUPLICATA 
			it { subject.get_codigo_movimento_retorno('38', 240).must_equal '238' }   # TARIFA DE INSTRUÇÃO 
			it { subject.get_codigo_movimento_retorno('39', 240).must_equal '239' }   # TARIFA DE OCORRÊNCIAS 
			it { subject.get_codigo_movimento_retorno('40', 240).must_equal '240' }   # TARIFA MENSAL DE EMISSÃO DE BOLETO/TARIFA MENSAL DE ENVIO DE DUPLICATA 
			it { subject.get_codigo_movimento_retorno('41', 240).must_equal '241' }   # DÉBITO MENSAL DE TARIFAS – EXTRATO DE POSIÇÃO (B4EP/B4OX) 
			it { subject.get_codigo_movimento_retorno('42', 240).must_equal '242' }   # DÉBITO MENSAL DE TARIFAS – OUTRAS INSTRUÇÕES 
			it { subject.get_codigo_movimento_retorno('43', 240).must_equal '243' }   # DÉBITO MENSAL DE TARIFAS – MANUTENÇÃO DE TÍTULOS VENCIDOS 
			it { subject.get_codigo_movimento_retorno('44', 240).must_equal '244' }   # DÉBITO MENSAL DE TARIFAS – OUTRAS OCORRÊNCIAS 
			it { subject.get_codigo_movimento_retorno('45', 240).must_equal '245' }   # DÉBITO MENSAL DE TARIFAS – PROTESTO 
			it { subject.get_codigo_movimento_retorno('46', 240).must_equal '246' }   # DÉBITO MENSAL DE TARIFAS – SUSTAÇÃO DE PROTESTO 
			it { subject.get_codigo_movimento_retorno('47', 240).must_equal '247' }   # BAIXA COM TRANSFERÊNCIA PARA DESCONTO 
			it { subject.get_codigo_movimento_retorno('48', 240).must_equal '248' }   # CUSTAS DE SUSTAÇÃO JUDICIAL 
			it { subject.get_codigo_movimento_retorno('51', 240).must_equal '251' }   # TARIFA MENSAL REFERENTE A ENTRADAS BANCOS CORRESPONDENTES NA CARTEIRA 
			it { subject.get_codigo_movimento_retorno('52', 240).must_equal '252' }   # TARIFA MENSAL BAIXAS NA CARTEIRA 
			it { subject.get_codigo_movimento_retorno('53', 240).must_equal '253' }   # TARIFA MENSAL BAIXAS EM BANCOS CORRESPONDENTES NA CARTEIRA 
			it { subject.get_codigo_movimento_retorno('54', 240).must_equal '254' }   # TARIFA MENSAL DE LIQUIDAÇÕES NA CARTEIRA 
			it { subject.get_codigo_movimento_retorno('55', 240).must_equal '255' }   # TARIFA MENSAL DE LIQUIDAÇÕES EM BANCOS CORRESPONDENTES NA CARTEIRA 
			it { subject.get_codigo_movimento_retorno('56', 240).must_equal '256' }   # CUSTAS DE IRREGULARIDADE 
			it { subject.get_codigo_movimento_retorno('57', 240).must_equal '257' }   # INSTRUÇÃO CANCELADA 
			it { subject.get_codigo_movimento_retorno('60', 240).must_equal '260' }   # ENTRADA REJEITADA CARNÊ 
			it { subject.get_codigo_movimento_retorno('61', 240).must_equal '261' }   # TARIFA EMISSÃO AVISO DE MOVIMENTAÇÃO DE TÍTULOS (2154) 
			it { subject.get_codigo_movimento_retorno('62', 240).must_equal '262' }   # DÉBITO MENSAL DE TARIFA – AVISO DE MOVIMENTAÇÃO DE TÍTULOS (2154) 
			it { subject.get_codigo_movimento_retorno('63', 240).must_equal '63' }    # TÍTULO SUSTADO JUDICIALMENTE 
			it { subject.get_codigo_movimento_retorno('74', 240).must_equal '274' }   # INSTRUÇÃO DE NEGATIVAÇÃO EXPRESSA REJEITADA 
			it { subject.get_codigo_movimento_retorno('75', 240).must_equal '275' }   # CONFIRMA O RECEBIMENTO DE INSTRUÇÃO DE ENTRADA EM NEGATIVAÇÃO EXPRESSA 
			it { subject.get_codigo_movimento_retorno('77', 240).must_equal '277' }   # CONFIRMA O RECEBIMENTO DE INSTRUÇÃO DE EXCLUSÃO DE ENTRADA EM NEGATIVAÇÃO EXPRESSA 
			it { subject.get_codigo_movimento_retorno('78', 240).must_equal '278' }   # CONFIRMA O RECEBIMENTO DE INSTRUÇÃO DE CANCELAMENTO DA NEGATIVAÇÃO EXPRESSA 
			it { subject.get_codigo_movimento_retorno('79', 240).must_equal '279' }   # NEGATIVAÇÃO EXPRESSA INFORMACIONAL 
			it { subject.get_codigo_movimento_retorno('80', 240).must_equal '280' }   # CONFIRMAÇÃO DE ENTRADA EM NEGATIVAÇÃO EXPRESSA – TARIFA 
			it { subject.get_codigo_movimento_retorno('82', 240).must_equal '282' }   # CONFIRMAÇÃO O CANCELAMENTO DE NEGATIVAÇÃO EXPRESSA - TARIFA 
			it { subject.get_codigo_movimento_retorno('83', 240).must_equal '283' }   # CONFIRMAÇÃO DA EXCLUSÃO/CANCELAMENTO DA NEGATIVAÇÃO EXPRESSA POR LIQUIDAÇÃO - TARIFA 
			it { subject.get_codigo_movimento_retorno('85', 240).must_equal '285' }   # TARIFA POR BOLETO (ATÉ 03 ENVIOS) COBRANÇA ATIVA ELETRÔNICA 
			it { subject.get_codigo_movimento_retorno('86', 240).must_equal '286' }   # TARIFA EMAIL COBRANÇA ATIVA ELETRÔNICA 
			it { subject.get_codigo_movimento_retorno('87', 240).must_equal '287' }   # TARIFA SMS COBRANÇA ATIVA ELETRÔNICA 
			it { subject.get_codigo_movimento_retorno('88', 240).must_equal '288' }   # TARIFA MENSAL POR BOLETO (ATÉ 03 ENVIOS) COBRANÇA ATIVA ELETRÔNICA 
			it { subject.get_codigo_movimento_retorno('89', 240).must_equal '289' }   # TARIFA MENSAL EMAIL COBRANÇA ATIVA ELETRÔNICA 
			it { subject.get_codigo_movimento_retorno('90', 240).must_equal '290' }   # TARIFA MENSAL SMS COBRANÇA ATIVA ELETRÔNICA 
			it { subject.get_codigo_movimento_retorno('91', 240).must_equal '291' }   # TARIFA MENSAL DE EXCLUSÃO DE ENTRADA EM NEGATIVAÇÃO EXPRESSA 
			it { subject.get_codigo_movimento_retorno('92', 240).must_equal '292' }   # TARIFA MENSAL DE CANCELAMENTO DE NEGATIVAÇÃO EXPRESSA 
			it { subject.get_codigo_movimento_retorno('93', 240).must_equal '293' }   # TARIFA MENSAL DE EXCLUSÃO/CANCELAMENTO DE NEGATIVAÇÃO EXPRESSA POR LIQUIDAÇÃO 
			it { subject.get_codigo_movimento_retorno('94', 240).must_equal '294' }   # CONFIRMA RECEBIMENTO DE INSTRUÇÃO DE NÃO NEGATIVAR 
		end
	end


	describe "#get_codigo_motivo_ocorrencia" do
		context "CÓDIGOS para oa Caixa com Motivo Ocorrência A com codigo de movimento 03" do
			it { subject.get_codigo_motivo_ocorrencia('03', '03').must_equal 'A49' } # CEP INVÁLIDO OU NÃO FOI POSSÍVEL ATRIBUIR A AGÊNCIA PELO CEP 
			it { subject.get_codigo_motivo_ocorrencia('04', '03').must_equal 'A52' } # SIGLA DO ESTADO INVÁLIDA
			it { subject.get_codigo_motivo_ocorrencia('08', '03').must_equal 'A45' } # NÃO INFORMADO OU DESLOCADO
			it { subject.get_codigo_motivo_ocorrencia('09', '03').must_equal 'A07' } # AGÊNCIA ENCERRADA
			it { subject.get_codigo_motivo_ocorrencia('10', '03').must_equal 'A47' } # NÃO INFORMADO OU DESLOCADO
			it { subject.get_codigo_motivo_ocorrencia('11', '03').must_equal 'A49' } # CEP NÃO NUMÉRICO
			it { subject.get_codigo_motivo_ocorrencia('12', '03').must_equal 'A54' } # NOME NÃO INFORMADO OU DESLOCADO (BANCOS CORRESPONDENTES)
			it { subject.get_codigo_motivo_ocorrencia('13', '03').must_equal 'A51' } # CEP INCOMPATÍVEL COM A SIGLA DO ESTADO
			it { subject.get_codigo_motivo_ocorrencia('14', '03').must_equal 'A08' } # NOSSO NÚMERO JÁ REGISTRADO NO CADASTRO DO BANCO OU FORA DA FAIXA
			it { subject.get_codigo_motivo_ocorrencia('15', '03').must_equal 'A09' } # NOSSO NÚMERO EM DUPLICIDADE NO MESMO MOVIMENTO
			it { subject.get_codigo_motivo_ocorrencia('35', '03').must_equal 'A32' } # IOF MAIOR QUE 5%
			it { subject.get_codigo_motivo_ocorrencia('42', '03').must_equal 'A08' } # NOSSO NÚMERO FORA DE FAIXA
			it { subject.get_codigo_motivo_ocorrencia('60', '03').must_equal 'A33' } # VALOR DO ABATIMENTO INVÁLIDO
			it { subject.get_codigo_motivo_ocorrencia('62', '03').must_equal 'A29' } # VALOR DO DESCONTO MAIOR QUE O VALOR DO TÍTULO
			it { subject.get_codigo_motivo_ocorrencia('64', '03').must_equal 'A24' } # DATA DE EMISSÃO DO TÍTULO INVÁLIDA (VENDOR)
			it { subject.get_codigo_motivo_ocorrencia('66', '03').must_equal 'A74' } # INVALIDA/FORA DE PRAZO DE OPERAÇÃO (MÍNIMO OU MÁXIMO)
			it { subject.get_codigo_motivo_ocorrencia('67', '03').must_equal 'A20' } # VALOR DO TÍTULO/QUANTIDADE DE MOEDA INVÁLIDO
			it { subject.get_codigo_motivo_ocorrencia('68', '03').must_equal 'A10' } # CARTEIRA INVÁLIDA OU NÃO CADASTRADA NO INTERCÂMBIO DA COBRANÇA
		end
		context "CÓDIGOS para oa Caixa com Motivo Ocorrência A com codigo de movimento 26" do
			it { subject.get_codigo_motivo_ocorrencia('09', '26').must_equal 'A53'  }  # CNPJ/CPF DO SACADOR/AVALISTA INVÁLIDO
			it { subject.get_codigo_motivo_ocorrencia('15', '26').must_equal 'A54'  }  # CNPJ/CPF INFORMADO SEM NOME DO SACADOR/AVALISTA
			it { subject.get_codigo_motivo_ocorrencia('19', '26').must_equal 'A34'  }  # VALOR DO ABATIMENTO MAIOR QUE 90% DO VALOR DO TÍTULO
			it { subject.get_codigo_motivo_ocorrencia('20', '26').must_equal 'A41'  }  # EXISTE SUSTACAO DE PROTESTO PENDENTE PARA O TITULO
			it { subject.get_codigo_motivo_ocorrencia('22', '26').must_equal 'A106' }  # TÍTULO BAIXADO OU LIQUIDADO
			it { subject.get_codigo_motivo_ocorrencia('50', '26').must_equal 'A24'  }  # DATA DE EMISSÃO DO TÍTULO INVÁLIDA
		end
		context "CÓDIGOS para oa Caixa com Motivo Ocorrência A com codigo de movimento 30" do
			it { subject.get_codigo_motivo_ocorrencia('11', '30').must_equal 'A48' }  # CEP INVÁLIDO
			it { subject.get_codigo_motivo_ocorrencia('12', '30').must_equal 'A53' }  # NÚMERO INSCRIÇÃO INVÁLIDO DO SACADOR AVALISTA
			it { subject.get_codigo_motivo_ocorrencia('13', '30').must_equal 'A86' }  # SEU NÚMERO COM O MESMO CONTEÚDO
			it { subject.get_codigo_motivo_ocorrencia('67', '30').must_equal 'A54' }  # NOME INVÁLIDO DO SACADOR AVALISTA
			it { subject.get_codigo_motivo_ocorrencia('72', '30').must_equal 'A54' }  # ENDEREÇO INVÁLIDO – SACADOR AVALISTA
			it { subject.get_codigo_motivo_ocorrencia('73', '30').must_equal 'A54' }  # BAIRRO INVÁLIDO – SACADOR AVALISTA
			it { subject.get_codigo_motivo_ocorrencia('74', '30').must_equal 'A54' }  # CIDADE INVÁLIDA – SACADOR AVALISTA
			it { subject.get_codigo_motivo_ocorrencia('75', '30').must_equal 'A54' }  # SIGLA ESTADO INVÁLIDO – SACADOR AVALISTA
			it { subject.get_codigo_motivo_ocorrencia('76', '30').must_equal 'A54' }  # CEP INVÁLIDO – SACADOR AVALISTA
		end
		
		context "CÓDIGOS para oa Caixa com Motivo Ocorrência C" do
			it { subject.get_codigo_motivo_ocorrencia('AA', '06').must_equal 'C32' }   # CAIXA ELETRÔNICO ITAÚ
			it { subject.get_codigo_motivo_ocorrencia('AC', '09').must_equal 'C08' }   # PAGAMENTO EM CARTÓRIO AUTOMATIZADO
			it { subject.get_codigo_motivo_ocorrencia('BC', '17').must_equal 'C31' }   # BANCOS CORRESPONDENTES
			it { subject.get_codigo_motivo_ocorrencia('BF', '06').must_equal 'C37' }   # ITAÚ BANKFONE
			it { subject.get_codigo_motivo_ocorrencia('BL', '09').must_equal 'C33' }   # ITAÚ BANKLINE
			it { subject.get_codigo_motivo_ocorrencia('CC', '17').must_equal 'C36' }   # AGÊNCIA ITAÚ – COM CHEQUE DE OUTRO BANCO ou (CHEQUE ITAÚ)
			it { subject.get_codigo_motivo_ocorrencia('EA', '06').must_equal 'C03' }   # TERMINAL DE CAIXA
		end
	end

	describe "#get_codigo_ocorrencia_pagador" do
		context "CÓDIGOS para oa Caixa com Motivo Ocorrência A com codigo de movimento 03" do
			it { subject.get_codigo_ocorrencia_pagador('1313').must_equal '0302' } # SOLICITA A PRORROGAÇÃO DO VENCIMENTO PARA:
			it { subject.get_codigo_ocorrencia_pagador('1321').must_equal '0503' } # SOLICITA A DISPENSA DOS JUROS DE MORA
			it { subject.get_codigo_ocorrencia_pagador('1339').must_equal '0101' } # NÃO RECEBEU A MERCADORIA
			it { subject.get_codigo_ocorrencia_pagador('1347').must_equal '0102' } # A MERCADORIA CHEGOU ATRASADA
			it { subject.get_codigo_ocorrencia_pagador('1354').must_equal '0103' } # A MERCADORIA CHEGOU AVARIADA
			it { subject.get_codigo_ocorrencia_pagador('1362').must_equal '0105' } # A MERCADORIA CHEGOU INCOMPLETA
			it { subject.get_codigo_ocorrencia_pagador('1370').must_equal '0104' } # A MERCADORIA NÃO CONFERE COM O PEDIDO
			it { subject.get_codigo_ocorrencia_pagador('1388').must_equal '0106' } # A MERCADORIA ESTÁ À DISPOSIÇÃO
			it { subject.get_codigo_ocorrencia_pagador('1396').must_equal '0107' } # DEVOLVEU A MERCADORIA
			it { subject.get_codigo_ocorrencia_pagador('1404').must_equal '0201' } # NÃO RECEBEU A FATURA
			it { subject.get_codigo_ocorrencia_pagador('1412').must_equal '0108' } # A FATURA ESTÁ EM DESACORDO COM A NOTA FISCAL
			it { subject.get_codigo_ocorrencia_pagador('1420').must_equal '0202' } # O PEDIDO DE COMPRA FOI CANCELADO
			it { subject.get_codigo_ocorrencia_pagador('1438').must_equal '0203' } # A DUPLICATA FOI CANCELADA
			it { subject.get_codigo_ocorrencia_pagador('1446').must_equal '0109' } # QUE NADA DEVE OU COMPROU
			it { subject.get_codigo_ocorrencia_pagador('1453').must_equal '0603' } # QUE MANTÉM ENTENDIMENTOS COM O SACADOR
			it { subject.get_codigo_ocorrencia_pagador('1461').must_equal '0304' } # QUE PAGARÁ O TÍTULO EM:
			it { subject.get_codigo_ocorrencia_pagador('1479').must_equal '0305' } # QUE PAGOU O TÍTULO DIRETAMENTE AO BENEFICIÁRIO EM:
			it { subject.get_codigo_ocorrencia_pagador('1487').must_equal '0306' } # QUE PAGARÁ O TÍTULO DIRETAMENTE AO BENEFICIÁRIO EM:
			it { subject.get_codigo_ocorrencia_pagador('1495').must_equal '0301' } # QUE O VENCIMENTO CORRETO É:
			it { subject.get_codigo_ocorrencia_pagador('1503').must_equal '0501' } # QUE TEM DESCONTO OU ABATIMENTO DE:
			it { subject.get_codigo_ocorrencia_pagador('1719').must_equal '0401' } # PAGADOR NÃO FOI LOCALIZADO; CONFIRMAR ENDEREÇO
			it { subject.get_codigo_ocorrencia_pagador('1727').must_equal '0601' } # PAGADOR ESTÁ EM REGIME DE CONCORDATA
			it { subject.get_codigo_ocorrencia_pagador('1735').must_equal '0602' } # PAGADOR ESTÁ EM REGIME DE FALÊNCIA
			it { subject.get_codigo_ocorrencia_pagador('1750').must_equal '0504' } # PAGADOR SE RECUSA A PAGAR JUROS BANCÁRIOS
			it { subject.get_codigo_ocorrencia_pagador('1768').must_equal '0505' } # PAGADOR SE RECUSA A PAGAR COMISSÃO DE PERMANÊNCIA
			it { subject.get_codigo_ocorrencia_pagador('1776').must_equal '1776' } # NÃO FOI POSSÍVEL A ENTREGA DO BOLETO AO PAGADOR
			it { subject.get_codigo_ocorrencia_pagador('1784').must_equal '1784' } # BOLETO NÃO ENTREGUE, MUDOU-SE/DESCONHECIDO
			it { subject.get_codigo_ocorrencia_pagador('1792').must_equal '1792' } # BOLETO NÃO ENTREGUE, CEP ERRADO/INCOMPLETO
			it { subject.get_codigo_ocorrencia_pagador('1800').must_equal '1800' } # BOLETO NÃO ENTREGUE, NÚMERO NÃO EXISTE/ENDEREÇO INCOMPLETO
			it { subject.get_codigo_ocorrencia_pagador('1834').must_equal '1834' } # BOLETO DDA, DIVIDA RECONHECIDA PELO PAGADOR
			it { subject.get_codigo_ocorrencia_pagador('1842').must_equal '1842' } # BOLETO DDA, DIVIDA NÃO RECONHECIDA PELO PAGADOR
		end
	end

	describe "#get_codigo_movimento_retorno" do
		context "CÓDIGOS para o cnab 400 do SICOOB" do
			it { subject.get_codigo_movimento_retorno('07', 400).must_equal '102' }  # LIQUIDAÇÃO PARCIAL – COBRANÇA INTELIGENTE (B2B)
			it { subject.get_codigo_movimento_retorno('24', 400).must_equal '20' }   # INSTRUÇÃO DE PROTESTO REJEITADA / SUSTADA / PENDENTE (NOTA 20 – TABELA 7)
			it { subject.get_codigo_movimento_retorno('25', 400).must_equal '29' }   # ALEGAÇÕES DO PAGADOR (NOTA 20 – TABELA 6)
			it { subject.get_codigo_movimento_retorno('59', 400).must_equal '259' }  # BAIXA POR CRÉDITO EM C/C ATRAVÉS DO SISPAG
			it { subject.get_codigo_movimento_retorno('64', 400).must_equal '264' }  # ENTRADA CONFIRMADA COM RATEIO DE CRÉDITO
			it { subject.get_codigo_movimento_retorno('65', 400).must_equal '265' }  # PAGAMENTO COM CHEQUE – AGUARDANDO COMPENSAÇÃO
			it { subject.get_codigo_movimento_retorno('69', 400).must_equal '44' }   # CHEQUE DEVOLVIDO (NOTA 20 – TABELA 9)
			it { subject.get_codigo_movimento_retorno('71', 400).must_equal '271' }  # ENTRADA REGISTRADA, AGUARDANDO AVALIAÇÃO
			it { subject.get_codigo_movimento_retorno('72', 400).must_equal '272' }  # BAIXA POR CRÉDITO EM C/C ATRAVÉS DO SISPAG SEM TÍTULO CORRESPONDENTE
			it { subject.get_codigo_movimento_retorno('73', 400).must_equal '273' }  # CONFIRMAÇÃO DE ENTRADA NA COBRANÇA SIMPLES – ENTRADA NÃO ACEITA NA COBRANÇA CONTRATUAL
			it { subject.get_codigo_movimento_retorno('76', 400).must_equal '45' }   # CHEQUE COMPENSADO
		end
	end
end