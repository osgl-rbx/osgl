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
local fillPolygon = require(draw.polygon)
local pixel = require(draw.pixel)

return function<T>(object: types.DrawableObject<T>, xPos: number, yPos: number, width: number, height: number, fill: types.Color?, stroke: types.Color?, strokeThickness: number?, rotation: number?)
    fill = fill or color.BLACK
    rotation = rotation or 0
    stroke = stroke or color.TRANSPARENT
    strokeThickness = strokeThickness or 0

    local strokeLength = if stroke ~= color.TRANSPARENT then strokeThickness else 0

    local sizeX, sizeY = object.width, object.height

    local centerX = xPos + width / 2
    local centerY = yPos + height / 2

    if rotation % 90 == 0 then
        local w, h

        if rotation % 180 == 0 then
            w, h = width, height
        else
            w, h = height, width
        end

        w += strokeLength
        h += strokeLength

        for x = 0, w  do
            x += xPos

            if x >= sizeX then
                continue
            end

            for y = 0, h do
                y += yPos
                if y >= sizeY then
                    continue
                end

                local pixelColor = if x > (w + xPos) or y > (h + yPos) then stroke else fill

                pixel(object, x, y, pixelColor)
            end
        end

        return
    end

    local radians = rotation * (math.pi / 180)
    local cosTheta = math.cos(radians)
    local sinTheta = math.sin(radians)

    local function rotatePoint(x, y)
        local relativeX = x - centerX
        local relativeY = y - centerY
        local rotatedX = relativeX * cosTheta - relativeY * sinTheta
        local rotatedY = relativeX * sinTheta + relativeY * cosTheta
        return centerX + rotatedX, centerY + rotatedY
    end

    local x0, y0 = rotatePoint(xPos, yPos)
    local x1, y1 = rotatePoint(xPos + width, yPos)
    local x2, y2 = rotatePoint(xPos + width, yPos + height)
    local x3, y3 = rotatePoint(xPos, yPos + height)


    fillPolygon(object, {
        { x0, y0 },
        { x1, y1 },
        { x2, y2 },
        { x3, y3 },
    }, fill)
end
