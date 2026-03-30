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
    ImmutableCreationError = 9 :: TextureError
}

--[=[
<strong>@OSGL/Font</strong>
<strong>@ThreadSafe</strong>
<em>An error relating to the `Font` class.</em>
  ]=]
local FontError = {
    BadInput = 7 :: FontError,
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

--[=[
<strong>@OSGL/Window</strong>
<strong>@ThreadSafe</strong>
<em>An error relating to the `Window` class.</em>
  ]=]
export type WindowError = number

--[=[
<strong>@OSGL/Drawable</strong>
<strong>@ThreadSafe</strong>
<em>An error relating to the `DrawableObject` class.</em>
  ]=]
export type DrawableObjectError = number

--[=[
<strong>@OSGL/Texture</strong>
<strong>@ThreadSafe</strong>
<em>An error relating to the `Texture` superclass.</em>
  ]=]
export type TextureError = number

--[=[
<strong>@OSGL/Font</strong>
<strong>@ThreadSafe</strong>
<em>An error relating to the `Font` class.</em>
  ]=]
export type FontError = number

--[=[
<strong>@OSGL/Drawable</strong>
<strong>@ThreadSafe</strong>
<em>A blending mode defines how an object's colors interact with the colors of the background behind it.</em>
  ]=]
export type BlendingMode = number
export type OEnum = typeof(enums)

return enums :: OEnum
