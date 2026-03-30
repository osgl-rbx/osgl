------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
------------------------------------------------------------

local OSGL = script.Parent
local result = require(OSGL.result)
local oEnum = require(OSGL.enums)

--[=[
<strong>@OSGL/Result</strong>
<strong>@ThreadSafe</strong>
<em>The result of an operation.</em>
  ]=]
type Result<T, E> = result.Result<T, E>

--[=[
<strong>@OSGL/Window</strong>
<strong>@ThreadSafe</strong>
<em>A type of image.</em>
  ]=]
export type ImageBase = ImageLabel | ImageButton

--[=[
<strong>@OSGL/Window</strong>
<strong>@ThreadSafe</strong>
<em>A type of texture</em>
  ]=]
export type TextureBase = Decal | Texture

--[=[
<strong>@OSGL/Window</strong>
<strong>@ThreadSafe</strong>
<em>An instance that an EditableImage can be created on.</em>
  ]=]
export type Drawable = ImageBase | TextureBase | MeshPart

--[=[
<strong>@OSGL/Color</strong>
<strong>@ThreadSafe</strong>
<em>A color.</em>
  ]=]
export type Color = number

--[=[
<strong>@OSGL/Window</strong>
<strong>@ThreadSafe*</strong>
<em>`WindowCore` represents the internal representation of a `Window`.</em>
  ]=]
type WindowCore = ImmutableSource<WindowCore> & {
    surfaces: {Drawable},
    editableImage: EditableImage,
    targetFPS: number,

    Render: (self: Window) -> (),
    RenderTargetFPS: (self: Window) -> (),
    AddRenderers: (self: Window, ...Drawable) -> (),
    RemoveRenderers: (self: Window, ...Drawable) -> (),
    GetRelativeMousePosition: (self: Window, image: ImageBase) -> (boolean, number, number),
    Destroy: (self: Window) -> (),
}

--[=[
<strong>@OSGL/Window</strong>
<strong>@ThreadSafe*</strong>
<em>A `Window` is an object that can render to `Drawable` surfaces.</em>
  ]=]
export type Window = DrawableObject<WindowCore> & WindowCore

--[=[
<strong>@OSGL/Drawable</strong>
<strong>@ThreadSafe*</strong>
<em>A `DrawableObject` is an object that can be drawn to. It owns a memory buffer for storing pixel data.</em>
  ]=]
export type DrawableObject<T> = DrawingContext<T> & {
    buffer: buffer,

    width: number,
    height: number,
    size: Vector2,

    GetBlendingMode: (self: T) -> oEnum.BlendingMode,
    SetBlendingMode: (self: T, blendingMode: oEnum.BlendingMode) -> nil,
    Resize: (self: T, width: number, height: number) -> Result<nil, oEnum.DrawableObjectError>,
    Serialize: (self: T) -> (buffer, number, number),
    Deserialize: (self: T, buffer: buffer, width: number, height: number) -> Result<nil, oEnum.DrawableObjectError>,
    ReadPixelChecked: (self: T, X: number, Y: number) -> Result<Color, oEnum.DrawableObjectError>,
    ReadPixelUnchecked: (self: T, X: number, Y: number) -> Color,
    TintRegionChecked: (self: T, tint: Color, factor: number, X: number, Y: number, width: number, height: number) -> Result<nil, oEnum.DrawableObjectError>,
    TintRegionUnchecked: (self: T, tint: Color, factor: number, X: number, Y: number, width: number, height: number) -> nil,
    Tint: (self: T, tint: Color, factor: number) -> nil,
    Resample: (self: T, scale: number?) -> nil,
}

--[=[
<strong>@OSGL/Drawable</strong>
<strong>@ThreadSafe*</strong>
<em>A `DrawingContext` contains drawing utilities.</em>
  ]=]
