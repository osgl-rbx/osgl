--!optimize 2
--!native

------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
------------------------------------------------------------

local OSGL = script.Parent.Parent
local draw = OSGL.draw
local types = require(OSGL.types)
local color = require(OSGL.color)
local chunk = require(draw.chunk)

local floor = math.floor
local clamp = math.clamp
local sqrt = math.sqrt
local max = math.max

return function<T>(
    object: types.DrawableObject<T>,
    centerX: number,
    centerY: number,
    radius: number,
    fill: types.Color?,
    stroke: types.Color?,
    strokeThickness: number?
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
    local maxDy = floor(totalRadius - 0.5)
    local minDy = -maxDy

    for dy = minDy, maxDy do
        local y = centerY + dy
        if y < 0 or y >= sizeY then
            continue
        end

        local dySquared = dy * dy
        local rInner = sqrt(max(radiusSquared - dySquared, 0))
        local rOuter = sqrt(max(strokeSquared - dySquared, 0))

        local innerX = floor(rInner + .0001)
        local outerX = floor(rOuter + .0001)

        -- fill interior
        local startX = clamp(centerX - innerX, 0, sizeX - 1)
        local endX = clamp(centerX + innerX, 0, sizeX - 1)
        if endX >= startX then
            chunk(object, fill, startX, y, endX, y)
        end

        -- stroke
        if strokeThickness > 0 and outerX > innerX then
            -- left stroke
            local leftStart = clamp(centerX - outerX, 0, sizeX - 1)
            local leftEnd = clamp(centerX - innerX, 0, sizeX - 1)
            if leftEnd >= leftStart then
                chunk(object, stroke, leftStart, y, leftEnd, y)
            end

            -- right stroke
            local rightStart = clamp(centerX + innerX, 0, sizeX - 1)
            local rightEnd = clamp(centerX + outerX, 0, sizeX - 1)
            if rightEnd >= rightStart then
                chunk(object, stroke, rightStart, y, rightEnd, y)
            end
        end
    end
end
