# -*- encoding: utf-8 -*-
module BrBoleto
	module Remessa
		class Lote < BrBoleto::ActiveModelBase
			# variavel que terá os pagamentos no qual será gerado o lote do arquivo de remessa
			# Pode haver 1 ou vários pagamentos para o mesmo arquivo
			include BrBoleto::HavePagamentos
		end
	end
end