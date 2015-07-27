# BrBoleto

Emissão de Boletos Bancários em Ruby.

## Versão 1.0.0

Por enquanto esta gem apenas faz os cálculos para o banco sicoob.

## Alternativas

Essa biblioteca é baseada em outras **ótimas** bibliotecas.
**Recomendo analisar muito bem cada solução**:

* Stella Caelum [http://stella.caelum.com.br/](http://stella.caelum.com.br/)
* Novo Gateway de Pagamentos da Locaweb [http://www.locaweb.com.br/produtos/gateway-pagamento.html](http://www.locaweb.com.br/produtos/gateway-pagamento.html)
* Brcobranca [https://github.com/kivanio/brcobranca](https://github.com/kivanio/brcobranca)
* Boleto Php [http://boletophp.com.br/](http://boletophp.com.br/)
* Gem de Boleto Bancário [https://github.com/tomas-stefano/boleto_bancario](https://github.com/tomas-stefano/boleto_bancario)

## Instalação
**Manual**

    gem install br_boleto

**Instalação via Gemfile**
    
     gem 'br_boleto'

## Documentação

Seguimos as documentações descritas abaixo:

* [Sicoob](documentacoes_boletos/Sicoob)


## Bancos Suportados

Para todos os bancos e carteiras implementadas, **seguimos as documentações** que estão dentro do repositório:

<table>
  <tr>
    <th>Nome do Banco</th>
    <th>Carteiras Suportadas</th>
    <th>Testada/Homologada no banco</th>
  </tr>
  <tr>
    <td>Sicoob</td>
    <td>1, 3.</td>
    <td>Emm andamento...</td>
  </tr>
</table>

## Usage

Você pode usar as próprias classes da gem, porém, **recomendo criar uma subclasse** para os bancos que você gostaria de desenvolver.

### Exemplo

```ruby
class BoletoSicoob < BrBoleto::Sicoob
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
   # Renderiza o boleto itau
else
   # Trata os erros
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
class BoletoSicoob < BrBoleto::Sicoob
  def codigo_de_barras_do_banco
   # Sua implementação ...
  end
end
```

## Contribuições

Seja um contribuidor. Você pode contribuir de N formas. Seguem elas:

* Homologando boletos junto ao banco.
* Fornecendo documentações mais atualizadas dos Bancos.
* Escrevendo novos formatos (PDF, PNG), e me avisando para divulgar no Readme.
* Refatorando código!!
* Fornecendo Feedback construtivo! (Sempre bem vindo!)
