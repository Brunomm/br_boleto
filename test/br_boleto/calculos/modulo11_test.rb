# encoding: utf-8
require 'test_helper'

module BrBoleto
	module Calculos
		describe Modulo11 do
			subject { Modulo11.new(1) }

			describe "#fatores" do
				before { Modulo11.any_instance.stubs(:calculate).returns(1) }

				it "expects raise error" do
					assert_raises NotImplementedError do
						subject.fatores
					end
				end
			end

			describe "#calculate" do
				it "expects raise error" do
					assert_raises NotImplementedError do
						Modulo11.new(1)
					end
				end
			end
		end
	end
end