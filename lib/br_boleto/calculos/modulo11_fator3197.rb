module BrBoleto
  module Calculos
    # === Módulo 11 Fator 3197
    #
    # === Passos
    #
    # 1) Tomando-se os algarismos multiplique-os, iniciando-se da direita para a esquerda,
    # pela seqüência numérica (3, 1, 9 ,7, 3, 1, 9 ,7 ... e assim por diante).
    #
    # 2) Some o resultado de cada produto efetuado e determine o total como (N).
    #
    # 3) Divida o total (N) por 11 e determine o resto obtido da divisão como Mod 11(N).
    #
    # 4) Calcule o dígito verificador (DAC) através da expressão:
    #
    #     DIGIT = 11 - Mod 11 (n)
    #
    # <b>OBS.:</b> Se o resto da divisão for “1” ou "0", o resultado deve ser = 0
    #
    # ==== Exemplo
    #
    # Considerando o seguinte número: '306900008281900010005'.
    #
    # 1) Multiplicando a seqüência de multiplicadores:
    #
    #      3  0  6  9  0  0  0  0  8  2  8  1  9  0  0  0  1  0  0  0  5
    #      *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *
    #      3  1  9  7  3  1  9  7  3  1  9  7  3  1  9  7  3  1  9  7  3
    #
    # 2) Soma-se o resultado dos produtos obtidos no item “1” acima:
    #
    #      9  0  54 63 0  0  0  0  24 2  72 7  27 0  0  0  3  0  0  0  15 
    #      # => 204
    #
    # 3) Determina-se o resto da Divisão:
    #
    #      204 % 11
    #      # => 55
    #      Como é maior que 10, então pega-se 60-55 = 5
    #      Por exemplo, se fosse 27, então pegaria 30-27 = 3
    #
    # 4) Calcula-se o DAC:
    #
    #      11 - 5
    #      # => 6 =============> Resultado final retornado.
    #
    # @param [String]: Corresponde ao número a ser calculado o Módulo 11 no fator de 2 a 7.
    # @return [String] Retorna o resultado do cálculo descrito acima.
    #
    # @example
    #
    #    BrBoleto::Calculos::Modulo11FatorDe2a7.new('20')
    #    # => '5'
    #
    #    BrBoleto::Calculos::Modulo11FatorDe2a7.new('64')
    #    # => '7'
    #
    #    BrBoleto::Calculos::Modulo11FatorDe2a7.new('26')
    #    # => '4'
    #
    #    BrBoleto::Calculos::Modulo11FatorDe2a7.new('6')
    #    # => 'P'
    #
    #    BrBoleto::Calculos::Modulo11FatorDe2a7.new('14')
    #    # => '0'
    #
    class Modulo11Fator3197 < Modulo11
      # Sequência numérica 3197 que será feito a multiplicação de cada dígito
      # do número passado no #initialize.
      #
      # @return [Array] Sequência numérica
      #
      def fatores
        [3,7,9,1]
      end

      # @return [Fixnum]
      #
      def calculate
        if mod_division.equal?(1) or mod_division.equal?(0)
          0
        else
          total
        end
      end
    end
  end
end