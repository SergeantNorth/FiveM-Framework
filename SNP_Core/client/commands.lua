-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

RegisterCommand("changecharacter", function(source, args)
    DoScreenFadeOut(1500)
    TriggerServerEvent("SERGEANTNORTH:GETCHARCTERS")
end)
  
RegisterCommand("framework", function(source, args)
    DoScreenFadeOut(1500)
    TriggerServerEvent("SERGEANTNORTH:GETCHARCTERS")
end)
  

-- CART RELOAD THANKS TO FAXES --
if(Config.tasercarts == true) then
    local maxtaser = Config.maxtasercarts;
    Citizen.CreateThread(function()
        while true do
          Citizen.Wait(5)
          local ped = GetPlayerPed(-1)
          local taserModel = GetHashKey("WEAPON_STUNGUN")
          if GetSelectedPedWeapon(ped) == taserModel then
              if IsPedShooting(ped) then
                maxtaser = maxtaser - 1
              end
          end
          if maxtaser <= 0 then
              if GetSelectedPedWeapon(ped) == taserModel then
                SetPlayerCanDoDriveBy(ped, false)
                DisablePlayerFiring(ped, true)
                if IsControlPressed(0, 106) then
                    ShowInfo("~y~You have no taser cartridges left. please use /reload or /rc")
                end
              end
          end
        end
    end)

    RegisterCommand("reload", function(source, args, rawCommand)
        maxtaser = Config.maxtasercarts;
        ShowInfo("~g~Taser Cartridges Refilled.")
    end)

    RegisterCommand("rc", function(source, args, rawCommand)
        maxtaser = Config.maxtasercarts;
        ShowInfo("~g~Taser Cartridges Refilled.")
    end)
end


if(Config.clearweapons_command == true) then
    RegisterCommand('clear', function(source, args) 
        RemoveAllPedWeapons(PlayerPedId(), true)
        ShowInfo("~g~successfully cleared your weapons")
    end)
end

-- TP COMMAND -- 
if(Config.enable_tp_command  == true) then
    RegisterNetEvent('SERGEANTNORTH:TPADMINTOSOMEONE')
    AddEventHandler('SERGEANTNORTH:TPADMINTOSOMEONE', function(quickfix, loc) 
      local x, y, z = table.unpack(loc)
      SetEntityCoords(PlayerPedId(), x, y, z)
      TriggerEvent('chatMessage', "[^2STAFF^0] You have teleported to " .. quickfix)
    end)
end