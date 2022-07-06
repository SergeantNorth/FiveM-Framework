-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

local on_duty = {}

-- NOTIFY -- 
function ShowInfo(text)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandThefeedPostTicker(true, false)
end
  
-- NOTIFY
function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function ShowInfoRevive(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(text)
	DrawNotification(true, true)
end

-- GIVE WEAPON --
function GiveWeapon(Hash)
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(Hash), 300, false)
end

  
-- ADD WEAPON COMPONENT -- 
function AddWeaponComponent(WeaponHash, Component)
    if HasPedGotWeapon(GetPlayerPed(-1), GetHashKey(WeaponHash), false) then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(WeaponHash), GetHashKey(Component))
    end
end


-- SYNC WITH CLIENT -- 
function sync(account) 
    on_duty = account
end

-- PRIORTY -- 
if(Config.enable_priority == true) then
    function priorty_draw(text)
      SetTextFont(4)
      SetTextScale(0.44, 0.44)
      SetTextOutline()
      SetTextEntry("STRING")
      AddTextComponentString(text)
      DrawText(Config.priority_draw.x, Config.priority_draw.y)
    end
end
  
  
-- AOP --
if(Config.enable_aop == true) then
    function aop_draw(text)
        SetTextFont(4)
        SetTextScale(0.44, 0.44)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(Config.aop_draw.x, Config.aop_draw.y)
    end
end
  
-- PEACETIME -- 
if(Config.enable_peacetime == true) then
    function peacetime_draw(text)
        SetTextFont(4)
        SetTextScale(0.44, 0.44)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(Config.peactime_draw.x, Config.peactime_draw.y)
    end
end


-- BUTTONS BELOW --
if (Config.richpresence == true) then
    RegisterNetEvent('SERGEANTNORTH:UPDATEPLAYERCOUNT')
    AddEventHandler('SERGEANTNORTH:UPDATEPLAYERCOUNT', function(num) 
        SetDiscordAppId(Config.client_id)
        SetDiscordRichPresenceAsset(Config.big_icon)
        SetDiscordRichPresenceAssetText(Config.big_text)
        SetDiscordRichPresenceAssetSmall(Config.small_icon)
        SetDiscordRichPresenceAssetSmallText(Config.small_text)
        if(Config.show_char_playing == true) then
            local player = GetPlayerServerId(PlayerId())
            if(on_duty[player]) then
                SetRichPresence("Currently playing as " .. on_duty[player].char_name .. " [" .. on_duty[player].dept .. "]") 
                Citizen.Wait(12500)
                SetRichPresence('Players: ' .. num)
            else 
                SetRichPresence('Players: ' .. num)
            end
        else 
            SetRichPresence('Players: ' .. num)
        end
        if(Config.discord_buttons == true) then
            SetDiscordRichPresenceAction(0, Config.button_1.label, Config.button_1.url)
            SetDiscordRichPresenceAction(1, Config.button_2.label, Config.button_2.url)
        end
    end)
    
    Citizen.CreateThread(function() 
        while true do 
            TriggerServerEvent('SERGEANTNORTH:GETPLAYERCOUNT')
            Citizen.Wait(25000)
        end
    end)
end

-- clear wanted level --
if(Config.clearcops == true) then
    Citizen.CreateThread(function() 
      while true do 
        Citizen.Wait(1)
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
          SetPlayerWantedLevel(PlayerId(), 0, false)
          SetPlayerWantedLevelNow(PlayerId(), false)
        end
        for i = 1, 12 do
          EnableDispatchService(i, false)
        end
        local pos = GetEntityCoords(GetPlayerPed(-1))
        ClearAreaOfCops(pos.x, pos.y, pos.z, 1000.00, 0)
      end
    end)
end


-- Door script -- 
if(Config.enable_door_lock == true) then
    function Draw3DText(x,y,z,textInput,scaleX,scaleY)
        z = z + 2
        local onScreen, _x, _y = World3dToScreen2d(x, y, z)
        local camCoords      = GetGameplayCamCoords()
        local dist           = GetDistanceBetweenCoords(camCoords, x, y, z, true)
        local size           = size
        local factor = #textInput / 370
      
        if size == nil then
          size = 1
        end
      
        local scale = (size / dist) * 2
        local fov   = (1 / GetGameplayCamFov()) * 100
        local scale = scale * fov
      
        if onScreen then
          SetTextScale(0.35, 0.35)
          SetTextFont(4)
          SetTextColour(255, 255, 255, 255)
          SetTextDropshadow(0, 0, 0, 0, 255)
          SetTextDropShadow()
          SetTextOutline()
          SetTextEntry('STRING')
          SetTextCentre(1)
      
          AddTextComponentString(textInput)
          DrawText(_x, _y)
          DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
        end
    end	

    function round(n)
        return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
    end 

    function clientcheckperms(stuff, id)
        local perms = false
        for k, v in ipairs(stuff) do
          if(on_duty[id]) then
            if(on_duty[id].dept == v) then
              perms = true
            end
          end
        end
        return perms
    end
