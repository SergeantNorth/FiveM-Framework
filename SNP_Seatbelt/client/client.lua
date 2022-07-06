-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

-- MAIN VARS / DO NOT TOUCH -- 
local is_player_in_vehicle = false;
local seatbelt_status = false;
local ui = false;
local speedBuffer = {}
local vol = {}

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)
    local class = GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false))
    if(class == 21 or class == 19 or class == 16 or class == 15 or class == 14 or  class == 13 or class == 8) then 
      SendNUIMessage({displayWindow = 'false'})
      ui = false
      seatbelt_status = false;
      is_player_in_vehicle = false;
    else 
      if vehicle ~= 0 and (is_player_in_vehicle or checkclass(vehicle) and not checkvehicle(vehicle)) then
        is_player_in_vehicle = true
        if ui == false and not IsPlayerDead(PlayerId()) then
          SendNUIMessage({displayWindow = 'true'})
          ui = true
        end
  
        if seatbelt_status then 
          DisableControlAction(0, 75, true)
          DisableControlAction(27, 75, true)
          if IsDisabledControlJustPressed(0, 75) and IsVehicleStopped(vehicle) and seatbelt_status then
            ShowInfo("~w~Seatbelt ~r~unbuckled")
            TriggerServerEvent('SERGEANTNORTH:SERVERPLAY', 'unbuckle', 0.7)
            SendNUIMessage({displayWindow = 'true'})
            ui = true
            seatbelt_status = false;
          end

          if IsDisabledControlJustPressed(0, 75) and not IsVehicleStopped(vehicle) then
            ShowInfo("~w~You must unbuckle your ~g~seatbelt~w~ in order to exit your vehicle.")
          end
        end
      
        speedBuffer[2] = speedBuffer[1]
        speedBuffer[1] = GetEntitySpeed(vehicle)
  
        if not seatbelt_status and speedBuffer[2] ~= nil and GetEntitySpeedVector(vehicle, true).y > 1.0 and speedBuffer[1] > (100.0 / 3.6) and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
          local co = GetEntityCoords(ped)
          local fw = Fwv(ped)
          SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
          SetEntityVelocity(ped, vol[2].x, vol[2].y, vol[2].z)
          Citizen.Wait(1)
          SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
        end
          
        vol[2] = vol[1]
        vol[1] = GetEntityVelocity(vehicle)
      
        if IsDisabledControlJustPressed(0, 75) and IsControlPressed(0, 21) then
          if seatbelt_status then
            TriggerServerEvent('SERGEANTNORTH:SERVERPLAY', 'unbuckle', 0.7)
            ShowInfo("~w~Seatbelt ~r~unbuckled")
            SendNUIMessage({displayWindow = 'false'})
            ui = true 
            seatbelt_status = false
          end
        end

      elseif is_player_in_vehicle then
        is_player_in_vehicle = false
        seatbelt_status = false
        speedBuffer[1], speedBuffer[2] = 0.0, 0.0
        if ui == true and not IsPlayerDead(PlayerId()) then
          SendNUIMessage({displayWindow = 'false'})
          ui = false 
        end
      end
    end
  end
end)


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
    if is_player_in_vehicle then
      local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
      local speed = GetEntitySpeed(Vehicle) * 3.6;
      if speed > 20 then
        ShowWindow = true
      else
        ShowWindow = false
      end
      if IsPlayerDead(PlayerId()) or IsPauseMenuActive() then
        if ui == true then
          SendNUIMessage({displayWindow = 'false'})
        end
      elseif not seatbelt_status and is_player_in_vehicle and not IsPauseMenuActive() and not IsPlayerDead(PlayerId()) then
        if ShowWindow and speed > 5 then
          SendNUIMessage({displayWindow = 'true'})
          DisplayHelpText("~w~Press ~INPUT_890F8836~ to ~y~buckle ~w~your seatbelt.") -- Thanks to Povers (http://tools.povers.fr/hashgenerator/) i can generate the hash for user made keybinds
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
	  Citizen.Wait(1000)
      if not seatbelt_status and is_player_in_vehicle and not IsPauseMenuActive() then
      local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
      local primary, secondary = GetVehicleColours(vehicle)
      local ped = GetPlayerPed(-1)
      local model = GetEntityModel(vehicle)
      local displaytext = GetDisplayNameFromVehicleModel(model)
      local class = GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false))
      local plate = GetVehicleNumberPlateText(vehicle)
      primary = Config.colorNames[tostring(primary)] 
      local speed = GetEntitySpeed(vehicle)
      speed = speed * 2.236936;
      TriggerServerEvent("SERGEANTNORTH:SENDNOT", primary, displaytext, class, plate, speed)
    end
  end
