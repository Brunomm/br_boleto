# encoding: utf-8
require 'test_helper'

describe BrBoleto::Retorno::Pagamento do
	
	subject { FactoryGirl.build(:retorno_pagamento) }
	
	describe "atributos que devem ser convertidos para data quando o valor for setado" do
		describe "#data_vencimento" do
			it "deve converter para uma data se a string estiver no formato DDMMYYYY" do
				subject.data_vencimento = '12041991'
				subject.data_vencimento.must_equal Date.parse('12/04/1991')
			end
			it "Se for uma data inválida deve setar o valor nil" do
				subject.data_vencimento = '99999999'
				subject.data_vencimento.must_be_nil
			end
			it "Deve aceitar o valor se for do tipo Date" do
				subject.data_vencimento = Date.parse('05/07/2014')
				subject.data_vencimento.must_equal Date.parse('05/07/2014')
			end
		end
		describe "#data_ocorrencia" do
			it "deve converter para uma data se a string estiver no formato DDMMYYYY" do
				subject.data_ocorrencia = '12041991'
				subject.data_ocorrencia.must_equal Date.parse('12/04/1991')
			end
			it "Se for uma data inválida deve setar o valor nil" do
				subject.data_ocorrencia = '99999999'
				subject.data_ocorrencia.must_be_nil
			end
			it "Deve aceitar o valor se for do tipo Date" do
				subject.data_ocorrencia = Date.parse('05/07/2014')
				subject.data_ocorrencia.must_equal Date.parse('05/07/2014')
			end
		end
		describe "#data_credito" do
			it "deve converter para uma data se a string estiver no formato DDMMYYYY" do
				subject.data_credito = '12041991'
				subject.data_credito.must_equal Date.parse('12/04/1991')
			end
			it "Se for uma data inválida deve setar o valor nil" do
				subject.data_credito = '99999999'
				subject.data_credito.must_be_nil
			end
			it "Deve aceitar o valor se for do tipo Date" do
				subject.data_credito = Date.parse('05/07/2014')
				subject.data_credito.must_equal Date.parse('05/07/2014')
			end
		end
		describe "#data_ocorrencia_sacado" do
			it "deve converter para uma data se a string estiver no formato DDMMYYYY" do
				subject.data_ocorrencia_sacado = '12041991'
				subject.data_ocorrencia_sacado.must_equal Date.parse('12/04/1991')
			end
			it "Se for uma data inválida deve setar o valor nil" do
				subject.data_ocorrencia_sacado = '99999999'
				subject.data_ocorrencia_sacado.must_be_nil
			end
			it "Deve aceitar o valor se for do tipo Date" do
				subject.data_ocorrencia_sacado = Date.parse('05/07/2014')
				subject.data_ocorrencia_sacado.must_equal Date.parse('05/07/2014')
			end
		end
	end

	describe "atributos que devem ser convertidos para Float quando o valor for setado" do
		describe "#valor_titulo" do
			it "deve converter o valor string para float mantendo os 2 ultimos characteres com decimais" do
				subject.valor_titulo = '00087944'
				subject.valor_titulo.must_equal 879.44
			end
			it "se o valor setado for um numero deve mante-lo" do
				subject.valor_titulo = 7_745.67
				subject.valor_titulo.must_equal 7_745.67
			end
		end
		describe "#valor_tarifa" do
			it "deve converter o valor string para float mantendo os 2 ultimos characteres com decimais" do
				subject.valor_tarifa = '00087944'
				subject.valor_tarifa.must_equal 879.44
			end
			it "se o valor setado for um numero deve mante-lo" do
				subject.valor_titulo = 7_745.67
				subject.valor_titulo.must_equal 7_745.67
			end
		end
		describe "#valor_juros_multa" do
			it "deve converter o valor string para float mantendo os 2 ultimos characteres com decimais" do
				subject.valor_juros_multa = '00087944'
				subject.valor_juros_multa.must_equal 879.44
			end
			it "se o valor setado for um numero deve mante-lo" do
				subject.valor_titulo = 7_745.67
				subject.valor_titulo.must_equal 7_745.67
			end
		end
		describe "#valor_desconto" do
			it "deve converter o valor string para float mantendo os 2 ultimos characteres com decimais" do
				subject.valor_desconto = '00087944'
				subject.valor_desconto.must_equal 879.44
			end
			it "se o valor setado for um numero deve mante-lo" do
				subject.valor_titulo = 7_745.67
				subject.valor_titulo.must_equal 7_745.67
			end
		end
		describe "#valor_abatimento" do
			it "deve converter o valor string para float mantendo os 2 ultimos characteres com decimais" do
				subject.valor_abatimento = '00087944'
				subject.valor_abatimento.must_equal 879.44
			end
			it "se o valor setado for um numero deve mante-lo" do
				subject.valor_titulo = 7_745.67
				subject.valor_titulo.must_equal 7_745.67
			end
		end
		describe "#valor_iof" do
			it "deve converter o valor string para float mantendo os 2 ultimos characteres com decimais" do
				subject.valor_iof = '00087944'
				subject.valor_iof.must_equal 879.44
			end
			it "se o valor setado for um numero deve mante-lo" do
				subject.valor_titulo = 7_745.67
				subject.valor_titulo.must_equal 7_745.67
			end
		end
		describe "#valor_pago" do
			it "deve converter o valor string para float mantendo os 2 ultimos characteres com decimais" do
				subject.valor_pago = '00087944'
				subject.valor_pago.must_equal 879.44
			end
			it "se o valor setado for um numero deve mante-lo" do
				subject.valor_titulo = 7_745.67
				subject.valor_titulo.must_equal 7_745.67
			end
		end
		describe "#valor_liquido" do
			it "deve converter o valor string para float mantendo os 2 ultimos characteres com decimais" do
				subject.valor_liquido = '00087944'
				subject.valor_liquido.must_equal 879.44
			end
			it "se o valor setado for um numero deve mante-lo" do
				subject.valor_titulo = 7_745.67
				subject.valor_titulo.must_equal 7_745.67
			end
		end
		describe "#valor_outras_despesas" do
			it "deve converter o valor string para float mantendo os 2 ultimos characteres com decimais" do
				subject.valor_outras_despesas = '00087944'
				subject.valor_outras_despesas.must_equal 879.44
			end
			it "se o valor setado for um numero deve mante-lo" do
				subject.valor_titulo = 7_745.67
				subject.valor_titulo.must_equal 7_745.67
			end
		end
		describe "#valor_outros_creditos" do
			it "deve converter o valor string para float mantendo os 2 ultimos characteres com decimais" do
				subject.valor_outros_creditos = '00087944'
				subject.valor_outros_creditos.must_equal 879.44
			end
			it "se o valor setado for um numero deve mante-lo" do
				subject.valor_titulo = 7_745.67
				subject.valor_titulo.must_equal 7_745.67
			end
		end
		describe "#valor_ocorrencia_sacado" do
			it "deve converter o valor string para float mantendo os 2 ultimos characteres com decimais" do
				subject.valor_ocorrencia_sacado = '00087944'
				subject.valor_ocorrencia_sacado.must_equal 879.44
			end
			it "se o valor setado for um numero deve mante-lo" do
				subject.valor_titulo = 7_745.67
				subject.valor_titulo.must_equal 7_745.67
			end
		end
		describe "#numero_conta_com_dv" do
			it "deve converter o valor numero_conta concatenado com o numero_conta_dv" do
				subject.numero_conta = '12345'
				subject.numero_conta_dv = '0'
				subject.numero_conta_com_dv.must_equal '123450'
			end
		end
	end
end