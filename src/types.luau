------------------------------------------------------------
-- OSGL v1.6b - Open-Source Graphical Library
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
local result = require(OSGL.result)
local oEnum = require(OSGL.enums)

type Result<T, E> = result.Result<T, E>

export type ImageBase = ImageLabel | ImageButton
export type TextureBase = Decal | Texture
export type Drawable = ImageBase | TextureBase
export type Color = number

export type Window = DrawableObject<Window> & {
    surfaces: {Drawable},
    editableImage: EditableImage,
    targetFPS: number,

    Render: (self: Window) -> (),
    RenderTargetFPS: (self: Window) -> (),
    AddRenderers: (self: Window, ...Drawable) -> (),
    RemoveRenderers: (self: Window, ...Drawable) -> (),
    GetRelativeMousePosition: (self: Window, image: ImageBase) -> (boolean, number, number)
}

export type DrawableObject<T> = DrawingContext<DrawableObject<T>> & {
    buffer: buffer,

    width: number,
    height: number,
    size: Vector2,

    Resize: (self: DrawableObject<T>, width: number, height: number) -> Result<nil, oEnum.DrawableObjectError>,
    Serialize: (self: DrawableObject<T>) -> (buffer, number, number),
    Deserialize: (self: DrawableObject<T>, buffer: buffer, width: number, height: number) -> Result<nil, oEnum.DrawableObjectError>,
    ReadPixelChecked: (self: DrawableObject<T>, X: number, Y: number) -> Result<Color, oEnum.DrawableObjectError>,
    ReadPixelUnchecked: (self: DrawableObject<T>, X: number, Y: number) -> Color,
    TintRegionChecked: (self: DrawableObject<T>, tint: Color, factor: number, X: number, Y: number, width: number, height: number) -> Result<nil, oEnum.DrawableObjectError>,
    TintRegionUnchecked: (self: DrawableObject<T>, tint: Color, factor: number, X: number, Y: number, width: number, height: number) -> nil,
    Tint: (self: DrawableObject<T>, tint: Color, factor: number) -> nil,
    Resample: (self: DrawableObject<T>, scale: number?) -> nil,
}

export type DrawingContext<T> = {
    Pixel: (self: T, X: number, Y: number, Color: Color) -> nil,
    Line: (self: T, X1: number, Y1: number, X2: number, Y2: number, Thickness: number, Color: Color?) -> nil,
    Rectangle: (self: T, X: number, Y: number, Width: number, Height: number, Fill: Color?, Stroke: Color?, StrokeThickness: number?, Rotation: number?) -> nil,
    Polygon: (self: T, Corners: { { number } }, Fill: Color, StrokeColor: Color?, StrokeWidth: number?) -> nil,
    Triangle: (self: T, X1: number, Y1: number, X2: number, Y2: number, X3: number, Y3: number, Fill: Color?, Stroke: Color?, StrokeThickness: number?) -> nil,
    Circle: (self: T, CenterX: number, CenterY: number, Radius: number, Fill: Color?, Stroke: Color?, StrokeThickness: number?, Rotation: number?) -> nil,
    Buffer: (self: T, Buffer: buffer, Width: number, Height: number, X: number, Y: number) -> nil,

    Clear: (self: T, Color: Color?) -> nil,
}

export type BaseRawTexture<T> = {
    version: string & T,
    width: number,
    height: number,
    pixels: buffer
}

export type BaseUnloadedTexture = BaseRawTexture<"1.6b">
export type Texture = DrawableObject<Texture>
export type RawTexture = ModuleScript | BaseUnloadedTexture
export type Bitmap = {
    channels: number,
    width: number,
    height: number,
    buffer: buffer,
    Read: (self: Bitmap, x: number, y: number, channel: number?) -> number
}

export type Glyph = {
    number | buffer | { number }
}
export type Glyphs = { [string]: Glyph }
export type StoredFont = {
    version: string,
    letters: Glyphs,
    maxHeight: number,
}
export type Font = {
    glyphs: Glyphs,

    spacing: number,
    linePadding: number,

    Draw:<T>(self: Font, object: DrawableObject<T>, text: string, x: number, y: number, color: Color) -> Font,
}

export type Video = {
    width: number,
    height: number,
    playbackFrame: number,
    frameRate: number,
    playing: boolean,
    loop: boolean,
    frames: {buffer},

    PlaySync: (self: Video, callback: (width: number, height: number, buffer: buffer) -> ()) -> Video,
    PlayAsync: (self: Video, callback: (width: number, height: number, buffer: buffer) -> ()) -> Video,

    Stop: (self: Video) -> Video,

    GetFrame: (self: Video, frame: number) -> (buffer, number, number),
    GetBufferOfFrame: (self: Video, frame: number) -> buffer,

    Previous: (self: Video) -> Video,
    Next: (self: Video) -> Video,
}

return nil
