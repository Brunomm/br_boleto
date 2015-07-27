# encoding: utf-8
require 'br_boleto/version'
require 'active_model'
require 'active_support/core_ext/class'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/object'
require 'active_support/core_ext/string'

# Copyright (C) 2015 Bruno M. Mergen <http://duobr.com.br>
#
# @author Bruno Mucelini Mergen <brunomergen@gmail.com>
#
# == Boleto Bancário
#
# Emissão de Boletos Bancários em Ruby. Simples e principalmente, flexível.
#
# Essa biblioteca é baseada em outras <b>ótimas</b> bibliotecas.
# Recomendo analisar muito bem cada solução!
#
# * Novo Gateway de Pagamentos da Locaweb: http://www.locaweb.com.br/produtos/gateway-pagamento.html
# * Brcobranca: https://github.com/kivanio/brcobranca
# * Boleto Php: http://boletophp.com.br
# * Stella Caelum: http://stella.caelum.com.br
# * BoletoBancario: https://github.com/tomas-stefano/boleto_bancario
#
# === Instalação via Rubygems
#
#	gem install br_boleto
#
# === Instalar via Bundler
#
# Coloque no Gemfile:
#
#	gem 'br_boleto'
#
# Depois de colocar no Gemfile:
#
#   bundle install
#
module BrBoleto
	# Modulo responsável por guardar todas as regras dos campos de
	# todos os Boletos Bancários. <b>Contribuicões com novas documentações dos
	# bancos e homologação dos boletos são extremamente bem vindas!</b>
	#
	# Esse módulo também é responsável por guardar todas as regras de validação dos boletos e
	# contém a forma de chamar os objetos necessários para renderização
	# dos formatos (pdf, html, etc) e internacionalização dos boletos (caso
	# você precise mudar os nomes dos campos nos boletos)
	#
	module Core
		extend ActiveSupport::Autoload

		autoload :Boleto
		autoload :BancoBrasil
		autoload :Banrisul
		autoload :Bradesco
		autoload :Caixa
		autoload :Hsbc
		autoload :Itau
		autoload :Real
		autoload :Santander
		autoload :Sicredi
		autoload :Sicoob
	end

	# Módulo que possui classes que realizam os cálculos dos campos que serão mostrados nos boletos.
	#
	module Calculos
		extend ActiveSupport::Autoload

		autoload :FatorVencimento
		autoload :FatoresDeMultiplicacao
		autoload :LinhaDigitavel
		autoload :Modulo10
		autoload :Modulo11
		autoload :Modulo11FatorDe2a9
		autoload :Modulo11Fator3197
		autoload :Modulo11FatorDe2a9RestoZero
		autoload :Modulo11FatorDe2a7
		autoload :Modulo11FatorDe9a2
		autoload :Modulo11FatorDe9a2RestoX
		autoload :ModuloNumeroDeControle
		autoload :Digitos
	end

	include Core
end
