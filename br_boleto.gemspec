# -*- encoding: utf-8 -*-
require File.expand_path('../lib/br_boleto/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bruno M. Mergen"]
  gem.email         = ["brunomergen@gmail.com"]
  gem.description   = %q{Emissão de Boletos Bancários em Ruby}
  gem.summary       = %q{Emissão de Boletos Bancários em Ruby}
  gem.homepage      = "https://github.com/duobr/br_boleto"

  gem.files         = `git ls-files`.split($\).reject { |f| ['.pdf','.xls'].include?(File.extname(f)) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "br_boleto"
  gem.require_paths = ["lib"]
  gem.version       = BrBoleto::VERSION

  gem.required_ruby_version = '>= 2.2'

  gem.add_dependency "rake"
  gem.add_dependency "activesupport", '~> 4.2.1'
  gem.add_dependency "activemodel",   '~> 4.2.1'

end