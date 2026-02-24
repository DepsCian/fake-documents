local acef = require("arizona-events")

local JS = {}

function JS.eval(code)
    acef.eval(code)
end

return JS