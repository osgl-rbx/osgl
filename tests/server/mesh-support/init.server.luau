local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OSGL = require(ReplicatedStorage.OSGL)
local Window = OSGL.Window
local color = OSGL.color

local Mesh = Instance.new("MeshPart")
Mesh.Name = "WindowPart"
Mesh.Parent = workspace
Mesh.Anchored = true
Mesh.Size = Vector3.new(5, 0, 5)
Mesh.Position = Vector3.new(0, 5, 0)

local WIDTH = 5
local HEIGHT = 5

local myWindow = Window.from(Mesh, WIDTH, HEIGHT)

if not myWindow.isOk then
	warn("Encountered Error,", myWindow:UnwrapErr())
    return
end

local unwrappedWindow: OSGL.Window = myWindow:Unwrap()
unwrappedWindow:Clear(color.RED)
unwrappedWindow:Render()