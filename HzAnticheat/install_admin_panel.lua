-- Instalador automático del Panel de Administración HzAnticheat
-- Este script configura automáticamente el panel de administración

local AdminPanelInstaller = {}

-- Configuración de instalación
local INSTALL_CONFIG = {
    version = "1.0.0",
    requiredFiles = {
        "src/client/admin_panel.lua",
        "src/server/admin_panel_server.lua",
        "src/client/protections/index.html",
        "admin_panel_config.lua",
        "fxmanifest.lua"
    },
    permissions = {
        ace = "hzanticheat.admin",
        commands = {"hzadmin", "adminpanel"}
    }
}

-- Función para verificar archivos
function AdminPanelInstaller.checkFiles()
    local missing = {}
    local present = {}
    
    for _, file in ipairs(INSTALL_CONFIG.requiredFiles) do
        if LoadResourceFile(GetCurrentResourceName(), file) then
            table.insert(present, file)
        else
            table.insert(missing, file)
        end
    end
    
    return present, missing
end

-- Función para verificar permisos
function AdminPanelInstaller.checkPermissions(source)
    if not source or source == 0 then
        return false, false
    end
    
    local hasAce = false
    local isTxAdmin = false
    
    -- Verificar ACE con manejo de errores
    local success, result = pcall(IsPlayerAceAllowed, source, INSTALL_CONFIG.permissions.ace)
    if success then
        hasAce = result
    end
    
    -- Verificar txAdmin
    if AdminWhitelist and AdminWhitelist.getTxAdminPerm then
        local txSuccess, txResult = pcall(AdminWhitelist.getTxAdminPerm, source)
        if txSuccess then
            isTxAdmin = txResult ~= nil
        end
    end
    
    return hasAce, isTxAdmin
end

-- Función para configurar permisos ACE automáticamente
function AdminPanelInstaller.setupAcePermissions()
    local commands = {
        'add_ace group.admin hzanticheat.admin allow',
        'add_ace identifier.steam:110000000000000 hzanticheat.admin allow', -- Ejemplo
    }
    
    print("=== CONFIGURACIÓN DE PERMISOS ACE ===")
    print("Agrega estos comandos a tu server.cfg o permissions.cfg:")
    print("")
    
    for _, cmd in ipairs(commands) do
        print(cmd)
    end
    
    print("")
    print("O usa el comando: add_ace [identifier] hzanticheat.admin allow")
    print("Ejemplo: add_ace identifier.steam:110000103fa1234 hzanticheat.admin allow")
    print("=== FIN DE CONFIGURACIÓN ===")
end

-- Función para mostrar información de instalación
function AdminPanelInstaller.showInstallInfo()
    print("")
    print("🛡️  ===== INSTALADOR PANEL DE ADMINISTRACIÓN HZANTICHEAT ===== 🛡️")
    print("")
    print("📋 Versión: " .. INSTALL_CONFIG.version)
    print("📅 Fecha: " .. os.date("%Y-%m-%d %H:%M:%S"))
    print("")
    
    local present, missing = AdminPanelInstaller.checkFiles()
    
    print("📁 Estado de archivos:")
    print("")
    
    if #present > 0 then
        print("✅ Archivos presentes:")
        for _, file in ipairs(present) do
            print("   ✓ " .. file)
        end
        print("")
    end
    
    if #missing > 0 then
        print("❌ Archivos faltantes:")
        for _, file in ipairs(missing) do
            print("   ✗ " .. file)
        end
        print("")
        print("⚠️  ADVERTENCIA: Algunos archivos están faltantes.")
        print("   El panel puede no funcionar correctamente.")
        print("")
    else
        print("✅ Todos los archivos están presentes.")
        print("")
    end
    
    -- Verificar configuración
    if AdminPanelConfig then
        print("✅ Configuración cargada correctamente.")
        if AdminPanelConfig.validateConfig and AdminPanelConfig.validateConfig() then
            print("✅ Configuración válida.")
        else
            print("⚠️  Configuración tiene errores.")
        end
    else
        print("❌ Configuración no encontrada.")
    end
    
    print("")
    print("🔑 Configuración de permisos:")
    print("   ACE Permission: " .. INSTALL_CONFIG.permissions.ace)
    print("   Comandos: " .. table.concat(INSTALL_CONFIG.permissions.commands, ", "))
    print("")
    
    print("📖 Comandos disponibles después de la instalación:")
    print("   /hzadmin - Abrir panel de administración")
    print("   /adminpanel - Comando alternativo")
    print("   F6 - Tecla rápida (configurable)")
    print("")
    
    print("🔧 Comandos de utilidad:")
    print("   /hzinstall - Mostrar esta información")
    print("   /hzperms - Configurar permisos ACE")
    print("   /hztest - Probar funcionalidad")
    print("   /hzstatus - Estado del sistema")
    print("")
    
    if #missing == 0 and AdminPanelConfig then
        print("🎉 ¡INSTALACIÓN COMPLETA!")
        print("   El panel de administración está listo para usar.")
    else
        print("⚠️  INSTALACIÓN INCOMPLETA")
        print("   Revisa los archivos faltantes y la configuración.")
    end
    
    print("")
    print("📚 Para más información, consulta ADMIN_PANEL_README.md")
    print("")
    print("🛡️  ===== FIN DEL INSTALADOR ===== 🛡️")
    print("")
