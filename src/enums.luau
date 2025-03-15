local WindowError = {
    InvalidCreationInstance = 0 :: WindowError,
    WindowDimensionsOutOfBounds = 1 :: WindowError,
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

local enums = {
    WindowError = WindowError :: typeof(WindowError),
    DrawableObjectError = DrawableObjectError :: typeof(DrawableObjectError),
    TextureError = TextureError :: typeof(TextureError),
}

export type WindowError = number
export type DrawableObjectError = number
export type TextureError = number
export type OEnum = typeof(enums)

return enums :: OEnum