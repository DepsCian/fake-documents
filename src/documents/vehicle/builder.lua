local ffi = require("ffi")
local Encoding = require("core/encoding")
local Vehicle = require("documents/vehicle/init")

local Builder = {}

local VEHICLE_SEL = ".documents-vehicle__vehicle"

local FIELD_SELECTORS = {
    { key = "name",        sel = ".documents-vehicle__vehicle-name" },
    { key = "number",      sel = ".documents-vehicle__vehicle-number" },
    { key = "cost",        sel = ".documents-vehicle__vehicle-price-value" },
    { key = "milliage",    sel = ".documents-vehicle__vehicle-mileage-value" },
    { key = "status_text", sel = ".documents-vehicle__vehicle-status-value" },
}

local function _escape(str)
    return str
        :gsub("\\", "\\\\")
        :gsub('"', '\\"')
        :gsub("'", "\\'")
        :gsub("\n", "\\n")
        :gsub("\r", "\\r")
end

function Builder.build()
    local s = Vehicle.state
    local code = 'const vehicles=document.querySelectorAll("' .. VEHICLE_SEL .. '");'

    for i = 1, Vehicle.MAX_VEHICLES do
        local vState = s.vehicles[i]
        if vState.enabled[0] then
            local jsIdx = i - 1
            local guard = "if(vehicles[" .. jsIdx .. "]){"
            local body = ""

            for _, item in ipairs(FIELD_SELECTORS) do
                local field = vState[item.key]
                if field.enabled[0] then
                    local decoded = Encoding.u8:decode(ffi.string(field.value))
                    local vRef = "vehicles[" .. jsIdx .. "]"
                    body = body
                        .. 'var e=' .. vRef .. '.querySelector("' .. item.sel .. '");'
                        .. 'if(e)e.textContent="' .. _escape(decoded) .. '";'
                end
            end

            if #body > 0 then
                code = code .. guard .. body .. "}"
            end
        end
    end

    return code
end

return Builder
