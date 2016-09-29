require 'test_helper'

require 'pry'
describe BrBoleto::Retorno::Cnab240::Bradesco do
	subject { BrBoleto::Retorno::Cnab240::Bradesco.new(file) }
	let(:file) { open_fixture('retorno/cnab400/bradesco.ret') }
	

end