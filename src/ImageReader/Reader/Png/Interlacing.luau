local Interlacing = {}

local X_STEP = { 8, 8, 4, 4, 2, 2, 1 }
local Y_STEP = { 8, 8, 8, 4, 4, 2, 2 }
local X_OFF = { 0, 4, 0, 2, 0, 1, 0 }
local Y_OFF = { 0, 0, 4, 0, 2, 0, 1 }

function Interlacing.calculateSize(w, h, bpp)
	local totalBytes = 0
	for pass = 1, 7 do
		local passW = math.ceil((w - X_OFF[pass]) / X_STEP[pass])
		local passH = math.ceil((h - Y_OFF[pass]) / Y_STEP[pass])
		if passW > 0 and passH > 0 then
			totalBytes += passH * (1 + math.ceil((passW * bpp) / 8))
		end
	end
	return totalBytes
end

function Interlacing.deinterlaceAdam7(responseBuffer, width, height, bpp, file, header)
	local idx = 0
	local channels = 4 -- RGBA
	local bitDepth = 8
	local working = responseBuffer
	local map = buffer.create(width * height * channels)

	for passNum = 1, 7 do
		local sx, sy = X_OFF[passNum], Y_OFF[passNum]
		local dx, dy = X_STEP[passNum], Y_STEP[passNum]

		local w = math.ceil((width - sx) / dx)
		local h = math.ceil((height - sy) / dy)
		if w < 1 or h < 1 then
			continue
		else
			local scanlineSize = math.ceil(w * channels * bitDepth / 8)
			local newIdx = idx

			for y = 1, h do
				local rowFilter = buffer.readu8(working, idx)
				idx += 1

				if rowFilter == 0 or (rowFilter == 2 and y == 1) then
					idx += scanlineSize
				elseif rowFilter == 1 then
					for x = 1, scanlineSize do
						local sub = (x <= bpp) and 0 or buffer.readu8(working, idx - bpp)
						local value = bit32.band(buffer.readu8(working, idx) + sub, 0xFF)
						buffer.writeu8(working, idx, value)
						idx += 1
					end
				elseif rowFilter == 2 then
					for _ = 1, scanlineSize do
						local up = buffer.readu8(working, idx - scanlineSize - 1)
						local value = bit32.band(buffer.readu8(working, idx) + up, 0xFF)
						buffer.writeu8(working, idx, value)
						idx += 1
					end
				elseif rowFilter == 3 then
					for x = 1, scanlineSize do
						local sub = (x <= bpp) and 0 or buffer.readu8(working, idx - bpp)
						local up = (y == 1) and 0 or buffer.readu8(working, idx - scanlineSize - 1)
						local value = bit32.band(buffer.readu8(working, idx) + bit32.rshift(sub + up, 1), 0xFF)
						buffer.writeu8(working, idx, value)
						idx += 1
					end
				elseif rowFilter == 4 then
					for x = 1, scanlineSize do
						local sub = (x <= bpp) and 0 or buffer.readu8(working, idx - bpp)
						local up = (y == 1) and 0 or buffer.readu8(working, idx - scanlineSize - 1)
						local corner = (x <= bpp or y == 1) and 0
							or buffer.readu8(working, idx - scanlineSize - bpp - 1)
						local p0 = math.abs(up - corner)
						local p1 = math.abs(sub - corner)
						local p2 = math.abs(sub + up - 2 * corner)
						local paeth = (p0 <= p1 and p0 <= p2) and sub or ((p1 <= p2) and up or corner)
						local value = bit32.band(buffer.readu8(working, idx) + paeth, 0xFF)
						buffer.writeu8(working, idx, value)
						idx += 1
					end
				end
			end

			local bit = 8
			local function readValue()
				local b = buffer.readu8(working, newIdx)
				if bitDepth < 8 then
					b = bit32.extract(b, bit - bitDepth, bitDepth)
					bit -= bitDepth
					if bit == 0 then
						bit = 8
						newIdx += 1
					end
				elseif bitDepth == 8 then
					newIdx += 1
				else
					b = bit32.bor(bit32.lshift(b, 8), buffer.readu8(working, newIdx + 1))
					newIdx += 2
				end
				return b
			end

			local alpha = file.alpha

			for y = 1, h do
				newIdx += 1
				if bit < 8 then
					bit = 8
					newIdx += 1
				end

				for x = 1, w do
					local r, g, b, a

					if header.colorType == 0 then
						local gray = readValue()
						r = gray
						g = gray
						b = gray
						a = if gray == alpha.gray then 0 else 255
					elseif header.colorType == 2 then
						r = readValue()
						g = readValue()
						b = readValue()
						a = if r == alpha.red and g == alpha.green and b == alpha.blue then 0 else 255
					elseif header.colorType == 3 then
						local originalOffset = readValue()
						r, g, b, a =
							buffer.readu8(file.palette, originalOffset),
							buffer.readu8(file.palette, originalOffset + 1),
							buffer.readu8(file.palette, originalOffset + 2),
							buffer.readu8(file.palette, originalOffset + 3)
					elseif header.colorType == 4 then
						local gray = readValue()
						r = gray
						g = gray
						b = gray
						a = readValue()
					elseif header.colorType == 6 then
						r = readValue()
						g = readValue()
						b = readValue()
						a = readValue()
					end

					local py = sy + (y - 1) * dy
					local px = sx + (x - 1) * dx
					local i = (py * width + px) * 4

					if bitDepth == 16 then
						r = bit32.rshift(r, 8)
						g = bit32.rshift(g, 8)
						b = bit32.rshift(b, 8)
						a = bit32.rshift(a, 8)
					end

					buffer.writeu32(map, i, bit32.bor(bit32.lshift(a, 24), bit32.lshift(b, 16), bit32.lshift(g, 8), r))
				end
			end
		end
	end

	return map
end

return Interlacing
