local imgui = require("mimgui")
local ffi = require("ffi")
local Encoding = require("core/encoding")
local u8 = Encoding.u8

local FIELDS = {
    { key = "name",        bufSize = 256 },
    { key = "ukrop",       bufSize = 32 },
    { key = "health",      bufSize = 128 },
    { key = "insurance",   bufSize = 128 },
    { key = "validity",    bufSize = 128 },
    { key = "psychiatric", bufSize = 64 },
    { key = "avatarUrl",   bufSize = 512 },
}

local DEFAULTS = {
    enabled      = false,
    onlyOwn      = true,
    examProgress = false,
    name         = { value = u8"Александр Невский",    enabled = true },
    ukrop        = { value = u8"0.0",                  enabled = true },
    health       = { value = u8"Полностью здоров",     enabled = true },
    insurance    = { value = u8"Platinum",              enabled = true },
    validity     = { value = u8"999 дня(ей)",           enabled = true },
    psychiatric  = { value = u8"0 раз(а)",              enabled = true },
    avatarUrl    = { value = u8"",                      enabled = false },
}

local Medical = {}
Medical.FIELDS = FIELDS
Medical.DEFAULTS = DEFAULTS
Medical.state = nil

function Medical.createState(cfg)
    local state = {
        enabled      = imgui.new.bool(cfg.enabled),
        onlyOwn      = imgui.new.bool(cfg.onlyOwn ~= false),
        examProgress = imgui.new.bool(cfg.examProgress),
    }
    for _, field in ipairs(FIELDS) do
        state[field.key] = {
            value   = imgui.new.char[field.bufSize](cfg[field.key].value),
            enabled = imgui.new.bool(cfg[field.key].enabled),
        }
    end
    Medical.state = state
    return state
end

function Medical.syncToConfig(cfg)
    local s = Medical.state
    cfg.enabled      = s.enabled[0]
    cfg.onlyOwn      = s.onlyOwn[0]
    cfg.examProgress = s.examProgress[0]
    for _, field in ipairs(FIELDS) do
        cfg[field.key].value   = ffi.string(s[field.key].value)
        cfg[field.key].enabled = s[field.key].enabled[0]
    end
end

return Medical
