-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

-- DO NOT TOUCH --
local blipActive = false
local activeshooting = false;


-- BLIPS --
local currentBlips = {}

-- DO NOT TOUCH --
local on_duty = {}

-- AOP --
local current_aop = Config.default_aop

-- server id -- 
local myServerId = nil

-- main loop when a player joins! --
Citizen.CreateThread(function()
  if NetworkIsSessionStarted() then
    DoScreenFadeOut(1500)  
    Citizen.Wait(100)
      
      if(myServerId == nil) then
        myServerId = GetPlayerServerId(PlayerId())
      end

      TriggerServerEvent("SERGEANTNORTH:GETCHARCTERS")

      if(Config.enable_priority == true) then
        TriggerServerEvent("SERGEANTNORTH:UPDATEDAPRIORTY")
      end

      if(Config.enable_aop == true) then
        TriggerServerEvent("SERGEANTNORTH:UPDATEDUMBAOP")
      end

      if(Config.enable_peacetime == true) then
        TriggerServerEvent("SERGEANTNORTH:UPDATEDUMBPEACETIME")
      end

      if(Config.enable_door_lock == true) then
        TriggerServerEvent('SERGEANTNORTH:getDoorState')
      end

      if(Config.enable_ai_cop_Weapon == true) then
        ped = GetHashKey("s_m_y_cop_01")
        RequestModel(ped)
        while not HasModelLoaded(ped) do
          Citizen.Wait(0)
        end
        for name, loc in pairs(Config.cop_spots) do
          local pack = table.unpack(loc)
          local coppboy = CreatePed(4, ped, pack.x, pack.y, pack.z, pack.w, false, true)
          GiveWeaponToPed(coppboy, GetHashKey("weapon_carbinerifle"), 300, false)
          SetCurrentPedWeapon(coppboy, GetHashKey("weapon_carbinerifle"), true)
          SetBlockingOfNonTemporaryEvents(coppboy, true)
        end 
      end
  end
end)



RegisterNetEvent("SERGEANTNORTH:UPDATELEOS")
AddEventHandler("SERGEANTNORTH:UPDATELEOS", function(active) 
  on_duty = active;
  sync(on_duty)
end)


-- SHOT SPOTER -- 
if(Config.shotspoter == true) then
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if(on_duty[myServerId]) then
        if(on_duty[myServerId].dept == Config.dept_names['civ_level']) then 
          local ped = GetPlayerPed(-1)
          local pedShooting = IsPedShooting(ped)
          local isBlacklistedWeapon = false
          local x,y,z = table.unpack(GetEntityCoords(ped))
          x, y, z = tonumber(x), tonumber(y), tonumber(z)
      
          for i,v in ipairs(Config.blacklistedweapons) do
            if GetSelectedPedWeapon(ped) == GetHashKey(v) then
              isBlacklistedWeapon = true
            end
          end 
          if pedShooting and not isBlacklistedWeapon then
            local silence = IsPedCurrentWeaponSilenced(ped)
              if(silence == false) then
                if activeshooting == true then return end
                local var1, var2 = GetStreetNameAtCoord(x, y, z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
                hash1 = GetStreetNameFromHashKey(var1); -- thanks to streetlabel
                hash2 = GetStreetNameFromHashKey(var2); -- thanks to streetlabel
                TriggerServerEvent("SERGEANTNORTH:SHOTSPOTER", myServerId, x, y, z, hash1, hash2)
              end
            end
          end
        end
      end 
  end)
  
  RegisterNetEvent("SERGEANTNORTHSENDSHOTSPOTER")
  AddEventHandler("SERGEANTNORTHSENDSHOTSPOTER", function(x, y, z)
      if blipActive == false then
        local blip = AddBlipForRadius(x, y, z, 100.0);
        SetBlipColour(blip, 40)
        SetBlipAlpha(blip, 80)
        SetBlipSprite(blip, 9)
        blipActive = true
        if(blipActive == true) then 
          Citizen.Wait(60000)
          RemoveBlip(blip)
          blipActive =  false;
          activeshooting = false;
        end
      end
  end)
