--!optimize 2
--!native

------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
------------------------------------------------------------

local Draw = script.Parent
local OSGL = Draw.Parent
local types = require(OSGL.types)

return function<T>(self: types.DrawableObject<T>, Index: number, Color: types.Color)
    buffer.writeu32(self.buffer, Index, Color)
end
