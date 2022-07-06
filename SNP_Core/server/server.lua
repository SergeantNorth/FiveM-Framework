-- MADE BY SERGEANTNORTH -- 
local resource_name = GetCurrentResourceName();

--############-- 
-- DO NOT TOUCH -- 
local on_duty = {}

-- SHOT SPOTER -- 
local on = false;
--############-- 

-- GETS USERS CHARCTERS -- 
RegisterNetEvent("SERGEANTNORTH:GETCHARCTERS")
AddEventHandler("SERGEANTNORTH:GETCHARCTERS", function()
  local steamid = GetPlayerIdentifier(source)
  local user_id = source
  local discord = getdiscordid(user_id)
  local admin = false
  local perms = {}
  
  if(Config.use_discord == true) then
    local admin_check = IsRolePresent(user_id, Config.users_roles["admin_level"])
    if(admin_check == true) then
      admin =  true
    end
  else 
    if IsPlayerAceAllowed(user_id, Config.users_roles["admin_level"]) then
      admin =  true
    end
  end

  for level, department in pairs(Config.dept_names) do
    local dept = {id = level, name = department, role = Config.users_roles[level], spawns = Config.Spawns[level], perms = 0, level_name = level, admin = 0}
    perms[level] = dept
    if(Config.use_discord == true) then
      if(Config.users_roles[level] == "0") then
        perms[level].perms = 1
      else 
        Citizen.Wait(30)
        local check = IsRolePresent(user_id, Config.users_roles[level])
        if(check == true) then
          perms[level].perms = 1
        else 
          perms[level].perms = 0
        end
        if(admin == true) then
          perms[level].perms = 1
          perms[level].admin = 1
        end
      end
    else 
      if(Config.users_roles[level] == "0") then
        perms[level].perms = 1
      else 
        if IsPlayerAceAllowed(user_id, Config.users_roles[level])	 then
          perms[level].perms = 1

        end
      end
      if IsPlayerAceAllowed(user_id, Config.users_roles["admin_level"]) then
        perms[level].perms = 1
        perms[level].admin = 1
      end

    end
  end

  Citizen.Wait(10)
  local settings = nil
  MySQL.Async.fetchAll("SELECT * FROM characters_settings WHERE steamid=@steamid", {["@steamid"] = steamid}, function(data2)
    if(data2 == nil or data2[1] == nil) then 
      MySQL.Async.execute("INSERT INTO characters_settings (discord, steamid) VALUES (@discord, @steamid)", {["@discord"] = discord, ["@steamid"] = steamid})
      Citizen.Wait(50)
      MySQL.Async.fetchAll("SELECT * FROM characters_settings WHERE steamid=@steamid", {["@steamid"] = steamid}, function(data)
        if(data == nil or data[1] == nil) then
          settings = {dark_mode = "1", cloud_spawning = "1", slideshow = "0", character_gardient = "#DDADF3|#582185", refresh_gardien = "#3E3BDF|#6529C5", settings_gardient = "#1792DA|#49C06D", disconnect_gardient = "#FF0000|#EB7F27"}
        else 
          settings = {dark_mode = data[1].dark_mode, cloud_spawning = data[1].cloud_spawning, slideshow = data[1].image_slideshow, character_gardient = data[1].character_gardient_color, refresh_gardien = data[1].refresh_gardient_color, settings_gardient = data[1].settings_gardient_color, disconnect_gardient = data[1].disconnect_gardient_color}
        end
        loadup(settings)
      end)
    else 
      settings = {dark_mode = data2[1].dark_mode, cloud_spawning = data2[1].cloud_spawning, slideshow = data2[1].image_slideshow, character_gardient = data2[1].character_gardient_color, refresh_gardien = data2[1].refresh_gardient_color, settings_gardient = data2[1].settings_gardient_color, disconnect_gardient = data2[1].disconnect_gardient_color}
      loadup(settings)
    end
  end)

  function loadup(set)
    MySQL.Async.fetchAll("SELECT * FROM characters WHERE steamid=@steamid", {["@steamid"] = steamid}, function(data1)
      local check = false
      if(Config.checkDiscord == true) then
        if(data1[1] ~= nil) then   
          for i, v in pairs(data1) do
            for k, value in pairs(Config.dept_names) do
              if(perms[k] and perms[k].perms == 0 and perms[k].name == v.dept) then
                Citizen.Wait(5)
                MySQL.Async.execute("DELETE FROM characters WHERE steamid = @steam AND dept = @dept AND first_name = @first AND last_name = @last", {["@steam"] = steamid, ["@dept"] = v.dept, ["@first"] = v.first_name, ["@last"] = v.last_name})
                sendToDiscord(0000000, "Auto Character Removal", "**Steam Hex:** " ..steamid.. "\n**Discord ID:** " ..formatdiscord(discord).. "\n**Character Name:** " .. v.first_name .. " " .. v.last_name ..  "\n**Twitter Name:** " ..v.twitter_name.. "\n**Gender:** " ..v.gender.. "\n**Data of birth:** " ..v.dob.. "\n**Department:** " ..v.dept.. "\nThis Character was removed due to the user not having access to the role in the discord anymore.")
                check = true
                print("deleting!\n\n**Character Name:** " .. v.first_name .. " " .. v.last_name ..  "\n**Twitter Name:** " ..v.twitter_name.. "\n**Gender:** " ..v.gender.. "\n**Data of birth:** " ..v.dob.. "\n**Department:** " ..v.dept.. "")
              end
            end
          end
        end
        if(check == true) then
          Citizen.Wait(20)
          getchars(user_id, steamid, set, perms, resource_name)
        else 
          Citizen.Wait(20)
          getchars(user_id, steamid, set, perms, resource_name)
        end
      else 
        TriggerClientEvent("SERGEANTNORTH:OPENUI", user_id, data1, set, perms, resource_name)
      end
    end)
  end

end)



-- UI refresh --
RegisterNetEvent("SERGEANTNORTH:UIREFRESH")
AddEventHandler("SERGEANTNORTH:UIREFRESH", function(id)
  local src = id
  local steamid = GetPlayerIdentifier(src, 0)
  MySQL.Async.fetchAll("SELECT * FROM characters WHERE steamid=@steamid", {["@steamid"] = steamid}, function(chars)
      TriggerClientEvent("SERGEANTNORTH:RESETUI", src, chars)
  end)
end)

