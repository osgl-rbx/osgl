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
local color = require(OSGL.color)
local chunk = require(draw.chunk)

return function<T>(
    object: types.DrawableObject<T>,
    centerX: number, centerY: number, radius: number,
    fill: types.Color?, stroke: types.Color?, strokeThickness: number?
)
    fill = fill or color.BLACK
    stroke = stroke or color.TRANSPARENT
    strokeThickness = strokeThickness or 0

    local sizeX, sizeY = object.width, object.height

    -- Only apply stroke if it's not transparent
    strokeThickness = (stroke ~= color.TRANSPARENT) and strokeThickness or 0

    local radiusSquared = radius * radius
    local totalRadius = radius + strokeThickness
    local strokeSquared = totalRadius * totalRadius

    for dy = -totalRadius, totalRadius do
        local y = centerY + dy
        if y < 0 or y >= sizeY then
            continue
        end

        local dySquared = dy * dy
        local innerX = math.floor(math.sqrt(math.max(radiusSquared - dySquared, 0)))
        local outerX = math.floor(math.sqrt(math.max(strokeSquared - dySquared, 0)))

        local startX = math.clamp(centerX - innerX, 0, sizeX - 1)
        local endX = math.clamp(centerX + innerX, 0, sizeX - 1)
        if endX >= startX then
            chunk(object, fill, startX, y, endX, y)
        end

        if strokeThickness > 0 and outerX > innerX then
            local leftStart = math.clamp(centerX - outerX, 0, sizeX - 1)
            local leftEnd = math.clamp(centerX - innerX - 1, 0, sizeX - 1)
            if leftEnd >= leftStart then
                chunk(object, stroke, leftStart, y, leftEnd,y)
            end

            local rightStart = math.clamp(centerX + innerX + 1, 0, sizeX - 1)
            local rightEnd = math.clamp(centerX + outerX, 0, sizeX - 1)
            if rightEnd >= rightStart then
                chunk(object, stroke, rightStart, y, rightEnd, y)
            end
        end
    end
end
