local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OSGL = require(ReplicatedStorage.OSGL)
local Window = OSGL.Window

local win: OSGL.Window = Window.fromAssetId(15675868981):Unwrap()
win:AddRenderers(workspace.SpawnLocation.Decal)

local newBuff = buffer.create(win.width * win.height * 4)
buffer.copy(newBuff, 0, win.buffer)
win:Clear()
win:Buffer(newBuff, 512, 512, 0, 0)
win:Render()