end

 
-- opens the framework --
RegisterNetEvent("SERGEANTNORTH:OPENUI")
AddEventHandler("SERGEANTNORTH:OPENUI", function(user_chars, setti, perms, name)
  if (perms == nil) then
    print("^1[ERROR | MYSQL]^0 SERGEANTNORTH's Framework has been disabled. This is due to SQL connection not being setup correctly. If you are the customer of this script please watch the videos \non how to set up the framework or use client support for support. ^1Made by SERGEANTNORTH^0")
  else 
    freeze()
    SendNUIMessage({
      action = "framework_open",
      chars = user_chars,
      perms = perms,
      max = Config.maxchars,
      resource = name,
      enabledamsg = Config.enabled_message,
      welcomemsg = Config.welcome_message,
      blacklisted_word = Config.blacklisted_word,
      whitelist_word = Config.whitelist_word,
      change_backgrounds = Config.change_backgrounds,
      background_images = Config.background_images,
      server_logo = Config.server_logo,
      aop_status = Config.enable_aop,
      current_aop = current_aop,
      aop_replace = Config.show_aop_on_framework,
      refresh_button = Config.refresh_button,
      disconnect_button = Config.disconnect_button,
      dept_names = Config.dept_names,
      version = Config.version,
      slideshow = Config.background_slideshow,
      slideshow_length = Config.slidwshow_length,
      usersettings = setti,
      darkmod = Config.default_darkmode,
      spawnsize = Config.spawnloc_big
    })
  end
end)


-- this event will refresh the framework when something happens --
RegisterNetEvent("SERGEANTNORTH:RESETUI")
AddEventHandler("SERGEANTNORTH:RESETUI", function(characters)
  SendNUIMessage({
    action = "refresh_ui",
    players = characters
  })
end)


-- NUI callback for deleting a user --
RegisterNUICallback("DeleteCharacter", function(data)
  TriggerServerEvent("SERGEANTNORTH:DELETEUSER", data.char_id)
end)

-- NUI callback for the refresh button --
RegisterNUICallback("Refresh", function(data)
  TriggerServerEvent("SERGEANTNORTH:UIREFRESH", myServerId)
end)

-- NUI callback for nui create character
RegisterNUICallback("CreateCharacter", function(data)
  TriggerServerEvent("SERGEANTNORTH:CREATECHARCTER", data.first_name, data.last_name, data.twt, data.gender, data.dob, data.dept, data)
end)

-- Disconnct button -- 
RegisterNUICallback("Disconnct", function(data)
  TriggerServerEvent("SERGEANTNORTH:DISCONNECTBUTTON")
end)


-- NUI callabacks to edit the player --
RegisterNUICallback("EditeCharacter", function(data) 
  TriggerServerEvent("SERGEANTNORTH:EDITCHARCTER", data.first_name, data.last_name,  data.twt, data.gender, data.dob, data.chid, data.dept, data.old_first, data.old_last)
end)

-- NUI callback play as a player --
RegisterNUICallback("PlayCharacter", function(data, tel)
  DoScreenFadeIn(0)
  local spawns = {x = data.spawn.x, y = data.spawn.y, z = data.spawn.z, h = data.spawn.h}
  freeze()
  unfreeze(data.cloud, data.gender, data.dept, data.telp, spawns)
  Citizen.Wait(1000)
  if(Config.join_msg_as_circle_text == true) then
    TriggerEvent("chat:addMessage", {template = '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgb(144,238,144); border-radius: 3px;"><b>{0}</b></div>', args = {"You are now playing as " .. data.first_name .. " " .. data.last_name .. " (" .. data.dept .. ")"}})
  else 
    TriggerEvent('chat:addMessage', {
      template = '<div id="message"><b> ^7You are now playing as {0} ({1})</div>',
      args = { data.first_name .. " " .. data.last_name, data.dept }
    })
  end
  TriggerServerEvent('SERGEANTNORTH:CHECKSQL', data.steamid, data.discord, data.first_name, data.last_name, data.twt, data.dept, data.dob, data.gender, data)

  if(Config.spawnwithaloadout == true) then
    if(data.level ~= "civ_level") then
      TriggerEvent("SERGEANTNORTH:GIVELOADOUT")
    end
  end
 
end)


