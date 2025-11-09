


starfall = {}
starfall.modules = {}

local function CompileFile(path)
    return Autorun.exists(path) and Autorun.load(Autorun.read(path)) or nil
end

function compileModule(path)
    local ok, init = xpcall(function() local r = (CompileFile(path) or Autorun.load(path)) r=r and r() return r end, debug.traceback)
    if not ok then
        Autorun.print("Attempt to load bad module: " .. path .. "\n" .. init)
        init = nil
    else
        Autorun.print("successfully loaded module: " .. path)
    end
    return init
end

local function addModule(name, path)
    local init = compileModule(path)
    local tbl = _G.SF.Modules[name]
    if not tbl then tbl = {} _G.SF.Modules[name] = tbl end
    tbl[path] = {init = init}
end

function starfall.addModule(name, path)
    table.insert(starfall.modules, {name, path})
end

Autorun.on("loadbuffer", function(scriptName, scriptCode)
    if not string.find(scriptName, "libs_cl/xinput.lua") then
        return
    end

    for _, v in pairs(starfall.modules) do
        addModule(v[1], v[2])
    end
end)