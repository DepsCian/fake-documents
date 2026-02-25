local imgui = require("mimgui")
local ffi = require("ffi")
local Encoding = require("core/encoding")
local Licenses = require("documents/licenses/init")
local Save = require("documents/save")
local Helpers = require("ui/helpers")
local u8 = Encoding.u8

local LicensesUI = {}

function LicensesUI.render()
	local s = Licenses.state

	Helpers.renderDocumentHeader(s, nil, Licenses)

	imgui.Columns(3)
	imgui.Text(u8"Название")
	imgui.NextColumn()
	imgui.Text(u8"Активна")
	imgui.NextColumn()
	imgui.Text(u8"Срок действия")
	imgui.NextColumn()
	imgui.Separator()

	for i, item in ipairs(s.items) do
		imgui.Text(item.name)
		imgui.NextColumn()

		if imgui.Checkbox("##lic_" .. i, item.enabled) then
			Save.execute()
		end
		imgui.NextColumn()

		imgui.PushItemWidth(imgui.GetColumnWidth() - 10)
		imgui.InputText("##lic_date_" .. i, item.date, ffi.sizeof(item.date))
		imgui.PopItemWidth()
		imgui.NextColumn()
	end

	imgui.Columns(1)
end

return LicensesUI
