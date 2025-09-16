local JPEG = {}

local HUFFMAN_MODULE = require(script.HuffmanTable)
local BITSTREAM_MODULE = require(script.BitStream)
local util = require(script.Parent.Parent.util)
local ImageError = require(script.Parent.Parent.Parent.Parent.ImageError)
local Result = require(script.Parent.Parent.Parent.Parent.Result)

local RUN_SERVICE = game:GetService("RunService")

local PREVENT_TIMEOUT_INTERVAL = 50

-- Supported modes
local supportedModes =
	{ -- If a mode is not supported (set to false) then the module will simply return and say that the mode isn't supported, in short, it won't bother decoding it.
		[0xC0] = true, -- "Start Of Frame 0"
		[0xC1] = true, -- "Start Of Frame 1"
		[0xC2] = true, -- "Start Of Frame 2"
		[0xC3] = false, -- "Start Of Frame 3"
		[0xC5] = false, -- "Start Of Frame 5"
		[0xC6] = false, -- "Start Of Frame 6"
		[0xC7] = false, -- "Start Of Frame 7"
		[0xC9] = false, -- "Start Of Frame 9"
		[0xCA] = false, -- "Start Of Frame 10"
		[0xCB] = false, -- "Start Of Frame 11"
		[0xCD] = false, -- "Start Of Frame 13"
		[0xCE] = false, -- "Start Of Frame 14"
		[0xCF] = false, -- "Start Of Frame 15"
	}

-- Create idct LUT
local idctTable = {}

local function NormCoeff(n)
	if n == 0 then
		return math.sqrt(1 / 8)
	else
		return math.sqrt(2 / 8)
	end
end

for i = 0, 7 do
	for j = 0, 7 do
		local grid = {}

		for y = 0, 7 do
			for x = 0, 7 do
				local nn = NormCoeff(j) * math.cos(j * math.pi * (x + 0.5) / 8)
				local mm = NormCoeff(i) * math.cos(i * math.pi * (y + 0.5) / 8)

				grid[x * 8 + y + 1] = nn * mm
			end
		end

		idctTable[i * 8 + j + 1] = grid
	end
end

-- Zigzag LUTs
local zigzag1D = {
	1,
	2,
	9,
	17,
	10,
	3,
	4,
	11,
	18,
	25,
	33,
	26,
	19,
	12,
	5,
	6,
	13,
	20,
	27,
	34,
	41,
	49,
	42,
	35,
	28,
	21,
	14,
	7,
	8,
	15,
	22,
	29,
	36,
	43,
	50,
	57,
	58,
	51,
	44,
	37,
	30,
	23,
	16,
	24,
	31,
	38,
	45,
	52,
	59,
	60,
	53,
	46,
	39,
	32,
	40,
	47,
	54,
	61,
	62,
	55,
	48,
	56,
	63,
	64,
}

local zigzag2D = {
	{ 1, 2, 6, 7, 15, 16, 28, 29 },
	{ 3, 5, 8, 14, 17, 27, 30, 43 },
	{ 4, 9, 13, 18, 26, 31, 42, 44 },
	{ 10, 12, 19, 25, 32, 41, 45, 54 },
	{ 11, 20, 24, 33, 40, 47, 53, 55 },
	{ 21, 23, 34, 39, 47, 52, 56, 61 },
	{ 22, 35, 38, 48, 51, 57, 60, 62 },
	{ 36, 37, 49, 50, 58, 59, 63, 64 },
}

-- Useful functions
local function CombineTwoBytes(high, low)
	return bit32.lshift(high, 8) + low
end

local function DecodeNumber(code, bits)
	local l = math.pow(2, code - 1)

	if bits >= l then
		return bits
	else
		return bits - (2 * l - 1)
	end
end

local function BitwiseHandleOverflow(x)
	if x > 4000000000 then
		return x - 4294967296
	else
		return x
	end
end

