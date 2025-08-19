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

local r = color.r
local g = color.g
local b = color.b
local a = color.a
local new = color.new

local lerp = math.lerp

return function(color1: types.Color, color2: types.Color)
    local normalised = a(color2) / 255

    if normalised == 0 then
        return color1
    elseif normalised == 1 then
        return color2
    else
        return new(
            lerp(r(color1), r(color2), normalised),
            lerp(g(color1), g(color2), normalised),
            lerp(b(color1), b(color2), normalised),
            255
        )
    end
end
