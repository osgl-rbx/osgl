------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
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

local BlendingMode = {
    Overwrite = 9 :: BlendingMode,
    Normal = 10 :: BlendingMode,
    Additive = 11 :: BlendingMode,
    Multiply = 12 :: BlendingMode,
    Screen = 13 :: BlendingMode,
    Overlay = 14 :: BlendingMode,
    Subtract = 15 :: BlendingMode,
}

local enums = {
    WindowError = WindowError :: typeof(WindowError),
    DrawableObjectError = DrawableObjectError :: typeof(DrawableObjectError),
    TextureError = TextureError :: typeof(TextureError),
    FontError = FontError :: typeof(FontError),
    BlendingMode = BlendingMode :: typeof(BlendingMode)
}

export type WindowError = number
export type DrawableObjectError = number
export type TextureError = number
export type FontError = number
export type BlendingMode = number
export type OEnum = typeof(enums)

return enums :: OEnum
