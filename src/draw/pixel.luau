--!optimize 2
--!native

------------------------------------------------------------
-- OSGL v1.6b - Open-Source Graphical Library
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

local Draw = script.Parent
local OSGL = Draw.Parent
local types = require(OSGL.types)

return function<T>(self: types.DrawableObject<T>, X: number, Y: number, Color: types.Color)
    buffer.writeu32(self.buffer, (Y * self.width + X) * 4, Color)
end
