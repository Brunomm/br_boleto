require 'test_helper'

describe BrBoleto::Retorno::Cnab400::Itau do
	subject { BrBoleto::Retorno::Cnab400::Itau.new(file) }
	let(:file) { open_fixture('retorno/cnab400/itau.ret') }

		it "Deve carregar 52 pagamentos" do
		subject.pagamentos.size.must_equal 52
	end

	describe 'deve setar as informações corretas para os pagamentos' do
		it "valores para o pagamento 1" do
			pagamento = subject.pagamentos[0]
			pagamento.agencia_sem_dv.must_equal            "0730"
			pagamento.numero_conta_sem_dv.must_equal       "03511"
			pagamento.numero_conta_dv.must_equal           "0"
			pagamento.numero_conta.must_equal              "035110"
			pagamento.carteira.must_equal                  "109"
			pagamento.numero_documento.must_equal          "00000011"
			pagamento.nosso_numero_sem_dv.must_equal       "00000011"
			pagamento.nosso_numero_dv.must_equal           "4"
			pagamento.cod_carteira.must_equal              "I"
			pagamento.data_vencimento.must_be_nil
			pagamento.valor_titulo.must_equal              40.0    # 0000000004000
			pagamento.banco_recebedor.must_equal           "104"
			pagamento.agencia_recebedora_com_dv.must_equal "18739"
			pagamento.sacado_documento.must_equal          "16733872000107"
			pagamento.valor_tarifa.must_equal              2.10    # 0000000000210
			pagamento.valor_juros_multa.must_equal         0.0     
			pagamento.valor_desconto.must_equal            0.0     
			pagamento.valor_abatimento.must_equal          0.0     
			pagamento.valor_iof.must_equal                 0.0     
			pagamento.valor_pago.must_equal                37.9    # 0000000003790
			pagamento.valor_liquido.must_equal             37.9
			pagamento.valor_outros_creditos.must_equal     0.0
			pagamento.data_ocorrencia.must_equal           Date.parse('20/05/2013') # 200513
			pagamento.data_credito.must_equal              Date.parse('21/05/2013')  # 210513
			pagamento.data_ocorrencia_sacado.must_equal    Date.parse('20/05/2013') # 200513
			pagamento.valor_ocorrencia_sacado.must_equal   37.9
			pagamento.especie_titulo.must_equal            ''
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_equal               '' 
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia_original_1.must_be_nil
			pagamento.motivo_ocorrencia_original_2.must_be_nil
			pagamento.motivo_ocorrencia_original_3.must_be_nil
			pagamento.motivo_ocorrencia_original_4.must_be_nil
			pagamento.motivo_ocorrencia_original_5.must_be_nil
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
			pagamento.codigo_ocorrencia_retorno.must_equal '06'
		end
	end

	describe 'deve setar as informações corretas para os pagamentos' do
		it "valores para o pagamento 52" do
			pagamento = subject.pagamentos[51]
			pagamento.agencia_sem_dv.must_equal            "0730"
			pagamento.numero_conta_sem_dv.must_equal       "03511"
			pagamento.numero_conta_dv.must_equal           "0"
			pagamento.numero_conta.must_equal              "035110"
			pagamento.carteira.must_equal                  "157"
			pagamento.numero_documento.must_equal          "27714592"
			pagamento.nosso_numero_sem_dv.must_equal       "27714592"
			pagamento.nosso_numero_dv.must_equal           "2"
			pagamento.cod_carteira.must_equal              "I"
			pagamento.data_vencimento.must_equal           Date.parse('10/05/2013')
			pagamento.valor_titulo.must_equal              40.0    
			pagamento.banco_recebedor.must_equal           "341"
			pagamento.agencia_recebedora_com_dv.must_equal "77099"
			pagamento.sacado_documento.must_equal          "16733872000107"
			pagamento.valor_tarifa.must_equal              2.10    
			pagamento.valor_juros_multa.must_equal         0.0     
			pagamento.valor_desconto.must_equal            0.0     
			pagamento.valor_abatimento.must_equal          0.0     
			pagamento.valor_iof.must_equal                 0.0     
			pagamento.valor_pago.must_equal                2.1
			pagamento.valor_liquido.must_equal             2.1
			pagamento.valor_outros_creditos.must_equal     0.0
			pagamento.data_ocorrencia.must_equal           Date.parse('20/05/2013')
			pagamento.data_credito.must_be_nil
			pagamento.data_ocorrencia_sacado.must_equal    Date.parse('20/05/2013')
			pagamento.valor_ocorrencia_sacado.must_equal   2.1
			pagamento.especie_titulo.must_equal            ''
			pagamento.codigo_ocorrencia_sacado.must_be_nil
			pagamento.dv_conta_e_agencia.must_be_nil
			pagamento.identificacao_titulo_empresa.must_be_nil
			pagamento.codigo_moeda.must_be_nil
			pagamento.sacado_tipo_documento.must_be_nil
			pagamento.sacado_nome.must_equal               'MIRCALO TIADORO' 
			pagamento.numero_contrato.must_be_nil
			pagamento.motivo_ocorrencia_original_1.must_be_nil
			pagamento.motivo_ocorrencia_original_2.must_be_nil
			pagamento.motivo_ocorrencia_original_3.must_be_nil
			pagamento.motivo_ocorrencia_original_4.must_be_nil
			pagamento.motivo_ocorrencia_original_5.must_be_nil
			pagamento.complemento_ocorrencia_sacado.must_be_nil
			pagamento.codigo_ocorrencia_banco_correspondente.must_be_nil
			pagamento.nosso_numero_banco_correspondente.must_be_nil
			pagamento.codigo_ocorrencia_retorno.must_equal '09'
		end
	end
end