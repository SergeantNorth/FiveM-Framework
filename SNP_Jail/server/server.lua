-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

if (GetCurrentResourceName() ~= "SNP_Jail") then
    print("[^1DEBUG^0] Please make sure the resource name is ^3SNP_Jail^0 or else exports won't work.")
end

RegisterNetEvent('SERGEANTNORTH:GETJAILPLAYERS')
AddEventHandler('SERGEANTNORTH:GETJAILPLAYERS', function(src) 
    local allplayers = {}
    local num = 0
    for _, player in ipairs(GetPlayers()) do
        player = tonumber(player)
        local playerdata = exports[Config.framework_name]:getdept(player)
        if(playerdata ~= nil and playerdata[player].level == "civ_level" and player ~= src) then
            allplayers[num] = {name = GetPlayerName(player), userid = player, char_name = playerdata[player].char_name}
            num = num + 1
        end
    end
    Wait(10)
    TriggerClientEvent('SERGEANTNORTH:OPENDAJAILUI', src, allplayers)
end)


RegisterNetEvent("SERGEANTNORTH:JAILUSERCHECK")
AddEventHandler("SERGEANTNORTH:JAILUSERCHECK", function(id, length)
    length = tonumber(length)
    if(length > Config.maxtime) then length = Config.maxtime end
    local src = source
    id = tonumber(id)
    local playerstuff = exports[Config.framework_name]:getdept(id)
    if(playerstuff == nil) then return end
    if(playerstuff[id].dept == "Civilian") then
        for _, player in ipairs(GetPlayers()) do
            player = tonumber(player)
            local user = id;
            if(player == id) then
                local name = GetPlayerName(player); 
                TriggerClientEvent("SERGEANTNORTH:GETJAILED", player, id, length)
                TriggerClientEvent('chatMessage', -1, '^1[JUDGE]^7', { 0, 0, 0 }, " has Jailed " .. name .. " for " .. length .. " seconds")
                exports[Config.framework_name]:sendtothediscord(000000, GetPlayerName(src) .. " [#" .. src .. "]", "Has jailed " .. GetPlayerName(id) .. " [#" .. id .. "] for " .. length .. " seconds!")
            end
        end
    end
end)

RegisterCommand("unjail", function(source, args, message) 
    local src = source
    local player = exports[Config.framework_name]:getdept(src)
    if(player == nil or player[src].level ~= "admin_level") then
        TriggerClientEvent('chatMessage', src, "^1 Access Denied")
    else 
        local playertocheck = args[1]
        if(playertocheck == nil or tonumber(playertocheck) == nil) then
            TriggerClientEvent('chatMessage', src, "[^2JUDGE^0] Please ensure to input a valid players id.")
        else 
            if(GetPlayerName(src) == nil) then
                TriggerClientEvent('chatMessage', src, "[^2JUDGE^0] Please ensure to input a valid players id.")
            else 
                TriggerClientEvent('SERGEANTNORTH:JAILCHECK', playertocheck, src)
            end
        end
    end
end)

RegisterNetEvent('SERGEANTNORTH:JAILRETURNCHECK')
AddEventHandler('SERGEANTNORTH:JAILRETURNCHECK', function(id, org, dead) 
    if(dead == true) then
       TriggerClientEvent('chatMessage', id, "[^2JUDGE^0] You have been unjailed by " .. GetPlayerName(org) .. " [#" .. org .. "]")
        TriggerClientEvent('chatMessage', org, "[^2JUDGE^0] I have successfully unjailed " .. GetPlayerName(id) .. " [#" .. id .. "].")
        exports[Config.framework_name]:sendtothediscord(000000, GetPlayerName(org) .. " [#" .. org .. "]", "Has unjailed " .. GetPlayerName(id) .. " [#" .. id .. "]")
    else 
        TriggerClientEvent('chatMessage', org, "[^2JUDGE^0] I was not able to unjail " .. GetPlayerName(id) .. " [#" .. id .. "]. Please ensure the players are jailed first!")
    end
end)


RegisterCommand("unjailall", function(source, args, message) 
    local src = source
    local playerstuff = exports[Config.framework_name]:getdept(src)
    if(playerstuff == nil or playerstuff[src].level ~= "admin_level") then
        TriggerClientEvent('chatMessage', src, "^1 Access Denied")
    else 
        for _, player in ipairs(GetPlayers()) do
            player = tonumber(player)
            TriggerClientEvent('chatMessage', src, "[^1ADMIN^0] You have triggerd a mass unjail action.")
            TriggerClientEvent('SERGEANTNORTH:UNJAILAALL', player, src, GetPlayerName(src))
        end
        exports[Config.framework_name]:sendtothediscord(000000, GetPlayerName(src) .. " [#" .. src .. "]", "Has unjailed everyone in the server.")
    end
end)
