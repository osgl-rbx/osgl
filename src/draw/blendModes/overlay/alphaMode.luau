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

function overlayChannel(background: number, pixel: number)
    background /= 255
    pixel /= 255
    local result
    if background < 0.5 then
        result = 2 * background * pixel
    else
        result = 1 - 2 * (1 - background) * (1 - pixel)
    end
    return result * 255
end

return function(color1: types.Color, color2: types.Color)
    local oR = overlayChannel(r(color1), r(color2))
    local oG = overlayChannel(g(color1), g(color2))
    local oB = overlayChannel(b(color1), b(color2))

    local invertedAlpha = (255 - a(color2)) / 255

    return new(
        floor(lerp(oR, r(color1), invertedAlpha)),
        floor(lerp(oG, g(color1), invertedAlpha)),
        floor(lerp(oB, b(color1), invertedAlpha)),
        255
    )
end
