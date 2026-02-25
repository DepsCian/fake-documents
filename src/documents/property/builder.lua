local ffi = require("ffi")
local Encoding = require("core/encoding")
local Property = require("documents/property/init")

local Builder = {}

function Builder.build()
	local s = Property.state

	local properties = {}

	for i = 1, 5 do
		local slot = s.residential[i]
		if slot.enabled[0] and slot.name.enabled[0] then
			table.insert(
				properties,
				'{"text":"' .. Encoding.escape(
					ffi.string(slot.name.value)
				) .. '","column":"residential","property_type":"house"}'
			)
		end
	end

	for i = 1, 5 do
		local slot = s.commercial[i]
		if slot.enabled[0] and slot.name.enabled[0] then
			table.insert(
				properties,
				'{"text":"' .. Encoding.escape(
					ffi.string(slot.name.value)
				) .. '","column":"commerce","property_type":"house"}'
			)
		end
	end

	local json =
		'{"type":16,"not":false,"properties":[' .. table.concat(
			properties,
			","
		) .. "]}"

	return 'window.executeEvent("event.documents.inititalizeData",`' .. json .. "`);"
end

return Builder
