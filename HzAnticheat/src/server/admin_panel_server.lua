local AdminPanelServer = {}
local systemStats = {
    playerCount = 0,
    totalBans = 0,
    totalErrors = 0,
    debugMode = false,
    devMode = false,
    protectionStatus = 'Activo'
}

local adminLogs = {}
local maxLogs = 1000

-- Función para agregar logs
local function addLog(type, message, admin)
    local logEntry = {
        timestamp = os.time(),
        type = type,
        message = message,
        admin = admin or 'Sistema'
    }
    
    table.insert(adminLogs, 1, logEntry)
    
    -- Mantener solo los últimos maxLogs
    if #adminLogs > maxLogs then
        table.remove(adminLogs, #adminLogs)
    end
end

-- Función para obtener estadísticas del sistema
local function getSystemStats()
    local players = GetPlayers()
    systemStats.playerCount = #players
    
    -- Obtener total de baneos desde el archivo JSON
    local banFile = LoadResourceFile(GetCurrentResourceName(), 'bans.json')
    if banFile then
        local bans = json.decode(banFile) or {}
        systemStats.totalBans = #bans
    end
    
    return systemStats
end

-- Función para obtener lista de baneos
local function getBanList(count)
    local banFile = LoadResourceFile(GetCurrentResourceName(), 'bans.json')
    if not banFile then
        return {}
    end
    
    local bans = json.decode(banFile) or {}
    local recentBans = {}
    
    -- Obtener los baneos más recientes
    for i = 1, math.min(count or 10, #bans) do
        table.insert(recentBans, bans[i])
    end
    
    return recentBans
end

-- Función para filtrar logs
local function getFilteredLogs(filter)
    if filter == 'all' then
        return adminLogs
    end
    
    local filteredLogs = {}
    for _, log in ipairs(adminLogs) do
        if log.type == filter then
            table.insert(filteredLogs, log)
        end
    end
    
    return filteredLogs
end

-- Eventos del cliente

-- Evento para verificar permisos de administrador
RegisterNetEvent('HzAnticheat:checkAdminPermission')
AddEventHandler('HzAnticheat:checkAdminPermission', function()
    local source = source
    
    if AdminWhitelist and AdminWhitelist.isAdmin(source) then
        TriggerClientEvent('HzAnticheat:openAdminPanelConfirmed', source)
    else
        TriggerClientEvent('HzAnticheat:adminPermissionDenied', source)
    end
end)

RegisterNetEvent('HzAnticheat:requestStats')
AddEventHandler('HzAnticheat:requestStats', function()
    local source = source
    
    if not AdminWhitelist or not AdminWhitelist.isAdmin(source) then
        return
    end
    
    local stats = getSystemStats()
    TriggerClientEvent('HzAnticheat:updateStats', source, stats)
end)

RegisterNetEvent('HzAnticheat:banPlayer')
AddEventHandler('HzAnticheat:banPlayer', function(data)
    local source = source
    local adminName = GetPlayerName(source)
    
    if not AdminWhitelist or not AdminWhitelist.isAdmin(source) then
        TriggerClientEvent('HzAnticheat:showNotification', source, 'No tienes permisos para banear jugadores', 'error')
        return
    end
    
    local playerId = tonumber(data.playerId)
    local targetPlayer = nil
    
    -- Buscar jugador por ID o nombre
    if playerId then
        targetPlayer = playerId
    else
        -- Buscar por nombre
        local players = GetPlayers()
        for _, player in ipairs(players) do
            local playerName = GetPlayerName(player)
            if playerName and string.lower(playerName):find(string.lower(data.playerId)) then
                targetPlayer = tonumber(player)
                break
            end
        end
    end
    
    if not targetPlayer or not GetPlayerName(targetPlayer) then
        TriggerClientEvent('HzAnticheat:showNotification', source, 'Jugador no encontrado', 'error')
        return
    end
    
    -- Ejecutar comando de baneo
    local duration = data.duration and data.duration > 0 and data.duration or nil
    if duration then
        ExecuteCommand(string.format('secureban %d "%s" %d', targetPlayer, data.reason, duration))
    else
        ExecuteCommand(string.format('secureban %d "%s"', targetPlayer, data.reason))
    end
    
    -- Agregar log
    addLog('bans', string.format('Jugador %s baneado por %s. Razón: %s', GetPlayerName(targetPlayer), adminName, data.reason), adminName)
    
    TriggerClientEvent('HzAnticheat:showNotification', source, 'Jugador baneado exitosamente', 'success')
    
    -- Actualizar estadísticas
    systemStats.totalBans = systemStats.totalBans + 1
end)

RegisterNetEvent('HzAnticheat:unbanPlayer')
AddEventHandler('HzAnticheat:unbanPlayer', function(data)
    local source = source
    local adminName = GetPlayerName(source)
    
    if not AdminWhitelist or not AdminWhitelist.isAdmin(source) then
        TriggerClientEvent('HzAnticheat:showNotification', source, 'No tienes permisos para desbanear jugadores', 'error')
        return
    end
    
    -- Ejecutar comando de desbaneo
    ExecuteCommand(string.format('secureunban "%s"', data.identifier))
    
    -- Agregar log
    addLog('admin', string.format('Jugador %s desbaneado por %s', data.identifier, adminName), adminName)
    
    TriggerClientEvent('HzAnticheat:showNotification', source, 'Jugador desbaneado exitosamente', 'success')
end)

RegisterNetEvent('HzAnticheat:addToWhitelist')
AddEventHandler('HzAnticheat:addToWhitelist', function(data)
    local source = source
    local adminName = GetPlayerName(source)
    
    if not AdminWhitelist or not AdminWhitelist.isAdmin(source) then
        TriggerClientEvent('HzAnticheat:showNotification', source, 'No tienes permisos para modificar la lista blanca', 'error')
        return
    end
    
    -- Ejecutar comando de whitelist
    ExecuteCommand(string.format('securewhitelist %s %s', data.type, data.name))
    
    -- Agregar log
    addLog('admin', string.format('%s "%s" agregado a la lista blanca por %s', data.type, data.name, adminName), adminName)
    
    TriggerClientEvent('HzAnticheat:showNotification', source, string.format('%s agregado a la lista blanca', data.name), 'success')
end)

RegisterNetEvent('HzAnticheat:toggleDebugMode')
AddEventHandler('HzAnticheat:toggleDebugMode', function()
    local source = source
    local adminName = GetPlayerName(source)
    
    if not AdminWhitelist or not AdminWhitelist.isAdmin(source) then
        TriggerClientEvent('HzAnticheat:showNotification', source, 'No tienes permisos para cambiar el modo debug', 'error')
        return
    end
    
    -- Alternar modo debug
    if systemStats.debugMode then
        ExecuteCommand('securedebug off')
        systemStats.debugMode = false
        addLog('admin', string.format('Modo debug desactivado por %s', adminName), adminName)
        TriggerClientEvent('HzAnticheat:showNotification', source, 'Modo debug desactivado', 'info')
    else
        ExecuteCommand('securedebug on')
        systemStats.debugMode = true
        addLog('admin', string.format('Modo debug activado por %s', adminName), adminName)
        TriggerClientEvent('HzAnticheat:showNotification', source, 'Modo debug activado', 'info')
    end
    
    -- Enviar estadísticas actualizadas
    local stats = getSystemStats()
    TriggerClientEvent('HzAnticheat:updateStats', source, stats)
end)

RegisterNetEvent('HzAnticheat:toggleDevMode')
AddEventHandler('HzAnticheat:toggleDevMode', function()
    local source = source
    local adminName = GetPlayerName(source)
    
    if not AdminWhitelist or not AdminWhitelist.isAdmin(source) then
        TriggerClientEvent('HzAnticheat:showNotification', source, 'No tienes permisos para cambiar el modo desarrollador', 'error')
        return
    end
    
    -- Alternar modo desarrollador
    if systemStats.devMode then
        ExecuteCommand('securedevmode off')
        systemStats.devMode = false
        addLog('admin', string.format('Modo desarrollador desactivado por %s', adminName), adminName)
        TriggerClientEvent('HzAnticheat:showNotification', source, 'Modo desarrollador desactivado', 'info')
    else
        ExecuteCommand('securedevmode on')
        systemStats.devMode = true
        addLog('admin', string.format('Modo desarrollador activado por %s', adminName), adminName)
        TriggerClientEvent('HzAnticheat:showNotification', source, 'Modo desarrollador activado', 'info')
    end
    
    -- Enviar estadísticas actualizadas
    local stats = getSystemStats()
    TriggerClientEvent('HzAnticheat:updateStats', source, stats)
end)

RegisterNetEvent('HzAnticheat:reloadConfig')
AddEventHandler('HzAnticheat:reloadConfig', function()
    local source = source
    local adminName = GetPlayerName(source)
    
    if not AdminWhitelist or not AdminWhitelist.isAdmin(source) then
        TriggerClientEvent('HzAnticheat:showNotification', source, 'No tienes permisos para recargar la configuración', 'error')
        return
    end
    
    -- Ejecutar comando de recarga
    ExecuteCommand('securereload')
    
    -- Agregar log
    addLog('admin', string.format('Configuración recargada por %s', adminName), adminName)
    
    TriggerClientEvent('HzAnticheat:showNotification', source, 'Configuración recargada exitosamente', 'success')
end)

RegisterNetEvent('HzAnticheat:requestBanList')
AddEventHandler('HzAnticheat:requestBanList', function(data)
    local source = source
    
    if not AdminWhitelist or not AdminWhitelist.isAdmin(source) then
        return
    end
    
    local bans = getBanList(data.count)
    TriggerClientEvent('HzAnticheat:updateBanList', source, bans)
end)

RegisterNetEvent('HzAnticheat:requestLogs')
AddEventHandler('HzAnticheat:requestLogs', function(data)
    local source = source
    
    if not AdminWhitelist or not AdminWhitelist.isAdmin(source) then
        return
    end
    
    local logs = getFilteredLogs(data.filter)
    TriggerClientEvent('HzAnticheat:updateLogs', source, logs)
end)

-- Función para incrementar errores detectados
function AdminPanelServer.incrementErrors()
    systemStats.totalErrors = systemStats.totalErrors + 1
end

-- Función para agregar log de error
function AdminPanelServer.addErrorLog(message)
    addLog('errors', message)
end

-- Función para agregar log de baneo
function AdminPanelServer.addBanLog(message, admin)
    addLog('bans', message, admin)
end

-- Inicialización
CreateThread(function()
    -- Agregar log de inicio
    addLog('admin', 'Panel de administración HzAnticheat iniciado')
    
    -- Actualizar estadísticas cada 30 segundos
    while true do
        Wait(30000)
        getSystemStats()
    end
end)

-- Comando para verificar permisos ACE
RegisterCommand('hzcheckperms', function(source, args, rawCommand)
    if source == 0 then
        print("^3[HzAnticheat] ^7Este comando solo puede ser usado por jugadores")
        return
    end
    
    local playerName = GetPlayerName(source)
    local identifiers = GetPlayerIdentifiers(source)
    
    print("^3[HzAnticheat] ^7Verificando permisos para: ^5" .. playerName .. "^7 (ID: ^5" .. source .. "^7)")
    
    -- Mostrar identificadores
    print("^3[HzAnticheat] ^7Identificadores:")
    for _, identifier in pairs(identifiers) do
        print("^3[HzAnticheat] ^7  - " .. identifier)
    end
    
    -- Verificar permisos ACE
    local hasHzAdmin = IsPlayerAceAllowed(source, "hzanticheat.admin")
    local hasSecureAdmin = IsPlayerAceAllowed(source, "secure.admin")
    local hasTxAdmin = IsPlayerAceAllowed(source, "command.tx")
    
    print("^3[HzAnticheat] ^7Permisos ACE:")
    print("^3[HzAnticheat] ^7  - hzanticheat.admin: " .. (hasHzAdmin and "^2SÍ" or "^1NO"))
    print("^3[HzAnticheat] ^7  - secure.admin: " .. (hasSecureAdmin and "^2SÍ" or "^1NO"))
    print("^3[HzAnticheat] ^7  - command.tx (txAdmin): " .. (hasTxAdmin and "^2SÍ" or "^1NO"))
    
    -- Verificar con AdminWhitelist
    local isAdmin = false
    if AdminWhitelist and AdminWhitelist.isAdmin then
        isAdmin = AdminWhitelist.isAdmin(source)
    end
    
    print("^3[HzAnticheat] ^7AdminWhitelist.isAdmin(): " .. (isAdmin and "^2SÍ" or "^1NO"))
    
    -- Enviar mensaje al jugador
    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 255},
        multiline = true,
        args = {"[HzAnticheat]", "Verificación de permisos completada. Revisa la consola del servidor para más detalles."}
    })