-- chat commands  --

-- DO COMMAND --
RegisterNetEvent('SendProximityMessageDo')
AddEventHandler('SendProximityMessageDo', function(id, fix, message)
  local myID = PlayerId()
  local pID = GetPlayerFromServerId(id)
  if pID == myID then
  TriggerEvent('chatMessage', "", {255, 0, 0}, " ^9 ^*[DO] " .. fix .."".."^r (#" .. id .. ")^7: " .. message)
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myID)), GetEntityCoords(GetPlayerPed(pID)), true) < 19.999 then
    local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myID)), GetEntityCoords(GetPlayerPed(pID)), true)
    if(distance > 0.0 and distance < 19.9) then   
      local math = math.ceil(distance)
      TriggerEvent('chatMessage', "", {255, 0, 0}, " ^9 ^*[DO] " .. fix .."".." ^r (#" .. id .. ") (" .. math .."m)^7: " .. message)
    end
  end
end)


-- ME COMMAND --
RegisterNetEvent('SendProximityMessageMe')
AddEventHandler('SendProximityMessageMe', function(id, fix, message)
  local myID = PlayerId()
  local pID = GetPlayerFromServerId(id)
  if pID == myID then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 ^*[ME] " .. fix .."".."^r (#" .. id .. ")^7: " .. message)
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myID)), GetEntityCoords(GetPlayerPed(pID)), true) < 19.999 then
    local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myID)), GetEntityCoords(GetPlayerPed(pID)), true)
    if(distance > 0.0 and distance < 19.9) then    
      local math = math.ceil(distance)
      TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 ^*[ME] " .. fix .."".." ^r (#" .. id .. ") (" .. math .."m)^7: " .. message)
    end
  end
end)

-- MER COMMAND -- 
RegisterNetEvent("SendProximityMessageMer")
AddEventHandler("SendProximityMessageMer", function(id, fix, message) 
  local myID = PlayerId()
  local pID = GetPlayerFromServerId(id)
  if pID == myID then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 ^*[ME] " .. fix .."".."^r (#" .. id .. "):^*^1 " .. message)
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myID)), GetEntityCoords(GetPlayerPed(pID)), true) < 19.999 then
    local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myID)), GetEntityCoords(GetPlayerPed(pID)), true)
    if(distance > 0.0 and distance < 19.9) then    
      local math = math.ceil(distance)
      TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 ^*[ME] " .. fix .."".." ^r (#" .. id .. ") (" .. math .."m):^*^1 " .. message)
    end
  end
end)

-- DOB COMMAND -- 
RegisterNetEvent('SERGEANTNORTH:DOBCOMMAND')
AddEventHandler('SERGEANTNORTH:DOBCOMMAND', function(char_name, dob)
    ShowInfo("~r~" .. char_name .. " ~w~Date of birth: " .. dob)
end)

-- 911 COMMAND --
local showing_911_blip = false
RegisterNetEvent("SERGEANTNORTH:911CALL")
AddEventHandler("SERGEANTNORTH:911CALL", function(id, message, pos) 
  local playerIdx = GetPlayerFromServerId(id)
  local ped = GetPlayerPed(playerIdx)
  local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
  hash1 = GetStreetNameFromHashKey(var1); -- thanks to streetlabel
  hash2 = GetStreetNameFromHashKey(var2); -- thanks to streetlabel
  TriggerEvent('chatMessage', "", {255, 0, 0}, " ^1 ^*[911] We have received a 911 call near " .. hash1 .. " " .. hash2 .. " The caller states:^*^7 " .. message)

  if(showing_911_blip == true) then return end
  showing_911_blip = true
  local blip = AddBlipForRadius(pos.x, pos.y, pos.z, 250.0)
  SetBlipSprite(blip, 161)
  SetBlipColour(blip, 1)
  SetBlipAsShortRange(blip, 0)
  Citizen.Wait(20000)
  RemoveBlip(blip)
  showing_911_blip = false
end)

