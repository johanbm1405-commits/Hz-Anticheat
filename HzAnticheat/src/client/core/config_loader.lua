---@class ConfigLoaderModule
local ConfigLoader = {}

local Utils = require("shared/lib/utils")
local ClientLogger = require("client/core/client_logger")
local protection_count = {}

-- Initialize global variables
_G.HzAnticheatConfig = nil
_G.HzAnticheatLoaded = false
_G.HzAnticheatProtectionSettings = {}
_G.HzAnticheatInitCalled = false
_G.HzAnticheatAdminList = {}
_G.HzAnticheatLastAdminUpdate = 0

---@description Initialize the client-side config loader
function ConfigLoader.initialize()
    if _G.HzAnticheatInitCalled then return end
    _G.HzAnticheatInitCalled = true
    
    ClientLogger.info("^5[LOADING] ^3Client Config^7")
    
    TriggerServerEvent("requestConfig")
    
    RegisterNetEvent("receiveConfig", function(serverConfig)
        _G.HzAnticheatConfig = serverConfig
        _G.HzAnticheat = serverConfig
        ConfigLoader.process_config(serverConfig)
        _G.HzAnticheatLoaded = true
        ClientLogger.info("^5[SUCCESS] ^3Client Config^7 received from server")
    end)
    
    local attempts = 0
    local maxAttempts = 10
    
    while not _G.HzAnticheatLoaded and attempts < maxAttempts do
        Wait(1000)
        attempts = attempts + 1
        if not _G.HzAnticheatLoaded then
            TriggerServerEvent("requestConfig")
        end
    end
end

---@description Get config value with optional default
---@param key string The config key to get
---@param default any Optional default value if key doesn't exist
---@return any The config value or default
function ConfigLoader.get(key, default)
    if not _G.HzAnticheatLoaded or not _G.HzAnticheatConfig then
        return default
    end
    
    local parts = {}
    for part in key:gmatch("[^%.]+") do
        table.insert(parts, part)
    end
    
    local value = _G.HzAnticheatConfig
    for _, part in ipairs(parts) do
        if type(value) ~= "table" then
            return default
        end
        value = value[part]
        if value == nil then
            return default
        end
    end
    
    return value
end

---@description Check if config has been loaded
---@return boolean is_loaded Whether config has been loaded
function ConfigLoader.is_loaded()
    return _G.HzAnticheatLoaded
end

---@description Get the entire config table
---@return table config The config table
function ConfigLoader.get_config()
    return _G.HzAnticheatConfig
end

---@description Get the HzAnticheat configuration
---@return table hzanticheat The HzAnticheat configuration
function ConfigLoader.get_secureserve()
    return _G.HzAnticheat
end

---@description Ensure settings are initialized
local function ensure_initialized()
    if not _G.HzAnticheatInitCalled then
        ConfigLoader.initialize()
        Wait(1000) 
    end
end

---@description Get protection setting directly from HzAnticheat.Protection.Simple
---@param name string The name of the protection
---@param property string The property to get
---@return any value The protection setting value
local function get_from_simple_protection(name, property)
    if not _G.HzAnticheat or not _G.HzAnticheat.Protection or not _G.HzAnticheat.Protection.Simple then
        return nil
    end
    
    for _, v in pairs(_G.HzAnticheat.Protection.Simple) do
        if v.protection == name then
            if property == "time" and type(v.time) ~= "number" and _G.HzAnticheat.BanTimes then
                return _G.HzAnticheat.BanTimes[v.time]
            elseif property == "webhook" and v.webhook == "" and _G.HzAnticheat.Webhooks then
                return _G.HzAnticheat.Webhooks.Simple
            else
                return v[property]
            end
        end
    end
    
    return nil
end

