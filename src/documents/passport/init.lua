local imgui = require("mimgui")
local ffi = require("ffi")
local Encoding = require("core/encoding")
local u8 = Encoding.u8

local FIELDS = {
    { key = "name",         bufSize = 256 },
    { key = "sex",          bufSize = 64 },
    { key = "birthday",     bufSize = 64 },
    { key = "citizen",      bufSize = 128 },
    { key = "married",      bufSize = 64 },
    { key = "level",        bufSize = 64 },
    { key = "zakono",       bufSize = 64 },
    { key = "job",          bufSize = 128 },
    { key = "povestka",     bufSize = 128 },
    { key = "rank",         bufSize = 128 },
    { key = "organization", bufSize = 128 },
    { key = "seria",        bufSize = 32 },
    { key = "number",       bufSize = 32 },
    { key = "signature",    bufSize = 128 },
    { key = "avatarUrl",    bufSize = 512 },
}

local DEFAULTS = {
    enabled  = false,
    onlyOwn  = true,
    showEmptyState = false,
    name     = { value = u8"Олег Тиньков",       enabled = true },
    sex      = { value = u8"Мужской",             enabled = true },
    birthday = { value = u8"25.12.1967",          enabled = true },
    citizen  = { value = u8"Российская Федерация", enabled = true },
    married  = { value = u8"Женат",               enabled = true },
    level    = { value = u8"99",                  enabled = true },
    zakono   = { value = u8"777",                 enabled = true },
    job      = { value = u8"Предприниматель",     enabled = true },
    povestka = { value = u8"Нет",                 enabled = true },
    rank     = { value = u8"CEO",                 enabled = true },
    organization = { value = u8"Tinkoff Bank",    enabled = true },
    seria    = { value = u8"0011",                enabled = true },
    number   = { value = u8"777777",              enabled = true },
    signature = { value = u8"O.Tinkoff",          enabled = true },
    avatarUrl = {
        value = u8"https://storage.googleapis.com/activatica/uploads/f39fc1d4-16df-4d3e-97de-5eaa235edd3c",
        enabled = true
    },
}

local Passport = {}
Passport.FIELDS = FIELDS
Passport.DEFAULTS = DEFAULTS
Passport.state = nil

function Passport.createState(cfg)
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
    Passport.state = state
    return state
end

function Passport.syncToConfig(cfg)
    local s = Passport.state
    cfg.enabled = s.enabled[0]
    cfg.onlyOwn = s.onlyOwn[0]
    cfg.showEmptyState = s.showEmptyState[0]
    for _, field in ipairs(FIELDS) do
        cfg[field.key].value   = ffi.string(s[field.key].value)
        cfg[field.key].enabled = s[field.key].enabled[0]
    end
end

return Passport
