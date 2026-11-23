-- Cliente de teste do laboratório: simula um cliente modificado,
-- que escolhe o preço do item em vez de aceitar o preço do servidor.

addCommandHandler("comprarhack", function(comando, item, preco)
    if not item or not preco then
        outputChatBox("Uso: /comprarhack item preco")
        return
    end

    triggerServerEvent("comprarItem", localPlayer, item, tonumber(preco))
end)
