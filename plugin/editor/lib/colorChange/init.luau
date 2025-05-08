--!optimize 2

------------------------------------------------------------
-- OSGL v1.6.2 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
--
-- Free to use, modify and distribute in your projects (including commercial games ;3)
-- Credit appreciated but not required
--
-- Do NOT:
-- - Repackage and sell OSGL directly
-- - Claim you created the core library
--
-- By using OSGL, you agree to these terms.
-- Full license available in the LICENSE file
------------------------------------------------------------

local UserInputService = game:GetService("UserInputService")

local lib = script.Parent
local editorFolder = lib.Parent
local osglTools = editorFolder.Parent

local tool = require(editorFolder.editorTool)
local tools = require(editorFolder.tools)
local t = require(editorFolder.types)
local OSGL = require(osglTools.OSGL)
local color = OSGL.color
local colorPicker = require(script.colorPicker)

local namespace = "Color"
local connections: {RBXScriptConnection} = {}

local picker = colorPicker.new("tool")
local col = Color3.fromRGB(255)

return function(UI: t.OSGLEditor, toolset: tools.Tools)
    local toolObject = tool.new(namespace)

    local screen = UI.Screen
    local view = screen.View
    local editBar = view.EditBar
    local colorChange = editBar.ColorChange

    function toolObject:OnRegistration()
        table.insert(
            connections,
            colorChange.Holder.State.MouseButton1Click:Connect(function()
                toolset:CallSelect(namespace)
            end)
        )
    end


    function toolObject:OnSelect(self: tool.editorTool)
        if not picker then
            picker = colorPicker.new(`osgl-{math.random(0, 2^25)}`)
        end

        picker:BindToChange(function(c)
            colorChange.Holder.BackgroundColor3 = c
            view:SetAttribute("Color", color.fromColor3(c))
            col = c
        end)

        picker:Prompt(col)
        picker:Destroy()
        picker = nil
    end

    function toolObject:Cleanup()
        for _, v in connections do
            v:Disconnect()
        end

        table.clear(connections)
    end

    return toolObject
end
