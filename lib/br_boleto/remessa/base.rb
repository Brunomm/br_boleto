require "unidecoder"

module BrBoleto
	module Remessa
		class Base < BrBoleto::ActiveModelBase
			include BrBoleto::HaveConta

			def pagamento_valid_tipo_impressao_required;    end
			def pagamento_valid_cod_desconto_length;        end
			def pagamento_valid_emissao_boleto_length;      end
			def pagamento_valid_distribuicao_boleto_length; end
			
			# sequencial remessa (num. sequencial que nao pode ser repetido nem zerado)
			attr_accessor :sequencial_remessa

			# Data e hora da geração do arquivo
			attr_accessor :data_hora_arquivo

			validates :sequencial_remessa, presence: true

			def persisted?
				false
			end

			# Data de geracao do arquivo
			#
			# @return [String]
			#
			def data_geracao(formato = '%d%m%Y')
				data_hora_arquivo.to_date.strftime(formato)
			end

			# Hora de geracao do arquivo
			#
			# @return [String]
			#
			def hora_geracao(formato = '%H%M%S')
				data_hora_arquivo.strftime(formato)
			end
			
			def data_hora_arquivo
				@data_hora_arquivo.to_time
			rescue
				return Time.current
			end
		end
	end
end