local util = require(script.Parent.Parent.util)

local createRGBAColor = util.createRGBAColor

local function getRGB2Bit(palette, index)
	local offset = index * 3
	return buffer.readu8(palette, offset), -- R
		buffer.readu8(palette, offset + 1), -- G
		buffer.readu8(palette, offset + 2) -- B
end

return {
	[0.25] = function(file, i1, i2, i3, i4) -- Takes 4 indices (2 bits each)
		local palette = file.palette
		-- Generate 4 RGBA colors (assuming alpha = 255)
		local r1, g1, b1 = getRGB2Bit(palette, i1)
		local r2, g2, b2 = getRGB2Bit(palette, i2)
		local r3, g3, b3 = getRGB2Bit(palette, i3)
		local r4, g4, b4 = getRGB2Bit(palette, i4)

		return createRGBAColor(r1, g1, b1), -- Pixel 1
			createRGBAColor(r2, g2, b2), -- Pixel 2
			createRGBAColor(r3, g3, b3), -- Pixel 3
			createRGBAColor(r4, g4, b4) -- Pixel 4
	end,

	[0.5] = function(file, hi, lo)
		local palette = file.palette

		local high = hi * 3
		local low = lo * 3

		return createRGBAColor(
			buffer.readu8(palette, high),
			buffer.readu8(palette, high + 1),
			buffer.readu8(palette, high + 2)
		),
			createRGBAColor(
				buffer.readu8(palette, low),
				buffer.readu8(palette, low + 1),
				buffer.readu8(palette, low + 2)
			)
	end,

	[1] = function(file, byte)
		local palette = file.palette
		local offset = byte * 3

		local r = buffer.readu8(palette, offset)
		local g = buffer.readu8(palette, offset + 1)
		local b = buffer.readu8(palette, offset + 2)

		return createRGBAColor(r, g, b)
	end,

	[3] = function(_, r: number, g: number, b: number)
		return createRGBAColor(r, g, b)
	end,
}
