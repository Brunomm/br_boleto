# encoding: utf-8
require 'br_boleto/version'
require 'active_model'
require 'active_support/core_ext/class'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/object'
require 'active_support/core_ext/string'

require 'br_boleto/string_methods'

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
	
	def self.root
		File.expand_path '../..', __FILE__
	end

	extend ActiveSupport::Autoload
	autoload :ActiveModelBase
	
	module Boleto
		extend ActiveSupport::Autoload

		autoload :Base
		autoload :Sicoob
		autoload :Caixa
	end


	module Remessa
		extend ActiveSupport::Autoload
		autoload :Base
		autoload :Lote
		autoload :Pagamento

		module Cnab240
			extend ActiveSupport::Autoload
			autoload :Base
			autoload :Sicoob
			autoload :Caixa
		end
	end
	
	module Retorno
		extend ActiveSupport::Autoload
		autoload :Base
		autoload :Pagamento
		module Cnab240
			extend ActiveSupport::Autoload
			autoload :Base
		end
	end

	module Helper
		extend ActiveSupport::Autoload

		autoload :CpfCnpj
		autoload :Number
		autoload :FormatValue
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

	include Helper
	include Boleto
	include Remessa
end
