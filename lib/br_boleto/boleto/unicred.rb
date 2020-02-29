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

			def digito_verificador_nosso_numero
				BrBoleto::Calculos::Modulo11FatorDe2a9.new("#{numero_documento}")
			end

			# Nosso Número descrito na documentação (Pag. 36).
			# Carteira com 2 (dois) caracteres / N.Número com 11 (onze) caracteres + digito.
			# Exemplo: 99 / 99999999999-D
			def nosso_numero
				"#{numero_documento}-#{digito_verificador_nosso_numero}"
			end

			def nosso_numero_retorno
				"#{nosso_numero}".gsub(/[^\w\d]/i, '')
			end

			#  === Código de barras do banco
			#
			#     ___________________________________________________________________________________________________
			#    | Posição  | Tamanho | Descrição                                                                   |
			#    |----------|---------|-----------------------------------------------------------------------------|
			#    | 20-23    |  04     | Agência (Sem o digito, completar com zeros a esquerda se necessário)        |
			#    | 24-33    |  10     | Conta do BENEFICIÁRIO (Com o dígito verificador)                            |
			#    | 34-44    |  11     | NNosso Número (Com o dígito verificador)                                    |
			#    ----------------------------------------------------------------------------------------------------
			#
			def codigo_de_barras_do_banco
				conta_corrente = "#{conta.conta_corrente}#{conta.conta_corrente_dv}".adjust_size_to(10, '0', :right)
				"#{conta.agencia}#{conta_corrente}#{nosso_numero_retorno.adjust_size_to(11, '0', :right)}"
			end

		end
	end
end
