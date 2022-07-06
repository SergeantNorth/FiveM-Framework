-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

fx_version 'adamant'
game 'gta5'
author 'SergeantNorth Productions'

files {
	'html/index.html',
	'html/assets/css/*.css',
	'html/assets/js/*.js',
	'html/assets/fonts/roboto/*.woff',
	'html/assets/fonts/roboto/*.woff2',
	'html/assets/fonts/justsignature/JustSignature.woff',
	'html/assets/images/*.png'
}

ui_page 'html/index.html'

shared_scripts {
	'config.lua'
}

client_script {
	'client/emotes.lua',
	'client/client.lua',
}

server_script {
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}

