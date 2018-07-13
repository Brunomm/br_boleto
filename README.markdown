[![Gem Version](https://badge.fury.io/rb/br_boleto.svg)](https://badge.fury.io/rb/br_boleto)
[![Code Climate](https://codeclimate.com/github/Brunomm/br_boleto/badges/gpa.svg)](https://codeclimate.com/github/Brunomm/br_boleto)
[![Build Status](https://travis-ci.org/Brunomm/br_boleto.svg?branch=master)](https://travis-ci.org/Brunomm/br_boleto)

# **BrBoleto**

Emissão de Boletos Bancários em Ruby.

**O que essa gem faz?**

 1. Boleto bancário (apenas os cálculos para o boleto, sem a interface) para os bancos:
- Banco do Brasil
- Bradesco (em andamento)
- Caixa
- Cecred
- Itaú
- Santander (em andamento)
- Sicoob
- Sicredi
- Unicred
 2. Arquivo de remessa para os Bancos:
- Banco do Brasil (CNAB240 e CNAB400)
- Bradesco (CNAB240 e CNAB400)
- Caixa (CNAB240 e CNAB400)
- Cecred (CNAB240)
- Itaú (CNAB240 e CNAB400)
- Santander (CNAB240 e CNAB400)
- Sicoob (CNAB240 e CNAB400)
- Sicredi (CNAB240 e CNAB400)
- Unicred (CNAB240 e CNAB400)
 3. Arquivo de retorno para os Bancos:
- Banco do Brasil (CNAB240 e CNAB400)
- Bradesco (CNAB240 e CNAB400)
- Caixa (CNAB240 e CNAB400)
- Cecred (CNAB240)
- Itaú (CNAB240 e CNAB400)
- Santander (CNAB240 e CNAB400)
- Sicoob (CNAB240 e CNAB400)
- Sicredi (CNAB240 e CNAB400)
- Unicred (CNAB240 e CNAB400)



## Instalação
**Manualmente**

    gem install br_boleto

**Gemfile**
    
     gem 'br_boleto'

## Documentação

Seguimos as documentações descritas abaixo:

* [Banco do Brasil](documentacoes_boletos/Banco do Brasil)
* [Bradesco](documentacoes_boletos/Bradesco)
* [Caixa](documentacoes_boletos/Caixa)
* [Cecred](documentacoes_boletos/cecred)
* [Itaú](documentacoes_boletos/Itaú)
* [Santander](documentacoes_boletos/Santander)
* [Sicoob](documentacoes_boletos/Sicoob)
* [Sicredi](documentacoes_boletos/Sicredi)
* [Unicred](documentacoes_boletos/Unicred)


## Bancos Suportados

Para todos os bancos e carteiras implementadas, **seguimos as documentações** que estão dentro do repositório:

**Boletos**
<table>
  <tr>
    <th>Nome do Banco</th>
    <th>Carteiras Suportadas</th>
    <th>Testada/Homologada no banco</th>
    <th>Autor </th>
  </tr>
  <tr>
    <td>Sicoob</td>
    <td>1, 3.</td>
    <td>Homologado dia 03/08/2015</td>
   <td>Bruno M. Mergen</td>
  </tr>
  <tr>
    <td>Caixa</td>
    <td>1, 2.</td>
    <td>Homologado dia 11/11/2016</td>
   <td>Bruno M. Mergen</td>
  </tr>
  <tr>
    <td>Cecred</td>
    <td>1.</td>
    <td>Homologado dia 07/11/2016</td>
   <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Unicred</td>
    <td>09.</td>
    <td>Homologado dia 11/11/2016</td>
   <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Sicredi</td>
    <td>1, 3.</td>
    <td>Homologado dia 17/11/2016</td>
   <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Banco do Brasil</td>
    <td>11, 12, 15, 16, 17, 18, 31, 51.</td>
    <td>Homologado dia 15/12/2016</td>
   <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Itaú</td>
    <td>104, 105, 107, 108, 109, 112, 113, 116, 117, 119, 121, 122, 126, 131, 134, 135, 136, 142, 143, 146, 147, 150, 168, 169, 174, 175, 180, 191, 196, 198.</td>
    <td>Homologado dia 16/12/2016</td>
   <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Bradesco</td>
    <td>06, 09, 19, 21, 22.</td>
    <td>Pendente</td>
   <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Santander</td>
    <td>101, 102, 121.</td>
    <td>Pendente</td>
   <td>Ricardo Zanuzzo</td>
  </tr>
</table>


----------


**Arquivos de remessa**
<table>
  <tr>
    <th>Nome do Banco</th>
    <th>CNAB</th>
    <th>Testada/Homologada no banco</th>
    <th>Autor </th>
  </tr>
  <tr>
    <td>Sicoob</td>
    <td>240</td>
    <td>Homologado dia 07/08/2015</td>
    <td>Bruno M. Mergen</td>
  </tr>
  <tr>
    <td>Sicoob</td>
    <td>400</td>
    <td>Pendente</td>
    <td>Bruno M. Mergen</td>
  </tr>
  <tr>
    <td>Caixa</td>
    <td>240</td>
    <td>Homologado dia 11/11/2016</td>
    <td>Bruno M. Merge</td>
  </tr>
  <tr>
    <td>Caixa</td>
    <td>400</td>
    <td>Homologado dia 29/12/2016</td>
    <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Cecred</td>
    <td>240</td>
    <td>Homologado dia 07/11/2016</td>
    <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Unicred</td>
    <td>240</td>
    <td>Homologado dia 11/11/2016</td>
    <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Unicred</td>
    <td>400</td>
    <td>Pendente</td>
    <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Sicredi</td>
    <td>240</td>
    <td>Homologado dia 17/11/2016</td>
    <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Sicredi</td>
    <td>400</td>
    <td>Pendente</td>
    <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Banco do Brasil</td>
    <td>240</td>
    <td>Homologado dia 30/12/2016</td>
    <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Banco do Brasil</td>
    <td>400</td>
    <td>Homologado dia 15/12/2016</td>
    <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Itaú</td>
    <td>240</td>
    <td>Pendente</td>
    <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Itaú</td>
    <td>400</td>
    <td>Homologado dia 16/12/2016</td>
    <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Bradesco</td>
    <td>240</td>
    <td>Pendente</td>
    <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Bradesco</td>
    <td>400</td>
    <td>Pendente</td>
    <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Santander</td>
    <td>240</td>
    <td>Pendente</td>
    <td>Ricardo Zanuzzo</td>
  </tr>
  <tr>
    <td>Santander</td>
    <td>400</td>
    <td>Pendente</td>
    <td>Ricardo Zanuzzo</td>
  </tr>
</table>

# Como usar

## Começando
Em todas as classes desenvolvidas é possível instanciar objetos em forma de `Hash` ou `Block`. Exemplo:
```ruby
obj1 = BrBoleto::Pagador.new(nome: 'João')
obj2 = BrBoleto::Pagador.new do |pagador|
  pagador.nome = 'João'
end
```

As associações também podem ser instanciadas em forma de `Hash`ou `Block`. Exemplo:
```ruby
boleto1 = BrBoleto::Boleto::Sicoob.new do |boleto|
   boleto.conta do |ct|
      ct.agencia  = 1234
      ct.carteira  = 1
   end
end

 boleto1.conta.agencia
 # => "1234"

# OU

boleto2 = BrBoleto::Boleto::Sicoob.new({
   conta: {
      agencia:  7465,
      carteira: 2
   }
}

 boleto2.conta.agencia
 # => "7465"

# OU

conta = BrBoleto::Conta::Sicoob.new(agencia:  4522)
boleto2 = BrBoleto::Boleto::Sicoob.new(conta: conta)
boleto2.conta.agencia
 # => "4522"
```


### Classes auxiliares
Devido a falta de padronização de regras e nomenclaturas entre os banco, essa gem é composta por classes auxiliares para conseguir manter o minimo de padronização com sua utilização e nomenclaturas.

#### Conta
Para gerar **boletos** e **remessas**  é necessário de uma conta bancária, certo? Pensando nisso foi criado uma classe onde contém todas as regras e informações referente a conta bancária. Existe uma classe para cada banco desenvolvido.  **Vejamos um exemplo com o banco Sicoob:**
```ruby
conta = BrBoleto::Conta::Sicoob.new({
  codigo_beneficiario:     '253167',
  codigo_beneficiario_dv:  '4', # Se não passar o dv irá gerar automaticamente
  conta_corrente:    '887469',
  conta_corrente_dv: '7', # Se não passar o dv irá gerar automaticamente
  agencia:           '3069',
  carteira:          '1',
  modalidade:        '02'  ,
  razao_social:      'Razao Social emitente',
  cpf_cnpj:          '98137264000196',
  endereco:          'Rua nome da rua, 9999',
})
  
```

#### Pagador
O pagador é o "cliente" que vai pagar o boleto/cobrança. É utilizado no boleto e no Pagamento da remessa.
```ruby
pagador = BrBoleto::Pagador.new do |pagador|
  pagador.nome =      'João da Silva'
  pagador.cpf_cnpj =  '33.669.170/0001-12' # Gerado pelo gerador de cnpj
  pagador.endereco =  'RUA DO PAGADOR'
  pagador.bairro =    'Bairro do pagador'
  pagador.cep =       '89885-000'
  pagador.cidade =    'Chapecó'
  pagador.uf =        'SC'
  pagador.nome_avalista =      'Maria avalista'
  pagador.documento_avalista = '840.106.990-43' # Gerado pelo gerador de CPF
end
```

#### Pagamento
É utilizado apenas para gerar remessas. Cada pagamento representa 1 boleto (por exemplo). Exemplo:

```ruby
pagamento = BrBoleto::Remessa::Pagamento.new({
  nosso_numero:     "123456",
  numero_documento: "977897",
  data_vencimento:  Date.tomorrow,
  valor_documento:  100.12,
  pagador:          { 
    nome:     'João da Silva',
    cpf_cnpj: '33.669.170/0001-12', # Gerado pelo gerador de pdf online
    # ....
  },
  data_emissao:      Date.today, # Valor default
  valor_desconto:    0.0, # Valor default
  valor_iof:         0.0, # Valor default
  valor_abatimento:  0.0, # Valor default
  cod_desconto:      '0', # Valor default
  desconto_2_codigo: '0', # Valor default
  desconto_2_valor:  0.0, # Valor default
  desconto_3_codigo: '0', # Valor default
  desconto_3_valor:  0.0, # Valor default
  codigo_multa:      '3', # Valor default
  codigo_juros:      '3', # Valor default
  valor_multa:       0.0, # Valor default
  valor_juros:       0.0, # Valor default
  parcela:           '1', # Valor default
  tipo_impressao:    '1', # Valor default
  tipo_emissao:      '2', # Valor default
  identificacao_ocorrencia: '01', # Valor default
  especie_titulo:           '01', # Valor default
  codigo_moeda:             '9', # Valor default
  forma_cadastramento:      '0', # Valor default
  emissao_boleto:           '2', # Valor default
  distribuicao_boleto:      '2', # Valor default
})
```

## Sobrescrevendo classes e validações

Você pode usar as próprias classes da gem, porém, **recomendo criar uma subclasse** para os bancos que você gostaria de desenvolver. Com isso também é possível sobrescrever validações e métodos da gem. (*Isso pode ser útil caso precise tratar alguma particularidade*)

##### **Exemplo:**

```ruby
class BoletoSicoob < BrBoleto::Boleto::Sicoob
  def default_values
    {
      local_pagamento:   'PREFERENCIALMENTE NA EMPRESA XXXXX',
      aceite: true
    }
  end
end

boleto = BoletoSicoob.new()
boleto.aceite # true
boleto.local_pagamento # PREFERENCIALMENTE NA EMPRESA XXXXX
```

Você pode também sobrescrever a `class` da conta, mas para isso será necessário sobrescrever um método na `class` do boleto para que funcione adequadamente:
```ruby
class MinhaContaSicoob < BrBoleto::Conta::Sicoob
  # Suas regras aqui
end
class MeuBoletoSicoob < BrBoleto::Boleto::Sicoob
  def conta_class
    MinhaContaSicoob # Sem isso sua conta personalizada não vai funcioanr
  end
end

boleto = MeuBoletoSicoob.new
boleto.conta.class
# => MinhaContaSicoob
```

Você pode sobrescrever os comportamentos na subclasse.
Por exemplo, imagine que você quer sobrescrever a forma como é tratada a segunda parte do código de barras.
**Seguindo a interface da classe BrBoleto::Boleto::Base** fica bem simples:

```ruby
class BoletoSicoob < BrBoleto::Boleto::Sicoob
  def codigo_de_barras_do_banco
   # Sua implementação ...
  end
end
```

### Criando os boletos / Validações

Agora você pode emitir um boleto, **usando a classe criada no exemplo anterior**:

```ruby
BoletoSicoob.new(conta: {agencia: '3195', codigo_cedente: '6532', carteira: '1'}, numero_documento: '1101', valor_documento: 105.78) 
```

Você pode usar blocos se quiser:

```ruby
boleto_sicoob = BoletoSicoob.new do |boleto|
  boleto.conta = {
    agencia:        '0097',
    carteira:       '1',
    modalidade:     '01',
    razao_social:   'Razao Social da Empresa',
    codigo_cedente: '90901',
    endereco:       'Rua nome da rua, 9999',
    cpf_cnpj:       '98137264000196', # Gerado pelo gerador de cnpj
  }
  boleto.pagador do |pag|
    pag.nome     = 'Nome do Sacado'
    pag.cpf_cnpj = '35433793990'
  end
  boleto.numero_documento      = '12345678'
  boleto.data_vencimento       = Date.tomorrow
  boleto.valor_documento       = 31_678.99
end
```

**Cada banco possui suas próprias validações de campo e de tamanho**.
Primeiramente, **antes de renderizar qualquer boleto você precisar verificar se esse o boleto é válido**.

```ruby
if boleto_sicoob.valid?
   # Renderiza o boleto
else
   # Tratar erros
end
```

### Campos do Boleto

Segue abaixo os métodos para serem chamados, no momento de renderizar os boletos. Os campos são de mesmo nome:

```ruby
boleto_sicoob.codigo_banco_formatado # Retorna o código do banco, junto com seu dígito

boleto_sicoob.codigo_de_barras

boleto_sicoob.linha_digitavel

boleto_sicoob.nosso_numero

boleto_sicoob.conta.agencia_codigo_cedente

boleto_sicoob.conta.carteira_formatada # Formata a carteira, para mostrar no boleto.

boleto_sicoob.numero_documento

boleto_sicoob.valor_documento

boleto_sicoob.especie

boleto_sicoob.especie_documento
```

#**Arquivo de remessa**

## **CNAB 240**
Um arquivo de remessa é composto de UM ou VÁRIOS lotes (class BrBoleto::Remessa::Lote).
Estes lotes são compostos de UM ou VÁRIOS pagamentos (class BrBoleto::Remessa::Pagamento).

Por exemplo, você gerou 2 boletos, e precisa criar um arquivo de remessa para os mesmos. Deve ser criado(instanciado) 2 pagamentos(BrBoleto::Remessa::Pagamento) onde deverão ter os dados requeridos do pagamento de cada boleto. (pagamento 1 com dados do boleto 1 e pagamento 2  com os dados do boleto 2).
Com isso, deve-se instanciar um lote passando os dois pagamentos instanciados. Esse lote você adiciona aos lotes da remessa e chama o método `dados_do_arquivo` do objeto de Remessa do banco referente.

Exemplo:
```ruby
boleto_1 = BrBoleto::Boleto::Sicoob.new({
  conta: {
    agencia:          3069,
    codigo_cedente:   6532,
    carteira:         1,
    conta_corrente:   '5679',
    razao_social:     'Cedente 1',
    cpf_cnpj:        '12345678901',
  },
  pagador: {
    nome:     'Sacado',
    cpf_cnpj: '725.275.005-10',
    endereco: 'Rua teste, 23045',
    bairro:   'Centro',
    cep:      '89804-457',
    cidade:   'Chapecó',
    uf:       'SC'
  },
  numero_documento: 10001,
  valor_documento:  100.78,
  data_vencimento:  Date.tomorrow,  
  instrucoes1:      'Lembrar de algo 1',
  instrucoes2:      'Lembrar de algo 2',
  instrucoes3:      'Lembrar de algo 3',
  instrucoes4:      'Lembrar de algo 4',
  instrucoes5:      'Lembrar de algo 5',
  instrucoes6:      'Lembrar de algo 6'
})

boleto_2 = BrBoleto::Boleto::Sicoob.new({
  conta: {
    agencia:          3069,
    codigo_cedente:   6532,
    carteira:         1,
    conta_corrente:   '5679',
    razao_social:     'Cedente 1',
    cpf_cnpj:        '12345678901',
  },
  pagador: {
    nome:     'Sacado 2',
    cpf_cnpj: '725.275.005-10',
    endereco: 'Rua teste, 648',
    bairro:   'Centro',
    cep:      '89804-301',
    cidade:   'Xaxim',
    uf:       'SC'
  },
  valor_documento:  200.78,
  data_vencimento:  Date.tomorrow,
  numero_documento: 10002,
  instrucoes1:      'Lembrar de algo 1',
  instrucoes2:      'Lembrar de algo 2',
  instrucoes3:      'Lembrar de algo 3',
  instrucoes4:      'Lembrar de algo 4',
  instrucoes5:      'Lembrar de algo 5',
  instrucoes6:      'Lembrar de algo 6'
})


pagamento_1 = BrBoleto::Remessa::Pagamento.new({
  nosso_numero:     boleto_1.nosso_numero,
  data_vencimento:  boleto_1.data_vencimento,
  valor_documento:  boleto_1.valor_documento,
  pagador:          boleto_1.pagador
})

pagamento_2 = BrBoleto::Remessa::Pagamento.new({
  nosso_numero:     boleto_2.nosso_numero,
  data_vencimento:  boleto_2.data_vencimento,
  valor_documento:  boleto_2.valor_documento,
  pagador:          boleto_2.pagador
})


lote = BrBoleto::Remessa::Lote.new(pagamentos: [pagamento_1, pagamento_2])

remessa = BrBoleto::Remessa::Cnab240::Sicoob.new({
  conta: {
    agencia:          3069,
    codigo_cedente:   6532,
    carteira:         1,
    conta_corrente:   '5679',
    razao_social:     'Cedente 1',
    cpf_cnpj:        '12345678901',
  },
  lotes: lote,
  sequencial_remessa:  1
})


remessa.dados_do_arquivo
```
Com isso irá gerar uma string com os dados para o arquivo de remessa.
Ele irá ficar no seguinte formato
```
HEADER_ARQUIVO
  HEADER_LOTE
    SEGMENTO_P # Do pagamento 1
    SEGMENTO_Q # Do pagamento 1
    SEGMENTO_R # Do pagamento 1
    SEGMENTO_S # Do pagamento 1
    SEGMENTO_P # Do pagamento 2
    SEGMENTO_Q # Do pagamento 2
    SEGMENTO_R # Do pagamento 2
    SEGMENTO_S # Do pagamento 2
  TRAILER_LOTE
TRAILER_ARQUIVO
```

Está nesse formato pois somente assim consegui homologar junto ao banco.

Mas se você deseja colocar o arquivo no formato:
```
HEADER_ARQUIVO
  HEADER_LOTE # Do pagamento 1
    SEGMENTO_P
    SEGMENTO_Q
    SEGMENTO_R
    SEGMENTO_S
  TRAILER_LOTE
  HEADER_LOTE # Do pagamento 2
    SEGMENTO_P 
    SEGMENTO_Q 
    SEGMENTO_R 
    SEGMENTO_S 
  TRAILER_LOTE
TRAILER_ARQUIVO
```
basta criar um lote para cada pagamento. Exemplo:

```ruby
lotes = []
lotes << BrBoleto::Remessa::Lote.new(pagamentos: pagamento_1)
lotes << BrBoleto::Remessa::Lote.new(pagamentos: pagamento_2)

remessa = BrBoleto::Remessa::Cnab240::Sicoob.new({
  lotes:               lotes,
 conta: {
    agencia:          3069,
    codigo_cedente:   6532,
    carteira:         1,
    conta_corrente:   '5679',
    razao_social:     'Cedente 1',
    cpf_cnpj:        '12345678901',
  },
  sequencial_remessa:  2
})
```
##**CNAB 400**
O CNAB400 é composto por 1 ou vários pagamentos. A diferença de utilização entre o CNAB 240 e o 400 é que no 400 não existe lotes, apenas pagamentos. Exemplo:

```ruby
  
remessa = BrBoleto::Remessa::Cnab400::Sicoob.new do |rem|
  rem.conta = {
    agencia:          3069,
    codigo_cedente:   6532,
    carteira:         1,
    conta_corrente:   '5679',
    razao_social:     'Cedente 1',
    cpf_cnpj:        '12345678901',
  }
  pagamentos = [pagamento1, pagamento2]
  sequencial_remessa = 5
end
```

## Alternativas

Essa biblioteca é baseada em outras **ótimas** bibliotecas.
**Recomendo analisar muito bem cada solução**:

* Brcobranca [https://github.com/kivanio/brcobranca](https://github.com/kivanio/brcobranca)
* Gem de Boleto Bancário [https://github.com/tomas-stefano/boleto_bancario](https://github.com/tomas-stefano/boleto_bancario)

 
## Contribuições

Seja um contribuidor. Você pode contribuir de N formas. Seguem elas:

* Criar boletos para outros bancos.
* Homologando boletos junto ao banco.
* Fornecendo documentações mais atualizadas dos Bancos.
* Escrevendo novos formatos (PDF, PNG), e me avisando para divulgar no Readme.
* Refatorando código!!
* Fornecendo Feedback construtivo! (Sempre bem vindo!)

## Licença

- MIT
- Copyleft 2016 Bruno M. Mergen
