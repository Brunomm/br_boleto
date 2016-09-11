# -*- encoding: utf-8 -*-
require 'br_boleto/remessa/cnab400/helper/header'
require 'br_boleto/remessa/cnab400/helper/detalhe'
require 'br_boleto/remessa/cnab400/helper/trailer'

module BrBoleto
	module Remessa
		module Cnab400
			class Base < BrBoleto::Remessa::Base
				# Utilizado para montar o header
				include BrBoleto::Remessa::Cnab400::Helper::Header				
				# Utilizado para montar oS DETALHES
				include BrBoleto::Remessa::Cnab400::Helper::Detalhe
				# Utilizado para montar o trailer do arquivo
				include BrBoleto::Remessa::Cnab400::Helper::Trailer

				include BrBoleto::HavePagamentos

				# Informacoes da conta do cedente
				# Este metodo deve ser sobrescrevido na classe do banco
				# Tamanho: 20
				def informacoes_da_conta(local)
					raise NotImplementedError.new('Sobreescreva este método na classe referente ao banco que você esta criando')
				end

				# Informações do banco
				# Padrão:
				#   077 a 079 = Código do banco com 3 posições
				#   080 a 094 = Nome do banco com 15 posições
				# Tamanho: 018
				def informacoes_do_banco
					"#{conta.codigo_banco}#{conta.nome_banco}".adjust_size_to(18)
				end

				# Complemento do registro
				# Vai na posição 101 até 394
				# Tamanho: 294
				def complemento_registro
					raise NotImplementedError.new('Sobreescreva este método na classe referente ao banco que você esta criando')
				end
				
				# Nosso numero do pagamento e outras informações
				# Vai na posição 063 até 076
				# Tamanho: 14
				def dados_do_pagamento(pagamento)
					raise NotImplementedError.new("Sobreescreva o metodo #dados_do_pagamento para a class #{self}")
				end
				
				# Informações referente a cobrança do pagamento
				def informacoes_do_pagamento(pagamento, sequencial)
					raise NotImplementedError.new("Sobreescreva o metodo #informacoes_do_pagamento para a class #{self}")
				end

				# Informações referente aos juros e multas do pagamento
				# Posição 161 a 218
				# Tamanho: 58
				def detalhe_multas_e_juros_do_pagamento(pagamento, sequencial)
					raise NotImplementedError.new("Sobreescreva o metodo #detalhe_multas_e_juros_do_pagamento para a class #{self}")
				end
				
				# Informações referente aos dados do sacado/pagador
				# Posição 219 a 394
				# Tamanho: 176
				def informacoes_do_sacado(pagamento, sequencial)
					raise NotImplementedError.new("Sobreescreva o metodo #informacoes_do_sacado para a class #{self}")
				end
				
				# Gera os dados para o arquivo remessa
				#
				def dados_do_arquivo
					return if self.invalid?

					# contador dos registros do lote
					contador = 1

					# Metodo 'monta_header' implementado no module -> BrBoleto::Remessa::Cnab400::Helper::Header
					arquivo = [monta_header] 
					contador += 1

					pagamentos.each do |pagamento|
						arquivo << monta_detalhe(pagamento, contador)
						contador += 1
					end

					# Metodo 'monta_trailer' implementado no module -> BrBoleto::Remessa::Cnab400::Helper::Trailer
					arquivo << monta_trailer(contador)

					retorno = arquivo.join("\n")
					ActiveSupport::Inflector.transliterate(retorno).upcase
				end
				
			end
		end
	end
end