end)


-- EVENTS --

RegisterNetEvent("SERGEANTNORTH:NOTIFY")
AddEventHandler("SERGEANTNORTH:NOTIFY", function(id, primary, displaytext, class, plate, speed)
  local clientid = PlayerId()
  local serverid = GetPlayerFromServerId(id)
  if clientid ~= serverid then
    if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == 18 then 
      if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(clientid)), GetEntityCoords(GetPlayerPed(serverid)), true) < Config.distance then
        if(class == 21 or class == 19 or class == 16 or class == 15 or class == 14 or  class == 13 or class == 8 or class == 18) then 
          return
        else
          if(speed > Config.min_speed) then
            if math.random(1, Config.chance) == 1 then
              if(Config.displayplate == false) then
                ShowInfo("A person in a ~y~" .. primary .. " ~w~vehicle is not wearing their seatbelt.") 
              else 
                ShowInfo("A person in the ~y~" .. primary .. " ~w~vehicle is not wearing their seatbelt. Plate: " .. plate)
              end
            end
          end
        end
      end
    end
  end
end)

RegisterNetEvent('SERGEANTNORTH:PLAYSOUND')
AddEventHandler('SERGEANTNORTH:PLAYSOUND', function(soundFile, soundVolume)
    SendNUIMessage({transactionType = 'playSound', transactionFile     = soundFile, transactionVolume = soundVolume})
end)


RegisterCommand('+seatbelt', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)
    if vehicle ~= 0 and (is_player_in_vehicle and checkclass(vehicle) and not checkvehicle(vehicle)) then
      seatbelt_status = not seatbelt_status 
      if seatbelt_status then
        Citizen.Wait(5)
        TriggerServerEvent('SERGEANTNORTH:SERVERPLAY', 'buckle', 0.7)
        ShowInfo("~w~Seatbelt ~g~buckled")
        SendNUIMessage({displayWindow = 'false'})
        ui = true 
      else 
        Citizen.Wait(5)
        ShowInfo("~w~Seatbelt ~r~unbuckled")
        TriggerServerEvent('SERGEANTNORTH:SERVERPLAY', 'unbuckle', 0.7)
        SendNUIMessage({displayWindow = 'true'})
        ui = true  
      end
    end
end, false)

RegisterCommand('-seatbelt', function() end, false)
RegisterKeyMapping('+seatbelt', 'Vehicle Seatbelt', 'keyboard', Config.defaultKeybind)

-- MIAN FNUCTION  --
function checkvehicle(veh)
	for i = 1, #Config.seatbeltException, 1 do
		if GetEntityModel(veh) == GetHashKey(Config.seatbeltException[i]) then
			return true
		end
	end
	return false
end

function ShowInfo(string)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(string)
  DrawNotification(false, true)
end

function DisplayHelpText(text)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, 0, 0, -1)
end

function checkclass(vehicle)
  return (GetVehicleClass(vehicle) >= 0 and GetVehicleClass(vehicle) <= 7) or (GetVehicleClass(vehicle) >= 9 and  GetVehicleClass(vehicle) <= 12) or (GetVehicleClass(vehicle) >= 17 and GetVehicleClass(vehicle) <= 20)
end	

function Fwv(entity)
  local hr = GetEntityHeading(entity) + 90.0
  if hr < 0.0 then hr = 360.0 + hr end
  hr = hr * 0.0174533
  return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end