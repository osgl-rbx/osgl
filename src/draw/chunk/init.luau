--!optimize 2

------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
------------------------------------------------------------

local OSGL = script.Parent.Parent
local enums = require(OSGL.enums)
local util = require(OSGL.util)
local types = require(OSGL.types)

local chunk = require(script.overwrite)

local blendingModes = enums.BlendingMode
local blendFunctions = util.BLEND_FUNCTIONS

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
