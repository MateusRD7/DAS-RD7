-- Laboratório: mesma lógica do lab_vulneravel, com as falhas corrigidas.

local conexao
local saldos = {}
local SALDO_INICIAL = 100
local ULTIMA_COMPRA = {}
local INTERVALO_COMPRA = 1000

-- O preço é do servidor. O cliente nunca decide quanto custa.
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

-- Correção 1: os valores vão como parâmetro, nunca como parte da consulta.
addCommandHandler("logar", function(jogador, comando, nome, ...)
    local senha = table.concat({ ... }, " ")

    if not nome or senha == "" then
        outputChatBox("Uso: /logar usuario senha", jogador)
        return
    end

    local resultado = dbPoll(
        dbQuery(conexao, "SELECT * FROM contas WHERE nome = ? AND senha = ?", nome, senha),
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

    if getSaldo(jogador) < PRECOS[item] then
        outputChatBox("Saldo insuficiente.", jogador)
        return
    end

    saldos[getPlayerName(jogador)] = getSaldo(jogador) - PRECOS[item]
    outputChatBox(("Comprou %s por %d. Saldo agora: %d"):format(item, PRECOS[item], getSaldo(jogador)), jogador)
end)

-- Correção 2: quem disparou é o client, não o source (source pode ser forjado).
-- O preço não é lido do evento, vem da tabela do servidor.
-- Tipo validado, saldo conferido e compra com intervalo mínimo.
addEvent("comprarItem", true)
addEventHandler("comprarItem", root, function(item)
    if getElementType(client) ~= "player" then
        return
    end

    if type(item) ~= "string" or not PRECOS[item] then
        outputChatBox("Item inválido.", client)
        return
    end

    local agora = getTickCount()
    if ULTIMA_COMPRA[client] and agora - ULTIMA_COMPRA[client] < INTERVALO_COMPRA then
        outputChatBox("Aguarde um instante antes de comprar de novo.", client)
        return
    end

    if getSaldo(client) < PRECOS[item] then
        outputChatBox("Saldo insuficiente.", client)
        return
    end

    ULTIMA_COMPRA[client] = agora
    saldos[getPlayerName(client)] = getSaldo(client) - PRECOS[item]
    outputChatBox(("Comprou %s por %d. Saldo agora: %d"):format(item, PRECOS[item], getSaldo(client)), client)
end)

addEventHandler("onPlayerQuit", root, function()
    ULTIMA_COMPRA[source] = nil
end)
