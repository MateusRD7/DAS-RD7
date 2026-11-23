# Exemplo de análise: login com SQL Injection

Este é o formato que a skill `vulnerability-analysis` deve produzir. O caso é o do `labs/python-sql-injection/app_vulneravel.py`.

## Resumo

A função `fazer_login` monta a consulta SQL juntando o que a pessoa digitou. Isso permite entrar no sistema sem saber a senha.

## Falha e conceito

O banco de dados recebe uma string única, em que o valor digitado virou parte do comando. Quando alguém digita `' OR '1'='1`, a aspa fecha o campo e a condição passa a ser sempre verdadeira.

A falha é `CWE-89` (injeção de SQL). Se esse login estiver publicado na internet, a técnica se encaixa no `T1190` do MITRE ATT&CK: explorar aplicação exposta. O princípio afetado é a confidencialidade, porque dá acesso a dados que não deveriam ser visíveis, e a integridade, porque o atacante pode alterar o que quiser.

## Risco

| Cenário | Impacto | Probabilidade | Severidade |
| --- | --- | --- | --- |
| Rodando local, sem rede, só para estudo | Alto | Baixa | Média |
| Publicado na internet, sem proteção | Alto | Alta | Crítica |

O impacto não muda: quem explora entra como se tivesse conta. O que muda é a probabilidade, e é por isso que a severidade precisa ser justificada pelo cenário, não pela falha isolada.

## Investigação

O que um profissional olharia, nesta ordem:

1. **Como a consulta é montada.** Se o valor entra na string, é injeção. Se entra como parâmetro, não é.
2. **Se o erro do banco aparece para o usuário.** Mensagem de erro detalhada entrega estrutura de tabela.
3. **Qual permissão o usuário do banco tem.** Um usuário só de leitura limita o estrago.
4. **Se existe limite de tentativas.** Sem limite, qualquer falha de login fica mais barata de explorar.

## Correção

A ideia é tirar o valor do texto da consulta. O banco recebe a estrutura pronta e os valores separados:

```python
conexao.execute(
    "SELECT 1 FROM usuarios WHERE username = ? AND password = ? LIMIT 1",
    (usuario, senha),
)
```

Também vale garantir o fechamento da conexão com `try/finally`, que é o que o código corrigido faz.

## Validação

Rode os três casos:

- usuário e senha corretos: acesso permitido;
- usuário correto e senha errada: acesso negado;
- `' OR '1'='1` nos dois campos: acesso negado.

No laboratório, o `testar_login.py` faz isso nas duas versões e mostra a diferença.

## Aprendizado

Corrigir a linha é o começo. O que ficou pendente: a senha continua sendo comparada em texto puro (`CWE-916`). O próximo passo seria guardar um hash com salt e comparar o hash. Uma análise boa aponta isso mesmo quando a falha principal já foi fechada.
