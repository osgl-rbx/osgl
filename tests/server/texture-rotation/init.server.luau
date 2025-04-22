local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OSGL = require(ReplicatedStorage.OSGL)
local Window = OSGL.Window
local Texture = OSGL.Texture

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

local textureObject = script.RobloxLogo
local myWindow = Window.from(Decal, WIDTH, HEIGHT)

if not myWindow.isOk then
    warn("Encountered Error,", myWindow:UnwrapErr())
    return
end

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()

local r = 0
local txt = Texture.fromChecked(textureObject):Unwrap()
while task.wait() do
    r += 1
    Texture.drawUnchecked(unwrappedWindow, txt, 0, 0, r)
    unwrappedWindow:Render()
    unwrappedWindow:Clear()
end