-- CREATE USER --
RegisterNetEvent("SERGEANTNORTH:CREATECHARCTER")
AddEventHandler("SERGEANTNORTH:CREATECHARCTER", function(first, last, twt, gender, dob, dept, level)
  -- getting users discord info
  local src = source
  local discord = getdiscordid(src);
  local steamid = GetPlayerIdentifier(src) 
  MySQL.Async.execute("INSERT INTO characters (discord, steamid, first_name, last_name, twitter_name, gender, dob, dept) VALUES (@discord, @steamid, @first_name, @last_name, @twitter_name, @gender, @dob, @dept)", {["@discord"] = discord, ["@steamid"] = steamid, ["@first_name"] = first, ["@last_name"] = last, ["@twitter_name"] = twt, ["@dob"] = dob, ["@gender"] = gender,  ["@dept"] = dept}, function()end)
  Citizen.Wait(5)

  if(Config_s.use_hamz_cad == true) then
    if(Config_s.Only_insert_if_civ == true) then
      if(dept == Config.dept_names["civ_level"]) then
        PerformHttpRequest(Config_s.website_url .. "api/createcharacter/?discordid=" .. discord .. "&name=" .. first .. "%20" .. last .. "&dob=" .. dob .. "&gender=" .. gender .. "&secret=" .. Config_s.secret_key, value, 'POST')
      end
    else 
      PerformHttpRequest(Config_s.website_url .. "api/createcharacter/?discordid=" .. discord .. "&name=" .. first .. "%20" .. last .. "&dob=" .. dob .. "&gender=" .. gender .. "&secret=" .. Config_s.secret_key, value, 'POST')
    end
  end

  TriggerEvent("SERGEANTNORTH:UIREFRESH", src)
  sendToDiscord(0000000, "Character creation", "**Steam Hex:** " ..steamid.. "\n**Discord ID:** " ..formatdiscord(discord).. "\n**Character Name:** " ..first.. " " .. last ..  "\n**Twitter Name:** " ..twt.. "\n**Gender:** " ..gender.. "\n**Data of birth:** " ..dob.. "\n**Department:** " ..dept)
end)

-- EDIT USER --
RegisterNetEvent("SERGEANTNORTH:EDITCHARCTER")
AddEventHandler("SERGEANTNORTH:EDITCHARCTER", function(first, last, twt, gender, dob, charid, dept, oldfirst, oldlast)
  local src = source
  local discord = getdiscordid(src);
   
  MySQL.Async.execute("UPDATE characters SET first_name = @first_name, last_name = @last_name, twitter_name = @twotter_name, gender = @gender, dob = @dob, dept = @dept WHERE id = @id", {["@first_name"] = first, ["@last_name"] = last, ["@twotter_name"] = twt, ["@gender"] = gender, ["@dob"] = dob, ["@dept"] = dept, ["@id"] = charid})
  Citizen.Wait(5)
  if(Config_s.use_hamz_cad == true) then
    if(Config_s.Only_insert_if_civ == true) then
      if(dept == Config.dept_names["civ_level"]) then
        PerformHttpRequest(Config_s.website_url .. "api/updatecharacter/?discordid=" .. discord .. "&oldname=" .. oldfirst .. "%20" .. oldlast .. "&newname=" .. first .. "%20" .. last .. "&dob=" .. dob .. "&gender=" .. gender .. "&secret=" .. Config_s.secret_key,value, 'POST') --  
      end
    else 
      PerformHttpRequest(Config_s.website_url .. "api/updatecharacter/?discordid=" .. discord .. "&oldname=" .. oldfirst .. "%20" .. oldlast .. "&newname=" .. first .. "%20" .. last .. "&dob=" .. dob .. "&gender=" .. gender .. "&secret=" .. Config_s.secret_key,value, 'POST') --  
    end    
  end
  TriggerEvent("SERGEANTNORTH:UIREFRESH", src)
end)


  -- SQL CHECKING TO SYNC WITH COMMANDS --
  RegisterNetEvent("SERGEANTNORTH:CHECKSQL")
  AddEventHandler("SERGEANTNORTH:CHECKSQL", function(steam, discord, first_name, last_name, twt, dept, dob, gender, data)
    local src = source
    local main_info = {src = src, discord = discord, steam = steam, char_name = first_name .. " " .. last_name, twitter_name = twt, dob = dob, gender = gender, dept = dept, level = data.level_name,  admin = data.adminperms}
    -- SQL CONNECTIONS -- 
    MySQL.Async.execute("UPDATE characters_settings SET dark_mode = @darkmode, cloud_spawning = @cloud, image_slideshow = @slideshow, character_gardient_color = @firstcolor, refresh_gardient_color = @secondcolor, settings_gardient_color = @thirdcolor, disconnect_gardient_color = @forthcolor WHERE discord = @discord AND steamid = @steamid", {["@darkmode"] = data.dark_mode, ["@cloud"]  = data.cloud, ["slideshow"] = data.img_slideshow, ["@firstcolor"] = data.char_color, ["@secondcolor"] = data.refresh_color, ["@thirdcolor"] = data.settings_color, ["@forthcolor"] = data.disconnect_color, ["@discord"] = discord, ["@steamid"] = steam})
    MySQL.Async.fetchAll("SELECT * FROM char_playing WHERE steamid = @steamid", {["@steamid"] = steam}, function(data) 
      Citizen.Wait(10)
      if(data[1] == nil) then
        MySQL.Async.execute("INSERT INTO char_playing (discord, steamid, char_name, twitter_name, gender, dob, dept) VALUES (@discord, @steamid, @char_name, @twotter_name, @gender, @dob, @dept)", {["@discord"] = discord, ["@steamid"] = steam, ["@char_name"] = first_name .. " " .. last_name, ["@twotter_name"] = twt, ["@dob"] = dob, ["@gender"] = gender,  ["@dept"] = dept}, function()end)
      elseif (data[1] ~= nil) then
        MySQL.Async.execute("DELETE FROM char_playing WHERE steamid = @steamid", {["@steamid"] = steam}, function()end)
        Citizen.Wait(10)
        MySQL.Async.execute("INSERT INTO char_playing (discord, steamid, char_name, twitter_name, gender, dob, dept) VALUES (@discord, @steamid, @char_name, @twotter_name, @gender, @dob, @dept)", {["@discord"] = discord, ["@steamid"] = steam, ["@char_name"] = first_name .. " " .. last_name, ["@twotter_name"] = twt, ["@dob"] = dob, ["@gender"] = gender,  ["@dept"] = dept}, function()end)
      end
    end)


    -- MAIN TAGS WIP -- 
    TriggerEvent("SERGEANTNORTH:REMOVELEO", src)
    Citizen.Wait(2)
    TriggerEvent("SERGEANTNORTH:ADDLEO", main_info)
    

    -- FOR LEO BLIPS -- 
    Citizen.Wait(5)
    TriggerEvent("SERGEANTNORTH:REMOVEBLIP", src)
    if(Config.autoenable_blips == true) then
      if(dept ~= Config.dept_names['civ_level']) then
        local player_info = {name = GetPlayerName(src), src = src}
        TriggerEvent("SERGEANTNORTH:ADDBLIP", player_info)
      end
    end
end)

