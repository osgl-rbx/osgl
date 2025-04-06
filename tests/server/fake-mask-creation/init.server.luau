local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OSGL = require(ReplicatedStorage.OSGL)
local Bitmap = OSGL.Bitmap

local WIDTH = 50
local HEIGHT = 50

local fakeBitmap = {
	version = "1.6b",
	pixels = buffer.fromstring(string.rep("\255\127", WIDTH * HEIGHT)),
	width = WIDTH,
	height = HEIGHT,
}

local newBitmap = Bitmap.fromChecked(fakeBitmap)
if not newBitmap.isOk then
	warn("Encountered Error,", newBitmap:UnwrapErr())
	return
end

local unwrappedBitmap: OSGL.Bitmap = newBitmap:Unwrap()
print(unwrappedBitmap:Read(0, 0))
print(unwrappedBitmap:Read(1, 0))
print(unwrappedBitmap:Read(0, 0, 2))
print(unwrappedBitmap:Read(1, 0, 2))