local AdminPanel = {}
local isAdminPanelOpen = false
local playerData = {}

-- Función para abrir el panel de administración
function AdminPanel.openPanel()
    if isAdminPanelOpen then
        return
    end
    
    -- Verificar permisos en el servidor
    TriggerServerEvent('HzAnticheat:checkAdminPermission')
end

-- Función para abrir el panel después de verificar permisos
function AdminPanel.openPanelConfirmed()
    if isAdminPanelOpen then
        return
    end
    
    isAdminPanelOpen = true
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        action = 'openAdminPanel'
    })
    
    -- Solicitar estadísticas iniciales
    TriggerServerEvent('HzAnticheat:requestStats')
end

-- Función para cerrar el panel
function AdminPanel.closePanel()
    if not isAdminPanelOpen then
        return
    end
    
    isAdminPanelOpen = false
    SetNuiFocus(false, false)
    
    SendNUIMessage({
        action = 'closeAdminPanel'
    })
end

-- Comando para abrir el panel
RegisterCommand('hzadmin', function(source, args, rawCommand)
    AdminPanel.openPanel()
end, false)

-- Comando alternativo
RegisterCommand('adminpanel', function(source, args, rawCommand)
    AdminPanel.openPanel()
end, false)

-- Keybind para abrir el panel (F6 por defecto)
RegisterKeyMapping('hzadmin', 'Abrir Panel de Administración HzAnticheat', 'keyboard', 'F6')

-- Callbacks NUI
RegisterNUICallback('setNuiFocus', function(data, cb)
    SetNuiFocus(data.hasFocus, data.hasCursor)
    if not data.hasFocus then
        isAdminPanelOpen = false
    end
    cb('ok')
end)

RegisterNUICallback('banPlayer', function(data, cb)
    TriggerServerEvent('HzAnticheat:banPlayer', {
        playerId = data.playerId,
        reason = data.reason,
        duration = data.duration
    })
    
    cb('ok')
end)

RegisterNUICallback('unbanPlayer', function(data, cb)
    TriggerServerEvent('HzAnticheat:unbanPlayer', {
        identifier = data.identifier
    })
    
    cb('ok')
end)

RegisterNUICallback('addToWhitelist', function(data, cb)
    TriggerServerEvent('HzAnticheat:addToWhitelist', {
        type = data.type,
        name = data.name
    })
    
    cb('ok')
end)

RegisterNUICallback('toggleDebugMode', function(data, cb)
    TriggerServerEvent('HzAnticheat:toggleDebugMode')
    cb('ok')
end)

RegisterNUICallback('toggleDevMode', function(data, cb)
    TriggerServerEvent('HzAnticheat:toggleDevMode')
    cb('ok')
end)

RegisterNUICallback('reloadConfig', function(data, cb)
    TriggerServerEvent('HzAnticheat:reloadConfig')
    cb('ok')
end)

RegisterNUICallback('getStats', function(data, cb)
    TriggerServerEvent('HzAnticheat:requestStats')
    cb('ok')
end)

RegisterNUICallback('getBanList', function(data, cb)
    TriggerServerEvent('HzAnticheat:requestBanList', {
        count = data.count or 10
    })
    
    cb('ok')
end)

RegisterNUICallback('getLogs', function(data, cb)
    TriggerServerEvent('HzAnticheat:requestLogs', {
        filter = data.filter or 'all'
    })
    
    cb('ok')
end)

-- Eventos del servidor
RegisterNetEvent('HzAnticheat:updateStats')
AddEventHandler('HzAnticheat:updateStats', function(stats)
    SendNUIMessage({
        action = 'updateStats',
        stats = stats
    })
end)

RegisterNetEvent('HzAnticheat:updateBanList')
AddEventHandler('HzAnticheat:updateBanList', function(bans)
    SendNUIMessage({
        action = 'updateBanList',
        bans = bans
    })
end)

RegisterNetEvent('HzAnticheat:showNotification')
AddEventHandler('HzAnticheat:showNotification', function(message, type)
    SendNUIMessage({
        action = 'showNotification',
        message = message,
        type = type or 'info'
    })
end)

RegisterNetEvent('HzAnticheat:updateLogs')
AddEventHandler('HzAnticheat:updateLogs', function(logs)
    SendNUIMessage({
        action = 'updateLogs',
        logs = logs
    })
end)

-- Evento para confirmar permisos de admin y abrir panel
RegisterNetEvent('HzAnticheat:openAdminPanelConfirmed')
AddEventHandler('HzAnticheat:openAdminPanelConfirmed', function()
    AdminPanel.openPanelConfirmed()
end)

-- Evento para mostrar error de permisos
RegisterNetEvent('HzAnticheat:adminPermissionDenied')
AddEventHandler('HzAnticheat:adminPermissionDenied', function()
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {"[HzAnticheat]", "No tienes permisos para acceder al panel de administración."}
    })
end)

-- Cerrar panel con ESC
CreateThread(function()
    while true do
        Wait(0)
        if isAdminPanelOpen then
            DisableControlAction(0, 322, true) -- ESC
            if IsDisabledControlJustPressed(0, 322) then
                AdminPanel.closePanel()
            end
        else
            Wait(500)
        end
    end
end)

-- Exportar funciones
exports('openAdminPanel', AdminPanel.openPanel)
exports('closeAdminPanel', AdminPanel.closePanel)
exports('isAdminPanelOpen', function() return isAdminPanelOpen end)

return AdminPanel