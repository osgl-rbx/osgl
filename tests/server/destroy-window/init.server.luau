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

local Texture = Instance.new("Decal")
Texture.Name = "WindowTexture"
Texture.Face = Enum.NormalId.Top
Texture.Parent = Block

local WIDTH = 100
local HEIGHT = 100

local myWindow = Window.from(Texture, WIDTH, HEIGHT)

if not myWindow.isOk then
    warn("Encountered Error,", myWindow:UnwrapErr())
    return
end

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()
print("Test started")

for i = 1, 5 do 
    print(`Window is destroyed in {5 - i} seconds, watch memory usage`)
    task.wait(1)
end

print("Window destroyed")
unwrappedWindow:Destroy()