local Config = {}

local _data = nil
local _configDir = getWorkingDirectory() .. "\\config"
local _configPath = _configDir .. "\\fake_doc.json"

local function _ensureDirectory()
    if not doesDirectoryExist(_configDir) then
        createDirectory(_configDir)
    end
end

local function _deepMerge(target, defaults)
    for k, v in pairs(defaults) do
        if target[k] == nil then
            target[k] = v
        elseif type(v) == "table" and type(target[k]) == "table" then
            _deepMerge(target[k], v)
        end
    end
    return target
end

local function _readJson(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    local ok, result = pcall(decodeJson, content)
    if not ok or type(result) ~= "table" then return nil end
    return result
end

local function _writeJson(path, data)
    _ensureDirectory()
    local file = io.open(path, "w")
    if not file then
        print("[Fake Documents] Failed to write config: " .. path)
        return false
    end
    file:write(encodeJson(data))
    file:flush()
    file:close()
    return true
end

function Config.load(defaults)
    _ensureDirectory()
    local loaded = _readJson(_configPath)
    if not loaded then
        _data = defaults
        _writeJson(_configPath, _data)
        return _data
    end
    _data = _deepMerge(loaded, defaults)
    return _data
end

function Config.data()
    return _data
end

function Config.write()
    if not _data then
        print("[Fake Documents] Config.write() called before Config.load()")
        return false
    end
    return _writeJson(_configPath, _data)
end

return Config
