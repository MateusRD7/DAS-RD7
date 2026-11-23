import sqlite3


def fazer_login(usuario, senha):
    conexao = sqlite3.connect("banco_de_dados.db")
    try:
        resultado = conexao.execute(
            "SELECT 1 FROM usuarios WHERE username = ? AND password = ? LIMIT 1",
            (usuario, senha),
        ).fetchone()
    finally:
        conexao.close()

    if resultado:
        return "Acesso Permitido!"
    return "Acesso Negado."


# O que esta versão resolve:
# - SQL Injection (CWE-89): os valores entram como parâmetros, nunca como
#   parte do texto da consulta.
#
# O que ela ainda NÃO resolve:
# - A senha continua sendo comparada em texto puro (CWE-916). O próximo
#   passo seria guardar um hash com salt e comparar o hash.
