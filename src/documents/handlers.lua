local acef = require("arizona-events")
local JS = require("core/js")
local State = require("documents/state")
local Message = require("core/message")
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

local function _getPlayerNickname()
    local _, playerId = sampGetPlayerIdByCharHandle(PLAYER_PED)
    return sampGetPlayerNickname(playerId)
end

local function _shouldApply(docState)
    if not docState.enabled[0] then return false end
    if docState.onlyOwn[0] and State.isViewingOtherPlayer then return false end
    return true
end

local function _tryApply(docState, builder, docName)
    if _shouldApply(docState) then
        local code = builder.build()
        sampAddChatMessage("[FD] Applying " .. docName .. " (" .. #code .. " chars)", 0x00FF00)
        JS.eval(code)
    else
        sampAddChatMessage("[FD] Skipped " .. docName .. " (enabled=" .. tostring(docState.enabled[0]) .. ", onlyOwn=" .. tostring(docState.onlyOwn[0]) .. ", viewing=" .. tostring(State.isViewingOtherPlayer) .. ")", 0xFFFF00)
    end
end

function acef.onArizonaDisplay(packet)
    if packet.text:find(INIT_EVENT, 1, true)
        and not packet.text:find(_getPlayerNickname(), 1, true) then
        State.isViewingOtherPlayer = true
        sampAddChatMessage("[FD] Viewing other player's documents", 0xFFAA00)
    end

    if packet.text:find('"type":1', 1, true) or packet.text == UPDATE_PAGE:format(1) then
        sampAddChatMessage("[FD] Detected Passport (type:1)", 0x00AAFF)
        _tryApply(Passport.state, PassportBuilder, "Passport")
    end

    if packet.text:find('"type":2', 1, true) or packet.text == UPDATE_PAGE:format(2) then
        sampAddChatMessage("[FD] Detected Licenses (type:2)", 0x00AAFF)
        _tryApply(Licenses.state, LicensesBuilder, "Licenses")
    end

    if packet.text:find('"type":4', 1, true) or packet.text == UPDATE_PAGE:format(4) then
        sampAddChatMessage("[FD] Detected Medical (type:4)", 0x00AAFF)
        _tryApply(Medical.state, MedicalBuilder, "Medical")
    end

    if packet.text:find('"type":8', 1, true) or packet.text == UPDATE_PAGE:format(8) then
        sampAddChatMessage("[FD] Detected Military (type:8)", 0x00AAFF)
        _tryApply(Military.state, MilitaryBuilder, "Military")
    end

    if packet.text:find('"type":16', 1, true) or packet.text == UPDATE_PAGE:format(16) then
        sampAddChatMessage("[FD] Detected Property (type:16)", 0x00AAFF)
        _tryApply(Property.state, PropertyBuilder, "Property")
    end

    if packet.text:find('"type":32', 1, true) or packet.text == UPDATE_PAGE:format(32) then
        sampAddChatMessage("[FD] Detected Vehicle (type:32)", 0x00AAFF)
        _tryApply(Vehicle.state, VehicleBuilder, "Vehicle")
    end

    if packet.text:find('"type":64', 1, true) or packet.text == UPDATE_PAGE:format(64) then
        sampAddChatMessage("[FD] Detected VIP (type:64)", 0x00AAFF)
        _tryApply(Vip.state, VipBuilder, "VIP")
    end
end

function acef.onArizonaSend(packet)
    if packet.text:find(CLOSE_EVENT, 1, true) then
        State.isViewingOtherPlayer = false
        sampAddChatMessage("[FD] Documents closed", 0x888888)
    end
end

return {}
