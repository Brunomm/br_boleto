require 'test_helper'

describe BrBoleto::Retorno::Cnab400::Sicredi do
	subject { BrBoleto::Retorno::Cnab400::Sicredi.new(file) }
	let(:file) { open_fixture('retorno/cnab400/sicredi.ret') }

	it "Deve ler o código do banco" do
		subject.codigo_banco.must_equal '748'
	end

	it "Deve carregar 2 pagamentos" do
		subject.pagamentos.size.must_equal 2
	end

	describe "deve setar as informações corretas para os pagamentos" do
		it "valores para o pagamento 1" do
			pagamento = subject.pagamentos[0]
			pagamento.agencia_com_dv.must_be_nil
			pagamento.agencia_sem_dv.must_be_nil
			pagamento.numero_conta_dv.must_be_nil
			pagamento.numero_conta_sem_dv.must_be_nil
			pagamento.banco_recebedor.must_be_nil
			pagamento.agencia_recebedora_com_dv.must_be_nil
			pagamento.sacado_documento.must_be_nil
			pagamento.data_credito.must_be_nil
			pagamento.codigo_pagador_cooperativa.must_equal  "00000"
			pagamento.codigo_pagador_associado.must_equal    "00000"
			pagamento.nosso_numero.must_equal                "162000017"
			pagamento.nosso_numero_sem_dv.must_equal         "16200001"
			pagamento.nosso_numero_dv.must_equal             "7"
			pagamento.carteira.must_equal                    "C"
			pagamento.numero_documento.must_equal            ""
			pagamento.data_vencimento.must_be_nil
			pagamento.valor_titulo.must_equal                5.0
			pagamento.valor_tarifa.must_equal                0.0
			pagamento.valor_juros_multa.must_equal           0.0
			pagamento.valor_desconto.must_equal              0.0
			pagamento.valor_abatimento.must_equal            0.0
			pagamento.valor_pago.must_equal                  5.0
			pagamento.valor_liquido.must_equal               5.0
			pagamento.valor_outras_despesas.must_equal       0.0
			pagamento.valor_outros_creditos.must_equal       0.0
			pagamento.data_ocorrencia.must_equal             Date.parse('05/12/2016')
			pagamento.data_ocorrencia_sacado.must_equal      Date.parse('05/12/2016')
			pagamento.valor_ocorrencia_sacado.must_equal     5.0
			pagamento.especie_titulo.must_equal              ''
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_be_nil
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia_original_1.must_equal 'H5'
			pagamento.motivo_ocorrencia_original_2.must_equal ''
			pagamento.motivo_ocorrencia_original_3.must_equal ''
			pagamento.motivo_ocorrencia_original_4.must_equal ''
			pagamento.motivo_ocorrencia_original_5.must_equal ''
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
		end
		it "valores para o pagamento 2" do
			pagamento = subject.pagamentos[1]
			pagamento.agencia_com_dv.must_be_nil
			pagamento.agencia_sem_dv.must_be_nil
			pagamento.numero_conta_dv.must_be_nil
			pagamento.numero_conta_sem_dv.must_be_nil
			pagamento.banco_recebedor.must_be_nil
			pagamento.agencia_recebedora_com_dv.must_be_nil
			pagamento.sacado_documento.must_be_nil
			pagamento.data_credito.must_be_nil
			pagamento.codigo_pagador_cooperativa.must_equal  "00000"
			pagamento.codigo_pagador_associado.must_equal    "00000"
			pagamento.nosso_numero.must_equal                "162000017"
			pagamento.nosso_numero_sem_dv.must_equal         "16200001"
			pagamento.nosso_numero_dv.must_equal             "7"
			pagamento.carteira.must_equal                    "C"
			pagamento.numero_documento.must_equal            ""
			pagamento.data_vencimento.must_be_nil
			pagamento.valor_titulo.must_equal                2.5
			pagamento.valor_tarifa.must_equal                0.0
			pagamento.valor_juros_multa.must_equal           0.0
			pagamento.valor_desconto.must_equal              0.0
			pagamento.valor_abatimento.must_equal            0.0
			pagamento.valor_pago.must_equal                  5.0
			pagamento.valor_liquido.must_equal               5.0
			pagamento.valor_outras_despesas.must_equal       0.0
			pagamento.valor_outros_creditos.must_equal       0.0
			pagamento.data_ocorrencia.must_equal             Date.parse('05/12/2016')
			pagamento.data_ocorrencia_sacado.must_equal      Date.parse('05/12/2016')
			pagamento.valor_ocorrencia_sacado.must_equal     5.0
			pagamento.especie_titulo.must_equal              ''
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_be_nil
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia_original_1.must_equal 'B3'
			pagamento.motivo_ocorrencia_original_2.must_equal ''
			pagamento.motivo_ocorrencia_original_3.must_equal ''
			pagamento.motivo_ocorrencia_original_4.must_equal ''
			pagamento.motivo_ocorrencia_original_5.must_equal ''
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
		end
	end
end