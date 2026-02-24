local ffi = require("ffi")
local Encoding = require("core/encoding")
local Licenses = require("documents/licenses/init")

local Builder = {}

local ID_MAP = {
    airship = "fly",
    fishing = "fish",
    glock = "gun",
    deer = "hunter",
    shovel = "hitch",
    repair = "mechanic",
    court = "lawyer",
    tax = "taxman",
    pickaxe = "resource"
}

function Builder.build()
    local s = Licenses.state
    
    local function escape(str)
        return Encoding.u8:decode(str):gsub('"', '\\"'):gsub('\\', '\\\\'):gsub('\n', '\\n')
    end
    
    local info = {}
    local diplomacy_item = nil
    
    for _, item in ipairs(s.items) do
        if item.id == "diplomacy" then
            diplomacy_item = item
        else
            local license_id = ID_MAP[item.id] or item.id
            local available = item.enabled[0] and "true" or "false"
            local date_text = item.enabled[0] and ',"date_text":"' .. escape(ffi.string(item.date)) .. '"' or ""
            table.insert(info, '{"license":"' .. license_id .. '","available":' .. available .. date_text .. '}')
        end
    end
    
    local json = '{"type":2,"not":false,"info":[' .. table.concat(info, ',') .. ']}'
    local code = 'window.executeEvent("event.documents.inititalizeData",`' .. json .. '`);'
    
    if diplomacy_item then
        local diplomacy_value = diplomacy_item.enabled[0] and '{"available":true,"date_text":"' .. escape(ffi.string(diplomacy_item.date)) .. '"}' or "0"
        code = code .. 'window.executeEvent("event.documents.inititalizeDiplomacyLicense",' .. diplomacy_value .. ');'
    end
    
    return code
end

return Builder