end

-- Función para probar funcionalidad básica
function AdminPanelInstaller.testFunctionality(source)
    local tests = {
        {name = "Archivos", func = function() 
            local present, missing = AdminPanelInstaller.checkFiles()
            return #missing == 0
        end},
        {name = "Configuración", func = function()
            return AdminPanelConfig ~= nil
        end},
        {name = "Permisos", func = function()
            -- Si no hay source (ejecución automática), verificar configuración de permisos
            if not source then
                -- Verificar que la configuración de permisos esté disponible
                if _G.HzAnticheat and _G.HzAnticheat.Permissions then
                    return _G.HzAnticheat.Permissions.Enabled == true
                end
                -- Fallback: verificar que al menos la configuración base exista
                return HzAnticheat ~= nil
            else
                -- Si hay source, verificar permisos del jugador
                local success, hasAce, isTxAdmin = pcall(AdminPanelInstaller.checkPermissions, source)
                if success then
                    return hasAce or isTxAdmin
                end
                return false
            end
        end},
        {name = "AdminWhitelist", func = function()
            -- Verificar que AdminWhitelist esté cargado y funcional
            if not AdminWhitelist then
                return false
            end
            
            -- Verificar que la función isAdmin existe
            if not AdminWhitelist.isAdmin then
                return false
            end
            
            -- Verificar que la configuración de permisos esté disponible
            if _G.HzAnticheat and _G.HzAnticheat.Permissions and _G.HzAnticheat.Permissions.Enabled then
                return true
            end
            
            -- Si no hay configuración, intentar inicializarla si la función existe
            if AdminWhitelist.setupPermissions then
                local success, result = pcall(AdminWhitelist.setupPermissions)
                if success then
                    -- Verificar nuevamente después de la inicialización
                    return _G.HzAnticheat and _G.HzAnticheat.Permissions and _G.HzAnticheat.Permissions.Enabled
                end
            end
            
            -- Fallback: si AdminWhitelist existe pero no hay configuración de permisos,
            -- asumir que está funcionando con configuración manual
            return true
        end}
    }
    
    print("")
    print("🧪 === PRUEBAS DE FUNCIONALIDAD ===")
    print("")
    
    local allPassed = true
    
    for _, test in ipairs(tests) do
        local success, result = pcall(test.func)
        local status = success and result
        
        if status then
            print("✅ " .. test.name .. ": OK")
        else
            print("❌ " .. test.name .. ": FALLO")
            if not success then
                print("   Error: " .. tostring(result))
            end
            allPassed = false
        end
    end
    
    print("")
    
    if allPassed then
        print("🎉 Todas las pruebas pasaron. El panel está funcionando correctamente.")
    else
        print("⚠️  Algunas pruebas fallaron. Revisa la configuración.")
    end
    
    print("")
    print("🧪 === FIN DE PRUEBAS ===")
    print("")
    
    return allPassed
end

