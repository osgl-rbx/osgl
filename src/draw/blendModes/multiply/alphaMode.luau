--!optimize 2

------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
------------------------------------------------------------

local Draw = script.Parent.Parent.Parent
local OSGL = Draw.Parent
local types = require(OSGL.types)
local color = require(OSGL.color)

local r = color.r
local g = color.g
local b = color.b
local a = color.a
local new = color.new

local lerp = math.lerp
local floor = math.floor

return function(color1: types.Color, color2: types.Color)
    local mulR = floor((r(color1) * r(color2)) / 255)
    local mulG = floor((g(color1) * g(color2)) / 255)
    local mulB = floor((b(color1) * b(color2)) / 255)

    local invertedAlpha = (255 - a(color2)) / 255

    return new(
        floor(lerp(mulR, r(color1), invertedAlpha)),
        floor(lerp(mulG, g(color1), invertedAlpha)),
        floor(lerp(mulB, b(color1), invertedAlpha)),
        255
    )
end
