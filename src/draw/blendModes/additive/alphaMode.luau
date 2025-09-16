--!optimize 2

------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
------------------------------------------------------------

local Draw = script.Parent.Parent.Parent
local OSGL = Draw.Parent
local types = require(OSGL.types)
local color = require(OSGL.color)
local normal = require(script.Parent.Parent.normal.alphaMode)

local r = color.r
local g = color.g
local b = color.b
local a = color.a
local new = color.new

local clamp = math.clamp

return function(color1: types.Color, color2: types.Color)
    local alpha = a(color2) / 255

    return normal(
        color1,
        new(
            clamp(r(color1) + r(color2) * alpha, 0, 255),
            clamp(g(color1) + g(color2) * alpha, 0, 255),
            clamp(b(color1) + b(color2) * alpha, 0, 255)
        )
    )
end
