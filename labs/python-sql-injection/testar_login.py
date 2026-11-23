from app_corrigido import fazer_login as login_corrigido
from app_vulneravel import fazer_login as login_vulneravel

casos = [
    ("aluno", "dio2026", "login válido"),
    ("aluno", "senha_errada", "senha incorreta"),
    ("' OR '1'='1", "' OR '1'='1", "tentativa de SQL Injection"),
]

for usuario, senha, descricao in casos:
    print(f"Caso: {descricao}")
    print(f"  vulnerável: {login_vulneravel(usuario, senha)}")
    print(f"  corrigido : {login_corrigido(usuario, senha)}")
    print()
