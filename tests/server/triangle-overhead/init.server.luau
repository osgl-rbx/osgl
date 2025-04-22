local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OSGL = require(ReplicatedStorage.OSGL)
local Window = OSGL.Window
local color = OSGL.color

local Block = Instance.new("Part")
Block.Name = "WindowPart"
Block.Parent = workspace
Block.Anchored = true
Block.Size = Vector3.new(5, 0, 5)
Block.Position = Vector3.new(0, 5, 0)

local Texture = Instance.new("Texture")
Texture.Name = "WindowTexture"
Texture.Face = Enum.NormalId.Top
Texture.Parent = Block

local WIDTH = 1024
local HEIGHT = 1024

local myWindow = Window.from(Texture, WIDTH, HEIGHT)

if not myWindow.isOk then
    warn("Encountered Error,", myWindow:UnwrapErr())
    return
end

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()

while task.wait() do
    local col = color.fromColor3(Color3.fromHSV(tick() % 1, 1, 1))
    unwrappedWindow:Triangle(0,0, 500, 500, 500, 0, col)
    unwrappedWindow:Render()
end