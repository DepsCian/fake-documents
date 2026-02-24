script_name("Fake Documents")
script_author("DepsCian")
script_version("1.2")

local Config = require("core/config")
local Passport = require("documents/passport/init")
local Licenses = require("documents/licenses/init")
local Medical = require("documents/medical/init")
local UI = require("ui/init")
local Message = require("core/message")
require("documents/handlers")

local DEFAULTS = {
    pass     = Passport.DEFAULTS,
    licenses = Licenses.DEFAULTS,
    medical  = Medical.DEFAULTS,
}

local cfg = Config.load(DEFAULTS)

Passport.createState(cfg.pass)
Licenses.createState(cfg.licenses)
Medical.createState(cfg.medical)

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(1000) end

    UI.initialize()

    sampRegisterChatCommand("fdoc", UI.toggle)
    Message.info("Активация: /fdoc")

    while true do wait(0) end
end
