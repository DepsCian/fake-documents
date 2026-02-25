local ffi = require("ffi")
local Vip = require("documents/vip/init")
local Encoding = require("core/encoding")
local VIP_TYPES = require("documents/vip/constants")

local Builder = {}

local vip_type_map = {}
for _, vip in ipairs(VIP_TYPES) do
	vip_type_map[vip.name] = vip.type
end

function Builder.build()
	local s = Vip.state

	local json = '{"type":64,"not":false,"header_block":{'
	if s.statusName.enabled[0] then
		local name = Encoding.escape(ffi.string(s.statusName.value))
		local vip_type = vip_type_map[name] or "diamond"
		json = json .. '"type_vip":"' .. vip_type .. '"'
	end
	if s.statusTime.enabled[0] then
		json =
			json .. ',"vip_date":"' .. Encoding.escape(
				ffi.string(s.statusTime.value)
			) .. '"'
	end
	if s.addVipDays.enabled[0] then
		json =
			json .. ',"add_vip_date":"' .. Encoding.escape(
				ffi.string(s.addVipDays.value)
			) .. '"'
	end
	json = json .. "}"

	local levels = {}
	for i = 1, 10 do
		local lvl = s.premiumLevels[i]
		if lvl.enabled[0] then
			local mark = lvl.mark[0] and "true" or "false"
			local text = Encoding.escape(ffi.string(lvl.text.value))
			local desc = Encoding.escape(ffi.string(lvl.desc.value))
			table.insert(
				levels,
				'{"mark":' .. mark .. ',"text":"' .. text .. '","desc":"' .. desc .. '"}'
			)
		end
	end
	json = json .. ',"premium_levels":[' .. table.concat(levels, ",") .. "]"

	local statuses = {}
	for i = 1, 4 do
		local st = s.vipStatuses[i]
		local type_name = Encoding.escape(ffi.string(st.type.value))
		local type_vip = vip_type_map[type_name] or "diamond"
		local date_vip = Encoding.escape(ffi.string(st.date.value))
		local available = st.enabled[0] and "true" or "false"
		table.insert(
			statuses,
			'{"type_vip":"' .. type_vip .. '","date_vip":"' .. date_vip .. '","available":' .. available .. "}"
		)
	end
	json = json .. ',"vip_statuses":[' .. table.concat(statuses, ",") .. "]}"

	return 'window.executeEvent("event.documents.inititalizeData",`' .. json .. "`);"
end

return Builder
