require 'test_helper'

describe BrBoleto::Retorno::Cnab400::Bradesco do
	subject { BrBoleto::Retorno::Cnab400::Bradesco.new(file) }
	let(:file) { open_fixture('retorno/cnab400/bradesco.ret') }
	

	it "Deve carregar 6 pagamentos" do
		subject.pagamentos.size.must_equal 6
	end

	describe 'deve setar as informações corretas para os pagamentos' do
		it "valores para o pagamento 1" do
			pagamento = subject.pagamentos[0]
			pagamento.agencia_sem_dv.must_equal            "01467"
			pagamento.numero_conta.must_equal              "0019669"
			pagamento.numero_conta_dv.must_equal           "9"
			pagamento.numero_conta_sem_dv.must_equal       "001966"
			pagamento.nosso_numero.must_equal              "000000000303"
			pagamento.nosso_numero_sem_dv.must_equal       "00000000030"
			pagamento.nosso_numero_dv.must_equal           "3"
			pagamento.carteira.must_equal                  "09"
			pagamento.numero_documento.must_equal          "0030"
			pagamento.data_vencimento.must_equal           Date.parse('25/05/2015')
			pagamento.valor_titulo.must_equal              1450.0
			pagamento.banco_recebedor.must_equal           "237"
			pagamento.agencia_recebedora_com_dv.must_equal "04157"
			pagamento.sacado_documento.must_equal          "12095870000170"
			pagamento.valor_tarifa.must_equal              1.60
			pagamento.valor_juros_multa.must_equal         0.0
			pagamento.valor_desconto.must_equal            0.0
			pagamento.valor_abatimento.must_equal          0.0
			pagamento.valor_iof.must_equal                 0.0
			pagamento.valor_pago.must_equal                1450.0
			pagamento.valor_liquido.must_equal             1450.0
			pagamento.valor_outras_despesas.must_equal     0.0
			pagamento.valor_outros_creditos.must_equal     0.0
			pagamento.data_ocorrencia.must_equal           Date.parse('15/05/2015')
			pagamento.data_credito.must_equal              Date.parse('15/05/2015')
			pagamento.data_ocorrencia_sacado.must_equal    Date.parse('15/05/2015')
			pagamento.valor_ocorrencia_sacado.must_equal   1450.0
			pagamento.especie_titulo.must_equal            ''
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_be_nil
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia_original_1.must_equal '00'
			pagamento.motivo_ocorrencia_original_2.must_equal '00'
			pagamento.motivo_ocorrencia_original_3.must_equal '00'
			pagamento.motivo_ocorrencia_original_4.must_equal '00'
			pagamento.motivo_ocorrencia_original_5.must_equal '00'
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
		end

		it "valores para o pagamento 2" do
			pagamento = subject.pagamentos[1]
			pagamento.agencia_sem_dv.must_equal            "01467"
			pagamento.numero_conta.must_equal              "0019669"
			pagamento.numero_conta_dv.must_equal           "9"
			pagamento.numero_conta_sem_dv.must_equal       "001966"
			pagamento.nosso_numero.must_equal              "51350000004P"
			pagamento.nosso_numero_sem_dv.must_equal       "51350000004"
			pagamento.nosso_numero_dv.must_equal           "P"
			pagamento.carteira.must_equal                  "09"
			pagamento.numero_documento.must_equal          "1146"
			pagamento.data_vencimento.must_equal           Date.parse('25/05/2015')
			pagamento.valor_titulo.must_equal              180.0
			pagamento.banco_recebedor.must_equal           "237"
			pagamento.agencia_recebedora_com_dv.must_equal "04157"
			pagamento.sacado_documento.must_equal          "12095870000170"
			pagamento.valor_tarifa.must_equal              1.60
			pagamento.valor_juros_multa.must_equal         0.0
			pagamento.valor_desconto.must_equal            0.0
			pagamento.valor_abatimento.must_equal          0.0
			pagamento.valor_iof.must_equal                 0.0
			pagamento.valor_pago.must_equal                0.0
			pagamento.valor_liquido.must_equal             0.0
			pagamento.valor_outras_despesas.must_equal     0.0
			pagamento.valor_outros_creditos.must_equal     0.0
			pagamento.data_ocorrencia.must_equal           Date.parse('15/05/2015')
			pagamento.data_ocorrencia_sacado.must_equal    Date.parse('15/05/2015')
			pagamento.valor_ocorrencia_sacado.must_equal   0.0
			pagamento.especie_titulo.must_equal            ''
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_be_nil
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia_original_1.must_equal '00'
			pagamento.motivo_ocorrencia_original_2.must_equal '00'
			pagamento.motivo_ocorrencia_original_3.must_equal '00'
			pagamento.motivo_ocorrencia_original_4.must_equal '00'
			pagamento.motivo_ocorrencia_original_5.must_equal '00'
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
		end

		it "valores para o pagamento 3" do
			pagamento = subject.pagamentos[2]
			pagamento.agencia_sem_dv.must_equal            "01467"
			pagamento.numero_conta.must_equal              "0019669"
			pagamento.numero_conta_dv.must_equal           "9"
			pagamento.numero_conta_sem_dv.must_equal       "001966"
			pagamento.nosso_numero.must_equal              "513500000074"
			pagamento.nosso_numero_sem_dv.must_equal       "51350000007"
			pagamento.nosso_numero_dv.must_equal           "4"
			pagamento.carteira.must_equal                  "09"
			pagamento.numero_documento.must_equal          "1142"
			pagamento.data_vencimento.must_equal           Date.parse('25/05/2015')
			pagamento.valor_titulo.must_equal              720.0
			pagamento.banco_recebedor.must_equal           "237"
			pagamento.agencia_recebedora_com_dv.must_equal "04157"
			pagamento.sacado_documento.must_equal          "12095870000170"
			pagamento.valor_tarifa.must_equal              1.60
			pagamento.valor_juros_multa.must_equal         0.0
			pagamento.valor_desconto.must_equal            0.0
			pagamento.valor_abatimento.must_equal          0.0
			pagamento.valor_iof.must_equal                 0.0
			pagamento.valor_pago.must_equal                0.0
			pagamento.valor_liquido.must_equal             0.0
			pagamento.valor_outras_despesas.must_equal     0.0
			pagamento.valor_outros_creditos.must_equal     0.0
			pagamento.data_ocorrencia.must_equal           Date.parse('15/05/2015')
			pagamento.data_ocorrencia_sacado.must_equal    Date.parse('15/05/2015')
			pagamento.valor_ocorrencia_sacado.must_equal   0.0
			pagamento.especie_titulo.must_equal            ''
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_be_nil
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia_original_1.must_equal '00'
			pagamento.motivo_ocorrencia_original_2.must_equal '00'
			pagamento.motivo_ocorrencia_original_3.must_equal '00'
			pagamento.motivo_ocorrencia_original_4.must_equal '00'
			pagamento.motivo_ocorrencia_original_5.must_equal '00'
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
		end

		it "valores para o pagamento 4" do
			pagamento = subject.pagamentos[3]
			pagamento.agencia_sem_dv.must_equal            "01467"
			pagamento.numero_conta.must_equal              "0019669"
			pagamento.numero_conta_dv.must_equal           "9"
			pagamento.numero_conta_sem_dv.must_equal       "001966"
			pagamento.nosso_numero.must_equal              "513500000090"
			pagamento.nosso_numero_sem_dv.must_equal       "51350000009"
			pagamento.nosso_numero_dv.must_equal           "0"
			pagamento.carteira.must_equal                  "09"
			pagamento.numero_documento.must_equal          "1145"
			pagamento.data_vencimento.must_equal           Date.parse('12/06/2015')
			pagamento.valor_titulo.must_equal              200.0
			pagamento.banco_recebedor.must_equal           "237"
			pagamento.agencia_recebedora_com_dv.must_equal "04157"
			pagamento.sacado_documento.must_equal          "12095870000170"
			pagamento.valor_tarifa.must_equal              1.60
			pagamento.valor_juros_multa.must_equal         0.0
			pagamento.valor_desconto.must_equal            0.0
			pagamento.valor_abatimento.must_equal          0.0
			pagamento.valor_iof.must_equal                 0.0
			pagamento.valor_pago.must_equal                0.0
			pagamento.valor_liquido.must_equal             0.0
			pagamento.valor_outras_despesas.must_equal     0.0
			pagamento.valor_outros_creditos.must_equal     0.0
			pagamento.data_ocorrencia.must_equal           Date.parse('15/05/2015')
			pagamento.data_ocorrencia_sacado.must_equal    Date.parse('15/05/2015')
			pagamento.valor_ocorrencia_sacado.must_equal   0.0
			pagamento.especie_titulo.must_equal            ''
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_be_nil
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia_original_1.must_equal '00'
			pagamento.motivo_ocorrencia_original_2.must_equal '00'
			pagamento.motivo_ocorrencia_original_3.must_equal '00'
			pagamento.motivo_ocorrencia_original_4.must_equal '00'
			pagamento.motivo_ocorrencia_original_5.must_equal '00'
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
		end

		it "valores para o pagamento 5" do
			pagamento = subject.pagamentos[4]
			pagamento.agencia_sem_dv.must_equal            "01467"
			pagamento.numero_conta.must_equal              "0019669"
			pagamento.numero_conta_dv.must_equal           "9"
			pagamento.numero_conta_sem_dv.must_equal       "001966"
			pagamento.nosso_numero.must_equal              "513500000112"
			pagamento.nosso_numero_sem_dv.must_equal       "51350000011"
			pagamento.nosso_numero_dv.must_equal           "2"
			pagamento.carteira.must_equal                  "09"
			pagamento.numero_documento.must_equal          "1144"
			pagamento.data_vencimento.must_equal           Date.parse('25/05/2015')
			pagamento.valor_titulo.must_equal              180.0
			pagamento.banco_recebedor.must_equal           "237"
			pagamento.agencia_recebedora_com_dv.must_equal "04157"
			pagamento.sacado_documento.must_equal          "12095870000170"
			pagamento.valor_tarifa.must_equal              1.60
			pagamento.valor_juros_multa.must_equal         0.0
			pagamento.valor_desconto.must_equal            0.0
			pagamento.valor_abatimento.must_equal          0.0
			pagamento.valor_iof.must_equal                 0.0
			pagamento.valor_pago.must_equal                0.0
			pagamento.valor_liquido.must_equal             0.0
			pagamento.valor_outras_despesas.must_equal     0.0
			pagamento.valor_outros_creditos.must_equal     0.0
			pagamento.data_ocorrencia.must_equal           Date.parse('15/05/2015')
			pagamento.data_ocorrencia_sacado.must_equal    Date.parse('15/05/2015')
			pagamento.valor_ocorrencia_sacado.must_equal   0.0
			pagamento.especie_titulo.must_equal            ''
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_be_nil
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia_original_1.must_equal '00'
			pagamento.motivo_ocorrencia_original_2.must_equal '00'
			pagamento.motivo_ocorrencia_original_3.must_equal '00'
			pagamento.motivo_ocorrencia_original_4.must_equal '00'
			pagamento.motivo_ocorrencia_original_5.must_equal '00'
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
		end

		it "valores para o pagamento 6" do
			pagamento = subject.pagamentos[5]
			pagamento.agencia_sem_dv.must_equal            "01467"
			pagamento.numero_conta.must_equal              "0019669"
			pagamento.numero_conta_dv.must_equal           "9"
			pagamento.numero_conta_sem_dv.must_equal       "001966"
			pagamento.nosso_numero.must_equal              "509800000028"
			pagamento.nosso_numero_sem_dv.must_equal       "50980000002"
			pagamento.nosso_numero_dv.must_equal           "8"
			pagamento.carteira.must_equal                  "09"
			pagamento.numero_documento.must_equal          "1053"
			pagamento.data_vencimento.must_equal           Date.parse('06/05/2015')
			pagamento.valor_titulo.must_equal              200.0
			pagamento.banco_recebedor.must_equal           "237"
			pagamento.agencia_recebedora_com_dv.must_equal "00000"
			pagamento.sacado_documento.must_equal          "12095870000170"
			pagamento.valor_tarifa.must_equal              0.0
			pagamento.valor_juros_multa.must_equal         0.0
			pagamento.valor_desconto.must_equal            0.0
			pagamento.valor_abatimento.must_equal          0.0
			pagamento.valor_iof.must_equal                 0.0
			pagamento.valor_pago.must_equal                0.0
			pagamento.valor_liquido.must_equal             0.0
			pagamento.valor_outras_despesas.must_equal     0.0
			pagamento.valor_outros_creditos.must_equal     0.0
			pagamento.data_ocorrencia.must_equal           Date.parse('15/05/2015')
			pagamento.data_ocorrencia_sacado.must_equal    Date.parse('15/05/2015')
			pagamento.valor_ocorrencia_sacado.must_equal   0.0
			pagamento.especie_titulo.must_equal            ''
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_be_nil
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia_original_1.must_equal '00'
			pagamento.motivo_ocorrencia_original_2.must_equal '00'
			pagamento.motivo_ocorrencia_original_3.must_equal '00'
			pagamento.motivo_ocorrencia_original_4.must_equal '00'
			pagamento.motivo_ocorrencia_original_5.must_equal '00'
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
		end

	end
end