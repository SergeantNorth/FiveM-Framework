-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

RegisterNetEvent("SERGEANTNORTH:SENDNOT")
AddEventHandler("SERGEANTNORTH:SENDNOT", function(primary, displaytext, class, plate, speed)
    TriggerClientEvent("SERGEANTNORTH:NOTIFY", -1, source, primary, displaytext, class, plate, speed)
end)


RegisterServerEvent('SERGEANTNORTH:SERVERPLAY')
AddEventHandler('SERGEANTNORTH:SERVERPLAY', function(soundFile, soundVolume)
    TriggerClientEvent('SERGEANTNORTH:PLAYSOUND', source, soundFile, soundVolume)
end)
