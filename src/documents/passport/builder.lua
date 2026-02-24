local ffi = require("ffi")
local Passport = require("documents/passport/init")
local Encoding = require("core/encoding")

local Builder = {}

function Builder.build()
    local s = Passport.state

    if s.showEmptyState[0] then
        return 'window.executeEvent("event.documents.inititalizeData",`{"type":1,"not":true}`);'
    end

    local json = '{"type":1,"not":false'
    if s.name.enabled[0] then json = json .. ',"name":"' .. Encoding.escape(ffi.string(s.name.value)) .. '"' end
    if s.level.enabled[0] then json = json .. ',"level":"' .. Encoding.escape(ffi.string(s.level.value)) .. '"' end
    if s.sex.enabled[0] then json = json .. ',"sex":"' .. Encoding.escape(ffi.string(s.sex.value)) .. '"' end
    if s.zakono.enabled[0] then json = json .. ',"zakono":"' .. Encoding.escape(ffi.string(s.zakono.value)) .. '"' end
    if s.birthday.enabled[0] then json = json .. ',"birthday":"' .. Encoding.escape(ffi.string(s.birthday.value)) .. '"' end
    if s.job.enabled[0] then json = json .. ',"job":"' .. Encoding.escape(ffi.string(s.job.value)) .. '"' end
    if s.citizen.enabled[0] then json = json .. ',"citizen":"' .. Encoding.escape(ffi.string(s.citizen.value)) .. '"' end
    if s.povestka.enabled[0] then json = json .. ',"agenda":"' .. Encoding.escape(ffi.string(s.povestka.value)) .. '"' end
    if s.married.enabled[0] then json = json .. ',"married":"' .. Encoding.escape(ffi.string(s.married.value)) .. '"' end
    if s.organization.enabled[0] then json = json .. ',"charity":"' .. Encoding.escape(ffi.string(s.organization.value)) .. '"' end
    if s.rank.enabled[0] then json = json .. ',"rank":"' .. Encoding.escape(ffi.string(s.rank.value)) .. '"' end
    if s.seria.enabled[0] then json = json .. ',"seria":"' .. Encoding.escape(ffi.string(s.seria.value)) .. '"' end
    if s.number.enabled[0] then json = json .. ',"number":"' .. Encoding.escape(ffi.string(s.number.value)) .. '"' end
    if s.signature.enabled[0] then json = json .. ',"signature":"' .. Encoding.escape(ffi.string(s.signature.value)) .. '"' end
    json = json .. '}'

    local code = 'window.executeEvent("event.documents.inititalizeData",`' .. json .. '`);'

    if s.avatarUrl.enabled[0] then
        local avatarUrl = ffi.string(s.avatarUrl.value)
        code = code .. 'setTimeout(()=>{const a=document.querySelector(".documents-pasport__photo");if(a){a.src="' .. avatarUrl .. '";a.style.height="100%";}},100);'
    end

    return code
end

return Builder