export type DrawingContext<T> = {
    Pixel: (self: T, X: number, Y: number, Color: Color) -> nil,
    PixelIndex: (self: T, Index: number, Color: Color) -> nil,
    Line: (self: T, X1: number, Y1: number, X2: number, Y2: number, Thickness: number, Color: Color?) -> nil,
    Rectangle: (self: T, X: number, Y: number, Width: number, Height: number, Fill: Color?, Stroke: Color?, StrokeThickness: number?, Rotation: number?) -> nil,
    Polygon: (self: T, Corners: { { number } }, Fill: Color, StrokeColor: Color?, StrokeWidth: number?) -> nil,
    Triangle: (self: T, X1: number, Y1: number, X2: number, Y2: number, X3: number, Y3: number, Fill: Color?, Stroke: Color?, StrokeThickness: number?) -> nil,
    Circle: (self: T, CenterX: number, CenterY: number, Radius: number, Fill: Color?, Stroke: Color?, StrokeThickness: number?) -> nil,
    Chunk: (self: T, color: Color, x1: number, y1: number, x2: number, y2: number) -> nil,
    FloodFill: (self: T, x: number, y: number, color: Color) -> nil,
    Buffer: (self: T, Buffer: buffer, Width: number, Height: number, X: number, Y: number) -> nil,

    Clear: (self: T, Color: Color?) -> nil,
}

--[=[
<strong>@OSGL/Texture</strong>
<strong>@ThreadSafe*</strong>
<em>A `BaseRawTexture` is an object that can load or free a `Texture`.</em>
  ]=]
export type BaseRawTexture = {
    version: number,
    get: () -> (number, number, buffer),
    free: () -> ()
}

--[=[
<strong>@OSGL/Texture</strong>
<strong>@ThreadSafe*</strong>
<em>An object which can be explicitly loaded into, or freed from memory.</em>
]=]
type Allocatable<T> = {
    Load: (self: T) -> (),
    Free: (self: T) -> (),
}

--[=[
<strong>@OSGL/Texture</strong>
<strong>@ThreadSafe*</strong>
<em>A texture which cannot be edited.</em>
]=]
export type ImmutableTexture = Content

--[=[
<strong>@OSGL/Texture</strong>
<strong>@ThreadSafe*</strong>
<em>A type that allows `T` to be converted into an `ImmutableTexture`</em>
]=]
type ImmutableSource<T> = {
    AsImmutable: (self: T) -> Result<ImmutableTexture, oEnum.TextureError>
}

--[=[
<strong>@OSGL/Texture</strong>
<strong>@ThreadSafe*</strong>
<em>The internal representation of a texture which can be edited.</em>
]=]
type MutableTextureCapabilities = ImmutableSource<MutableTexture>

--[=[
<strong>@OSGL/Texture</strong>
<strong>@ThreadSafe*</strong>
<em>A texture which can be edited.</em>
]=]
export type MutableTexture = DrawableObject<MutableTextureCapabilities> & MutableTextureCapabilities

--[=[
<strong>@OSGL/Texture</strong>
<strong>@ThreadSafe*</strong>
<em>A texture that may or may not be loaded.</em>
  ]=]
export type RawTexture = ModuleScript | BaseRawTexture

--[=[
<strong>@OSGL/Bitmap</strong>
<strong>@ThreadSafe*</strong>
<em>A `Bitmap` is a `MutableTexture` with a varying amount of channels.</em>
  ]=]
export type Bitmap = {
    channels: number,
    width: number,
    height: number,
    buffer: buffer,
    Read: (self: Bitmap, X: number, Y: number, channel: number?) -> number,
    Write: (self: Bitmap, X: number, Y: number, channel: number, value: number) -> nil,
} & Allocatable<Bitmap>

--[=[
<strong>@OSGL/Font</strong>
<strong>@ThreadSafe*</strong>
<em>A `Glyph` is a single letter in a font.</em>
  ]=]
export type Glyph = {
    number | buffer | { number }
}

--[=[
<strong>@OSGL/Font</strong>
<strong>@ThreadSafe*</strong>
<em>`Glyphs` are a map of letters to their corresponding `Glyph`.</em>
  ]=]
export type Glyphs = { [string]: Glyph }

--[=[
<strong>@OSGL/Font</strong>
<strong>@ThreadSafe*</strong>
<em>A `StoredFont` is a `Font` as generated by the OSGL font generator.</em>
  ]=]
export type StoredFont = {
    version: string,
    letters: Glyphs,
    maxHeight: number,
}

--[=[
<strong>@OSGL/Font</strong>
<strong>@ThreadSafe*</strong>
<em>A `Font` can render text to a `DrawableObject`.</em>
  ]=]
export type Font = {
    glyphs: Glyphs,

    spacing: number,
    linePadding: number,

    Draw:<T>(self: Font, object: DrawableObject<T>, text: string, x: number, y: number, color: Color) -> Font,
}

--[=[
<strong>@OSGL/Video</strong>
<strong>@ThreadSafe*</strong>
<em>A `Video` is a collection of frames.</em>
  ]=]
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
