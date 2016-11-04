# -*- encoding: utf-8 -*-
module BrBoleto
	module Retorno
		module Cnab400
			class Unicred < BrBoleto::Retorno::Cnab400::Bradesco
				# A Unicred (através do CobExpress) utiliza e o layout de boleto os arquivos de remessa/retorno disponibilizados pelo Banco Bradesco.
			end
		end
	end
end