-- LOADOUT COMMAND -- 
RegisterNetEvent("SERGEANTNORTH:GIVELOADOUT")
AddEventHandler("SERGEANTNORTH:GIVELOADOUT", function() 
  Citizen.Wait(10)
  SetEntityHealth(PlayerPedId(), 200)
  RemoveAllPedWeapons(PlayerPedId(), true)
  AddArmourToPed(PlayerPedId(), 100)
  GiveWeapon('weapon_nightstick')
  GiveWeapon('weapon_flashlight')
  GiveWeapon('weapon_fireextinguisher')
  GiveWeapon('weapon_flare')
  GiveWeapon('weapon_stungun')
  GiveWeapon('weapon_combatpistol')
  GiveWeapon('weapon_carbinerifle')
  GiveWeapon('weapon_pumpshotgun')
  Citizen.Wait(2)
  AddWeaponComponent('weapon_combatpistol', 'component_at_pi_flsh')
  AddWeaponComponent('weapon_carbinerifle', 'component_at_ar_flsh')
  AddWeaponComponent('weapon_carbinerifle', 'component_at_scope_medium')
  AddWeaponComponent('weapon_pumpshotgun', 'component_at_ar_flsh')
  ShowInfo('~g~Loadout Spawned')
end)

-- BLIPS -- 
if(Config.enable_blips == true) then
  local blip_status = false;
  RegisterNetEvent("SERGEANTNORTH:TOGGLELEOBLIP")
  AddEventHandler("SERGEANTNORTH:TOGGLELEOBLIP", function(st) 
    blip_status = st
    if not blip_status then
      RemoveAnyExistingEmergencyBlips()
    end
  end)
  
  RegisterNetEvent("SERGEANTNORTH:UPDATEBLIPS")
  AddEventHandler("SERGEANTNORTH:UPDATEBLIPS", function(activeEmergencyPersonnel)
    if blip_status then
      RemoveAnyExistingEmergencyBlips()
      RefreshBlips(activeEmergencyPersonnel)
    end
  end)
end




-- PRIORITY -- 
if(Config.enable_priority == true) then
  local cooldown = 0
  local priorty_status = false
  local hold_status = false
  local active_player = "";
  local priorty_on = false;
  local inactive_time = 0;
  local show_pri = true
  
  RegisterNetEvent("SERGEANTNORTH:UPDATEPR")
  AddEventHandler("SERGEANTNORTH:UPDATEPR", function(time) 
    inactive_time = time;
  end)

  RegisterNetEvent("SERGEANTNORTH:UPDATEVARSPRI")
  AddEventHandler("SERGEANTNORTH:UPDATEVARSPRI", function(value1, value2, value3, value4, value5) 
    cooldown = value1;
    priorty_status = value2;
    hold_status = value3;
    inactive_time = value4;
    active_player = value5;
  end)

  RegisterNetEvent('SERGEANTNORTH:UPDATECOOLDOWN')
  AddEventHandler('SERGEANTNORTH:UPDATECOOLDOWN', function(length)
      cooldown = length
  end)
  
  RegisterNetEvent('SERGEANTNORTH:UPDATEPRIORTY')
  AddEventHandler('SERGEANTNORTH:UPDATEPRIORTY', function(status, name)
      priorty_status = status
      active_player = name
  end)
  
  RegisterNetEvent('SERGEANTNORTH:HOLDPRIORTY')
  AddEventHandler('SERGEANTNORTH:HOLDPRIORTY', function(newishold)
    hold_status = newishold
  end)
  
  if(Config.disable_view_on_hud_priority == false) then
    Citizen.CreateThread(function() 
      while true do
        Citizen.Wait(0)
        if(on_duty[myServerId]) then
          if(show_pri == true) then
            if(Config.leo_can_see_it == true) then
              if hold_status == true then
                priorty_draw("~w~Priority Status: ~b~Priorities Are On Hold")
              elseif priorty_status == false then
                if(cooldown > 0) then
                  priorty_draw("~w~Priority Status: ~r~Cooldown ~c~(".. cooldown .."m remaining)")
                else 
                  priorty_draw("~w~Priority Status: ~g~Inactive ~c~(".. inactive_time .."m)")
                end
              elseif priorty_status == true then
                priorty_draw("~w~Priority Status: ~g~Priority In Progress ~w~( " .. active_player .. " )")
              end
            else 
              if(on_duty[myServerId].dept == "Civilian") then
                if hold_status == true then
                  priorty_draw("~w~Priority Status: ~b~Priorities Are On Hold")
                elseif priorty_status == false then
                  if(cooldown > 0) then
                    priorty_draw("~w~Priority Status: ~r~Cooldown ~c~(".. cooldown .."m remaining)")
                  else 
                    priorty_draw("~w~Priority Status: ~g~Inactive ~c~(".. inactive_time .."m)")
                  end
                elseif priorty_status == true then
                  priorty_draw("~w~Priority Status: ~g~Priority In Progress ~w~( " .. active_player .. " )")
                end
              end
            end
          end
        end
      end
    end)
  end

  RegisterCommand("phud", function(source, args, message)
    if(show_pri == true) then
      show_pri = false
    else 
      show_pri = true
    end
end)
end


