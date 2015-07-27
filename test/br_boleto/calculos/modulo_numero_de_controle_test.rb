# encoding: utf-8
require 'test_helper'

module BrBoleto
	module Calculos
		describe ModuloNumeroDeControle do
			context "when is simple calculation" do
				subject { ModuloNumeroDeControle.new('00009274') }

				it { subject.must_equal '22' }
			end

			context "another example" do
				subject { ModuloNumeroDeControle.new('0000001') }

				it { subject.must_equal '83' }
			end

			context "example with second digit invalid" do
				subject { ModuloNumeroDeControle.new('00009194') }

				it { subject.must_equal '38' }
			end

			context "example with second digit invalid and first digit with '9'" do
				subject { ModuloNumeroDeControle.new('411') }

				it { subject.must_equal '06' }
			end

			context 'should calculate when the first digit is not 10 (ten)' do
				subject { ModuloNumeroDeControle.new('5') }

				it { subject.must_equal '90' }
			end
		end
	end
end