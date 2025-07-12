
fx_version "cerulean"

shared_script "@HzAnticheat/src/module/module.lua"
shared_script "@HzAnticheat/src/module/module.js"

file "@HzAnticheat/hzanticheat.key"

game "gta5"

version "1.0.0"


client_scripts {
    "client.lua",
}

dependencies {
    "/server:5181",
    "screenshot-basic"
}

lua54 "yes"

