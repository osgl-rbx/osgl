local Reader = script.Parent
local ImageReader = Reader.Parent
local Cursor = require(ImageReader.Parent.Cursor)
local ImageError = require(ImageReader.Parent.ImageError)
local Result = require(ImageReader.Parent.Result)
local ImageReaderStructs = require(ImageReader.structs)
local DynamicImageTypes = require(ImageReader.Parent.DynamicImage.types)
local Decoder = require(script.Decoder)
local util = require(script.Parent.util)
local t = require(script.types)

type Result<T, E> = Result.Result<T, E>
type ImageResult<T> = ImageError.ImageResult<T>
type DynamicImage<T> = DynamicImageTypes.DynamicImage<T>
type Dimensions = ImageReaderStructs.Dimensions
type Cursor = Cursor.Cursor
export type JpgHeader = t.JpgHeader

local Jpg = {
	canEncode = false,
}

function Jpg.getHeader(cursor: Cursor): ImageResult<JpgHeader>
	local s, r = pcall(function(...)
		-- cursor.buffer = util.RemoveFF00(cursor.buffer)
		local isJpeg = Jpg.isFile(cursor)

		if not isJpeg.isOk or isJpeg.isOk and not isJpeg:Unwrap() then
			return Result.err(ImageError.Decoding)
		end

		cursor.position = 0
		cursor:ExpectBytesRaw(0xff, 0xe0)
		cursor:ExpectBytesRaw(0xff, 224)

		local app0Length = util.beToLe16(cursor:ReadU16()) -- Includes these 2 bytes
		cursor:SkipBytes(5) -- Skip "JFIF\0"
		local versionMajor = cursor:ReadByte()
		local versionMinor = cursor:ReadByte()
		local densityUnits = cursor:ReadByte()
		local xDensity = util.beToLe16(cursor:ReadU16())
		local yDensity = util.beToLe16(cursor:ReadU16())
		local thumbWidth = cursor:ReadByte()
		local thumbHeight = cursor:ReadByte()

		local bytesReadSoFar = 16

		if app0Length > bytesReadSoFar then
			cursor:SkipBytes(app0Length - bytesReadSoFar)
		end

		-- Don't use `GetDimensions`!
		local originalPosition = cursor.position
		while true do
			local marker = util.beToLe16(cursor:ReadU16())

			if marker == 0xFFC0 or marker == 0xFFC2 then
				if marker == 0xffc2 then
					return Result.err(ImageError.Unsupported)
				end

				local length = util.beToLe16(cursor:ReadU16())
				local precision = cursor:ReadByte()
				local height = util.beToLe16(cursor:ReadU16())
				local width = util.beToLe16(cursor:ReadU16())
				local componentCount = cursor:ReadByte()
				cursor:SkipBytes((length - 2) - 6)

				cursor.position = originalPosition
				return Result.ok({
					dimensions = {
						width = width,
						height = height,
					},
					componentCount = componentCount,
					precision = precision,
					versionMajor = versionMajor,
					versionMinor = versionMinor,
					density = densityUnits,
					xDensity = xDensity,
					yDensity = yDensity,
					thumbnailWidth = thumbWidth,
					thumbnailHeight = thumbHeight,
				})
			else
				local length = util.beToLe16(cursor:ReadU16())
				cursor:SkipBytes(length - 2)
			end
		end
	end)

	if not s then
		return Result.err(ImageError.Decoding)
	end

	return r
end

function Jpg.getDimensions(cursor: Cursor): ImageResult<Dimensions>
	local s, r = pcall(function(...)
		cursor.position = 4
		local app0Len = util.beToLe16(cursor:ReadU16())
		cursor:SkipBytes(app0Len - 2)

		while true do
			local marker = util.beToLe16(cursor:ReadU16())

			if marker == 0xFFC0 or marker == 0xFFC2 then
				if marker == 0xFFC2 then
					return Result.err(ImageError.Unsupported)
				end

				cursor:SkipBytes(2)
				cursor:SkipBytes(1)

				local height = util.beToLe16(cursor:ReadU16())
				local width = util.beToLe16(cursor:ReadU16())

				return Result.ok({
					width = width,
					height = height,
				})
			else
				local length = util.beToLe16(cursor:ReadU16())
				cursor:SkipBytes(length - 2)
			end
		end
	end)

	if not s then
		return Result.err(ImageError.Decoding)
	end

	return r
end

function Jpg.isFile(cursor: Cursor)
	local s, r = pcall(function(...)
		cursor.position = 6
		return Result.ok(cursor:ExpectBytes("JFIF\0"))
	end)

	if not s then
		return Result.err(ImageError.Decoding)
	end

	return r
end

function Jpg.decode(cursor: Cursor)
	-- TODO: pcall!
	local header = Jpg.getHeader(cursor):Unwrap()
    local s, bfr = pcall(function()
        local by = string.split(buffer.tostring(cursor.buffer), "")
        for i, str in by do
            by[i] = string.byte(str)
        end
        return Decoder.decode(by)
    end)
    
    if s then
        if not bfr.isOk then
            return Result.castSmallToDefault(bfr)
        end

        return Result.ok(header.dimensions.width, header.dimensions.height, bfr.value, header)
    end

	return Result.err(ImageError.Decoding)
end

return Jpg
