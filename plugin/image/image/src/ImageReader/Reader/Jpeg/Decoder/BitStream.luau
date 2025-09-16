local module = {}

function module.CreateBitStream(data)
	local stream = {}

	stream.data = data
	stream.pos = 0

	local nextByte = 0
	local nextBit = 0

	function stream.ReadBit()
		if nextByte >= #stream.data then
			return -1
		end

		local index = bit32.rshift(stream.pos, 3) + 1

		local bit = bit32.band(bit32.rshift(stream.data[nextByte + 1], (7 - nextBit)), 1)
		nextBit = nextBit + 1

		if nextBit == 8 then
			nextBit = 0
			nextByte = nextByte + 1
		end

		return bit
	end

	function stream.ReadBits(length)
		local bits = 0

		for i = 1, length do
			local bit = stream.ReadBit()

			if bit == -1 then
				bits = -1
				break
			end

			bits = bit32.bor(bit32.lshift(bits, 1), bit)
		end

		return bits
	end
	
	function stream.Align()
		if nextByte >= #stream.data then
			return
		end

		if nextBit ~= 0 then
			nextBit = 0
			nextByte = nextByte + 1
		end
	end

	return stream
end

return module