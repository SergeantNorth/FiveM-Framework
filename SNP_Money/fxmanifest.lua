-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

fx_version 'cerulean'
games { 'gta5' }
author 'SergeantNorth Productions'


shared_scripts {
    'config.lua'
}

client_script {
    'client/client.js',
}

server_script {
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}

server_export {
    'getaccount',
    'updateaccount',
    'bankNotify',
    'sendmoney'
}
client_export {
    'getclientaccount',
}