-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

RegisterNetEvent('SERGEANTNORTH:SENTID')
AddEventHandler('SERGEANTNORTH:SENTID', function(id)
	local src = source
	local playerdata = exports[Config.framework_name]:getdept(src)
	if(playerdata ~= nil) then
		TriggerClientEvent("NAT2K15:OPENIDUI", id, src, playerdata[src].char_name, playerdata[src].gender, playerdata[src].dob)
	end
end)
  
-- coming soon -- 
-- RegisterNetEvent('SERGEANTNORTH:MUGSHOTCREATED')
-- AddEventHandler('SERGEANTNORTH:MUGSHOTCREATED', function(id, name, gender, dob, txd) 
-- 	local src = source
-- 	TriggerClientEvent("SERGEANTNORTH:OPENIDUI", id, src, name, gender, dob, txd)
-- end)