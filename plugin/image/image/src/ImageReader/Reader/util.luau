local util = {}

function util.createRGBAColor(r: number, g: number, b: number, a: number?): number
    return bit32.bor(
        if a then a * 16777216 else 4278190080,
        b * 65536,
        g * 256,
        r
    )
end

function util.beToLe32(beValue: number)
	return bit32.bor(
		bit32.rshift(bit32.band(beValue, 0xFF000000), 24),
		bit32.rshift(bit32.band(beValue, 0x00FF0000), 8),
		bit32.lshift(bit32.band(beValue, 0x0000FF00), 8),
		bit32.lshift(bit32.band(beValue, 0x000000FF), 24)
	)
end

function util.beToLe16(beValue: number)
    return bit32.bor(
        bit32.rshift(bit32.band(beValue, 0xFF00), 8),
        bit32.lshift(bit32.band(beValue, 0x00FF), 8)
    )
end

return util