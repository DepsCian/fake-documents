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

local TABS = {
    { name = u8"Паспорт",    render = PassportUI.render },
    { name = u8"Лицензии",   render = LicensesUI.render },
    { name = u8"Мед. карта", render = MedicalUI.render },
    { name = u8"Военный",    render = MilitaryUI.render },
    { name = u8"Недвижимость", render = PropertyUI.render },
    { name = u8"Транспорт",   render = VehicleUI.render },
    { name = u8"VIP",          render = VipUI.render },
}

function UI.toggle()
    _window[0] = not _window[0]
end

function UI.initialize()
    imgui.OnFrame(
        function() return _window[0] end,
        function()
            imgui.SetNextWindowPos(
                imgui.ImVec2(_resX / 2, _resY / 2),
                imgui.Cond.FirstUseEver,
                imgui.ImVec2(0.5, 0.5)
            )
            imgui.SetNextWindowSize(imgui.ImVec2(700, 550), imgui.Cond.FirstUseEver)

            if imgui.Begin(u8"Fake Documents by DepsCian", _window) then
                local windowHeight = imgui.GetWindowHeight()
                
                if imgui.BeginChild("##content", imgui.ImVec2(0, windowHeight - 70), false) then
                    if imgui.BeginTabBar("##fdoc_tabs") then
                        for _, tab in ipairs(TABS) do
                            if imgui.BeginTabItem(tab.name) then
                                tab.render()
                                imgui.EndTabItem()
                            end
                        end
                        imgui.EndTabBar()
                    end
                end
                imgui.EndChild()

                imgui.Separator()
                if imgui.Button(u8"Сохранить настройки", imgui.ImVec2(-1, 0)) then
                    Save.executeWithNotify()
                end
            end
            imgui.End()
        end
    )
end

return UI
