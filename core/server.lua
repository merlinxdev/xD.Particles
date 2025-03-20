ESX = exports["es_extended"]:getSharedObject()
local ResourceName = GetCurrentResourceName()
local RegEvent , TriggerClient = RegisterServerEvent , TriggerClientEvent


RegEvent("T")
RegisterCommand(Config["Command"], function(source, args, showError)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if Config["Permission"][xPlayer.getGroup()] then
        TriggerClient(ResourceName..":UI:Toggle",xPlayer.source)
    end
end)

