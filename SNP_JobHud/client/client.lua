-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

local player = "unknown"

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(3000)
        local id = GetPlayerServerId(PlayerId())
        local data = exports[config.framework_name]:getclientdept(id)
        if(data == nil) then
            player = "unknown"
        else 
            if(data[id]) then
                player = data[id].dept
            else 
                player = "unknown"
            end
        end

    end
end)

Citizen.CreateThread(function() 
    while true do 
        Citizen.Wait(0)
        SetTextFont(4)
        SetTextScale(0.44, 0.44)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(string.format(config.message, player))
        DrawText(config.spot.x, config.spot.y)
    end
end)