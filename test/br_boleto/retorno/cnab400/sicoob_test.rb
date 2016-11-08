require 'test_helper'

describe BrBoleto::Retorno::Cnab400::Sicoob do
	subject { BrBoleto::Retorno::Cnab400::Sicoob.new(file) }
	let(:file) { open_fixture('retorno/cnab400/sicoob.ret') }

	it "Deve ler o código do banco" do
		subject.codigo_banco.must_equal '756'
	end

	it "Deve carregar 5 pagamentos" do
		subject.pagamentos.size.must_equal 5
	end

	describe "deve setar as informações corretas para os pagamentos" do
		it "valores para o pagamento 1" do
			pagamento = subject.pagamentos[0]
			pagamento.modalidade.must_equal                '01'
			pagamento.agencia_com_dv.must_equal            "30690"
			pagamento.agencia_sem_dv.must_equal            "3069"
			pagamento.numero_conta_com_dv.must_equal       "000567329"
			pagamento.numero_conta_dv.must_equal           "9"
			pagamento.numero_conta.must_equal              "00056732"
			pagamento.nosso_numero.must_equal              "000000157595"
			pagamento.carteira.must_equal                  "1"
			pagamento.numero_documento.must_equal          "000000000157595"
			pagamento.data_vencimento.must_equal           Date.parse('16/09/2016')
			pagamento.valor_titulo.must_equal              400.0
			pagamento.banco_recebedor.must_equal           "756"
			pagamento.agencia_recebedora_com_dv.must_equal "30690"
			pagamento.sacado_documento.must_equal          "00000000000000"
			pagamento.valor_tarifa.must_equal              1.89
			pagamento.valor_juros_multa.must_equal         0.0
			pagamento.valor_desconto.must_equal            10.0
			pagamento.valor_abatimento.must_equal          0.0
			pagamento.valor_iof.must_equal                 0.0
			pagamento.valor_pago.must_equal                390.0
			pagamento.valor_liquido.must_equal             390.0
			pagamento.valor_outras_despesas.must_equal     0.0
			pagamento.valor_outros_creditos.must_equal     0.0
			pagamento.data_ocorrencia.must_equal           Date.parse('05/09/2016')
			pagamento.data_credito.must_equal              Date.parse('05/09/2016')
			pagamento.data_ocorrencia_sacado.must_equal    Date.parse('05/09/2016')
			pagamento.valor_ocorrencia_sacado.must_equal   390.0
			pagamento.parcela.must_equal                   '01'
			pagamento.especie_titulo.must_equal            '01'
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_be_nil
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia.must_be_nil
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
		end
		it "valores para o pagamento 2" do
			pagamento = subject.pagamentos[1]
			pagamento.modalidade.must_equal                '02'
			pagamento.agencia_com_dv.must_equal            "30690"
			pagamento.agencia_sem_dv.must_equal            "3069"
			pagamento.numero_conta_com_dv.must_equal       "000567329"
			pagamento.numero_conta_dv.must_equal           "9"
			pagamento.numero_conta.must_equal              "00056732"
			pagamento.nosso_numero.must_equal              "000000152106"
			pagamento.carteira.must_equal                  "2"
			pagamento.numero_documento.must_equal          "000000000152106"
			pagamento.data_vencimento.must_equal           Date.parse('10/09/2016')
			pagamento.valor_titulo.must_equal              59.0
			pagamento.banco_recebedor.must_equal           "104"
			pagamento.agencia_recebedora_com_dv.must_equal "07010"
			pagamento.sacado_documento.must_equal          "11111111111111"
			pagamento.valor_tarifa.must_equal              2.29
			pagamento.valor_juros_multa.must_equal         0.0
			pagamento.valor_desconto.must_equal            0.0
			pagamento.valor_abatimento.must_equal          0.0
			pagamento.valor_iof.must_equal                 0.0
			pagamento.valor_pago.must_equal                59.0
			pagamento.valor_liquido.must_equal             59.0
			pagamento.valor_outras_despesas.must_equal     0.0
			pagamento.valor_outros_creditos.must_equal     0.0
			pagamento.data_ocorrencia.must_equal           Date.parse('05/09/2016')
			pagamento.data_credito.must_equal              Date.parse('05/09/2016')
			pagamento.data_ocorrencia_sacado.must_equal    Date.parse('05/09/2016')
			pagamento.valor_ocorrencia_sacado.must_equal   59.0
			pagamento.parcela.must_equal                   '01'
			pagamento.especie_titulo.must_equal            '02'
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_be_nil
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia.must_be_nil
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
		end
		it "valores para o pagamento 3" do
			pagamento = subject.pagamentos[2]
			pagamento.modalidade.must_equal                '03'
			pagamento.agencia_com_dv.must_equal            "30690"
			pagamento.agencia_sem_dv.must_equal            "3069"
			pagamento.numero_conta_com_dv.must_equal       "000567329"
			pagamento.numero_conta_dv.must_equal           "9"
			pagamento.numero_conta.must_equal              "00056732"
			pagamento.nosso_numero.must_equal              "000000156601"
			pagamento.carteira.must_equal                  "3"
			pagamento.numero_documento.must_equal          "000000000156601"
			pagamento.data_vencimento.must_equal           Date.parse('05/09/2016')
			pagamento.valor_titulo.must_equal              250.0
			pagamento.banco_recebedor.must_equal           "104"
			pagamento.agencia_recebedora_com_dv.must_equal "05800"
			pagamento.sacado_documento.must_equal          "22222222222222"
			pagamento.valor_tarifa.must_equal              2.29
			pagamento.valor_juros_multa.must_equal         0.0
			pagamento.valor_desconto.must_equal            0.0
			pagamento.valor_abatimento.must_equal          0.0
			pagamento.valor_iof.must_equal                 0.0
			pagamento.valor_pago.must_equal                250.0
			pagamento.valor_liquido.must_equal             250.0
			pagamento.valor_outras_despesas.must_equal     0.0
			pagamento.valor_outros_creditos.must_equal     0.0
			pagamento.data_ocorrencia.must_equal           Date.parse('05/09/2016')
			pagamento.data_credito.must_equal              Date.parse('05/09/2016')
			pagamento.data_ocorrencia_sacado.must_equal    Date.parse('05/09/2016')
			pagamento.valor_ocorrencia_sacado.must_equal   250.0
			pagamento.parcela.must_equal                   '01'
			pagamento.especie_titulo.must_equal            '03'
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_be_nil
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia.must_be_nil
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
		end
		it "valores para o pagamento 4" do
			pagamento = subject.pagamentos[3]
			pagamento.modalidade.must_equal                '01'
			pagamento.agencia_com_dv.must_equal            "30690"
			pagamento.agencia_sem_dv.must_equal            "3069"
			pagamento.numero_conta_com_dv.must_equal       "000567329"
			pagamento.numero_conta_dv.must_equal           "9"
			pagamento.numero_conta.must_equal              "00056732"
			pagamento.nosso_numero.must_equal              "000000157517"
			pagamento.carteira.must_equal                  "1"
			pagamento.numero_documento.must_equal          "000000000157517"
			pagamento.data_vencimento.must_equal           Date.parse('10/09/2016')
			pagamento.valor_titulo.must_equal              50.0
			pagamento.banco_recebedor.must_equal           "001"
			pagamento.agencia_recebedora_com_dv.must_equal "83480"
			pagamento.sacado_documento.must_equal          "33333333333333"
			pagamento.valor_tarifa.must_equal              2.29
			pagamento.valor_juros_multa.must_equal         0.0
			pagamento.valor_desconto.must_equal            0.0
			pagamento.valor_abatimento.must_equal          0.0
			pagamento.valor_iof.must_equal                 0.0
			pagamento.valor_pago.must_equal                50.0
			pagamento.valor_liquido.must_equal             50.0
			pagamento.valor_outras_despesas.must_equal     0.0
			pagamento.valor_outros_creditos.must_equal     0.0
			pagamento.data_ocorrencia.must_equal           Date.parse('05/09/2016')
			pagamento.data_credito.must_equal              Date.parse('05/09/2016')
			pagamento.data_ocorrencia_sacado.must_equal    Date.parse('05/09/2016')
			pagamento.valor_ocorrencia_sacado.must_equal   50.0
			pagamento.parcela.must_equal                   '01'
			pagamento.especie_titulo.must_equal            '04'
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_be_nil
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia.must_be_nil
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
		end
		it "valores para o pagamento 5" do
			pagamento = subject.pagamentos[4]
			pagamento.modalidade.must_equal                '01'
			pagamento.agencia_com_dv.must_equal            "30690"
			pagamento.agencia_sem_dv.must_equal            "3069"
			pagamento.numero_conta_com_dv.must_equal       "000567329"
			pagamento.numero_conta_dv.must_equal           "9"
			pagamento.numero_conta.must_equal              "00056732"
			pagamento.nosso_numero.must_equal              "000000157610"
			pagamento.carteira.must_equal                  "1"
			pagamento.numero_documento.must_equal          "000000000157610"
			pagamento.data_vencimento.must_equal           Date.parse('12/09/2016')
			pagamento.valor_titulo.must_equal              350.0
			pagamento.banco_recebedor.must_equal           "756"
			pagamento.agencia_recebedora_com_dv.must_equal "30690"
			pagamento.sacado_documento.must_equal          "44444444444444"
			pagamento.valor_tarifa.must_equal              1.89
			pagamento.valor_juros_multa.must_equal         0.0
			pagamento.valor_desconto.must_equal            0.0
			pagamento.valor_abatimento.must_equal          0.0
			pagamento.valor_iof.must_equal                 0.0
			pagamento.valor_pago.must_equal                350.0
			pagamento.valor_liquido.must_equal             350.0
			pagamento.valor_outras_despesas.must_equal     0.0
			pagamento.valor_outros_creditos.must_equal     0.0
			pagamento.data_ocorrencia.must_equal           Date.parse('05/09/2016')
			pagamento.data_credito.must_equal              Date.parse('05/09/2016')
			pagamento.data_ocorrencia_sacado.must_equal    Date.parse('05/09/2016')
			pagamento.valor_ocorrencia_sacado.must_equal   350.0
			pagamento.parcela.must_equal                   '01'
			pagamento.especie_titulo.must_equal            '05'
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_be_nil
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia.must_be_nil
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
		end
	end
end