require 'test_helper'

describe BrBoleto::Helper::Number do
	describe '#formata_valor_monetario' do
		it "deve remover a pontuação do número" do
			BrBoleto::Helper::Number.new(7_658.478654).formata_valor_monetario(8).must_equal '00765848'
			BrBoleto::Helper::Number.new(850.2).formata_valor_monetario(13).must_equal '0000000085020'
		end
		it "se o numero estiver nil deve retornar zeros" do
			BrBoleto::Helper::Number.new(nil).formata_valor_monetario(13).must_equal '0000000000000'
		end
	end

	describe '#formata_valor_percentual' do
		it "deve preencher com zeros a direiva ai inves da esquerda" do
			BrBoleto::Helper::Number.new(2.55).formata_valor_percentual.must_equal '025500'
			BrBoleto::Helper::Number.new(850.2).formata_valor_percentual(10).must_equal '8502000000'
			BrBoleto::Helper::Number.new(10.47).formata_valor_percentual(5).must_equal '10470'
		end
	end

	describe '#get_percent_by_total' do
		it "deve retornar o percentual representado pelo numero a partir do valor passado por parâmetro" do
			BrBoleto::Helper::Number.new(10.47).get_percent_by_total(194.87, 4).must_equal 5.3728
			BrBoleto::Helper::Number.new(4.20).get_percent_by_total(325.45    ).must_equal 1.290521
			BrBoleto::Helper::Number.new(0.77).get_percent_by_total(8.5,    2 ).must_equal 9.06
		end
	end
end
