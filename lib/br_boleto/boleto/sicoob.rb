# encoding: utf-8
module BrBoleto
	module Boleto
		# Implementação de emissão de boleto bancário pelo Banco Sicoob.
		#
		# === Documentação Implementada
		#
		# A documentação na qual essa implementação foi baseada está localizada na pasta
		# 'documentacoes_dos_boletos/sicoob' dentro dessa biblioteca.
		#
		class Sicoob < Base
			# === Carteira/Modalidade:
			#
			#   '1/01' - Simples com registro
			#   '1/02' - Simples sem registro
			#   '3/03' - Garantida Caucionada
			#
			attr_accessor :modalidade_cobranca
			def modalidade_cobranca
				if @modalidade_cobranca.present?
					@modalidade_cobranca.to_s.rjust(2, '0')
				else
					'01'
				end
			end

			#Modalidades de cobranças válidas conforme a documentação
			def self.modalidade_cobranca_validas
				%{'01' '02' '03'}
			end

			def deve_validar_modalidade_cobranca?
				true
			end

			# Quantidade de parcelas que o boleto possui
			# Liberando a possibilidade de edição
			attr_accessor :parcelas
			def parcelas
				if @parcelas.present?
					@parcelas.to_s.rjust(3, '0')
				else
					'001'
				end
			end


			# Tamanho máximo de uma agência no Banco Sicoob.
			# <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
			#
			# @return [Fixnum] 4
			#
			def self.tamanho_maximo_agencia
				4
			end

			# Tamanho máximo do codigo cedente no Banco Sicoob.
			# <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
			#
			# @return [Fixnum] 7
			#
			def self.tamanho_maximo_codigo_cedente
				7
			end

			# Tamanho máximo do numero do documento no Boleto.
			# <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
			#
			# @return [Fixnum] 6
			#
			def self.tamanho_maximo_numero_documento
				7
			end

			# <b>Carteiras suportadas.</b>
			#
			# <b>Método criado para validar se a carteira informada é suportada.</b>
			#
			# @return [Array]
			#
			def self.carteiras_suportadas
				%w[1 3]
			end

			# Validações para os campos abaixo:
			#
			# * Agencia
			# * Codigo Cedente
			# * Número do documento
			#
			# Se você quiser sobrescrever os metodos, <b>ficará a sua responsabilidade.</b>
			# Basta você sobrescrever os métodos de validação:
			#
			#    class Sicoob < BrBoleto::Core::Sicoob
			#       def self.tamanho_maximo_agencia
			#         6
			#       end
			#
			#       def self.tamanho_maximo_codigo_cedente
			#         9
			#       end
			#
			#       def self.tamanho_maximo_numero_documento
			#         10
			#       end
			#    end
			#
			# Obs.: Mudar as regras de validação podem influenciar na emissão do boleto em si.
			# Talvez você precise analisar o efeito no #codigo_de_barras e na #linha_digitável (ambos podem ser
			# sobreescritos também).
			#
			validates :agencia, :codigo_cedente, presence: true

			validates :agencia,          length: { maximum: tamanho_maximo_agencia          }, if: :deve_validar_agencia?
			validates :codigo_cedente,   length: { maximum: tamanho_maximo_codigo_cedente   }, if: :deve_validar_codigo_cedente?
			validates :numero_documento, length: { maximum: tamanho_maximo_numero_documento }, if: :deve_validar_numero_documento?

			validates :carteira, inclusion: { in: ->(object) { object.class.carteiras_suportadas } }, if: :deve_validar_carteira?
			validates :modalidade_cobranca, inclusion: { in: ->(object) { object.class.modalidade_cobranca_validas } }, if: :deve_validar_modalidade_cobranca?

			# @return [String] 4 caracteres
			#
			def agencia
				@agencia.to_s.rjust(4, '0') if @agencia.present?
			end

			# @return [String] 7 caracteres
			# O Código do cedente é o mesmo que o codigo do beneficiário
			def codigo_cedente
				@codigo_cedente.to_s.rjust(7, '0') if @codigo_cedente.present?
			end

			# @return [String] 6 caracteres
			#
			def numero_documento
				@numero_documento.to_s.rjust(7, '0') if @numero_documento.present?
			end

			# @return [String] Código do Banco descrito na documentação.
			#
			def codigo_banco
				'756'
			end

			# @return [String] Dígito do código do banco descrito na documentação.
			#
			def digito_codigo_banco
				'0'
			end

			# Campo Agência / Código do Cedente
			#
			# @return [String]
			#
			def agencia_codigo_cedente
				"#{agencia} / #{codigo_cedente}"
			end

			# O nosso número descrino na documentação é formado pelo numero do documento mais o digito
			# verificador no nosso_numero, que é um cálculo descrito na documentação.
			#
			# @return [String]
			#
			def nosso_numero
				"#{numero_documento}-#{digito_verificador_nosso_numero}"
			end

			#  === Código de barras do banco
			#
			#     ___________________________________________________________
			#    | Posição | Tamanho | Descrição                             |
			#    |---------|---------|---------------------------------------|
			#    | 20 - 20 |    01   | Código da carteira                    |
			#    | 21 - 24 |    04   | Código da agência                     |
			#    | 25 - 26 |    02   | Código da modalidade de cobrança (01) |
			#    | 27 - 33 |    07   | Código do Cedente                     |
			#    | 34 - 41 |    08   | Nosso Número do título                |
			#    | 42 - 44 |    03   | Número da Parcela do Título (001)     |
			#    |___________________________________________________________|
			#
			# @return [String]
			#
			def codigo_de_barras_do_banco
				"#{carteira}#{agencia}#{modalidade_cobranca}#{codigo_cedente}#{nosso_numero.gsub('-','')}#{parcelas}"
			end

			def digito_verificador_nosso_numero
				BrBoleto::Calculos::Modulo11Fator3197.new("#{agencia}#{codigo_cedente.rjust(10, '0')}#{numero_documento}")
			end
		end
	end
end
