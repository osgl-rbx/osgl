--!native
--!optimize 2
--!nonstrict

local __BUNDLE
__BUNDLE = {
	cache = {},
	load = function(m)
		if not __BUNDLE.cache[m] then
			__BUNDLE.cache[m] = { c = __BUNDLE[m]() }
		end
		return __BUNDLE.cache[m].c
	end,
}
do
	function __BUNDLE.a()
		return {}
	end
	function __BUNDLE.b()
		__BUNDLE.load("a")

		return {}
	end
	function __BUNDLE.c()
		__BUNDLE.load("b")
		__BUNDLE.load("a")

		local COLOR_TYPE_BIT_DEPTH = {
			[0] = { 1, 2, 4, 8, 16 },
			[2] = { 8, 16 },
			[3] = { 1, 2, 4, 8 },
			[4] = { 8, 16 },
			[6] = { 8, 16 },
		}

		local function read(buf, chunk)
			assert(chunk.length == 13, "IHDR data must be 13 bytes")

			local offset = chunk.offset

			local width = bit32.byteswap(buffer.readu32(buf, offset))
			local height = bit32.byteswap(buffer.readu32(buf, offset + 4))
			local bitDepth = buffer.readu8(buf, offset + 8)
			local colorType = buffer.readu8(buf, offset + 9)
			local compression = buffer.readu8(buf, offset + 10)
			local filter = buffer.readu8(buf, offset + 11)
			local interlace = buffer.readu8(buf, offset + 12)

			assert(width > 0 and width <= 2 ^ 31 and height > 0 and height <= 2 ^ 31, "invalid dimensions")
			assert(compression == 0, "invalid compression method")
			assert(filter == 0, "invalid filter method")
			assert(interlace == 0 or interlace == 1, "invalid interlace method")

			local allowedBitDepth = COLOR_TYPE_BIT_DEPTH[colorType]
			assert(allowedBitDepth ~= nil, "invalid color type")
			assert(table.find(allowedBitDepth, bitDepth) ~= nil, "invalid bit depth")

			return {
				width = width,
				height = height,
				bitDepth = bitDepth,
				colorType = colorType,
				interlaced = interlace == 1,
			}
		end

		return read
	end
	function __BUNDLE.d()
		__BUNDLE.load("b")
		__BUNDLE.load("a")

		local function read(buf, chunk, header)
			assert(chunk.length % 3 == 0, "malformed PLTE chunk")

			local count = chunk.length / 3
			assert(count > 0, "no entries in PLTE")
			assert(count <= 256, "too many entries in PLTE")
			assert(count <= 2 ^ header.bitDepth, "too many entries in PLTE for bit depth")

			local colors = table.create(count)
			local offset = chunk.offset

			for i = 1, count do
				colors[i] = {
					r = buffer.readu8(buf, offset),
					g = buffer.readu8(buf, offset + 1),
					b = buffer.readu8(buf, offset + 2),
					a = 255,
				}
				offset += 3
			end

			return {
				colors = colors,
			}
		end

		return read
	end
	function __BUNDLE.e()
		__BUNDLE.load("b")
		__BUNDLE.load("a")

		local function readU16(buf, offset, depth)
			return bit32.extract(
				bit32.bor(bit32.lshift(buffer.readu8(buf, offset), 8), buffer.readu8(buf, offset + 1)),
				0,
				depth
			)
		end

		local function read(buf, chunk, header, palette)
			local gray = -1
			local red = -1
			local green = -1
			local blue = -1

			if header.colorType == 0 then
				assert(chunk.length == 2, "invalid tRNS length for color type")
				gray = readU16(buf, chunk.offset, header.bitDepth)
			elseif header.colorType == 2 then
				assert(chunk.length == 6, "invalid tRNS length for color type")
				red = readU16(buf, chunk.offset, header.bitDepth)
				green = readU16(buf, chunk.offset + 2, header.bitDepth)
				blue = readU16(buf, chunk.offset + 4, header.bitDepth)
			else
				local count = chunk.length
				assert(palette, "tRNS requires PLTE for color type")
				assert(count <= #palette.colors, "tRNS specified too many PLTE alphas")
				for i = 1, count do
					palette.colors[i].a = buffer.readu8(buf, chunk.offset + i - 1)
				end
			end

			return {
				gray = gray,
				red = red,
				green = green,
				blue = blue,
			}
		end

		return read
	end
	function __BUNDLE.f()
		return {
			IHDR = __BUNDLE.load("c"),
			PLTE = __BUNDLE.load("d"),
			tRNS = __BUNDLE.load("e"),
		}
	end
	function __BUNDLE.g()


-- stylua: ignore

local lookup = {
	0x00000000, 0x77073096, 0xEE0E612C, 0x990951BA, 0x076DC419, 0x706AF48F, 0xE963A535, 0x9E6495A3,
	0x0EDB8832, 0x79DCB8A4, 0xE0D5E91E, 0x97D2D988, 0x09B64C2B, 0x7EB17CBD, 0xE7B82D07, 0x90BF1D91,
	0x1DB71064, 0x6AB020F2, 0xF3B97148, 0x84BE41DE, 0x1ADAD47D, 0x6DDDE4EB, 0xF4D4B551, 0x83D385C7,
	0x136C9856, 0x646BA8C0, 0xFD62F97A, 0x8A65C9EC, 0x14015C4F, 0x63066CD9, 0xFA0F3D63, 0x8D080DF5,
	0x3B6E20C8, 0x4C69105E, 0xD56041E4, 0xA2677172, 0x3C03E4D1, 0x4B04D447, 0xD20D85FD, 0xA50AB56B,
	0x35B5A8FA, 0x42B2986C, 0xDBBBC9D6, 0xACBCF940, 0x32D86CE3, 0x45DF5C75, 0xDCD60DCF, 0xABD13D59,
	0x26D930AC, 0x51DE003A, 0xC8D75180, 0xBFD06116, 0x21B4F4B5, 0x56B3C423, 0xCFBA9599, 0xB8BDA50F,
	0x2802B89E, 0x5F058808, 0xC60CD9B2, 0xB10BE924, 0x2F6F7C87, 0x58684C11, 0xC1611DAB, 0xB6662D3D,
	0x76DC4190, 0x01DB7106, 0x98D220BC, 0xEFD5102A, 0x71B18589, 0x06B6B51F, 0x9FBFE4A5, 0xE8B8D433,
	0x7807C9A2, 0x0F00F934, 0x9609A88E, 0xE10E9818, 0x7F6A0DBB, 0x086D3D2D, 0x91646C97, 0xE6635C01,
	0x6B6B51F4, 0x1C6C6162, 0x856530D8, 0xF262004E, 0x6C0695ED, 0x1B01A57B, 0x8208F4C1, 0xF50FC457,
	0x65B0D9C6, 0x12B7E950, 0x8BBEB8EA, 0xFCB9887C, 0x62DD1DDF, 0x15DA2D49, 0x8CD37CF3, 0xFBD44C65,
	0x4DB26158, 0x3AB551CE, 0xA3BC0074, 0xD4BB30E2, 0x4ADFA541, 0x3DD895D7, 0xA4D1C46D, 0xD3D6F4FB,
	0x4369E96A, 0x346ED9FC, 0xAD678846, 0xDA60B8D0, 0x44042D73, 0x33031DE5, 0xAA0A4C5F, 0xDD0D7CC9,
	0x5005713C, 0x270241AA, 0xBE0B1010, 0xC90C2086, 0x5768B525, 0x206F85B3, 0xB966D409, 0xCE61E49F,
	0x5EDEF90E, 0x29D9C998, 0xB0D09822, 0xC7D7A8B4, 0x59B33D17, 0x2EB40D81, 0xB7BD5C3B, 0xC0BA6CAD,
	0xEDB88320, 0x9ABFB3B6, 0x03B6E20C, 0x74B1D29A, 0xEAD54739, 0x9DD277AF, 0x04DB2615, 0x73DC1683,
	0xE3630B12, 0x94643B84, 0x0D6D6A3E, 0x7A6A5AA8, 0xE40ECF0B, 0x9309FF9D, 0x0A00AE27, 0x7D079EB1,
	0xF00F9344, 0x8708A3D2, 0x1E01F268, 0x6906C2FE, 0xF762575D, 0x806567CB, 0x196C3671, 0x6E6B06E7,
	0xFED41B76, 0x89D32BE0, 0x10DA7A5A, 0x67DD4ACC, 0xF9B9DF6F, 0x8EBEEFF9, 0x17B7BE43, 0x60B08ED5,
	0xD6D6A3E8, 0xA1D1937E, 0x38D8C2C4, 0x4FDFF252, 0xD1BB67F1, 0xA6BC5767, 0x3FB506DD, 0x48B2364B,
	0xD80D2BDA, 0xAF0A1B4C, 0x36034AF6, 0x41047A60, 0xDF60EFC3, 0xA867DF55, 0x316E8EEF, 0x4669BE79,
	0xCB61B38C, 0xBC66831A, 0x256FD2A0, 0x5268E236, 0xCC0C7795, 0xBB0B4703, 0x220216B9, 0x5505262F,
	0xC5BA3BBE, 0xB2BD0B28, 0x2BB45A92, 0x5CB36A04, 0xC2D7FFA7, 0xB5D0CF31, 0x2CD99E8B, 0x5BDEAE1D,
	0x9B64C2B0, 0xEC63F226, 0x756AA39C, 0x026D930A, 0x9C0906A9, 0xEB0E363F, 0x72076785, 0x05005713,
	0x95BF4A82, 0xE2B87A14, 0x7BB12BAE, 0x0CB61B38, 0x92D28E9B, 0xE5D5BE0D, 0x7CDCEFB7, 0x0BDBDF21,
	0x86D3D2D4, 0xF1D4E242, 0x68DDB3F8, 0x1FDA836E, 0x81BE16CD, 0xF6B9265B, 0x6FB077E1, 0x18B74777,
	0x88085AE6, 0xFF0F6A70, 0x66063BCA, 0x11010B5C, 0x8F659EFF, 0xF862AE69, 0x616BFFD3, 0x166CCF45,
	0xA00AE278, 0xD70DD2EE, 0x4E048354, 0x3903B3C2, 0xA7672661, 0xD06016F7, 0x4969474D, 0x3E6E77DB,
	0xAED16A4A, 0xD9D65ADC, 0x40DF0B66, 0x37D83BF0, 0xA9BCAE53, 0xDEBB9EC5, 0x47B2CF7F, 0x30B5FFE9,
	0xBDBDF21C, 0xCABAC28A, 0x53B39330, 0x24B4A3A6, 0xBAD03605, 0xCDD70693, 0x54DE5729, 0x23D967BF,
	0xB3667A2E, 0xC4614AB8, 0x5D681B02, 0x2A6F2B94, 0xB40BBE37, 0xC30C8EA1, 0x5A05DF1B, 0x2D02EF8D,
}

		local function crc32(buf, i, j)
			local code = 0xFFFFFFFF
			for k = i, j do
				code = bit32.bxor(
					bit32.rshift(code, 8),
					lookup[bit32.bxor(bit32.band(code, 0xFF), buffer.readu8(buf, k)) + 1]
				)
			end
			return bit32.bxor(code, 0xFFFFFFFF)
		end

		return crc32
	end
	function __BUNDLE.h()
		local function new(lengths)
			local blCount = {}
			local maxBits = 0
			for _, len in lengths do
				if len > 0 then
					blCount[len] = (blCount[len] or 0) + 1
					if len > maxBits then
						maxBits = len
					end
				end
			end

			local thisCode = 1
			local nextCode = {}
			for bits = 1, maxBits do
				thisCode = 2 * (thisCode + (blCount[bits - 1] or 0))
				nextCode[bits] = thisCode
			end

			local look = {}
			for n, len in lengths do
				if len > 0 then
					look[nextCode[len]] = n - 1
					nextCode[len] += 1
				end
			end

			local function read(readBit)
				local code = 1
				repeat
					code = 2 * code + readBit()
				until look[code]
				return look[code]
			end

			return {
				read = read,
			}
		end

		return {
			new = new,
		}
	end
	function __BUNDLE.i()
		local HuffmanTable = __BUNDLE.load("h")

-- stylua: ignore
local LIT_LEN = {
	3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 
	35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258,
}

-- stylua: ignore
local LIT_EXTRA = {
	0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 
	2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0,
}

-- stylua: ignore
local DIST_OFF = {
	1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513,
	769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577,
}

-- stylua: ignore
local DIST_EXTRA = {
	0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6,
	7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13,
}

-- stylua: ignore
local LEN_ORDER = {
	16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15,
}

		local FIXED_LIT = {}
		for n = 0, 287 do
			FIXED_LIT[n + 1] = if n < 144 or n > 279 then 8 elseif n < 256 then 9 else 7
		end

		local FIXED_DIST = {}
		for n = 0, 31 do
			FIXED_DIST[n + 1] = 5
		end

		local readFixedLit = HuffmanTable.new(FIXED_LIT).read
		local readFixedDist = HuffmanTable.new(FIXED_DIST).read

		local function inflate(input, output)
			local byteIdx = 0
			local bitIdx = 0

			local function readBit()
				local byte = buffer.readu8(input, byteIdx)
				local bit = bit32.extract(byte, bitIdx)
				bitIdx += 1
				if bitIdx == 8 then
					bitIdx = 0
					byteIdx += 1
				end
				return bit
			end

			local function readBits(count)
				local n = 0
				local byte = buffer.readu8(input, byteIdx)
				for p = 0, count - 1 do
					local bit = bit32.extract(byte, bitIdx)
					n += bit32.lshift(bit, p)
					bitIdx += 1
					if bitIdx == 8 then
						bitIdx = 0
						byteIdx += 1
						byte = buffer.readu8(input, byteIdx)
					end
				end
				return n
			end

			local method = readBits(4)
			assert(method == 8, "invalid zlib compression method")

			local info = readBits(4)
			assert(info <= 7, "invalid zlib window size")

			local fcheck = readBits(5)
			local fdict = readBit()
			assert(fdict == 0, "preset dictionary is not allowed")

			local flevel = readBits(2)
			local sum = bit32.bor(
				bit32.lshift(info, 12),
				bit32.lshift(method, 8),
				bit32.lshift(flevel, 6),
				bit32.lshift(fdict, 5),
				fcheck
			)
			assert(sum % 31 == 0, "invalid zlib header sum")

			local window = buffer.create(0x8000)
			local windowIdx = 0
			local outputIdx = 0

			repeat
				local bfinal = readBit()
				local btype = readBits(2)
				assert(btype ~= 3, "reserved btype")
				assert(btype == 0 or btype == 1 or btype == 2, "unknown btype")

				if btype == 0 then
					if bitIdx > 0 then
						byteIdx += 1
						bitIdx = 0
					end

					local len =
						bit32.bor(buffer.readu8(input, byteIdx), bit32.lshift(buffer.readu8(input, byteIdx + 1), 8))
					local nlen =
						bit32.bor(buffer.readu8(input, byteIdx + 2), bit32.lshift(buffer.readu8(input, byteIdx + 3), 8))
					assert(len + nlen == 0xFFFF, "invalid len/nlen")
					byteIdx += 4

					for _ = 1, len do
						local b = buffer.readu8(input, byteIdx)
						buffer.writeu8(window, windowIdx, b)
						buffer.writeu8(output, outputIdx, b)
						byteIdx += 1
						windowIdx = bit32.band(windowIdx + 1, 0x7FFF)
						outputIdx += 1
					end
				elseif btype == 1 or btype == 2 then
					local readLit = readFixedLit
					local readDist = readFixedDist

					if btype == 2 then
						local litsCount = readBits(5) + 257
						local distsCount = readBits(5) + 1
						local codesCount = readBits(4) + 4

						local codeLengths = table.create(19, 0)
						local readLength
						for i = 1, codesCount do
							codeLengths[LEN_ORDER[i] + 1] = readBits(3)
						end

						local function getReader(numCodes)
							local lengths = {}
							local index = 1
							local length
							while index <= numCodes do
								local code = readLength(readBit)
								local repeatCount = 1
								if code <= 15 then
									length = code
								elseif code == 16 then
									repeatCount = readBits(2) + 3
								elseif code == 17 then
									length = 0
									repeatCount = readBits(3) + 3
								elseif code == 18 then
									length = 0
									repeatCount = readBits(7) + 11
								end
								for _ = 1, repeatCount do
									lengths[index] = length
									index += 1
								end
							end
							return HuffmanTable.new(lengths).read
						end

						readLength = HuffmanTable.new(codeLengths).read
						readLit = getReader(litsCount)
						readDist = getReader(distsCount)
					end

					while true do
						local v = readLit(readBit)
						if v == 0x100 then
							break
						elseif v < 0x100 then
							buffer.writeu8(window, windowIdx, v)
							buffer.writeu8(output, outputIdx, v)
							windowIdx = bit32.band(windowIdx + 1, 0x7FFF)
							outputIdx += 1
						else
							local len = LIT_LEN[v - 0x100]
							local lenExtra = LIT_EXTRA[v - 0x100]
							if lenExtra > 0 then
								len += readBits(lenExtra)
							end
							local d = readDist(readBit)
							local dist = DIST_OFF[d + 1]
							local distExtra = DIST_EXTRA[d + 1]
							if distExtra > 0 then
								dist += readBits(distExtra)
							end
							for _ = 1, len do
								local b = buffer.readu8(window, bit32.band(windowIdx - dist, 0x7FFF))
								buffer.writeu8(window, windowIdx, b)
								buffer.writeu8(output, outputIdx, b)
								windowIdx = bit32.band(windowIdx + 1, 0x7FFF)
								outputIdx += 1
							end
						end
					end
				end
			until bfinal == 1

			return outputIdx
		end

		return inflate
	end
end
__BUNDLE.load("b")
__BUNDLE.load("a")

local chunkReaders = __BUNDLE.load("f")
local crc32 = __BUNDLE.load("g")
local inflate = __BUNDLE.load("i")

local COLOR_TYPE_CHANNELS = {
	[0] = 1,
	[2] = 3,
	[3] = 1,
	[4] = 2,
	[6] = 4,
}

local INTERLACE_ROW_START = { 0, 0, 4, 0, 2, 0, 1 }
local INTERLACE_COL_START = { 0, 4, 0, 2, 0, 1, 0 }
local INTERLACE_ROW_INCR = { 8, 8, 8, 4, 4, 2, 2 }
local INTERLACE_COL_INCR = { 8, 8, 4, 4, 2, 2, 1 }

local function decode(buf, options)
	local bufLen = buffer.len(buf)
	assert(bufLen >= 8, "not a PNG")

	-- selene: allow(bad_string_escape)
	assert(buffer.readstring(buf, 0, 8) == "\x89PNG\x0D\x0A\x1A\x0A", "not a PNG")

	local chunks = table.create(3)
	local offset = 8

	local skipCRC = options ~= nil and options.allowIncorrectCRC == true

	repeat
		local dataLength = bit32.byteswap(buffer.readu32(buf, offset))
		local chunkType = buffer.readstring(buf, offset + 4, 4)
		assert(string.match(chunkType, "%a%a%a%a"), `invalid chunk type {chunkType}`)

		local dataOffset = offset + 8
		local nextOffset = dataOffset + dataLength + 4
		assert(nextOffset <= bufLen, `EOF while reading {chunkType} chunk`)

		local chunkCode = bit32.byteswap(buffer.readu32(buf, nextOffset - 4))
		local expectCode = crc32(buf, offset + 4, nextOffset - 5)
		assert(skipCRC or chunkCode == expectCode, `incorrect checksum in {chunkType}`)

		table.insert(chunks, {
			type = chunkType,
			offset = dataOffset,
			length = dataLength,
		})
		offset = nextOffset
	until offset >= bufLen
	assert(offset == bufLen, "trailing data in file")

	for _, chunk in chunks do
		local t = chunk.type
		if bit32.extract(string.byte(t, 1, 1), 5) == 0 then
			assert(t == "IHDR" or t == "IDAT" or t == "PLTE" or t == "IEND", `unhandled critical chunk {t}`)
		end
	end

	local header
	local headerChunk = chunks[1]
	assert(headerChunk.type == "IHDR", "first chunk must be IHDR")
	for i = 2, #chunks do
		assert(chunks[i].type ~= "IHDR", "multiple IHDR chunks are not allowed")
	end
	header = chunkReaders.IHDR(buf, headerChunk)

	local dataChunkIndex0 = -1
	local dataChunkIndex1 = -1
	local compressedDataLength = 0
	for i, chunk in chunks do
		if chunk.type == "IDAT" then
			if dataChunkIndex0 < 0 then
				dataChunkIndex0 = i
			else
				assert(i == dataChunkIndex1 + 1, "multiple IDAT chunks must be consecutive")
			end
			dataChunkIndex1 = i
			compressedDataLength += chunk.length
		end
	end
	assert(dataChunkIndex0 > 0, "no IDAT chunks")
	assert(compressedDataLength > 0, "no image data in IDAT chunks")

	local palette
	local paletteChunkIndex = -1
	for i, chunk in chunks do
		if chunk.type == "PLTE" then
			assert(not palette, "multiple PLTE chunks are not allowed")
			assert(i < dataChunkIndex0, "PLTE not allowed after IDAT chunks")
			assert(header.colorType ~= 0 and header.colorType ~= 4, "PLTE not allowed for color type")
			palette = chunkReaders.PLTE(buf, chunk, header)
			paletteChunkIndex = i
		end
	end
	if header.colorType == 3 then
		assert(palette ~= nil, "color type requires a PLTE chunk")
	end

	local transparencyData
	for i, chunk in chunks do
		if chunk.type == "tRNS" then
			assert(transparencyData == nil, "multiple tRNS chunks are not allowed")
			assert(i < dataChunkIndex0, "tRNS not allowed after IDAT chunks")
			assert(not palette or i > paletteChunkIndex, "tRNS must be after PLTE")
			assert(header.colorType ~= 4 and header.colorType ~= 6, "tRNS not allowed for color type")
			transparencyData = chunkReaders.tRNS(buf, chunk, header, palette)
		end
	end

	local finalChunk = chunks[#chunks]
	assert(finalChunk.type == "IEND", "final chunk must be IEND")
	assert(finalChunk.length == 0, "IEND chunk must be empty")
	for i = 2, #chunks - 1 do
		assert(chunks[i].type ~= "IEND", "multiple IEND chunks are not allowed")
	end

	local compressedData = buffer.create(compressedDataLength)
	local compressedOffset = 0
	for _, chunk in chunks do
		if chunk.type == "IDAT" then
			buffer.copy(compressedData, compressedOffset, buf, chunk.offset, chunk.length)
			compressedOffset += chunk.length
		end
	end

	local width = header.width
	local height = header.height
	local bitDepth = header.bitDepth
	local colorType = header.colorType
	local channels = COLOR_TYPE_CHANNELS[colorType]

	local rawSize = 0
	if not header.interlaced then
		rawSize = height * (math.ceil(width * channels * bitDepth / 8) + 1)
	else
		for i = 1, 7 do
			local w = math.ceil((width - INTERLACE_COL_START[i]) / INTERLACE_COL_INCR[i])
			local h = math.ceil((height - INTERLACE_ROW_START[i]) / INTERLACE_ROW_INCR[i])
			if w > 0 and h > 0 then
				local scanlineSize = math.ceil(w * channels * bitDepth / 8) + 1
				rawSize += h * scanlineSize
			end
		end
	end

	local paletteColors
	if palette then
		paletteColors = palette.colors
	end

	local rescale
	if colorType ~= 3 and bitDepth < 8 then
		rescale = 0xFF / (2 ^ bitDepth - 1)
	end

	local bpp = math.ceil(channels * bitDepth / 8)
	local defaultAlpha = 2 ^ bitDepth - 1

	local idx = 0
	local working = buffer.create(rawSize)
	local inflatedSize = inflate(compressedData, working)
	assert(inflatedSize == rawSize, "decompressed data size mismatch")

	local rgba8 = buffer.create(width * height * 4)

	local alphaGray = if transparencyData then transparencyData.gray else -1
	local alphaRed = if transparencyData then transparencyData.red else -1
	local alphaGreen = if transparencyData then transparencyData.green else -1
	local alphaBlue = if transparencyData then transparencyData.blue else -1

	local function pass(sx, sy, dx, dy)
		local w = math.ceil((width - sx) / dx)
		local h = math.ceil((height - sy) / dy)
		if w < 1 or h < 1 then
			return
		end

		local scanlineSize = math.ceil(w * channels * bitDepth / 8)
		local newIdx = idx

		for y = 1, h do
			local rowFilter = buffer.readu8(working, idx)
			idx += 1

			if rowFilter == 0 or (rowFilter == 2 and y == 1) then
				idx += scanlineSize
			elseif rowFilter == 1 then
				for x = 1, scanlineSize do
					local sub = if x <= bpp then 0 else buffer.readu8(working, idx - bpp)
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
					local sub = if x <= bpp then 0 else buffer.readu8(working, idx - bpp)
					local up = if y == 1 then 0 else buffer.readu8(working, idx - scanlineSize - 1)
					local value = bit32.band(buffer.readu8(working, idx) + bit32.rshift(sub + up, 1), 0xFF)
					buffer.writeu8(working, idx, value)
					idx += 1
				end
			elseif rowFilter == 4 then
				for x = 1, scanlineSize do
					local sub = if x <= bpp then 0 else buffer.readu8(working, idx - bpp)
					local up = if y == 1 then 0 else buffer.readu8(working, idx - scanlineSize - 1)
					local corner = if x <= bpp or y == 1
						then 0
						else buffer.readu8(working, idx - scanlineSize - bpp - 1)
					local p0 = math.abs(up - corner)
					local p1 = math.abs(sub - corner)
					local p2 = math.abs(sub + up - 2 * corner)
					local paeth = if p0 <= p1 and p0 <= p2 then sub elseif p1 <= p2 then up else corner
					local value = bit32.band(buffer.readu8(working, idx) + paeth, 0xFF)
					buffer.writeu8(working, idx, value)
					idx += 1
				end
			else
				error("invalid row filter")
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

		for y = 1, h do
			newIdx += 1
			if bit < 8 then
				bit = 8
				newIdx += 1
			end

			for x = 1, w do
				local r, g, b, a

				if colorType == 0 then
					local gray = readValue()
					r = gray
					g = gray
					b = gray
					a = if gray == alphaGray then 0 else defaultAlpha
				elseif colorType == 2 then
					r = readValue()
					g = readValue()
					b = readValue()
					a = if r == alphaRed and g == alphaGreen and b == alphaBlue then 0 else defaultAlpha
				elseif colorType == 3 then
					local color = paletteColors[readValue() + 1]
					r = color.r
					g = color.g
					b = color.b
					a = color.a
				elseif colorType == 4 then
					local gray = readValue()
					r = gray
					g = gray
					b = gray
					a = readValue()
				elseif colorType == 6 then
					r = readValue()
					g = readValue()
					b = readValue()
					a = readValue()
				end

				local py = sy + (y - 1) * dy
				local px = sx + (x - 1) * dx
				local i = (py * width + px) * 4

				if rescale then
					r = math.round(r * rescale)
					g = math.round(g * rescale)
					b = math.round(b * rescale)
					a = math.round(a * rescale)
				elseif bitDepth == 16 then
					r = bit32.rshift(r, 8)
					g = bit32.rshift(g, 8)
					b = bit32.rshift(b, 8)
					a = bit32.rshift(a, 8)
				end

				buffer.writeu32(rgba8, i, bit32.bor(bit32.lshift(a, 24), bit32.lshift(b, 16), bit32.lshift(g, 8), r))
			end
		end
	end

	if not header.interlaced then
		pass(0, 0, 1, 1)
	else
		for i = 1, 7 do
			pass(INTERLACE_COL_START[i], INTERLACE_ROW_START[i], INTERLACE_COL_INCR[i], INTERLACE_ROW_INCR[i])
		end
	end

	local function readPixel(x, y)
		assert(x >= 1 and x <= width and y >= 1 and y <= height, "pixel out of range")

		local i = ((y - 1) * width + x - 1) * 4
		return {
			r = buffer.readu8(rgba8, i),
			g = buffer.readu8(rgba8, i + 1),
			b = buffer.readu8(rgba8, i + 2),
			a = buffer.readu8(rgba8, i + 3),
		}
	end

	return {
		width = width,
		height = height,
		pixels = rgba8,
		readPixel = readPixel,
	}
end

return {
	decode = decode,
}
