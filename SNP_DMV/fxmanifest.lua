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
    'html/js/script.js',
    'html/css/main.css',
    'html/css/bootstrap.min.css',
    'html/css/bootstrap.min.css.map',
    'html/js/jquery-3.4.1.min.js',
    'html/js/bootstrap.min.js',
    'html/js/bootstrap.min.js.map',
}

shared_scripts {
    'config.lua'
}

client_script {
    'client/client.lua',
}

server_script {
	'config_server.lua',
    '@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}
