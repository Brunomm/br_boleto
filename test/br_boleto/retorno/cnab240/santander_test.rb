require 'test_helper'

require 'pry'
describe BrBoleto::Retorno::Cnab240::Santander do
	subject { BrBoleto::Retorno::Cnab240::Santander.new(file) }
	let(:file) { open_fixture('retorno/cnab240/santander.ret') }

	it "Deve ler o código do banco" do
		subject.codigo_banco.must_equal '033'
	end

	it "Deve carregar 5 pagamentos" do
		subject.pagamentos.size.must_equal 6
	end

	describe "deve setar as informações corretas para os pagamentos" do
		it "valores para o pagamento 1" do
			pagamento = subject.pagamentos[0]
			pagamento.modalidade.must_equal                             nil
			pagamento.agencia_com_dv.must_equal                         "99999"
			pagamento.agencia_sem_dv.must_equal                         "9999"
			pagamento.numero_conta.must_equal                           "1234567891"
			pagamento.numero_conta_sem_dv.must_equal                    "123456789"
			pagamento.numero_conta_dv.must_equal                        "1"
			pagamento.dv_conta_e_agencia.must_equal                     ""
			pagamento.nosso_numero.must_equal                           "0000000000001"
			pagamento.nosso_numero_sem_dv.must_equal                    "000000000000"
			pagamento.nosso_numero_dv.must_equal                        "1"
			pagamento.carteira.must_equal                               "2"
			pagamento.numero_documento.must_equal                       ""
			pagamento.data_vencimento.must_equal                        Date.parse('05/05/2016')
			pagamento.valor_titulo.must_equal                           10.25
			pagamento.banco_recebedor.must_equal                        "033"
			pagamento.agencia_recebedora_com_dv.must_equal              "12340"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "00"
			pagamento.sacado_tipo_documento.must_equal                  "1"
			pagamento.sacado_documento.must_equal                       "000033806987840"
			pagamento.sacado_nome.must_equal                            "XUNDA"
			pagamento.numero_contrato.must_equal                        "6789100000"
			pagamento.valor_tarifa.must_equal                           2.61
			pagamento.motivo_ocorrencia_original_1.must_equal           "00"
			pagamento.motivo_ocorrencia_original_2.must_equal           "00"
			pagamento.motivo_ocorrencia_original_3.must_equal           "00"
			pagamento.motivo_ocorrencia_original_4.must_equal           "00"
			pagamento.motivo_ocorrencia_original_5.must_equal           "00"
			pagamento.valor_juros_multa.must_equal                      0.0
			pagamento.valor_desconto.must_equal                         0.0
			pagamento.valor_abatimento.must_equal                       0.0
			pagamento.valor_iof.must_equal                              0.0
			pagamento.valor_pago.must_equal                             0.0
			pagamento.valor_liquido.must_equal                          0.0
			pagamento.valor_outras_despesas.must_equal                 0.0
			pagamento.valor_outros_creditos.must_equal                 0.0
			pagamento.data_ocorrencia.must_equal                        Date.parse('28/04/2016')
			pagamento.data_credito.must_equal                           Date.parse('28/04/2016')
			pagamento.codigo_ocorrencia_sacado.must_equal               "0000"
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      ""
			pagamento.codigo_movimento_retorno.must_equal               "02"
		end
		it "valores para o pagamento 2" do
			pagamento = subject.pagamentos[1]
			pagamento.modalidade.must_equal                             nil
			pagamento.agencia_com_dv.must_equal                         "99999"
			pagamento.agencia_sem_dv.must_equal                         "9999"
			pagamento.numero_conta.must_equal                           "1234567891"
			pagamento.numero_conta_sem_dv.must_equal                    "123456789"
			pagamento.numero_conta_dv.must_equal                        "1"
			pagamento.dv_conta_e_agencia.must_equal                     ""
			pagamento.nosso_numero.must_equal                           "0000000000002"
			pagamento.nosso_numero_sem_dv.must_equal                    "000000000000"
			pagamento.nosso_numero_dv.must_equal                        "2"
			pagamento.carteira.must_equal                               "2"
			pagamento.numero_documento.must_equal                       ""
			pagamento.data_vencimento.must_equal                        Date.parse('05/05/2016')
			pagamento.valor_titulo.must_equal                           1058.77
			pagamento.banco_recebedor.must_equal                        "033"
			pagamento.agencia_recebedora_com_dv.must_equal              "12340"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "00"
			pagamento.sacado_tipo_documento.must_equal                  "2"
			pagamento.sacado_documento.must_equal                       "013021784000186"
			pagamento.sacado_nome.must_equal                            "XUNDA"
			pagamento.numero_contrato.must_equal                        "6789100000"
			pagamento.valor_tarifa.must_equal                           2.61
			pagamento.motivo_ocorrencia_original_1.must_equal           "00"
			pagamento.motivo_ocorrencia_original_2.must_equal           "00"
			pagamento.motivo_ocorrencia_original_3.must_equal           "00"
			pagamento.motivo_ocorrencia_original_4.must_equal           "00"
			pagamento.motivo_ocorrencia_original_5.must_equal           "00"
			pagamento.valor_juros_multa.must_equal                      0.0
			pagamento.valor_desconto.must_equal                         0.0
			pagamento.valor_abatimento.must_equal                       0.0
			pagamento.valor_iof.must_equal                              0.0
			pagamento.valor_pago.must_equal                             0.0
			pagamento.valor_liquido.must_equal                          0.0
			pagamento.valor_outras_despesas.must_equal                 0.0
			pagamento.valor_outros_creditos.must_equal                 0.0
			pagamento.data_ocorrencia.must_equal                        Date.parse('28/04/2016')
			pagamento.data_credito.must_equal                           Date.parse('28/04/2016')
			pagamento.codigo_ocorrencia_sacado.must_equal               "0000"
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      ""
			pagamento.codigo_movimento_retorno.must_equal               "02"
		end
		it "valores para o pagamento 3" do
			pagamento = subject.pagamentos[2]
			pagamento.modalidade.must_equal                             nil
			pagamento.agencia_com_dv.must_equal                         "99999"
			pagamento.agencia_sem_dv.must_equal                         "9999"
			pagamento.numero_conta.must_equal                           "1234567891"
			pagamento.numero_conta_sem_dv.must_equal                    "123456789"
			pagamento.numero_conta_dv.must_equal                        "1"
			pagamento.dv_conta_e_agencia.must_equal                     ""
			pagamento.nosso_numero.must_equal                           "0000000000003"
			pagamento.nosso_numero_sem_dv.must_equal                    "000000000000"
			pagamento.nosso_numero_dv.must_equal                        "3"
			pagamento.carteira.must_equal                               "2"
			pagamento.numero_documento.must_equal                       ""
			pagamento.data_vencimento.must_equal                        Date.parse('28/04/2016')
			pagamento.valor_titulo.must_equal                           1.26
			pagamento.banco_recebedor.must_equal                        "033"
			pagamento.agencia_recebedora_com_dv.must_equal              "12340"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "00"
			pagamento.sacado_tipo_documento.must_equal                  "2"
			pagamento.sacado_documento.must_equal                       "013021784000186"
			pagamento.sacado_nome.must_equal                            "XUNDA"
			pagamento.numero_contrato.must_equal                        "6789100000"
			pagamento.valor_tarifa.must_equal                           2.61
			pagamento.motivo_ocorrencia_original_1.must_equal           "00"
			pagamento.motivo_ocorrencia_original_2.must_equal           "00"
			pagamento.motivo_ocorrencia_original_3.must_equal           "00"
			pagamento.motivo_ocorrencia_original_4.must_equal           "00"
			pagamento.motivo_ocorrencia_original_5.must_equal           "00"
			pagamento.valor_juros_multa.must_equal                      0.0
			pagamento.valor_desconto.must_equal                         0.0
			pagamento.valor_abatimento.must_equal                       0.0
			pagamento.valor_iof.must_equal                              0.0
			pagamento.valor_pago.must_equal                             0.0
			pagamento.valor_liquido.must_equal                          0.0
			pagamento.valor_outras_despesas.must_equal                 0.0
			pagamento.valor_outros_creditos.must_equal                 0.0
			pagamento.data_ocorrencia.must_equal                        Date.parse('28/04/2016')
			pagamento.data_credito.must_equal                           Date.parse('28/04/2016')
			pagamento.codigo_ocorrencia_sacado.must_equal               "0000"
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      ""
			pagamento.codigo_movimento_retorno.must_equal               "02"
		end
		it "valores para o pagamento 4" do
			pagamento = subject.pagamentos[3]
			pagamento.modalidade.must_equal                             nil
			pagamento.agencia_com_dv.must_equal                         "99999"
			pagamento.agencia_sem_dv.must_equal                         "9999"
			pagamento.numero_conta.must_equal                           "1234567891"
			pagamento.numero_conta_sem_dv.must_equal                    "123456789"
			pagamento.numero_conta_dv.must_equal                        "1"
			pagamento.dv_conta_e_agencia.must_equal                     ""
			pagamento.nosso_numero.must_equal                           "0000000000004"
			pagamento.nosso_numero_sem_dv.must_equal                    "000000000000"
			pagamento.nosso_numero_dv.must_equal                        "4"
			pagamento.carteira.must_equal                               "2"
			pagamento.numero_documento.must_equal                       ""
			pagamento.data_vencimento.must_equal                        Date.parse('28/04/2016')
			pagamento.valor_titulo.must_equal                           1.27
			pagamento.banco_recebedor.must_equal                        "033"
			pagamento.agencia_recebedora_com_dv.must_equal              "12340"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "00"
			pagamento.sacado_tipo_documento.must_equal                  "1"
			pagamento.sacado_documento.must_equal                       "000033806987840"
			pagamento.sacado_nome.must_equal                            "XUNDA"
			pagamento.numero_contrato.must_equal                        "6789100000"
			pagamento.valor_tarifa.must_equal                           2.61
			pagamento.motivo_ocorrencia_original_1.must_equal           "00"
			pagamento.motivo_ocorrencia_original_2.must_equal           "00"
			pagamento.motivo_ocorrencia_original_3.must_equal           "00"
			pagamento.motivo_ocorrencia_original_4.must_equal           "00"
			pagamento.motivo_ocorrencia_original_5.must_equal           "00"
			pagamento.valor_juros_multa.must_equal                      0.0
			pagamento.valor_desconto.must_equal                         0.0
			pagamento.valor_abatimento.must_equal                       0.0
			pagamento.valor_iof.must_equal                              0.0
			pagamento.valor_pago.must_equal                             0.0
			pagamento.valor_liquido.must_equal                          0.0
			pagamento.valor_outras_despesas.must_equal                 0.0
			pagamento.valor_outros_creditos.must_equal                 0.0
			pagamento.data_ocorrencia.must_equal                        Date.parse('28/04/2016')
			pagamento.data_credito.must_equal                           Date.parse('28/04/2016')
			pagamento.codigo_ocorrencia_sacado.must_equal               "0000"
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      ""
			pagamento.codigo_movimento_retorno.must_equal               "02"
		end
		it "valores para o pagamento 5" do
			pagamento = subject.pagamentos[4]
			pagamento.agencia_com_dv.must_equal                         "99999"
			pagamento.agencia_sem_dv.must_equal                         "9999"
			pagamento.numero_conta.must_equal                           "1234567891"
			pagamento.numero_conta_sem_dv.must_equal                    "123456789"
			pagamento.numero_conta_dv.must_equal                        "1"
			pagamento.dv_conta_e_agencia.must_equal                     ""
			pagamento.nosso_numero.must_equal                           "0000000000004"
			pagamento.nosso_numero_sem_dv.must_equal                    "000000000000"
			pagamento.nosso_numero_dv.must_equal                        "4"
			pagamento.carteira.must_equal                               "2"
			pagamento.numero_documento.must_equal                       ""
			pagamento.data_vencimento.must_equal                        Date.parse('28/04/2016')
			pagamento.valor_titulo.must_equal                           1.27
			pagamento.banco_recebedor.must_equal                        "001"
			pagamento.agencia_recebedora_com_dv.must_equal              "12340"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "00"
			pagamento.sacado_tipo_documento.must_equal                  "1"
			pagamento.sacado_documento.must_equal                       "000033806987840"
			pagamento.sacado_nome.must_equal                            "XUNDA"
			pagamento.numero_contrato.must_equal                        "6789100000"
			pagamento.valor_tarifa.must_equal                           0.0
			pagamento.motivo_ocorrencia_original_1.must_equal           "04"
			pagamento.motivo_ocorrencia_original_2.must_equal           "00"
			pagamento.motivo_ocorrencia_original_3.must_equal           "00"
			pagamento.motivo_ocorrencia_original_4.must_equal           "00"
			pagamento.motivo_ocorrencia_original_5.must_equal           "00"
			pagamento.valor_juros_multa.must_equal                      0.0
			pagamento.valor_desconto.must_equal                         0.0
			pagamento.valor_abatimento.must_equal                       0.0
			pagamento.valor_iof.must_equal                              0.0
			pagamento.valor_pago.must_equal                             1.27
			pagamento.valor_liquido.must_equal                          1.27
			pagamento.valor_outras_despesas.must_equal                 0.0
			pagamento.valor_outros_creditos.must_equal                 0.0
			pagamento.data_ocorrencia.must_equal                        Date.parse('28/04/2016')
			pagamento.data_credito.must_equal                           Date.parse('29/04/2016')
			pagamento.codigo_ocorrencia_sacado.must_equal               "0000"
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      ""
			pagamento.codigo_movimento_retorno.must_equal               "06"
		end
		it "valores para o pagamento 6" do
			pagamento = subject.pagamentos[5]
			pagamento.agencia_com_dv.must_equal                         "99999"
			pagamento.agencia_sem_dv.must_equal                         "9999"
			pagamento.numero_conta.must_equal                           "1234567891"
			pagamento.numero_conta_sem_dv.must_equal                    "123456789"
			pagamento.numero_conta_dv.must_equal                        "1"
			pagamento.dv_conta_e_agencia.must_equal                     ""
			pagamento.nosso_numero.must_equal                           "0000000289647"
			pagamento.nosso_numero_sem_dv.must_equal                    "000000028964"
			pagamento.nosso_numero_dv.must_equal                        "7"
			pagamento.carteira.must_equal                               "1"
			pagamento.numero_documento.must_equal                       ""
			pagamento.data_vencimento.must_equal                        Date.parse('28/04/2016')
			pagamento.valor_titulo.must_equal                           1.26
			pagamento.banco_recebedor.must_equal                        "001"
			pagamento.agencia_recebedora_com_dv.must_equal              "12340"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "00"
			pagamento.sacado_tipo_documento.must_equal                  "2"
			pagamento.sacado_documento.must_equal                       "000000000000000"
			pagamento.sacado_nome.must_equal                            ""
			pagamento.numero_contrato.must_equal                        "6789100000"
			pagamento.valor_tarifa.must_equal                           6.0
			pagamento.motivo_ocorrencia_original_1.must_equal           "04"
			pagamento.motivo_ocorrencia_original_2.must_equal           "00"
			pagamento.motivo_ocorrencia_original_3.must_equal           "00"
			pagamento.motivo_ocorrencia_original_4.must_equal           "00"
			pagamento.motivo_ocorrencia_original_5.must_equal           "00"
			pagamento.valor_juros_multa.must_equal                      0.0
			pagamento.valor_desconto.must_equal                         0.0
			pagamento.valor_abatimento.must_equal                       0.0
			pagamento.valor_iof.must_equal                              0.0
			pagamento.valor_pago.must_equal                             1.26
			pagamento.valor_liquido.must_equal                          1.26
			pagamento.valor_outras_despesas.must_equal                 0.0
			pagamento.valor_outros_creditos.must_equal                 0.0
			pagamento.data_ocorrencia.must_equal                        Date.parse('28/04/2016')
			pagamento.data_credito.must_equal                           Date.parse('29/04/2016')
			pagamento.codigo_ocorrencia_sacado.must_equal               "0000"
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      ""
			pagamento.codigo_movimento_retorno.must_equal               "17"
		end
	end


end