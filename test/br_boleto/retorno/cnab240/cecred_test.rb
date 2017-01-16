require 'test_helper'

require 'pry'
describe BrBoleto::Retorno::Cnab240::Cecred do
	subject { BrBoleto::Retorno::Cnab240::Cecred.new(file) }
	let(:file) { open_fixture('retorno/cnab240/cecred.ret') }
	

	it "Deve ler o código do banco" do
		subject.codigo_banco.must_equal '085'
	end

	it "Deve carregar 3 pagamentos" do
		subject.pagamentos.size.must_equal 3
	end

	describe "deve setar as informações corretas para os pagamentos" do
		it "valores para o pagamento 1" do
			pagamento = subject.pagamentos[0]
			pagamento.modalidade.must_equal                             nil
			pagamento.agencia_com_dv.must_equal                         "030690"
			pagamento.agencia_sem_dv.must_equal                         "03069"
			pagamento.numero_conta.must_equal                           "0000000777778"
			pagamento.numero_conta_dv.must_equal                        "8"
			pagamento.numero_conta_sem_dv.must_equal                    "000000077777"
			pagamento.dv_conta_e_agencia.must_equal                     "0"
			pagamento.nosso_numero_sem_dv.must_equal                    "00777778000000076"
			pagamento.carteira.must_equal                               "1"
			pagamento.numero_documento.must_equal                       "000000000000076"
			pagamento.data_vencimento.must_equal                        Date.parse('20/12/2016')
			pagamento.valor_titulo.must_equal                           260.0
			pagamento.banco_recebedor.must_equal                        "085"
			pagamento.agencia_recebedora_com_dv.must_equal              "030690"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "90"
			pagamento.sacado_tipo_documento.must_equal                  "2"
			pagamento.sacado_documento.must_equal                       "111111111111111"
			pagamento.sacado_nome.must_equal                            "EMPRESA DO CLIENTE1 LTDA"
			pagamento.numero_contrato.must_equal                        "0000000000"
			pagamento.valor_tarifa.must_equal                           0.0
			pagamento.motivo_ocorrencia_original_1.must_equal           ""
			pagamento.motivo_ocorrencia_original_2.must_equal           ""
			pagamento.motivo_ocorrencia_original_3.must_equal           ""
			pagamento.motivo_ocorrencia_original_4.must_equal           ""
			pagamento.motivo_ocorrencia_original_5.must_equal           ""
			pagamento.valor_juros_multa.must_equal                      0.0
			pagamento.valor_desconto.must_equal                         0.0
			pagamento.valor_abatimento.must_equal                       0.0
			pagamento.valor_iof.must_equal                              0.0
			pagamento.valor_pago.must_equal                             0.0
			pagamento.valor_liquido.must_equal                          0.0
			pagamento.valor_outras_despesas.must_equal                 0.0
			pagamento.valor_outros_creditos.must_equal                 0.0
			pagamento.data_ocorrencia.must_equal                        Date.parse('07/12/2016')
			pagamento.data_credito.must_equal                           nil
			pagamento.codigo_ocorrencia_sacado.must_equal               ""
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      "00000000000000000000"
			pagamento.codigo_movimento_retorno.must_equal               "02"
		end
		it "valores para o pagamento 2" do
			pagamento = subject.pagamentos[1]
			pagamento.modalidade.must_equal                             nil
			pagamento.agencia_com_dv.must_equal                         "030690"
			pagamento.agencia_sem_dv.must_equal                         "03069"
			pagamento.numero_conta.must_equal                           "0000000777778"
			pagamento.numero_conta_dv.must_equal                        "8"
			pagamento.numero_conta_sem_dv.must_equal                    "000000077777"
			pagamento.dv_conta_e_agencia.must_equal                     "0"
			pagamento.nosso_numero_sem_dv.must_equal                    "00777778000000071"
			pagamento.carteira.must_equal                               "1"
			pagamento.numero_documento.must_equal                       "000000000000071"
			pagamento.data_vencimento.must_equal                        Date.parse('07/12/2016')
			pagamento.valor_titulo.must_equal                           690.0
			pagamento.banco_recebedor.must_equal                        "033"
			pagamento.agencia_recebedora_com_dv.must_equal              "001473"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "90"
			pagamento.sacado_tipo_documento.must_equal                  "2"
			pagamento.sacado_documento.must_equal                       "222222222222222"
			pagamento.sacado_nome.must_equal                            "EMPRESA DO CLIENTE2 - ME"
			pagamento.numero_contrato.must_equal                        "0000000000"
			pagamento.valor_tarifa.must_equal                           4.0
			pagamento.motivo_ocorrencia_original_1.must_equal           "33"
			pagamento.motivo_ocorrencia_original_2.must_equal           ""
			pagamento.motivo_ocorrencia_original_3.must_equal           ""
			pagamento.motivo_ocorrencia_original_4.must_equal           ""
			pagamento.motivo_ocorrencia_original_5.must_equal           ""
			pagamento.valor_juros_multa.must_equal                      0.0
			pagamento.valor_desconto.must_equal                         0.0
			pagamento.valor_abatimento.must_equal                       0.0
			pagamento.valor_iof.must_equal                              0.0
			pagamento.valor_pago.must_equal                             690.0
			pagamento.valor_liquido.must_equal                          690.0
			pagamento.valor_outras_despesas.must_equal                 0.0
			pagamento.valor_outros_creditos.must_equal                 0.0
			pagamento.data_ocorrencia.must_equal                        Date.parse('07/12/2016')
			pagamento.data_credito.must_equal                           Date.parse('08/12/2016')
			pagamento.codigo_ocorrencia_sacado.must_equal               ""
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      "00000000000000000000"
			pagamento.codigo_movimento_retorno.must_equal               "06"
		end
		it "valores para o pagamento 3" do
			pagamento = subject.pagamentos[2]
			pagamento.modalidade.must_equal                             nil
			pagamento.agencia_com_dv.must_equal                         "030690"
			pagamento.agencia_sem_dv.must_equal                         "03069"
			pagamento.numero_conta.must_equal                           "0000000777778"
			pagamento.numero_conta_dv.must_equal                        "8"
			pagamento.numero_conta_sem_dv.must_equal                    "000000077777"
			pagamento.dv_conta_e_agencia.must_equal                     "0"
			pagamento.nosso_numero_sem_dv.must_equal                    "00777778000000027"
			pagamento.carteira.must_equal                               "1"
			pagamento.numero_documento.must_equal                       "000000000000027"
			pagamento.data_vencimento.must_equal                        Date.parse('10/12/2016')
			pagamento.valor_titulo.must_equal                           365.0
			pagamento.banco_recebedor.must_equal                        "237"
			pagamento.agencia_recebedora_com_dv.must_equal              "031178"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "90"
			pagamento.sacado_tipo_documento.must_equal                  "2"
			pagamento.sacado_documento.must_equal                       "333333333333333"
			pagamento.sacado_nome.must_equal                            "NOVA EMPRESA DO CLIENTE3 LTDA - ME"
			pagamento.numero_contrato.must_equal                        "0000000000"
			pagamento.valor_tarifa.must_equal                           4.0
			pagamento.motivo_ocorrencia_original_1.must_equal           "33"
			pagamento.motivo_ocorrencia_original_2.must_equal           ""
			pagamento.motivo_ocorrencia_original_3.must_equal           ""
			pagamento.motivo_ocorrencia_original_4.must_equal           ""
			pagamento.motivo_ocorrencia_original_5.must_equal           ""
			pagamento.valor_juros_multa.must_equal                      0.0
			pagamento.valor_desconto.must_equal                         0.0
			pagamento.valor_abatimento.must_equal                       0.0
			pagamento.valor_iof.must_equal                              0.0
			pagamento.valor_pago.must_equal                             365.0
			pagamento.valor_liquido.must_equal                          365.0
			pagamento.valor_outras_despesas.must_equal                 0.0
			pagamento.valor_outros_creditos.must_equal                 0.0
			pagamento.data_ocorrencia.must_equal                        Date.parse('07/12/2016')
			pagamento.data_credito.must_equal                           Date.parse('08/12/2016')
			pagamento.codigo_ocorrencia_sacado.must_equal               ""
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      "00000000000000000000"
			pagamento.codigo_movimento_retorno.must_equal               "06"
		end
	end
end