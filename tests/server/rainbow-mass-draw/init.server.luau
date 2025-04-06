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

local Surface = Instance.new("SurfaceGui")
Surface.Name = "WindowTexture"
Surface.Face = Enum.NormalId.Top
Surface.Parent = Block

local Texture = Instance.new("ImageLabel")
Texture.Parent = Surface
Texture.Name = "Texture"
Texture.Size = UDim2.fromScale(1, 1)

local WIDTH = 500
local HEIGHT = 500

local myWindow = Window.from(Texture, WIDTH, HEIGHT)

if not myWindow.isOk then
	warn("Encountered Error,", myWindow:UnwrapErr())
    return
end

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()

while task.wait() do
    for y = 0, HEIGHT - 1 do
        for x = 0, WIDTH - 2 do
            local pixelColor = unwrappedWindow:ReadPixelUnchecked(x + 1, y) 
            unwrappedWindow:Pixel(x, y, pixelColor)
        end
    end

    for y = 0, HEIGHT - 1 do
        local hue = (tick() * 0.1 + y / HEIGHT) % 1
        local col = Color3.fromHSV(hue, 1, 1)
        unwrappedWindow:Pixel(WIDTH - 1, y, color.fromColor3(col))
    end

    unwrappedWindow:Render()
end