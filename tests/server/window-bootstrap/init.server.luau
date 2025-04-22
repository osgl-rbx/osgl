local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OSGL = require(ReplicatedStorage.OSGL)
local Window = OSGL.Window

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

local WIDTH = 5
local HEIGHT = 5

local myWindow = Window.from(Texture, WIDTH, HEIGHT)

if not myWindow.isOk then
    warn("Encountered Error,", myWindow:UnwrapErr())
    return
end

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()
assert(unwrappedWindow.width == WIDTH, "Test failed! (1)")
assert(unwrappedWindow.height == HEIGHT, "Test failed! (2)")
assert(buffer.len(unwrappedWindow.buffer) == WIDTH * HEIGHT * 4, "Test failed! (3)")

warn("All tests (3) passed!")