-- HANDLES EVERYTHING | DO NOT TOUCH -- 
RegisterNetEvent("SERGEANTNORTH:ADDLEO")
AddEventHandler("SERGEANTNORTH:ADDLEO", function(player)
  on_duty[player.src] = player;
  updatearray(on_duty)
  TriggerClientEvent("SERGEANTNORTH:UPDATELEOS", -1, on_duty)
end)

RegisterServerEvent("SERGEANTNORTH:REMOVELEO")
AddEventHandler("SERGEANTNORTH:REMOVELEO", function(src)
  on_duty[src] = nil
  updatearray(on_duty)
  TriggerClientEvent("SERGEANTNORTH:UPDATELEOS", -1, on_duty)
end)

AddEventHandler("playerDropped", function()
  Citizen.Wait(3000)
  if on_duty[source] then
    on_duty[source] = nil
    updatearray(on_duty)
    TriggerClientEvent("SERGEANTNORTH:UPDATELEOS", -1, on_duty)
  end
end)

-- DELETE USER --
RegisterNetEvent("SERGEANTNORTH:DELETEUSER")
AddEventHandler("SERGEANTNORTH:DELETEUSER", function(char_id)
  local src = source
  local discord = getdiscordid(src); 
  local steamid = GetPlayerIdentifier(src, 0)
    MySQL.Async.fetchAll("SELECT * FROM characters WHERE id = @id AND steamid=@steamid", {["@steamid"] = steamid, ["@id"] = char_id}, function(data)
      Citizen.Wait(5)
      if(Config_s.use_hamz_cad == true) then
        if(Config_s.Only_insert_if_civ == true) then
          if(dept == Config.dept_names["civ_level"]) then
            PerformHttpRequest(Config_s.website_url .. "api/deletecharacter/?discordid=" .. discord .. "&name=" .. data[1].first_name .. "%20" .. data[1].last_name .. "&secret=" .. Config_s.secret_key, value, 'POST')
          end
        else 
          PerformHttpRequest(Config_s.website_url .. "api/deletecharacter/?discordid=" .. discord .. "&name=" .. data[1].first_name .. "%20" .. data[1].last_name .. "&secret=" .. Config_s.secret_key, value, 'POST')
        end
      end
      MySQL.Async.execute("DELETE FROM characters WHERE id = @id AND steamid=@steamid", {["@steamid"] = steamid, ["@id"] = char_id}, function()end)
      TriggerEvent("SERGEANTNORTH:UIREFRESH", src)
      sendToDiscord(0000000, "Character Deleted", "**Character ID:** " .. data[1].id.."\n**Steam Hex:** " .. data[1].steamid.. "\n**Discord ID:** " .. formatdiscord(data[1].discord).. "\n**Character Name:** " .. data[1].first_name .. " ".. data[1].last_name .. "\n**Twitter Name:** " .. data[1].twitter_name.. "\n**Gender:** " .. data[1].gender.. "\n**Data of birth:** " .. data[1].dob.. "\n**Department:** " .. data[1].dept)
    end)
end)

-- DISCONNECT
RegisterNetEvent("SERGEANTNORTH:DISCONNECTBUTTON")
AddEventHandler("SERGEANTNORTH:DISCONNECTBUTTON", function() 
  DropPlayer(source, "Disconnect from the server via framework.")
end)


-- SHOT SPOTER --
if(Config.shotspoter == true) then
  RegisterNetEvent("SERGEANTNORTH:SHOTSPOTER")
  AddEventHandler("SERGEANTNORTH:SHOTSPOTER", function(id, playerX, playerY, playerZ, hash1, hash2) 
    if(on_duty[id]) then 
      if(on_duty[id].dept == Config.dept_names['civ_level']) then
        if(on == true) then return end
        local postal = getPlayerLocation(id)
        on = true;
        Citizen.Wait(Config.shotspotter_timer)
        Citizen.Wait(2)
        for _, player in ipairs(GetPlayers()) do
          player = tonumber(player)
          if(on_duty[player]) then
            if(on_duty[player].dept ~= Config.dept_names['civ_level']) then
              TriggerClientEvent("chatMessage", player, "^2[DISPATCH]", {255,255,255}, " ^7We have received a 911 call about an active shooter in " ..hash1.. " " ..hash2 .. " Postal: " .. postal)
              TriggerClientEvent("SERGEANTNORTHSENDSHOTSPOTER", player, playerX, playerY, playerZ, hash1, hash2)
            end
          end
        end
        turnoff()
      end
    end
  end)

  function turnoff() 
    Citizen.Wait(Config.wait_time_before_next_blip)
    on = false;
  end
end

-- event for when someone leaves --
AddEventHandler('playerDropped', function(reason)
  local hex = GetPlayerIdentifier(source)
  MySQL.Async.execute("DELETE FROM char_playing WHERE steamid = @steamid", {["@steamid"] = hex });
end)


-- chat commands --
if (Config.enable_ooc_command == true) then
  RegisterCommand('ooc', function(source, args, message)
    local steamid = GetPlayerIdentifier(source)
    local check = false;
    local length = string.len(table.concat(args, " "));
    if (length > 0) then 
      local name = GetPlayerName(source)
      if(Config.enable_chat_blocker == true ) then
        check = chatblacklist(message)
      end
      if(check == true) then
        TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Your message was flagged for containing a blacklisted word.")
      else 
        TriggerClientEvent('chatMessage', -1, "^3^*[OOC] " .. name, {19, 84, 145}, "^7 " .. table.concat(args, " "))
      end
      sendToDiscord(0000000, "Command used! [OOC]", "**Steam Name:** " .. GetPlayerName(source) .. "\n**Steam Hex:**" ..steamid.. "\n**Message:** " ..table.concat(args, " ")) 
    end
  end, false)
