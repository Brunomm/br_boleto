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

				# documento do cedente (CPF/CNPJ)
				attr_accessor :documento_cedente

				# convenio do cedente
				attr_accessor :convenio

				# mensagem 1
				attr_accessor :mensagem_1

				# mensagem 2
				attr_accessor :mensagem_2

				# Data e hora da geração do arquivo
				attr_accessor :data_hora_arquivo

				# codigo da carteira
				#   opcoes:
				#     1 - cobranca simples
				#     2 - cobranca caucionada
				#     3 - cobranca descontada
				#     7 – modalidade Simples quando carteira 17 (apenas Banco do Brasil)
				attr_accessor :codigo_carteira

				# forma de cadastramento dos titulos (campo nao tratado pelo Banco do Brasil)
				#   opcoes:
				#     1 - com cadastramento (cobrança registrada)
				#     2 - sem cadastramento (cobrança sem registro)
				attr_accessor :forma_cadastramento

				# identificacao da emissao do boleto (verificar opcoes nas classes referentes aos bancos)
				attr_accessor :emissao_boleto

				# identificacao da distribuicao do boleto (verificar opcoes nas classes referentes aos bancos)
				attr_accessor :distribuicao_boleto

				# especie do titulo (verificar o padrao nas classes referentes aos bancos)
				attr_accessor :especie_titulo

				
				def self.tamanho_codigo_carteira
					1
				end

				def self.tamanho_forma_cadastramento
					1
				end

				def self.tamanho_emissao_boleto
					1
				end

				def self.tamanho_distribuicao_boleto
					1
				end

				def self.tamanho_especie_titulo
					2
				end

				def convenio_obrigatorio?
					true
				end

				validates :convenio,          presence: true, if: :convenio_obrigatorio?
				validates :documento_cedente, presence: true

				validates :codigo_carteira,     length: {is: tamanho_codigo_carteira,     message: "deve ter #{tamanho_codigo_carteira} dígito."}
				validates :forma_cadastramento, length: {is: tamanho_forma_cadastramento, message: "deve ter #{tamanho_forma_cadastramento} dígito."}
				validates :emissao_boleto,      length: {is: tamanho_emissao_boleto,      message: "deve ter #{tamanho_emissao_boleto} dígito."}
				validates :distribuicao_boleto, length: {is: tamanho_distribuicao_boleto, message: "deve ter #{tamanho_distribuicao_boleto} dígito."}
				validates :especie_titulo,      length: {is: tamanho_especie_titulo,      message: "deve ter #{tamanho_especie_titulo} dígitos."}

				def default_values
					super.merge({
						codigo_carteira:     '1',
						forma_cadastramento: '1'
					})
				end

				# Tipo de inscricao do cedente
				# (pessoa fisica ou juridica)
				#
				# @return [String]
				#
				def tipo_inscricao
					# Retorna 1 se CPF e 2 se CNPJ
					BrBoleto::Helper::CpfCnpj.new(documento_cedente).tipo_documento(1)
				end

				# Data de geracao do arquivo
				#
				# @return [String]
				#
				def data_geracao
					data_hora_arquivo.to_date.strftime('%d%m%Y')
				end

				# Hora de geracao do arquivo
				#
				# @return [String]
				#
				def hora_geracao
					data_hora_arquivo.strftime('%H%M%S')
				end
				
				def data_hora_arquivo
					@data_hora_arquivo.to_time
				rescue
					return Time.now
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

					#Nº Sequencial de Registros no Lote:
					sequencial_do_lote = 1

					# Metodo 'monta_header_lote' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::HeaderLote
					itens_lote = [monta_header_lote(nro_lote)] # Fixo numero sequencial do lote = 1
					sequencial_do_lote += 1

					#Contador para saber quantos segmentos tem no lote
					cont_segmentos_lote = 0
					lote.pagamentos.each do |pagamento|					
						# Metodo 'monta_segmento_p' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::SegmentoP
						cont_segmentos_lote += 1
						itens_lote << monta_segmento_p(pagamento, cont_segmentos_lote, sequencial_do_lote)
						sequencial_do_lote += 1
						
						# Metodo 'monta_segmento_q' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::SegmentoQ
						cont_segmentos_lote += 1
						itens_lote << monta_segmento_q(pagamento, cont_segmentos_lote, sequencial_do_lote)
						sequencial_do_lote += 1

						# Metodo 'monta_segmento_r' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::SegmentoR
						cont_segmentos_lote += 1
						itens_lote << monta_segmento_r(pagamento, cont_segmentos_lote, sequencial_do_lote)
						sequencial_do_lote += 1

						# Metodo 'monta_segmento_s' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::SegmentoS
						cont_segmentos_lote += 1
						itens_lote << monta_segmento_s(pagamento, cont_segmentos_lote, sequencial_do_lote)
						sequencial_do_lote += 1
					end
					
					# Metodo 'monta_trailer_lote' implementado no module -> BrBoleto::Remessa::Cnab240::Helper::TrailerLote
					itens_lote << monta_trailer_lote(nro_lote, sequencial_do_lote)

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
				# Valor que se encontra no nosso numero
				# 15 posições
				#
				def segmento_p_numero_do_documento(pagamento)
					pagamento.nosso_numero.to_s.rjust(15, '0')
				end

				# Complemento do registro
				#
				# Este metodo deve ser sobrescrevido na classe do banco
				#
				def complemento_header
					raise NotImplementedError.new('Sobreescreva este método na classe referente ao banco que você esta criando')
				end

				# Numero da versao do layout do arquivo
				#
				# Este metodo deve ser sobrescrevido na classe do banco
				#
				def versao_layout_arquivo
					raise NotImplementedError.new('Sobreescreva este método na classe referente ao banco que você esta criando')
				end

				# Numero da versao do layout do lote
				#
				# Este metodo deve ser sobrescrevido na classe do banco
				#
				def versao_layout_lote
					raise NotImplementedError.new('Sobreescreva este método na classe referente ao banco que você esta criando')
				end

				# Informacoes do convenio para o lote
				#
				# Este metodo deve ser sobrescrevido na classe do banco
				#
				def convenio_lote
					raise NotImplementedError.new('Sobreescreva este método na classe referente ao banco que você esta criando')
				end

				# Nome do banco
				#
				# Este metodo deve ser sobrescrevido na classe do banco
				#
				def nome_banco
					raise NotImplementedError.new('Sobreescreva este método na classe referente ao banco que você esta criando')
				end

				# Codigo do banco
				#
				# Este metodo deve ser sobrescrevido na classe do banco
				#
				def codigo_banco
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

				# Digito verificado da agência
				# Normalmente calculado pelo Modulo 11
				# Deve ser sobrescrito na classe do banco
				#
				def digito_agencia
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
				def complemento_trailer_lote
					''.rjust(217, ' ')	
				end
			end
		end
	end
end