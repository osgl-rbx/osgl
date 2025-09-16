local Reader = script.ImageReader.Reader

local ImageReader = require(script.ImageReader)
local ReaderModule = require(Reader)
local Bmp = require(Reader.Bmp)
local Png = require(Reader.Png)
local Tga = require(Reader.Tga)

export type Decoder<T> = ReaderModule.Codec<T>
export type Bmp = Bmp.BmpHeader
export type Png = Png.PngHeader
export type Tga = Tga.TgaHeader
export type ImageReader<T> = ImageReader.ImageReader<T>

return {
    ImageReader = require(script.ImageReader),
    ImageFormat = require(script.ImageFormat),
}