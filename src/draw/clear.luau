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

local Draw = script.Parent
local OSGL = Draw.Parent
local types = require(OSGL.types)
local color = require(OSGL.color)

return function<T>(self: types.DrawableObject<T>, Color: types.Color)
    local bufferLength = buffer.len(self.buffer)
    local current_size = 4
    local numCopies = math.ceil(math.log(bufferLength / 4, 2))

    buffer.writeu32(self.buffer, 0, Color or color.TRANSPARENT)

    for _ = 1, numCopies do
        local copy_size = math.min(current_size, bufferLength - current_size)
        buffer.copy(self.buffer, current_size, self.buffer, 0, copy_size)

        current_size += copy_size
    end

    return self
end
