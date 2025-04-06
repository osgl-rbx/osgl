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
local textureCopy = script.RobloxLogo2

local myWindow = Window.from(Decal, WIDTH, HEIGHT)

if not myWindow.isOk then
	warn("Encountered Error,", myWindow:UnwrapErr())
	return
end

local ITERATIONS = 256

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()

local uncheckedAvg = 0
for _ = 1, ITERATIONS do
	local start = os.clock()
	local txt = Texture.fromUnchecked(require(textureObject))
	Texture.drawUnchecked(unwrappedWindow, txt, 0, 0)
	unwrappedWindow:Render()
    uncheckedAvg += os.clock() - start
end

local checkedAvg = 0
for _ = 1, ITERATIONS do
    local start = os.clock()
    local txt = Texture.fromChecked(textureCopy):Unwrap()
    Texture.drawChecked(unwrappedWindow, txt, 0, 0)
    unwrappedWindow:Render()
    checkedAvg += os.clock() - start
end

checkedAvg /= ITERATIONS
uncheckedAvg /= ITERATIONS

warn(`Checked avg: {checkedAvg}s`)
warn(`Unchecked avg: {uncheckedAvg}s`)