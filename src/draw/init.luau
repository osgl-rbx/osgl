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

local Pixel = require(script.pixel)
local PixelIndex = require(script.pixelIndex)
local Line = require(script.line)
local Rect = require(script.rect)
local Polygon = require(script.polygon)
local Triangle = require(script.triangle)
local Circle = require(script.circle)
local Buffer = require(script.buffer)
local FloodFill = require(script.floodFill)

local Clear = require(script.clear)
local Chunk = require(script.chunk)

return {
    Pixel = Pixel,
    PixelIndex = PixelIndex,
    Line = Line,
    Rectangle = Rect,
    Polygon = Polygon,
    Triangle = Triangle,
    Circle = Circle,
    Buffer = Buffer,
    FloodFill = FloodFill,

    Clear = Clear,
    Chunk = Chunk,
}
