local Factory = require("core/document_factory")
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
    showEmptyState = false,
    examProgress = false,
    name         = { value = u8"Александр Невский",    enabled = true },
    ukrop        = { value = u8"0.0",                  enabled = true },
    health       = { value = u8"Полностью здоров",     enabled = true },
    insurance    = { value = u8"Platinum",              enabled = true },
    validity     = { value = u8"999 дня(ей)",           enabled = true },
    psychiatric  = { value = u8"0 раз(а)",              enabled = true },
    avatarUrl    = { value = u8"",                      enabled = false },
}

return Factory.create(FIELDS, DEFAULTS)