-- AOP -- 
if(Config.enable_aop == true) then
  local show_aop = true

  RegisterNetEvent("SERGEANTNORTH:AOPCHANGE")
  AddEventHandler("SERGEANTNORTH:AOPCHANGE", function(aop)
    current_aop = aop
  end)

  RegisterNetEvent("SERGEANTNORTH:AOPNOT")
  AddEventHandler("SERGEANTNORTH:AOPNOT", function(text)
    DisplayHelpText(text)
  end)

  if(Config.disable_view_on_hud_aop == false) then 
    Citizen.CreateThread(function() 
      while true do 
        Citizen.Wait(0)
        if(show_aop == true) then
          if(on_duty[myServerId]) then
            if(Config.leo_can_view_aop == true) then
              aop_draw("~w~Current AOP:~c~ " .. current_aop)
            else 
              if(on_duty[myServerId].dept == Config.dept_names["civ_level"]) then
                aop_draw("~w~Current AOP:~c~ " .. current_aop)
              end
            end
          end
        end
      end
    end)
  end

  RegisterCommand('aophud', function(source, args, message) 
    if(show_aop == true) then
      show_aop = false
    else 
      show_aop = true
    end
  end)
end

-- PEACTIME -- 
if(Config.enable_peacetime == true) then
  local peacetime = false;
  local show_peacetime = true

  RegisterNetEvent("SERGEANTNORTH:CHANGEPT")
  AddEventHandler("SERGEANTNORTH:CHANGEPT", function(status)
      peacetime = status
  end)

  RegisterNetEvent("SERGEANTNORTH:PEACETIMENOT")
  AddEventHandler("SERGEANTNORTH:PEACETIMENOT", function(text)
    DisplayHelpText(text)
  end)

  -- draw function -- 
  if(Config.disable_view_on_hud_peacetime == false) then
    Citizen.CreateThread(function() 
      while true do 
        Citizen.Wait(0)
        if(show_peacetime == true) then
          if(on_duty[myServerId]) then
            if(Config.leo_can_view_peacetime == true) then
              if(peacetime == true) then
                peacetime_draw('~w~Peacetime: ~r~Enabled')
              else 
                peacetime_draw('~w~Peacetime: ~g~Disabled')
              end
            else 
              if(on_duty[myServerId].dept == "Civilian") then
                if(peacetime == true) then
                  peacetime_draw('~w~Peacetime: ~r~Enabled')
                else 
                  peacetime_draw('~w~Peacetime: ~g~Disabled')
                end
              end
            end
          end
        end
      end
    end)
  end

  RegisterCommand("pthud", function(source, args, message)
      if(show_peacetime == true) then
        show_peacetime = false
      else 
        show_peacetime = true
      end
  end)

  -- main loop for peacetime -- 
  Citizen.CreateThread(function() 
    while true do
      Citizen.Wait(1)
      if(peacetime == true) then
        if (Config.peacetime_affect_leo == true) then
          if IsControlPressed(0, 106) then
            ShowInfo("~r~Peacetime is enabled. ~n~~s~You cannot cause violence.")
          end
          SetPlayerCanDoDriveBy(ped, false)
          DisablePlayerFiring(ped, true)
          DisableControlAction(0, 140)
          DisableControlAction(0, 37)
        else
          if(on_duty[myServerId]) then
            if(on_duty[myServerId].dept == "Civilian") then
              if IsControlPressed(0, 106) then
                ShowInfo("~r~Peacetime is enabled. ~n~~s~You cannot cause violence.")
              end
              SetPlayerCanDoDriveBy(ped, false)
              DisablePlayerFiring(ped, true)
              DisableControlAction(0, 140)
              DisableControlAction(0, 37)
            end
          end
        end
      end
    end
  end)
