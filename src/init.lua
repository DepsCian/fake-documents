script_name("Fake Documents")
script_author("DepsCian")
script_version("1.5")

local Config = require("core/config")
local Passport = require("documents/passport/init")
local Licenses = require("documents/licenses/init")
local Medical = require("documents/medical/init")
local Military = require("documents/military/init")
local Property = require("documents/property/init")
local Vehicle = require("documents/vehicle/init")
local Vip = require("documents/vip/init")
local UI = require("ui/init")
local Message = require("core/message")
local _handlersLoaded = pcall(require, "documents/handlers")

local DEFAULTS = {
    pass     = Passport.DEFAULTS,
    licenses = Licenses.DEFAULTS,
    medical  = Medical.DEFAULTS,
    military = Military.DEFAULTS,
    property = Property.DEFAULTS,
    vehicle  = Vehicle.DEFAULTS,
    vip      = Vip.DEFAULTS,
}

local cfg = Config.load(DEFAULTS)

Passport.createState(cfg.pass)
Licenses.createState(cfg.licenses)
Medical.createState(cfg.medical)
Property.createState(cfg.property)
Military.createState(cfg.military)
Vehicle.createState(cfg.vehicle)
Vip.createState(cfg.vip)

local _MISSING_LIB_DIALOG_ID = 15782
local _MISSING_LIB_URL = "https://www.blast.hk/threads/235586/"
local _MISSING_LIB_TEXT = "{FF4444}Библиотека arizona-events не найдена!\n\n"
    .. "{FFFFFF}Для работы скрипта необходима библиотека {00AAFF}arizona-events{FFFFFF}.\n"
    .. "Нажмите {00FF00}\"Скачать\"{FFFFFF}, чтобы перейти на страницу загрузки."

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    if _handlersLoaded then
        sampShowDialog(
            _MISSING_LIB_DIALOG_ID,
            "Fake Documents - Ошибка",
            _MISSING_LIB_TEXT,
            "Скачать",
            "Закрыть",
            0
        )
        while true do
            wait(0)
            local responded, button = sampHasDialogRespond(_MISSING_LIB_DIALOG_ID)
            if responded then
                if button == 1 then
                    os.execute('start "" "' .. _MISSING_LIB_URL .. '"')
                end
                thisScript():unload()
                return
            end
        end
    end

    UI.initialize()

    sampRegisterChatCommand("fdoc", UI.toggle)
    Message.info("Активация: /fdoc")

    while true do wait(0) end
end
