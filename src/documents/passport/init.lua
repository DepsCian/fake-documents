local Factory = require("core/document_factory")
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

return Factory.create(FIELDS, DEFAULTS)