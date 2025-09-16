local Reader = script.Parent
local ImageReader = Reader.Parent
local Cursor = require(ImageReader.Parent.Cursor)
local ImageError = require(ImageReader.Parent.ImageError)
local Result = require(ImageReader.Parent.Result)
local ImageReaderStructs = require(ImageReader.structs)
local DynamicImageTypes = require(ImageReader.Parent.DynamicImage.types)
local util = require(script.Parent.util)

local createRGBAColor = util.createRGBAColor

local Bmp = {
    canEncode = true
}

type Result<T, E> = Result.Result<T, E>
type ImageResult<T> = ImageError.ImageResult<T>
type DynamicImage<T> = DynamicImageTypes.DynamicImage<T>
type Dimensions = ImageReaderStructs.Dimensions
type Cursor = Cursor.Cursor
export type BmpHeader = {
	bytes: number,
	pixelDataOffset: number,
	headerSize: number,
	dimensions: Dimensions,
	colorDepth: number,
	compressionType: number,
	imageSizeBytes: number,
	xPixelsPerMeter: number,
	yPixelsPerMeter: number,
	numberOfColors: number,
	importantColors: number,
}

function Bmp.getHeader(cursor: Cursor): ImageResult<BmpHeader>
	cursor.position = 0

	local s, r = pcall(function(...)
        local isBmp = Bmp.isFile(cursor)
        if not isBmp.isOk or isBmp.isOk and not isBmp:Unwrap() then
            return Result.err(ImageError.Decoding)
        end

        local bytes = cursor:ReadU32()

        -- 2 reserve slots
        cursor:SkipBytes(4)


        local pixelDataOffset = cursor:ReadU32()
        local headerSize = cursor:ReadU32()

        local dimensions = Bmp.getDimensions(cursor)
        if not dimensions.isOk then
            return dimensions -- Full result, no need to cast!
        end

        -- Colour panes
        cursor:ExpectBytes(string.char(1) .. string.char(0))

        local colorDepth = cursor:ReadU16()
        local compression = cursor:ReadU32()
        local imageSize = cursor:ReadU32()
        local xPPM = cursor:ReadU32()
        local yPPM = cursor:ReadU32()
        local numColors = cursor:ReadU32()
        local importantColors = cursor:ReadU32()

        return Result.ok({
            bytes = bytes,
            pixelDataOffset = pixelDataOffset,
            headerSize = headerSize,
            dimensions = dimensions:Unwrap(),
            colorDepth = colorDepth,
            compressionType = compression,
            imageSizeBytes = imageSize,
            xPixelsPerMeter = xPPM,
            yPixelsPerMeter = yPPM,
            numberOfColors = numColors,
            importantColors = importantColors,
        })
    end)

    if s then
        return r
    end

    local words = string.split(r, " ")
    return Result.err(tonumber(words[#words]))
end

function Bmp.isFile(cursor: Cursor): ImageResult<boolean>
    cursor.position = 0

    local s, r = pcall(cursor.ExpectBytes, cursor, "BM")
    if s then
        return Result.ok(r)
    else
        local words = string.split(r, " ")
        return Result.err(tonumber(words[#words]))
    end
end

function Bmp.getDimensions(cursor: Cursor): ImageResult<Dimensions>
	cursor.position = 18

	local s, r = pcall(function(...)
        local width = cursor:ReadI32()
        local height = cursor:ReadI32()

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

function decode8bit(width: number, height: number, pixels: buffer, palette: buffer, cursor: Cursor)
	for y = 0, height - 1 do
		for x = 0, width - 1 do
			local index = cursor:ReadByte()

			local pixelOffset = (y * width + x) * 4
            buffer.writeu32(pixels, pixelOffset, buffer.readu32(palette, index * 4))
		end
		local padding = (4 - (width % 4)) % 4
		cursor:SkipBytes(padding)
	end

	return Result.okSmall()
end

function decode4bit(width: number, height: number, pixels: buffer, palette: buffer, cursor: Cursor)
    for y = 0, height - 1 do
        for x = 0, width - 1, 2 do  -- 2 because of 2 pixels per byte
            local byte = cursor:ReadByte()

            
            local index1 = bit32.band(bit32.rshift(byte, 4), 0x0F)
            local pixelOffset1 = (y * width + x) * 4
            buffer.writeu32(pixels, pixelOffset1, buffer.readu32(palette, index1 * 4))   

            -- Low nibble
            if x + 1 < width then
                local index2 = bit32.band(byte, 0x0F)
                local pixelOffset2 = (y * width + x + 1) * 4
                buffer.writeu32(pixels, pixelOffset2, buffer.readu32(palette, index2 * 4))   
            end
        end
        
        -- Padding
        local bytesRead = math.ceil(width / 2)
        local padding = (4 - (bytesRead % 4)) % 4
        cursor:SkipBytes(padding)
    end
    return Result.okSmall()
end

function decode1bit(width: number, height: number, pixels: buffer, palette: buffer, cursor: Cursor)
    for y = 0, height - 1 do
        local bitsRemaining = 0
        local currentByte = 0

        for x = 0, width - 1 do
            if bitsRemaining == 0 then
                currentByte = cursor:ReadByte()
                bitsRemaining = 8
            end

            local index = bit32.band(bit32.rshift(currentByte, bitsRemaining - 1), 1)
            bitsRemaining = bitsRemaining - 1

            local pixelOffset = (y * width + x) * 4
            buffer.writeu32(pixels, pixelOffset, buffer.readu32(palette, index * 4))                                -- A
        end

        local bytesRead = math.ceil(width / 8)
        local padding = (4 - (bytesRead % 4)) % 4
        cursor:SkipBytes(padding)
    end

    return Result.okSmall()
end

function decode16bit(width: number, height: number, pixels: buffer, cursor: Cursor, header: BmpHeader)
    for y = 0, height - 1 do
        for x = 0, width - 1 do
            local pixel = cursor:ReadU16()

            local r = bit32.band(bit32.rshift(pixel, 10), 0x1F)
            local g = bit32.band(bit32.rshift(pixel, 5), 0x1F)
            local b = bit32.band(pixel, 0x1F)

            
            local rb = bit32.bor(bit32.lshift(r, 3), bit32.rshift(r, 2))
            local gb = bit32.bor(bit32.lshift(g, 3), bit32.rshift(g, 2))
            local bb = bit32.bor(bit32.lshift(b, 3), bit32.rshift(b, 2))

            local offset = (y * width + x) * 4
            buffer.writeu32(pixels, offset, createRGBAColor(rb, gb, bb))
        end
    end

    return Result.okSmall()
end

function decode24bit(width: number, height: number, pixels: buffer, cursor: Cursor, header: BmpHeader)
    for y = 0, height - 1 do
        for x = 0, width - 1 do
            local b = cursor:ReadByte()
            local g = cursor:ReadByte()
            local r = cursor:ReadByte()

            local offset = (y * width + x) * 4
            buffer.writeu32(pixels, offset, createRGBAColor(r, g, b))
        end

        local padding = (4 - (width * 3) % 4) % 4
        cursor:SkipBytes(padding)
    end

    return Result.okSmall()
end

function decode32bit(width: number, height: number, pixels: buffer, cursor: Cursor, header: BmpHeader)
    for y = 0, height - 1 do
        for x = 0, width - 1 do
            local b = cursor:ReadByte()
            local g = cursor:ReadByte()
            local r = cursor:ReadByte()
            local a = cursor:ReadByte()

            local offset = (y * width + x) * 4
            buffer.writeu32(pixels, offset, createRGBAColor(r, g, b, a))
        end
    end

    return Result.okSmall()
end

function flipBuffer(width: number, height: number, pixels: buffer)
    local newPixels = buffer.create(width * height * 4)
    local rowSize = width * 4
        
    for y = 0, height - 1 do
        local sourceY = height - 1 - y
        buffer.copy(
            newPixels,
            y * rowSize,
            pixels,
            sourceY * rowSize,
            rowSize 
        )
    end

    return newPixels
end

local colorDepthMap = {
	[1] = decode1bit,
	[4] = decode4bit,
	[8] = decode8bit,
    [16] = decode16bit,
    [24] = decode24bit,
    [32] = decode32bit,
}

function BmpDecodePallete(cursor: Cursor, header: BmpHeader)
    cursor.position = 14 + header.headerSize -- Pallete area

	local numberOfColors = header.numberOfColors
	if numberOfColors == 0 and header.colorDepth <= 8 then
		numberOfColors = 2 ^ header.colorDepth -- 1-bit=2, 4-bit=16, 8-bit=256
	end

	local palette = buffer.create(numberOfColors * 4)
	local s, res = pcall(function(...)
        for i = 0, numberOfColors - 1 do
            local index = i * 4

            local bByte = cursor:ReadByte()
            local gByte = cursor:ReadByte()
            local rByte = cursor:ReadByte()


            -- Skip Alpha! (not present here)
            cursor:SkipBytes(1)

            --BGR -> RGBA (No point converting to u32 here. 256 * 4 writes (worst case) isn't too much)
            buffer.writeu8(palette, index, rByte) -- R
            buffer.writeu8(palette, index + 1, gByte) -- G
            buffer.writeu8(palette, index + 2, bByte) -- B
            buffer.writeu8(palette, index + 3, 255) -- A
	    end
    end)

    if not s then
        local words = string.split(res, " ")
        return Result.err(tonumber(words[#words]))
    end

	-- Start reading
	cursor.position = header.pixelDataOffset

	local dimensions = header.dimensions
	local trueWidth, trueHeight = math.abs(dimensions.width), math.abs(dimensions.height)
	local pixels = buffer.create(trueWidth * trueHeight * 4)

	local bits = header.colorDepth
    
	s, res = pcall(colorDepthMap[bits], trueWidth, trueHeight, pixels, palette, cursor)
	if not s then
		local words = string.split(res, " ")
        return Result.err(tonumber(words[#words]))
	end

    local isTopDown = dimensions.height < 0
    if not isTopDown then
        pixels = flipBuffer(trueWidth, trueHeight, pixels)
    end
    
	return Result.okSmall(
        trueWidth, trueHeight, pixels, header
    )
end

function BmpDecodeTrueColor(cursor: Cursor, header: BmpHeader)
    -- 15, 24, & 32 bit
    -- 15 bit is stored as 5 bytes each with an extra 0 (16 bit)??? 

    cursor.position = header.pixelDataOffset

	local dimensions = header.dimensions
	local trueWidth, trueHeight = math.abs(dimensions.width), math.abs(dimensions.height)
	local pixels = buffer.create(trueWidth * trueHeight * 4)

	local bits = header.colorDepth
    
    local s, res = pcall(colorDepthMap[bits], trueWidth, trueHeight, pixels, cursor, header)
    if not s then
		local words = string.split(res, " ")
        return Result.err(tonumber(words[#words]))
	end

    local isTopDown = dimensions.height < 0
    if not isTopDown then
        pixels = flipBuffer(trueWidth, trueHeight, pixels)
    end

    return Result.okSmall(
        trueWidth, trueHeight, pixels, header
    )
end

function Bmp.decode(cursor: Cursor): ImageResult<DynamicImageTypes.DynamicImage<any>> -- Dw about the type
	local header = Bmp.getHeader(cursor)
	if not header.isOk then
		return header -- No need to cast
	end

	local headerData = header:Unwrap()
    if headerData.colorDepth > 32 or headerData.colorDepth ~= 32 and headerData.compressionType ~= 0 and headerData.colorDepth == 32 and (headerData.compressionType ~= 0 or headerData.compressionType ~= 3) then
        return Result.err(ImageError.Unsupported)
    end

	-- Decode
	if headerData.colorDepth <= 8 then
		local res = BmpDecodePallete(cursor, headerData)
        return Result.castSmallToDefault(res)
	end

	local res = BmpDecodeTrueColor(cursor, headerData)
    return Result.castSmallToDefault(res)
end

function Bmp.encode(width: number, height: number, pixels: buffer)
    local FILE_HEADER_SIZE = 14
    local DIB_HEADER_SIZE = 40
    local PIXEL_DATA_OFFSET = FILE_HEADER_SIZE + DIB_HEADER_SIZE
    local BYTES_PER_PIXEL = 4

    local rowSize = width * BYTES_PER_PIXEL
    local fileSize = PIXEL_DATA_OFFSET + (rowSize * height)
    local bmp = buffer.create(fileSize)

    -- BITMAPFILEHEADER (14 bytes)
    buffer.writeu8(bmp, 0, 0x42)  -- 'B'
    buffer.writeu8(bmp, 1, 0x4D)  -- 'M'
    buffer.writeu32(bmp, 2, fileSize)  -- File size
    buffer.writeu32(bmp, 6, 0)
    buffer.writeu32(bmp, 10, PIXEL_DATA_OFFSET)  -- Pixel data offset

    -- BITMAPINFOHEADER (40 bytes)
    buffer.writeu32(bmp, 14, DIB_HEADER_SIZE)  -- Header size
    buffer.writeu32(bmp, 18, width)
    buffer.writeu32(bmp, 22, height)
    buffer.writeu16(bmp, 26, 1)  -- Planes
    buffer.writeu16(bmp, 28, 32)  -- Bits per pixel
    buffer.writeu32(bmp, 30, 3)  -- Compression (BI_BITFIELDS for alpha!!)
    buffer.writeu32(bmp, 34, rowSize * height)  -- Image size
    buffer.writeu32(bmp, 38, 0)  -- X pixels per mete
    buffer.writeu32(bmp, 42, 0)  -- Y pixels per meter
    buffer.writeu32(bmp, 46, 0)  -- Colors in palette
    buffer.writeu32(bmp, 50, 0)  -- Important colors

    -- (BGRA format, bottom-to-top)
    for y = height - 1, 0, -1 do  -- Backwards
        for x = 0, width - 1 do
            local srcOffset = (y * width + x) * 4  -- RGBA source
            local dstOffset = PIXEL_DATA_OFFSET + ((height - 1 - y) * rowSize) + (x * 4)

            -- Reversed so you can't really use `u32`
            buffer.writeu8(bmp, dstOffset,     buffer.readu8(pixels, srcOffset + 2))  -- B
            buffer.writeu8(bmp, dstOffset + 1, buffer.readu8(pixels, srcOffset + 1))  -- G
            buffer.writeu8(bmp, dstOffset + 2, buffer.readu8(pixels, srcOffset))      -- R
            buffer.writeu8(bmp, dstOffset + 3, buffer.readu8(pixels, srcOffset + 3))  -- A
        end
    end

    return bmp
end

return Bmp
