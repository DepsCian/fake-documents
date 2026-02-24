local ffi = require("ffi")
local Medical = require("documents/medical/init")
local Encoding = require("core/encoding")

local Builder = {}

local PHOTO_SEL = ".documents-medical__photo"

function Builder.build()
    local s = Medical.state

    if s.showEmptyState[0] then
        return 'window.executeEvent("event.documents.inititalizeData",`{"type":4,"not":true}`);'
    end

    local json = '{"type":4,"not":false'
    if s.name.enabled[0] then json = json .. ',"name":"' .. Encoding.escape(ffi.string(s.name.value)) .. '"' end
    if s.ukrop.enabled[0] then json = json .. ',"zavisimost":"' .. Encoding.escape(ffi.string(s.ukrop.value)) .. '"' end
    if s.health.enabled[0] then json = json .. ',"state":"' .. Encoding.escape(ffi.string(s.health.value)) .. '"' end
    if s.insurance.enabled[0] then json = json .. ',"health_insurance":"' .. Encoding.escape(ffi.string(s.insurance.value)) .. '"' end
    if s.validity.enabled[0] then json = json .. ',"med_card_time":"' .. Encoding.escape(ffi.string(s.validity.value)) .. '"' end
    if s.psychiatric.enabled[0] then json = json .. ',"demorgan":{"count":"' .. Encoding.escape(ffi.string(s.psychiatric.value)) .. '"}' end
    if s.examProgress[0] then json = json .. ',"med_osmotr_progress":10' end
    json = json .. '}'

    local code = 'window.executeEvent("event.documents.inititalizeData",`' .. json .. '`);'

    if s.avatarUrl.enabled[0] then
        local avatarUrl = ffi.string(s.avatarUrl.value)
        code = code .. 'setTimeout(()=>{const a=document.querySelector("' .. PHOTO_SEL .. '");if(a){a.src="' .. avatarUrl .. '";a.style.height="100%";}},100);'
    end


    return code
end

return Builder