---@description Get a protection setting by name and property
---@param name string The name of the protection
---@param property string The property to get
---@return any value The protection setting value
function ConfigLoader.get_protection_setting(name, property)

    
    if not name or not property then
        return nil
    end
    
    if _G.HzAnticheatProtectionSettings[name] and _G.HzAnticheatProtectionSettings[name][property] ~= nil then
        return _G.HzAnticheatProtectionSettings[name][property]
    end
    
    if _G.HzAnticheatLoaded and _G.HzAnticheat and _G.HzAnticheat.Protection and _G.HzAnticheat.Protection.Simple then
        for _, v in pairs(_G.HzAnticheat.Protection.Simple) do
            if v.protection == name then
                local time = v.time
                if type(time) ~= "number" and _G.HzAnticheat.BanTimes then
                    time = _G.HzAnticheat.BanTimes[v.time]
                end
                
                local webhook = v.webhook
                if webhook == "" and _G.HzAnticheat.Webhooks then
                    webhook = _G.HzAnticheat.Webhooks.Simple
                end
                
                local settings = {
                    time = time,
                    limit = v.limit or 999,
                    webhook = webhook,
                    enabled = v.enabled,
                    default = v.default,
                    defaultr = v.defaultr,
                    tolerance = v.tolerance,
                    defaults = v.defaults,
                    dispatch = v.dispatch
                }
                
                _G.HzAnticheatProtectionSettings[name] = settings
                
                return settings[property]
            end
        end
    end
    
    return get_from_simple_protection(name, property)
end

---@param config table The received config from server
function ConfigLoader.process_config(config)
    if not config then return end
    
    _G.HzAnticheat = config 
    local HzAnticheat = _G.HzAnticheat
    
    _G.HzAnticheatProtectionSettings = _G.HzAnticheatProtectionSettings or {}
    
    for k, v in pairs(HzAnticheat.Protection.Simple) do
        if v.webhook == "" then
            HzAnticheat.Protection.Simple[k].webhook = HzAnticheat.Webhooks.Simple
        end
        if type(v.time) ~= "number" then
            HzAnticheat.Protection.Simple[k].time = HzAnticheat.BanTimes[v.time]
        end
        
        local name = HzAnticheat.Protection.Simple[k].protection
        local dispatch = HzAnticheat.Protection.Simple[k].dispatch
        local default = HzAnticheat.Protection.Simple[k].default
        local defaultr = HzAnticheat.Protection.Simple[k].defaultr
        local tolerance = HzAnticheat.Protection.Simple[k].tolerance
        local defaults = HzAnticheat.Protection.Simple[k].defaults
        local time = HzAnticheat.Protection.Simple[k].time
        if type(time) ~= "number" then
            time = HzAnticheat.BanTimes[v.time]
        end
        local limit = HzAnticheat.Protection.Simple[k].limit or 999
        local webhook = HzAnticheat.Protection.Simple[k].webhook
        if webhook == "" then
            webhook = HzAnticheat.Webhooks.Simple
        end
        local enabled = HzAnticheat.Protection.Simple[k].enabled
        
        ConfigLoader.assign_protection_settings(name, {
            ["time"] = time,
            ["limit"] = limit,
            ["webhook"] = webhook,
            ["enabled"] = enabled,
            ["default"] = default,
            ["defaultr"] = defaultr,
            ["tolerance"] = tolerance,
            ["defaults"] = defaults,
            ["dispatch"] = dispatch
        })
        
        if not protection_count["HzAnticheat.Protection.Simple"] then protection_count["HzAnticheat.Protection.Simple"] = 0 end
        protection_count["HzAnticheat.Protection.Simple"] = protection_count["HzAnticheat.Protection.Simple"] + 1
    end

    ConfigLoader.process_blacklist_category("BlacklistedCommands")
    ConfigLoader.process_blacklist_category("BlacklistedSprites")
    ConfigLoader.process_blacklist_category("BlacklistedAnimDicts")
    ConfigLoader.process_blacklist_category("BlacklistedExplosions")
    ConfigLoader.process_blacklist_category("BlacklistedWeapons")
    ConfigLoader.process_blacklist_category("BlacklistedVehicles")
    ConfigLoader.process_blacklist_category("BlacklistedObjects")
