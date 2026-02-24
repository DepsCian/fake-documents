local imgui = require("mimgui")
local Encoding = require("core/encoding")
local Vehicle = require("documents/vehicle/init")
local Save = require("documents/save")
local Helpers = require("ui/helpers")
local u8 = Encoding.u8

local LABELS = {
    { key = "name",        label = u8"Название" },
    { key = "number",      label = u8"Номер" },
    { key = "cost",        label = u8"Стоимость" },
    { key = "milliage",    label = u8"Пробег" },
    { key = "status_text", label = u8"Статус" },
}

local HEADERS = {}
for i = 1, Vehicle.MAX_VEHICLES do
    HEADERS[i] = u8"Транспорт #" .. tostring(i)
end

local VehicleUI = {}

function VehicleUI.render()
    local s = Vehicle.state

    if imgui.Checkbox(u8"Включено", s.enabled) then Save.execute() end
    imgui.SameLine()
    if imgui.Checkbox(u8"Не менять чужие документы", s.onlyOwn) then Save.execute() end
    imgui.Separator()

    for i = 1, Vehicle.MAX_VEHICLES do
        if imgui.CollapsingHeader(HEADERS[i]) then
            local vState = s.vehicles[i]
            if imgui.Checkbox(u8"Включено##vehicle_" .. tostring(i), vState.enabled) then
                Save.execute()
            end
            Helpers.renderFieldTable(LABELS, vState)
        end
    end
end

return VehicleUI
