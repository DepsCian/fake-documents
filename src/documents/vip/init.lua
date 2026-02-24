local imgui = require("mimgui")
local ffi = require("ffi")
local Encoding = require("core/encoding")
local u8 = Encoding.u8

local FIELDS = {
    { key = "statusName", bufSize = 128 },
    { key = "statusTime", bufSize = 128 },
    { key = "addVipDays", bufSize = 128 },
}

local DEFAULTS = {
    enabled    = false,
    onlyOwn    = true,
    statusName = { value = u8"VIP Diamond", enabled = true },
    statusTime = { value = u8"999 дней",    enabled = true },
    addVipDays = { value = u8"999 дней",    enabled = true },
}

local Vip = {}
Vip.FIELDS = FIELDS
Vip.DEFAULTS = DEFAULTS
Vip.state = nil

function Vip.createState(cfg)
    local state = {
        enabled = imgui.new.bool(cfg.enabled),
        onlyOwn = imgui.new.bool(cfg.onlyOwn ~= false),
    }
    for _, field in ipairs(FIELDS) do
        state[field.key] = {
            value   = imgui.new.char[field.bufSize](cfg[field.key].value),
            enabled = imgui.new.bool(cfg[field.key].enabled),
        }
    end
    Vip.state = state
    return state
end

function Vip.syncToConfig(cfg)
    local s = Vip.state
    cfg.enabled = s.enabled[0]
    cfg.onlyOwn = s.onlyOwn[0]
    for _, field in ipairs(FIELDS) do
        cfg[field.key].value   = ffi.string(s[field.key].value)
        cfg[field.key].enabled = s[field.key].enabled[0]
    end
end

return Vip
