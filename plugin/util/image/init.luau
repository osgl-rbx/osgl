------------------------------------------------------------
-- OSGL v1.6.2 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
--
-- Free to use, modify and distribute in your projects (including commercial games ;3)
-- Credit appreciated but not required
--
-- Do NOT:
-- - Repackage and sell OSGL directly
-- - Claim you created the core library
--
-- By using OSGL, you agree to these terms.
-- Full license available in the LICENSE file
------------------------------------------------------------

local OSGL = require(script.Parent.Parent.OSGL)
local color = OSGL.color

local bfr = require(script.Parent.Parent.util.buffer)
local const = require(script.Parent.Parent.util.const)

local PNG = require(script.png)
local JPEG = require(script.jpeg)
local BMP = require(script.bmp)

local Image = {}

type FileConvert = {
    asBuffer: (self: FileConvert) -> buffer,
    dimensions: (self: FileConvert) -> (number, number),
    asOSGL: (self: FileConvert) -> string,
}



local function flipBufferUpsideDown(bfr, width, height)
    local pixelCount = width * height
    local flippedBuffer = buffer.create(pixelCount * 4)

    for y = 0, height - 1 do
        local sourceRowStart = y * width
        local targetRowStart = (height - 1 - y) * width

        for x = 0, width - 1 do
            local sourceX = width - 1 - x
            local sourceOffset = (sourceRowStart + sourceX) * 4
            local targetOffset = (targetRowStart + x) * 4
            local pixel = buffer.readu32(bfr, sourceOffset)
            buffer.writeu32(flippedBuffer, targetOffset, pixel)
        end
    end

    return flippedBuffer
end

local function stringToBytes(str: string): { number }
    local bytes = table.create(#str)
    for i = 1, #str do
        bytes[i] = string.byte(str, i)
    end
    return bytes
end

function Image.fileBufferToConvert(
    buff: { readPixel: (x: number, y: number) -> (number, number, number, number) }
): FileConvert
    return {
        dimensions = function()
            return buff.width, buff.height
        end,

        asBuffer = function()
            if buff.bfr then
                return flipBufferUpsideDown(buff.bfr, buff.width, buff.height)
            end

            return buff.pixels
        end,

        asOSGL = function()
            local width, height = buff.width, buff.height
            local indexes = width * height
            local tab = table.create(indexes * 4, "")
            for pixelIndex = 0, indexes - 1 do
                local x = (pixelIndex % width) + 1
                local y = math.floor(pixelIndex / width) + 1

                local R, G, B, A = buff.readPixel(x, y)

                local byteOffset = pixelIndex * 4

                tab[byteOffset + 1] = bfr.toHex(R)
                tab[byteOffset + 2] = bfr.toHex(G)
                tab[byteOffset + 3] = bfr.toHex(B)
                tab[byteOffset + 4] = bfr.toHex(A)
            end

            return `-- Generated with OSGL Image Uploader\n\nreturn \{\n\tversion = "{const.version}",\n\twidth = {width},\n\theight = {height},\n\tpixels = buffer.fromstring("\\x{table.concat(
                tab,
                "\\x"
            )}")\n}`
        end,
    }
end

function Image.loadPNG(file: File): (boolean, FileConvert?)
    local S, R = pcall(function()
        return PNG.decode(buffer.fromstring(file:GetBinaryContents()))
    end)

    if not S then
        return false, nil
    end

    return true, Image.fileBufferToConvert(R)
end

function Image.loadBMP(file: File): (boolean, FileConvert?)
    local S, R = pcall(function()
        return BMP.Parse(file)
    end)

    if not S then
        return false, nil
    end

    return true, Image.fileBufferToConvert(R)
end

function Image.loadJPEG(file: File): (boolean, FileConvert?)
    local S, Res = pcall(function()
        return JPEG.CreateJPEGfromBytes(stringToBytes(file:GetBinaryContents()), false)
    end)

    if not S then
        return false, nil
    end

    Res.width = Res.ImageWidth
    Res.height = Res.ImageHeight

    local buff = buffer.create(Res.width * Res.height * 4)
    for x = 1, Res.width do
        for y = 1, Res.height do
            local R, G, B = Res.GetPixel(x, y)
            local pixelIndex = ((y - 1) * Res.width + (x - 1)) * 4
            buffer.writeu32(buff, pixelIndex, color.newRGB(R, G, B))
        end
    end

    Res.pixels = buff

    function Res.readPixel(x: number, y: number)
        local R, G, B = Res.GetPixel(x, y)
        return R, G, B, 255
    end

    return true, Image.fileBufferToConvert(Res)
end

function Image.load(file: File): (boolean, FileConvert?)
    local extensionTable = string.split(file.Name, ".")
    local extension = string.lower(extensionTable[#extensionTable])

    if extension == "png" then
        return Image.loadPNG(file)
    elseif extension == "bmp" then
        return Image.loadBMP(file)
    elseif extension == "jpeg" or extension == "jpg" then
        return Image.loadJPEG(file)
    end

    return false, nil
end

return Image
