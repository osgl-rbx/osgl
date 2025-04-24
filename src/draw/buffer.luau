--!optimize 2
--!native

------------------------------------------------------------
-- OSGL v1.6.2 - Open-Source Graphical Library
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

return function<T>(object: types.DrawableObject<T>, bfr: buffer, width: number, height: number, x: number, y: number)
    local drawWidth = math.min(width, object.width - x)
    local drawHeight = math.min(height, object.height - y)

    local targetBuffer = object.buffer
    local sourceBuffer = bfr
    local targetSize = width * 4

    local targetOffset = (y * object.width + x) * 4
    local sourceOffset = 0

    for y = 0, drawHeight - 1 do
        buffer.copy(
            targetBuffer,
            targetOffset + y * targetSize,
            sourceBuffer,
            sourceOffset + y * targetSize,
            drawWidth * 4
        )
    end
end
