local ffi = require("ffi")
local Medical = require("documents/medical/init")
local JsonBuilder = require("core/json_builder")

local Builder = {}

local FIELD_MAP = {
    { stateKey = "name",        jsonKey = "name" },
    { stateKey = "ukrop",       jsonKey = "zavisimost" },
    { stateKey = "health",      jsonKey = "state" },
    { stateKey = "insurance",   jsonKey = "health_insurance" },
    { stateKey = "validity",    jsonKey = "med_card_time" },
}

function Builder.build()
    local s = Medical.state

    if s.showEmptyState[0] then
        return 'window.executeEvent("event.documents.inititalizeData",`{"type":4,"not":true}`);'
    end

    local json = '{"type":4,"not":false' .. JsonBuilder.buildFields(s, FIELD_MAP)
    
    if s.psychiatric.enabled[0] then
        local value = require("core/encoding").escape(ffi.string(s.psychiatric.value))
        json = json .. ',"demorgan":{"count":"' .. value .. '"}'
    end
    
    if s.examProgress[0] then
        json = json .. ',"med_osmotr_progress":10'
    end
    
    json = json .. '}'
    local code = 'window.executeEvent("event.documents.inititalizeData",`' .. json .. '`);'
    
    return code .. JsonBuilder.avatarSnippet(s, ".documents-medical__photo")
end

return Builder