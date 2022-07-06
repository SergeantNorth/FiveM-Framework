Citizen.CreateThread(function()
    if(Config.version_check == true) then
      local currentVersion = Config.version;
        function version_return(err, response)
          Citizen.Wait(4000)
          if(err == 200) then
            local comeback = json.decode(response)
            if(currentVersion ~= comeback.version) then
              print("^3[SERGEANTNORTH PRODUCTIONS | VERSION CHECKER]^1 You have an outdated version of the framework. ^0Please contact the creator of the framework ^3SergeantNorth#1650^0 or you can check ^1#client-news^0 in ^1https://discord.gg/sergeantnorth^0")
              print("^5Change logs:^0\n" .. comeback.change_logs)
              sendToDiscord(000000, "Version Check | SERGEANTNORTH PRODUCTIONS", "You have an outdated version check #client-news for the update or contact SergeantNorth#1650")
            else
              print("^3[SERGEANTNORTH PRODUCTIONS] ^0You are up to date with the framework\nThis framework was made by ^1SergeantNorth#1650^0. If you are in need of support please join the support server ^1https://discord.gg/sergeantnorth^0")
            end
          end
        end
        PerformHttpRequest("https://sergantnorth.tk/framework/version.json", version_return, 'GET')
    end
    MySQL.ready(function()
      MySQL.Async.fetchAll("SELECT * FROM characters WHERE id LIKE @id", {["@id"] = "%"}, function(data)
        if(data == nil) then
          MySQL.Async.execute("CREATE TABLE characters (id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, discord varchar(50) DEFAULT NULL, steamid varchar(50) DEFAULT NULL, first_name varchar(50) DEFAULT NULL, last_name varchar(50) DEFAULT NULL, twitter_name varchar(50) DEFAULT NULl, dob varchar(50) DEFAULT NULL, gender varchar(50) DEFAULT NULL, dept varchar(50) DEFAULT NULL);")
          Citizen.Wait(1000)
          print("[^1TABLE characters missing^0] The table characters was not found within the database. I have automatically created it for you!")
        else 
          MySQL.Async.fetchAll("SELECT characters.twitter_name FROM characters WHERE id LIKE @id", {["@id"] = "%"}, function(check)
            if(check == nil) then
              MySQL.Async.execute("ALTER TABLE `characters` CHANGE COLUMN `twotter_name` `twitter_name` VARCHAR(50) DEFAULT NULL AFTER `last_name`")
              Citizen.Wait(1000)
              print("[^1TABLE characters error^0] The column twotter_name was removed in version 1.3 I have automatically changed it's name to twitteR_name it for you!")
            end
          end)
        end
      end)
      MySQL.Async.fetchAll("SELECT * FROM char_playing WHERE discord LIKE @char", {["@char"] = "%"}, function(seconddata)
        if(seconddata == nil) then
          MySQL.Async.execute("CREATE TABLE char_playing (discord varchar(50) DEFAULT NULL, steamid varchar(50) DEFAULT NULL, char_name varchar(50) DEFAULT NULL, twitter_name varchar(50) DEFAULT NULL, dob varchar(50) DEFAULT NULL, gender varchar(50) DEFAULT NULL, dept varchar(50) DEFAULT NULL);")
          Citizen.Wait(1000)
          print("[^1TABLE char_playing missing^0] The table char_playing was not found within the database. I have automatically created it for you!")
        else 
          MySQL.Async.fetchAll("SELECT char_playing.twitter_name FROM char_playing WHERE discord LIKE @id", {["@id"] = "%"}, function(test)
            if(test == nil) then
              MySQL.Async.execute("ALTER TABLE `char_playing` CHANGE COLUMN `twotter_name` `twitter_name` VARCHAR(50) DEFAULT NULL AFTER `char_name`")
              Citizen.Wait(1000)
              print("[^1TABLE char_playing error^0] The column twotter_name was removed in version 1.3 I have automatically changed it's name to twitter_name it for you!")
            end
          end)
        end
      end)
      MySQL.Async.fetchAll("SELECT * FROM characters_settings WHERE discord LIKE @randomchar", {["@randomchar"] = "%"}, function(seconddata)
        if(seconddata == nil) then
          MySQL.Async.execute("CREATE TABLE characters_settings(discord varchar(50) DEFAULT NULL,steamid varchar(50) DEFAULT NULL,dark_mode varchar(50) DEFAULT \"1\",cloud_spawning varchar(50) DEFAULT \"1\",image_slideshow varchar(50) DEFAULT \"0\",character_gardient_color varchar(50) DEFAULT \"#DDADF3|#582185\",refresh_gardient_color varchar(50) DEFAULT \"#3E3BDF|#6529C5\",settings_gardient_color varchar(50) DEFAULT \"#1792DA|#49C06D\",disconnect_gardient_color varchar(50) DEFAULT \"#FF0000|#EB7F27\");")
          Citizen.Wait(1000)
          print("[^1TABLE characters_settings missing^0] The table characters_settings was not found within the database. I have automatically created it for you!")
        end
      end)
    end)
end)