end, false)

-- Comando para diagnosticar configuración de permisos
RegisterCommand('hzdiagperms', function(source, args, rawCommand)
    if source == 0 then
        print("Este comando solo puede ser usado por jugadores")
        return
    end
    
    local player = GetPlayerName(source)
    local identifiers = {}
    
    -- Obtener todos los identificadores del jugador
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local identifier = GetPlayerIdentifier(source, i)
        table.insert(identifiers, identifier)
    end
    
    print("\n=== DIAGNÓSTICO DE PERMISOS ===")
    print("Jugador: " .. player .. " (ID: " .. source .. ")")
    print("Identificadores:")
    for _, id in ipairs(identifiers) do
        print("  - " .. id)
    end
    
    -- Verificar estado de HzAnticheat global
    print("\nEstado de configuración global:")
    print("_G.HzAnticheat existe: " .. tostring(_G.HzAnticheat ~= nil))
    
    if _G.HzAnticheat then
        print("_G.HzAnticheat.Permissions existe: " .. tostring(_G.HzAnticheat.Permissions ~= nil))
        
        if _G.HzAnticheat.Permissions then
            print("Permissions.Enabled: " .. tostring(_G.HzAnticheat.Permissions.Enabled))
            print("Permissions.DefaultAce: " .. tostring(_G.HzAnticheat.Permissions.DefaultAce))
            
            if _G.HzAnticheat.Permissions.GroupAces then
                print("GroupAces configurados:")
                for group, ace in pairs(_G.HzAnticheat.Permissions.GroupAces) do
                    print("  " .. group .. " -> " .. ace)
                end
            else
                print("GroupAces: No configurado")
            end
        end
    end
    
    -- Verificar permisos ACE específicos
    print("\nVerificación de permisos ACE:")
    local acePerms = {"hzanticheat.admin", "secure.admin", "command.tx", "command"}
    
    for _, perm in ipairs(acePerms) do
        local hasAce = IsPlayerAceAllowed(source, perm)
        print("  " .. perm .. ": " .. (hasAce and "✅ SÍ" or "❌ NO"))
    end
    
    -- Verificar AdminWhitelist.isAdmin
    print("\nVerificación AdminWhitelist:")
    if AdminWhitelist and AdminWhitelist.isAdmin then
        local isAdmin = AdminWhitelist.isAdmin(source)
        print("AdminWhitelist.isAdmin(" .. source .. "): " .. (isAdmin and "✅ SÍ" or "❌ NO"))
    else
        print("AdminWhitelist no disponible")
    end
    
    print("=== FIN DIAGNÓSTICO ===\n")
    
    -- Enviar mensaje al jugador
    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 255},
        args = {"[HzAnticheat]", "Diagnóstico de permisos completado. Revisa la consola del servidor."}
    })
