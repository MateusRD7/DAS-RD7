-- Laboratório: falhas intencionais de segurança. Não use em servidor real.
-- Resource de teste do lab de MTA:SA.

local conexao
local saldos = {}
local SALDO_INICIAL = 100

local PRECOS = { lanche = 50, agua = 20 }

local function getSaldo(jogador)
    local nome = getPlayerName(jogador)
    saldos[nome] = saldos[nome] or SALDO_INICIAL
    return saldos[nome]
end

addEventHandler("onResourceStart", resourceRoot, function()
    conexao = dbConnect("sqlite", "lab.db")
    dbExec(conexao, "CREATE TABLE IF NOT EXISTS contas (nome TEXT, senha TEXT)")
    dbExec(conexao, "DELETE FROM contas")
    dbExec(conexao, "INSERT INTO contas (nome, senha) VALUES ('aluno', 'dio2026')")
end)

-- Falha 1: o texto digitado entra direto na consulta.
addCommandHandler("logar", function(jogador, comando, nome, ...)
    local senha = table.concat({ ... }, " ")

    if not nome or senha == "" then
        outputChatBox("Uso: /logar usuario senha", jogador)
        return
    end

    local resultado = dbPoll(
        dbQuery(conexao, "SELECT * FROM contas WHERE nome = '" .. nome .. "' AND senha = '" .. senha .. "'"),
        -1
    )

    if type(resultado) == "table" and #resultado > 0 then
        outputChatBox("Acesso permitido para " .. nome, jogador)
    else
        outputChatBox("Acesso negado.", jogador)
    end
end)

addCommandHandler("saldo", function(jogador)
    outputChatBox(("Seu saldo: %d"):format(getSaldo(jogador)), jogador)
end)

-- Compra normal: o preço sai da tabela do servidor.
addCommandHandler("comprar", function(jogador, comando, item)
    if not item or not PRECOS[item] then
        outputChatBox("Itens: lanche (50), agua (20)", jogador)
        return
    end

    local saldo = getSaldo(jogador)
    saldos[getPlayerName(jogador)] = saldo - PRECOS[item]
    outputChatBox(("Comprou %s por %d. Saldo agora: %d"):format(item, PRECOS[item], saldos[getPlayerName(jogador)]), jogador)
end)

-- Falha 2: o servidor aceita o preço que o cliente mandou.
addEvent("comprarItem", true)
addEventHandler("comprarItem", root, function(item, preco)
    local saldo = getSaldo(source)
    saldos[getPlayerName(source)] = saldo - preco
    outputChatBox(("Comprou %s por %d. Saldo agora: %d"):format(tostring(item), preco, saldos[getPlayerName(source)]), source)
end)
