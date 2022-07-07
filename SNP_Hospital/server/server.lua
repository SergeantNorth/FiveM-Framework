-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

if (GetCurrentResourceName() ~= "SNP_Hospital") then
    print("[^1DEBUG^0] Please make sure the resource name is ^3SNP_Hospital^0 or else exports won't work.")
end

RegisterNetEvent('SERGEANTNORTH:GETSICKPEOPLE')
AddEventHandler('SERGEANTNORTH:GETSICKPEOPLE', function(src) 
    local allplayers = {}
    local num = 0
    for _, player in ipairs(GetPlayers()) do
        player = tonumber(player)
        local playerdata = exports[Config.framework_name]:getdept(player)
        if(playerdata ~= nil) then
            allplayers[num] = {name = GetPlayerName(player), userid = player, char_name = playerdata[player].char_name}
            num = num + 1
        end
    end
    Citizen.Wait(10)
    TriggerClientEvent('SERGEANTNORTH:OPENDAHOSTLUI', src, allplayers)
end)


RegisterNetEvent("SERGEANTNORTH:HOSPITALUSERCHECK")
AddEventHandler("SERGEANTNORTH:HOSPITALUSERCHECK", function(id, length)
    length = tonumber(length)
    if(length > Config.maxtime or length <= 0) then length = Config.maxtime end
    local src = source
    id = tonumber(id)
    local playerstuff = exports[Config.framework_name]:getdept(id)
    if(playerstuff == nil) then return end

    for _, player in ipairs(GetPlayers()) do
        player = tonumber(player)
        local user = id;
        if(player == id) then
            local name = GetPlayerName(player); 
            TriggerClientEvent("SERGEANTNORTH:GETHOSPITAL", player, id, length)
            TriggerClientEvent('chatMessage', -1, '^1[DOCTOR]^7', { 0, 0, 0 }, " has Hospitalized " .. name .. " for " .. length .. " seconds")
            exports[Config.framework_name]:sendtothediscord(000000, GetPlayerName(src) .. " [#" .. src .. "]", "Has Hospitalized " .. GetPlayerName(id) .. " [#" .. id .. "] for " .. length .. " seconds!")
        end
    end
end)
