local Reader = require(script.Parent.ImageReader.Reader)
local ImageFormat = require(script.Parent.ImageFormat)
local ImageError = require(script.Parent.ImageError)
local Result = require(script.Parent.Result)
local types = require(script.types)

export type DynamicImage<T> = types.DynamicImage<T>

local DynamicImage = {}

function DynamicImage.Encode<T>(self: DynamicImage<T>, format: ImageFormat.ImageFormat): ImageError.ImageResult<buffer>
    local codecs = Reader.GetCodecs()
    local codec = codecs[format]
    if not codec then
        return Result.err(ImageError.Encoding)
    end

    if not codec.canEncode then
        return Result.err(ImageError.Unsupported)
    end

    return Result.ok(codec.encode(self.width, self.height, self.buffer))
end

return {
    new = function<T>(width: number, height: number, buffer: buffer, header: T): DynamicImage<T>
        local self = table.clone(DynamicImage)
        self.width = width
        self.height = height
        self.buffer = buffer
        self.header = header
        
        return self
    end
}