end

-- PANIC SYSTEM -- 
local alreadyon = false

RegisterNetEvent('SERGEANTNORTH:PANICPRESSED')
AddEventHandler('SERGEANTNORTH:PANICPRESSED', function(area, msg, pos) 
  x, y, z = table.unpack(area)
  local var1, var2 = GetStreetNameAtCoord(tonumber(x), tonumber(y), tonumber(z), Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
  hash1 = GetStreetNameFromHashKey(var1); -- thanks to streetlabel
  hash2 = GetStreetNameFromHashKey(var2); -- thanks to streetlabel
  TriggerEvent('chatMessage', msg .. " has pressed their panic button. There last known location was ^3" .. hash1 .. " " .. hash2 .. " ^0Postal ^3" .. pos)
  paniclength()
end)

function paniclength() 
  if(alreadyon == true) then return end
  alreadyon = true
  Citizen.Wait(20000)
  alreadyon = false
end



-- DOOR LOCK HUGE SHOUTOUT TO BADGER FOR THIS SCRIPT. I EDITED THE PERMS TO WORK WITH THE FRAMEWORK-- 

if(Config.enable_door_lock == true) then
  RegisterNetEvent('SERGEANTNORTH:returnDoorState')
  AddEventHandler('SERGEANTNORTH:returnDoorState', function(states) 
    Config_doors.DoorList = states
  end)
  
  RegisterNetEvent('SERGEANTNORTH:setDoorState')
  AddEventHandler('SERGEANTNORTH:setDoorState', function(index, state) 
    Config_doors.DoorList[index].locked = state
  end)

  
  Citizen.CreateThread(function()
    while true do
      local coords = GetEntityCoords(PlayerPedId())
      for k,v in ipairs(Config_doors.DoorList) do
        if v.doors then
          for k2,v2 in ipairs(v.doors) do
            if v2.object and DoesEntityExist(v2.object) then
              if k2 == 1 then
                v.distanceToPlayer = #(coords - GetEntityCoords(v2.object))
              end
  
              if v.locked and v2.objHeading and round(GetEntityHeading(v2.object)) ~= v2.objHeading then
                SetEntityHeading(v2.object, v2.objHeading)
              end
            else
              v.distanceToPlayer = nil
              v2.object = GetClosestObjectOfType(v2.objCoords, 1.0, v2.objHash, false, false, false)
            end
          end
        else
          if v.object and DoesEntityExist(v.object) then
            v.distanceToPlayer = #(coords - GetEntityCoords(v.object))
  
            if v.locked and v.objHeading and round(GetEntityHeading(v.object)) ~= v.objHeading then
              SetEntityHeading(v.object, v.objHeading)
            end
          else
            v.distanceToPlayer = nil
            v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash, false, false, false)
          end
        end
      end
  
      Citizen.Wait(500)
    end
  end)
  
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      for k,v in ipairs(Config_doors.DoorList) do
        if v.distanceToPlayer and v.distanceToPlayer < 50 then
          if v.doors then
            for k2,v2 in ipairs(v.doors) do
              FreezeEntityPosition(v2.object, v.locked)
            end
          else
            FreezeEntityPosition(v.object, v.locked)
          end
        end
        if v.distanceToPlayer and v.distanceToPlayer < v.maxDistance then
          if v.locked == false then
            displayText = Config.door_unlocked
          end
          if v.locked == true then 
            displayText = Config.door_lock
          end
          local x, y, z = table.unpack(v.textCoords);
          local check = clientcheckperms(v.authorizedRoles, myServerId)
          if(check == true) then
            Draw3DText(x, y, z - 2, displayText, 0.1, 0.1);
          end
  
          if(on_duty[myServerId]) then
            if(on_duty[myServerId].dept ~= Config.dept_names['civ_level']) then
              if IsControlJustReleased(0, 38) then
                TriggerServerEvent('SERGEANTNORTH:CheckPermsDoor', k, not v.locked);
                loadAnimDict("anim@heists@keycard@") 
                TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
                Citizen.Wait(400)
                ClearPedTasks(PlayerPedId())
            end
            end
          end
        
        end
      end
    end
  end)
