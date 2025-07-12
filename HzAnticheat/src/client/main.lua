RegisterNetEvent("HzAnticheat:ForceSocialClubUpdate", function()
    ForceSocialClubUpdate()
end)

RegisterNetEvent("HzAnticheat:ForceUpdate", function()
    ForceSocialClubUpdate()
    NetworkIsPlayerActive(PlayerId())
    NetworkIsPlayerConnected(PlayerId())
end)

RegisterNetEvent("HzAnticheat:ShowPermaBanCard", function(cardData)
    ForceSocialClubUpdate()
end) 


RegisterNetEvent("checkalive", function ()
    TriggerServerEvent("addalive")
end)

RegisterNetEvent("HzAnticheat:Client:getEncryptionKey", function(key)
end)














