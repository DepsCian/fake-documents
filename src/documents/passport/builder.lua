local ffi = require("ffi")
local JS = require("core/js")
local Passport = require("documents/passport/init")

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

local AVATAR_SEL = BASE .. "div.documents-pasport__photo-wrapper.svelte-11hrewx > img.documents-pasport__photo.svelte-11hrewx"

function Builder.build()
    local s = Passport.state
    local code = ""

    if s.avatarUrl.enabled[0] then
        local val = ffi.string(s.avatarUrl.value)
        code = code .. JS.setAttr(AVATAR_SEL, "src", val)
        code = code .. JS.setStyle(AVATAR_SEL, "height:100%!important")
    end

    for _, item in ipairs(SELECTORS) do
        local field = s[item.key]
        if field and field.enabled[0] then
            code = code .. JS.setText(item.sel, ffi.string(field.value))
        end
    end

    return code
end

return Builder
