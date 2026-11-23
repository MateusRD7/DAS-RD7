# Laboratório: SQL Injection em Python

Um login em Python com SQLite para mostrar, na prática, o que muda entre uma consulta montada com `f-string` e uma consulta parametrizada.

> Todo o teste roda em máquina própria, com banco local e dados fictícios.

## Arquivos

| Arquivo | O que é |
| --- | --- |
| `app_vulneravel.py` | Versão que monta o SQL juntando usuário e senha direto na string. |
| `app_corrigido.py` | Versão com consulta parametrizada e fechamento da conexão garantido. |
| `criar_banco.py` | Cria o banco de teste com um usuário fictício. |
| `testar_login.py` | Roda os três casos (login válido, senha errada e injeção) nas duas versões. |

## Como reproduzir

```bash
cd labs/python-sql-injection
python criar_banco.py
python testar_login.py
```

## Resultado obtido

```text
Banco criado. Usuário de teste: aluno / dio2026
Caso: login válido
  vulnerável: Acesso Permitido!
  corrigido : Acesso Permitido!

Caso: senha incorreta
  vulnerável: Acesso Negado.
  corrigido : Acesso Negado.

Caso: tentativa de SQL Injection
  vulnerável: Acesso Permitido!
  corrigido : Acesso Negado.
```

Na versão vulnerável, o texto digitado vira parte da consulta: `' OR '1'='1` fecha a string e a condição passa a ser verdadeira. Na versão corrigida, o valor vai como parâmetro e nunca é interpretado como comando.

## O que a análise do agente mostrou

- **Falha:** SQL Injection, CWE-89. Mapeada no MITRE ATT&CK como T1190 quando o login está exposto na internet.
- **Impacto:** contorno de autenticação. Quem não tem conta entra como se tivesse.
- **Correção aplicada:** `?` no lugar dos valores, com a tupla de parâmetros na chamada do `execute`.
- **Próximo passo:** a senha ainda é comparada em texto puro (CWE-916). Guardar um hash com salt e comparar o hash fecha essa parte.
