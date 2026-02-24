local imgui = require("mimgui")
local ffi = require("ffi")
local Encoding = require("core/encoding")
local Vip = require("documents/vip/init")
local Save = require("documents/save")
local Helpers = require("ui/helpers")
local u8 = Encoding.u8

local LABELS = {
    { key = "statusTime", label = u8"Срок действия" },
    { key = "addVipDays", label = u8"ADD VIP (дни)" },
}

local VIP_TYPES = {
    { name = "ADD VIP", value = u8"ADD VIP" },
    { name = "Premium VIP", value = u8"Premium VIP" },
    { name = "Titan VIP", value = u8"Titan VIP" },
    { name = "Diamond VIP", value = u8"Diamond VIP" },
}

local VipUI = {}

function VipUI.render()
    local s = Vip.state

    if imgui.Checkbox(u8"Включено", s.enabled) then Save.execute() end
    imgui.SameLine()
    if imgui.Checkbox(u8"Не менять чужие документы", s.onlyOwn) then Save.execute() end
    imgui.Separator()

    imgui.Text(u8"Ваш текущий статус:")
    local current_status = ffi.string(s.statusName.value)
    for _, vip in ipairs(VIP_TYPES) do
        local is_selected = current_status == ffi.string(vip.value)
        local checkbox_state = imgui.new.bool(is_selected)
        if imgui.Checkbox(u8(vip.name .. "##viptype"), checkbox_state) then
            if not is_selected then
                ffi.copy(s.statusName.value, vip.value)
                Save.execute()
            end
        end
    end

    imgui.Separator()

    Helpers.renderFieldTable(LABELS, s)

    imgui.Separator()
    imgui.Text(u8"Premium уровни:")
    for i = 1, 10 do
        local lvl = s.premiumLevels[i]
        if imgui.Checkbox(u8("Уровень " .. i), lvl.enabled) then Save.execute() end
        imgui.SameLine()
        if imgui.Checkbox(u8("##mark" .. i), lvl.mark) then Save.execute() end
        if lvl.enabled[0] then
            imgui.InputText(u8("##text" .. i), lvl.text.value, 256)
            imgui.InputText(u8("##desc" .. i), lvl.desc.value, 512)
        end
    end

    imgui.Separator()
    imgui.Text(u8"VIP статусы:")
    for i = 1, 4 do
        local st = s.vipStatuses[i]
        if imgui.Checkbox(u8(VIP_TYPES[i].name), st.enabled) then Save.execute() end
        if st.enabled[0] then
            imgui.InputText(u8("##vipdate" .. i), st.date.value, 128)
        end
    end
end

return VipUI
