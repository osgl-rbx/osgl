--!optimize 2

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
local enums = require(OSGL.enums)
local util = require(OSGL.util)
local types = require(OSGL.types)

local blendingModes = enums.BlendingMode
local blendFunctions = util.BLEND_FUNCTIONS

local function chunk<T>(self: types.DrawableObject<T>, x1: number, y1: number, x2: number, y2: number, color: types.Color)
    local sizeX = self.width
    local startIndex = (y1 * sizeX + x1) * 4
    local endIndex = (y2 * sizeX + x2) * 4

    local bufferLength = endIndex - startIndex
    local currentSize = 4
    local numCopies = math.ceil(math.log(bufferLength / 4, 2))

    buffer.writeu32(self.buffer, startIndex, color)

    for _ = 1, numCopies do
        local copySize = math.min(currentSize, bufferLength - currentSize)

        buffer.copy(self.buffer, startIndex + currentSize, self.buffer, startIndex, copySize)

        currentSize += copySize
    end
end

return function<T>(self: types.DrawableObject<T>, color: types.Color, x1: number, y1: number, x2: number, y2: number)
    local currentBlendMode = self:GetBlendingMode()

    if currentBlendMode == blendingModes.Overwrite then
        chunk(self, x1, y1, x2, y2, color)
    else
        local alphaFunc = blendFunctions[currentBlendMode]
        local sizeX = self.width
        local regionWidth = x2 - x1
        local regionHeight = y2 - y1
        local startX, startY = x1, y1
        local runColor =  buffer.readu32(self.buffer, (y1 * sizeX + x1) * 4)

        for row = 0, regionHeight do
            startY += row

            for col = 0, regionWidth do
                local pixelIndex = ((y1 + row) * sizeX + (x1 + col)) * 4
                local bg = buffer.readu32(self.buffer, pixelIndex)

                if runColor ~= bg then
                    chunk(self, startX, startY, (x1 + col), y1 + row, alphaFunc(runColor, color))
                    startX = x1 + col
                    runColor = bg
                end
            end
        end
        
        chunk(self, startX, startY, x2, y2, alphaFunc(runColor, color))
    end
end
