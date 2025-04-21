local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local OSGL = require(ReplicatedStorage.OSGL)
local Window = OSGL.Window
local color = OSGL.color

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Screen"
ScreenGui.Parent = Players.LocalPlayer.PlayerGui

local Image = Instance.new("ImageLabel")
Image.Name = "Texture"
Image.Parent = ScreenGui
Image.AnchorPoint = Vector2.new(.5, .5)
Image.Position = UDim2.fromScale(.5, .5)
Image.Size = UDim2.fromOffset(500, 500)
Image.ResampleMode = Enum.ResamplerMode.Pixelated

local WIDTH = 1024
local HEIGHT = 1024

local myWindow = Window.from(Image, WIDTH, HEIGHT)

if not myWindow.isOk then
	warn("Encountered Error,", myWindow:UnwrapErr())
    return
end

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()
while task.wait() do
    local inWindow, X, Y = unwrappedWindow:GetRelativeMousePosition(Image)
    if not inWindow or not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        continue
    end
    
    unwrappedWindow:Clear()
    unwrappedWindow:Circle(X, Y, 500, color.RED, color.BLACK, 50)
    unwrappedWindow:Render()
end