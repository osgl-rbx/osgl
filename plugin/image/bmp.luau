--PoptartNoahh & Sceptive

local BMP = {}

local Bin = {
    get = function(n: number)
        local s = ""

        while n ~= 0 do
            s = (n % 2) .. s
            n = math.floor(n / 2)
        end

        return s
    end,
    reverse = function(s: string)
        local n = 0

        s = string.reverse(s)
        for i = 1, #s do
            n += (if string.byte(s) == 49 then 1 else 0) * math.pow(2, i - 1)
        end

        return n
    end,
}

function BMP.Parse(file: File)
    local self = {}
    local contents = file
    if typeof(file) == "Instance" then
        if file:IsA("File") then
            contents = file:GetBinaryContents()
        end
    end

    local function fileSeek(position: number)
        return contents:byte(position)
    end

    local function makeHeader(offset)
        return tonumber("0x" .. string.format("%x", fileSeek(offset + 2)) .. ("%x"):format(fileSeek(offset + 1)))
    end

    self.file_size = makeHeader(0x02)
    self.bitmap_offset = makeHeader(0x0A)
    self.width, self.height = makeHeader(0x12), makeHeader(0x16)
    self.bpp = makeHeader(0x1C)
    self.image = {}
    for x = 1, self.width do
        self.image[x] = {}
    end
    self.packet_size = self.bpp / 8
    self.padding = (4 - (self.width * self.packet_size) % 4) % 4
    self.palette = {}
    if self.bpp <= 8 then
        for i = 0, 2 ^ self.bpp - 1 do
            local offset = 0x36 + 4 * i + 1
            table.insert(self.palette, Color3.fromRGB(fileSeek(offset + 2), fileSeek(offset + 1), fileSeek(offset)))
        end
    end
    local bitmap_encoding = {
        [32] = function(position)
            return fileSeek(position + 3), fileSeek(position + 2), fileSeek(position + 1),
                fileSeek(position + 4) or 1
        end,
        [24] = function(position)
            return fileSeek(position + 3), fileSeek(position + 2), fileSeek(position + 1), 1
        end,
        [16] = function(position)
            local rgb, byte = {}, Bin.get(fileSeek(position + 2)) .. Bin.get(fileSeek(position + 1))
            for i = 0, 2 do
                local offset = 2 + i * 5
                rgb[i + 1] = Bin.reverse(string.sub(byte, offset, offset + 4)) / 31
            end

            return unpack(rgb), 1
        end,

        [8] = function(position)
            return self.palette[fileSeek(position + 1) + 1]
        end,

        [4] = function(position)
            local byte = Bin.get(fileSeek(position + 1))
            return self.palette[(position % math.floor(position) == 0 and Bin.reverse(byte:sub(1, 4)) or Bin.reverse(
                byte:sub(5, 9)
            )) + 1]
        end,
        [1] = function(position)
            return Bin.get(fileSeek(position + 1)):byte((position % math.floor(position) * 8) + 1) == 49
                    and 1, 1, 1, 1
                or 0, 0, 0, 1
        end,
    }

    local get_encoding = bitmap_encoding[self.bpp]
    if get_encoding then
        local pixels, i = 0, self.bitmap_offset
        self.bfr = buffer.create(self.width * self.height * 4)

        for _ = self.bitmap_offset, self.width * self.packet_size * self.height + self.bitmap_offset - self.packet_size, self.packet_size do
            local r, g, b, a = get_encoding(i)
            pixels += 1

			a = a or 1

			if typeof(r) == "Color3" then
				r, g, b = r.R, r.G, r.B
				a = 1
			end

			r *= 255
			g *= 255
			b *= 255
			a *= 255

            local x = self.width - (pixels - 1) % self.width
            local y = math.ceil(pixels / self.width)

            local pixelBufferOffset = ((y - 1) * self.width + (x - 1)) * 4

            buffer.writeu8(self.bfr, pixelBufferOffset, r)
            buffer.writeu8(self.bfr, pixelBufferOffset + 1, g)
            buffer.writeu8(self.bfr, pixelBufferOffset + 2, b)
            buffer.writeu8(self.bfr, pixelBufferOffset + 3, a)

            i += self.packet_size
            if pixels % self.width == 0 then
                i += self.padding
            end
        end
    else
        error("Invalid BMP.")
    end

    local width, height = self.width, self.height

    self.readPixel = function(x, y)
        local inverted_y = height - y
        local i = ((inverted_y) * width + (width - x)) * 4
		local buff = self.bfr

        return buffer.readu8(buff, i),
		buffer.readu8(buff, i + 1),
		buffer.readu8(buff, i + 2),
		buffer.readu8(buff, i + 3)
    end

    return self
end

return BMP

--[[
	local Image = BMP.Parse(file)
	for x = 1, Image.Width do
		for y = 1, Image.Height do
			local color, alpha = Image.Pixel(x, y)
			if alpha then
				local transparency = 1 - alpha
			end
		end
	end
]]
