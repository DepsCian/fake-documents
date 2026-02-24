local imgui = require("mimgui")
local Encoding = require("core/encoding")
local Medical = require("documents/medical/init")
local Save = require("documents/save")
local Helpers = require("ui/helpers")
local u8 = Encoding.u8

local LABELS = {
    { key = "name",        label = u8"Имя и фамилия" },
    { key = "ukrop",       label = u8"Зависимость от укропа" },
    { key = "health",      label = u8"Состояние здоровья" },
    { key = "insurance",   label = u8"Медицинская страховка" },
    { key = "validity",    label = u8"Срок действия" },
    { key = "psychiatric", label = u8"Лечился в псих.больнице" },
    { key = "avatarUrl",   label = u8"URL фото" },
}

local MedicalUI = {}

function MedicalUI.render()
    local s = Medical.state

    Helpers.renderDocumentHeader(s, u8"Показать 'нет мед.карты'")

    Helpers.renderFieldTable(LABELS, s)

    imgui.Separator()
    imgui.Checkbox(u8"Медосмотр пройден (10/10)", s.examProgress)
end

return MedicalUI