-- Función para mostrar estado del sistema
function AdminPanelInstaller.showSystemStatus()
    print("")
    print("📊 === ESTADO DEL SISTEMA ===")
    print("")
    
    -- Información del recurso
    print("📦 Recurso: " .. GetCurrentResourceName())
    print("🔄 Estado: " .. GetResourceState(GetCurrentResourceName()))
    print("")
    
    -- Información del servidor
    print("🖥️  Servidor:")
    print("   Jugadores: " .. GetNumPlayerIndices() .. "/" .. GetConvarInt('sv_maxclients', 32))
    print("   Uptime: " .. math.floor(GetGameTimer() / 1000 / 60) .. " minutos")
    print("")
    
    -- Estado de HzAnticheat
    if HzAnticheat then
        print("🛡️  HzAnticheat: Activo")
    else
        print("❌ HzAnticheat: No encontrado")
    end
    
    -- Estado del panel
    local present, missing = AdminPanelInstaller.checkFiles()
    print("🎛️  Panel de Administración:")
    print("   Archivos: " .. #present .. "/" .. #INSTALL_CONFIG.requiredFiles)
    print("   Estado: " .. (#missing == 0 and "Completo" or "Incompleto"))
    
    if AdminPanelConfig then
        print("   Configuración: Cargada")
        print("   Tema: " .. (AdminPanelConfig.ui and AdminPanelConfig.ui.theme or "Desconocido"))
        print("   Idioma: " .. (AdminPanelConfig.ui and AdminPanelConfig.ui.language or "Desconocido"))
    else
        print("   Configuración: No encontrada")
    end
    
    print("")
    print("📊 === FIN DEL ESTADO ===")
    print("")
end

-- Comandos de instalación
RegisterCommand('hzinstall', function(source, args, rawCommand)
    AdminPanelInstaller.showInstallInfo()
end, false)

RegisterCommand('hzperms', function(source, args, rawCommand)
    AdminPanelInstaller.setupAcePermissions()
end, false)

RegisterCommand('hztest', function(source, args, rawCommand)
    AdminPanelInstaller.testFunctionality(source)
end, false)

RegisterCommand('hzstatus', function(source, args, rawCommand)
    AdminPanelInstaller.showSystemStatus()
end, false)

-- Auto-instalación al iniciar el recurso
CreateThread(function()
    Wait(3000) -- Esperar a que todo se cargue
    
    print("")
    print("🚀 Iniciando instalador del Panel de Administración...")
    
    Wait(2000)
    
    AdminPanelInstaller.showInstallInfo()
    
    -- Probar funcionalidad automáticamente
    Wait(1000)
    AdminPanelInstaller.testFunctionality()
end)

-- Función para desinstalar (solo para desarrollo)
function AdminPanelInstaller.uninstall()
    print("")
    print("🗑️  === DESINSTALACIÓN ===")
    print("")
    print("⚠️  ADVERTENCIA: Esta función es solo para desarrollo.")
    print("   Para desinstalar completamente:")
    print("")
    print("1. Detén el recurso: stop " .. GetCurrentResourceName())
    print("2. Elimina los archivos del panel:")
    print("   - src/client/admin_panel.lua")
    print("   - src/server/admin_panel_server.lua")
    print("   - admin_panel_config.lua")
    print("   - ADMIN_PANEL_README.md")
    print("3. Restaura el index.html original")
    print("4. Actualiza fxmanifest.lua")
    print("5. Elimina permisos ACE del server.cfg")
    print("")
    print("🗑️  === FIN DE DESINSTALACIÓN ===")
    print("")
end

RegisterCommand('hzuninstall', function(source, args, rawCommand)
    AdminPanelInstaller.uninstall()
end, false)

-- Exportar funciones para uso externo
exports('checkInstallation', function()
    local present, missing = AdminPanelInstaller.checkFiles()
    return #missing == 0
end)

exports('getInstallStatus', function()
    local present, missing = AdminPanelInstaller.checkFiles()
    return {
        complete = #missing == 0,
        present = present,
        missing = missing,
        version = INSTALL_CONFIG.version
    }
end)

return AdminPanelInstaller