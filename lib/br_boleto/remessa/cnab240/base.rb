# -*- encoding: utf-8 -*-
require 'br_boleto/remessa/cnab240/helper/header_arquivo'
require 'br_boleto/remessa/cnab240/helper/header_lote'
require 'br_boleto/remessa/cnab240/helper/segmento_p'
require 'br_boleto/remessa/cnab240/helper/segmento_q'
require 'br_boleto/remessa/cnab240/helper/segmento_r'
require 'br_boleto/remessa/cnab240/helper/segmento_s'
require 'br_boleto/remessa/cnab240/helper/trailer_lote'
require 'br_boleto/remessa/cnab240/helper/trailer_arquivo'

module BrBoleto
	module Remessa
		module Cnab240
			class Base < BrBoleto::Remessa::Base
				
				# Utilizado para montar o header do arquivo
				include BrBoleto::Remessa::Cnab240::Helper::HeaderArquivo
				
				# Utilizado para montar o header do lote
				include BrBoleto::Remessa::Cnab240::Helper::HeaderLote

				# Utilizado para montar o segmento P
				include BrBoleto::Remessa::Cnab240::Helper::SegmentoP

				# Utilizado para montar o segmento Q
				include BrBoleto::Remessa::Cnab240::Helper::SegmentoQ

				# Utilizado para montar o segmento R
				include BrBoleto::Remessa::Cnab240::Helper::SegmentoR

				# Utilizado para montar o segmento S
				include BrBoleto::Remessa::Cnab240::Helper::SegmentoS

				# Utilizado para montar o trailer do lote
				include BrBoleto::Remessa::Cnab240::Helper::TrailerLote

				# Utilizado para montar o trailer do arquivo
				include BrBoleto::Remessa::Cnab240::Helper::TrailerArquivo

				# Utilizado para padronização dos códigos, segundo a documentação
				include BrBoleto::Helper::DefaultCodes

				# mensagem 1
				attr_accessor :mensagem_1

				# mensagem 2
				attr_accessor :mensagem_2

				# variavel que terá os lotes no qual será gerado o arquivo de remessa
				# um lote deve conter no minimo 1 pagamento
				# Pode haver 1 ou vários lotes para o mesmo arquivo
				attr_accessor :lotes

				def self.class_for_lote
					BrBoleto::Remessa::Lote
				end

				def pagamento_valid_emissao_boleto_length
					1
				end

				def pagamento_valid_distribuicao_boleto_length
					1
				end

				validates_each :lotes do |record, attr, value|
					record.errors.add(attr, :blank) if value.empty?
					value.each do |lote|
						lote.pagamento_valid_tipo_impressao_required    = record.pagamento_valid_tipo_impressao_required
						lote.pagamento_valid_cod_desconto_length        = record.pagamento_valid_cod_desconto_length
						lote.pagamento_valid_emissao_boleto_length      = record.pagamento_valid_emissao_boleto_length
						lote.pagamento_valid_distribuicao_boleto_length = record.pagamento_valid_distribuicao_boleto_length
						if lote.invalid?
							lote.errors.full_messages.each { |msg| record.errors.add(:base, msg) }
						end
					end				
				end

				# O atributo lotes sempre irá retornar umm Array 
				def lotes
					@lotes = [@lotes].flatten.compact.select{|l| l.is_a?(self.class.class_for_lote) }
				end

				# Monta um lote para o arquivo
				#
				# @param lote [BrBoleto::Remessa::Lote]
				#   objeto contendo os detalhes do boleto (valor, )
				#
				# @param nro_lote [Integer]
				# numero do lote no arquivo
				#
				# @return [Array]
				#
				def monta_lote(lote, nro_lote)
					return if lote.invalid?


					# Metodo 'monta_header_lote' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::HeaderLote
					itens_lote = [monta_header_lote(lote, nro_lote)]
					
					#Nº Sequencial de Registros no Lote:
					sequencial_do_lote = 0

					lote.pagamentos.each do |pagamento|					
						# Metodo 'monta_segmento_p' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::SegmentoP
						sequencial_do_lote += 1
						itens_lote << monta_segmento_p(pagamento, nro_lote, sequencial_do_lote)
						
						# Metodo 'monta_segmento_q' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::SegmentoQ
						sequencial_do_lote += 1
						itens_lote << monta_segmento_q(pagamento, nro_lote, sequencial_do_lote)

						# Metodo 'monta_segmento_r' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::SegmentoR
						sequencial_do_lote += 1
						itens_lote << monta_segmento_r(pagamento, nro_lote, sequencial_do_lote)

						# Metodo 'monta_segmento_s' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::SegmentoS
						sequencial_do_lote += 1
						itens_lote << monta_segmento_s(pagamento, nro_lote, sequencial_do_lote)
					end
					
					# total_de_registros_do_lote é a quantidade de registros(linhas) que constam em um lote
					# Total de complementos do lote + o HEADER_LOTE + TRAILER_LOTE
					#        sequencial_do_lote     +       1       +      1  
					total_de_registros_do_lote = sequencial_do_lote + 2

					# Metodo 'monta_trailer_lote' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::TrailerLote
					itens_lote << monta_trailer_lote(lote, nro_lote, total_de_registros_do_lote)

					itens_lote
				end

				# Gera os dados para o arquivo remessa
				#
				# @return [String]
				#
				def dados_do_arquivo
					return if self.invalid?

					# contador dos registros do lote
					contador = 1

					# Metodo 'monta_header_arquivo' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::HeaderArquivo
					arquivo = [monta_header_arquivo] 
					contador += 1

					lotes.each_with_index do |lote, index|
						novo_lote = monta_lote(lote, (index + 1))
						arquivo.push novo_lote
						novo_lote.each { |_lote| contador += 1 }
					end

					# Metodo 'monta_trailer_arquivo' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::TrailerArquivo
					arquivo << monta_trailer_arquivo(lotes.count, contador)

					retorno = arquivo.join("\n")
					ActiveSupport::Inflector.transliterate(retorno).upcase
				end

				# Número do Documento de Cobrança 
				# Cada banco tem sua maneira de identificar esse número, mas o padrão é o
				# Valor que se encontra no numero_documento ou então em nosso numero
				# 15 posições
				#
				def segmento_p_numero_do_documento(pagamento)
					if pagamento.numero_documento.present?
						pagamento.numero_documento.to_s.rjust(15, '0')
					else
						pagamento.nosso_numero.to_s.rjust(15, '0')
					end
				end

				# Complemento do registro
				#
				# Este metodo deve ser sobrescrevido na classe do banco
				#
				def complemento_header_arquivo
					raise NotImplementedError.new('Sobreescreva este método na classe referente ao banco que você esta criando')
				end

				# Informacoes do convenio para o lote
				#
				# Este metodo deve ser sobrescrevido na classe do banco
				#
				def convenio_lote(lote)
					raise NotImplementedError.new('Sobreescreva este método na classe referente ao banco que você esta criando')
				end

				# Informacoes da conta do cedente
				#
				# Este metodo deve ser sobrescrevido na classe do banco
				#
				def informacoes_da_conta
					raise NotImplementedError.new('Sobreescreva este método na classe referente ao banco que você esta criando')
				end

				# Codigo do convenio
				#
				# Este metodo deve ser sobrescrevido na classe do banco
				#
				def codigo_convenio
					raise NotImplementedError.new('Sobreescreva este método na classe referente ao banco que você esta criando')
				end

				# Complemento do segmento P
				# Recebe um objeto da classe BrBoleto::Remessa::Pagamento
				# Composto por 34 digitos
				# Cada banco tem seu padrão
				# Deve ser sobrescrito na classe do banco
				#
				def complemento_p(pagamento)
					raise NotImplementedError.new('Sobreescreva este método na classe referente ao banco que você esta criando')
				end

				# Complemento final do trailer do lote
				# Por padrão coloco 217 caracateres em branco pois é na maioria dos bancos
				# Mas para alguns bancos isso pode mudar
				#
				def complemento_trailer_lote(lote, nr_lote)
					''.rjust(217, ' ')	
				end
			end
		end
	end
end