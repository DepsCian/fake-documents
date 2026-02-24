local imgui = require("mimgui")
local ffi = require("ffi")
local Encoding = require("core/encoding")
local u8 = Encoding.u8

local FIELDS = {
    { key = "name",             bufSize = 256 },
    { key = "army_online",      bufSize = 128 },
    { key = "have_army_ticket", bufSize = 128 },
    { key = "rank",             bufSize = 128 },
    { key = "avatarUrl",        bufSize = 512 },
}

local DEFAULTS = {
    enabled  = false,
    onlyOwn  = true,
    showEmptyState = false,
    name             = { value = u8"Олег Тиньков",  enabled = true },
    army_online      = { value = u8"999 дней",      enabled = true },
    have_army_ticket = { value = u8"Имеется",       enabled = true },
    rank             = { value = u8"Генерал",       enabled = true },
    avatarUrl        = { value = u8"",              enabled = false },
}

local Military = {}
Military.FIELDS = FIELDS
Military.DEFAULTS = DEFAULTS
Military.state = nil

function Military.createState(cfg)
    local state = {
        enabled = imgui.new.bool(cfg.enabled),
        onlyOwn = imgui.new.bool(cfg.onlyOwn ~= false),
        showEmptyState = imgui.new.bool(cfg.showEmptyState == true),
    }
    for _, field in ipairs(FIELDS) do
        state[field.key] = {
            value   = imgui.new.char[field.bufSize](cfg[field.key].value),
            enabled = imgui.new.bool(cfg[field.key].enabled),
        }
    end
    Military.state = state
    return state
end

function Military.syncToConfig(cfg)
    local s = Military.state
    cfg.enabled = s.enabled[0]
    cfg.onlyOwn = s.onlyOwn[0]
    cfg.showEmptyState = s.showEmptyState[0]
    for _, field in ipairs(FIELDS) do
        cfg[field.key].value   = ffi.string(s[field.key].value)
        cfg[field.key].enabled = s[field.key].enabled[0]
    end
end

return Military
