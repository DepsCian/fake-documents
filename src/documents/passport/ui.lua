local imgui = require("mimgui")
local Encoding = require("core/encoding")
local Passport = require("documents/passport/init")
local Save = require("documents/save")
local Helpers = require("ui/helpers")
local u8 = Encoding.u8

local LABELS = {
    { key = "name",         label = u8"Имя и фамилия" },
    { key = "sex",          label = u8"Пол" },
    { key = "birthday",     label = u8"Дата рождения" },
    { key = "citizen",      label = u8"Гражданство" },
    { key = "married",      label = u8"Семейное положение" },
    { key = "level",        label = u8"Уровень" },
    { key = "zakono",       label = u8"Законопослушность" },
    { key = "job",          label = u8"Работа" },
    { key = "povestka",     label = u8"Повестка" },
    { key = "rank",         label = u8"Ранг" },
    { key = "organization", label = u8"Организация" },
    { key = "seria",        label = u8"Серия" },
    { key = "number",       label = u8"Номер" },
    { key = "signature",    label = u8"Подпись" },
    { key = "avatarUrl",    label = u8"URL фото" },
}

local PassportUI = {}

function PassportUI.render()
    local s = Passport.state

    Helpers.renderDocumentHeader(s, u8"Показать 'нет паспорта'", Passport)

    Helpers.renderFieldTable(LABELS, s)
end

return PassportUI
