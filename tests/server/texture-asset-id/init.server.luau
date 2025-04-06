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

local loadedTexture = Texture.fromAssetId(17544804292):Unwrap()

local WIDTH = loadedTexture.width
local HEIGHT = loadedTexture.height

local myWindow = Window.from(Decal, WIDTH, HEIGHT)

if not myWindow.isOk then
	warn("Encountered Error,", myWindow:UnwrapErr())
	return
end

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()
Texture.drawChecked(unwrappedWindow, loadedTexture, 0, 0)
unwrappedWindow:Render()