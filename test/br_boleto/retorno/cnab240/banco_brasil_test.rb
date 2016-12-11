require 'test_helper'

require 'pry'
describe BrBoleto::Retorno::Cnab240::BancoBrasil do
	subject { BrBoleto::Retorno::Cnab240::BancoBrasil.new(file) }
	let(:file) { open_fixture('retorno/cnab240/banco_brasil.ret') }
	

	it "Deve ler o código do banco" do
		subject.codigo_banco.must_equal '001'
	end

	it "Deve carregar 5 pagamentos" do
		subject.pagamentos.size.must_equal 35
	end

	describe "deve setar as informações corretas para os pagamentos" do
		it "valores para o pagamento 1" do
			pagamento = subject.pagamentos[0]
			pagamento.modalidade.must_equal                             nil
			pagamento.agencia_com_dv.must_equal                         "012345"
			pagamento.agencia_sem_dv.must_equal                         "01234"
			pagamento.numero_conta.must_equal                           "0000000054321"
			pagamento.numero_conta_sem_dv.must_equal                    "000000005432"
			pagamento.numero_conta_dv.must_equal                        "1"
			pagamento.dv_conta_e_agencia.must_equal                     ""
			pagamento.nosso_numero_sem_dv.must_equal                    "14499570000020673"
			pagamento.carteira.must_equal                               "7"
			pagamento.numero_documento.must_equal                       ""
			pagamento.data_vencimento.must_equal                        nil
			pagamento.valor_titulo.must_equal                           344.00
			pagamento.banco_recebedor.must_equal                        "001"
			pagamento.agencia_recebedora_com_dv.must_equal              "020850"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "09"
			pagamento.sacado_tipo_documento.must_equal                  "0"
			pagamento.sacado_documento.must_equal                       "000000000000000"
			pagamento.sacado_nome.must_equal                            "0000000000000000000000000000000000000"
			pagamento.numero_contrato.must_equal                        "0000000000"
			pagamento.valor_tarifa.must_equal                           1.03
			pagamento.motivo_ocorrencia.must_equal                      "03"
			pagamento.valor_juros_multa.must_equal                      0.09
			pagamento.valor_desconto.must_equal                         0.01
			pagamento.valor_abatimento.must_equal                       0.02
			pagamento.valor_iof.must_equal                              0.03
			pagamento.valor_pago.must_equal                             344.00
			pagamento.valor_liquido.must_equal                          342.97
			pagamento.valor_outras_despesas.must_equal                 0.04
			pagamento.valor_outros_creditos.must_equal                 0.05
			pagamento.data_ocorrencia.must_equal                        Date.parse('29/12/2011')
			pagamento.data_credito.must_equal                           Date.parse('02/01/2012')
			pagamento.codigo_ocorrencia_sacado.must_equal               ""
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      ""
			pagamento.codigo_movimento_retorno.must_equal               "17"
		end
		it "valores para o pagamento 2" do
			pagamento = subject.pagamentos[1]
			pagamento.modalidade.must_equal                             nil
			pagamento.agencia_com_dv.must_equal                         "012345"
			pagamento.agencia_sem_dv.must_equal                         "01234"
			pagamento.numero_conta.must_equal                           "0000000054321"
			pagamento.numero_conta_sem_dv.must_equal                    "000000005432"
			pagamento.numero_conta_dv.must_equal                        "1"
			pagamento.dv_conta_e_agencia.must_equal                     ""
			pagamento.nosso_numero_sem_dv.must_equal                    "14499570000020807"
			pagamento.carteira.must_equal                               "7"
			pagamento.numero_documento.must_equal                       ""
			pagamento.data_vencimento.must_equal                        nil
			pagamento.valor_titulo.must_equal                           321.17
			pagamento.banco_recebedor.must_equal                        "237"
			pagamento.agencia_recebedora_com_dv.must_equal              "003210"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "09"
			pagamento.sacado_tipo_documento.must_equal                  "0"
			pagamento.sacado_documento.must_equal                       "000000000000000"
			pagamento.sacado_nome.must_equal                            "0000000000000000000000000000000000000"
			pagamento.numero_contrato.must_equal                        "0000000000"
			pagamento.valor_tarifa.must_equal                           1.03
			pagamento.motivo_ocorrencia.must_equal                      "03"
			pagamento.valor_juros_multa.must_equal                      0.0
			pagamento.valor_desconto.must_equal                         0.0
			pagamento.valor_abatimento.must_equal                       0.0
			pagamento.valor_iof.must_equal                              0.0
			pagamento.valor_pago.must_equal                             321.17
			pagamento.valor_liquido.must_equal                          320.14
			pagamento.valor_outras_despesas.must_equal                 0.0
			pagamento.valor_outros_creditos.must_equal                 0.0
			pagamento.data_ocorrencia.must_equal                        Date.parse('29/12/2011')
			pagamento.data_credito.must_equal                           Date.parse('02/01/2012')
			pagamento.codigo_ocorrencia_sacado.must_equal               ""
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      ""
			pagamento.codigo_movimento_retorno.must_equal               "17"
		end
		it "valores para o pagamento 3" do
			pagamento = subject.pagamentos[2]
			pagamento.modalidade.must_equal                             nil
			pagamento.agencia_com_dv.must_equal                         "012345"
			pagamento.agencia_sem_dv.must_equal                         "01234"
			pagamento.numero_conta.must_equal                           "0000000054321"
			pagamento.numero_conta_sem_dv.must_equal                    "000000005432"
			pagamento.numero_conta_dv.must_equal                        "1"
			pagamento.dv_conta_e_agencia.must_equal                     ""
			pagamento.nosso_numero_sem_dv.must_equal                    "14499570000020821"
			pagamento.carteira.must_equal                               "7"
			pagamento.numero_documento.must_equal                       ""
			pagamento.data_vencimento.must_equal                        nil
			pagamento.valor_titulo.must_equal                           751.47
			pagamento.banco_recebedor.must_equal                        "237"
			pagamento.agencia_recebedora_com_dv.must_equal              "003210"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "09"
			pagamento.sacado_tipo_documento.must_equal                  "0"
			pagamento.sacado_documento.must_equal                       "000000000000000"
			pagamento.sacado_nome.must_equal                            "0000000000000000000000000000000000000"
			pagamento.numero_contrato.must_equal                        "0000000000"
			pagamento.valor_tarifa.must_equal                           1.03
			pagamento.motivo_ocorrencia.must_equal                      "03"
			pagamento.valor_juros_multa.must_equal                      0.0
			pagamento.valor_desconto.must_equal                         0.0
			pagamento.valor_abatimento.must_equal                       0.0
			pagamento.valor_iof.must_equal                              0.0
			pagamento.valor_pago.must_equal                             751.47
			pagamento.valor_liquido.must_equal                          750.44
			pagamento.valor_outras_despesas.must_equal                 0.0
			pagamento.valor_outros_creditos.must_equal                 0.0
			pagamento.data_ocorrencia.must_equal                        Date.parse('29/12/2011')
			pagamento.data_credito.must_equal                           Date.parse('02/01/2012')
			pagamento.codigo_ocorrencia_sacado.must_equal               ""
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      ""
			pagamento.codigo_movimento_retorno.must_equal               "17"
		end
		it "valores para o pagamento 4" do
			pagamento = subject.pagamentos[3]
			pagamento.modalidade.must_equal                             nil
			pagamento.agencia_com_dv.must_equal                         "012345"
			pagamento.agencia_sem_dv.must_equal                         "01234"
			pagamento.numero_conta.must_equal                           "0000000054321"
			pagamento.numero_conta_sem_dv.must_equal                    "000000005432"
			pagamento.numero_conta_dv.must_equal                        "1"
			pagamento.dv_conta_e_agencia.must_equal                     ""
			pagamento.nosso_numero_sem_dv.must_equal                    "14499570000020823"
			pagamento.carteira.must_equal                               "7"
			pagamento.numero_documento.must_equal                       ""
			pagamento.data_vencimento.must_equal                        nil
			pagamento.valor_titulo.must_equal                           866.18
			pagamento.banco_recebedor.must_equal                        "001"
			pagamento.agencia_recebedora_com_dv.must_equal              "043915"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "09"
			pagamento.sacado_tipo_documento.must_equal                  "0"
			pagamento.sacado_documento.must_equal                       "000000000000000"
			pagamento.sacado_nome.must_equal                            "0000000000000000000000000000000000000"
			pagamento.numero_contrato.must_equal                        "0000000000"
			pagamento.valor_tarifa.must_equal                           1.03
			pagamento.motivo_ocorrencia.must_equal                      "03"
			pagamento.valor_juros_multa.must_equal                      0.0
			pagamento.valor_desconto.must_equal                         0.0
			pagamento.valor_abatimento.must_equal                       0.0
			pagamento.valor_iof.must_equal                              0.0
			pagamento.valor_pago.must_equal                             866.18
			pagamento.valor_liquido.must_equal                          865.15
			pagamento.valor_outras_despesas.must_equal                 0.0
			pagamento.valor_outros_creditos.must_equal                 0.0
			pagamento.data_ocorrencia.must_equal                        Date.parse('29/12/2011')
			pagamento.data_credito.must_equal                           Date.parse('02/01/2012')
			pagamento.codigo_ocorrencia_sacado.must_equal               ""
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      ""
			pagamento.codigo_movimento_retorno.must_equal               "17"
		end
		it "valores para o pagamento 5" do
			pagamento = subject.pagamentos[4]
			pagamento.modalidade.must_equal                             nil
			pagamento.agencia_com_dv.must_equal                         "012345"
			pagamento.agencia_sem_dv.must_equal                         "01234"
			pagamento.numero_conta.must_equal                           "0000000054321"
			pagamento.numero_conta_sem_dv.must_equal                    "000000005432"
			pagamento.numero_conta_dv.must_equal                        "1"
			pagamento.dv_conta_e_agencia.must_equal                     ""
			pagamento.nosso_numero_sem_dv.must_equal                    "14499570000020826"
			pagamento.carteira.must_equal                               "7"
			pagamento.numero_documento.must_equal                       ""
			pagamento.data_vencimento.must_equal                        nil
			pagamento.valor_titulo.must_equal                           830.0
			pagamento.banco_recebedor.must_equal                        "237"
			pagamento.agencia_recebedora_com_dv.must_equal              "021340"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "09"
			pagamento.sacado_tipo_documento.must_equal                  "0"
			pagamento.sacado_documento.must_equal                       "000000000000000"
			pagamento.sacado_nome.must_equal                            "0000000000000000000000000000000000000"
			pagamento.numero_contrato.must_equal                        "0000000000"
			pagamento.valor_tarifa.must_equal                           1.03
			pagamento.motivo_ocorrencia.must_equal                      "03"
			pagamento.valor_juros_multa.must_equal                      0.0
			pagamento.valor_desconto.must_equal                         0.0
			pagamento.valor_abatimento.must_equal                       0.0
			pagamento.valor_iof.must_equal                              0.0
			pagamento.valor_pago.must_equal                             830.0
			pagamento.valor_liquido.must_equal                          828.97
			pagamento.valor_outras_despesas.must_equal                 0.0
			pagamento.valor_outros_creditos.must_equal                 0.0
			pagamento.data_ocorrencia.must_equal                        Date.parse('29/12/2011')
			pagamento.data_credito.must_equal                           Date.parse('02/01/2012')
			pagamento.codigo_ocorrencia_sacado.must_equal               ""
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      ""
			pagamento.codigo_movimento_retorno.must_equal               "17"
		end
		it "valores para o pagamento 35" do
			pagamento = subject.pagamentos[34]
			pagamento.modalidade.must_equal                             nil
			pagamento.agencia_com_dv.must_equal                         "012345"
			pagamento.agencia_sem_dv.must_equal                         "01234"
			pagamento.numero_conta.must_equal                           "0000000054321"
			pagamento.numero_conta_sem_dv.must_equal                    "000000005432"
			pagamento.numero_conta_dv.must_equal                        "1"
			pagamento.dv_conta_e_agencia.must_equal                     ""
			pagamento.nosso_numero_sem_dv.must_equal                    "14499570007451702"
			pagamento.carteira.must_equal                               "7"
			pagamento.numero_documento.must_equal                       ""
			pagamento.data_vencimento.must_equal                        nil
			pagamento.valor_titulo.must_equal                           380.0
			pagamento.banco_recebedor.must_equal                        "001"
			pagamento.agencia_recebedora_com_dv.must_equal              "043699"
			pagamento.identificacao_titulo_empresa.must_equal           ""
			pagamento.codigo_moeda.must_equal                           "09"
			pagamento.sacado_tipo_documento.must_equal                  "0"
			pagamento.sacado_documento.must_equal                       "000000000000000"
			pagamento.sacado_nome.must_equal                            "0000000000000000000000000000000000000"
			pagamento.numero_contrato.must_equal                        "0000000000"
			pagamento.valor_tarifa.must_equal                           1.03
			pagamento.motivo_ocorrencia.must_equal                      "03"
			pagamento.valor_juros_multa.must_equal                      0.0
			pagamento.valor_desconto.must_equal                         0.0
			pagamento.valor_abatimento.must_equal                       0.0
			pagamento.valor_iof.must_equal                              0.0
			pagamento.valor_pago.must_equal                             380.0
			pagamento.valor_liquido.must_equal                          378.97
			pagamento.valor_outras_despesas.must_equal                 0.0
			pagamento.valor_outros_creditos.must_equal                 0.0
			pagamento.data_ocorrencia.must_equal                        Date.parse('29/12/2011')
			pagamento.data_credito.must_equal                           Date.parse('02/01/2012')
			pagamento.codigo_ocorrencia_sacado.must_equal               ""
			pagamento.data_ocorrencia_sacado.must_equal                 nil
			pagamento.valor_ocorrencia_sacado.must_equal                0.0
			pagamento.complemento_ocorrencia_sacado.must_equal          ""
			pagamento.codigo_ocorrencia_banco_correspondente.must_equal "000"
			pagamento.nosso_numero_banco_correspondente.must_equal      ""
			pagamento.codigo_movimento_retorno.must_equal               "17"
		end
	end
end