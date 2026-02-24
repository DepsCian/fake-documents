local Config = require("core/config")
local Passport = require("documents/passport/init")
local Licenses = require("documents/licenses/init")
local Medical = require("documents/medical/init")
local Message = require("core/message")

local Save = {}

function Save.execute()
    local cfg = Config.data()
    Passport.syncToConfig(cfg.pass)
    Licenses.syncToConfig(cfg.licenses)
    Medical.syncToConfig(cfg.medical)
    Config.write()
end

function Save.executeWithNotify()
    Save.execute()
    Message.success("Настройки успешно сохранены")
end

return Save