end

---@param category string The blacklist category to process
function ConfigLoader.process_blacklist_category(category)
    local HzAnticheat = _G.HzAnticheat  
    
    for k, v in pairs(HzAnticheat.Protection[category]) do
        if v.webhook == "" then
            HzAnticheat.Protection[category][k].webhook = HzAnticheat.Webhooks[category]
        end
        if type(v.time) ~= "number" then
            HzAnticheat.Protection[category][k].time = HzAnticheat.BanTimes[v.time]
        end
                
        if not protection_count["HzAnticheat.Protection." .. category] then
            protection_count["HzAnticheat.Protection." .. category] = 0
        end
        protection_count["HzAnticheat.Protection." .. category] = protection_count["HzAnticheat.Protection." .. category] + 1
    end
end

---@param name string The name of the protection
---@param settings table The settings to assign
function ConfigLoader.assign_protection_settings(name, settings)
    _G.HzAnticheatProtectionSettings[name] = settings
end

---@param player number The player ID to check
---@return boolean is_whitelisted Whether the player is whitelisted
function ConfigLoader.is_whitelisted(player_id)
    local player_id = player_id or GetPlayerServerId(PlayerId())
    
    local currentTime = GetGameTimer()
    if currentTime - _G.HzAnticheatLastAdminUpdate > 60000 then
        TriggerServerEvent("HzAnticheat:RequestAdminList")
        _G.HzAnticheatLastAdminUpdate = currentTime
    end
    
    if _G.HzAnticheatAdminList[tostring(player_id)] then
        return true
    end
    
    return false
end

RegisterNetEvent("HzAnticheat:ReceiveAdminList", function(adminList)
    _G.HzAnticheatAdminList = adminList
    _G.HzAnticheatLastAdminUpdate = GetGameTimer()
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000) 
    TriggerServerEvent("HzAnticheat:RequestAdminList")
    _G.HzAnticheatLastAdminUpdate = GetGameTimer()
end)

---@param player number The player ID to check
---@return boolean is_menu_admin Whether the player is a menu admin
function ConfigLoader.is_menu_admin(player)
    local promise = promise.new()

    TriggerServerEvent('HzAnticheat:RequestMenuAdminStatus', player)

    RegisterNetEvent('HzAnticheat:ReturnMenuAdminStatus', function(result)
        promise:resolve(result)
    end)

    return Citizen.Await(promise)
end

---@description Check if a model is blacklisted
---@param model_hash string|number The model hash to check
---@return boolean is_blacklisted Whether the model is blacklisted
function ConfigLoader.is_model_blacklisted(model_hash)

    if not _G.HzAnticheatLoaded or not _G.HzAnticheatConfig then
        return false
    end
    
    model_hash = tostring(model_hash)
    
    if _G.HzAnticheatConfig.Protection and _G.HzAnticheatConfig.Protection.BlacklistedObjects then
        for _, blacklisted in pairs(_G.HzAnticheatConfig.Protection.BlacklistedObjects) do
            if tostring(blacklisted.hash) == model_hash then
                return true
            end
        end
    end
    
    if _G.HzAnticheatConfig.Protection and _G.HzAnticheatConfig.Protection.BlacklistedVehicles then
        for _, blacklisted in pairs(_G.HzAnticheatConfig.Protection.BlacklistedVehicles) do
            if tostring(blacklisted.hash) == model_hash then
                return true
            end
        end
    end
    
    if _G.HzAnticheatConfig.Protection and _G.HzAnticheatConfig.Protection.BlacklistedPeds then
        for _, blacklisted in pairs(_G.HzAnticheatConfig.Protection.BlacklistedPeds) do
            if tostring(blacklisted.hash) == model_hash then
                return true
            end
        end
    end
    
    return false
end

return ConfigLoader














