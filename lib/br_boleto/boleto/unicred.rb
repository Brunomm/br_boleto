# encoding: utf-8
module BrBoleto
	module Boleto
		# Implementação de emissão de boleto bancário pelo Banco Unicred.
		#
		# === Documentação Implementada
		#
		# A documentação na qual essa implementação foi baseada está localizada na pasta
		# 'documentacoes_dos_boletos/unicred' dentro dessa biblioteca.
		#
		# A Unicred (através do CobExpress) utiliza e o layout de boleto os arquivos de remessa/retorno disponibilizados pelo Banco Bradesco.
		class Unicred < Bradesco
			def conta_class
				BrBoleto::Conta::Unicred
			end

			def valid_avalista_required;     true   end

		end
	end
end
