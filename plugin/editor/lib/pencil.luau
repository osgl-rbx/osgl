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
local Window = OSGL.Window
local color = OSGL.color

local namespace = "Pencil"

local previewWindow: OSGL.Window
local selected = "1"
local connections = {}
local radius

return function(UI: t.OSGLEditor, toolset: tools.Tools, file: t.OSGLFile)
    local toolObject = tool.new(namespace)

    local screen = UI.Screen
    local view = screen.View
    local canvas = view.Canvas
    local editable = canvas.Editable
    local editBar = view.EditBar
    local pencil = editBar.Pencil
    local preview = pencil.Preview
    local sizeSelection = pencil.SizeSelection
    local previewLabel = preview.Preview
    local pencilButton = pencil.Pencil

    local quickTween = TweenInfo.new(0.15, Enum.EasingStyle.Quad)

    local function calculateBrushRadius(brushSizeLevel, width, height)
        return math.floor(
            ((
                (width + height) / 2
            ) * (0.05 * (brushSizeLevel^2))) / 2
        )
    end

    local previousRadius
    local thread
    local col = 0xFF0000FF
    local function updatePreview(centerX, centerY, newRadius: number)
        if thread then
            task.cancel(thread)
            thread = nil
        end

        thread = task.spawn(function()
            local steps = 10 
            local stepTime = 0.0125
            
            for i = 0, steps do
                local alpha = i/steps 
                local currentRadius = math.floor(math.lerp(previousRadius, newRadius, alpha))
                
                previewWindow:Clear()
                previewWindow:Circle(centerX, centerY, currentRadius, col)
                previewWindow:Render()

                task.wait(stepTime)
                
                if coroutine.status(coroutine.running()) == "dead" then
                    return
                end
            end
            
            previewWindow:Clear()
            previewWindow:Circle(centerX, centerY, newRadius, col)
            previewWindow:Render()

            thread = nil
        end)

        repeat
            task.wait()
        until not thread
    end

    function toolObject:OnRegistration()
        table.insert(
            connections,
            pencilButton.State.MouseButton1Click:Connect(function()
                if toolset.selected == namespace then
                    toolset:Deselect()
                else
                    toolset:Select(namespace)
                end
            end)
        )

        local width, height = file.width, file.height
        radius = calculateBrushRadius(1, width, height)
        previousRadius = radius

        local bigSize = calculateBrushRadius(4, width, height) * 2
        local previewSize = math.min(math.floor(bigSize * 1.5), 1024)

        if previewWindow then
            previewWindow:Destroy()
        end

        previewWindow = Window.from(previewLabel, previewSize, previewSize):Unwrap()

        local centerX, centerY = math.floor(previewWindow.width / 2), math.floor(previewWindow.height / 2)

        for _, v: TextButton in sizeSelection:GetChildren() do
            if v:IsA("TextButton") then
                v.Selection.Enabled = true
                v.Selection.Thickness = 0

                if selected == v.Name then
                    v.Selection.Thickness = 5
                end

                table.insert(connections, v.MouseButton1Click:Connect(function()
                    if selected == v.Name then
                        return
                    end

                    local item = sizeSelection:FindFirstChild(selected)
                    TweenService:Create(item.Selection, quickTween, {
                        Thickness = 0,
                    }):Play()

                    TweenService:Create(v.Selection, quickTween, {
                        Thickness = 5,
                    }):Play()

                    selected = v.Name

                    radius = calculateBrushRadius(tonumber(v.Name), width, height)
                    sizeSelection:SetAttribute("Radius", radius)
                    updatePreview(centerX, centerY, radius)
                    previousRadius = radius
                end))
            end
        end

        sizeSelection:SetAttribute("Radius", radius)
        updatePreview(centerX, centerY, radius)

        table.insert(connections, view.AttributeChanged:Connect(function(attribute)
            if attribute ~= "Color" then
                return
            end
    
            col = view:GetAttribute(attribute)
            updatePreview(centerX, centerY, radius)
        end))
    end

    local prevX, prevY = nil, nil
    function toolObject:Frame(window: OSGL.Window)
        local onWindow, x, y = window:GetRelativeMousePosition(editable)
        if not onWindow then
            return
        end
    
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            prevX = nil
            prevY = nil
            return
        end
    
        if not prevX or not prevY then
            prevX = x
            prevY = y
        end

        local dx = x - prevX
        local dy = y - prevY
        local distance = math.sqrt(dx * dx + dy * dy)
        local steps = math.max(1, math.floor(distance / (radius * .5)))
    
        for i = 0, steps do
            local t = i / steps
            local cx = prevX + dx * t
            local cy = prevY + dy * t
            window:Circle(math.floor(cx), math.floor(cy), math.floor(radius), col)
        end
    
        prevX = x
        prevY = y
    
        window:Render()
    end

    function toolObject:OnSelect(self: tool.editorTool)
        local UIStroke = pencilButton.Contents.Selection :: UIStroke
        UIStroke.Thickness = 0
        UIStroke.Enabled = true

        TweenService:Create(pencilButton.Contents.Selection, quickTween, {
            Thickness = 6,
        }):Play()
    end

    function toolObject:OnDeselect(self: tool.editorTool)
        local UIStroke = pencilButton.Contents.Selection :: UIStroke
        UIStroke.Thickness = 6
        UIStroke.Enabled = true

        TweenService:Create(pencilButton.Contents.Selection, quickTween, {
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
