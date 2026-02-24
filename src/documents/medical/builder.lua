local ffi = require("ffi")
local JS = require("core/js")
local Medical = require("documents/medical/init")

local Builder = {}

local PHOTO_SEL = ".documents-medical__photo"

local TEXT_SELECTORS = {
    { key = "name",        sel = ".documents-medical__main-info > div:nth-child(1) > div.documents-medical__value" },
    { key = "ukrop",       sel = ".documents-medical__main-info > div:nth-child(2) > div.documents-medical__value" },
    { key = "health",      sel = ".documents-medical__main-info > div:nth-child(3) > div.documents-medical__value" },
    { key = "insurance",   sel = ".documents-medical__main-info > div:nth-child(4) > div.documents-medical__value" },
    { key = "validity",    sel = ".documents-medical__main-info > div:nth-child(5) > div.documents-medical__value" },
    { key = "psychiatric", sel = ".documents-medical__main-info > div:nth-child(6) > div.documents-medical__value-wrapper > div.documents-medical__value" },
}

function Builder.build()
    local s = Medical.state
    local code = ""

    if s.avatarUrl.enabled[0] then
        local val = ffi.string(s.avatarUrl.value)
        code = code .. JS.setAttr(PHOTO_SEL, "src", val)
        code = code .. JS.setStyle(PHOTO_SEL, "height:100%!important")
    end

    for _, item in ipairs(TEXT_SELECTORS) do
        local field = s[item.key]
        if field and field.enabled[0] then
            code = code .. JS.setText(item.sel, ffi.string(field.value))
        end
    end

    if s.psychiatric.enabled[0] then
        code = code .. 'const r=document.querySelector(".documents-medical__refresh-card");if(r)r.style.display="none";'
    end

    if s.examProgress[0] then
        code = code
            .. 'document.querySelector(".documents-medical__inspection-progress").textContent="10 / 10";'
            .. 'const p=document.querySelectorAll(".documents-medical__progress-counter-item");'
            .. 'p.forEach(i=>{i.style.backgroundColor="#4CAF50"});'
            .. 'document.querySelector(".documents-medical__tip-text").textContent='
            .. '"\\u041c\\u0435\\u0434\\u0438\\u0446\\u0438\\u043d\\u0441\\u043a\\u0438\\u0439 \\u043e\\u0441\\u043c\\u043e\\u0442\\u0440 '
            .. '\\u043f\\u043e\\u043b\\u043d\\u043e\\u0441\\u0442\\u044c\\u044e \\u043f\\u0440\\u043e\\u0439\\u0434\\u0435\\u043d";'
    end

    return code
end

return Builder