end

if(Config.enable_do_command == true) then
  RegisterCommand('do', function(source, args, message)
    local check = false;
    local steamid = GetPlayerIdentifier(source)
    local length = string.len(table.concat(args, " "));
    local name = GetPlayerName(source)
    if (length > 0) then 
      if(Config.enable_chat_blocker == true ) then
        check = chatblacklist(message)
      end
      local fix = on_duty[source].char_name .. " [" .. on_duty[source].dept .. "]"
      if(check == true) then
        TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Your message was flagged for containing a blacklisted word.")
      else 
        TriggerClientEvent("SendProximityMessageDo", -1, source, fix, table.concat(args, " "))
      end
      sendToDiscord(0000000, "Command used! [DO]", "**Steam Name:** " .. GetPlayerName(source)  .. "\n**Steam Hex:**" ..steamid.. "\n**Message:** " ..table.concat(args, " ")) 
    end
  end, false)
end

if(Config.enable_me_command == true) then
  RegisterCommand('me', function(source, args, message)
    local check = false;
    local steamid = GetPlayerIdentifier(source)
    local length = string.len(table.concat(args, " "));
    if (length > 0) then 
      local name = GetPlayerName(source)
      if(Config.enable_chat_blocker == true ) then
        check = chatblacklist(message)
      end
      local fix = on_duty[source].char_name .. " [" .. on_duty[source].dept .. "]"
      if(check == true) then
        TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Your message was flagged for containing a blacklisted word.")
      else 
        TriggerClientEvent("SendProximityMessageMe", -1, source, fix, table.concat(args, " "))
      end
      sendToDiscord(0000000, "Command used! [ME]", "**Steam Name:** " .. GetPlayerName(source)  .. "\n**Steam Hex:**" ..steamid.. "\n**Message:** " ..table.concat(args, " "))  
    end
  end, false)
end

if(Config.enable_mer_command == true) then 
  RegisterCommand('mer', function(source, args, message)
    local check = false;
    local length = string.len(table.concat(args, " "));
    local steamid = GetPlayerIdentifier(source)
    if (length > 0) then 
      local name = GetPlayerName(source)
      if(Config.enable_chat_blocker == true ) then
        check = chatblacklist(message)
      end
      local fix = on_duty[source].char_name .. " [" .. on_duty[source].dept .. "]"
      if(check == true) then
        TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Your message was flagged for containing a blacklisted word.")
      else 
        TriggerClientEvent("SendProximityMessageMer", -1, source, fix, table.concat(args, " "))
      end
      sendToDiscord(0000000, "Command used! [MER]", "**Steam Name:** " .. GetPlayerName(source)  .. "\n**Steam Hex:**" ..steamid.. "\n**Message:** " ..table.concat(args, " "))  
    end
  end, false)
end

if(Config.enable_dob_command == true) then
  RegisterCommand('dob', function(source, args, message)
    local name = GetPlayerName(source)
    local steamid = GetPlayerIdentifier(source)
    TriggerClientEvent("SERGEANTNORTH:DOBCOMMAND", source, on_duty[source].char_name, on_duty[source].dob)
    sendToDiscord(0000000, "Command used! [DOB]", "**Steam Name:** " ..name.. "\n**Steam Hex:**" ..steamid.. "\n**Message:** " ..table.concat(args, " "))  
  end, false)
end


