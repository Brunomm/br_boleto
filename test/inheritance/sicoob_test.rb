# encoding: utf-8
require 'test_helper'

class TesteSicoob < BrBoleto::Boleto::Sicoob
	def valid_valor_documento_tamanho_maximo
		456.50 # Default 99999999.99
	end

	def valid_carteira_inclusion
		%w[1] # Default %w[1 3]
	end
end

describe TesteSicoob do
	subject { TesteSicoob.new() }

	describe "on validations" do

		it "valor maximo do documento" do
			subject.send(:valid_valor_documento_tamanho_maximo).must_equal 456.5
			must validate_numericality_of(:valor_documento).is_less_than_or_equal_to(456.50)
		end

			context '#conta.carteira' do
			it { subject.valid_carteira_inclusion.must_equal ['1'] }
			it "validação da carteira da conta" do
				subject.conta.carteira = '3'
				conta_must_be_msg_error(:carteira, :custom_inclusion, {list: '1'})
				subject.conta.carteira = '1'
				conta_wont_be_msg_error(:carteira, :custom_inclusion, {list: '1'})
			end
		end

		def conta_must_be_msg_error(attr_validation, msg_key, options_msg={})
			must_be_message_error(:base, "#{BrBoleto::Conta::Sicoob.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
		def conta_wont_be_msg_error(attr_validation, msg_key, options_msg={})
			wont_be_message_error(:base, "#{BrBoleto::Conta::Sicoob.human_attribute_name(attr_validation)} #{get_message(msg_key, options_msg)}")
		end
	end
end
