local on_duty = {}

-- DISCORD WEBHOOK FUNCTION --
function sendToDiscord(color, name, message)
  local embed = {
    {
      ["color"] = color,
      ["title"] = "**".. name .."**",
      ["description"] = message,
      ["footer"] = {
        ["text"] = "MADE BY SergeantNorth#1650", -- do not remove
      },
    }
  }

  PerformHttpRequest(Config_s.webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed, avatar_url = Config_s.avatar_url}), { ['Content-Type'] = 'application/json' })
end
  

if(Config.enable_chat_blocker == true) then
  function chatblacklist(str)
      local blacklist = false;
      for badword in ipairs(Config.blacklisted_words) do
          if string.match(string.lower(str), Config.blacklisted_words[badword]) then
          blacklist = true
          else 
              if(blacklist ==  true) then
              blacklist = true
              else 
              blakclist = false;
              end
          end
      end
      return blacklist
  end
end

function updatearray(something)
  on_duty = something
end

function randomchar(id)
  local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local lowerCase = "abcdefghijklmnopqrstuvwxyz"
  local numbers = "0123456789"
  local characterSet = upperCase .. lowerCase .. numbers
  local output = ""
  for	i = 1, 4 do
    local rand = math.random(#characterSet)
    output = output .. string.sub(characterSet, rand, rand)
  end
  return output
end

function getPlayerLocation(src)
  local raw = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file'))
  local postals = json.decode(raw)
  local nearest = nil
  
  local player = src
  local ped = GetPlayerPed(player)
  local playerCoords = GetEntityCoords(ped)
  
  local x, y = table.unpack(playerCoords)
  
    local ndm = -1
    local ni = -1
    for i, p in ipairs(postals) do
      local dm = (x - p.x) ^ 2 + (y - p.y) ^ 2
      if ndm == -1 or dm < ndm then
        ni = i
        ndm = dm
      end
    end
  
    if ni ~= -1 then
      local nd = math.sqrt(ndm)
      nearest = {i = ni, d = nd}
    end
    _nearest = postals[nearest.i].code
    return _nearest
end

function checkperms(door, id)  
  local perms = false
  for k, v in ipairs(door.authorizedRoles) do
    if(on_duty[id]) then
      if(on_duty[id].dept == v) then
        perms = true
      end
    end
  end
  return perms
end

function getdiscordid(id)
  local discord = ""
  for k,v in ipairs(GetPlayerIdentifiers(id)) do
		if string.match(v, 'discord:') then
			discord = string.sub(v, 9)
		end
	end  
  return discord
end

function formatdiscord(di) 
  local disoc = "<@" ..di .. "> (" .. di .. ")"
  return disoc
end

RegisterNetEvent('SERGEANTNORTH:GETPLAYERCOUNT')
AddEventHandler('SERGEANTNORTH:GETPLAYERCOUNT', function() 
  local count = playerCount()
  TriggerClientEvent('SERGEANTNORTH:UPDATEPLAYERCOUNT', -1, count)
end)

function playerCount() 
  return GetNumPlayerIndices()
end


function getchars(id, steamid, set, per, res) 
  MySQL.Async.fetchAll("SELECT * FROM characters WHERE steamid=@steamid", {["@steamid"] = steamid}, function(data1)
    TriggerClientEvent("SERGEANTNORTH:OPENUI", id, data1, set, per, res)
  end)
end