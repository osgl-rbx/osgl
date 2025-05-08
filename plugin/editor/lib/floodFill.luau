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

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local lib = script.Parent
local editorFolder = lib.Parent
local osglTools = editorFolder.Parent

local tool = require(editorFolder.editorTool)
local tools = require(editorFolder.tools)
local t = require(editorFolder.types)
local OSGL = require(osglTools.OSGL)
local color = OSGL.color

local namespace = "FloodFill"
local connections: {RBXScriptConnection} = {}

local plugin = script:FindFirstAncestorOfClass("Plugin")

return function(UI: t.OSGLEditor, toolset: tools.Tools)
    local toolObject = tool.new(namespace)

    local screen = UI.Screen
    local view = screen.View
    local canvas = view.Canvas
    local editable = canvas.Editable
    local editBar = view.EditBar
    local floodFill = editBar.FloodFill

    local quickTween = TweenInfo.new(0.15, Enum.EasingStyle.Quad)

    function toolObject:OnRegistration()
        table.insert(
            connections,
            floodFill.State.MouseButton1Click:Connect(function()
                if toolset.selected == namespace then
                    toolset:Deselect()
                else
                    toolset:Select(namespace)
                end
            end)
        )
    end
    
    function toolObject:Frame(window: OSGL.Window)
        local onWindow, x, y = window:GetRelativeMousePosition(editable)
        if not onWindow then
            return
        end

        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            return
        end

        local c = view:GetAttribute("Color")
        window:FloodFill(x, y, c)
        window:Render()
    end

    function toolObject:OnSelect(self: tool.editorTool)
        local UIStroke = floodFill.Contents.Selection :: UIStroke
        UIStroke.Thickness = 0
        UIStroke.Enabled = true

        TweenService:Create(floodFill.Contents.Selection, quickTween, {
            Thickness = 6,
        }):Play()
    end

    function toolObject:OnDeselect(self: tool.editorTool)
        local UIStroke = floodFill.Contents.Selection :: UIStroke
        UIStroke.Thickness = 6
        UIStroke.Enabled = true

        TweenService:Create(floodFill.Contents.Selection, quickTween, {
            Thickness = 0,
        }):Play()

        task.wait(quickTween.Time)
        UIStroke.Enabled = false
    end

    function toolObject:Cleanup()
        for _, v in connections do
            v:Disconnect()
        end

        table.clear(connections)
    end

    return toolObject
end
