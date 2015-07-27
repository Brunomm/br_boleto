# encoding: utf-8
require 'test_helper'

describe BrBoleto::Calculos::FatorVencimento do
	describe "#base_date" do
		it "should be 1997-10-07" do
			BrBoleto::Calculos::FatorVencimento.new(Date.parse("2012-02-01")).base_date.must_equal Date.new(1997, 10, 7)
		end
	end

	describe "#calculate" do
		it 'should return an empty string when passing nil value' do
			BrBoleto::Calculos::FatorVencimento.new(nil).must_equal ''
		end

		it 'should return an empty string when passing empty value' do
			BrBoleto::Calculos::FatorVencimento.new('').must_equal ''
		end

		it "should calculate the days between expiration date and base date" do
			BrBoleto::Calculos::FatorVencimento.new(Date.parse("2012-12-2")).must_equal "5535"
		end

		it "should calculate equal to itau documentation example" do
			BrBoleto::Calculos::FatorVencimento.new(Date.parse("2000-07-04")).must_equal "1001"
		end

		it "should calculate equal to itau documentation last section of the docs" do
			BrBoleto::Calculos::FatorVencimento.new(Date.parse("2002-05-01")).must_equal "1667"
		end

		it "should calculate to the maximum date equal to itau documentation example" do
			BrBoleto::Calculos::FatorVencimento.new(Date.parse("2025-02-21")).must_equal "9999"
		end

		it "should calculate the days between expiration date one year ago" do
			BrBoleto::Calculos::FatorVencimento.new(Date.parse("2011-05-25")).must_equal "4978"
		end

		it "should calculate the days between expiration date two years ago" do
			BrBoleto::Calculos::FatorVencimento.new(Date.parse("2010-10-02")).must_equal "4743"
		end

		it "should calculate the days between expiration date one year from now" do
			BrBoleto::Calculos::FatorVencimento.new(Date.parse("2013-02-01")).must_equal "5596"
		end

		it "should calculate the days between expiration date eigth years from now" do
			BrBoleto::Calculos::FatorVencimento.new(Date.parse("2020-02-01")).must_equal "8152"
		end

		it "should calculate the days between expiration date formating with 4 digits" do
			BrBoleto::Calculos::FatorVencimento.new(Date.parse("1997-10-08")).must_equal "0001"
		end
	end
end