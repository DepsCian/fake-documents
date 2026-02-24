local imgui = require("mimgui")
local ffi = require("ffi")
local Encoding = require("core/encoding")
local Property = require("documents/property/init")
local Save = require("documents/save")
local Helpers = require("ui/helpers")
local u8 = Encoding.u8

local PropertyUI = {}

local function _renderSlots(categoryState, prefix)
    for i = 1, 5 do
        local slot = categoryState[i]
        if imgui.Checkbox(u8"Изменить ##" .. prefix .. "_" .. i, slot.enabled) then
            Save.execute()
        end
        if slot.enabled[0] then
            imgui.SameLine()
            imgui.PushItemWidth(300)
            imgui.InputText("##" .. prefix .. "_name_" .. i, slot.name.value, ffi.sizeof(slot.name.value))
            imgui.PopItemWidth()
            imgui.SameLine()
            if imgui.Checkbox(u8"Вкл##" .. prefix .. "_name_en_" .. i, slot.name.enabled) then
                Save.execute()
            end
        end
    end
end

function PropertyUI.render()
    local s = Property.state

    Helpers.renderDocumentHeader(s)

    if imgui.CollapsingHeader(u8"Жилая недвижимость") then
        _renderSlots(s.residential, "res")
    end

    if imgui.CollapsingHeader(u8"Комерческая недвижимость") then
        _renderSlots(s.commercial, "com")
    end
end

return PropertyUI
