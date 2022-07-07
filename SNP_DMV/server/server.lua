-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

if (GetCurrentResourceName() ~= "SNP_DMV") then
    print("[^1DEBUG^0] Please make sure the resource name is ^3SNP_DMV^0 or else exports won't work.")
end

RegisterCommand(config.command, function(source, args, message) 
    local player = getstuff(source)
    local name = SpaceBet(player[source].char_name)
    selectEver(source, player, name, false)
end)

RegisterNetEvent('SERGEANTNORTH:DELETEVEHICLE')
AddEventHandler('SERGEANTNORTH:DELETEVEHICLE', function(id, plat) 
    local src = source
    local discord = ""
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
		if string.match(v, 'discord:') then
			discord = string.sub(v, 9)
        end
	end
    Citizen.Wait(20)
    local player = getstuff(src)
    MySQL.Async.execute('DELETE FROM vehicle WHERE vecid = @id', {["@id"] = id})
    Citizen.Wait(50)
    local name = SpaceBet(player[src].char_name)
    if(config_s.use_hamz_cad) then
        PerformHttpRequest(config_s.website_url .. "api/deletevehicle/?discordid=" .. discord .. "&plate=" ..plat.. "&secret=" .. config_s.secret_key, value, 'POST')
    end
    selectEver(src, player, name, true)
end)

RegisterNetEvent('SERGEANTNORTH:CREATEVEHCILE')
AddEventHandler('SERGEANTNORTH:CREATEVEHCILE', function(color, plat, type, modal) 
    local discord = '';
    local src = source
    local player = getstuff(src)
    local steam = GetPlayerIdentifier(source, 0) 
	for k,v in ipairs(GetPlayerIdentifiers(src)) do
		if string.match(v, 'discord:') then
			discord = string.sub(v, 9)
		end
	end
    local name = SpaceBet(player[src].char_name)
    local vehiclename = SpaceBet(color)
    if(vehiclename.second ~= "") then
        if(vehiclename.forth ~= "") then
            vehiclename = vehiclename.first .. "%20" .. vehiclename.second .. "%20" .. vehiclename.third .. "&20" .. vehiclename.forth
        elseif(vehiclename.third ~= "") then
            vehiclename = vehiclename.first .. "%20" .. vehiclename.second .. "%20" .. vehiclename.third
        elseif(vehiclename.second ~= "") then
            vehiclename = vehiclename.first .. "%20" .. vehiclename.second
        else 
            vehiclename = vehiclename.first
        end
    else 
        vehiclename = vehiclename.first
    end

    local getshit = getFrameworkid(steam, name)
    local fixedGender = "M"
    if(player[src].gender == "Male") then
      fixedGender = "M"
    else 
      fixedGender = "F"
    end

    Citizen.Wait(20)
    MySQL.Async.fetchAll('SELECT * FROM vehicle WHERE plate = @plate', {["@plate"] = plat}, function(data) 
        if(data[1] ~= nil) then
            if(data[1].plate == plat) then
                TriggerClientEvent('chatMessage', src, '[^3SYSTEM^0] You cannot register this vehicle due to the plate being used by another user. Please chose another plate number.')
                TriggerClientEvent('SERGEANTNORTH:OPENDMV', src, "closeui", data, player[src].char_name, false)
            else 
                Citizen.Wait(20)
                if(config_s.use_hamz_cad) then
                    PerformHttpRequest(config_s.website_url .. "api/createvehicle/?discordid=" .. discord .. "&name=" .. name.first .. "%20" .. name.second .. "&plate=" ..plat..  "&model=" .. modal .. "&color=" .. vehiclename .. "&secret=" .. config_s.secret_key, value, 'POST')
                end
                MySQL.Async.execute('INSERT INTO vehicle (first, last, discord, id, steam, type, color, plate) VALUES (@first, @last, @discord, @shit, @steam, @type, @color, @plate)', {["@first"] = name.first, ["@last"] = name.second, ["@shit"] = getshit, ["@discord"] = discord, ["@steam"] =  steam, ["@type"] = modal, ["@color"] = color, ["@plate"] = plat})
                Citizen.Wait(50)
                selectEver(src, player, name, true)
            end
        else 
            if(config_s.use_hamz_cad) then
                PerformHttpRequest(config_s.website_url .. "api/createvehicle/?discordid=" .. discord .. "&name=" .. name.first .. "%20" .. name.second .. "&plate=" ..plat..  "&model=" .. modal .. "&color=" .. vehiclename .. "&secret=" .. config_s.secret_key, value, 'POST')
            end
            if(config_s.use_sonorancad) then            
                local data = {
                    ["id"] = config_s.sonorancad_id,
                    ["key"] = config_s.sonorancad_apiKey,
                    ["type"] = "NEW_RECORD",
                    ["data"] = {
                      {
                        ["user"] = string.gsub(steam, "steam:", ""),
                        ["useDictionary"] = true,
                        ["recordTypeId"] = 5,
                        ["replaceValues"] = {
                            ["first"] = name.first,
                            ["last"] = name.last,
                            ["dob"] = player[src].dob,
                            ["sex"] = fixedGender,
                            ["make"] = type,
                            ["plate"] = plat,
                            ["color"] = color,
                            ["model"] = modal
                        },
                      }
                    }
                }

                PerformHttpRequest(config_s.sonoranLink .. "general/new_record", function(errorCode, resultData, resultHeaders)
                    local errorCode = tostring(errorCode)
                    if(errorCode ~= "200") then
                      print("There was an error executing an API call to sonoran. [CREATE VEHICLE] Error code: " .. errorCode)
                    end
                  end, "POST", json.encode(data))
            end
            MySQL.Async.execute('INSERT INTO vehicle (first, last, discord, id, steam, type, color, plate) VALUES (@first, @last, @discord, @shit, @steam, @type, @color, @plate)', {["@first"] = name.first, ["@last"] = name.second, ["@shit"] = getshit, ["@discord"] = discord, ["@steam"] =  steam, ["@type"] = modal, ["@color"] = color, ["@plate"] = plat})
            Citizen.Wait(50)
            selectEver(src, player, name, true)
        end
    end)
end)


