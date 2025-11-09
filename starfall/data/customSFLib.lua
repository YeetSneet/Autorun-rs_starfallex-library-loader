
-- @name Custom
-- @class library
-- @libtbl custom_library
SF.RegisterLibrary("custom")

local checkluatype = SF.CheckLuaType

return function(instance)

    local library = instance.Libraries.custom

    local ang_meta, aunwrap = instance.Types.Angle, instance.Types.Angle.Unwrap
    local vec_meta, vunwrap = instance.Types.Vector, instance.Types.Vector.Unwrap
    local CheckType = instance.CheckType

    local function unwrap(...)
        local data = {...}
        for k, v in pairs(data) do
            local t = SF.GetType(v)
            local it = instance.Types[t]
            data[k] = (it and it.Unwrap(v) or v)
        end
        return unpack(data)
    end

    local function wrap(...)
        local data = {...}
        for k, v in pairs(data) do
            local t = SF.GetType(v)
            local it = instance.Types[t]
            data[k] = (it and it.Wrap(v) or v)
        end
        return unpack(data)
    end

    local checkpermission = (LocalPlayer()==instance.player)
    function library.setEyeAngles(ang)
        if not checkpermission then return end
        CheckType(ang, ang_meta)
        LocalPlayer():SetEyeAngles(unwrap(ang))
    end
    
    function library.CompileString(str)
        if not checkpermission then return end
        checkluatype(str, TYPE_STRING)

        local func = CompileString(str, "Compiled String", false)
        if isfunction(func) then
            return wrap(func())
        else
            SF.Throw("Failed to compile string: "..func)
        end
    end
end