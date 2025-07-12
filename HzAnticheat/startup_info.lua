-- Script de información de inicio para HzAnticheat con Panel de Administración
-- Muestra información importante al cargar el recurso

local StartupInfo = {}

-- Configuración de startup
local STARTUP_CONFIG = {
    showBanner = true,
    showFeatures = true,
    showCommands = true,
    showWarnings = true,
    delaySeconds = 5
}

-- Banner ASCII del panel
local BANNER = [[

██╗  ██╗███████╗     █████╗ ███╗   ██╗████████╗██╗ ██████╗██╗  ██╗███████╗ █████╗ ████████╗
██║  ██║╚══███╔╝    ██╔══██╗████╗  ██║╚══██╔══╝██║██╔════╝██║  ██║██╔════╝██╔══██╗╚══██╔══╝
███████║  ███╔╝     ███████║██╔██╗ ██║   ██║   ██║██║     ███████║█████╗  ███████║   ██║   
██╔══██║ ███╔╝      ██╔══██║██║╚██╗██║   ██║   ██║██║     ██╔══██║██╔══╝  ██╔══██║   ██║   
██║  ██║███████╗    ██║  ██║██║ ╚████║   ██║   ██║╚██████╗██║  ██║███████╗██║  ██║   ██║   
╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   

                           🛡️  PANEL DE ADMINISTRACIÓN INTEGRADO  🛡️
]]

-- Función para mostrar el banner
function StartupInfo.showBanner()
    if not STARTUP_CONFIG.showBanner then return end
    
    print(BANNER)
    print("")
    print("🚀 Versión: 1.0.0 | 📅 Fecha: " .. os.date("%Y-%m-%d"))
    print("👨‍💻 Desarrollado por: HzAnticheat Team")
    print("🌐 Basado en: SecureServe Framework")
    print("")
end

-- Función para mostrar características
function StartupInfo.showFeatures()
    if not STARTUP_CONFIG.showFeatures then return end
    
    print("✨ === CARACTERÍSTICAS PRINCIPALES ===")
    print("")
    print("🎛️  Panel de Administración In-Game")
    print("   • Dashboard con estadísticas en tiempo real")
    print("   • Gestión completa de jugadores y baneos")
    print("   • Sistema de whitelist avanzado")
    print("   • Logs del sistema con filtros")
    print("")
    print("🔐 Sistema de Permisos Robusto")
    print("   • ACE Permissions (hzanticheat.admin)")
    print("   • Integración con txAdmin")
    print("   • Lista manual de administradores")
    print("")
    print("🎨 Interfaz Moderna")
    print("   • Diseño responsive y profesional")
    print("   • Tema oscuro/claro")
    print("   • Animaciones suaves")
    print("   • Notificaciones en tiempo real")
    print("")
    print("🛡️  Protecciones Avanzadas")
    print("   • Anti-cheat integrado")
    print("   • Detección de exploits")
    print("   • Sistema de logs completo")
    print("   • Configuración en tiempo real")
    print("")
end

-- Función para mostrar comandos
function StartupInfo.showCommands()
    if not STARTUP_CONFIG.showCommands then return end
    
    print("⌨️  === COMANDOS DISPONIBLES ===")
    print("")
    print("🎛️  Panel de Administración:")
    print("   /hzadmin - Abrir panel de administración")
    print("   /adminpanel - Comando alternativo")
    print("   F6 - Tecla rápida (configurable)")
    print("")
    print("🔧 Utilidades del Sistema:")
    print("   /hzinstall - Información de instalación")
    print("   /hzverify - Verificar instalación")
    print("   /hztest - Probar funcionalidad")
    print("   /hzstatus - Estado del sistema")
    print("   /hzhelp - Ayuda completa")
    print("")
    print("🎮 Comandos de Demostración:")
    print("   /hzdemo - Mostrar características")
    print("   /hzteststats - Probar estadísticas")
    print("   /hztestbans - Probar sistema de baneos")
    print("   /hztestlogs - Probar logs")
    print("")
    print("🛠️  Configuración:")
    print("   /hzperms - Configurar permisos ACE")
    print("   /securereload - Recargar configuración")
    print("   /securedebug - Toggle modo debug")
    print("   /securedevmode - Toggle modo desarrollador")
    print("")
end

