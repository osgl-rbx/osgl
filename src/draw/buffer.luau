--!optimize 2
--!native

------------------------------------------------------------
-- OSGL v1.6.1 - Open-Source Graphical Library
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

local OSGL = script.Parent.Parent
local draw = OSGL.draw
local types = require(OSGL.types)
local pixel = require(draw.pixel)

return function<T>(object: types.DrawableObject<T>, bfr: buffer, width: number, height: number, x: number, y: number)
    for i = 0, width - 1 do
        local pixelX = x + i
        for j = 0, height - 1 do
            local pixelY = y + j

            local col = buffer.readu32(bfr, (y * width + x) * 4)
            pixel(object, pixelX, pixelY, col)
        end
    end
end
