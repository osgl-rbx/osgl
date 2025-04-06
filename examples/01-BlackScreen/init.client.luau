local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local OSGL = require(ReplicatedStorage.OSGL)

local Window = OSGL.Window
local color = OSGL.color

-- Create instances needed
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Screen"
ScreenGui.Parent = Players.LocalPlayer.PlayerGui

local Image = Instance.new("ImageLabel")
Image.Name = "Texture"
Image.Parent = ScreenGui
Image.AnchorPoint = Vector2.new(.5, .5)
Image.Position = UDim2.fromScale(.5, .5)
Image.Size = UDim2.fromOffset(500, 500)

-- Define window dimensions
local WIDTH = 100
local HEIGHT = 100

local myWindow = Window.from(Image, WIDTH, HEIGHT)

if not myWindow.isOk then
	warn("Encountered Error,", myWindow:UnwrapErr())
    return
end

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()
unwrappedWindow:Clear(color.BLACK)
unwrappedWindow:Render()
