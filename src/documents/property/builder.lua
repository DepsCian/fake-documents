local ffi = require("ffi")
local Encoding = require("core/encoding")
local Property = require("documents/property/init")

local Builder = {}

local RES_SEL = ".documents-property__main-info > .documents-property__list:first-child .documents-property__property"
local COM_SEL = ".documents-property__main-info > .documents-property__list:last-child .documents-property__property"

local function _buildCategoryCode(varName, selector, categoryState)
    local code = 'var ' .. varName .. '=document.querySelectorAll("' .. selector .. '");'
    for i = 1, 5 do
        local slot = categoryState[i]
        if slot.enabled[0] and slot.name.enabled[0] then
            local decoded = Encoding.u8:decode(ffi.string(slot.name.value))
            local escaped = decoded:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("'", "\\'")
            code = code .. 'if(' .. varName .. '[' .. (i - 1) .. '])'
                .. varName .. '[' .. (i - 1) .. '].querySelector(".documents-property__property-name")'
                .. '.textContent="' .. escaped .. '";'
        end
    end
    return code
end

function Builder.build()
    local s = Property.state
    local code = ""
    code = code .. _buildCategoryCode("r", RES_SEL, s.residential)
    code = code .. _buildCategoryCode("c", COM_SEL, s.commercial)
    return code
end

return Builder
