fx_version 'adamant'
game 'gta5'
author 'SergeantNorth Productions'

files {
  'html/index.html',
  'html/css/style.css',
  'html/css/bootstrap.min.css',
  'html/js/script.js',
  'html/js/jquery-3.4.1.min.js',
  'html/js/bootstrap.min.js',
  'html/img/logo.png', 
  'html/img/background.png',
  'html/postal/postals.json'
}

ui_page 'html/index.html'

shared_scripts {
  'config/config.lua',
  'config/config_doors.lua'
}

client_scripts {
  'dependencies/NativeUI.lua',
  'client/client.lua',
  'client/function.lua',
  'client/suggestions.lua',
  'client/commands.lua',
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'config/config_server.lua',
  'dependencies/discord.lua',
  'server/function.lua',
  'server/server.lua',
  'server/version_checker.lua'
}

client_exports {
  'getclientdept'
}

server_export {
  'getdept',
  'geteverything',
  'getconfig',
}

postal_file  'html/postal/postals.json'