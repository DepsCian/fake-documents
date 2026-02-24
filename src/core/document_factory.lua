local imgui = require("mimgui")
local ffi = require("ffi")

local Factory = {}

function Factory.create(FIELDS, DEFAULTS)
    local Module = {}
    Module.FIELDS = FIELDS
    Module.DEFAULTS = DEFAULTS
    Module.state = nil

    function Module.createState(cfg)
        local state = {
            enabled = imgui.new.bool(cfg.enabled),
            onlyOwn = imgui.new.bool(cfg.onlyOwn ~= false),
        }
        
        if cfg.showEmptyState ~= nil then
            state.showEmptyState = imgui.new.bool(cfg.showEmptyState == true)
        end
        
        if cfg.examProgress ~= nil then
            state.examProgress = imgui.new.bool(cfg.examProgress)
        end
        
        for _, field in ipairs(FIELDS) do
            state[field.key] = {
                value = imgui.new.char[field.bufSize](cfg[field.key].value),
                enabled = imgui.new.bool(cfg[field.key].enabled),
            }
        end
        
        Module.state = state
        return state
    end

    function Module.syncToConfig(cfg)
        local s = Module.state
        cfg.enabled = s.enabled[0]
        cfg.onlyOwn = s.onlyOwn[0]
        
        if s.showEmptyState then
            cfg.showEmptyState = s.showEmptyState[0]
        end
        
        if s.examProgress then
            cfg.examProgress = s.examProgress[0]
        end
        
        for _, field in ipairs(FIELDS) do
            cfg[field.key].value = ffi.string(s[field.key].value)
            cfg[field.key].enabled = s[field.key].enabled[0]
        end
    end

    return Module
end

return Factory