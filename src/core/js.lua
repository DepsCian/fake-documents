local Encoding = require("core/encoding")
local acef = require("arizona-events")

local JS = {}

local function _escape(str)
    return str
        :gsub("\\", "\\\\")
        :gsub('"', '\\"')
        :gsub("'", "\\'")
        :gsub("\n", "\\n")
        :gsub("\r", "\\r")
end

function JS.eval(code)
    acef.eval(code)
end

function JS.setText(selector, utf8Value)
    local decoded = Encoding.u8:decode(utf8Value)
    return 'document.querySelector("' .. selector .. '").textContent="' .. _escape(decoded) .. '";'
end

function JS.setAttr(selector, attr, utf8Value)
    local decoded = Encoding.u8:decode(utf8Value)
    return 'document.querySelector("' .. selector .. '").' .. attr .. '="' .. _escape(decoded) .. '";'
end

function JS.setStyle(selector, style)
    return 'document.querySelector("' .. selector .. '").style="' .. style .. '";'
end

return JS
