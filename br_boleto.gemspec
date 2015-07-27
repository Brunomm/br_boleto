# -*- encoding: utf-8 -*-
require File.expand_path('../lib/br_boleto/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bruno M. Mergen"]
  gem.email         = ["brunomergen@gmail.com"]
  gem.description   = %q{Emissão de Boletos Bancários em Ruby}
  gem.summary       = %q{Emissão de Boletos Bancários em Ruby}
  gem.homepage      = "https://github.com/Brunomm/br_boleto"
  gem.license       = "BSD"

  gem.files         = `git ls-files`.split($\).reject { |f| ['.pdf','.xls'].include?(File.extname(f)) }
  gem.test_files    = `git ls-files -- test/**/*`.split("\n")
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.name          = "br_boleto"
  gem.require_paths = ["lib"]
  gem.version       = BrBoleto::Version::CURRENT

  gem.required_ruby_version = '>= 2.1'


  gem.add_dependency "rake", '>= 0.8.7'
  gem.add_dependency "activesupport", '~> 4.2'
  gem.add_dependency "activemodel",   '~> 4.2'

end