local Reader = script.Parent
local ImageReader = Reader.Parent
local Cursor = require(ImageReader.Parent.Cursor)
local ImageError = require(ImageReader.Parent.ImageError)
local Result = require(ImageReader.Parent.Result)
local ImageReaderStructs = require(ImageReader.structs)
local IDHR = require(script.IDHR)
local Deflate = require(script.Deflate)
local Unfilter = require(script.Unfilter)
local Interlacing = require(script.Interlacing)
local ConvertBpp = require(script.BppConvert)
local util = require(script.Parent.util)

local beToLe32 = util.beToLe32

local Png = {
	canEncode = false,
}

type Result<T, E> = Result.Result<T, E>
type SmallResult<T, E> = Result.SmallResult<T, E>
type ImageResult<T> = ImageError.ImageResult<T>
type Dimensions = ImageReaderStructs.Dimensions
type Cursor = Cursor.Cursor
export type PngHeader = {
	dimensions: Dimensions,
	bitDepth: number,
	colorType: number,
	interlaced: boolean,
	compression: number,
	filtering: number,
	crc: number,
	metadata: {
		[string]: number,
	},
}

function Png.getHeader(cursor: Cursor)
	cursor.position = 0

	local s, r = pcall(function(...)
		local isPng = Png.isFile(cursor)
		if not isPng then
			return isPng
		end

		return Result.ok(IDHR(Png, cursor))
	end)

	if s then
		return r
	end

	local words = string.split(r, " ")
	return Result.err(tonumber(words[#words]))
end

function Png.isFile(cursor: Cursor)
	cursor.position = 0

	local s, r = pcall(cursor.ExpectBytesRaw, cursor, 137, 80, 78, 71, 13, 10, 26, 10)
	if s then
		return Result.ok(r)
	else
		local words = string.split(r, " ")
		return Result.err(tonumber(words[#words]))
	end
end

function Png.getDimensions(cursor: Cursor)
	cursor.position = 16

	local s, r = pcall(function(...)
		local width = beToLe32(cursor:ReadU32())
		local height = beToLe32(cursor:ReadU32())

		return Result.ok({
			width = width,
			height = height,
		})
	end)

	if s then
		return r
	end

	local words = string.split(r, " ")
	return Result.err(tonumber(words[#words]))
end

function getBytesPerPixel(colorType: number)
	if colorType == 0 or colorType == 3 then
		return 1
	elseif colorType == 4 then
		return 2
	elseif colorType == 2 then
		return 3
	elseif colorType == 6 then
		return 4
	else
		return 0
	end
end

function Png.decode(cursor: Cursor)
	local header: PngHeader = Png.getHeader(cursor):Unwrap()
	local chunks = {}
	local fileData = {
		isReading = true,
		zlibstream = "",
		metadata = {},
	}

	local s = pcall(function(...)
		while fileData.isReading do
			local len = beToLe32(cursor:ReadU32())
			local chunkType = cursor:ReadString(4)

			local chunkCursor, crc

			if len > 0 then
				chunkCursor = cursor:Fork(len)
				crc = beToLe32(cursor:ReadU32())
			end

			local chunkData = {
				length = len,
				header = chunkType,
				chunkCursor = chunkCursor,
				crc = crc,
			}

			local handler = script.Chunks:FindFirstChild(chunkType)

			if handler then
				handler = require(handler)
				handler(chunkCursor, fileData, chunkData)
			end

			table.insert(chunks, chunkData)
		end
	end)

	if not s then
		return Result.err(ImageError.Decoding)
	end

	header.metadata = fileData.metadata

	local bitDepth = header.bitDepth
	local colorType = header.colorType
	local channels = getBytesPerPixel(colorType)
	local bppRaw = channels * (bitDepth / 8)
	local bpp = math.max(1, bppRaw)

	local dimensions = header.dimensions
	local width, height = dimensions.width, dimensions.height
	local success, response = pcall(function()
		local interlaced = header.interlaced
		local result = buffer.create(
			if interlaced then Interlacing.calculateSize(width, height, bpp) else (height * (1 + width * bpp))
		)

		local offset = 0
		local index = 1
		local strLen = string.len(fileData.zlibstream)

		local function ensureCapacity(needed)
			if offset + needed <= buffer.len(result) then
				return
			end

			local newBuffer = buffer.create(buffer.len(result) + needed)
			buffer.copy(newBuffer, 0, result, 0, offset)
			result = newBuffer
		end

		Deflate:InflateZlib({
			Input = {
				ReadByte = function()
					if index > strLen then
						return
					end

					local result = string.sub(fileData.zlibstream, index, index)
					index += 1

					return string.byte(result)
				end,
			},

			Output = not interlaced and function(byte)
				buffer.writeu8(result, offset, byte)
				offset += 1
			end or function(byte)
				ensureCapacity(1)
				buffer.writeu8(result, offset, byte)
				offset += 1
			end,
		})

		return result
	end)

	if not success then
		return Result.err(ImageError.Decoding)
	end

	fileData.zlibstream = nil

	local bitmap = buffer.create(width * height * 4)

	-- Is this image interlaced?
	if header.interlaced then
		-- "un-interlace" the image and put it in bitmap
		s = pcall(function(...)
			bitmap = Interlacing.deinterlaceAdam7(response, width, height, bpp, fileData)
		end)

		if not s then
			return Result.err(ImageError.Decoding)
		end

		return Result.ok(width, height, bitmap, header)
	end

	-- Unfilter & write
	-- Preprocess all scanlines and convert them to RGBA

	local newCursor = Cursor.new(response)
	local scanlineWidth = math.ceil(width * bppRaw)
	local protectAlpha = bpp ~= 4

	s = pcall(function(...)
		for row = 0, height - 1 do
			local filterType = newCursor:ReadByte()
			local scanline = newCursor:ReadByteCollection(scanlineWidth)
			if protectAlpha then
				local newScan = buffer.create(width * 4)
				if bppRaw == 0.5 then
					ConvertBpp.fourBit(fileData, scanlineWidth, scanline, newScan)
				elseif bppRaw == 0.25 then
					ConvertBpp.twoBit(fileData, width, scanlineWidth, scanline, newScan)
				elseif bppRaw == 0.125 then
					ConvertBpp.oneBit(fileData, scanlineWidth, width, scanline, newScan)
				else
					ConvertBpp.trueColor(fileData, width, bpp, scanline, newScan)
				end

				scanline = newScan
			end

			Unfilter.unfilter(filterType, row, scanline, bitmap, width, height, protectAlpha)
		end
	end)

	if not s then
		return Result.err(ImageError.Decoding)
	end

	return Result.ok(width, height, bitmap, header)
end

return Png
