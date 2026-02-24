local ffi = require("ffi")
local JS = require("core/js")
local Military = require("documents/military/init")

local Builder = {}

local BASE = "body > div.documents > div.documents__content.documents__content--military > div > div > "
local INFO = BASE .. "div.documents-military__main-info.svelte-jle29v > "

local SELECTORS = {
    { key = "name",             sel = INFO .. "div:nth-child(1) > div.documents-military__value.svelte-jle29v" },
    { key = "army_online",      sel = INFO .. "div:nth-child(2) > div.documents-military__value.svelte-jle29v" },
    { key = "have_army_ticket", sel = INFO .. "div:nth-child(3) > div.documents-military__value.svelte-jle29v" },
    { key = "rank",             sel = INFO .. "div:nth-child(4) > div.documents-military__value.svelte-jle29v" },
}

local AVATAR_SEL = BASE .. "div.documents-military__photo-wrapper.svelte-jle29v > img.documents-military__photo.svelte-jle29v"

function Builder.build()
    local s = Military.state
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
