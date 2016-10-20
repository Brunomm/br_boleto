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

			def versao_layout_arquivo_cnab_240
				'082'
			end

			def versao_layout_lote_cnab_240
				'041'
			end

		end
	end
end
