# encoding: utf-8
require 'test_helper'

module BrBoleto
	module Calculos
		describe Modulo11Fator3197 do
			context 'with Sicoob documentation example' do
				subject { Modulo11Fator3197.new('000100000000190000021') }

				it { subject.must_equal '8' }
			end

			context "quando o resultado do mod_division for 0 então deve retornar zero e não o resultado do total" do
				subject { Modulo11Fator3197.new('123') }
				before do
					Modulo11Fator3197.any_instance.stubs(:mod_division).returns(0)
					Modulo11Fator3197.any_instance.stubs(:total).returns(9)
				end
				it { subject.must_equal '0' }
			end

			context "quando o resultado do mod_division for 1 então deve retornar zero e não o resultado do total" do
				subject { Modulo11Fator3197.new('123') }
				before do
					Modulo11Fator3197.any_instance.stubs(:mod_division).returns(1)
					Modulo11Fator3197.any_instance.stubs(:total).returns(9)
				end
				it { subject.must_equal '0' }
			end

			[1..9].each do |numero|
				context "quando o resultado do mod_division for #{numero} então deve o resultado do total" do
					subject { Modulo11Fator3197.new('123') }
					before do
						Modulo11Fator3197.any_instance.stubs(:mod_division).returns(numero)
						Modulo11Fator3197.any_instance.stubs(:total).returns(9)
					end
					it { subject.must_equal '9' }
				end
			end
		end
	end
end