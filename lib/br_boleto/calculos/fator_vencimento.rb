# encoding: utf-8
module BrBoleto
  module Calculos
    # Classe responsável pelo cálculo de Fator de Vencimento do boleto bancário.
    #
    # === Descricão
    #
    # Conforme Carta-circular 002926 do Banco Central do Brasil, de 24/07/2000, recomenda-se a indicação do Fator de Vencimento no Código de Barras.
    # A partir de 02/04/2001, o Banco acolhedor/recebedor não será mais responsável por eventuais diferenças de recebimento de BOLETOs fora do prazo,
    # ou sem a indicação do fator de vencimento.
    #
    # === Forma para obtenção do Fator de Vencimento
    #
    # Calcula-se <b>o número de dias corridos</b> entre a data base (<b>“Fixada” em 07/10/1997</b>) e a do vencimento desejado:
    # Alguns bancos dizem para Fazer o seguinte Cálculo: ((data de vencimento) - (03/07/2000) + 1000)
    # Porém esse cálculo é a mesma coisa que fazer: ((data de vencimento) - (07/10/1997))
    #
    #    Vencimento desejado:   04/07/2000
    #    Data base          : - 07/10/1997
    #    # => 1001
    #
    # === Atenção
    #
    # Caso ocorra divergência entre a data impressa no campo “data de vencimento” e a constante no código de barras,
    # o recebimento se dará da seguinte forma:
    #
    # * Quando pago por sistemas eletrônicos (Home-Banking, Auto-Atendimento, Internet, SISPAG, telefone, etc.), prevalecerá à representada no “código de barras”;
    # * Quando quitado na rede de agências, diretamente no caixa, será considerada a data impressa no campo “vencimento” do BOLETO.
    #
    # @return [String] retorna o resultado do cálculo. <b>Deve conter 4 dígitos</b>.
    #
    # @example
    #
    #    FatorVencimento.new(Date.parse("2012-12-02"))
    #    #=> "5535"
    #
    #    FatorVencimento.new(Date.parse("1997-10-08"))
    #    #=> "0001"
    #
    #    FatorVencimento.new(Date.parse("2012-12-16"))
    #    #=> "5549"
    #
    #    FatorVencimento.new(Date.parse("2014-12-15"))
    #    #=> "6278"
    #
    
    
    class FatorVencimento < String
      
      # A base é des de quando será subtraido a data de validade
      attr_accessor :base_date
      def base_date
        @base_date || Date.new(1997, 10, 7)
      end

      # @param [Date] expiration_date
      # @param [Date] base_date
      # @return [String] retorna o resultado do cálculo. <b>Deve conter 4 dígitos</b>.
      # @example
      #    FatorVencimento.new(Date.parse("2012-09-02"))
      #    #=> "5444"
      #
      #    FatorVencimento.new(Date.parse("1999-10-01"))
      #    #=> "0724"
      #
      #    FatorVencimento.new(Date.parse("2022-12-16"))
      #    #=> "9201"
      #

      #########################################################
      ############ OPÇÃO PARA CUSTOMIZAÇÃO DO CÁLCULO #########
      ############# MODIFIQUE APENAS SE TIVER CERTEZA #########
      #########################################################
        # Caso algum dia mude a forma do cálculo da data base, os valores do cálculo
        # poderão ser passados por parâmetro. Dia 22/02/2025 a diferença terá 5 números
        # Mas até lá não se sabe o que irá mudar
        attr_accessor :subtracao
        # Caso necessite subtratir o resultado entre a diferença do (vencimento - data_base) 
        def subtracao
          @subtracao || 0
        end

        # Caso necessite somar o resultado entre a diferença do (vencimento - data_base) 
        attr_accessor :soma
        def soma
          @soma || 0
        end

        # Caso necessite modificar o número de caracteres de retorno
        attr_accessor :quantidade_de_caracteres
        def quantidade_de_caracteres
          @quantidade_de_caracteres || 4
        end
      #########################################################

      def initialize(expiration_date, options={})
        @expiration_date = expiration_date
        self.base_date = options[:base_date]          
        self.subtracao = options[:subtracao]          
        self.soma      = options[:soma]     
        self.quantidade_de_caracteres   = options[:quantidade_de_caracteres]        

        if @expiration_date.present?
          super(calculate)
        end
      end

     

      # Cálculo da data de vencimento com a data base.
      #
      # @return [String] exatamente 4 dígitos
      #
      def calculate
        expiration_date_minus_base_date.to_s.rjust(quantidade_de_caracteres, '0')
      end

      # @api private
      #
      # Cálculo da data de vencimento com a data base.
      # Chamando #to_i para não retornar um Float.
      # @return [Integer] diff between this two dates.
      #
      def expiration_date_minus_base_date
        ((@expiration_date - base_date).to_i+soma)-subtracao
      end
    end
  end
end