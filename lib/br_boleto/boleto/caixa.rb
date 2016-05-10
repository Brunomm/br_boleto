# encoding: utf-8
module BrBoleto
	module Boleto
		# Implementação de emissão de boleto bancário pela Caixa Econômica Federal.
		#
		# === Documentação Implementada
		#
		# A documentação na qual essa implementação foi baseada está localizada na pasta
		# 'documentacoes_dos_boletos/caixa' dentro dessa biblioteca.
		# === Carteiras suportadas
		#
		# Segue abaixo as carteiras suportadas da Caixa Econômica Federal <b>seguindo a documentação</b>:
		#
		#      ___________________________________________
		#     | Carteira | Descrição                     |
		#     |    14    | Cobrança Simples com registro |
		#     |    24    | Cobrança Simples sem registro |
		#     |__________________________________________|
		#     === Carteira/Modalidade:
		#     
		#      1/4 = Registrada   / Emissão do boleto(4-Beneficiário) 
		#      2/4 = Sem Registro / Emissão do boleto(4-Beneficiário) 
		#    
		#
		class Caixa < Base
			#Modalidades de cobranças válidas conforme a documentação
			def self.modalidade_cobranca_validas
				%w(1 2)
			end

			def deve_validar_modalidade_cobranca?
				true
			end

			# Tamanho máximo de uma agência na Caixa Econômica Federal.
			# <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
			#
			# @return [Fixnum] 4
			#
			def self.tamanho_maximo_agencia
				4
			end

			# Tamanho máximo do código do cedente emitido no Boleto.
			# <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
			#
			# @return [Fixnum] 6
			#
			def self.tamanho_maximo_codigo_cedente
				6
			end

			# Tamanho máximo do numero do documento no Boleto.
			# <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
			#
			# @return [Fixnum] 15
			#
			def self.tamanho_maximo_numero_documento
				15
			end

			# <b>Carteiras suportadas.</b>
			#
			# <b>Método criado para validar se a carteira informada é suportada.</b>
			#
			# @return [Array]
			#
			def self.carteiras_suportadas
				%w(14 24)
			end

			# Conforme descrito na documentação, o valor que deve constar em local do pagamento é
			# "PREFERENCIALMENTE NAS CASAS LOTÉRICAS ATÉ O VALOR LIMITE"
			#
			def default_values
				super.merge({
					:local_pagamento   => 'PREFERENCIALMENTE NAS CASAS LOTÉRICAS ATÉ O VALOR LIMITE'
				})
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
			#    class Caixa < BrBoleto::Core::Caixa
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
			
			# @return [String] Código do Banco descrito na documentação.
			#
			def codigo_banco
				'104'
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
				"#{agencia} / #{codigo_cedente}-#{digito_verificador_codigo_cedente}"
			end

			def digito_verificador_codigo_cedente
				BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new(codigo_cedente)
			end			
			def digito_verificador_codigo_beneficiario
				digito_verificador_codigo_cedente
			end

			def digito_verificador_nosso_numero
				BrBoleto::Calculos::Modulo11FatorDe2a9RestoZero.new("#{carteira}#{numero_documento}")
			end

			# Mostra o campo nosso número calculando o dígito verificador do nosso número.
			#
			# @return [String]
			#
			def nosso_numero
				"#{carteira}#{numero_documento}-#{digito_verificador_nosso_numero}"
			end


			def nosso_numero_de_3_a_5
				nosso_numero[2..4]
			end

			def nosso_numero_de_6_a_8
				nosso_numero[5..7]
			end

			def nosso_numero_de_9_a_17
				nosso_numero[8..16]
			end

			# O Tipo de cobrança é o 1° caracter da carteira
			#
			# @return [String]
			#
			def tipo_cobranca
				carteira[0] if carteira.present?
			end

			# Modalidade de cobrança
			# As vezes é chamado de modalidade de cobrança e as vezes é chamado de tipo de cobrança
			# Por isso foi criado o metodo modalidade_cobrança que é a mesma coisa que o tipo_cobranca
			#
			# @return [String]
			#
			def modalidade_cobranca
				tipo_cobranca
			end

			# O Identificado de Emissão é o 2° e ultimo caracter da carteira
			# Normalmente é 4 onde significa que o Beneficiário emitiu o boleto.
			#
			# @return [String]
			#
			def identificador_de_emissao
				carteira.last if carteira.present?
			end

			# Formata a carteira dependendo se ela é registrada ou não.
			#
			# Para cobrança COM registro usar: <b>RG</b>
			# Para Cobrança SEM registro usar: <b>SR</b>
			#
			# @return [String]
			#
			def carteira_formatada
				if carteira.in?(carteiras_com_registro)
					'RG'
				else
					'SR'
				end
			end

			 # Retorna as carteiras com registro da Caixa Econômica Federal.
			# <b>Você pode sobrescrever esse método na subclasse caso exista mais
			# carteiras com registro na Caixa Econômica Federal.</b>
			#
			# @return [Array]
			#
			def carteiras_com_registro
				%w(14)
			end


			#  === Código de barras do banco
			#
			#     ________________________________________________________________________________________
			#    | Posição  | Tamanho | Descrição                                                        |
			#    |----------|---------|------------------------------------------------------------------|
			#    | 20 - 25  |   06    | Código do Beneficiário                                           |
			#    | 26 - 26  |   01    | DV do Código do Beneficiário                                     |
			#    | 27 – 29  |   03    | Nosso Número - 3ª a 5ª posição do Nosso Número                   |
			#    | 30 – 30  |   01    | Constante 1, tipo de cobrança (1-Registrada / 2-Sem Registro)    |
			#    | 31 – 33  |   03    | Nosso Número - 6ª a 8ª posição do Nosso Número                   |
			#    | 34 – 34  |   01    | Constante 2, identificador de emissão do boleto (4-Beneficiário) |
			#    | 35 – 43  |   09    | Nosso Número - 9ª a 17ª posição do Nosso Número                  |
			#    | 44 – 44  |   01    | DV do Campo Livre                                                |
			#    -----------------------------------------------------------------------------------------
			#
			# @return [String]
			#
			def codigo_de_barras_do_banco
				@composicao_codigo_barras = nil				
				codigo_dv = Modulo11FatorDe2a9RestoZero.new(composicao_codigo_barras)
				"#{composicao_codigo_barras}#{codigo_dv}"
			end

			def composicao_codigo_barras
				return @composicao_codigo_barras if @composicao_codigo_barras
				@composicao_codigo_barras =  "#{codigo_beneficiario}"
				@composicao_codigo_barras << "#{digito_verificador_codigo_beneficiario}"
				@composicao_codigo_barras << "#{nosso_numero_de_3_a_5}"
				@composicao_codigo_barras << "#{tipo_cobranca}"
				@composicao_codigo_barras << "#{nosso_numero_de_6_a_8}"
				@composicao_codigo_barras << "#{identificador_de_emissao}"
				@composicao_codigo_barras << "#{nosso_numero_de_9_a_17}"
				@composicao_codigo_barras
			end
		end
	end
end
