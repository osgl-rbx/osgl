local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OSGL = require(ReplicatedStorage.OSGL)
local Bitmap = OSGL.Bitmap
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

local WIDTH = 622
local HEIGHT = 622

local myWindow = Window.from(Texture, WIDTH, HEIGHT)

if not myWindow.isOk then
	warn("Encountered Error,", myWindow:UnwrapErr())
	return
end

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()

local RBitmap = Bitmap.fromChecked(script.R):Unwrap()
local GBitmap = Bitmap.fromChecked(script.G):Unwrap()
local BBitmap = Bitmap.fromChecked(script.B):Unwrap()

for X = 0, 621 do
	for Y = 0, 621 do
		local R = RBitmap:Read(X, Y)
		local G = GBitmap:Read(X, Y)
		local B = BBitmap:Read(X, Y)
		local col = color.newRGB(R, G, B)

		unwrappedWindow:Pixel(X, Y, col)
	end
end

unwrappedWindow:Render()
