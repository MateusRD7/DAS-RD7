import sqlite3

conexao = sqlite3.connect("banco_de_dados.db")
conexao.execute(
    """
    CREATE TABLE IF NOT EXISTS usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
    )
    """
)
conexao.execute("DELETE FROM usuarios")
conexao.execute(
    "INSERT INTO usuarios (username, password) VALUES (?, ?)",
    ("aluno", "dio2026"),
)
conexao.commit()
conexao.close()

print("Banco criado. Usuário de teste: aluno / dio2026")
