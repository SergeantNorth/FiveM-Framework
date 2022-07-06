-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

-- CHAT SUGGESTIONS -- 
Citizen.CreateThread(function()
    if(Config.enable_ooc_command) then
      TriggerEvent('chat:addSuggestion', '/ooc', 'Out Of Character chat Message. (Global Chat)', {
        { name="Message", help="ooc"}
      })
    end
  
    if(Config.enable_me_command) then
      TriggerEvent('chat:addSuggestion', '/me', 'Send message in the third person. (Proximity Chat)', {
        { name="Action", help="action."}
      })
    end
  
    if(Config.enable_mer_command) then
      TriggerEvent('chat:addSuggestion', '/mer', 'Send message in red text. (Proximity Chat)', {
        { name="Action", help="mer command"}
      })
    end
  
    if(Config.enable_gme_command) then
      TriggerEvent('chat:addSuggestion', '/gme', 'Send message in the third person. (Global Chat)', {
        { name="Action", help="action."}
      })
    end
  
    if(Config.enable_do_command) then
      TriggerEvent('chat:addSuggestion', '/do', 'Send action message. (Proximity Chat)', {
        { name="Action", help="action."}
      })
    end
  
    if(Config.enable_twt_command) then
      TriggerEvent('chat:addSuggestion', '/twitter', 'Send a Twotter in game. (Global Chat)', {
        { name="Message", help="Twotter Message."}
      })
    end
  
    if(Config.enable_darkweb_command) then
      TriggerEvent('chat:addSuggestion', '/darkweb', 'Send a anonymous message. (Global Chat)', {
        { name="Message", help="darkweb message."}
      })
    end
  
    if(Config.enable_radio_command) then
      TriggerEvent('chat:addSuggestion', '/radiochat', 'Send a radio message to all on duty LEOS. (Department Chat)', {
        { name="Message", help="radio command."}
      })
    end
   
    if(Config.enable_dob_command) then
      TriggerEvent('chat:addSuggestion', '/dob', 'Displays your characters date of birth', {
        { name="None", help="date of birth command."}
      })
    end
  
    if(Config.enable_whoami_command) then
      TriggerEvent('chat:addSuggestion', '/whoami', 'Displays your characters name and department', {
        { name="None", help="whoami command"}
      })
    end
  
  
    if(Config.tasercarts == true) then 
      TriggerEvent('chat:addSuggestion', '/reload', 'Reloads your taser cart', {
        { name="None", help="reload cart."}
      })
    
      TriggerEvent('chat:addSuggestion', '/rc', 'Reloads your taser cart', {
        { name="None", help="reload cart."}
      })
    end
    
    if(Config.enable_loadout_command == true) then
      TriggerEvent('chat:addSuggestion', '/loadout', 'Gives LEO their loadout', {
        { name="None", help="give leo a loadout."}
      })
    end
  
    if(Config.enable_ems_command) then
      TriggerEvent('chat:addSuggestion', '/ems', 'Out Of Character chat Message. (Global Chat)', {
        { name="Message", help="Put your questions or help request."}
      })
    
    end
   
    if(Config.enable_911_command) then
      TriggerEvent('chat:addSuggestion', '/911', 'Make a phone call to 911', {
        { name="Message", help="Make a phone call to 911"}
      })
    end
   
    if(Config.enable_blips == true) then
      TriggerEvent('chat:addSuggestion', '/blip', 'Turns on your LEO blip', {
        { name="On/Off", help="Turns on your LEO blip"}
      })
    end
  
    if(Config.enable_priority == true) then
      TriggerEvent('chat:addSuggestion', '/pstart', 'starts a priorty', {
        { name="None", help="starts a priorty"}
      })
  
      TriggerEvent('chat:addSuggestion', '/pend', 'ends a priorty', {
        { name="Time", help="ends a priorty"}
      })
  
      TriggerEvent('chat:addSuggestion', '/phold', 'holds a priorty', {
        { name="None", help="holds a priorty"}
      })

      TriggerEvent('chat:addSuggestion', '/phud', 'Shows/disables the hud', {
        { name="None", help="hud stuff"}
      })
    end
    if(Config.clearweapons_command == true) then
      TriggerEvent('chat:addSuggestion', '/clear', 'Clears your weapons', {
        { name="None", help="Clears your weapons"}
      })
    end
    if(Config.enable_aop == true) then
      TriggerEvent('chat:addSuggestion', '/aop', 'Changes AOP', {
        { name="Area of Patrol", help="Changes AOP"}
      })
  
      TriggerEvent('chat:addSuggestion', '/checkaop', 'Checks aop', {
        { name="None", help="checks aop"}
      })

      TriggerEvent('chat:addSuggestion', '/aophud', 'Disables/Enables AOP HUD', {
        { name="None", help="aop hud."}
      })
    end
  
    if(Config.enable_peacetime == true) then
      TriggerEvent('chat:addSuggestion', '/pt', 'Enables/disables peacetime', {
        { name="None", help="Enables/disables peacetime"}
      })
      TriggerEvent('chat:addSuggestion', '/pthud', 'Enables/disables peacetime hud.', {
        { name="None", help="Shows the peacetime hud."}
      })
      
    end
  
    if(Config.enable_chat_clear == true) then
      TriggerEvent('chat:addSuggestion', '/clearchat', 'Clears chat', {
        { name="None", help="Clears chat"}
      })
    end

    if(Config.enable_admin_command == true) then
      TriggerEvent('chat:addSuggestion', '/adminchat', 'Admin Chat', {
        { name="Message", help="Admin chat"}
      })
    end

    if(Config.enable_revive_all == true) then
      TriggerEvent('chat:addSuggestion', '/reviveall', 'Revives all users', {
        { name="Message", help="Revive All"}
      })
    end

    if(Config.call_admin == true) then
      TriggerEvent('chat:addSuggestion', '/calladmin', 'Call an admin!', {
        { name="None", help="calls admin"}
      })
    end

    if(Config.enable_tp_command == true) then
      TriggerEvent('chat:addSuggestion', '/telp', 'TP to a player', {
        { name="ID", help="tp"}
      })
    end
end)