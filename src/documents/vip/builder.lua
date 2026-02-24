local ffi = require("ffi")
local JS = require("core/js")
local Vip = require("documents/vip/init")

local Builder = {}

local TEXT_SELECTORS = {
    { key = "statusName", sel = ".documents-vip__status-name" },
    { key = "statusTime", sel = ".documents-vip__status-time" },
    { key = "addVipDays", sel = ".documents-vip__add-vip-days" },
}

function Builder.build()
    local s = Vip.state
    local code = 'const a=document.querySelector(".documents-vip__absent");if(a)a.style.display="none";'

    for _, item in ipairs(TEXT_SELECTORS) do
        local field = s[item.key]
        if field and field.enabled[0] then
            code = code .. JS.setText(item.sel, ffi.string(field.value))
        end
    end

    return code
end

return Builder
