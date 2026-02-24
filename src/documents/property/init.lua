local imgui = require("mimgui")
local ffi = require("ffi")
local Encoding = require("core/encoding")
local u8 = Encoding.u8

local PROPERTY_FIELDS = {
    { key = "name", bufSize = 256 },
}

local DEFAULTS = {
    enabled = false,
    onlyOwn = true,
    residential = {
        [1] = { enabled = false, name = { value = u8"Особняк на Vinewood Hills", enabled = false } },
        [2] = { enabled = false, name = { value = u8"", enabled = false } },
        [3] = { enabled = false, name = { value = u8"", enabled = false } },
        [4] = { enabled = false, name = { value = u8"", enabled = false } },
        [5] = { enabled = false, name = { value = u8"", enabled = false } },
    },
    commercial = {
        [1] = { enabled = false, name = { value = u8"Бизнес-центр Downtown", enabled = false } },
        [2] = { enabled = false, name = { value = u8"", enabled = false } },
        [3] = { enabled = false, name = { value = u8"", enabled = false } },
        [4] = { enabled = false, name = { value = u8"", enabled = false } },
        [5] = { enabled = false, name = { value = u8"", enabled = false } },
    },
}

local Property = {}
Property.FIELDS = PROPERTY_FIELDS
Property.DEFAULTS = DEFAULTS
Property.state = nil

local function _createCategoryState(cfgCategory)
    local items = {}
    for i = 1, 5 do
        local slot = cfgCategory[i]
        items[i] = {
            enabled = imgui.new.bool(slot.enabled),
            name = {
                value   = imgui.new.char[256](slot.name.value),
                enabled = imgui.new.bool(slot.name.enabled),
            },
        }
    end
    return items
end

function Property.createState(cfg)
    local state = {
        enabled     = imgui.new.bool(cfg.enabled),
        onlyOwn     = imgui.new.bool(cfg.onlyOwn ~= false),
        residential = _createCategoryState(cfg.residential),
        commercial  = _createCategoryState(cfg.commercial),
    }
    Property.state = state
    return state
end

local function _syncCategoryToConfig(cfgCategory, stateCategory)
    for i = 1, 5 do
        cfgCategory[i].enabled      = stateCategory[i].enabled[0]
        cfgCategory[i].name.value   = ffi.string(stateCategory[i].name.value)
        cfgCategory[i].name.enabled = stateCategory[i].name.enabled[0]
    end
end

function Property.syncToConfig(cfg)
    local s = Property.state
    cfg.enabled = s.enabled[0]
    cfg.onlyOwn = s.onlyOwn[0]
    _syncCategoryToConfig(cfg.residential, s.residential)
    _syncCategoryToConfig(cfg.commercial, s.commercial)
end

return Property