function JPEG.decode(rawInputBytes)
	local jpeg = {}

	jpeg.ImageData = {}

	jpeg.QuantisationTables = {}
	jpeg.HuffmanDCTables = {}
	jpeg.HuffmanACTables = {}

	jpeg.ImageWidth = 0
	jpeg.ImageHeight = 0

	jpeg.MCUCountX = 0
	jpeg.MCUCountY = 0

	jpeg.MaxVerticalSampleFactor = 0
	jpeg.MaxHorizontalSampleFactor = 0

	jpeg.FrameType = 0 -- The marker from start of frame, e.g 0xC0 = SOF0 (baseline), 0xC2 = SOF2 (progressive)
	jpeg.RestartInterval = 0
	jpeg.Precision = 8

	jpeg.ComponentCount = 0
	jpeg.ColorComponents = {}

	local colorTransform = 0

	local mcus = {}
	local eobRun = 0
	local previousDCs = { 0, 0, 0, 0 }

	local addOneToSelector = false -- Prevents zero index because this is Lua

	-- 'pos' will index the first byte in 'bytes' after the length information

	local function APPn(marker, pos, bytes)
		local payloadLength = CombineTwoBytes(bytes[pos - 2], bytes[pos - 1])

		if marker == 0xEE and payloadLength >= 12 then
			local i = pos

			if
				bytes[i] == 65
				and bytes[i + 1] == 100
				and bytes[i + 2] == 111
				and bytes[i + 3] == 98
				and bytes[i + 4] == 101
			then
				colorTransform = bytes[i + 11]
			end
		end

		return payloadLength
	end

	local function COM(marker, pos, bytes)
		local payloadLength = CombineTwoBytes(bytes[pos - 2], bytes[pos - 1])
		return payloadLength
	end

	local function DQT(marker, pos, bytes)
		local payloadLength = CombineTwoBytes(bytes[pos - 2], bytes[pos - 1])

		local i = 0
		while bytes[pos + i] ~= 0xFF do
			local precision = bit32.rshift(bytes[pos + i], 4)
			local identifier = bit32.band(bytes[pos + i], 0x0F)

			local quant = {}

			if precision == 1 then
				for j = 1, 64 do
					local highByte = bytes[pos + i + 1]
					local lowByte = bytes[pos + i + 2]

					local value = CombineTwoBytes(highByte, lowByte)
					table.insert(quant, value)

					i = i + 2
				end
			else
				for j = 1, 64 do
					i = i + 1
					table.insert(quant, bytes[pos + i])
				end
			end

			-- Add it to the global variable
			jpeg.QuantisationTables[identifier + 1] = quant

			i = i + 1
		end

		return payloadLength
	end

	local function DHT(marker, pos, bytes)
		local payloadLength = CombineTwoBytes(bytes[pos - 2], bytes[pos - 1])

		-- Create huffman table
		local function GetCodesFromLengths(lengths) -- Creates the codes used to traverse the huffman tree given the lengths in the jpeg binary
			local codes = {}

			local codeCandidate = 0

			for bitLength = 1, #lengths do
				local length = lengths[bitLength]

				for i = 1, length do
					table.insert(codes, { codeCandidate, bitLength })

					codeCandidate = codeCandidate + 1
				end

				codeCandidate = bit32.lshift(codeCandidate, 1)
			end

			return codes
		end

		-- Extract class and destination
		local i = 0

		while i < payloadLength - 2 do -- Subtract 2 because payload length includes length information
			local classAndDestination = bytes[pos + i] -- This will be used to index jpeg.HuffmanTables

			local class = bit32.band(bit32.rshift(classAndDestination, 4), 0x0F) -- 0 = DC, 1 = AC
			local destination = bit32.band(classAndDestination, 0x0F) -- 0 = Luminace, 1 = Chrominance

			-- Extract information
			local symbols = {}
			local lengths = {}
			local symbolsSorted = {}

			-- Extract lengths
			for j = 1, 16 do
				i = i + 1
				table.insert(lengths, bytes[pos + i])
			end

			-- Extract symbols
			for j, length in pairs(lengths) do
				symbolsSorted[j] = {}

				for k = 1, length do
					i = i + 1
					local symbol = bytes[pos + i]

					table.insert(symbols, symbol)
					symbolsSorted[j][k] = symbol
				end
			end

			i = i + 1

			for i, info in pairs(GetCodesFromLengths(lengths)) do
				local code = info[1]
				local bitLength = info[2]

				local str = ""
				local c = code

				for i = 1, bitLength do
					local bit = bit32.band(c, 1)
					c = bit32.rshift(c, 1)

					str = str .. bit
				end
			end

			local huffmanTable = HUFFMAN_MODULE.CreateHuffmanTable()
			HUFFMAN_MODULE.ConstructTree(huffmanTable, lengths, symbols)

			if class == 0 then -- DC
				jpeg.HuffmanDCTables[destination + 1] = huffmanTable
			elseif class == 1 then -- AC
				jpeg.HuffmanACTables[destination + 1] = huffmanTable
			end
		end

		return payloadLength
	end

	local function DRI(marker, pos, bytes)
		local payloadLength = CombineTwoBytes(bytes[pos - 2], bytes[pos - 1])

		local interval = CombineTwoBytes(bytes[pos], bytes[pos + 1]) --CombineTwoBytes(bytes[2], bytes[3])
		jpeg.RestartInterval = interval

		return payloadLength
	end

	local function SOFn(marker, pos, bytes)
		if not supportedModes[marker] then
			error("")
		end

		local payloadLength = CombineTwoBytes(bytes[pos - 2], bytes[pos - 1])

		-- Read information
		local precision = bytes[pos]
		local lineNumber = CombineTwoBytes(bytes[pos + 1], bytes[pos + 2]) -- aka height
		local samplesPerLine = CombineTwoBytes(bytes[pos + 3], bytes[pos + 4]) -- aka width
		local componentCount = bytes[pos + 5]

		jpeg.ImageWidth = samplesPerLine
		jpeg.ImageHeight = lineNumber
		jpeg.Precision = precision
		jpeg.ComponentCount = componentCount
		jpeg.FrameType = marker

		jpeg.MCUCountX = math.floor((jpeg.ImageWidth - 1) / 8)
		jpeg.MCUCountY = math.floor((jpeg.ImageHeight - 1) / 8)

		-- Fill in image with blank data
		for x = 1, jpeg.ImageWidth do
			jpeg.ImageData[x] = {}

			for y = 1, jpeg.ImageHeight do
				jpeg.ImageData[x][y] = { 0, 0, 0 }
			end
		end

		-- Create mcus
		for x = 1, jpeg.MCUCountX + 8 do
			mcus[x] = {}
			for y = 1, jpeg.MCUCountY + 8 do
				mcus[x][y] = {}
				for i = 1, componentCount do
					mcus[x][y][i] = table.create(64, 0)
				end
			end
		end

		for id = 0, componentCount - 1 do
			local componentId = bytes[pos + 6 + (id * 3)]
			local sampleFactor = bytes[pos + 7 + (id * 3)]
			local quantTableId = bytes[pos + 8 + (id * 3)]

			if addOneToSelector then
				componentId = componentId + 1
			end

			if componentId == 0 then
				addOneToSelector = true
				componentId = componentId + 1
			end

			local horizontalSample = bit32.band(bit32.rshift(sampleFactor, 4), 0x0F)
			local verticalSample = bit32.band(sampleFactor, 0x0F)

			jpeg.MaxHorizontalSampleFactor = math.max(jpeg.MaxHorizontalSampleFactor, horizontalSample)
			jpeg.MaxVerticalSampleFactor = math.max(jpeg.MaxVerticalSampleFactor, verticalSample)

			jpeg.ColorComponents[componentId] = {}
			jpeg.ColorComponents[componentId].ID = id + 1
			jpeg.ColorComponents[componentId].HorizontalSamplingFactor = horizontalSample
			jpeg.ColorComponents[componentId].VerticalSamplingFactor = verticalSample
			jpeg.ColorComponents[componentId].QuantSelection = quantTableId
		end

		return payloadLength
	end

	local function SOS(marker, pos, bytes)
		local componentCount = bytes[pos]
		local offset = 1

		local loopComponents = {}

		for i = 0, componentCount - 1 do
			local selector = bytes[pos + offset]

			local huffmanId = bytes[pos + offset + 1]
			local DCTableID = bit32.band(bit32.rshift(huffmanId, 4), 0x0F)
			local ACTableID = bit32.band(huffmanId, 0x0F)

			if addOneToSelector then
				selector = selector + 1
			end

			local component = {}
			component.ID = selector
			component.HuffmanDCTableID = DCTableID + 1
			component.HuffmanACTableID = ACTableID + 1
			component.HorizontalSample = jpeg.ColorComponents[selector].HorizontalSamplingFactor
			component.VerticalSample = jpeg.ColorComponents[selector].VerticalSamplingFactor

			local quantSelection = jpeg.ColorComponents[selector].QuantSelection + 1
			component.QuantisationTable = jpeg.QuantisationTables[quantSelection]

			table.insert(loopComponents, component)

			offset = offset + 2
		end

		local successiveApproximation = bytes[pos + offset + 2]
		local ss = bytes[pos + offset] -- Spectral start
		local se = bytes[pos + offset + 1] -- Spectral end
		local ah = bit32.band(bit32.rshift(successiveApproximation, 4), 0x0F) -- Successive Approximation low part of byte
		local al = bit32.band(successiveApproximation, 0x0F) -- Successive Approximation low part of byte

		-- Create scan data by removing stuff bytes and restart markers from inside it
		local scanData = {}

		do
			local i = pos + offset + 2
			local bytesToSkip = 0

			while true do
				i = i + 1

				if bytesToSkip > 0 then
					bytesToSkip = bytesToSkip - 1
					continue
				end

				local byte = bytes[i]
				local nextByte = bytes[i + 1]

				if byte == 0xFF then
					if nextByte >= 0xD0 and nextByte <= 0xD7 then
						bytesToSkip = bytesToSkip + 1
						continue
					elseif nextByte == 0x00 then
						bytesToSkip = bytesToSkip + 1
						table.insert(scanData, byte)
						continue
					else -- Probably another marker
						break
					end
				end

				table.insert(scanData, byte)

				if nextByte == nil then
					break
				end
			end
			
		end

		-- Make bit stream from scan data that will be used for huffman decoding
		local bitStream = BITSTREAM_MODULE.CreateBitStream(scanData)

		local mcuCountX = math.floor((jpeg.ImageWidth - 1) / 8)
		local mcuCountY = math.floor((jpeg.ImageHeight - 1) / 8)

		local maxHorizontalSample = jpeg.MaxHorizontalSampleFactor
		local maxVerticalSample = jpeg.MaxVerticalSampleFactor

		local restartInterval = jpeg.RestartInterval
		local restartCount = restartInterval

		local decodedMCUCount = 0

		-- Function used for decoding individual MCUs in baseline mode
		local function BaselineDecodeMCUComponent(mcu, component)
			-- Decode DC component
			local code = HUFFMAN_MODULE.GetCode(jpeg.HuffmanDCTables[component.HuffmanDCTableID], bitStream)

			local actualID = jpeg.ColorComponents[component.ID].ID
			local prevDC = previousDCs[actualID]

			if prevDC == nil then
				prevDC = 0
			end

			local bits = bitStream.ReadBits(code)
			local dccoeff = DecodeNumber(code, bits) + prevDC

			previousDCs[actualID] = dccoeff -- Set previous DC

			mcu[1] = dccoeff

			local huffmanTable = jpeg.HuffmanACTables[component.HuffmanACTableID]

			-- Decode AC components
			local i = 1
			while i < 64 do
				code = HUFFMAN_MODULE.GetCode(huffmanTable, bitStream)

				if code == 0 then
					return
				end

				if code > 16 then -- AC table
					i = i + bit32.rshift(code, 4) -- Num zeros which we skip
					code = bit32.band(code, 0x0F)
				end

				bits = bitStream.ReadBits(code)

				if i < 64 then
					i = i + 1

					local accoeff = DecodeNumber(code, bits)
					mcu[i] = accoeff
				end
			end
		end

		-- Functions used for decoding parts of individual MCUs in progressive mode
		local function Extend(additional, magnitude)
			local vt = BitwiseHandleOverflow(bit32.lshift(1, magnitude - 1))

			if additional < vt then
				return additional + BitwiseHandleOverflow(bit32.lshift(-1, magnitude)) + 1
			else
				return additional
			end
		end

		local function RefineAC(coeff)
			if coeff > 0 then
				if bitStream.ReadBit() == 1 then
					return coeff + BitwiseHandleOverflow(bit32.lshift(1, al))
				end
			elseif coeff < 0 then
				if bitStream.ReadBit() == 1 then
					return coeff + BitwiseHandleOverflow(bit32.lshift(-1, al))
				end
			end

			return coeff
		end

		local function DecodeDCProgressiveFirstPerBlock(mcu, component)
			local size = HUFFMAN_MODULE.GetCode(jpeg.HuffmanDCTables[component.HuffmanDCTableID], bitStream)
			local bits = bitStream.ReadBits(size)

			local dcValue = Extend(bits, size) + previousDCs[component.ID]
			previousDCs[component.ID] = dcValue -- Set previous DC

			mcu[1] = BitwiseHandleOverflow(bit32.lshift(dcValue, al))
		end

		local function DecodeDCProgressiveRefinePerBlock(mcu, component)
			local bit = bitStream.ReadBit()

			local leftShiftedBit = BitwiseHandleOverflow(bit32.lshift(bit, al))
			mcu[1] = BitwiseHandleOverflow(bit32.bor(mcu[1], leftShiftedBit))
		end

		local function DecodeACProgressiveFirstPerBlock(mcu, component)
			if eobRun > 0 then
				eobRun = eobRun - 1
				return
			end

			local huffmanTable = jpeg.HuffmanACTables[component.HuffmanACTableID]

			local i = ss
			while i <= se do
				local symbol = HUFFMAN_MODULE.GetCode(huffmanTable, bitStream)

				local runLength = bit32.rshift(symbol, 4)
				local size = bit32.band(symbol, 0x0F)

				if size == 0 then
					if runLength == 15 then
						i = i + 16
					else
						eobRun = bitStream.ReadBits(runLength) + math.pow(2, runLength) - 1
						return
					end
				else
					i = i + runLength + 1

					local bits = bitStream.ReadBits(size)

					local value = Extend(bits, size)
					value = bit32.lshift(value, al)
					value = BitwiseHandleOverflow(value)

					mcu[i] = value
				end
			end
		end

		local function DecodeACProgressiveRefinePerBlock(mcu, component)
			local i = ss

			if eobRun > 0 then
				while i <= se do
					if mcu[i + 1] ~= 0 then
						mcu[i + 1] = RefineAC(mcu[i + 1])
					end

					i = i + 1
				end

				eobRun = eobRun - 1
				return
			end

			local huffmanTable = jpeg.HuffmanACTables[component.HuffmanACTableID]

			while i <= se do
				local symbol = HUFFMAN_MODULE.GetCode(huffmanTable, bitStream)

				local runLength = bit32.rshift(symbol, 4)
				local size = symbol % 16

				if size == 1 then
					local value = Extend(bitStream.ReadBits(size), size)
					value = BitwiseHandleOverflow(bit32.lshift(value, al))

					while (runLength > 0 or mcu[i + 1] ~= 0) and i < se do
						i = i + 1

						if mcu[i] ~= 0 then
							mcu[i] = RefineAC(mcu[i])
						else
							runLength = runLength - 1
						end
					end

					i = i + 1
					mcu[i] = value
				elseif size == 0 then
					if runLength < 15 then
						local newEOBrun = bitStream.ReadBits(runLength)
							+ BitwiseHandleOverflow(bit32.lshift(1, runLength))

						while i <= se and i < se do
							i = i + 1

							if mcu[i] ~= 0 then
								mcu[i] = RefineAC(mcu[i])
							end
						end

						eobRun = newEOBrun - 1
						return
					else
						while runLength >= 0 and i < se do
							i = i + 1

							if mcu[i] ~= 0 then
								mcu[i] = RefineAC(mcu[i])
							else
								runLength = runLength - 1
							end
						end
					end
				else
					i = i + 1
				end
			end
		end

		-- Main progressive jpeg decoding functions
		local function DecodeDCProgressiveFirst()
			if componentCount > 1 then -- Interleaved
				for y = 0, mcuCountY, maxVerticalSample do
					for x = 0, mcuCountX, maxHorizontalSample do
						for _, component in pairs(loopComponents) do
							for v = 0, component.VerticalSample - 1 do
								for h = 0, component.HorizontalSample - 1 do
									local mcuX = x + h + 1
									local mcuY = y + v + 1

									DecodeDCProgressiveFirstPerBlock(mcus[mcuX][mcuY][component.ID], component)
								end
							end
						end
					end

					if y % PREVENT_TIMEOUT_INTERVAL == 0 then
							RUN_SERVICE.Stepped:Wait()
						end
				end
			else -- For non-interleaved (one component) we do this
				local component = loopComponents[1]

				for y = 0, mcuCountY, 3 - component.VerticalSample do
					for x = 0, mcuCountX, 3 - component.HorizontalSample do
						local mcuX = x + 1
						local mcuY = y + 1

						DecodeDCProgressiveFirstPerBlock(mcus[mcuX][mcuY][component.ID], component)
					end

					if y % PREVENT_TIMEOUT_INTERVAL == 0 then
							RUN_SERVICE.Stepped:Wait()
						end
				end
			end
		end

		local function DecodeDCProgressiveRefine()
			for y = 0, mcuCountY, maxVerticalSample do
				for x = 0, mcuCountX, maxHorizontalSample do
					for _, component in pairs(loopComponents) do
						local verticalSample = component.VerticalSample
						local horizontalSample = component.HorizontalSample

						for v = 0, verticalSample - 1 do
							for h = 0, horizontalSample - 1 do
								local mcuX = x + h + 1
								local mcuY = y + v + 1

								DecodeDCProgressiveRefinePerBlock(mcus[mcuX][mcuY][component.ID], component)
							end
						end
					end
				end

				if y % PREVENT_TIMEOUT_INTERVAL == 0 then
						RUN_SERVICE.Stepped:Wait()
					end
			end
		end

		local function DecodeACProgressiveFirst()
			local component = loopComponents[1]

			local subtractFromX = 2
			local subtractFromY = 2

			if maxHorizontalSample == 2 then
				subtractFromX = 3
			end
			if maxVerticalSample == 2 then
				subtractFromY = 3
			end

			for y = 0, mcuCountY, subtractFromY - component.VerticalSample do
				for x = 0, mcuCountX, subtractFromX - component.HorizontalSample do
					local mcuX = x + 1
					local mcuY = y + 1

					DecodeACProgressiveFirstPerBlock(mcus[mcuX][mcuY][component.ID], component)
				end

				if y % PREVENT_TIMEOUT_INTERVAL == 0 then
						RUN_SERVICE.Stepped:Wait()
					end
			end
		end

		local function DecodeACProgressiveRefine()
			local component = loopComponents[1]

			local subtractFromX = 2
			local subtractFromY = 2

			if maxHorizontalSample == 2 then
				subtractFromX = 3
			end
			if maxVerticalSample == 2 then
				subtractFromY = 3
			end

			for y = 0, mcuCountY, subtractFromY - component.VerticalSample do
				for x = 0, mcuCountX, subtractFromX - component.HorizontalSample do
					local mcuX = x + 1
					local mcuY = y + 1

					DecodeACProgressiveRefinePerBlock(mcus[mcuX][mcuY][component.ID], component)
				end

				if y % PREVENT_TIMEOUT_INTERVAL == 0 then
						RUN_SERVICE.Stepped:Wait()
					end
			end
		end

		-- Decode baseline jpegs
		if jpeg.FrameType == 0xC0 then
			
			for y = 0, mcuCountY, maxVerticalSample do
				for x = 0, mcuCountX, maxHorizontalSample do
					for i, component in pairs(loopComponents) do
						local componentId = i
						local quantisationTable = component.QuantisationTable
						local horizontalSample = component.HorizontalSample
						local verticalSample = component.VerticalSample

						for v = 0, verticalSample - 1 do
							for h = 0, horizontalSample - 1 do
								local mcuX = x + h + 1
								local mcuY = y + v + 1

								BaselineDecodeMCUComponent(mcus[mcuX][mcuY][componentId], component)
							end
						end

						decodedMCUCount = decodedMCUCount + (verticalSample * horizontalSample)
					end

					-- Restart Interval
					if restartInterval ~= 0 then
						restartCount = restartCount - 1

						if restartCount == 0 then
							restartCount = restartInterval

							previousDCs = { 0, 0, 0 }
							bitStream.Align()
						end
					end
				end

				-- if y % PREVENT_TIMEOUT_INTERVAL == 0 then
				-- 		RUN_SERVICE.Stepped:Wait()
				-- 	end
			end
		end

		-- Decode progressive jpegs
		if jpeg.FrameType == 0xC2 then
			-- Validation checks
			-- Decode
			if ss == 0 and se == 0 then
				if ah == 0 then
					DecodeDCProgressiveFirst()
				else
					DecodeDCProgressiveRefine()
				end
			else
				if ah == 0 then
					DecodeACProgressiveFirst()
				else
					DecodeACProgressiveRefine()
				end
			end
		end
	end

	local markerProcedures = {
		[0xC0] = SOFn, -- SOF0  [Baseline DCT]
		[0xC1] = SOFn, -- SOF1  [Extended Sequential DCT]
		[0xC2] = SOFn, -- SOF2  [Progressive DCT]
		[0xC3] = SOFn, -- SOF3  [Lossless (sequential)]
		[0xC4] = DHT, -- DHT   [Define Huffman Table]
		[0xC5] = SOFn, -- SOF5  [Differential sequential DCT]
		[0xC6] = SOFn, -- SOF6  [Differential progressive DCT]
		[0xC7] = SOFn, -- SOF7  [Differential lossless (sequential)]
		[0xC8] = "Print", -- JPG   [Reserved for JPEG extensions]
		[0xC9] = SOFn, -- SOF9  [Extended sequential DCT]
		[0xCA] = SOFn, -- SOF10 [Progressive DCT]
		[0xCB] = SOFn, -- SOF11 [Lossless (sequential)]
		[0xCC] = "Print", -- DAC   [Define arithmetic coding conditioning(s)]
		[0xCD] = SOFn, -- SOF13 [Differential sequential DCT]
		[0xCE] = SOFn, -- SOF14 [Differential progressive DCT]
		[0xCF] = SOFn, -- SOF15 [Differential lossless (sequential)]
		[0xD0] = "Print", -- RSTm* [Restart with modulo 8 count "m"]
		[0xD1] = "Print", -- RSTm* [Restart with modulo 8 count "m"]
		[0xD2] = "Print", -- RSTm* [Restart with modulo 8 count "m"]
		[0xD3] = "Print", -- RSTm* [Restart with modulo 8 count "m"]
		[0xD4] = "Print", -- RSTm* [Restart with modulo 8 count "m"]
		[0xD5] = "Print", -- RSTm* [Restart with modulo 8 count "m"]
		[0xD6] = "Print", -- RSTm* [Restart with modulo 8 count "m"]
		[0xD7] = "Print", -- RSTm* [Restart with modulo 8 count "m"]
		[0xD8] = "Print", -- SOI  [Start of image]
		[0xD9] = "Print", -- EOI  [End of image]
		[0xDA] = SOS, -- SOS   [Start of scan]
		[0xDB] = DQT, -- DQT   [Define quantisation table(s)]
		[0xDC] = "Print", -- DNL   [Define number of lines]
		[0xDD] = DRI, -- DRI   [Define restart interval]
		[0xDE] = "Print", -- DHP   [Define hierarchical progression]
		[0xDF] = "Print", -- EXP   [Expand reference components(s)]
		[0xE0] = APPn, -- APP0  [Application segments 0xE0->0xEF]
		[0xE1] = APPn, -- APP1
		[0xE2] = APPn, -- APP2
		[0xE3] = APPn, -- APP3
		[0xE4] = APPn, -- APP4
		[0xE5] = APPn, -- APP5
		[0xE6] = APPn, -- APP6
		[0xE7] = APPn, -- APP7
		[0xE8] = APPn, -- APP8
		[0xE9] = APPn, -- APP9
		[0xEA] = APPn, -- APP10
		[0xEB] = APPn, -- APP11
		[0xEC] = APPn, -- APP12
		[0xED] = APPn, -- APP13
		[0xEE] = APPn, -- APP14
		[0xEF] = APPn, -- APP15
		[0xF0] = "Print", -- JPG0  [JPG segments 0xF0->0xFD]
		[0xF1] = "Print", -- JPG1
		[0xF2] = "Print", -- JPG2
		[0xF3] = "Print", -- JPG3
		[0xF4] = "Print", -- JPG4
		[0xF5] = "Print", -- JPG5
		[0xF6] = "Print", -- JPG6
		[0xF7] = "Print", -- JPG7
		[0xF8] = "Print", -- JPG8
		[0xF9] = "Print", -- JPG9
		[0xFA] = "Print", -- JPG10
		[0xFB] = "Print", -- JPG11
		[0xFC] = "Print", -- JPG12
		[0xFD] = "Print", -- JPG13
		[0xFE] = COM, -- COM [Comment]
	}

	local bytes = rawInputBytes
	local skipCount = 0

	local scanCount = 0

	for pos = 1, #bytes - 1 do
		local byte = bytes[pos]
		local nextByte = bytes[pos + 1]

		if skipCount > 0 then
			skipCount = skipCount - 1
			continue
		end

		if byte ~= 0xFF then -- Skip unless there is a possible marker, scanning and stuff will be dealt with inside functions
			continue
		end

		if nextByte == 0x00 then
			continue
		end
		
		-- nextByte is the marker
		
		local procedure = markerProcedures[nextByte]

		if procedure == nil then
			continue
		elseif type(procedure) == "string" then
			continue
		end

		-- Procedure

		local returnValue = procedure(nextByte, pos + 4, bytes)

		if returnValue then
			-- Return incase jpeg is not supported
			if returnValue == type("table") and not returnValue.isOk then
				return returnValue
			elseif type(returnValue) == "number" then
				-- Skip bytes
				skipCount = skipCount + returnValue
			end
		end

		-- For debugging
		if nextByte == 0xDA then
			scanCount = scanCount + 1
		end

		if scanCount == 1000000 then
			break
		end
	end

	local iLimit = (8 * jpeg.MaxVerticalSampleFactor) - 1
	local jLimit = (8 * jpeg.MaxHorizontalSampleFactor) - 1

	local subtractFromX = 2
	local subtractFromY = 2

	if jpeg.MaxHorizontalSampleFactor == 2 then
		subtractFromX = 3
	end
	if jpeg.MaxVerticalSampleFactor == 2 then
		subtractFromY = 3
	end

	for component, _ in pairs(jpeg.ColorComponents) do
		local actualID = jpeg.ColorComponents[component].ID
		local componentHorizontalSample = jpeg.ColorComponents[component].HorizontalSamplingFactor
		local componentVerticalSample = jpeg.ColorComponents[component].VerticalSamplingFactor
		local quantSelection = jpeg.ColorComponents[component].QuantSelection
		local quantisationTable = jpeg.QuantisationTables[quantSelection + 1]

		for y = 0, jpeg.MCUCountY, jpeg.MaxVerticalSampleFactor do
			for x = 0, jpeg.MCUCountX, jpeg.MaxHorizontalSampleFactor do
				for v = 0, componentVerticalSample - 1 do
					for h = 0, componentHorizontalSample - 1 do
						local mcuX = x + h + 1
						local mcuY = y + v + 1

						-- IDCT
						local decodedMCU = table.create(64, 0)

						for i, influence in pairs(mcus[mcuX][mcuY][actualID]) do
							if influence == 0 then
								continue
							end

							if i > 64 then
								break
							end

							local zigzagIndex = zigzag1D[i]
							local quantisedInfluence = influence * quantisationTable[i]

							local idctLUT = idctTable[zigzagIndex]

							for j = 1, 64 do
								decodedMCU[j] = decodedMCU[j] + (idctLUT[j] * quantisedInfluence)
							end
						end

						-- Fill in pixel image
						for i = 0, iLimit do
							for j = 0, jLimit do
								local pixelX = (mcuX - 1) * 8 + j + 1
								local pixelY = (mcuY - 1) * 8 + i + 1

								if pixelX <= jpeg.ImageWidth and pixelY <= jpeg.ImageHeight then
									local ii = math.floor(i / (subtractFromY - componentVerticalSample))
									local jj = math.floor(j / (subtractFromX - componentHorizontalSample))

									local index = jj * 8 + ii + 1

									jpeg.ImageData[pixelX][pixelY][actualID] = decodedMCU[index]
								end
							end
						end
					end
				end
			end

			-- if y % PREVENT_TIMEOUT_INTERVAL == 0 then
			-- 	RUN_SERVICE.Stepped:Wait()
			-- end
		end
	end

    local bfr = buffer.create(jpeg.ImageWidth * jpeg.ImageHeight * 4)
	for x = 1, jpeg.ImageWidth do
		for y = 1, jpeg.ImageHeight do
			if jpeg.ComponentCount == 3 then
				local lum = jpeg.ImageData[x][y][1]
				local cb = jpeg.ImageData[x][y][2]
				local cr = jpeg.ImageData[x][y][3]

				local r = lum + 1.402 * cr + 128
				local g = lum - 0.34414 * cb - 0.71414 * cr + 128
				local b = lum + 1.772 * cb + 128

				r = math.floor(math.clamp(r, 0, 255))
				g = math.floor(math.clamp(g, 0, 255))
				b = math.floor(math.clamp(b, 0, 255))

                buffer.writeu32(bfr, ((y-1) * (jpeg.ImageWidth) + (x-1))*4, util.createRGBAColor(r, g, b))
			elseif jpeg.ComponentCount == 4 then
				local c = jpeg.ImageData[x][y][1]
				local m = jpeg.ImageData[x][y][2]
				local Y = jpeg.ImageData[x][y][3]
				local k = jpeg.ImageData[x][y][4]

				local r, g, b

				if colorTransform == 2 or colorTransform == 1 then
					r = c + 1.402 * Y + 128
					g = c - 0.34414 * m - 0.71414 * Y + 128
					b = c + 1.772 * m + 128

					r = math.clamp(r, 0, 255)
					g = math.clamp(g, 0, 255)
					b = math.clamp(b, 0, 255)

					r = (255 - r) * ((k + 128) / 255)
					g = (255 - g) * ((k + 128) / 255)
					b = (255 - b) * ((k + 128) / 255)
				elseif colorTransform == 0 then
					r = (c + 128) * ((k + 128) / 255)
					g = (m + 128) * ((k + 128) / 255)
					b = (Y + 128) * ((k + 128) / 255)
				end

				r = math.floor(r)
				g = math.floor(g)
				b = math.floor(b)

                buffer.writeu32(bfr, ((y-1) * (jpeg.ImageWidth-1) + (x-1))*4, util.createRGBAColor(r, g, b))
			end
		end
	end
	
	return Result.okSmall(bfr)
end

return JPEG
