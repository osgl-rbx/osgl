local ImageFormat = require(script.Parent.Parent.ImageFormat)
local ImageError = require(script.Parent.Parent.ImageError)
local Cursor = require(script.Parent.Parent.Cursor)
local DynamicImageTypes = require(script.Parent.Parent.DynamicImage.types)
local structs = require(script.Parent.structs)

local Reader = script.Parent.Reader
local Bmp = require(Reader.Bmp)
local Png = require(Reader.Png)
local Tga = require(Reader.Tga)
local Jpg = require(Reader.Jpeg)

type ImageResult<T> = ImageError.ImageResult<T>
type ImageFormat = ImageFormat.ImageFormat
type Cursor = Cursor.Cursor
export type ReadableData = buffer | string

export type HeaderTypes = {
    ["BMP"]: Bmp.BmpHeader,
    ["PNG"]: Png.PngHeader,
    ["TGA"]: Tga.TgaHeader,
    ["JPG"]: Jpg.JpgHeader,
}

export type ImageReader<T> = {
	WithGuessedFormat: (self: ImageReader<T>) -> ImageResult<keyof<HeaderTypes>>,

    Decode: (self: ImageReader<T>) -> ImageResult<DynamicImageTypes.DynamicImage<structs.getAppropriateDecoder<T, HeaderTypes>>>,
    IntoDimensions: (self: ImageReader<T>) -> ImageResult<structs.Dimensions>,
	IntoHeader: (self: ImageReader<T>) -> ImageResult<structs.getAppropriateDecoder<T, HeaderTypes>>,

	buffer: buffer,
	format: ImageFormat,
    cursor: Cursor,
}

return nil