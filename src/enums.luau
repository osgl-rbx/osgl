------------------------------------------------------------
-- OSGL v1.6.15 - Open-Source Graphical Library
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

local WindowError = {
    InvalidCreationInstance = 0 :: WindowError,
    WindowDimensionsOutOfBounds = 1 :: WindowError,
    APINotEnabled = 8 :: WindowError,
}

local DrawableObjectError = {
    NotEnoughMemory = 2 :: DrawableObjectError,
    ResizeOutOfBounds = 3 :: DrawableObjectError,
    BadBufferSize = 4 :: DrawableObjectError,
    OutOfBounds = 5 :: DrawableObjectError,
}

local TextureError = {
    BadInput = 6 :: TextureError,
}

local FontError = {
    BadInput = 7 :: TextureError,
}

local enums = {
    WindowError = WindowError :: typeof(WindowError),
    DrawableObjectError = DrawableObjectError :: typeof(DrawableObjectError),
    TextureError = TextureError :: typeof(TextureError),
    FontError = FontError :: typeof(FontError),
}

export type WindowError = number
export type DrawableObjectError = number
export type TextureError = number
export type FontError = number
export type OEnum = typeof(enums)

return enums :: OEnum
