--!optimize 2
--!native

------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
--
-- Free to use, modify and distribute in your projects (including commercial games ;3)
-- Credit appreciated but not required
--
-- Do NOT:
-- - Repackage and sell OSGL directly
-- - Claim you created the core library
--
-- By using OSGL, you agree to these terms.
-- Full license available in the LICENSE file
------------------------------------------------------------

local Draw = script.Parent.Parent
local OSGL = Draw.Parent
local types = require(OSGL.types)

local readu32 = buffer.readu32
local writeu32 = buffer.writeu32

return function<T>(alphaMode: (a: types.Color, b: types.Color) -> types.Color)
    return function(self: types.DrawableObject<T>, X: number, Y: number, Color: types.Color)
        local position = (Y * self.width + X) * 4
        local pixel = readu32(self.buffer, position)

        writeu32(self.buffer, position, alphaMode(pixel, Color))
    end
end
