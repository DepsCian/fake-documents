local ffi = require("ffi")
local Military = require("documents/military/init")
local JsonBuilder = require("core/json_builder")

local Builder = {}

local FIELD_MAP = { {
	stateKey = "name",
	jsonKey = "name",
}, {
	stateKey = "army_online",
	jsonKey = "army_online",
}, {
	stateKey = "have_army_ticket",
	jsonKey = "have_army_ticket",
}, {
	stateKey = "rank",
	jsonKey = "rank",
} }

function Builder.build()
	local s = Military.state

	if s.showEmptyState[0] then
		return 'window.executeEvent("event.documents.inititalizeData",`{"type":8,"not":true}`);'
	end

	local json =
		'{"type":8,"not":false' .. JsonBuilder.buildFields(s, FIELD_MAP) .. "}"
	local code =
		'window.executeEvent("event.documents.inititalizeData",`' .. json .. "`);"

	return code .. JsonBuilder.avatarSnippet(s, ".documents-military__photo")
end

return Builder
