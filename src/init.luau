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

local DrawableObject = script.DrawableObject
local types = require(script.types)

export type Window = types.Window
export type Color = types.Color
export type Texture = types.OSGLTexture
export type Bitmap = types.Bitmap
export type Video = types.Video
export type Font = types.Font

return {
    Window = require(DrawableObject.window),
    Texture = require(DrawableObject.texture),
    Bitmap = require(script.bitmap),
    Enum = require(script.enums),
    Video = require(script.video),
    Font = require(script.font),

    color = require(script.color),
}
