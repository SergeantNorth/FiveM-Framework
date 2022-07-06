-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

local currentJailed = false
local BoxModel = ""


-- MAIN LOOP FOR UI --
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(0);
        local ped = GetPlayerPed(-1)
        local x,y,z = table.unpack(GetEntityCoords(ped))
        x, y, z = tonumber(x), tonumber(y), tonumber(z)
        for _, station in pairs(Config.police_stations) do
			if GetDistanceBetweenCoords(x, y, z, station.x, station.y, station.z, true) < Config.min_distance then
                local playerid = GetPlayerServerId(PlayerId())
                local clientstuff = exports[Config.framework_name]:getclientdept(playerid)
                if(clientstuff == nil) then 
                    return                    
                else 
                    if(clientstuff[playerid].dept ~= "Civilian") then
                        DisplayNotification('~w~Press the ~r~E~w~ key to access the jail tablet')
                        if IsControlJustReleased(1, Config.tabletkey) then
                            TriggerServerEvent('SERGEANTNORTH:GETJAILPLAYERS', playerid)
                        end
                    end
                end
            end
        end
    end
end)

-- EVENT -- 


-- UI CALLBACKS --
RegisterNUICallback("closeui", function()
    SetNuiFocus(false, false)
    DeleteObject(BoxModel)
    ClearPedTasksImmediately(GetPlayerPed(-1))
    ClearPedTasks(GetPlayerPed(-1))
end)


RegisterNUICallback("jailuser", function(data)
    SetNuiFocus(false, false)
    TriggerServerEvent("SERGEANTNORTH:JAILUSERCHECK", data.id, data.length)
    DeleteObject(BoxModel)
    ClearPedTasksImmediately(GetPlayerPed(-1))
    ClearPedTasks(GetPlayerPed(-1))
end)

-- OPEN Ui -- 
RegisterNetEvent("SERGEANTNORTH:OPENDAJAILUI")
AddEventHandler("SERGEANTNORTH:OPENDAJAILUI", function(playerstuff)
    SendNUIMessage({action = "jail_open", maxtime = Config.maxtime, players = playerstuff})
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

-- JAIL THE USER -- 
RegisterNetEvent("SERGEANTNORTH:GETJAILED")
AddEventHandler("SERGEANTNORTH:GETJAILED", function(id, length)
    local ped = GetPlayerPed(-1)
    local x,y,z = table.unpack(GetEntityCoords(ped))
    x, y, z = tonumber(x), tonumber(y), tonumber(z)
    Citizen.CreateThread(function()
        currentJailed = true
        local ped = GetPlayerPed(-1)
        DoScreenFadeOut(1500)

        Citizen.Wait(500)
        SetEntityCoords(ped, Config.jail.x, Config.jail.y, Config.jail.z)
        Citizen.Wait(1000)
        DoScreenFadeIn(1500)
        while length > 0  do
       
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
        if(currentJailed ~= false) then
            TriggerEvent('chatMessage', "[^2JUDGE^0] You have been released from prison!")
            SetEntityCoords(ped, Config.unjail.x, Config.unjail.y, Config.unjail.z)
            SetEntityHeading(ped, Config.unjail.h)
            currentJailed = false
            SetEntityInvincible(ped, false)
        end
       
    end)
end)

RegisterNetEvent("SERGEANTNORTH:UNJAILAALL")
AddEventHandler("SERGEANTNORTH:UNJAILAALL", function(id, name) 
    if(currentJailed == true) then
        local ped = GetPlayerPed(-1)
        SetEntityCoords(ped, Config.unjail.x, Config.unjail.y, Config.unjail.z)
        SetEntityHeading(ped, Config.unjail.h)
        currentJailed = false
        SetEntityInvincible(ped, false)
        TriggerEvent('chatMessage', "[^2JUDGE^0] You have been unjailed by " .. name .. " [#" .. id .. "]")
    end
end)


RegisterNetEvent('SERGEANTNORTH:JAILCHECK')
AddEventHandler('SERGEANTNORTH:JAILCHECK', function(playerid) 
    local myserverid = GetPlayerServerId(PlayerId())
    if(currentJailed == true) then
        local ped = GetPlayerPed(-1)
        SetEntityCoords(ped, Config.unjail.x, Config.unjail.y, Config.unjail.z)
        SetEntityHeading(ped, Config.unjail.h)
        currentJailed = false
        SetEntityInvincible(ped, false)
        TriggerServerEvent('SERGEANTNORTH:JAILRETURNCHECK', myserverid, playerid, true)
    else 
        TriggerServerEvent('SERGEANTNORTH:JAILRETURNCHECK', myserverid, playerid, false)
    end
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