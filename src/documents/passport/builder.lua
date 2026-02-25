local ffi = require("ffi")
local Passport = require("documents/passport/init")
local JsonBuilder = require("core/json_builder")

local Builder = {}

local FIELD_MAP = { {
	stateKey = "name",
	jsonKey = "name",
}, {
	stateKey = "level",
	jsonKey = "level",
}, {
	stateKey = "sex",
	jsonKey = "sex",
}, {
	stateKey = "zakono",
	jsonKey = "zakono",
}, {
	stateKey = "birthday",
	jsonKey = "birthday",
}, {
	stateKey = "job",
	jsonKey = "job",
}, {
	stateKey = "citizen",
	jsonKey = "citizen",
}, {
	stateKey = "povestka",
	jsonKey = "agenda",
}, {
	stateKey = "married",
	jsonKey = "married",
}, {
	stateKey = "organization",
	jsonKey = "charity",
}, {
	stateKey = "rank",
	jsonKey = "rank",
}, {
	stateKey = "seria",
	jsonKey = "seria",
}, {
	stateKey = "number",
	jsonKey = "number",
}, {
	stateKey = "signature",
	jsonKey = "signature",
} }

function Builder.build()
	local s = Passport.state

	if s.showEmptyState[0] then
		return 'window.executeEvent("event.documents.inititalizeData",`{"type":1,"not":true}`);'
	end

	local json =
		'{"type":1,"not":false' .. JsonBuilder.buildFields(s, FIELD_MAP) .. "}"
	local code =
		'window.executeEvent("event.documents.inititalizeData",`' .. json .. "`);"

	return code .. JsonBuilder.avatarSnippet(s, ".documents-pasport__photo")
end

return Builder