if(Config.enable_twt_command == true) then
  RegisterCommand('twitter', function(source, args, message)
    local check = false;
    local name = GetPlayerName(source)
    local steamid = GetPlayerIdentifier(source)
    local length = string.len(table.concat(args, " "));
    if(on_duty) then    
      if (length > 0) then 
        if(Config.enable_chat_blocker == true ) then
          check = chatblacklist(message)
        end
        if(check == true) then
          TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Your message was flagged for containing a blacklisted word.")
        else 
          TriggerClientEvent('chatMessage', -1, "^4^*[Twitter] @" .. on_duty[source].twitter_name .. " (#" .. source .. ")^7 ", {30, 144, 255}, table.concat(args, " "))
        end
        sendToDiscord(0000000, "Command used! [twitter]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..steamid.. "\n**Message:** " ..table.concat(args, " ")) 
      end
    else 
      TriggerClientEvent('chatMessage', source, "^1 Access Denied")
    end
  end, false)
end

if(Config.enable_gme_command == true) then
  RegisterCommand('gme', function(source, args, message)
    local check = false;
    local length = string.len(table.concat(args, " "));
    local steamid = GetPlayerIdentifier(source)
    if (length > 0) then 
      local name = GetPlayerName(source)
      if(Config.enable_chat_blocker == true ) then
        check = chatblacklist(message)
      end
      if(check == true) then
        TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Your message was flagged for containing a blacklisted word.")
      else 
        TriggerClientEvent('chatMessage', -1, "^8 " .. on_duty[source].char_name .. " [" .. on_duty[source].dept .. "] (#" .. source .. ")^7" , {30, 144, 255}, table.concat(args, " "))
      end
      sendToDiscord(0000000, "Command used! [GME]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:**" ..steamid.."\n**Message:** " ..table.concat(args, " ")) 
    end
  end, false)
end


if(Config.enable_radio_command == true) then
  RegisterCommand('radiochat', function(source, args, message)
    local check = false;  
    local length = string.len(table.concat(args, " "));
    if (length > 0) then 
      if(Config.enable_chat_blocker == true) then
        check = chatblacklist(message)
      end    
      local name = GetPlayerName(source)
        if(check == true) then
          TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Your message was flagged for containing a blacklisted word.")
        else
            if(on_duty[source].dept ~= Config.dept_names['civ_level']) then
              local fix = "^2[Radio] ".. on_duty[source].char_name .. " [" .. on_duty[source].dept .. "] (#" .. source .. ")"
              for _, player in ipairs(GetPlayers()) do
                player = tonumber(player)
                if(on_duty[player]) then
                  if(on_duty[player].dept ~= Config.dept_names['civ_level']) then
                    TriggerClientEvent('chatMessage', player, fix, {255,255,255}, table.concat(args, " "))
                  end
                else
                  MySQL.Async.fetchAll("SELECT dept FROM char_playing WHERE steamid = @steamid", {["@steamid"] = on_duty[source].steam}, function(data)
                    if(data[1].dept ~= Config.dept_names['civ_level']) then
                      TriggerClientEvent('chatMessage', player, fix, {255,255,255}, table.concat(args, " "))
                    end
                  end)
                end
              end
            else 
              TriggerClientEvent('chatMessage', source, "^1 Access Denied")
            end
        end
      end
  end, false)
end

if(Config.enable_ems_command == true) then
  RegisterCommand('ems', function(source, args, message)
    local check = false;
    local steamid = GetPlayerIdentifier(source, 0)
    local length = string.len(table.concat(args, " "));
    if (length > 0) then 
      local name = GetPlayerName(source)
      if(Config.enable_chat_blocker == true ) then
        check = chatblacklist(message)
      end    
      if(check == true) then
        TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Your message was flagged for containing a blacklisted word.")
      else 
        if(on_duty[source].dept ~= Config.dept_names['civ_level']) then
          local fix = "^1[EMS] ".. on_duty[source].char_name .. " [" .. on_duty[source].dept .. "] (#" .. source .. ")"
          Citizen.Wait(2)
          for _, player in ipairs(GetPlayers()) do
            player = tonumber(player)
            if(on_duty[player].dept ~= Config.dept_names['civ_level']) then
              TriggerClientEvent('chatMessage', player, fix, {255,255,255}, table.concat(args, " "))
            end
          end
        else  
          TriggerClientEvent('chatMessage', source, "^1 Access Denied")
        end
      end
    end
  end, false)
end

if(Config.enable_darkweb_command == true) then
  RegisterCommand('darkweb', function(source, args, message)
    local name = GetPlayerName(source)
    local test = tostring(table.concat(args, " "))
    if(test == nil) then return end
    local length = string.len(test);
    if (length > 0) then 
      local check = false;  
      if(Config.enable_chat_blocker == true ) then
        check = chatblacklist(message)
      end    
      if(check == true) then
        TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Your message was flagged for containing a blacklisted word.")
      else 
        if(on_duty[source] and on_duty[source].dept ~= Config.dept_names['civ_level']) then 
          TriggerClientEvent('chatMessage', source, "^1 Access Denied")
        else 
          local value = randomchar() .. source;
          Citizen.Wait(2)  
          for _, player in ipairs(GetPlayers()) do
            player = tonumber(player)
            if(on_duty[player] and on_duty[player].dept == Config.dept_names['civ_level']) then
              TriggerClientEvent('chatMessage', player, "^*^9[Dark Web] " .. value, {255,255,255}, table.concat(args, " "))
            end
          end
        end
      end
    end
  end, false)
end

if(Config.enable_whoami_command == true) then
  RegisterCommand('whoami', function(source, args, message)
    local name = GetPlayerName(source)
    if(on_duty[source] and on_duty[source].dept ~= Config.dept_names['civ_level']) then
      TriggerClientEvent('chatMessage', source, "^0^*You are playing as ^3" .. on_duty[source].char_name.. " ^0Current Department: ^3" .. on_duty[source].dept)
    else 
      TriggerClientEvent('chatMessage', source, "^0^*You are playing as ^3" .. on_duty[source].char_name)
    end
    sendToDiscord(0000000, "Command used! [WHOAMI]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..on_duty[source].steam.."\n**Message:** " ..table.concat(args, " ")) 
  end)
end

if(Config.enable_loadout_command == true) then
  RegisterCommand('loadout', function(source, args, message)
    if(on_duty[source] and on_duty[source].dept ~= Config.dept_names['civ_level']) then
      TriggerClientEvent("SERGEANTNORTH:GIVELOADOUT", source)
    else 
      TriggerClientEvent('chatMessage', source, "^1 Access Denied")
    end
  end)
end

if(Config.enable_911_command == true) then
  RegisterCommand('911', function(source, args, message)
    local length = string.len(table.concat(args, " "));
    local name = GetPlayerName(source)
    local id = source;
    if (length > 0) then 
      local check = false;
      if(Config.enable_chat_blocker == true ) then
        check = chatblacklist(message)
      end    
      if(check == true) then
        TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Your message was flagged for containing a blacklisted word.")
      else 
        local pos = GetEntityCoords(GetPlayerPed(source))
        local message = table.concat(args, " ");
        if(on_duty[source]) then
          sendToDiscord(0000000, "Command used! [911]", "**Steam Name:** " .. GetPlayerName(source) .. "\n**Steam Hex:** " ..on_duty[source].steam.. "\n**Message:** " .. message) 
          for _, player in ipairs(GetPlayers()) do
            player = tonumber(player)
            if(on_duty[player]) then
              if(on_duty[player].dept ~= Config.dept_names['civ_level']) then
                TriggerClientEvent("SERGEANTNORTH:911CALL", player, id, message, pos)
              end
            end
          end
          TriggerClientEvent("chatMessage", source,  "[^3DISPATCH^0] We have notified dispatch regarding your 911 call!")
          sendToDiscord(000000, GetPlayerName(source) .. " [#" .. source .. "]", "(911 call made) `" .. table.concat(args, " ") .. "`")
        else
          TriggerClientEvent('chatMessage', source, "^1 Access Denied")
        end
      end
    end
  end, false)
end

if(Config.enable_aop == true) then
  local aop = Config.default_aop;

  RegisterCommand('aop', function(source, args, message)
    local length = string.len(table.concat(args, " "));
    if (length > 0) then
      if(on_duty[source]) then 
        if(on_duty[source].admin == 1 or on_duty[source].dept == Config.dept_names["admin_level"]) then
          TriggerClientEvent("SERGEANTNORTH:AOPCHANGE", -1, table.concat(args, " "))
          TriggerClientEvent("SERGEANTNORTH:AOPNOT", -1, "Aop switched to ~b~" .. table.concat(args, " "))
          sendToDiscord(000000, GetPlayerName(source) .. " [#" .. source .. "]", "Aop switched to `" .. table.concat(args, " ") .. "`")
          aop = table.concat(args, " ")
        else 
          TriggerClientEvent('chatMessage', source, "^1 Access Denied")
        end
      end
    end
  end)


  RegisterCommand("checkaop", function(source, args, message) 
    TriggerClientEvent("chatMessage", source, "Current server AOP is: ^3" .. aop)
  end)

  RegisterNetEvent("SERGEANTNORTH:UPDATEDUMBAOP")
  AddEventHandler("SERGEANTNORTH:UPDATEDUMBAOP", function()
    local src = source;
    TriggerClientEvent('SERGEANTNORTH:AOPCHANGE', src, aop)
  end)
end

-- BLIPS -- 
if(Config.enable_blips == true) then
  local active_leo = {};
  RegisterCommand('blip', function(source, args, message)
    local status = args[1];
    if(status == nil) then return end;
    status = status:lower()
    local player_name = GetPlayerName(source)
    if(on_duty[source].dept ~= Config.dept_names['civ_level']) then
      local player_info = {name = player_name, src = source}
      if(status == "on") then
        if active_leo[source] then
          TriggerClientEvent('chatMessage', source, "[^3Dispatch^0] Your blips are already enabled!")
        else 
          TriggerEvent("SERGEANTNORTH:ADDBLIP", player_info)
          TriggerClientEvent('chatMessage', source, "[^3Dispatch^0] You have enabled LEO blips!")
        end
      elseif(status == "off") then
        if not active_leo[source] then
          TriggerClientEvent('chatMessage', source, "[^3Dispatch^0] Your blips are already disabled!")
        else 
          TriggerEvent("SERGEANTNORTH:REMOVEBLIP", source)
          TriggerClientEvent('chatMessage', source, "[^3Dispatch^0] You have disabled LEO blips!")
        end
      end
    else
      TriggerClientEvent('chatMessage', source, "^1 Access Denied")
    end   
  end) 
  
  AddEventHandler("playerDropped", function()
    if active_leo[source] then
      active_leo[source] = nil
    end
  end)
  
  RegisterNetEvent("SERGEANTNORTH:ADDBLIP")
  AddEventHandler("SERGEANTNORTH:ADDBLIP", function(player)
    active_leo[player.src] = player;
    TriggerClientEvent("SERGEANTNORTH:TOGGLELEOBLIP", player.src, true)
  end)

  RegisterServerEvent("SERGEANTNORTH:REMOVEBLIP")
  AddEventHandler("SERGEANTNORTH:REMOVEBLIP", function(src)
    active_leo[src] = nil
    TriggerClientEvent("SERGEANTNORTH:TOGGLELEOBLIP", src, false)
  end)

  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(100)
        for id, info in pairs(active_leo) do
          active_leo[id].coords = GetEntityCoords(GetPlayerPed(id))
          TriggerClientEvent("SERGEANTNORTH:UPDATEBLIPS", id, active_leo)
        end
    end
  end)
end

-- PRIORTY --
if(Config.enable_priority == true) then
  local cooldown = 0
  local priorty_status = false 
  local hold_status = false
  local max_time = Config.max_time
  local inactive = 0;
  local nameofthepriorty = ""

  RegisterCommand('pstart', function(source, args, message) 
    local player_name = GetPlayerName(source)
    nameofthepriorty = player_name
    if(Config.admin_use_only == true) then
      if(Config.use_discord == true) then
        local pr_check = false;
        local check = false;
        for src, role in ipairs(Config.users_roles["PRIORTY"]) do
          check = IsRolePresent(source, role)
          if(check == true) then
            pr_check = true
          elseif (check == false and pr_check == true) then
            pr_check = true
          else 
            pr_check = false
          end
        end
        if(pr_check == true) then
          priorty_status = true
          TriggerClientEvent("SERGEANTNORTH:UPDATEPRIORTY", -1, priorty_status, player_name)
        else
          TriggerClientEvent('chatMessage', source, "^1 Access Denied")
        end
      else 
        if IsPlayerAceAllowed(source, "framework.priorty") then
          priorty_status = true
          TriggerClientEvent("SERGEANTNORTH:UPDATEPRIORTY", -1, priorty_status, player_name)
        else 
          TriggerClientEvent('chatMessage', source, "^1 Access Denied")
        end
      end
    else 
      if(Config.everyone_can_use_the_priority_command == true) then
        priorty_status = true
        TriggerClientEvent("SERGEANTNORTH:UPDATEPRIORTY", -1, priorty_status, player_name)
      else 
        if(on_duty[source].dept == Config.dept_names['civ_level']) then
          priorty_status = true
          TriggerClientEvent("SERGEANTNORTH:UPDATEPRIORTY", -1, priorty_status, player_name)
        else
          TriggerClientEvent('chatMessage', source, "^1 Access Denied")
        end
      end
      
    end 
  end)

  RegisterCommand('phold', function(source, args, message)
    if(Config.admin_use_only == true) then
      if(Config.use_discord == true) then
        local pr_check = false;
        local check = false;
        for src, role in ipairs(Config.users_roles["PRIORTY"]) do
          check = IsRolePresent(source, role)
          if(check == true) then
            pr_check = true
          elseif (check == false and pr_check == true) then
            pr_check = true
          else 
            pr_check = false
          end
        end
        if(pr_check == true) then
          hold_status = true
          TriggerClientEvent('SERGEANTNORTH:HOLDPRIORTY', -1, hold_status)
        else 
          TriggerClientEvent('chatMessage', source, "^1 Access Denied")
        end
      else 
        if IsPlayerAceAllowed(source, "framework.priorty") then
          hold_status = true
          TriggerClientEvent('SERGEANTNORTH:HOLDPRIORTY', -1, hold_status)
        else 
          TriggerClientEvent('chatMessage', source, "^1 Access Denied")
        end
      end
    else 
      if(Config.everyone_can_use_the_priority_command == true) then
        hold_status = true
        TriggerClientEvent('SERGEANTNORTH:HOLDPRIORTY', -1, hold_status)
      else 
        if(on_duty[source].dept == Config.dept_names['civ_level']) then
          hold_status = true
          TriggerClientEvent('SERGEANTNORTH:HOLDPRIORTY', -1, hold_status)
        else 
          TriggerClientEvent('chatMessage', source, "^1 Access Denied")
        end
      end
    end
  end)

  RegisterCommand('pend', function(source, args, message)
    local length = args[1];
    if(length == nil) then length = 20 end;
    length = tonumber(length);
    if(length == nil) then return end;
    if(length == 0) then length = 20 end;
    if(length > max_time) then length = 45 end
    if(Config.admin_use_only == true) then
      if(Config.use_discord == true) then
        local pr_check = false;
        local check = false;
        for src, role in ipairs(Config.users_roles["PRIORTY"]) do
          check = IsRolePresent(source, role)
          if(check == true) then
            pr_check = true
          elseif (check == false and pr_check == true) then
            pr_check = true
          else 
            pr_check = false
          end
        end
        if(pr_check == true) then
          TriggerEvent("SERGEANTNORTH:UPDATEPRIORTYS", length);
        else 
          TriggerClientEvent('chatMessage', source, "^1 Access Denied")
        end
      else 
        if IsPlayerAceAllowed(source, "framework.priorty") then
          TriggerEvent("SERGEANTNORTH:UPDATEPRIORTYS", length);
        else 
          TriggerClientEvent('chatMessage', source, "^1 Access Denied")
        end
      end
    else 
      if(Config.everyone_can_use_the_priority_command == true) then
        TriggerEvent("SERGEANTNORTH:UPDATEPRIORTYS", length);
      else 
        if(on_duty[source].dept == Config.dept_names['civ_level']) then
          TriggerEvent("SERGEANTNORTH:UPDATEPRIORTYS", length);
        else 
          TriggerClientEvent('chatMessage', source, "^1 Access Denied")
        end
      end
    end
  end)

  RegisterNetEvent("SERGEANTNORTH:UPDATEPRIORTYS")
  AddEventHandler("SERGEANTNORTH:UPDATEPRIORTYS", function(time)   
    if priorty_status == true then
      priorty_status = false
      TriggerClientEvent('SERGEANTNORTH:UPDATEPRIORTY', -1, priorty_status)
    end
    if hold_status == true then
      hold_status = false
      TriggerClientEvent('SERGEANTNORTH:HOLDPRIORTY', -1, hold_status)
    end
    cooldown = time + 1;
    countter()
  end)

  function countter()
    if(cooldown ~= 0) then
      while cooldown > 0 do 
        cooldown = cooldown - 1;
        TriggerClientEvent("SERGEANTNORTH:UPDATECOOLDOWN", -1, cooldown)
        Citizen.Wait(60000)
      end
    end
  end

  Citizen.CreateThread(function() 
    while true do 
      Citizen.Wait(10)
      if (cooldown == 0) then
        inactive = inactive + 1;
        TriggerClientEvent("SERGEANTNORTH:UPDATEPR", -1, inactive)
        Citizen.Wait(60000)
      else 
        inactive = 0;
        TriggerClientEvent("SERGEANTNORTH:UPDATEPR", -1, inactive)
        Citizen.Wait(30000)
      end
    end 
  end)

  RegisterNetEvent("SERGEANTNORTH:UPDATEDAPRIORTY")
  AddEventHandler("SERGEANTNORTH:UPDATEDAPRIORTY", function() 
    local src = source;
    TriggerClientEvent("SERGEANTNORTH:UPDATEVARSPRI", src, cooldown, priorty_status, hold_status, inactive, nameofthepriorty)
  end)
end


-- ADMIN CHAT -- 
if(Config.enable_admin_command == true) then
  RegisterCommand('adminchat', function(source, args, message) 
    if(on_duty[source]) then
      if(on_duty[source].admin == 1 or on_duty[source].dept == Config.dept_names["admin_level"]) then
        if(args[1] == nil) then return end
        for _, player in ipairs(GetPlayers()) do
          player = tonumber(player)
          if(on_duty[player]) then
            if(on_duty[source].admin == 1 or on_duty[player].dept == Config.dept_names['admin_level']) then 
                TriggerClientEvent('chatMessage', player, '[^6ADMIN^0] ^3' .. GetPlayerName(source) .. ":^0 " .. table.concat(args, " "))
            end
          end
        end
      else 
        TriggerClientEvent('chatMessage', source, "Access denied.")
      end
    end
  end)
end

-- PEACETIME -- 
if(Config.enable_peacetime == true) then
  local peacetime = false;
  RegisterCommand('pt', function(source, args, message)
    if(on_duty[source]) then
      if(on_duty[source].admin == 1 or on_duty[source].dept == Config.dept_names["admin_level"]) then
        if(peacetime == true) then
          TriggerClientEvent("SERGEANTNORTH:CHANGEPT", -1, false)
          TriggerClientEvent("SERGEANTNORTH:PEACETIMENOT", -1, "Peace time has been ~g~Disabled")
          peacetime = false;
          sendToDiscord(000000, GetPlayerName(source) .. " [#" .. source .. "]", "has disabled peacetime!")
        else 
          TriggerClientEvent("SERGEANTNORTH:CHANGEPT", -1, true)
          TriggerClientEvent("SERGEANTNORTH:PEACETIMENOT", -1, "Peace time has been ~r~Enabled")
          peacetime = true;
          sendToDiscord(000000, GetPlayerName(source) .. " [#" .. source .. "]",  "has enabled peacetime!")
        end
      else 
        TriggerClientEvent('chatMessage', source, "^1 Access Denied")
      end
    end
  end)

  RegisterNetEvent("SERGEANTNORTH:UPDATEDUMBPEACETIME")
  AddEventHandler("SERGEANTNORTH:UPDATEDUMBPEACETIME", function()
    local src = source;
    TriggerClientEvent('SERGEANTNORTH:CHANGEPT', src, peacetime)
  end)
end

if(Config.enable_chat_clear == true) then
  RegisterCommand("clearchat", function(source, args) 
      if(on_duty[source]) then
        if(on_duty[source].admin == 1 or on_duty[source].dept == Config.dept_names["admin_level"]) then
          TriggerClientEvent("chat:clear", -1)
          Citizen.Wait(10)
          TriggerClientEvent('chatMessage', -1, "[^3SYSTEM^0] Chat has been cleared by an admin")
          sendToDiscord(000000, GetPlayerName(source) .. " [#" .. source .. "]",  "has cleared the chat!")
        else 
          TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Access Denied")
        end
      end
  end, false)
end

-- PANIC SYSTEM --
if(Config.enable_panic_system == true) then
  RegisterCommand('panic', function(source, args, message) 
    if(on_duty[source].dept == Config.dept_names['civ_level']) then
      TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Access Denied")
    else 
      local src = source
      local ped = GetPlayerPed(src)
      local coords = GetEntityCoords(ped)
      local postal = getPlayerLocation(src)
      local fix = "^1[PANIC] ^0" .. on_duty[source].char_name .. " [" .. on_duty[source].dept .. "]"
      for _, player in ipairs(GetPlayers()) do
        player = tonumber(player)
        if(on_duty[player]) then
          if(on_duty[player].dept == Config.dept_names['civ_level']) then return end
          TriggerClientEvent('SERGEANTNORTH:PANICPRESSED', player, coords, fix, postal)
        end
      end
    end
  end)
end

-- DOOR LOCK -- 
if(Config.enable_door_lock == true) then
  RegisterNetEvent('SERGEANTNORTH:getDoorState')
  AddEventHandler('SERGEANTNORTH:getDoorState', function() 
    TriggerClientEvent('SERGEANTNORTH:returnDoorState', -1, Config_doors.DoorList)
  end)

  RegisterNetEvent('SERGEANTNORTH:CheckPermsDoor')
  AddEventHandler('SERGEANTNORTH:CheckPermsDoor', function(doorV, state)
    local player = source;
    local check = checkperms(Config_doors.DoorList[doorV], player)
    if(check == true) then
      if(Config_doors.DoorList[doorV].locked == true) then
        Config_doors.DoorList[doorV].locked = false
        TriggerClientEvent('SERGEANTNORTH:setDoorState', -1, doorV, false)
      elseif(Config_doors.DoorList[doorV].locked == false)  then
        Config_doors.DoorList[doorV].locked = true  
       TriggerClientEvent('SERGEANTNORTH:setDoorState', -1, doorV, true)
      end
    end
  end)
end

-- REVIVE -- 
if(Config.enable_revive_all == true and Config.enable_death_system == true) then
  RegisterCommand('reviveall', function(source, args, message) 
    if(on_duty[source]) then
      if(on_duty[source].admin == 1 or on_duty[source].dept == Config.dept_names["admin_level"]) then
        sendToDiscord(0000000, GetPlayerName(source) .. " [#" .. source .. "]", "Has revived all the players.")
        for _, player in ipairs(GetPlayers()) do
          player = tonumber(player)
          TriggerClientEvent('SERGEANTNORTH:REVIVEALLUSERS', player)  
        end
      else 
        TriggerClientEvent('chatMessage', source, "^1 Access Denied")
      end
    else 
      TriggerClientEvent('chatMessage', source, "^1 Access Denied")
    end
  end)

end

if(Config.use_discord == true) then
  if (Config.enable_whitelist == true or Config.discord_ban_checker == true)then
    AddEventHandler('playerConnecting', function(name, setKickReason, deferrals) 
      local src = source
      local discord = getdiscordid(src)
      local steamid = GetPlayerIdentifier(src)
      deferrals.defer();
      deferrals.update("Please wait while we check your information.")
      local whitelist, banned, reason = checksuserstate(discord)
      if(banned == true) then
        deferrals.done(reason)
        sendToDiscord(0000000, "Player connection rejected", "**Steam Hex:** " ..steamid.. "\n**Discord ID:** " ..formatdiscord(discord).. "\n**Reason:**\n" .. reason)
      elseif (whitelist == false) then
        deferrals.done(Config.notwhitelisted_msg)
        sendToDiscord(0000000, "Player connection rejected", "**Steam Hex:** " ..steamid.. "\n**Discord ID:** " ..formatdiscord(discord).. "\n**Reason:**\n" .. Config.notwhitelisted_msg)
      else 
        deferrals.done()
      end
    end)
  end
end


if(Config.call_admin == true) then
  RegisterCommand('calladmin', function(source, args, messag) 
    local src = source
    local postal = getPlayerLocation(src)
    for _, player in ipairs(GetPlayers()) do
      player = tonumber(player)
      if(on_duty[player]) then
        if(on_duty[source].admin == 1 or on_duty[player].dept == Config.dept_names["admin_level"]) then
          TriggerClientEvent('chatMessage', player, "[^1STAFF^0] " .. GetPlayerName(src) .. " [#" .. source .. "] has called an admin. There nearst postal is " .. postal .. ". To respond to them please do /telp " .. src)
        end
      end
    end
    TriggerClientEvent('chatMessage', src, "^3You have successfully called an admin!")
    sendToDiscord(00000, GetPlayerName(src) .. " [#" .. src .. "]", "Has called an admin!")
  end)
end

if(Config.enable_tp_command == true) then
  RegisterCommand('telp', function(source, args, messag) 
    local src = source
    if(on_duty[src]) then
      if(on_duty[source].admin == 1 or on_duty[src].dept == Config.dept_names["admin_level"]) then
        if(args[1] == nil or tonumber(args[1]) == nil) then
          TriggerClientEvent('chatMessage', src, "[^3SYSTEM^0] Please provide an ID to teleport to.")
        else 
          local player = tonumber(args[1])
          local testname = GetPlayerName(player)
          if(testname == nil) then
            TriggerClientEvent('chatMessage', src, "^1You have entred an invalid player!")
          else 
            if(player == src) then
              TriggerClientEvent('chatMessage', src, "[^1STAFF^0] You cannot teleport to your self!")
            else 
              local ped = GetPlayerPed(player)
              local playerCoords = GetEntityCoords(ped)
              local fix = GetPlayerName(player) .. " [#" .. player .. "]"
              TriggerClientEvent("SERGEANTNORTH:TPADMINTOSOMEONE", src, fix, playerCoords)
            end
          end
        end
      else 
        TriggerClientEvent('chatMessage', source, "^1 Access Denied")
      end
    else 
      TriggerClientEvent('chatMessage', source, "^1 Access Denied")
    end
  end)
end


-- exports for the other scripts to work--
exports('getdept', function(id) 
  if(on_duty[id]) then
    return on_duty
  else 
    return nil
  end
end)

exports('geteverything', function() 
  return on_duty
end)

exports('getconfig', function() 
  return Config
end)


exports('sendtothediscord', function(color, name, message) 
  sendToDiscord(color, name, message)
end)
