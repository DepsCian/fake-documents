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

function Helpers.renderRow(label, id, setting, disabled)
    imgui.Text(label)
    imgui.NextColumn()
    imgui.PushItemWidth(imgui.GetColumnWidth() - 10)
    if disabled then imgui.BeginDisabled() end
    imgui.InputText("##" .. id, setting.value, ffi.sizeof(setting.value))
    if disabled then imgui.EndDisabled() end
    imgui.PopItemWidth()
    imgui.NextColumn()
    if disabled then imgui.BeginDisabled() end
    imgui.Checkbox("##" .. id .. "_enabled", setting.enabled)
    if disabled then imgui.EndDisabled() end
    imgui.NextColumn()
end

function Helpers.renderFieldTable(labels, state)
    local disabled = state.enabled and not state.enabled[0]
    
    imgui.Columns(3)
    imgui.Text(u8"Параметр")
    imgui.NextColumn()
    imgui.Text(u8"Значение")
    imgui.NextColumn()
    imgui.Text(u8"Включено")
    imgui.NextColumn()
    imgui.Separator()

    for _, item in ipairs(labels) do
        Helpers.renderRow(item.label, item.key, state[item.key], disabled)
    end

    imgui.Columns(1)
end

return Helpers
