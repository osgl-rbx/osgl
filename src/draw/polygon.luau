--!optimize 2
--!native

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
local draw = OSGL.draw
local types = require(OSGL.types)
local color = require(OSGL.color)
local pixel = require(draw.pixel)
local line = require(draw.line)
local chunk = require(draw.chunk)

return function<T>(object: types.DrawableObject<T>, corners: { { number } }, fill: types.Color, strokeColor: types.Color?, strokeWidth: number?)
    -- [saaawdust]: These are temporary, cause
    -- if I calculate it, it takes up
    -- like 10FPS

    fill = fill or color.BLACK
    strokeColor = strokeColor or color.TRANSPARENT
    strokeWidth = strokeWidth or 1

    local sizeX = object.width
    local maxY = object.height

    if strokeColor ~= color.TRANSPARENT and strokeWidth > 0 then
        for i = 1, #corners do
            local p1 = corners[i]
            local p2 = corners[i % #corners + 1]

            line(
                object,
                math.floor(p1[1]),
                math.floor(p1[2]),
                math.floor(p2[1]),
                math.floor(p2[2]),
                strokeWidth,
                strokeColor
            )
        end
    end

    for y = 0, maxY do
        local intersections = {}
        local count = 0

        for i = 1, #corners do
            local p1 = corners[i]
            local p2 = corners[i % #corners + 1]

            if (p1[2] <= y and p2[2] > y) or (p2[2] <= y and p1[2] > y) then
                local t = (y - p1[2]) / (p2[2] - p1[2])
                local intersectX = p1[1] + t * (p2[1] - p1[1])
                count += 1
                intersections[count] = intersectX
            end
        end

        if count < 2 then
            continue
        end

        if count == 2 then
            local x1, x2 = intersections[1], intersections[2]
            if x1 > x2 then
                x1, x2 = x2, x1
            end

            chunk(object, fill, math.max(0, math.floor(x1)), y, math.min(sizeX - 1, math.ceil(x2)), y)

            continue
        end

        table.sort(intersections)

        for i = 1, count - 1, 2 do
            local x1, x2 = intersections[i], intersections[i + 1]
            chunk(object, fill, math.max(0, math.floor(x1)), y, math.min(sizeX - 1, math.ceil(x2)), y)
        end
    end
end
