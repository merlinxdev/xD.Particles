-- NC PROTECT+
shared_scripts { '@nc_PROTECT+/exports/protected.lua', '@nc_PROTECT+/exports/sh.lua' }

fx_version 'cerulean'
games { 'gta5' }

author 'Merlin.xD'
description 'Sample Particles Effect By xD Studio'
version '1.0.0'

shared_script 'config/config.setting.lua'
client_scripts {
    'particles/*.lua',
    'core/client.lua',
    'core/util/class.*.lua',
}

server_scripts {'core/crack.lua','core/server.lua'}

lua54 'yes'

ui_page 'interface/ui.html'
files {
  'interface/ui.html',
  'interface/assets/js/*.js',
  'interface/assets/css/*.css'
}