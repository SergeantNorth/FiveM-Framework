-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

local curhospital = false
local unhospital = false
local BoxModel = ""
-- MAIN LOOP FOR UI --
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(0);
        local ped = GetPlayerPed(-1)
        local x,y,z = table.unpack(GetEntityCoords(ped))
        x, y, z = tonumber(x), tonumber(y), tonumber(z)
        for _, station in pairs(Config.hospitals) do
            if GetDistanceBetweenCoords(x, y, z, station.x, station.y, station.z, true) < Config.min_distance then
                local playerid = GetPlayerServerId(PlayerId())
                local clientstuff = exports[Config.framework_name]:getclientdept(playerid)
                if(clientstuff == nil) then 
                    return                    
                else 
                    if(clientstuff[playerid].dept ~= "Civilian") then
                        DisplayNotification('~w~Press the ~r~E~w~ key to access the hospitalize tablet')
                        if IsControlJustReleased(1, Config.tabletkey) then
                            TriggerServerEvent('SERGEANTNORTH:GETSICKPEOPLE', playerid)
                        end
                    end
                end
            end
        end
    end
end)


-- UI CALLBACKS --
RegisterNUICallback("closedaui", function()
    SetNuiFocus(false, false)
    DeleteObject(BoxModel)
    ClearPedTasksImmediately(GetPlayerPed(-1))
    ClearPedTasks(GetPlayerPed(-1))
end)


RegisterNUICallback("hospuser", function(data)
    SetNuiFocus(false, false)
    TriggerServerEvent("SERGEANTNORTH:HOSPITALUSERCHECK", data.id, data.length)
    DeleteObject(BoxModel)
    ClearPedTasksImmediately(GetPlayerPed(-1))
    ClearPedTasks(GetPlayerPed(-1))
end)


-- OPEN Ui -- 
RegisterNetEvent("SERGEANTNORTH:OPENDAHOSTLUI")
AddEventHandler("SERGEANTNORTH:OPENDAHOSTLUI", function(playerstuff)

    SendNUIMessage({action = "hosp_open", players = playerstuff})
    SetNuiFocus(true, true)
   
    startEmote(emotes["tablet2"])
    local Box = GetHashKey('prop_cs_tablet')
    RequestModel(Box)
    coords = GetEntityCoords(GetPlayerPed(-1))
    local bone = GetPedBoneIndex(PlayerPedId(), 28422)
    while not HasModelLoaded(Box) do
      Citizen.Wait(0)
    end
    BoxModel = CreateObject(Box, coords.x, coords.y, coords.z, true, true, false)
    AttachEntityToEntity(BoxModel, PlayerPedId(), bone, -0.05, 0.05, 0.0, 20.0,  -90.0, 0.0, 0.0, false, false, false, true, 2, true)
 
end)


RegisterNetEvent("SERGEANTNORTH:GETHOSPITAL")
AddEventHandler("SERGEANTNORTH:GETHOSPITAL", function(id, length)
    Citizen.CreateThread(function()
        curhospital = true
        local ped = GetPlayerPed(-1)
        Citizen.Wait(100)
        SetEntityCoords(ped, Config.hospital.x, Config.hospital.y, Config.hospital.z)
        while length > 0 and not unhospital do
            RemoveAllPedWeapons(ped, true)
            SetEntityInvincible(ped, true)
            if IsPedInAnyVehicle(ped, false) then
                ClearPedTasksImmediately(ped)
            end
            if length % 30 == 0 then
                TriggerEvent('chatMessage', 'SYSTEM', { 0, 0, 0 }, length .." more seconds until release.")
            end
            Citizen.Wait(500)
            length = length - 0.5;
        end
        SetEntityCoords(ped, Config.unhospital.x, Config.unhospital.y, Config.unhospital.z)
        SetEntityHeading(ped, Config.unhospital.h)
        curhospital = false
        SetEntityInvincible(ped, false)
    end)
 
end)


-- FUNCTION FOR DISPLAYING -- 
function DisplayNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


-- EMOTE FUNCTION THANKS TO DPEMOTES -- 
function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
      RequestAnimDict(dict)
      Wait(10)
    end
  end


function startEmote(anim)
    ChosenDict,ChosenAnimation,ename = table.unpack(emotes["tablet2"])
    LoadAnim(ChosenDict)
    MovementType = 50
    AnimationDuration = -1
    AttachWait = 0
    Wait(AttachWait)
    TaskPlayAnim(GetPlayerPed(-1), ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 1, false, false, false)
    RemoveAnimDict(ChosenDict)
end