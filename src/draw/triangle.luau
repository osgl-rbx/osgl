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
local fillPolygon = require(draw.polygon)

return function<T>(object: types.DrawableObject<T>, x1: number, y1: number, x2: number, y2: number, x3: number, y3: number, fill: types.Color?, stroke: types.Color?, strokeThickness: number?)
    fill = fill or color.BLACK
    stroke = stroke or color.TRANSPARENT
    strokeThickness = strokeThickness or 0

    -- [saaawdust]: Somehow this is faster than
    --              an optimised triangle rasterizer.
    --              Use this implementation until something
    --              faster is found.
    fillPolygon(object, {
        { x1, y1 },
        { x2, y2 },
        { x3, y3 },
    }, fill, stroke, strokeThickness)
end
