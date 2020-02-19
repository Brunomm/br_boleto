# encoding: utf-8
module BrBoleto
	module Conta

		# A Unicred (através do CobExpress) utiliza e o layout de boleto os arquivos de remessa/retorno disponibilizados pelo Banco Bradesco.
		class Unicred < BrBoleto::Conta::Bradesco

			def default_values
				super.merge({
					carteira:     '09',
				})
			end

			def codigo_banco
				'136'
			end

			def versao_layout_arquivo_cnab_240
				'082'
			end

			def versao_layout_lote_cnab_240
				'041'
			end
			

			##################################### DEFAULT CODES ###############################################

				# Código adotado pelo UNICRED para identificar o tipo de prazo a ser considerado para o protesto.
				# Segundo documentação, é permitido somente os códigos '1' = Protestar dias corridos e '3' = Não protestar
				def equivalent_codigo_protesto_240
					{
						'1' => '1', # Protestar Dias Corridos
						'2' => '1', # Protestar Dias Úteis
						'3' => '3', # Não Protesta
						'4' => '1', # Protestar Fim Falimentar - Dias Úteis
						'5' => '1', # Protestar Fim Falimentar - Dias Corridos
						'8' => '3', # Negativação sem Protesto
						'9' => '3', # Cancelamento Protesto Automático 
					}
				end

		end
	end
end