end


function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do        
        Citizen.Wait(100)
    end
end


function Fixplayer(state, id) 
    if(state == true) then
        local ped = GetPlayerPed(-1)
        local numbers = {}
        SetEnableHandcuffs(ped, false)
        DoScreenFadeOut(3000)
        Citizen.Wait(3000)
        SetEntityHealth(GetPlayerPed(-1), 200) 
        for name, data in ipairs(Config.death_spots) do
            local far = GetDistanceBetweenCoords((GetEntityCoords(ped)), data, true)
            table.insert(numbers, far)
        end

        local num, id = getLowest(numbers)
        for k, v in ipairs(Config.death_spots) do
            if(k == id) then
                local x, y, z, h = table.unpack(v)
                NetworkResurrectLocalPlayer(x, y, z, true, false) 
                SetPlayerInvincible(ped, false) 
                ClearPedBloodDamage(ped)
                
                SetEntityCoords(PlayerPedId(), x, y, z)
                SetEntityHeading(PlayerPedId(), nil)
                DoScreenFadeIn(3000)
                FreezeEntityPosition(GetPlayerPed(-1), false)
            end
        end
      
    else 
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        SetEnableHandcuffs(ped, false)
        SetPlayerInvisibleLocally(ped, true)
        Citizen.Wait(500)
        ClearPedTasks(ped)
        SetPlayerInvisibleLocally(ped, false)        
        SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, true, false)
        SetEntityHealth(ped, 200) 
    end
end

function getLowest(table)
    local low = math.huge
    local index
    for i, v in pairs(table) do
        if v < low then
            low = v
            index = i
        end
    end
    return low, index
end



function open_menu(dept)
    _MenuPool:Remove()
    _MenuPool = NativeUI.CreatePool()
    MainMenu = NativeUI.CreateMenu("Weapon storage",  "Department: " .. dept, 0)
    _MenuPool:Add(MainMenu)
    MainMenu:SetMenuWidthOffset(80)

    
    MainMenu:SetMenuWidthOffset(80)	
    local menu = _MenuPool:AddSubMenu(MainMenu, 'Weapons', 'Weapon Related Menu', true)

    local weapons = Config.weapon_per_dept[dept]
    if(weapons ~= nil) then
        for k, v in pairs(weapons) do
            local add = NativeUI.CreateItem("Equip: ~g~" .. weapons[k].name, 'Click to equip ' .. weapons[k].name .. ".")
            menu:AddItem(add)
            add.Activated = function(ParentMenu, SelectedItem)
              GiveWeapon(weapons[k].weapon_hash)
              ShowInfo("You have been given a ~b~" .. weapons[k].name)
            end
        end
    end
  

    local clearweapons = NativeUI.CreateItem("~r~Clear weapons", "Clear your weapons.")
    menu:AddItem(clearweapons)
    clearweapons.Activated = function(ParentMenu, SelectedItem)
      RemoveAllPedWeapons(PlayerPedId(), true)
      ShowInfo("~g~successfully cleared your weapons")
    end
  
    _MenuPool:RefreshIndex()
end

function freeze() 
    RenderScriptCams(true, true, 1000, true, true)
    DisplayHud(false)
    DisplayRadar(false)
    SetNuiFocus(true, true)
    SetPlayerInvincible(PlayerId(), true)
    if IsEntityVisible(GetPlayerPed(PlayerId())) then
      SetEntityVisible(GetPlayerPed(PlayerId()), false)
    end
    FreezeEntityPosition(GetPlayerPed(PlayerId()), true)
end

function unfreeze(state, gender, dept, telpe, daplace)
    if(state == true) then
        SwitchOutPlayer(PlayerPedId(), 0, 1)
    end
    if(telpe == true) then
        SetEntityCoords(PlayerPedId(), daplace.x, daplace.y, daplace.z)
        SetEntityHeading(PlayerPedId(), daplace.h)
    end


    local ped = GetPlayerPed(PlayerId())
    SetNuiFocus(false, false)
    SetEntityVisible(ped, true)
    SetPlayerInvincible(PlayerId(), false)
    RenderScriptCams(false, true, 1000, true, true)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    SetTimecycleModifier('default')
    DisplayHud(true)
    DisplayRadar(true)
    if(state == true) then
        Citizen.Wait(1000)
      SwitchInPlayer(PlayerPedId())
    end

    if(Config.enable_default_ped_spawn == true) then
        if(dept ~= Config.dept_names['civ_level']) then
            local player = PlayerId()
            local modal = nil
            if(gender == "Male") then
                model = GetHashKey(Config.male_ped)
            else 
                model = GetHashKey(Config.female_ped)
            end
            
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(100)
            end
        
            SetPlayerModel(player, model)
            SetModelAsNoLongerNeeded(model)
        end
    end
end

