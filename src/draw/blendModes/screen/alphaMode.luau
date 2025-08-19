--!optimize 2

------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
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
local multiply = require(script.Parent.Parent.multiply.alphaMode)
local normal = require(script.Parent.Parent.normal.alphaMode)

return function(color1: types.Color, color2: types.Color)
    local inverted1 = color.invert(color1)
    local inverted2 = color.invert(color2)

    local multiplied = multiply(inverted1, inverted2)
    
    return normal(color1, color.invert(multiplied))
end
