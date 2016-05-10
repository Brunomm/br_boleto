# **BrBoleto**

Emissão de Boletos Bancários em Ruby.

[![Code Climate](https://codeclimate.com/github/Brunomm/br_boleto/badges/gpa.svg)](https://codeclimate.com/github/Brunomm/br_boleto)
[![Build Status](https://travis-ci.org/Brunomm/br_boleto.svg?branch=master)](https://travis-ci.org/Brunomm/br_boleto)

## Versão 1.1.0
**O que essa gem faz?**

 1. Boleto bancário (apenas os cálculos para o boleto, sem a interface) para os bancos:
- Sicoob 
- Caixa
 2. Arquivo de remessa para os Bancos:
- Sicoob (CNAB 240)
- Caixa  (CNAB 240)
 3. Arquivo de retorno para os Bancos:
- Sicoob (CNAB 240)
- Caixa  (CNAB 240)

## Alternativas

Essa biblioteca é baseada em outras **ótimas** bibliotecas.
**Recomendo analisar muito bem cada solução**:

* Brcobranca [https://github.com/kivanio/brcobranca](https://github.com/kivanio/brcobranca)
* Gem de Boleto Bancário [https://github.com/tomas-stefano/boleto_bancario](https://github.com/tomas-stefano/boleto_bancario)

## Instalação
**Manualmente**

    gem install br_boleto

**Gemfile**
    
     gem 'br_boleto'

## Documentação

Seguimos as documentações descritas abaixo:

* [Sicoob](documentacoes_boletos/Sicoob)


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
    <td>Pendente</td>
   <td></td>
  </tr>
</table>


----------


**Arquivos de remessa**
<table>
  <tr>
    <th>Nome do Banco</th>
    <th>Testada/Homologada no banco</th>
    <th>Autor </th>
  </tr>
  <tr>
    <td>Sicoob</td>
    <td>Homologado dia 07/08/2015</td>
    <td>Bruno M. Mergen</td>
  </tr>
  <tr>
    <td>Caixa</td>
    <td>Pendente</td>
    <td></td>
  </tr>
</table>

## Como usar

Você pode usar as próprias classes da gem, porém, **recomendo criar uma subclasse** para os bancos que você gostaria de desenvolver.

### Exemplo

```ruby
class BoletoSicoob < BrBoleto::Boleto::Sicoob
end

```

### Criando os boletos / Validações

Agora você pode emitir um boleto, **usando a classe criada no exemplo acima**:

```ruby
BoletoSicoob.new(agencia: '3195', codigo_cedente: '6532', numero_documento: '1101', carteira: '1', valor_documento: 105.78) 
```

Você pode usar blocos se quiser:

```ruby
boleto_sicoob = BoletoSicoob.new do |boleto|
  boleto.agencia               = '0097'
  boleto.carteira              = '1'
  boleto.cedente               = 'Razao Social da Empresa'
  boleto.codigo_cedente        = '90901'
  boleto.endereco_cedente      = 'Rua nome da rua, 9999'
  boleto.numero_documento      = '12345678'
  boleto.sacado                = 'Nome do Sacado'
  boleto.documento_sacado      = '35433793990'
  boleto.data_vencimento       = Date.tomorrow
  boleto.valor_documento       = 31678.99
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

boleto_sicoob.agencia_codigo_cedente

boleto_sicoob.carteira_formatada # Formata a carteira, para mostrar no boleto.

boleto_sicoob.numero_documento

boleto_sicoob.valor_documento

boleto_sicoob.especie

boleto_sicoob.especie_documento
```

## Sobrescrevendo comportamentos

Você pode sobrescrever os comportamentos na subclasse.

Por exemplo, imagine que você quer sobrescrever a forma como é tratada a segunda parte do código de barras.
**Seguindo a interface da classe BrBoleto::Boleto** fica bem simples:

```ruby
class BoletoSicoob < BrBoleto::Boleto::Sicoob
  def codigo_de_barras_do_banco
   # Sua implementação ...
  end
end
```
#**Arquivo de remessa**

##**CNAB 240**
Um arquivo de remessa é composto de UM ou VÁRIOS lotes (class BrBoleto::Remessa::Lote).
Estes lotes são compostos de UM ou VÁRIOS pagamentos (class BrBoleto::Remessa::Pagamento).

Por exemplo, você gerou 2 boletos, e precisa criar um arquivo de remessa para os mesmos. Deve ser criado(instanciado) 2 pagamentos(BrBoleto::Remessa::Pagamento) onde deverão ter os dados requeridos do pagamento de cada boleto. (pagamento 1 com dados do boleto 1 e pagamento 2  com os dados do boleto 2).
Com isso, deve-se instanciar um lote passando os dois pagamentos instanciados. Esse lote você adiciona aos lotes da remessa e chama o método `dados_do_arquivo` do objeto de Remessa do banco referente.

Exemplo:
```ruby
boleto_1 = BrBoleto::Boleto::Sicoob.new({
  agencia:          3069,
  codigo_cedente:   6532,
  numero_documento: 10001,
  carteira:         1,
  valor_documento:  100.78,
  data_vencimento:  Date.tomorrow,
  conta_corrente:   '5679',
  cedente:          'Cedente 1',
  documento_cedente:'12345678901',
  sacado:           'Sacado',
  documento_sacado: '725.275.005-10',
  endereco_sacado:  'Rua teste, 23045',
  instrucoes1:      'Lembrar de algo 1',
  instrucoes2:      'Lembrar de algo 2',
  instrucoes3:      'Lembrar de algo 3',
  instrucoes4:      'Lembrar de algo 4',
  instrucoes5:      'Lembrar de algo 5',
  instrucoes6:      'Lembrar de algo 6'
})

boleto_2 = BrBoleto::Boleto::Sicoob.new({
  agencia:          3069,
  codigo_cedente:   6532,
  numero_documento: 10002,
  carteira:         1,
  valor_documento:  200.78,
  data_vencimento:  Date.tomorrow,
  conta_corrente:   '5679',
  cedente:          'Cedente 2',
  documento_cedente:'12345678901',
  sacado:           'Sacado',
  documento_sacado: '725.275.005-10',
  endereco_sacado:  'Rua teste, 23045',
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
  documento_sacado: boleto_1.documento_sacado,
  nome_sacado:      boleto_1.sacado,
  endereco_sacado:  "R. TESTE DO SACADO",
  cep_sacado:       "89888000",
  cidade_sacado:    "PIRÁPORA",
  uf_sacado:        "SC",
  bairro_sacado:    "Bairro"
})

pagamento_2 = BrBoleto::Remessa::Pagamento.new({
  nosso_numero:     boleto_2.nosso_numero,
  data_vencimento:  boleto_2.data_vencimento,
  valor_documento:  boleto_2.valor_documento,
  documento_sacado: boleto_2.documento_sacado,
  nome_sacado:      boleto_2.sacado,
  endereco_sacado:  "R. TESTE DO SACADO",
  cep_sacado:       "89888000",
  cidade_sacado:    "PIRÁPORA",
  uf_sacado:        "SC",
  bairro_sacado:    "Bairro"
})


lote = BrBoleto::Remessa::Lote.new(pagamentos: [pagamento_1, pagamento_2])

remessa = BrBoleto::Remessa::Cnab240::Sicoob.new({
  lotes:               lote,
  nome_empresa:        "Sacado",
  agencia:             "3069",
  conta_corrente:      "5679", # Sem DV
  digito_conta:        "5",
  carteira:            "1",
  sequencial_remessa:  1,
  documento_cedente:   '12345678901',
  convenio:            '1',
  emissao_boleto:      '2',
  distribuicao_boleto: '2',
  especie_titulo:      '02'
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
  nome_empresa:        "Sacado",
  agencia:             "3069",
  conta_corrente:      "5679", # Sem DV
  digito_conta:        "5",
  carteira:            "1",
  sequencial_remessa:  1,
  documento_cedente:   '12345678901',
  convenio:            '1',
  emissao_boleto:      '2',
  distribuicao_boleto: '2',
  especie_titulo:      '02'
})
```

## Contribuições

Seja um contribuidor. Você pode contribuir de N formas. Seguem elas:

* Criar boletos para outros bancos.
* Homologando boletos junto ao banco.
* Fornecendo documentações mais atualizadas dos Bancos.
* Escrevendo novos formatos (PDF, PNG), e me avisando para divulgar no Readme.
* Refatorando código!!
* Fornecendo Feedback construtivo! (Sempre bem vindo!)

## Licença

- BSD
- Copyleft 2015 Bruno M. Mergen