-- Configuración del Panel de Administración HzAnticheat
-- Este archivo permite personalizar el comportamiento del panel

AdminPanelConfig = {}

-- Configuración de teclas
AdminPanelConfig.Keybinds = {
    openPanel = 'F6',  -- Tecla para abrir el panel (F1-F12, o códigos de tecla)
    closePanel = 'ESCAPE'  -- Tecla para cerrar el panel
}

-- Configuración de comandos
AdminPanelConfig.Commands = {
    primary = 'hzadmin',      -- Comando principal
    secondary = 'adminpanel', -- Comando alternativo
    enabled = true            -- Habilitar comandos de chat
}

-- Configuración de permisos
AdminPanelConfig.Permissions = {
    useAcePermissions = true,    -- Usar permisos ACE
    useTxAdminPermissions = true, -- Usar permisos txAdmin
    useManualList = true,        -- Usar lista manual de admins
    acePermission = 'hzanticheat.admin', -- Permiso ACE requerido
    txAdminPermission = 'admin'  -- Nivel txAdmin requerido
}

-- Configuración de la interfaz
AdminPanelConfig.UI = {
    theme = 'dark',              -- Tema: 'dark' o 'light'
    language = 'es',             -- Idioma: 'es', 'en'
    showNotifications = true,    -- Mostrar notificaciones
    notificationDuration = 3000, -- Duración de notificaciones (ms)
    autoRefreshStats = true,     -- Auto-actualizar estadísticas
    refreshInterval = 30000      -- Intervalo de actualización (ms)
}

-- Configuración de logs
AdminPanelConfig.Logging = {
    enabled = true,              -- Habilitar sistema de logs
    maxLogs = 1000,             -- Máximo número de logs a mantener
    logTypes = {                -- Tipos de logs a registrar
        admin = true,           -- Acciones administrativas
        bans = true,            -- Baneos y desbaneos
        errors = true,          -- Errores del sistema
        config = true           -- Cambios de configuración
    }
}

-- Configuración de baneos
AdminPanelConfig.Bans = {
    defaultDuration = 0,         -- Duración por defecto (0 = permanente)
    maxDuration = 525600,       -- Duración máxima en minutos (1 año)
    requireReason = true,       -- Requerir razón para banear
    minReasonLength = 5,        -- Longitud mínima de la razón
    maxReasonLength = 200,      -- Longitud máxima de la razón
    showRecentCount = 10        -- Número de baneos recientes a mostrar
}

-- Configuración de lista blanca
AdminPanelConfig.Whitelist = {
    allowEvents = true,         -- Permitir agregar eventos
    allowResources = true,      -- Permitir agregar recursos
    validateNames = true,       -- Validar nombres antes de agregar
    maxNameLength = 100         -- Longitud máxima del nombre
}

-- Configuración de estadísticas
AdminPanelConfig.Stats = {
    showPlayerCount = true,     -- Mostrar contador de jugadores
    showBanCount = true,        -- Mostrar contador de baneos
    showErrorCount = true,      -- Mostrar contador de errores
    showSystemStatus = true,    -- Mostrar estado del sistema
    updateInterval = 30         -- Intervalo de actualización (segundos)
}

-- Configuración de seguridad
AdminPanelConfig.Security = {
    logAllActions = true,       -- Registrar todas las acciones
    requireConfirmation = {     -- Requerir confirmación para:
        bans = false,           -- Baneos
        unbans = false,         -- Desbaneos
        configChanges = false   -- Cambios de configuración
    },
    rateLimiting = {            -- Limitación de velocidad
        enabled = true,         -- Habilitar limitación
        maxActionsPerMinute = 10 -- Máximo acciones por minuto
    }
}

-- Configuración de notificaciones
AdminPanelConfig.Notifications = {
    types = {
        success = {
            color = '#51cf66',
            icon = 'fas fa-check-circle'
        },
        error = {
            color = '#ff6b6b',
            icon = 'fas fa-exclamation-circle'
        },
        info = {
            color = '#667eea',
            icon = 'fas fa-info-circle'
        },
        warning = {
            color = '#ffd43b',
            icon = 'fas fa-exclamation-triangle'
        }
    }
}

