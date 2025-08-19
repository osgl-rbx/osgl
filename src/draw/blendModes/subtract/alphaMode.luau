--!optimize 2

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
local floor = math.floor
local lerp = math.lerp

return function(color1: types.Color, color2: types.Color)
    local invertedAlpha = (255 - a(color2)) / 255
    
    return new(
        floor(lerp(clamp(r(color1) - r(color2), 0, 255), r(color1), invertedAlpha)),
        floor(lerp(clamp(g(color1) - g(color2), 0, 255), g(color1), invertedAlpha)),
        floor(lerp(clamp(b(color1) - b(color2), 0, 255), b(color1), invertedAlpha)),
        255
    )
end
