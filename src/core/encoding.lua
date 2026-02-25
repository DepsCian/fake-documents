local encoding = require("encoding")
encoding.default = "CP1251"

local Encoding = { u8 = encoding.UTF8 }

function Encoding.escape(str)
	return Encoding.u8:decode(str):gsub("\\", "\\\\"):gsub('"', '\\"'):gsub(
		"\n",
		"\\n"
	)
end

return Encoding
