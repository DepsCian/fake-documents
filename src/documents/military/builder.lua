local ffi = require("ffi")
local Military = require("documents/military/init")
local Encoding = require("core/encoding")

local Builder = {}

local PHOTO_SEL = ".documents-military__photo"

function Builder.build()
    local s = Military.state

    if s.showEmptyState[0] then
        return 'window.executeEvent("event.documents.inititalizeData",`{"type":8,"not":true}`);'
    end

    local function escape(str)
        return Encoding.u8:decode(str):gsub('"', '\\"'):gsub('\\', '\\\\'):gsub('\n', '\\n')
    end

    local json = '{"type":8,"not":false'
    if s.name.enabled[0] then json = json .. ',"name":"' .. escape(ffi.string(s.name.value)) .. '"' end
    if s.army_online.enabled[0] then json = json .. ',"army_online":"' .. escape(ffi.string(s.army_online.value)) .. '"' end
    if s.have_army_ticket.enabled[0] then json = json .. ',"have_army_ticket":"' .. escape(ffi.string(s.have_army_ticket.value)) .. '"' end
    if s.rank.enabled[0] then json = json .. ',"rank":"' .. escape(ffi.string(s.rank.value)) .. '"' end
    json = json .. '}'

    local code = 'window.executeEvent("event.documents.inititalizeData",`' .. json .. '`);'

    if s.avatarUrl.enabled[0] then
        local avatarUrl = ffi.string(s.avatarUrl.value)
        code = code .. 'const a=document.querySelector("' .. PHOTO_SEL .. '");if(a){a.src="' .. avatarUrl .. '";a.style.height="100%";}'
    end

    return code
end

return Builder
