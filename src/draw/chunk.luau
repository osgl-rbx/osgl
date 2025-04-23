--!optimize 2

------------------------------------------------------------
-- OSGL v1.6.15 - Open-Source Graphical Library
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
local types = require(OSGL.types)

return function<T>(
    self: types.DrawableObject<T>,
    color: types.Color,
    x1: number,
    y1: number,
    x2: number,
    y2: number
)
    local sizeX = self.width
    local startIndex = (y1 * sizeX + x1) * 4
    local endIndex = (y2 * sizeX + x2) * 4

    local bufferLength = endIndex - startIndex
    local currentSize = 4
    local numCopies = math.ceil(math.log(bufferLength / 4, 2))

    buffer.writeu32(self.buffer, startIndex, color)

    for _ = 1, numCopies do
        local copySize = math.min(currentSize, bufferLength - currentSize)

        buffer.copy(
            self.buffer,
            startIndex + currentSize,
            self.buffer,
            startIndex,
            copySize
        )

        currentSize += copySize
    end
end
