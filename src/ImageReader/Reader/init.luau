--!strict

local ImageReader = script.Parent
local ImageFormat = require(ImageReader.Parent.ImageFormat)
local ImageError = require(ImageReader.Parent.ImageError)
local Cursor = require(ImageReader.Parent.Cursor)
local DynamicImageTypes = require(ImageReader.Parent.DynamicImage.types)
local structs = require(script.Parent.structs)

local PNG = require(script.Png)

type ImageResult<T> = ImageError.ImageResult<T>
type ImageFormat = ImageFormat.ImageFormat
type Cursor = Cursor.Cursor
type Dimensions = structs.Dimensions

export type Codec<T> = {
    canEncode: boolean,

    getHeader: (cursor: Cursor) -> ImageResult<T>,
    isFile: (cursor: Cursor) -> ImageResult<boolean>,
    getDimensions: (cursor: Cursor) -> ImageResult<Dimensions>,
    decode: (cursor: Cursor) -> DynamicImageTypes.DynamicImage<T>,
    encode: ((width: number, height: number, buffer: buffer) -> ImageResult<buffer>)?
}

export type PNG = PNG.PngHeader

local CODECS = {
    [ImageFormat.BMP] = require(script.Bmp),
    [ImageFormat.PNG] = require(script.Png),
    [ImageFormat.TGA] = require(script.Tga),
    [ImageFormat.JPG] = require(script.Jpeg),
}:: {[number]: Codec<any>}

return {
    GetCodec = function<T>(format: ImageFormat)
        return CODECS[format]
    end,

    GetCodecs = function()
        return CODECS
    end
}