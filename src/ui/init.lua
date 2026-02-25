local imgui = require("mimgui")
local Encoding = require("core/encoding")
local Save = require("documents/save")
local PassportUI = require("documents/passport/ui")
local LicensesUI = require("documents/licenses/ui")
local MedicalUI = require("documents/medical/ui")
local MilitaryUI = require("documents/military/ui")
local PropertyUI = require("documents/property/ui")
local VehicleUI = require("documents/vehicle/ui")
local VipUI = require("documents/vip/ui")
local u8 = Encoding.u8

local UI = {}

local _window = imgui.new.bool(false)
local _resX, _resY = getScreenResolution()

local FORGE_URL =
	"https://depscian.tech/forge?utm_source=fake-documents&utm_medium=moonloader&utm_campaign=in-game-script"
local FORGE_TITLE = u8"Arizona Forge"
local FORGE_DESC = u8"3D конфигуратор сетов Arizona RP"
local FORGE_LINK_TEXT = u8"Открыть Arizona Forge"
local FORGE_COLOR = imgui.ImVec4(0.33, 0.67, 0.82, 1.0)
local FORGE_COLOR_HOVER = imgui.ImVec4(0.45, 0.78, 0.93, 1.0)

local TABS = { {
	name = u8"Паспорт",
	render = PassportUI.render,
}, {
	name = u8"Лицензии",
	render = LicensesUI.render,
}, {
	name = u8"Мед. карта",
	render = MedicalUI.render,
}, {
	name = u8"Военный",
	render = MilitaryUI.render,
}, {
	name = u8"Недвижимость",
	render = PropertyUI.render,
}, {
	name = u8"Транспорт",
	render = VehicleUI.render,
}, {
	name = u8"VIP",
	render = VipUI.render,
} }

function UI.toggle()
	_window[0] = not _window[0]
end

local FORGE_BUTTON_HEIGHT = 30
local _windowFlags =
	imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse

local function _calcFooterHeight()
	local spacing = imgui.GetStyle().ItemSpacing.y
	local saveButton = imgui.GetFrameHeightWithSpacing()
	local textLines = 2 * imgui.GetTextLineHeightWithSpacing()
	local separators = 2 * spacing
	local spacings = 2 * spacing
	return saveButton + textLines + separators + spacings + FORGE_BUTTON_HEIGHT
end

function UI.initialize()
	imgui.OnFrame(
		function()
			return _window[0]
		end,
		function()
			imgui.SetNextWindowPos(
				imgui.ImVec2(_resX / 2, _resY / 2),
				imgui.Cond.FirstUseEver,
				imgui.ImVec2(0.5, 0.5)
			)
			imgui.SetNextWindowSize(
				imgui.ImVec2(700, 550),
				imgui.Cond.FirstUseEver
			)

			if imgui.Begin(
				u8"Fake Documents by DepsCian",
				_window,
				_windowFlags
			) then
				local footerH = _calcFooterHeight()

				if imgui.BeginTabBar("##fdoc_tabs") then
					for i, tab in ipairs(TABS) do
						if imgui.BeginTabItem(tab.name) then
							local childId = "##tab_scroll_" .. tostring(i)
							if imgui.BeginChild(
								childId,
								imgui.ImVec2(0, -footerH),
								false
							) then
								tab.render()
							end
							imgui.EndChild()
							imgui.EndTabItem()
						end
					end
					imgui.EndTabBar()
				end

				imgui.Separator()
				if imgui.Button(
					u8"Сохранить настройки",
					imgui.ImVec2(-1, 0)
				) then
					Save.executeWithNotify()
				end

				imgui.Spacing()
				imgui.Separator()

				local availWidth = imgui.GetContentRegionAvail().x
				imgui.PushStyleColor(imgui.Col.Text, FORGE_COLOR)
				local titleSize = imgui.CalcTextSize(FORGE_TITLE)
				imgui.SetCursorPosX(
					(availWidth - titleSize.x) / 2 + imgui.GetCursorPosX()
				)
				imgui.Text(FORGE_TITLE)
				imgui.PopStyleColor()

				imgui.PushStyleColor(
					imgui.Col.Text,
					imgui.ImVec4(0.7, 0.7, 0.7, 1.0)
				)
				local descSize = imgui.CalcTextSize(FORGE_DESC)
				imgui.SetCursorPosX(
					(availWidth - descSize.x) / 2 + imgui.GetCursorPosX()
				)
				imgui.Text(FORGE_DESC)
				imgui.PopStyleColor()

				imgui.Spacing()
				imgui.PushStyleColor(imgui.Col.Button, FORGE_COLOR)
				imgui.PushStyleColor(imgui.Col.ButtonHovered, FORGE_COLOR_HOVER)
				imgui.PushStyleColor(
					imgui.Col.ButtonActive,
					imgui.ImVec4(0.25, 0.55, 0.70, 1.0)
				)
				local buttonWidth = 250
				imgui.SetCursorPosX(
					(availWidth - buttonWidth) / 2 + imgui.GetCursorPosX()
				)
				if imgui.Button(
					FORGE_LINK_TEXT,
					imgui.ImVec2(buttonWidth, FORGE_BUTTON_HEIGHT)
				) then
					os.execute('start "" "' .. FORGE_URL .. '"')
				end
				imgui.PopStyleColor(3)
			end
			imgui.End()
		end
	)
end

return UI
