local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local OSGL = require(ReplicatedStorage.OSGL)

local Window = OSGL.Window
local Texture = OSGL.Texture
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
local WIDTH = 50
local HEIGHT = 50

local myWindow = Window.from(Image, WIDTH, HEIGHT)

if not myWindow.isOk then
	warn("Encountered Error,", myWindow:UnwrapErr())
    return
end

local texture = Texture.fromChecked(script.RobloxLogo):Unwrap()

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()
Texture.drawChecked(unwrappedWindow, texture, 0, 0)

unwrappedWindow:Render()