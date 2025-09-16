local Preprocess = require(script.Parent.Preprocess)
local fourBit = Preprocess[0.5]
local twoBit = Preprocess[0.25]

local Convert = {}

local function noneFilter(scanWidth: number, line: buffer, bitmap: buffer)
	buffer.copy(bitmap, 0, line, 0, scanWidth)
end

function Convert.trueColor(fileData, imageWidth, bpp, line, newScan)
	local preprocess = Preprocess[bpp]

	for pixel = 0, imageWidth - 1 do
		local rgba = preprocess(
			fileData,
			buffer.readu8(line, pixel * bpp),
			bpp > 1 and buffer.readu8(line, pixel * bpp + 1) or nil,
			bpp > 2 and buffer.readu8(line, pixel * bpp + 2) or nil
		)
		buffer.writeu32(newScan, pixel * 4, rgba)
	end
end

function Convert.fourBit(fileData, scanlineWidth: number, scanline: buffer, newScan: buffer)
	local testBuff = buffer.create(scanlineWidth)

	noneFilter(scanlineWidth, scanline, testBuff)

	for i = 0, scanlineWidth - 1 do
		local byte = buffer.readu8(testBuff, i)
		local index1 = bit32.rshift(byte, 4)
		local index2 = bit32.band(byte, 0x0F)

		local rgba1, rgba2 = fourBit(fileData, index1, index2)
		buffer.writeu32(newScan, i * 8, rgba1)
		buffer.writeu32(newScan, i * 8 + 4, rgba2)
	end
end

function Convert.twoBit(fileData, width: number, scanlineWidth: number, scanline: buffer, newScan: buffer)
	local testBuff = buffer.create(scanlineWidth)
	noneFilter(scanlineWidth, scanline, testBuff)

	local fullBytes = math.floor(width / 4)
	local extraPixels = width % 4
	local totalBytesNeeded = fullBytes + (extraPixels > 0 and 1 or 0)

	totalBytesNeeded = math.min(totalBytesNeeded, scanlineWidth)

	local outputPos = 0

	for i = 0, fullBytes - 1 do
		local byte = buffer.readu8(testBuff, i)
		local index1 = bit32.rshift(byte, 6)
		local index2 = bit32.band(bit32.rshift(byte, 4), 0x03)
		local index3 = bit32.band(bit32.rshift(byte, 2), 0x03)
		local index4 = bit32.band(byte, 0x03)

		buffer.writeu32(newScan, outputPos, twoBit(fileData, index1, 0, 0, 0))
		buffer.writeu32(newScan, outputPos + 4, twoBit(fileData, index2, 0, 0, 0))
		buffer.writeu32(newScan, outputPos + 8, twoBit(fileData, index3, 0, 0, 0))
		buffer.writeu32(newScan, outputPos + 12, twoBit(fileData, index4, 0, 0, 0))
		outputPos += 16
	end

	if extraPixels > 0 and fullBytes < scanlineWidth then
		local byte = buffer.readu8(testBuff, fullBytes)
		for p = 0, extraPixels - 1 do
			local shift = 6 - (p * 2)
			local index = bit32.band(bit32.rshift(byte, shift), 0x03)
			buffer.writeu32(newScan, outputPos, twoBit(fileData, index, 0, 0, 0))
			outputPos += 4
		end
	end
end

function Convert.oneBit(fileData, scanlineWidth: number, width: number, scanline: buffer, newScan: buffer)
	local testBuff = buffer.create(scanlineWidth)
	noneFilter(scanlineWidth, scanline, testBuff)

	local totalBitsNeeded = width
	local totalBytesNeeded = math.ceil(totalBitsNeeded / 8)
	local outputPos = 0

	for i = 0, totalBytesNeeded - 1 do
		local byte = buffer.readu8(testBuff, i)

		local remainingBits = totalBitsNeeded - outputPos
		local bitsInThisByte = math.min(8, remainingBits)

		for bit = 0, bitsInThisByte - 1 do
			local index = bit32.band(bit32.rshift(byte, 7 - bit), 0x01)

			local rgba = Preprocess[1](fileData, index)
			buffer.writeu32(newScan, outputPos * 4, rgba)
			outputPos += 1
		end
	end
end

return Convert