-- Configuración de exportación
AdminPanelConfig.Export = {
    allowLogExport = true,      -- Permitir exportar logs
    allowStatsExport = true,    -- Permitir exportar estadísticas
    allowBanExport = true,      -- Permitir exportar lista de baneos
    exportFormats = {'json', 'csv'} -- Formatos de exportación disponibles
}

-- Configuración de desarrollo
AdminPanelConfig.Development = {
    debugMode = false,          -- Modo debug del panel
    showConsoleMessages = false, -- Mostrar mensajes en consola
    enableTestMode = false      -- Habilitar modo de prueba
}

-- Mensajes personalizables
AdminPanelConfig.Messages = {
    es = {
        noPermission = "No tienes permisos para acceder al panel de administración.",
        playerNotFound = "Jugador no encontrado.",
        banSuccess = "Jugador baneado exitosamente.",
        unbanSuccess = "Jugador desbaneado exitosamente.",
        whitelistSuccess = "Elemento agregado a la lista blanca exitosamente.",
        configReloaded = "Configuración recargada exitosamente.",
        debugToggled = "Modo debug alternado.",
        devModeToggled = "Modo desarrollador alternado.",
        fillRequiredFields = "Por favor completa todos los campos requeridos.",
        invalidIdentifier = "Por favor ingresa un identificador válido.",
        invalidName = "Por favor ingresa un nombre válido."
    },
    en = {
        noPermission = "You don't have permission to access the admin panel.",
        playerNotFound = "Player not found.",
        banSuccess = "Player banned successfully.",
        unbanSuccess = "Player unbanned successfully.",
        whitelistSuccess = "Item added to whitelist successfully.",
        configReloaded = "Configuration reloaded successfully.",
        debugToggled = "Debug mode toggled.",
        devModeToggled = "Developer mode toggled.",
        fillRequiredFields = "Please fill all required fields.",
        invalidIdentifier = "Please enter a valid identifier.",
        invalidName = "Please enter a valid name."
    }
}

-- Función para obtener mensaje localizado
function AdminPanelConfig.getMessage(key)
    local lang = AdminPanelConfig.UI.language or 'es'
    local messages = AdminPanelConfig.Messages[lang] or AdminPanelConfig.Messages.es
    return messages[key] or key
end

-- Función para validar configuración
function AdminPanelConfig.validate()
    -- Validar configuración de teclas
    if not AdminPanelConfig.Keybinds.openPanel then
        AdminPanelConfig.Keybinds.openPanel = 'F6'
    end
    
    -- Validar configuración de comandos
    if not AdminPanelConfig.Commands.primary then
        AdminPanelConfig.Commands.primary = 'hzadmin'
    end
    
    -- Validar configuración de UI
    if not AdminPanelConfig.UI.theme or (AdminPanelConfig.UI.theme ~= 'dark' and AdminPanelConfig.UI.theme ~= 'light') then
        AdminPanelConfig.UI.theme = 'dark'
    end
    
    if not AdminPanelConfig.UI.language or (AdminPanelConfig.UI.language ~= 'es' and AdminPanelConfig.UI.language ~= 'en') then
        AdminPanelConfig.UI.language = 'es'
    end
    
    -- Validar intervalos
    if not AdminPanelConfig.UI.refreshInterval or AdminPanelConfig.UI.refreshInterval < 5000 then
        AdminPanelConfig.UI.refreshInterval = 30000
    end
    
    if not AdminPanelConfig.UI.notificationDuration or AdminPanelConfig.UI.notificationDuration < 1000 then
        AdminPanelConfig.UI.notificationDuration = 3000
    end
    
    -- Validar configuración de baneos
    if not AdminPanelConfig.Bans.maxDuration or AdminPanelConfig.Bans.maxDuration < 1 then
        AdminPanelConfig.Bans.maxDuration = 525600
    end
    
    if not AdminPanelConfig.Bans.showRecentCount or AdminPanelConfig.Bans.showRecentCount < 1 then
        AdminPanelConfig.Bans.showRecentCount = 10
    end
    
    print("[HzAnticheat] Configuración del panel de administración validada.")
end

-- Inicializar configuración
CreateThread(function()
    AdminPanelConfig.validate()
end)

return AdminPanelConfig