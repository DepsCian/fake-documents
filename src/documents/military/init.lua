local Factory = require("core/document_factory")
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

return Factory.create(FIELDS, DEFAULTS)