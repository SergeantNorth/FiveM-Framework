-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

fx_version "bodacious"
game "gta5"

author "SergeantNorth Productions" 


files {
    'html/index.html',
	'html/script.js',
    'html/style.css',
	'html/image/seatbelt.png',
    'html/sounds/buckle.ogg',
    'html/sounds/unbuckle.ogg',
}

ui_page 'html/index.html'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}


