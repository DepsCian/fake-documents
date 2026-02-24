local imgui = require("mimgui")
local Encoding = require("core/encoding")
local Vip = require("documents/vip/init")
local Save = require("documents/save")
local Helpers = require("ui/helpers")
local u8 = Encoding.u8

local LABELS = {
    { key = "statusName", label = u8"Название статуса" },
    { key = "statusTime", label = u8"Срок действия" },
    { key = "addVipDays", label = u8"ADD VIP (дни)" },
}

local VipUI = {}

function VipUI.render()
    local s = Vip.state

    if imgui.Checkbox(u8"Включено", s.enabled) then Save.execute() end
    imgui.SameLine()
    if imgui.Checkbox(u8"Не менять чужие документы", s.onlyOwn) then Save.execute() end
    imgui.Separator()

    Helpers.renderFieldTable(LABELS, s)
end

return VipUI
