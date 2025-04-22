local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OSGL = require(ReplicatedStorage.OSGL)
local Window = OSGL.Window
local Texture = OSGL.Texture
local color = OSGL.color

local Block = Instance.new("Part")
Block.Name = "WindowPart"
Block.Parent = workspace
Block.Anchored = true
Block.Size = Vector3.new(5, 0, 5)
Block.Position = Vector3.new(0, 5, 0)

local Decal = Instance.new("Decal")
Decal.Name = "WindowTexture"
Decal.Face = Enum.NormalId.Top
Decal.Parent = Block

local WIDTH = 50
local HEIGHT = 50

local myWindow = Window.from(Decal, WIDTH, HEIGHT)

if not myWindow.isOk then
    warn("Encountered Error,", myWindow:UnwrapErr())
    return
end

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()
local newTexture = Texture.new(WIDTH, HEIGHT)
newTexture:Clear(color.RED)
Texture.drawChecked(unwrappedWindow, newTexture, 0, 0)
unwrappedWindow:Render()