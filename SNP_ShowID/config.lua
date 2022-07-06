-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

Config = {}

Config.key = 47 -- change the key here

Config.framework_name = "SNP_Core" -- framework name

-- DO NOT TOUCH BELOW -- 
function Closetplayer()
    local ped = PlayerPedId()
    for _, Player in ipairs(GetActivePlayers()) do
        if GetPlayerPed(Player) ~= GetPlayerPed(-1) then
            local Ped2 = GetPlayerPed(Player)
            local x, y, z = table.unpack(GetEntityCoords(ped))
            if (GetDistanceBetweenCoords(GetEntityCoords(Ped2), x, y, z) <  4) then
                local playerId = GetPlayerServerId(Player);
                return playerId;
            end
        end
    end
    return nil;
end