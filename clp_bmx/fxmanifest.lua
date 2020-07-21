fx_version 'adamant'
games { 'gta5' };

-- Bmx item created by Clippy#2929
-- Do not change trigger

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "sv_bmx.lua",
}

client_scripts {
    '@es_extended/locale.lua',
    'locales/fr.lua',
    "cl_bmx.lua",
}