end, false)

-- Comando para reinicializar completamente el sistema de permisos
RegisterCommand('hzreinitperms', function(source, args, rawCommand)
    if source ~= 0 then
        if not AdminWhitelist or not AdminWhitelist.isAdmin(source) then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                args = {"[HzAnticheat]", "No tienes permisos para usar este comando"}
            })
            return
        end
    end
    
    print("\n=== REINICIALIZANDO SISTEMA DE PERMISOS ===")
    
    -- Limpiar configuración existente
    if _G.HzAnticheat then
        _G.HzAnticheat.Permissions = nil
        print("✅ Configuración anterior limpiada")
    end
    
    -- Reinicializar AdminWhitelist
    if AdminWhitelist and AdminWhitelist.setupPermissions then
        AdminWhitelist.setupPermissions()
        print("✅ AdminWhitelist reinicializado")
    end
    
    -- Ejecutar pruebas de funcionalidad
    Wait(1000)
    if AdminPanelInstaller and AdminPanelInstaller.testFunctionality then
        print("\n🧪 Ejecutando pruebas de funcionalidad...")
        AdminPanelInstaller.testFunctionality(source)
    end
    
    print("=== REINICIALIZACIÓN COMPLETADA ===\n")
    
    if source ~= 0 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {0, 255, 0},
            args = {"[HzAnticheat]", "Sistema de permisos reinicializado. Revisa la consola del servidor."}
        })
    end
end, true)

-- Exportar funciones
exports('incrementErrors', AdminPanelServer.incrementErrors)
exports('addErrorLog', AdminPanelServer.addErrorLog)
exports('addBanLog', AdminPanelServer.addBanLog)
exports('getSystemStats', getSystemStats)

return AdminPanelServer