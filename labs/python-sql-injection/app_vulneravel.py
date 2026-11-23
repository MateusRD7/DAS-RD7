# ATENÇÃO: código vulnerável de propósito.
# Este arquivo existe só para o laboratório de análise de SQL Injection.
# Não use em sistema real.

import sqlite3


def fazer_login(usuario, senha):
    conexao = sqlite3.connect("banco_de_dados.db")
    cursor = conexao.cursor()

    query = f"SELECT * FROM usuarios WHERE username = '{usuario}' AND password = '{senha}'"

    cursor.execute(query)
    resultado = cursor.fetchone()
    conexao.close()

    if resultado:
        return "Acesso Permitido!"
    else:
        return "Acesso Negado."
