local Pixel = require(script.pixel)
local Line = require(script.line)
local Rect = require(script.rect)
local Polygon = require(script.polygon)
local Triangle = require(script.triangle)
local Circle = require(script.circle)
local Buffer = require(script.buffer)

local Clear = require(script.clear)

return {
    Pixel = Pixel,
    Line = Line,
    Rectangle = Rect,
    Polygon = Polygon,
    Triangle = Triangle,
    Circle = Circle,
    Buffer = Buffer,

    Clear = Clear,
}