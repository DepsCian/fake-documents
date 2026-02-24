local Encoding = require("core/encoding")
local u8 = Encoding.u8

return {
    { name = "ADD VIP",     display = u8"ADD VIP",     type = "add" },
    { name = "Premium VIP", display = u8"Premium VIP", type = "premium" },
    { name = "Titan VIP",   display = u8"Titan VIP",   type = "titan" },
    { name = "Diamond VIP", display = u8"Diamond VIP", type = "diamond" },
}