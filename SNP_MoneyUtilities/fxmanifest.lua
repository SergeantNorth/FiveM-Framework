-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

fx_version 'adamant'
game 'gta5'
author 'SergeantNorth Productions'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
	'html/script.js',
	'html/img/user.png',
	'html/img/phone.png',
	'html/img/clock.png',
	'html/img/receipt.png',
	'html/img/knife.png'

}

shared_scripts {
	'config.lua'
}

client_scripts {
	'client/client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}