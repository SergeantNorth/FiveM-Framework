-- I AM NOT THE CREATOR OF THIS. I AM JUST USING IT YOU CAN FIND THE PUBLIC SCRIPT HERE https://github.com/sadboilogan/discord_perms/blob/master/discord_perms/ -- 

if(Config.use_discord ==  true) then
    local FormattedToken = "Bot "..Config_s.bot_token 

    function DiscordRequest(method, endpoint, jsondata)
        local data = nil
        PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
            data = {data=resultData, code=errorCode, headers=resultHeaders}
        end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})
    
        while data == nil do
            Citizen.Wait(0)
        end
        
        return data
    end
    
    function IsRolePresent(user, role)
        local discordId = nil
        for _, id in ipairs(GetPlayerIdentifiers(user)) do
            if string.match(id, "discord:") then
                discordId = string.gsub(id, "discord:", "")
                break
            end
        end
    
        local theRole = nil
        if type(role) == "number" then
            theRole = tostring(role)
        else
            theRole = role
        end
        if discordId then
            local endpoint = ("guilds/%s/members/%s"):format(Config.server_id, discordId)
            local member = DiscordRequest("GET", endpoint, {})
            Citizen.Wait(100)
            if member.code == 200 then
                local data = json.decode(member.data)
                local roles = data.roles
                local quickcheck = checkroles(roles, theRole)
                return quickcheck
            else
                return false
            end
        else
            return false
        end
    end
    
    Citizen.CreateThread(function()
        local guild = DiscordRequest("GET", "guilds/"..Config.server_id, {})
        if guild.code == 200 then
            local data = json.decode(guild.data)
            print("Permission system guild set to: "..data.name.." ("..data.id..")")
        else
            print("An error occured, please check your config and ensure everything is correct (Discord bot token). Error: "..(guild.data or guild.code)) 
        end
    end)

    function checksuserstate(id)
        local banned = false
        local discordid = id
        local endpoint = ""
        if(Config.enable_whitelist == true and Config.discord_ban_checker == true) then
            endpoint = ("guilds/%s/bans/%s"):format(Config.server_id, discordid)
        elseif (Config.discord_ban_checker == true) then 
            endpoint = ("guilds/%s/bans/%s"):format(Config.server_id, discordid)
        else 
            endpoint = ("guilds/%s/members/%s"):format(Config.server_id, discordid)
        end
        Citizen.Wait(50)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            if(Config.discord_ban_checker == true) then
                banned = true
               
                local data = json.decode(member.data)
                local reason = ""

                if(data.reason == nil) then
                    reason = Config.ban_default_message
                else 
                    reason = data.reason
                end
    
                return false, true, reason
            elseif (Config.enable_whitelist == true) then
                local data = json.decode(member.data)
                local rolescheck = checkroles(data.roles, Config.whitelist_role)
                return rolescheck, false, false
            end
        elseif (member.code == 404) then
            if(Config.enable_whitelist == true) then
                endpoint = ("guilds/%s/members/%s"):format(Config.server_id, discordid)
                Citizen.Wait(50)
                local callback = DiscordRequest("GET", endpoint, {})
                if callback.code == 200 then
                    local data = json.decode(callback.data)
                   
                    local rolescheck = checkroles(data.roles, Config.whitelist_role)
                    
                    return rolescheck, false, false
                else
                    return false, false, false
                end
            else 
                return true, false, false
            end
        end
    end


    function checkroles(allroles, role)
        local check = false
        for i=1, #allroles do
            if allroles[i] == role then
                check = true
            end
        end
        return check
    end
end

