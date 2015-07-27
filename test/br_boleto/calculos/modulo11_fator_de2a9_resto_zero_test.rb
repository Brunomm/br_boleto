# encoding: utf-8
require 'test_helper'

module BrBoleto
	module Calculos
		describe Modulo11FatorDe2a9RestoZero do
			describe "#calculate" do
				context "with a one number digit" do
					subject { Modulo11FatorDe2a9RestoZero.new(6) }

					it { subject.must_equal '0' }
				end

				context "with a two number digit" do
					subject { Modulo11FatorDe2a9RestoZero.new(100) }

					it { subject.must_equal '7' }
				end

				context "with a three number digit" do
					subject { Modulo11FatorDe2a9RestoZero.new(1004) }

					it { subject.must_equal '9' }
				end

				context "with a three number digit that returns zero" do
					subject { Modulo11FatorDe2a9RestoZero.new(1088) }

					it { subject.must_equal '0' }
				end

				context "when mod division return '10'" do
					subject { Modulo11FatorDe2a9RestoZero.new(1073) }

					it { subject.must_equal '1' }
				end
			end
		end
	end
end