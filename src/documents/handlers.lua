local acef = require("arizona-events")
local JS = require("core/js")
local State = require("documents/state")
local Passport = require("documents/passport/init")
local Licenses = require("documents/licenses/init")
local Medical = require("documents/medical/init")
local Military = require("documents/military/init")
local Property = require("documents/property/init")
local Vehicle = require("documents/vehicle/init")
local Vip = require("documents/vip/init")
local PassportBuilder = require("documents/passport/builder")
local LicensesBuilder = require("documents/licenses/builder")
local MedicalBuilder = require("documents/medical/builder")
local MilitaryBuilder = require("documents/military/builder")
local PropertyBuilder = require("documents/property/builder")
local VehicleBuilder = require("documents/vehicle/builder")
local VipBuilder = require("documents/vip/builder")

local INIT_EVENT = "event.documents.inititalizeData"
local CLOSE_EVENT = "onActiveViewChanged|null"
local UPDATE_PAGE = "window.executeEvent('event.documents.updatePage', `[%d]`);"

local DOCUMENT_TYPES = {
    { type = 1,  page = 1,  state = Passport.state,  builder = PassportBuilder },
    { type = 2,  page = 2,  state = Licenses.state,  builder = LicensesBuilder },
    { type = 4,  page = 4,  state = Medical.state,   builder = MedicalBuilder },
    { type = 8,  page = 8,  state = Military.state,  builder = MilitaryBuilder },
    { type = 16, page = 16, state = Property.state,  builder = PropertyBuilder },
    { type = 32, page = 32, state = Vehicle.state,   builder = VehicleBuilder },
    { type = 64, page = 64, state = Vip.state,       builder = VipBuilder },
}

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
    if packet.text:find(INIT_EVENT, 1, true) and not packet.text:find(_getPlayerNickname(), 1, true) then
        State.isViewingOtherPlayer = true
    end

    for _, doc in ipairs(DOCUMENT_TYPES) do
        if packet.text:find('"type":' .. doc.type, 1, true) or packet.text == UPDATE_PAGE:format(doc.page) then
            _tryApply(doc.state, doc.builder)
            break
        end
    end
end

function acef.onArizonaSend(packet)
    if packet.text:find(CLOSE_EVENT, 1, true) then
        State.isViewingOtherPlayer = false
    end
end

return {}