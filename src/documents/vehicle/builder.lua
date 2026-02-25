local ffi = require("ffi")
local Encoding = require("core/encoding")
local Vehicle = require("documents/vehicle/init")

local Builder = {}

function Builder.build()
	local s = Vehicle.state

	local vehicles = {}
	for i = 1, Vehicle.MAX_VEHICLES do
		local v = s.vehicles[i]
		if v.enabled[0] then
			local veh =
				'{"name":"' .. Encoding.escape(ffi.string(v.name.value)) .. '"'
			if v.number.enabled[0] then
				veh =
					veh .. ',"number":"' .. Encoding.escape(
						ffi.string(v.number.value)
					) .. '"'
			end
			if v.cost.enabled[0] then
				veh =
					veh .. ',"cost":"' .. Encoding.escape(
						ffi.string(v.cost.value)
					) .. '"'
			end
			if v.milliage.enabled[0] then
				veh =
					veh .. ',"milliage":"' .. Encoding.escape(
						ffi.string(v.milliage.value)
					) .. '"'
			end
			if v.status_text.enabled[0] then
				veh =
					veh .. ',"status_text":"' .. Encoding.escape(
						ffi.string(v.status_text.value)
					) .. '"'
			end
			if v.image_url.enabled[0] then
				veh =
					veh .. ',"image_url":"' .. Encoding.escape(
						ffi.string(v.image_url.value)
					) .. '"'
			end
			veh = veh .. "}"
			table.insert(vehicles, veh)
		end
	end

	local json =
		'{"type":32,"not":false,"vehicles":[' .. table.concat(
			vehicles,
			","
		) .. "]}"

	return 'window.executeEvent("event.documents.inititalizeData",`' .. json .. "`);"
end

return Builder