end

-- DEATH SCRIPT -- 
if(Config.enable_death_system == true) then
  local dead = false
  local timer = Config.death_timer
  local can_revive = false


  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      local ped = GetPlayerPed(-1)
      if IsEntityDead(ped) then
        local playerPos = GetEntityCoords(ped, true)
        NetworkResurrectLocalPlayer(playerPos, true, true, false)
        SetPlayerInvincible(ped, false)
        ClearPedBloodDamage(ped)
        SetEntityHealth(ped, 200) 
        SetEnableHandcuffs(PlayerPedId(-1), true)
        loadAnimDict("dead")
        TaskPlayAnim(PlayerPedId(-1), "dead", "dead_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
        dead = true
      end
      if(dead == true and Config.enable_death_timer == true and can_revive == false) then
        DisplayHelpText("Please wait " .. timer .. " seconds in order to revive or respawn.")
      elseif (dead == true and can_revive == true and Config.enable_death_timer == true) then
        DisplayHelpText("Click ~INPUT_CONTEXT~ to revive or ~INPUT_RELOAD~ to respawn.")
      elseif(dead == true and Config.enable_death_timer == false) then
        DisplayHelpText("Click ~INPUT_CONTEXT~ to revive or ~INPUT_RELOAD~ to respawn.")
      end
    end
  end)

  
  Citizen.CreateThread(function() 
    while true do
      Citizen.Wait(0)
      if (dead == true) then
        if(Config.enable_death_timer ~= true) then
          can_revive = true
        end
        if(can_revive == true) then
          if IsControlJustReleased(0, Config.death_key) and GetLastInputMethod(0) then
            Fixplayer(false, PlayerPedId())
            dead = false
            can_revive = false
            timer = Config.death_timer
          elseif IsControlJustReleased(0, Config.respawn_key) and GetLastInputMethod(0) then
            Fixplayer(true, PlayerPedId())
            dead = false
            can_revive = false
            timer = Config.death_timer
          end
        end
      end
    end
  end)


  if(Config.enable_death_timer == true) then
    Citizen.CreateThread(function() 
      while true do
        Citizen.Wait(0)
        if (dead == true and can_revive ~= true) then
          if(timer <= 0) then
            can_revive = true
          else 
            timer = timer - 1
            Citizen.Wait(1000)
          end
        end
      end
    end)
  end
  
  RegisterNetEvent('SERGEANTNORTH:REVIVEALLUSERS')
  AddEventHandler('SERGEANTNORTH:REVIVEALLUSERS', function() 
    if(dead == true) then
      Fixplayer(false, PlayerPedId())
      dead = false
      can_revive = false
      timer = Config.death_timer
      TriggerEvent('chatMessage', '[^1SYSTEM^0] You have been revived by an admin.')
    end
  end)
