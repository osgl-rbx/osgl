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

local OSGL = script.Parent
local types = require(OSGL.types)

local bit32bor = bit32.bor
local bit32lshift = bit32.lshift
local bit32rshift = bit32.rshift
local bit32band = bit32.band

--[=[
    @class Color

    The color class. Handles manipulations of color values.
]=]
local color = {}

--[=[
    Creates a new color value. Values cannot be changed manually and must be changed
    via a function.

    ```lua
    local OSGL = require(path.to.osgl)
    local color = OSGL.color

    -- All other parameters are defaulted
    -- to 0, except for alpha, which is
    -- defaulted to 255.
    local myAwesomeRedColor = color.new(255)
    ```

    @within Color
    @return Color -- Returns a color Value
]=]
--[=[
<strong>@OSGL/Color</strong>
<em>Creates a new RGBA </em><code>Color</code><em>.</em>
  ]=]
function color.new(r: number?, g: number?, b: number?, a: number?): types.Color
    return bit32bor(
        if a then a * 16777216 else 4278190080,
        if b then b * 65536 else 0,
        if g then g * 256 else 0,
        r or 0
    )
end

--[=[
    Creates a new color value with the alpha channel being 255. Values cannot be changed
    manually and must be changed via a function.

    ```lua
    local OSGL = require(path.to.osgl)
    local color = OSGL.color

    -- All other parameters are defaulted
    -- to 0.
    local myAwesomeRedColor = color.newRGB(255)
    ```

    @within Color
    @return Color -- Returns a color Value
]=]
--[=[
<strong>@OSGL/Color</strong>
<em>Creates a new RGBA </em><code>Color</code><em> from an RGB one.</em>
  ]=]
function color.newRGB(r: number?, g: number?, b: number?): types.Color
    return bit32bor(
        color.BLACK,
        if b then b * 65536 else 0,
        if g then g * 256 else 0,
        r or 0
    )
end

--[=[
    Sets the 'r' channel of the color.

    ```lua
    local OSGL = require(path.to.osgl)
    local color = OSGL.color

    local c = color.setR(color.RED, 100)
    print(color.r(c)) -- Ouput:  100
    ```

    For performance boost, if you're creating colors using only 1 or 2 channels, you
    should do:

    ```lua
    local almostRed = color.setR(color.BLACK, 100)
    ```

    @param c Color -- The color to edit
    @param r number -- The new value
    @within Color
    @return number
]=]
--[=[
<strong>@OSGL/Color</strong>
<em>Sets the R channel of a </em><code>Color</code><em>.</em>
  ]=]
function color.setR(c: types.Color, r: number): number
    return bit32bor(c, r)
end

--[=[
    Sets the 'g' channel of the color.

    ```lua
    local OSGL = require(path.to.osgl)
    local color = OSGL.color

    local c = color.setG(color.GREEN, 100)
    print(color.g(c)) -- Ouput:  100
    ```

    For performance boost, if you're creating colors using only 1 or 2 channels, you
    should do:

    ```lua
    local almostGreen = color.setG(color.BLACK, 100)
    ```

    @param c Color -- The color to edit
    @param g number -- The new value
    @within Color
    @return number
]=]
--[=[
<strong>@OSGL/Color</strong>
<em>Sets the G channel of a </em><code>Color</code><em>.</em>
  ]=]
function color.setG(c: types.Color, g: number): number
    return bit32bor(c, bit32bor(bit32band(c, 0xFF00FFFF), bit32lshift(g, 8)))
end

--[=[
    Sets the 'b' channel of the color.

    ```lua
    local OSGL = require(path.to.osgl)
    local color = OSGL.color

    local c = color.setB(color.BLUE, 100)
    print(color.b(c)) -- Ouput:  100
    ```

    For performance boost, if you're creating colors using only 1 or 2 channels, you
    should do:

    ```lua
    local almostBlue = color.setB(color.BLACK, 100)
    ```

    @param c Color -- The color to edit
    @param b number -- The new value
    @within Color
    @return number
]=]
--[=[
<strong>@OSGL/Color</strong>
<em>Sets the B channel of a </em><code>Color</code><em>.</em>
  ]=]
function color.setB(c: types.Color, b: number): number
    return bit32bor(bit32band(c, 0xFFFF00FF), bit32lshift(b, 16))
end

--[=[
    Sets the 'a' channel of the color.

    ```lua
    local OSGL = require(path.to.osgl)
    local color = OSGL.color

    local c = color.setA(color.TRANSPARENT, 100)
    print(color.a(c)) -- Ouput:  100
    ```

    For performance boost, if you're creating colors using only 1 or 2 channels, you
    should do:

    ```lua
    local almostBlack = color.setA(color.TRANSPARENT, 100)
    ```

    @param c Color -- The color to edit
    @param a number -- The new value
    @within Color
    @return number
]=]
--[=[
<strong>@OSGL/Color</strong>
<em>Sets the A channel of a </em><code>Color</code><em>.</em>
  ]=]
function color.setA(c: types.Color, a: number): number
    return bit32bor(bit32band(c, 0x00FFFFFF), bit32lshift(a, 24))
end

--[=[
    Reads the value of the color

    ```lua
    local OSGL = require(path.to.osgl)
    local color = OSGL.color

    -- All other parameters are defaulted to 0, except for alpha,
    -- which is defaulted to 255.
    local myAwesomeRedColor = color.new(255)
    print(color.read(myAwesomeRedColor)) -- Output: { 255, 0, 0, 255 }
    ```

    @param rgbaColor Color -- The color to read
    @within Color
    @return number
]=]
--[=[
<strong>@OSGL/Color</strong>
<em>Returns all 4 channels of a </em><code>Color</code><em>.</em>
  ]=]
