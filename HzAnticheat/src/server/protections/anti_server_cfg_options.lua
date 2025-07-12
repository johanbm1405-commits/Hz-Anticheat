local logger = require("server/core/logger")
local ban_manager = require("server/core/ban_manager")

---@class AntiServerCfgOptionsModule
local AntiServerCfgOptions = {}

---@return void This function will apply the server security settings to the server
function AntiServerCfgOptions.initialize()
    -- Check if server security settings are enabled
    if not HzAnticheat.ServerSecurity or not HzAnticheat.ServerSecurity.Enabled then
        logger.info("[HzAnticheat] Server security configuration not enabled")
        return
    end
    
    -- CONNECTION & AUTHENTICATION SETTINGS
    if HzAnticheat.ServerSecurity.Connection then
        -- Timeout settings
        SetConvar("sv_kick_players_cnl_timeout_sec", tostring(HzAnticheat.ServerSecurity.Connection.KickTimeout or 600))
    SetConvar("sv_kick_players_cnl_update_rate_sec", tostring(HzAnticheat.ServerSecurity.Connection.UpdateRate or 60))
    SetConvar("sv_kick_players_cnl_consecutive_failures", tostring(HzAnticheat.ServerSecurity.Connection.ConsecutiveFailures or 2))
        
        -- Authentication settings
        SetConvar("sv_authMaxVariance", tostring(HzAnticheat.ServerSecurity.Connection.AuthMaxVariance or 1))
    SetConvar("sv_authMinTrust", tostring(HzAnticheat.ServerSecurity.Connection.AuthMinTrust or 5))
        
        -- Client verification
        SetConvar("sv_pure_verify_client_settings", HzAnticheat.ServerSecurity.Connection.VerifyClientSettings and "1" or "0")
    end
    
    -- NETWORK EVENT SECURITY
    if HzAnticheat.ServerSecurity.NetworkEvents then
        -- Block REQUEST_CONTROL_EVENT routing (supports values -1 to 4, 2 recommended for your use case)
        SetConvar("sv_filterRequestControl", tostring(HzAnticheat.ServerSecurity.NetworkEvents.FilterRequestControl or 0))
        
        -- Block NETWORK_PLAY_SOUND_EVENT routing
        SetConvar("sv_enableNetworkedSounds", HzAnticheat.ServerSecurity.NetworkEvents.DisableNetworkedSounds and "false" or "true")
        
        -- Block REQUEST_PHONE_EXPLOSION_EVENT
        SetConvar("sv_enableNetworkedPhoneExplosions", HzAnticheat.ServerSecurity.NetworkEvents.DisablePhoneExplosions and "false" or "true")
        
        -- Block SCRIPT_ENTITY_STATE_CHANGE_EVENT
        SetConvar("sv_enableNetworkedScriptEntityStates", HzAnticheat.ServerSecurity.NetworkEvents.DisableScriptEntityStates and "false" or "true")
    end
    
    -- CLIENT MODIFICATION PROTECTION
    if HzAnticheat.ServerSecurity.ClientProtection then
        -- Pure level setting
        SetConvar("sv_pureLevel", tostring(HzAnticheat.ServerSecurity.ClientProtection.PureLevel or 2))
        
        -- Disable client replays
        SetConvar("sv_disableClientReplays", HzAnticheat.ServerSecurity.ClientProtection.DisableClientReplays and "1" or "0")
        
        -- Script hook settings
        SetConvar("sv_scriptHookAllowed", HzAnticheat.ServerSecurity.ClientProtection.ScriptHookAllowed and "1" or "0")
    end
    
    -- MISC SECURITY SETTINGS
    if HzAnticheat.ServerSecurity.Misc then
        -- Enable chat sanitization
        SetConvar("sv_enableChatTextSanitization", HzAnticheat.ServerSecurity.Misc.EnableChatSanitization and "1" or "0")
        
        -- Rate limits
        if HzAnticheat.ServerSecurity.Misc.ResourceKvRateLimit then
            SetConvar("sv_defaultResourceKvRateLimit", tostring(HzAnticheat.ServerSecurity.Misc.ResourceKvRateLimit))
        end
        
        if HzAnticheat.ServerSecurity.Misc.EntityKvRateLimit then
            SetConvar("sv_defaultEntityKvRateLimit", tostring(HzAnticheat.ServerSecurity.Misc.EntityKvRateLimit))
        end
    end
    
    logger.info("[HzAnticheat] Server security configuration applied successfully")
end

return AntiServerCfgOptions













