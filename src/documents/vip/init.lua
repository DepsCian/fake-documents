local imgui = require("mimgui")
local ffi = require("ffi")
local Encoding = require("core/encoding")
local u8 = Encoding.u8

local FIELDS = {
    { key = "statusName", bufSize = 128 },
    { key = "statusTime", bufSize = 128 },
    { key = "addVipDays", bufSize = 128 },
}

local LEVEL_FIELDS = {
    { key = "text", bufSize = 256 },
    { key = "desc", bufSize = 512 },
}

local VIP_STATUS_FIELDS = {
    { key = "type", bufSize = 64 },
    { key = "date", bufSize = 128 },
}

local DEFAULTS = {
    enabled    = false,
    onlyOwn    = true,
    statusName = { value = u8"VIP Diamond", enabled = true },
    statusTime = { value = u8"999 дней",    enabled = true },
    addVipDays = { value = u8"999 дней",    enabled = true },
    premiumLevels = {
        [1] = { enabled = true, mark = true, text = { value = u8"Телепорт транспорта и отсутствие налогов на тс.", enabled = true }, desc = { value = u8"Возможность телепортировать к себе личный транспорт", enabled = true } },
        [2] = { enabled = true, mark = true, text = { value = u8"Отсутствие поломок аксессуаров", enabled = true }, desc = { value = u8"При смерти аксессуары не будут терять прочности", enabled = true } },
        [3] = { enabled = false, mark = false, text = { value = u8"Мидас, быстрый призыв охранника", enabled = true }, desc = { value = u8"Время на призыв охранника 3 секунды", enabled = true } },
        [4] = { enabled = true, mark = true, text = { value = u8"2 точки спавна", enabled = true }, desc = { value = u8"Возможность устанавливать до 2-х точек для спавна", enabled = true } },
        [5] = { enabled = true, mark = true, text = { value = u8"Доп. слоты имущества", enabled = true }, desc = { value = u8"+3 слота для домов, +10 для транспорта", enabled = true } },
        [6] = { enabled = true, mark = true, text = { value = u8"+1 страница инвентаря", enabled = true }, desc = { value = u8"Увеличенный стак ресурсов", enabled = true } },
        [7] = { enabled = false, mark = false, text = { value = u8"Porsche 992 Off-Road", enabled = true }, desc = { value = u8"Медленная потеря сытости", enabled = true } },
        [8] = { enabled = false, mark = false, text = { value = u8"Увеличенный шанс крафта", enabled = true }, desc = { value = u8"+1% к успешному крафту", enabled = true } },
        [9] = { enabled = false, mark = false, text = { value = u8"Увеличенный дроп", enabled = true }, desc = { value = u8"+15% дроп с ларцов и контейнеров", enabled = true } },
        [10] = { enabled = false, mark = false, text = { value = u8"Паспорт Vice City", enabled = true }, desc = { value = u8"Сборка шаров в зеленой зоне", enabled = true } },
    },
    vipStatuses = {
        [1] = { enabled = true, type = { value = u8"ADD VIP", enabled = true }, date = { value = u8"FOREVER", enabled = true } },
        [2] = { enabled = true, type = { value = u8"Premium VIP", enabled = true }, date = { value = u8"Бессрочно", enabled = true } },
        [3] = { enabled = false, type = { value = u8"Titan VIP", enabled = true }, date = { value = u8"", enabled = true } },
        [4] = { enabled = false, type = { value = u8"Diamond VIP", enabled = true }, date = { value = u8"", enabled = true } },
    },
}

local Vip = {}
Vip.FIELDS = FIELDS
Vip.LEVEL_FIELDS = LEVEL_FIELDS
Vip.VIP_STATUS_FIELDS = VIP_STATUS_FIELDS
Vip.DEFAULTS = DEFAULTS
Vip.state = nil

local function _createLevelsState(cfgLevels)
    local levels = {}
    for i = 1, 10 do
        local lvl = cfgLevels[i]
        levels[i] = {
            enabled = imgui.new.bool(lvl.enabled),
            mark = imgui.new.bool(lvl.mark),
            text = {
                value = imgui.new.char[256](lvl.text.value),
                enabled = imgui.new.bool(lvl.text.enabled),
            },
            desc = {
                value = imgui.new.char[512](lvl.desc.value),
                enabled = imgui.new.bool(lvl.desc.enabled),
            },
        }
    end
    return levels
end

local function _createVipStatusesState(cfgStatuses)
    local statuses = {}
    for i = 1, 4 do
        local st = cfgStatuses[i]
        statuses[i] = {
            enabled = imgui.new.bool(st.enabled),
            type = {
                value = imgui.new.char[64](st.type.value),
                enabled = imgui.new.bool(st.type.enabled),
            },
            date = {
                value = imgui.new.char[128](st.date.value),
                enabled = imgui.new.bool(st.date.enabled),
            },
        }
    end
    return statuses
end

function Vip.createState(cfg)
    local state = {
        enabled = imgui.new.bool(cfg.enabled),
        onlyOwn = imgui.new.bool(cfg.onlyOwn ~= false),
        premiumLevels = _createLevelsState(cfg.premiumLevels),
        vipStatuses = _createVipStatusesState(cfg.vipStatuses),
    }
    for _, field in ipairs(FIELDS) do
        state[field.key] = {
            value   = imgui.new.char[field.bufSize](cfg[field.key].value),
            enabled = imgui.new.bool(cfg[field.key].enabled),
        }
    end
    Vip.state = state
    return state
end

local function _syncLevelsToConfig(cfgLevels, stateLevels)
    for i = 1, 10 do
        cfgLevels[i].enabled = stateLevels[i].enabled[0]
        cfgLevels[i].mark = stateLevels[i].mark[0]
        cfgLevels[i].text.value = ffi.string(stateLevels[i].text.value)
        cfgLevels[i].text.enabled = stateLevels[i].text.enabled[0]
        cfgLevels[i].desc.value = ffi.string(stateLevels[i].desc.value)
        cfgLevels[i].desc.enabled = stateLevels[i].desc.enabled[0]
    end
end

local function _syncVipStatusesToConfig(cfgStatuses, stateStatuses)
    for i = 1, 4 do
        cfgStatuses[i].enabled = stateStatuses[i].enabled[0]
        cfgStatuses[i].type.value = ffi.string(stateStatuses[i].type.value)
        cfgStatuses[i].type.enabled = stateStatuses[i].type.enabled[0]
        cfgStatuses[i].date.value = ffi.string(stateStatuses[i].date.value)
        cfgStatuses[i].date.enabled = stateStatuses[i].date.enabled[0]
    end
end

function Vip.syncToConfig(cfg)
    local s = Vip.state
    cfg.enabled = s.enabled[0]
    cfg.onlyOwn = s.onlyOwn[0]
    _syncLevelsToConfig(cfg.premiumLevels, s.premiumLevels)
    _syncVipStatusesToConfig(cfg.vipStatuses, s.vipStatuses)
    for _, field in ipairs(FIELDS) do
        cfg[field.key].value   = ffi.string(s[field.key].value)
        cfg[field.key].enabled = s[field.key].enabled[0]
    end
end

return Vip
