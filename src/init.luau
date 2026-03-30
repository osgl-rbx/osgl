------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
------------------------------------------------------------

local DrawableObject = script.DrawableObject
local types = require(script.types)

export type Window = types.Window
export type Color = types.Color
export type MutableTexture = types.MutableTexture
export type ImmutableTexture = types.ImmutableTexture
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
