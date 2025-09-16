local types = require(script.types)
local structs = require(script.structs)

local ImageFormat = require(script.Parent.ImageFormat)
local DataReader = require(script.Parent.DataReader)
local Result = require(script.Parent.Result)
local ImageError = require(script.Parent.ImageError)
local Reader = require(script.Reader)
local Cursor = require(script.Parent.Cursor)
local DynamicImage = require(script.Parent.DynamicImage)

type Result<T, E> = Result.Result<T, E>
type ImageResult<T> = ImageError.ImageResult<T>
type ReadableData = types.ReadableData
type ImageFormat = ImageFormat.ImageFormat
type Cursor = Cursor.Cursor
type Dimensions = structs.Dimensions
export type ImageReader<T> = types.ImageReader<T>

local ImageReader = {}

function ImageReader.IntoDimensions<T>(self: ImageReader<T>): ImageResult<Dimensions>
    return Reader.GetCodec(self.format).getDimensions(self.cursor)
end

function ImageReader.IntoHeader<T>(self: ImageReader<T>)
	return Reader.GetCodec(self.format).getHeader(self.cursor)
end

function ImageReader.Decode<T>(self: ImageReader<T>)

	local res = Reader.GetCodec(self.format).decode(self.cursor)
	if not res.isOk then
		return res
	end

	return Result.ok(DynamicImage.new(res:Unwrap()))
end

function ImageReader.WithGuessedFormat<T>(self: ImageReader<T>)
	local decoders = Reader.GetCodecs()
	local format
	for k, v in decoders do
		local success = v.isFile(self.cursor)

		if not success.isOk then
			return success
		end

		local value = success:Unwrap()

		if value then
			format = k
			continue
		end
	end

	format = format or ImageFormat.UNKNOWN
	self.format = format

	return Result.ok(format)
end

function open(dataStream: ReadableData): ImageReader<"UNKNOWN">
    local bfr = DataReader.convertToBuffer(dataStream)

	local self = table.clone(ImageReader)
	self.format = ImageFormat.UNKNOWN
	self.buffer = bfr
    self.cursor = Cursor.new(bfr)

	return self
end

return {
	open = open,

	withFormat = function(dataStream: ReadableData, format: ImageFormat)
		local newFile = open(dataStream)
        newFile.format = format

        return newFile
	end,
}
