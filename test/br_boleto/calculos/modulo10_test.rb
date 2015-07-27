# encoding: utf-8
require 'test_helper'

module BrBoleto
	module Calculos
		describe Modulo10 do
			it "should accept the examples by the 'Itau documentation'" do
				Modulo10.new('341911012').must_equal  '1'
				Modulo10.new('3456788005').must_equal '8'
				Modulo10.new('7123457000').must_equal '1'
			end

			it "should accept the example from Banrisul" do
				Modulo10.new('00009274').must_equal '2'
			end

			it "returns zero when number is 0" do
				Modulo10.new('0').must_equal '0'
			end

			it "returns zero when mod 10 is zero" do
				Modulo10.new('99906').must_equal '0'
			end

			it "calculate when number had 1 digit" do
				Modulo10.new('1').must_equal '8'
			end

			it "calculate when number had 2 digits" do
				Modulo10.new('10').must_equal '9'
			end

			it "calculate when number had 3 digits" do
				Modulo10.new('994').must_equal '4'
			end

			it "calculate when number had 5 digits" do
				Modulo10.new('97831').must_equal '2'
			end

			it "calculate when number had 6 digits" do
				Modulo10.new('147966').must_equal '6'
			end

			it "calculate when number had 10 digits" do
				Modulo10.new('3456788005').must_equal '8'
			end

			it "should accept numbers too" do
				Modulo10.new(12345).must_equal '5'
			end
		end
	end
end