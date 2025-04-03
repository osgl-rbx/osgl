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

local Block2 = Instance.new("Part")
Block2.Name = "WindowPart2"
Block2.Parent = workspace
Block2.Anchored = true
Block2.Size = Vector3.new(5, 0, 5)
Block2.Position = Vector3.new(0, 5, 5)

local Texture2 = Instance.new("Decal")
Texture2.Name = "WindowTexture2"
Texture2.Face = Enum.NormalId.Top
Texture2.Parent = Block2

local WIDTH = 100
local HEIGHT = 100

local myWindow = Window.from(Texture, WIDTH, HEIGHT)
local secondWindow = Window.from(Texture2, WIDTH, HEIGHT)

if not myWindow.isOk then
	warn("Encountered Error,", myWindow:UnwrapErr())
	return
end

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()
local comparisonWindow: OSGL.Window = secondWindow:Unwrap()

local rnd = math.random
for x = 0, WIDTH - 1 do
	for y = 0, HEIGHT - 1 do
		local col = color.newRGB(rnd(0, 255), rnd(0, 255), rnd(0, 255))
		comparisonWindow:Pixel(x, y, col)
	end
end

comparisonWindow:Render()

local MAX = 5
local MIN = 0
local CHANGE = 0.01
local V = 0
while task.wait() do
	V += CHANGE
	if V > MAX or V < MIN then
		CHANGE = -CHANGE
	end

	unwrappedWindow.buffer = comparisonWindow.buffer

	local S, E = pcall(function()
		unwrappedWindow:Resample(V)
		unwrappedWindow:Render()
	end)

	if not S then
		warn(V)
	else
		print(V)
	end
end