-- Función para mostrar advertencias importantes
function StartupInfo.showWarnings()
    if not STARTUP_CONFIG.showWarnings then return end
    
    print("⚠️  === INFORMACIÓN IMPORTANTE ===")
    print("")
    
    -- Verificar instalación
    local present, missing = {}, {}
    local requiredFiles = {
        "src/client/admin_panel.lua",
        "src/server/admin_panel_server.lua",
        "admin_panel_config.lua"
    }
    
    for _, file in ipairs(requiredFiles) do
        if LoadResourceFile(GetCurrentResourceName(), file) then
            table.insert(present, file)
        else
            table.insert(missing, file)
        end
    end
    
    if #missing > 0 then
        print("❌ ARCHIVOS FALTANTES:")
        for _, file in ipairs(missing) do
            print("   • " .. file)
        end
        print("")
        print("🔧 Solución: Usa /hzinstall para más información")
        print("")
    else
        print("✅ Todos los archivos están presentes")
    end
    
    -- Verificar configuración
    if not AdminPanelConfig then
        print("❌ CONFIGURACIÓN NO ENCONTRADA")
        print("   El archivo admin_panel_config.lua no se cargó correctamente")
        print("")
    else
        print("✅ Configuración cargada correctamente")
    end
    
    -- Verificar permisos
    print("🔑 CONFIGURACIÓN DE PERMISOS:")
    print("   Para usar el panel, configura permisos ACE:")
    print("   add_ace group.admin hzanticheat.admin allow")
    print("   add_ace identifier.steam:TU_STEAM_ID hzanticheat.admin allow")
    print("")
    print("   O usa /hzperms para ver ejemplos completos")
    print("")
    
    -- Información de seguridad
    print("🔒 SEGURIDAD:")
    print("   • Solo administradores autorizados pueden acceder")
    print("   • Todas las acciones son registradas")
    print("   • Validación múltiple de permisos")
    print("   • Comunicación encriptada NUI")
    print("")
end

-- Función para mostrar estadísticas del sistema
function StartupInfo.showSystemStats()
    print("📊 === ESTADÍSTICAS DEL SISTEMA ===")
    print("")
    print("🖥️  Servidor:")
    print("   Recurso: " .. GetCurrentResourceName())
    print("   Estado: " .. GetResourceState(GetCurrentResourceName()))
    print("   Jugadores: " .. GetNumPlayerIndices() .. "/" .. GetConvarInt('sv_maxclients', 32))
    print("")
    
    if AdminPanelConfig then
        print("⚙️  Configuración:")
        print("   Tema: " .. (AdminPanelConfig.ui and AdminPanelConfig.ui.theme or "Desconocido"))
        print("   Idioma: " .. (AdminPanelConfig.ui and AdminPanelConfig.ui.language or "Desconocido"))
        print("   Tecla: " .. (AdminPanelConfig.keybinds and AdminPanelConfig.keybinds.openPanel or "F6"))
        print("")
    end
end

-- Función principal de inicio
function StartupInfo.initialize()
    CreateThread(function()
        -- Esperar a que todo se cargue
        Wait(STARTUP_CONFIG.delaySeconds * 1000)
        
        print("")
        print("🚀 Iniciando HzAnticheat con Panel de Administración...")
        print("")
        
        -- Mostrar información
        StartupInfo.showBanner()
        StartupInfo.showFeatures()
        StartupInfo.showCommands()
        StartupInfo.showWarnings()
        StartupInfo.showSystemStats()
        
        print("🎉 === SISTEMA LISTO ===")
        print("")
        print("✅ HzAnticheat cargado exitosamente")
        print("🎛️  Panel de administración disponible")
        print("📚 Usa /hzhelp para más información")
        print("🔧 Usa /hzverify para verificar instalación")
        print("")
        print("🛡️  ¡Tu servidor está protegido!")
        print("")
        
        -- Verificación automática
        Wait(2000)
        
        if exports and exports[GetCurrentResourceName()] then
            local installStatus = exports[GetCurrentResourceName()]:checkInstallation()
            if installStatus then
                print("✅ Verificación automática: EXITOSA")
            else
                print("⚠️  Verificación automática: PROBLEMAS DETECTADOS")
                print("   Usa /hzverify para más detalles")
            end
        end
        
        print("")
    end)
end

-- Comando para mostrar información de inicio
RegisterCommand('hzinfo', function(source, args, rawCommand)
    StartupInfo.showBanner()
    StartupInfo.showFeatures()
    StartupInfo.showCommands()
    StartupInfo.showSystemStats()
end, false)

-- Comando para mostrar solo el banner
RegisterCommand('hzbanner', function(source, args, rawCommand)
    StartupInfo.showBanner()
end, false)

-- Función para configurar el startup
function StartupInfo.configure(config)
    if config then
        for key, value in pairs(config) do
            if STARTUP_CONFIG[key] ~= nil then
                STARTUP_CONFIG[key] = value
            end
        end
    end
end

-- Inicializar automáticamente
StartupInfo.initialize()

-- Exportar funciones
exports('showStartupInfo', StartupInfo.initialize)
exports('configureStartup', StartupInfo.configure)

return StartupInfo