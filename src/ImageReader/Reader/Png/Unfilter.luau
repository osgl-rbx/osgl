local Unfilter = {}

-- 0
function Unfilter.none(row, scanline: buffer, bitmap: buffer, width: number, height: number)
	local rowIndex = width * row * 4
	buffer.copy(bitmap, rowIndex, scanline, 0, width * 4)
end

-- 1
function Unfilter.sub(row, scanline: buffer, bitmap: buffer, width: number, height: number, protectAlpha: boolean)
	local rowStart = row * (width * 4)

	buffer.writeu32(bitmap, rowStart, buffer.readu32(scanline, 0))

	for i = 4, (width * 4) - 1 do
		local filteredByte = buffer.readu8(scanline, i)
		local leftByte = buffer.readu8(bitmap, rowStart + i - 4)
		local reconstructedByte

		if protectAlpha and (i % 4) == 3 then
			reconstructedByte = filteredByte
		else
			reconstructedByte = (filteredByte + leftByte) % 256
		end

		buffer.writeu8(bitmap, rowStart + i, reconstructedByte)
	end
end

-- 2
function Unfilter.up(row, scanline: buffer, bitmap: buffer, width: number, height: number, protectAlpha: boolean)
	if row > 0 then
		local rowStride = width * 4
		local upperRowOffset = (row - 1) * rowStride
		local currentRowOffset = row * rowStride

		for i = 0, rowStride - 1 do
			local x = buffer.readu8(scanline, i)
			local b = buffer.readu8(bitmap, upperRowOffset + i)
			local reconstructedByte

			if protectAlpha and (i % 4) == 3 then
				reconstructedByte = x
			else
				reconstructedByte = bit32.band(x + b, 0xFF)
			end

			buffer.writeu8(bitmap, currentRowOffset + i, reconstructedByte)
		end
	else
		Unfilter.none(row, scanline, bitmap, width, height)
	end
end

-- 3
function Unfilter.average(row, scanline: buffer, bitmap: buffer, width: number, height: number, protectAlpha: boolean)
	local rowStride = width * 4
	local currentRowOffset = row * rowStride

	if row > 0 then
		local upperRowOffset = (row - 1) * rowStride

		for i = 0, 3 do
			local x = buffer.readu8(scanline, i)
			local b = buffer.readu8(bitmap, upperRowOffset + i)
			local reconstructedByte

			if protectAlpha and i == 3 then
				reconstructedByte = x
			else
				local avg = bit32.rshift(b, 1)
				reconstructedByte = bit32.band(x + avg, 0xFF)
			end

			buffer.writeu8(bitmap, currentRowOffset + i, reconstructedByte)
		end

		for i = 4, rowStride - 1 do
			local x = buffer.readu8(scanline, i)
			local a = buffer.readu8(bitmap, currentRowOffset + i - 4)
			local b = buffer.readu8(bitmap, upperRowOffset + i)
			local reconstructedByte

			if protectAlpha and (i % 4) == 3 then
				reconstructedByte = x
			else
				local avg = bit32.rshift(a + b, 1)
				reconstructedByte = bit32.band(x + avg, 0xFF)
			end

			buffer.writeu8(bitmap, currentRowOffset + i, reconstructedByte)
		end
	else
		for i = 0, 3 do
			buffer.writeu8(bitmap, currentRowOffset + i, buffer.readu8(scanline, i))
		end

		for i = 4, rowStride - 1 do
			local x = buffer.readu8(scanline, i)
			local reconstructedByte

			if protectAlpha and (i % 4) == 3 then
				reconstructedByte = x
			else
				local b = buffer.readu8(bitmap, currentRowOffset + i)
				local avg = bit32.rshift(b, 1)
				reconstructedByte = bit32.band(x + avg, 0xFF)
			end

			buffer.writeu8(bitmap, currentRowOffset + i, reconstructedByte)
		end
	end
end

-- 4
function Unfilter.paeth(row, scanline: buffer, bitmap: buffer, width: number, height: number, protectAlpha: boolean)
	if row > 0 then
		local rowStride = width * 4
		local currentRowOffset = row * rowStride
		local upperRowOffset = (row - 1) * rowStride

		for i = 0, 3 do
			local x = buffer.readu8(scanline, i)
			local b = buffer.readu8(bitmap, upperRowOffset + i)
			local reconstructedByte

			if protectAlpha and i == 3 then
				reconstructedByte = x
			else
				reconstructedByte = bit32.band(x + b, 0xFF)
			end

			buffer.writeu8(bitmap, currentRowOffset + i, reconstructedByte)
		end

		for i = 4, rowStride - 1 do
			local isAlpha = protectAlpha and (i % 4) == 3

			if isAlpha then
				-- Directly copy for protected alpha :)
				buffer.writeu8(bitmap, currentRowOffset + i, buffer.readu8(scanline, i))
			else
				-- Normal Paeth predictor!
				local a = buffer.readu8(bitmap, currentRowOffset + i - 4)
				local b = buffer.readu8(bitmap, upperRowOffset + i)
				local c = buffer.readu8(bitmap, upperRowOffset + i - 4)

				local x = buffer.readu8(scanline, i)
				local p = a + b - c

				local pa = math.abs(p - a)
				local pb = math.abs(p - b)
				local pc = math.abs(p - c)

				local pr
				if pa <= pb and pa <= pc then
					pr = a
				elseif pb <= pc then
					pr = b
				else
					pr = c
				end

				buffer.writeu8(bitmap, currentRowOffset + i, bit32.band(x + pr, 0xFF))
			end
		end
	else
		Unfilter.sub(row, scanline, bitmap, width, height, protectAlpha)
	end
end

local unfilteringFunctions = {
	[0] = Unfilter.none,
	[1] = Unfilter.sub,
	[2] = Unfilter.up,
	[3] = Unfilter.average,
	[4] = Unfilter.paeth,
}

function Unfilter.unfilter(
	t: number,
	row: number,
	scanline: buffer,
	bitmap: buffer,
	width: number,
	height: number,
	protectAlpha: boolean
)
    unfilteringFunctions[t](row, scanline, bitmap, width, height, protectAlpha)
end

return Unfilter
