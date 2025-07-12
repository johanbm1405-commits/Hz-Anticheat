-- Script de demostración para el Panel de Administración HzAnticheat
-- Este archivo muestra cómo usar las funciones del panel y puede ser usado para pruebas

-- NOTA: Este archivo es solo para demostración y pruebas
-- No incluir en producción

local DemoPanel = {}

-- Función de demostración para mostrar todas las características
function DemoPanel.showFeatures()
    print("=== DEMO: Panel de Administración HzAnticheat ===")
    print("")
    print("Comandos disponibles:")
    print("  /hzadmin - Abrir panel de administración")
    print("  /adminpanel - Comando alternativo")
    print("  F6 - Tecla rápida para abrir panel")
    print("")
    print("Características del panel:")
    print("  ✓ Dashboard con estadísticas en tiempo real")
    print("  ✓ Gestión de jugadores (banear/desbanear)")
    print("  ✓ Sistema de baneos con historial")
    print("  ✓ Lista blanca para eventos y recursos")
    print("  ✓ Configuración del sistema (debug/dev mode)")
    print("  ✓ Registros del sistema con filtros")
    print("")
    print("Permisos requeridos:")
    print("  - ACE: hzanticheat.admin")
    print("  - txAdmin: admin")
    print("  - Lista manual de administradores")
    print("")
    print("=== Fin de la demostración ===")
end

-- Comando de demostración
RegisterCommand('hzdemo', function(source, args, rawCommand)
    DemoPanel.showFeatures()
end, false)

-- Función para probar las estadísticas
function DemoPanel.testStats()
    local testStats = {
        playerCount = math.random(1, 32),
        totalBans = math.random(0, 50),
        totalErrors = math.random(0, 10),
        debugMode = math.random() > 0.5,
        devMode = math.random() > 0.5,
        protectionStatus = 'Activo'
    }
    
    print("Estadísticas de prueba generadas:")
    print(json.encode(testStats, {indent = true}))
    
    return testStats
end

-- Función para probar baneos de demostración
function DemoPanel.testBans()
    local testBans = {
        {
            identifier = "steam:110000103fa1234",
            reason = "Uso de cheats",
            timestamp = os.time() - 3600,
            admin = "Admin_Demo"
        },
        {
            identifier = "steam:110000103fa5678",
            reason = "Comportamiento tóxico",
            timestamp = os.time() - 7200,
            admin = "Admin_Demo"
        },
        {
            identifier = "steam:110000103fa9012",
            reason = "Explotación de bugs",
            timestamp = os.time() - 10800,
            admin = "Sistema"
        }
    }
    
    print("Baneos de prueba generados:")
    print(json.encode(testBans, {indent = true}))
    
    return testBans
end

-- Función para probar logs de demostración
function DemoPanel.testLogs()
    local testLogs = {
        {
            timestamp = os.time() - 300,
            type = "admin",
            message = "Panel de administración abierto",
            admin = "Admin_Demo"
        },
        {
            timestamp = os.time() - 600,
            type = "bans",
            message = "Jugador TestPlayer baneado por uso de cheats",
            admin = "Admin_Demo"
        },
        {
            timestamp = os.time() - 900,
            type = "errors",
            message = "Detección de speed hack en jugador ID 5",
            admin = "Sistema"
        },
        {
            timestamp = os.time() - 1200,
            type = "admin",
            message = "Modo debug activado",
            admin = "Admin_Demo"
        }
    }
    
    print("Logs de prueba generados:")
    print(json.encode(testLogs, {indent = true}))
    
    return testLogs
end

-- Comando para probar estadísticas
RegisterCommand('hzteststats', function(source, args, rawCommand)
    if not AdminWhitelist or not AdminWhitelist.isAdmin(source) then
        print("Solo administradores pueden usar este comando")
        return
    end
    
    local stats = DemoPanel.testStats()
    TriggerClientEvent('HzAnticheat:updateStats', source, stats)
end, false)

-- Comando para probar baneos
RegisterCommand('hztestbans', function(source, args, rawCommand)
    if not AdminWhitelist or not AdminWhitelist.isAdmin(source) then
        print("Solo administradores pueden usar este comando")
        return
    end
    
    local bans = DemoPanel.testBans()
    TriggerClientEvent('HzAnticheat:updateBanList', source, bans)
end, false)

