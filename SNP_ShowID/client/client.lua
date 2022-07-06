-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

-- DO NOT TOUCH
local open = false

RegisterNetEvent('SERGEANTNORTH:OPENIDUI')
AddEventHandler('SERGEANTNORTH:OPENIDUI', function(id, name, gender, dob, txd)
	local myID = PlayerId()
  local pID = GetPlayerFromServerId(id)
  if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myID)), GetEntityCoords(GetPlayerPed(pID)), true) < 10 then
    open = true
    SendNUIMessage({action = "id_open",name = name, gender = gender, dob = dob})
    -- Citizen.CreateThread(function() 
    --   while true and open do
    --     Citizen.Wait(0)
    --     DrawSprite(txd, txd, 0.7742, 0.297, 0.0685, 0.150, 0.0, 255, 255, 255, 1000)
    --   end
    -- end)
	end
end)

-- coming soon --
-- RegisterNetEvent('SERGEANTNORTH:MAKETHEMUGSHOT')
-- AddEventHandler('SERGEANTNORTH:MAKETHEMUGSHOT', function(id, name, gender, dob) 
--   local handle = RegisterPedheadshot(PlayerPedId())
--   while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
--     Citizen.Wait(100)
--   end
--   Citizen.Wait(100)
--   local headshot = GetPedheadshotTxdString(handle)
--   TriggerServerEvent('SERGEANTNORTH:MUGSHOTCREATED', id, name, gender, dob, headshot)
--   Citizen.Wait(2000)
--   UnregisterPedheadshot(handle)
-- end)


RegisterCommand("showid", function(source, args)
  local id = args[1]
  if(args[1] == nil or tonumber(args[1]) == nil) then
    id = Closetplayer()
  else 
    id = args[1]
  end
  Citizen.Wait(20)
  if(id == nil) then
    TriggerEvent('chatMessage', "[^1SYSTEM^0] There are no players around you. Or you haven't inputed a valid player id.")
  else 
    TriggerServerEvent("SERGEANTNORTH:SENTID", id)
    local ped = GetPlayerPed(-1);
    local emoteToPlay = args[1]
    if GetVehiclePedIsIn(ped, false) ~= 0 then return end; -- wont play emotes in any vehicle
    startEmote(emotes["keyfob"])
    local Box = GetHashKey('prop_ld_wallet_01')
    RequestModel(Box)
    coords = GetEntityCoords(GetPlayerPed(-1))
    local bone = GetPedBoneIndex(PlayerPedId(), 28422)
    while not HasModelLoaded(Box) do
      Citizen.Wait(0)
    end
    BoxModel = CreateObject(Box, coords.x, coords.y, coords.z, true, true, false)
    AttachEntityToEntity(BoxModel, PlayerPedId(), bone, 0.0, 0.05, 0.0, 90.0, 270.0, 90.0, 0.0, false, false, false, true, 2, true)
    Citizen.Wait(1000);
    DeleteObject(BoxModel)
  end
end)

-- DO NOT TOUCH --
Citizen.CreateThread(function()
	while true do
    Citizen.Wait(0)
		if IsControlJustReleased(1, Config.key) and open then
			SendNUIMessage({action = "id_close"})
			open = false
		end
	end
end)

-- EMOTE FUNCTION THANKS TO DPEMOTES -- 
function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
      RequestAnimDict(dict)
      Citizen.Wait(10)
    end
  end


function startEmote(anim)
    ChosenDict,ChosenAnimation,ename = table.unpack(emotes["keyfob"])
    LoadAnim(ChosenDict)
    Citizen.Wait(500)
    TaskPlayAnim(GetPlayerPed(-1), ChosenDict, ChosenAnimation, 2.0, 2.0, 1000, 1, 0, false, false, false)
    RemoveAnimDict(ChosenDict)
end


Citizen.CreateThread(function()
  TriggerEvent('chat:addSuggestion', '/showid', 'Displays your characters ID to another player', {
    { name="Player ID", help="Anonymous Message."}
  })
end)