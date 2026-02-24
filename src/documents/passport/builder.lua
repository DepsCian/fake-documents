local ffi = require("ffi")
local JS = require("core/js")
local Passport = require("documents/passport/init")
local Encoding = require("core/encoding")

local Builder = {}

local BASE = "body > div.documents > div.documents__content.documents__content--pasport > div > div > "
local INFO = BASE .. "div.documents-pasport__main-info.svelte-11hrewx > "

local SELECTORS = {
    { key = "name",         sel = INFO .. "div:nth-child(1) > div.documents-pasport__value.svelte-11hrewx" },
    { key = "level",        sel = INFO .. "div:nth-child(2) > div.documents-pasport__value.svelte-11hrewx" },
    { key = "sex",          sel = INFO .. "div:nth-child(3) > div.documents-pasport__value.svelte-11hrewx" },
    { key = "zakono",       sel = INFO .. "div:nth-child(4) > div.documents-pasport__value.svelte-11hrewx" },
    { key = "birthday",     sel = INFO .. "div:nth-child(5) > div.documents-pasport__value.svelte-11hrewx" },
    { key = "job",          sel = INFO .. "div:nth-child(6) > div.documents-pasport__value.svelte-11hrewx" },
    { key = "citizen",      sel = INFO .. "div:nth-child(7) > div.documents-pasport__value.svelte-11hrewx" },
    { key = "povestka",     sel = INFO .. "div:nth-child(8) > div.documents-pasport__value.svelte-11hrewx" },
    { key = "married",      sel = INFO .. "div:nth-child(9) > div.documents-pasport__value.svelte-11hrewx" },
    { key = "organization", sel = INFO .. "div:nth-child(10) > div.documents-pasport__value.svelte-11hrewx" },
    { key = "rank",         sel = INFO .. "div:nth-child(10) > div.documents-pasport__rank.svelte-11hrewx" },
    { key = "seria",        sel = BASE .. "div.documents-pasport__serial.svelte-11hrewx > div.documents-pasport__serial-value.svelte-11hrewx" },
    { key = "number",       sel = BASE .. "div.documents-pasport__number.svelte-11hrewx > div.documents-pasport__number-value.svelte-11hrewx" },
    { key = "signature",    sel = BASE .. "div.documents-pasport__signature.svelte-11hrewx" },
}

local AVATAR_SEL = ".documents-pasport__photo"

function Builder.build()
    local s = Passport.state

    if s.showEmptyState[0] then
        return 'window.executeEvent("event.documents.inititalizeData",`{"type":1,"not":true}`);'
    end

    local function escape(str)
        return Encoding.u8:decode(str):gsub('"', '\\"'):gsub('\\', '\\\\'):gsub('\n', '\\n')
    end

    local json = '{"type":1,"not":false'
    if s.name.enabled[0] then json = json .. ',"name":"' .. escape(ffi.string(s.name.value)) .. '"' end
    if s.level.enabled[0] then json = json .. ',"level":"' .. escape(ffi.string(s.level.value)) .. '"' end
    if s.sex.enabled[0] then json = json .. ',"sex":"' .. escape(ffi.string(s.sex.value)) .. '"' end
    if s.zakono.enabled[0] then json = json .. ',"zakono":"' .. escape(ffi.string(s.zakono.value)) .. '"' end
    if s.birthday.enabled[0] then json = json .. ',"birthday":"' .. escape(ffi.string(s.birthday.value)) .. '"' end
    if s.job.enabled[0] then json = json .. ',"job":"' .. escape(ffi.string(s.job.value)) .. '"' end
    if s.citizen.enabled[0] then json = json .. ',"citizen":"' .. escape(ffi.string(s.citizen.value)) .. '"' end
    if s.povestka.enabled[0] then json = json .. ',"agenda":"' .. escape(ffi.string(s.povestka.value)) .. '"' end
    if s.married.enabled[0] then json = json .. ',"married":"' .. escape(ffi.string(s.married.value)) .. '"' end
    if s.organization.enabled[0] then json = json .. ',"charity":"' .. escape(ffi.string(s.organization.value)) .. '"' end
    if s.rank.enabled[0] then json = json .. ',"rank":"' .. escape(ffi.string(s.rank.value)) .. '"' end
    if s.seria.enabled[0] then json = json .. ',"seria":"' .. escape(ffi.string(s.seria.value)) .. '"' end
    if s.number.enabled[0] then json = json .. ',"number":"' .. escape(ffi.string(s.number.value)) .. '"' end
    if s.signature.enabled[0] then json = json .. ',"signature":"' .. escape(ffi.string(s.signature.value)) .. '"' end
    json = json .. '}'

    local code = 'window.executeEvent("event.documents.inititalizeData",`' .. json .. '`);'

    if s.avatarUrl.enabled[0] then
        local avatarUrl = ffi.string(s.avatarUrl.value)
        code = code .. 'setTimeout(()=>{const a=document.querySelector("' .. AVATAR_SEL .. '");if(a){a.src="' .. avatarUrl .. '";a.style.height="100%";}},100);'
    end

    return code
end

return Builder
