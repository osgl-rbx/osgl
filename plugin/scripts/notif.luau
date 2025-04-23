------------------------------------------------------------
-- OSGL v1.6.15 - Open-Source Graphical Library
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

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local osglScripts = script.Parent
local osglPlugin = osglScripts.Parent

local notifGui
local quickTween = TweenInfo.new(.125, Enum.EasingStyle.Quad)

local Notifications = {}

function Notifications.setup()
    local template = osglPlugin:FindFirstChildOfClass("ScreenGui")
    local preexistingItem = CoreGui:FindFirstChild(template.Name)
    if preexistingItem then
        notifGui = preexistingItem
        return
    end

    local newClone = template:Clone()
    newClone.Parent = CoreGui
    notifGui = newClone

    return
end

local function destroyNotif(notification)
    local notifContents = notification.Notif.Content.Contents
    local textObject = notifContents.Info

    TweenService:Create(notification.Notif, quickTween, { ImageTransparency = 1, Position = UDim2.fromScale(1, 0) }):Play()
    TweenService:Create(textObject, quickTween, { TextTransparency = 1 }):Play()
    TweenService:Create(notifContents.Logo, quickTween, { ImageTransparency = 1 }):Play()

    task.wait(.5)
    notification:Destroy()

    return
end

function Notifications.invoke(message: string)
    local messageTemplate = notifGui.Template
    local newMessage = messageTemplate:Clone()
    newMessage.Visible = false

    local notifContents = newMessage.Notif.Content.Contents
    local textObject = notifContents.Info
    textObject.Text = message

    newMessage.Parent = notifGui
    newMessage.Size = UDim2.fromOffset(math.max(textObject.TextBounds.X, 32) + 88, math.max(textObject.TextBounds.Y, 32) + 27.4)

    newMessage.Notif.ImageTransparency = 1
    textObject.TextTransparency = 1
    notifContents.Logo.ImageTransparency = 1

    newMessage.Visible = true

    TweenService:Create(newMessage.Notif, quickTween, { ImageTransparency = 0, Position = UDim2.fromOffset(0, 0) }):Play()
    TweenService:Create(textObject, quickTween, { TextTransparency = 0 }):Play()
    TweenService:Create(notifContents.Logo, quickTween, { ImageTransparency = 0 }):Play()

    local connectionOnClick
    connectionOnClick = newMessage.MouseButton1Click:Connect(function()
        connectionOnClick:Disconnect()
        destroyNotif(newMessage)
    end)

    task.delay(5, function()
        if newMessage.Parent then
            destroyNotif(newMessage)
        end
    end)
end

return Notifications