-- needs to be done -- 
Citizen.CreateThread(function()
    MySQL.ready(function() 
        MySQL.Async.fetchAll("SELECT * FROM vehicle WHERE discord LIKE @char", {["@char"] = "%"}, function(data)
            if(data == nil) then
                MySQL.Async.execute('CREATE TABLE vehicle(vecid INT PRIMARY KEY NOT NULL AUTO_INCREMENT, id varchar(255) DEFAULT NULL, first varchar(255) DEFAULT NULL, last varchar(255) DEFAULT NULL, discord varchar(255) DEFAULT NULL, steam varchar(255) DEFAULT NULL, type varchar(255) DEFAULT NULL, color varchar(255) DEFAULT NULL, plate varchar(255) DEFAULT NULL, date varchar(255) DEFAULT "unknown");')
                Citizen.Wait(1000)
                print("[^1TABLE vehicle missing^0] The table vehicle was not found within the database. I have automatically created it for you!")
            end
        end)
    end)
end)

function selectEver(id, shit, value, state)
    MySQL.Async.fetchAll('SELECT * FROM vehicle WHERE steam = @steam AND first = @first AND last = @last', {["@steam"] = GetPlayerIdentifier(id, 0), ["@first"] = value.first, ["@last"] = value.second}, function(cars) 
        TriggerClientEvent('SERGEANTNORTH:OPENDMV', id, "dmv_open", cars, shit[id].char_name, state)
    end)
end

function getFrameworkid(steam, value) 
    local id = nil
    MySQL.Async.fetchAll('SELECT * FROM characters WHERE steamid = @steam AND first_name = @first AND last_name = @last', {["@steam"] = steam, ["@first"] = value.first, ["@last"] = value.second}, function(data) 
        id = data[1].id
    end)
    Citizen.Wait(100)
    return id
end

function SpaceBet(name) 
    local num = 0
    local words = {first = "", second = "", third = "", forth = ""}
    local pattern = "%S+"
    for word in string.gmatch(name, pattern) do
        if(words.first == "") then
            words.first = word
        elseif(words.second == "") then
            words.second = word
        elseif(words.third == "") then
            words.third = word
        elseif(words.forth == "") then
            words.forth = word
        end
    end
    return words
end
