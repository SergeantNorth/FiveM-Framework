-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

RegisterNetEvent('SERGEANTNORTH:OPENDMV')
AddEventHandler('SERGEANTNORTH:OPENDMV', function(nui, vec, username, stat) 
    if(stat) then
        SendNUIMessage({
            action = "refresh_vehicles", 
            vehicles = vec,
            name = config.name,
            us = username,
        })
    else
        SendNUIMessage({
            action = nui, 
            name = config.name,
            vehicles = vec,
            us = username,
        })
    end
    
    SetNuiFocus(true, true)
end)


RegisterNUICallback('close', function() 
    SetNuiFocus(false, false)
end)

RegisterNUICallback('registerCur', function() 
    SetNuiFocus(false, false)
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped, false)
    if(vehicle == 0) then  
        TriggerEvent('chatMessage', '[^3SYSTEM^0] You are not in a vehicle. Registration cancelled.') 
        TriggerEvent('SERGEANTNORTH:OPENDMV', "closeui", "N", "A", false)
    else 
        local plate = GetVehicleNumberPlateText(vehicle)
        local primary, secondary = GetVehicleColours(vehicle)
        local class = GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false))
        local model = GetEntityModel(vehicle)
        local displaytext = GetDisplayNameFromVehicleModel(model)
        primary = config.colorNames[tostring(primary)] 
        class = config.vehicle_classes[tostring(class)]
        TriggerServerEvent('SERGEANTNORTH:CREATEVEHCILE', primary, plate, class, displaytext)
    end
end)

RegisterNUICallback('createyourown', function(data)
    TriggerServerEvent('SERGEANTNORTH:CREATEVEHCILE', data.color, data.plate, data.type, data.type)

end)

RegisterNUICallback('delete', function(data) 
    local carid = data.carid;
    local plate = data.plate
    TriggerServerEvent('SERGEANTNORTH:DELETEVEHICLE', carid, plate)
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/' .. config.command, 'Vehicle Registration UI', {
        { name="None", help="DMV System"}
      })
end)
