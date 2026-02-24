local imgui = require("mimgui")
local ffi = require("ffi")
local Encoding = require("core/encoding")
local Save = require("documents/save")
local u8 = Encoding.u8

local Helpers = {}

function Helpers.renderDocumentHeader(state, emptyStateLabel)
    if imgui.Checkbox(u8"Включено", state.enabled) then Save.execute() end
    imgui.SameLine()
    if imgui.Checkbox(u8"Не менять чужие документы", state.onlyOwn) then Save.execute() end
    if emptyStateLabel and state.showEmptyState then
        imgui.SameLine()
        if imgui.Checkbox(emptyStateLabel, state.showEmptyState) then Save.execute() end
    end
    imgui.Separator()
end

function Helpers.renderRow(label, id, setting)
    imgui.Text(label)
    imgui.NextColumn()
    imgui.PushItemWidth(imgui.GetColumnWidth() - 10)
    imgui.InputText("##" .. id, setting.value, ffi.sizeof(setting.value))
    imgui.PopItemWidth()
    imgui.NextColumn()
    imgui.Checkbox("##" .. id .. "_enabled", setting.enabled)
    imgui.NextColumn()
end

function Helpers.renderFieldTable(labels, state)
    imgui.Columns(3)
    imgui.Text(u8"Параметр")
    imgui.NextColumn()
    imgui.Text(u8"Значение")
    imgui.NextColumn()
    imgui.Text(u8"Включено")
    imgui.NextColumn()
    imgui.Separator()

    for _, item in ipairs(labels) do
        Helpers.renderRow(item.label, item.key, state[item.key])
    end

    imgui.Columns(1)
end

return Helpers
