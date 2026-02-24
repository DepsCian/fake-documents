local imgui = require("mimgui")
local ffi = require("ffi")
local Encoding = require("core/encoding")
local u8 = Encoding.u8

local VEHICLE_FIELDS = {
    { key = "name",        bufSize = 128 },
    { key = "number",      bufSize = 64 },
    { key = "cost",        bufSize = 64 },
    { key = "milliage",    bufSize = 64 },
    { key = "status_text", bufSize = 128 },
    { key = "image_url",   bufSize = 256 },
}

local MAX_VEHICLES = 5

local function _createVehicleDefaults()
    return {
        enabled     = false,
        name        = { value = u8"Bugatti Chiron",  enabled = false },
        number      = { value = u8"A777AA",          enabled = false },
        cost        = { value = u8"$15,000,000",     enabled = false },
        milliage    = { value = u8"1,337 km",        enabled = false },
        status_text = { value = u8"В гараже",        enabled = false },
        image_url   = { value = u8"/projects/arizona-rp/assets/images/inventory/vehicles/512/402.webp", enabled = false },
    }
end

local function _buildDefaults()
    local vehicles = {}
    for i = 1, MAX_VEHICLES do
        vehicles[i] = _createVehicleDefaults()
    end
    return {
        enabled  = false,
        onlyOwn  = true,
        count    = MAX_VEHICLES,
        vehicles = vehicles,
    }
end

local DEFAULTS = _buildDefaults()

local Vehicle = {}
Vehicle.VEHICLE_FIELDS = VEHICLE_FIELDS
Vehicle.DEFAULTS = DEFAULTS
Vehicle.MAX_VEHICLES = MAX_VEHICLES
Vehicle.state = nil

function Vehicle.createState(cfg)
    local state = {
        enabled = imgui.new.bool(cfg.enabled),
        onlyOwn = imgui.new.bool(cfg.onlyOwn ~= false),
        vehicles = {},
    }
    for i = 1, MAX_VEHICLES do
        local vCfg = cfg.vehicles[i] or _createVehicleDefaults()
        local vState = {
            enabled = imgui.new.bool(vCfg.enabled),
        }
        for _, field in ipairs(VEHICLE_FIELDS) do
            vState[field.key] = {
                value   = imgui.new.char[field.bufSize](vCfg[field.key].value),
                enabled = imgui.new.bool(vCfg[field.key].enabled),
            }
        end
        state.vehicles[i] = vState
    end
    Vehicle.state = state
    return state
end

function Vehicle.syncToConfig(cfg)
    local s = Vehicle.state
    cfg.enabled = s.enabled[0]
    cfg.onlyOwn = s.onlyOwn[0]
    for i = 1, MAX_VEHICLES do
        local vState = s.vehicles[i]
        local vCfg = cfg.vehicles[i]
        vCfg.enabled = vState.enabled[0]
        for _, field in ipairs(VEHICLE_FIELDS) do
            vCfg[field.key].value   = ffi.string(vState[field.key].value)
            vCfg[field.key].enabled = vState[field.key].enabled[0]
        end
    end
end

return Vehicle