-- Comando para probar logs
RegisterCommand('hztestlogs', function(source, args, rawCommand)
    if not AdminWhitelist or not AdminWhitelist.isAdmin(source) then
        print("Solo administradores pueden usar este comando")
        return
    end
    
    local logs = DemoPanel.testLogs()
    TriggerClientEvent('HzAnticheat:updateLogs', source, logs)
end, false)

-- Comando para probar notificaciones
RegisterCommand('hztestnotif', function(source, args, rawCommand)
    if not AdminWhitelist or not AdminWhitelist.isAdmin(source) then
        print("Solo administradores pueden usar este comando")
        return
    end
    
    local notifType = args[1] or 'info'
    local message = table.concat(args, ' ', 2) or 'Mensaje de prueba'
    
    TriggerClientEvent('HzAnticheat:showNotification', source, message, notifType)
end, false)

-- Función para verificar la instalación
function DemoPanel.verifyInstallation()
    local errors = {}
    
    -- Verificar archivos del cliente
    if not LoadResourceFile(GetCurrentResourceName(), 'src/client/admin_panel.lua') then
        table.insert(errors, "Archivo faltante: src/client/admin_panel.lua")
    end
    
    if not LoadResourceFile(GetCurrentResourceName(), 'src/client/protections/index.html') then
        table.insert(errors, "Archivo faltante: src/client/protections/index.html")
    end
    
    -- Verificar archivos del servidor
    if not LoadResourceFile(GetCurrentResourceName(), 'src/server/admin_panel_server.lua') then
        table.insert(errors, "Archivo faltante: src/server/admin_panel_server.lua")
    end
    
    if not LoadResourceFile(GetCurrentResourceName(), 'admin_panel_config.lua') then
        table.insert(errors, "Archivo faltante: admin_panel_config.lua")
    end
    
    -- Verificar configuración
    if not AdminPanelConfig then
        table.insert(errors, "Configuración AdminPanelConfig no encontrada")
    end
    
    if #errors > 0 then
        print("=== ERRORES DE INSTALACIÓN ===")
        for _, error in ipairs(errors) do
            print("❌ " .. error)
        end
        print("=== FIN DE ERRORES ===")
        return false
    else
        print("=== VERIFICACIÓN EXITOSA ===")
        print("✅ Todos los archivos están presentes")
        print("✅ Configuración cargada correctamente")
        print("✅ Panel de administración listo para usar")
        print("=== INSTALACIÓN COMPLETA ===")
        return true
    end
end

-- Comando para verificar instalación
RegisterCommand('hzverify', function(source, args, rawCommand)
    DemoPanel.verifyInstallation()
end, false)

-- Información de ayuda
function DemoPanel.showHelp()
    print("=== AYUDA: Panel de Administración HzAnticheat ===")
    print("")
    print("Comandos de demostración:")
    print("  /hzdemo - Mostrar características del panel")
    print("  /hzverify - Verificar instalación")
    print("  /hzteststats - Probar estadísticas (solo admins)")
    print("  /hztestbans - Probar lista de baneos (solo admins)")
    print("  /hztestlogs - Probar logs (solo admins)")
    print("  /hztestnotif [tipo] [mensaje] - Probar notificaciones (solo admins)")
    print("  /hzhelp - Mostrar esta ayuda")
    print("")
    print("Comandos del panel:")
    print("  /hzadmin - Abrir panel de administración")
    print("  /adminpanel - Comando alternativo")
    print("")
    print("Teclas:")
    print("  F6 - Abrir panel")
    print("  ESC - Cerrar panel")
    print("")
    print("Para más información, consulta ADMIN_PANEL_README.md")
    print("=== FIN DE LA AYUDA ===")
end

-- Comando de ayuda
RegisterCommand('hzhelp', function(source, args, rawCommand)
    DemoPanel.showHelp()
end, false)

-- Inicialización automática
CreateThread(function()
    Wait(5000) -- Esperar 5 segundos para que todo se cargue
    
    print("")
    print("🛡️  Panel de Administración HzAnticheat cargado")
    print("📖 Usa /hzhelp para ver comandos disponibles")
    print("🔧 Usa /hzverify para verificar la instalación")
    print("")
end)

return DemoPanel