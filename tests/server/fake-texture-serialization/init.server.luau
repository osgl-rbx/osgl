local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OSGL = require(ReplicatedStorage.OSGL)
local Window = OSGL.Window
local Texture = OSGL.Texture
local color = OSGL.color

local WIDTH = 500
local HEIGHT = 500

local oldWindow = Window.from(workspace.SpawnLocation.Decal, 50, 50)
local myWindow = Window.from(workspace.SpawnLocation.Decal, WIDTH, HEIGHT)

if not myWindow.isOk then
	warn("Encountered Error,", myWindow:UnwrapErr())
    return
end

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()
local unwrappedOld: OSGL.Window = oldWindow:Unwrap()
unwrappedOld:Clear(color.RED)

local fakeTexture = {
    version = "1.6.1",
    width = 50,
    height = 50,
    pixels = unwrappedOld.buffer
}

local bfr, w, h = Texture.serializeChecked(fakeTexture)
print(bfr, w, h)
