# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		module Cnab240
			class Base < BrBoleto::Retorno::Base

			# Esta classe foi desenvolvida baseando-se no manual disponibilizado pela FEBRABAN
			# Manual: Layout Padrão Febraban 240 posições v09.0
				
			private

				# É feito um loop em todas as linhas do arquivo onde ignora se a linha não
				# for do segmento T ou do segmento U.
				# A cada loop é lido 2 linhas por vez, onde sempre terá o segmento T e U juntos.
				# Cada loop representa um pagamento.
				#
				def read_file! #:doc:
					File.readlines(file).reject{|l| adjust_encode(l) =~ /^((?!^.{7}3.{5}[T|U].*$).)*$/}.each_slice(2) do |line|
						instnce_payment(line)
					end
					pagamentos
				end

				# Método utilizado para instanciar um novo Pagamento a partir das linhas dos
				# Segmentos T e U do arquivo de retorno
				#
				def instnce_payment(lines) #:doc:
					payment = BrBoleto::Retorno::Pagamento.new
					lines.each do |line|
						self.codigo_banco ||= line[0..2]
						if line[13] == 'T'
							set_values_for_segment_t(payment, line)
						else # U
							set_values_for_segment_u(payment, line)
						end
					end
					self.pagamentos << payment
				end

				def set_values_for_segment_u(payment, line) #:doc: 
					segmento_u_fields.each do |column, position |
						payment.send("#{column}=", "_#{line}"[position].try(:strip))
					end
				end

				def set_values_for_segment_t(payment, line) #:doc:
					segmento_t_fields.each do |column, position |
						payment.send("#{column}=", "_#{line}"[position].try(:strip))
					end
				end
				
				def segmento_t_fields #:doc:
					{ #    ATRIBUTO               POSIÇÃO DA LINHA
						codigo_movimento_retorno:      16..17,
						agencia_com_dv:                18..23,
						agencia_sem_dv:                18..22,
						numero_conta_com_dv:           24..36,
						numero_conta_sem_dv:           24..35,
						dv_conta_e_agencia:            37..37,
						nosso_numero:                  38..57,
						carteira:                      58..58,
						numero_documento:              59..73,
						data_vencimento:               74..81,
						valor_titulo:                  82..96,
						banco_recebedor:               97..99,
						agencia_recebedora_com_dv:    100..105,
						identificacao_titulo_empresa: 106..130,
						codigo_moeda:                 131..132,
						sacado_tipo_documento:        133..133,
						sacado_documento:             134..148,
						sacado_nome:                  149..188,
						numero_contrato:              189..198,
						valor_tarifa:                 199..213,
						motivo_ocorrencia:            214..223
					}
				end

				def segmento_u_fields #:doc:
					{ #    ATRIBUTO                        POSIÇÃO DA LINHA     
						valor_juros_multa:                       18..32,
						valor_desconto:                          33..47,
						valor_abatimento:                        48..62,
						valor_iof:                               63..77,
						valor_pago:                              78..92,
						valor_liquido:                           93..107,
						valor_outras_despesas:                   108..122,
						valor_outros_creditos:                   123..137,
						data_ocorrencia:                         138..145,
						data_credito:                            146..153,
						codigo_ocorrencia_sacado:                154..157,
						data_ocorrencia_sacado:                  158..165,
						valor_ocorrencia_sacado:                 166..180,
						complemento_ocorrencia_sacado:           181..210,
						codigo_ocorrencia_banco_correspondente:  211..213,
						nosso_numero_banco_correspondente:       214..233,
					}				
				end

			end
		end
	end
end