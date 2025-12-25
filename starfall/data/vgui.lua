local SF = _G.SF

SF.RegisterLibrary("vgui")
SF.RegisterLibrary("draw")
SF.RegisterLibrary("surface")

return function(instance)
    if _G.LocalPlayer() ~= instance.player then return end
    local createdPanels = {}
    local chipID = instance.entity:EntIndex()
    local regLookup = {}

    
    local env = instance.env
    env.NODOCK = 0
    env.FILL = 1
    env.LEFT = 2
    env.RIGHT = 3
    env.TOP = 4
    env.BOTTOM = 5

    env.TEXT_ALIGN_LEFT = 0
    env.TEXT_ALIGN_CENTER = 1
    env.TEXT_ALIGN_RIGHT = 2
    env.TEXT_ALIGN_TOP = 3
    env.TEXT_ALIGN_BOTTOM = 4
    
    env.ScrW = _G.ScrW
    env.ScrH = _G.ScrH
    env.IsValid = _G.IsValid
    


    env.DermaMenu = function (...)
        local pan = _G.DermaMenu(...)
        table.insert(createdPanels, pan)
        return pan
    end
    
    env.VGUIRect = function (...)
        local pan = _G.VGUIRect(...)
        table.insert(createdPanels, pan)
        return pan
    end

    
    local draw_library = instance.Libraries.draw
    for k, v in pairs(_G.draw) do
        draw_library[k] = v
    end

    local surface_libary = instance.Libraries.surface
    for k, v in pairs(_G.surface) do
        surface_libary[k] = v
    end


    
    local GMvgui = _G.vgui
    local vgui_library = instance.Libraries.vgui

    vgui_library.Create = function (class, ...)
        local pan = GMvgui.Create((regLookup[class] or class), ...)
        table.insert(createdPanels, pan)
        return pan
    end

    vgui_library.CreateFromTable = function (...)
        local pan = GMvgui.CreateFromTable(...)
        table.insert(createdPanels, pan)
        return pan
    end

    local sha256 = _G.util.SHA256
    vgui_library.Register = function (class, paneltab, basename)
        local real = sha256(chipID..class)
        regLookup[class] = real
        return GMvgui.Register(real, paneltab, (regLookup[basename] or basename))
    end

    vgui_library.RegisterTable = function (table, basename)
        return GMvgui.RegisterTable(table, (regLookup[basename] or basename))
    end

    local function cleanupPanels()
        for k, v in pairs(createdPanels) do
            if IsValid(v) then
                v:Remove()
            end
            createdPanels[k] = nil
        end
    end

    instance:AddHook("deinitialize", cleanupPanels)
    instance:AddHook("destroy", cleanupPanels)
    instance:AddHook("error", cleanupPanels)
    instance:AddHook("quotaexceed", cleanupPanels)
    instance:AddHook("selfdestruct", cleanupPanels)
end