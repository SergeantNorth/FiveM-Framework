fx_version 'adamant'
author 'SergeantNorth Productions'

game 'gta5'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/js/script.js',
    'html/css/main.css',
    'html/css/bootstrap.min.css',
    'html/css/bootstrap.min.css.map',
    'html/js/bootstrap.min.js',
    'html/js/bootstrap.min.js.map',
}

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
