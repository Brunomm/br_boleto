require 'test_helper'

describe BrBoleto::Remessa::Base do
	subject { FactoryBot.build(:remessa_base) }
	before do
		subject.stubs(:conta_class).returns BrBoleto::Conta::Sicoob
	end
	describe "validations" do
		it { must validate_presence_of(:sequencial_remessa) }
	end

	it "deve ter incluso o module HaveConta" do
		subject.class.included_modules.must_include BrBoleto::HaveConta
	end

	it "wont be persisted?" do
		subject.persisted?.must_equal false
	end

	describe "#data_geracao" do
		it "deve pegar a data com 8 posições do atributo data_hora_arquivo" do
			subject.data_hora_arquivo = Time.parse("30/12/2015 01:02:03")
			subject.data_geracao.must_equal "30122015"
		end
		it "Posso escolher o formato em que a data virá" do
			subject.data_hora_arquivo = Time.parse("25/08/2017 01:02:03")
			subject.data_geracao('%m%d%y').must_equal "082517"
		end
	end

	describe "#hora_geracao" do
		it "deve pegar a hora minuto e segundo da data_hora_arquivo" do
			subject.data_hora_arquivo = Time.parse("30/12/2015 01:02:03")
			subject.hora_geracao.must_equal "010203"
		end
		it "deve permitir passar o formato por parametro" do
			subject.data_hora_arquivo = Time.parse("04/12/1991 03:30:51")
			subject.hora_geracao('%H%M').must_equal "0330"
		end
	end

	describe "#data_hora_arquivo" do
		it "se for nil deve pegar o time now" do
			subject.data_hora_arquivo = nil
			now = Time.now
			Time.expects(:current).returns(now)
			subject.data_hora_arquivo.must_equal now
		end
		it "se passar um date_time deve converter para time" do
			now = DateTime.now
			subject.data_hora_arquivo = now
			subject.data_hora_arquivo.must_equal now.to_time
		end
	end
end
