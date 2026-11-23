-- Cliente de teste: continua mandando o preço, como um cliente modificado faria.
-- No resource corrigido, o servidor ignora esse valor.

addCommandHandler("comprarhack", function(comando, item, preco)
    if not item or not preco then
        outputChatBox("Uso: /comprarhack item preco")
        return
    end

    triggerServerEvent("comprarItem", localPlayer, item, tonumber(preco))
end)