function color.read(rgbaColor: types.Color): (number, number, number, number)
    return
        color.r(rgbaColor),
        color.g(rgbaColor),
        color.b(rgbaColor),
        color.a(rgbaColor)
end

--[=[
    Reads the 'r' value of the color

    ```lua
    local OSGL = require(path.to.osgl)
    local color = OSGL.color

    -- All other parameters are defaulted to 0, except for alpha,
    -- which is defaulted to 255.
    local myAwesomeRedColor = color.new(255)
    print color.r(myAwesomeRedColor)) -- Ouput:  255
    ```

    @param color Color -- The color to read
    @within Color
    @return number
]=]
--[=[
<strong>@OSGL/Color</strong>
<em>Returns the R channel of a </em><code>Color</code><em>.</em>
  ]=]
function color.r(color: types.Color): number
    return bit32band(color, 0xFF)
end

--[=[
    Reads the 'g' value of the color

    ```lua
    local OSGL = require(path.to.osgl)
    local color = OSGL.color

    -- All other parameters are defaulted to 0, except for alpha,
    -- which is defaulted to 255.
    local myAwesomeRedColor = color.new(255)
    print color.g(myAwesomeRedColor)) -- Ouput:  0
    ```

    @param color Color -- The color to read
    @within Color
    @return number
]=]
--[=[
<strong>@OSGL/Color</strong>
<em>Returns the G channel of a </em><code>Color</code><em>.</em>
  ]=]
function color.g(color: types.Color): number
    return bit32band(bit32rshift(color, 8), 0xFF)
end

--[=[
    Reads the 'b' value of the color

    ```lua
    local OSGL = require(path.to.osgl)
    local color = OSGL.color

    -- All other parameters are defaulted to 0, except for alpha,
    -- which is defaulted to 255.
    local myAwesomeRedColor = color.new(255)
    print color.b(myAwesomeRedColor)) -- Ouput:  0
    ```

    @param color Color -- The color to read
    @within Color
    @return number
]=]
--[=[
<strong>@OSGL/Color</strong>
<em>Returns the B channel of a </em><code>Color</code><em>.</em>
  ]=]
function color.b(color: types.Color): number
    return bit32band(bit32rshift(color, 16), 0xFF)
end

--[=[
    Reads the 'a' value of the color

    ```lua
    local OSGL = require(path.to.osgl)
    local color = OSGL.color

    -- All other parameters are defaulted to 0, except for alpha,
    -- which is defaulted to 255.
    local myAwesomeRedColor = color.new(255)
    print(color.a(myAwesomeRedColor)) -- Ouput:  255
    ```

    @param color Color -- The color to read
    @within Color
    @return number
]=]
--[=[
<strong>@OSGL/Color</strong>
<em>Returns the A channel of a </em><code>Color</code><em>.</em>
  ]=]
function color.a(color: types.Color): number
    return bit32rshift(color, 24)
end

--[=[
<strong>@OSGL/Color</strong>
<em>Creates a </em><code>Color</code><em> from a </em><code>Color3</code><em>.</em>
  ]=]
function color.fromColor3(color3: Color3, a: number?): number
    return color.new(color3.R * 255, color3.G * 255, color3.B * 255, a or 255)
end

--[=[
<strong>@OSGL/Color</strong>
<em>Creates a </em><code>Color</code><em> from a </em><code>Vector3</code><em>.</em>
  ]=]
  function color.fromVector3(vector3: Vector3, a: number?): number
    return color.new(vector3.X * 255, vector3.Y * 255, vector3.Z * 255, a or 255)
end

--[=[
    Tints the color towards the other color using a tint factor. A tint factor of 0
    means `color1` will be returned, while a tint factor of 1 means `color2` will be
    returned.

    ```lua
    local OSGL = require(path.to.osgl)
    local color = OSGL.color

    local whiteTintedRed = color.tint(color.WHITE, color.RED, 0.5)
    ```

    @param color1 Color -- The color to tint
    @param color2 Color -- The tint that will be applied
    @param factor number -- How strong the tint is
    @within Color
    @return number
]=]
--[=[
<strong>@OSGL/Color</strong>
<em>Tints a </em><code>Color</code><em>.</em>
  ]=]
function color.tint(color1: types.Color, color2: types.Color, factor: number)
    if factor == 0 then
        return color1
    elseif factor == 1 then
        return color2
    else
        return color.new(
            math.lerp(color.r(color1), color.r(color2), factor),
            math.lerp(color.g(color1), color.g(color2), factor),
            math.lerp(color.b(color1), color.b(color2), factor),
            math.lerp(color.a(color1), color.a(color2), factor)
        )
    end
end

--- @prop RED Color
--- @within Color
--- A red color
color.RED = color.new(255)

--- @prop GREEN Color
--- @within Color
--- A green color
color.GREEN = color.new(0, 255)

--- @prop BLUE Color
--- @within Color
--- A blue color
color.BLUE = color.new(0, 0, 255)

--- @prop WHITE Color
--- @within Color
--- A white color
color.WHITE = color.new(255, 255, 255)

--- @prop BLACK Color
--- @within Color
--- A black color
color.BLACK = color.new(0, 0, 0, 255)

--- @prop YELLOW Color
--- @within Color
--- A yellow color
color.YELLOW = color.new(255, 255)

--- @prop MAGENTA Color
--- @within Color
--- A magenta color
color.MAGENTA = color.new(255, 0, 255)

--- @prop CYAN Color
--- @within Color
--- A cyan color
color.CYAN = color.new(0, 255, 255)

--- @prop TRANSPARENT Color
--- @within Color
--- A completely transparent color
color.TRANSPARENT = color.new(0, 0, 0, 0)

return color