end


-- AI COP -- 
if(Config.enable_ai_cop_Weapon == true) then
  _MenuPool = NativeUI.CreatePool()
  MainMenu = NativeUI.CreateMenu()
  local menu_status = false

  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      _MenuPool:ProcessMenus()	
      _MenuPool:ControlDisablingEnabled(false)
      _MenuPool:MouseControlsEnabled(false)
      if(on_duty[myServerId]) then
        if(on_duty[myServerId].dept ~= Config.dept_names['civ_level']) then 
          local coords = GetEntityCoords(PlayerPedId())
          for name, loc in pairs(Config.cop_spots) do
            local pack = table.unpack(loc)
            pack = vector3(pack.x, pack.y, pack.z)
            local distance = #(coords - pack)
            if(distance <= Config.default_cop_length) then
              DisplayHelpText("Click ~INPUT_CONTEXT~ to access the weapon menu.")
              local pausemenu = IsPauseMenuActive()
              if(pausemenu) then
                menu_status = false
                _MenuPool:CloseAllMenus()
              end
              if IsControlJustReleased(0, Config.default_keybind_to_open_menu) then
                if not menu_status then
                  menu_status = true
                  open_menu(on_duty[myServerId].dept)
                  MainMenu:Visible(true)
                else 
                  menu_status = false
                  _MenuPool:CloseAllMenus()
                end
              elseif IsControlJustReleased(0, 177) and menu_status == true then
                menu_status = false
              end
            else 
              menu_status = false
              _MenuPool:CloseAllMenus()
            end
          end
        end
      end
    end
  end)
end



-- MAIN FRAMEWORK FUNCTIONS -- 


-- BLIPS -- 
function RemoveAnyExistingEmergencyBlips()
  for i = #currentBlips, 1, -1 do
    local b = currentBlips[i]
    if b ~= 0 then
      RemoveBlip(b)
      table.remove(currentBlips, i)
    end
  end
end

local blip = nil
function RefreshBlips(activeEmergencyPersonnel)
  for src, info in pairs(activeEmergencyPersonnel) do
    if src ~= myServerId then
      if info and info.coords then
        local playerIdx = GetPlayerFromServerId(src)
        local ped = GetPlayerPed(playerIdx)
        local health = GetEntityHealth(ped)
        if IsPedInAnyVehicle(ped, false) then
          blip = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
          
          SetBlipAsFriendly(blip, true)
          SetBlipColour(blip, 5)
          local vehicle = GetVehiclePedIsIn(ped, false)
          local vehicleClass = GetVehicleClass(vehicle)
          if(vehicleClass == 15) then 
            SetBlipSprite(blip, 64)
          elseif(vehicleClass == 14) then
            SetBlipSprite(blip, 427)
          elseif(vehicleClass == 8) then
            SetBlipSprite(blip, 226)
          elseif(vehicleClass == 13) then
            SetBlipSprite(blip, 226)
          elseif(vehicleClass == 16) then
            SetBlipSprite(blip, 423)
          elseif(vehicleClass ~= 8 or 13 or 14 or 15 or 16) then
            SetBlipSprite(blip, 227)
          else 
            SetBlipSprite(blip, 227)
          end
        else
          if(Config.show_officer_on_foot == true) then
            blip = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
            if(health == 0) then
              SetBlipSprite(blip, 310)
            else 
              SetBlipSprite(blip, 280)
              SetBlipColour(blip, 0)
            end
          end
        end
				SetBlipAsShortRange(blip, true)
				SetBlipDisplay(blip, 280)
				SetBlipShowCone(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(info.name)
				EndTextCommandSetBlipName(blip)
				table.insert(currentBlips, blip)
			end
		end
	end
end


-- exports -- 
exports('getclientdept', function(id) 
  if(on_duty[id]) then
    return on_duty
  else 
    return nil
  end
end) 