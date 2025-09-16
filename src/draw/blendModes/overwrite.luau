--!optimize 2
--!native

------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
------------------------------------------------------------

local Draw = script.Parent.Parent
local OSGL = Draw.Parent
local types = require(OSGL.types)

return function<T>(self: types.DrawableObject<T>, X: number, Y: number, Color: types.Color)
    buffer.writeu32(self.buffer, (Y * self.width + X) * 4, Color)
end
