local Config = require("core/config")
local Passport = require("documents/passport/init")
local Licenses = require("documents/licenses/init")
local Medical = require("documents/medical/init")
local Military = require("documents/military/init")
local Property = require("documents/property/init")
local Vehicle = require("documents/vehicle/init")
local Vip = require("documents/vip/init")
local Message = require("core/message")

local REGISTRY = { {
	module = Passport,
	cfgKey = "pass",
}, {
	module = Licenses,
	cfgKey = "licenses",
}, {
	module = Medical,
	cfgKey = "medical",
}, {
	module = Military,
	cfgKey = "military",
}, {
	module = Property,
	cfgKey = "property",
}, {
	module = Vehicle,
	cfgKey = "vehicle",
}, {
	module = Vip,
	cfgKey = "vip",
} }

local Save = {}

function Save.execute()
	local cfg = Config.data()
	for _, entry in ipairs(REGISTRY) do
		entry.module.syncToConfig(cfg[entry.cfgKey])
	end
	Config.write()
end

function Save.executeWithNotify()
	Save.execute()
	Message.success("Настройки успешно сохранены")
end

return Save
