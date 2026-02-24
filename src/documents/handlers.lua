local acef = require("arizona-events")
local JS = require("core/js")
local State = require("documents/state")
local Passport = require("documents/passport/init")
local Licenses = require("documents/licenses/init")
local Medical = require("documents/medical/init")
local PassportBuilder = require("documents/passport/builder")
local LicensesBuilder = require("documents/licenses/builder")
local MedicalBuilder = require("documents/medical/builder")

local INIT_EVENT = "event.documents.inititalizeData"
local CLOSE_EVENT = "onActiveViewChanged|null"
local UPDATE_PAGE = "window.executeEvent('event.documents.updatePage', `[%d]`);"

local function _getPlayerNickname()
    local _, playerId = sampGetPlayerIdByCharHandle(PLAYER_PED)
    return sampGetPlayerNickname(playerId)
end

local function _shouldApply(docState)
    if not docState.enabled[0] then return false end
    if docState.onlyOwn[0] and State.isViewingOtherPlayer then return false end
    return true
end

local function _tryApply(docState, builder)
    if _shouldApply(docState) then
        JS.eval(builder.build())
    end
end

function acef.onArizonaDisplay(packet)
    if packet.text:find(INIT_EVENT, 1, true)
        and not packet.text:find(_getPlayerNickname(), 1, true) then
        State.isViewingOtherPlayer = true
    end

    if packet.text:find('"type":1', 1, true) or packet.text == UPDATE_PAGE:format(1) then
        _tryApply(Passport.state, PassportBuilder)
    end

    if packet.text:find('"type":2', 1, true) or packet.text == UPDATE_PAGE:format(2) then
        _tryApply(Licenses.state, LicensesBuilder)
    end

    if packet.text:find('"type":4', 1, true) or packet.text == UPDATE_PAGE:format(4) then
        _tryApply(Medical.state, MedicalBuilder)
    end
end

function acef.onArizonaSend(packet)
    if packet.text:find(CLOSE_EVENT, 1, true) then
        State.isViewingOtherPlayer = false
    end
end

return {}
