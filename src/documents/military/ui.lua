local imgui = require("mimgui")
local Encoding = require("core/encoding")
local Military = require("documents/military/init")
local Save = require("documents/save")
local Helpers = require("ui/helpers")
local u8 = Encoding.u8

local LABELS = {
    { key = "name",             label = u8"Имя и фамилия" },
    { key = "army_online",      label = u8"Срок действия" },
    { key = "have_army_ticket", label = u8"Военный билет" },
    { key = "rank",             label = u8"Звание" },
    { key = "avatarUrl",        label = u8"URL фото" },
}

local MilitaryUI = {}

function MilitaryUI.render()
    local s = Military.state

    Helpers.renderDocumentHeader(s, u8"Показать 'нет военного билета'", Military)

    Helpers.renderFieldTable(LABELS, s)
end

return MilitaryUI
