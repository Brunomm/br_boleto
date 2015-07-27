# encoding: utf-8
require 'test_helper'

module BrBoleto
	module Calculos
		describe Modulo11FatorDe2a7 do
			context 'with Bradesco documentation example' do
				subject { Modulo11FatorDe2a7.new('1900000000002') }

				it { subject.must_equal '8' }
			end

			context 'with Bradesco example that returns P' do
				subject { Modulo11FatorDe2a7.new('1900000000001') }

				it { subject.must_equal 'P' }
			end

			context 'with Bradesco example that returns zero' do
				subject { Modulo11FatorDe2a7.new('1900000000006') }

				it { subject.must_equal '0' }
			end

			context "when have two digits" do
				subject { Modulo11FatorDe2a7.new('20') }  

				it { subject.must_equal '5' }
			end

			context "when have two digits (more examples)" do
				subject { Modulo11FatorDe2a7.new('26') }

				it { subject.must_equal '4' }
			end

			context "more examples" do
				subject { Modulo11FatorDe2a7.new('64') }

				it { subject.must_equal '7' }
			end
		end
	end
end