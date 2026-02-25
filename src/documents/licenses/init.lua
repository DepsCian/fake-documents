local imgui = require("mimgui")
local ffi = require("ffi")
local Encoding = require("core/encoding")
local u8 = Encoding.u8

local LICENSE_DEFS = { {
	id = "car",
	name = u8"Лицензия на авто",
	icon = "icon-car",
}, {
	id = "bike",
	name = u8"Лицензия на мото",
	icon = "icon-bike",
}, {
	id = "airship",
	name = u8"Лицензия на полеты",
	icon = "icon-airship",
}, {
	id = "boat",
	name = u8"Лицензия на плавание",
	icon = "icon-boat",
}, {
	id = "fishing",
	name = u8"Лицензия на ловлю рыбы",
	icon = "icon-fishing",
}, {
	id = "glock",
	name = u8"Лицензия на оружие",
	icon = "icon-glock",
}, {
	id = "deer",
	name = u8"Лицензия на охоту",
	icon = "icon-deer",
}, {
	id = "shovel",
	name = u8"Лицензия на раскопки",
	icon = "icon-shovel",
}, {
	id = "taxi",
	name = u8"Лицензия таксиста",
	icon = "icon-taxi",
}, {
	id = "repair",
	name = u8"Лицензия механика",
	icon = "icon-repair",
}, {
	id = "court",
	name = u8"Лицензия адвоката",
	icon = "icon-court",
}, {
	id = "tax",
	name = u8"Лицензия налоговика",
	icon = "icon-tax",
}, {
	id = "diplomacy",
	name = u8"Лицензия дипломата",
	icon = "icon-diplomacy",
}, {
	id = "pickaxe",
	name = u8"Разрешение на добычу ресурсов",
	icon = "icon-pickaxe",
} }

local DEFAULT_DATE = u8"12:12 11.05.2029"

local DEFAULTS = {
	enabled = false,
	onlyOwn = true,
}
for _, def in ipairs(LICENSE_DEFS) do
	DEFAULTS[def.id] = {
		enabled = true,
		date = DEFAULT_DATE,
	}
end

local Licenses = {}
Licenses.DEFS = LICENSE_DEFS
Licenses.DEFAULTS = DEFAULTS
Licenses.state = nil

function Licenses.createState(cfg)
	local state = {
		enabled = imgui.new.bool(cfg.enabled),
		onlyOwn = imgui.new.bool(cfg.onlyOwn ~= false),
		items = {},
	}
	for _, def in ipairs(LICENSE_DEFS) do
		table.insert(state.items, {
			id = def.id,
			name = def.name,
			icon = def.icon,
			enabled = imgui.new.bool(cfg[def.id].enabled),
			date = imgui.new.char[64](cfg[def.id].date),
		})
	end
	Licenses.state = state
	return state
end

function Licenses.syncToConfig(cfg)
	local s = Licenses.state
	cfg.enabled = s.enabled[0]
	cfg.onlyOwn = s.onlyOwn[0]
	for _, item in ipairs(s.items) do
		cfg[item.id].enabled = item.enabled[0]
		cfg[item.id].date = ffi.string(item.date)
	end
end

return Licenses
