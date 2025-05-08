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

local GuiService = game:GetService("GuiService")
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

local namespace = "Eraser"
local connections: {RBXScriptConnection} = {}

local plugin = script:FindFirstAncestorOfClass("Plugin")

return function(UI: t.OSGLEditor, toolset: tools.Tools)
    local toolObject = tool.new(namespace)

    local screen = UI.Screen
    local view = screen.View
    local canvas = view.Canvas
    local editable = canvas.Editable
    local editBar = view.EditBar
    local eraser = editBar.Eraser
    local sizeSelection = editBar.Pencil.SizeSelection

    local quickTween = TweenInfo.new(0.15, Enum.EasingStyle.Quad)

    function toolObject:OnRegistration()

    end

    local lastActivation = os.clock()
    local firstPositionX
    local firstPositionY
    local accumulatedDeltaX, accumulatedDeltaY = 0, 0
    local prevEraseX, prevEraseY
    function toolObject:Frame(window: OSGL.Window)
        local now = os.clock()
        
        if now - lastActivation > 0.15 then
            local onWindow, x, y = window:GetRelativeMousePosition(editable)
            if onWindow then
                firstPositionX, firstPositionY = math.floor(x), math.floor(y)
                lastActivation = os.clock()
                accumulatedDeltaX, accumulatedDeltaY = 0, 0
                prevEraseX, prevEraseY = firstPositionX, firstPositionY
            else
                firstPositionX, firstPositionY = nil, nil
                prevEraseX, prevEraseY = nil, nil
            end
            return
        end
    
        if not firstPositionX or not firstPositionY or not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            prevEraseX, prevEraseY = nil, nil
            return
        end
    
        local mouseDelta = UserInputService:GetMouseDelta()
        accumulatedDeltaX = accumulatedDeltaX + mouseDelta.X
        accumulatedDeltaY = accumulatedDeltaY + mouseDelta.Y
        
        local currentX = math.floor(firstPositionX + accumulatedDeltaX)
        local currentY = math.floor(firstPositionY + accumulatedDeltaY)
    
        if currentX < 0 or currentY < 0 or currentX >= window.width or currentY >= window.height then
            prevEraseX, prevEraseY = nil, nil
            return
        end
    
        if prevEraseX and prevEraseY then
            local dx = currentX - prevEraseX
            local dy = currentY - prevEraseY
            local distance = math.sqrt(dx * dx + dy * dy)
            local radius = sizeSelection:GetAttribute("Radius")
            local steps = math.max(1, math.floor(distance / (radius * 0.5)))
    
            for i = 0, steps do
                local t = i / steps
                local cx = math.floor(prevEraseX + dx * t)
                local cy = math.floor(prevEraseY + dy * t)
                window:Circle(cx, cy, radius, color.TRANSPARENT)
            end
        else
            window:Circle(currentX, currentY, sizeSelection:GetAttribute("Radius"), color.TRANSPARENT)
        end
    
        prevEraseX, prevEraseY = currentX, currentY
        lastActivation = now
        window:Render()
    end

    function toolObject:OnSelect(self: tool.editorTool)
        local UIStroke = eraser.Contents.Selection :: UIStroke
        UIStroke.Thickness = 0
        UIStroke.Enabled = true

        TweenService:Create(eraser.Contents.Selection, quickTween, {
            Thickness = 6,
        }):Play()
    end

    function toolObject:OnDeselect(self: tool.editorTool)
        local UIStroke = eraser.Contents.Selection :: UIStroke
        UIStroke.Thickness = 6
        UIStroke.Enabled = true

        TweenService:Create(eraser.Contents.Selection, quickTween, {
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
