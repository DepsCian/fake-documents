local ffi = require("ffi")
local Encoding = require("core/encoding")

local Builder = {}

function Builder.buildFields(state, fieldMap)
    local parts = {}
    for _, mapping in ipairs(fieldMap) do
        local field = state[mapping.stateKey]
        if field and field.enabled[0] then
            local value = Encoding.escape(ffi.string(field.value))
            table.insert(parts, ',"' .. mapping.jsonKey .. '":"' .. value .. '"')
        end
    end
    return table.concat(parts)
end

function Builder.avatarSnippet(state, selector)
    if not state.avatarUrl or not state.avatarUrl.enabled[0] then
        return ""
    end
    local url = ffi.string(state.avatarUrl.value)
    return 'setTimeout(()=>{const a=document.querySelector("' .. selector .. '");if(a){a.src="' .. url .. '";a.style.height="100%";}},100);'
end

return Builder