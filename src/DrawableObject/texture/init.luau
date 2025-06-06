--!optimize 2
--!native

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

local AssetService = game:GetService("AssetService")
local HttpService = game:GetService("HttpService")

local DrawableObject = script.Parent
local base = require(DrawableObject.base)
local stringCompressor = require(script.canvasDrawStringCompressor)

local OSGL = DrawableObject.Parent
local types = require(OSGL.types)
local result = require(OSGL.result)
local oEnum = require(OSGL.enums)
local util = require(OSGL.util)
local draw = require(OSGL.draw)
local pixel = draw.Pixel

type Result<T, E> = result.Result<T, E>

local floor = math.floor

local Texture = {}

local function drawRotated<T>(
    object: types.DrawableObject<T>,
    texture: types.OSGLTexture,
    textureX: number,
    textureY: number,
    rotation: number
)
    local sizeY = texture.height
    local sizeX = texture.width
    local bfr = texture.buffer

    local radians = math.rad(rotation)
    local cosR = math.cos(radians)
    local sinR = math.sin(radians)

    local centerX = textureX + sizeX / 2
    local centerY = textureY + sizeY / 2

    local function rotate(x: number, y: number): number
        local relX = x - centerX
        local relY = y - centerY

        local rotatedX = cosR * relX - sinR * relY
        local rotatedY = sinR * relX + cosR * relY

        return rotatedX + centerX, rotatedY + centerY
    end

    for y = 0, sizeY - 1 do
        for x = 0, sizeX - 1 do
            x += textureX
            y += textureY

            local sourceX, sourceY = rotate(x, y)

            if sourceX >= 0 and sourceX < sizeX and sourceY >= 0 and sourceY < sizeY then
                local pixelColor = buffer.readu32(bfr, floor(sourceY) * sizeX * 4 + floor(sourceX) * 4)
                pixel(object, x, y, pixelColor)
            end
        end
    end
end

local function drawRotatedUnchecked<T>(
    object: types.DrawableObject<T>,
    texture: types.OSGLTexture,
    textureX: number,
    textureY: number,
    rotation: number
)
    local sizeY = texture.height
    local sizeX = texture.width
    local bfr = texture.buffer

    local radians = math.rad(rotation)
    local cosR = math.cos(radians)
    local sinR = math.sin(radians)

    local centerX = textureX + sizeX / 2
    local centerY = textureY + sizeY / 2

    local function rotate(x: number, y: number): number
        local relX = x - centerX
        local relY = y - centerY

        local rotatedX = cosR * relX - sinR * relY
        local rotatedY = sinR * relX + cosR * relY

        return rotatedX + centerX, rotatedY + centerY
    end

    for y = 0, sizeY - 1 do
        for x = 0, sizeX - 1 do
            x += textureX
            y += textureY

            local sourceX, sourceY = rotate(x, y)

            local pixelColor = buffer.readu32(bfr, floor(sourceY) * sizeX * 4 + floor(sourceX) * 4)
            pixel(object, x, y, pixelColor)
        end
    end
end

local function checkUnloadedTexture(
    unloadedTexture: types.RawTexture
): Result<types.BaseUnloadedTexture, oEnum.TextureError>
    if typeof(unloadedTexture) == "Instance" and unloadedTexture:IsA("ModuleScript") then
        unloadedTexture = require(unloadedTexture)
    end

    if type(unloadedTexture) ~= "table" or not table.find(util.VALID_TEXTURE_VERSIONS, unloadedTexture.version) then
        return result.new(false, oEnum.TextureError.BadInput)
    end

    return result.new(true, unloadedTexture)
end

--[=[
<strong>@OSGL/Texture</strong>
<strong>@Checked</strong>
<em>Creates a </em><code>Texture</code><em> from raw data.</em>
  ]=]
function Texture.fromChecked(rawTexture: types.RawTexture): Result<types.OSGLTexture, oEnum.TextureError>
    local raw = checkUnloadedTexture(rawTexture)

    if not raw.isOk then
        return raw
    end

    return result.new(true, Texture.fromUnchecked(raw:Unwrap()))
end

--[=[
<strong>@OSGL/Texture</strong>
<strong>@Unchecked!</strong>
<em>Creates a </em><code>Texture</code><em> from an unloaded one.</em>
  ]=]
function Texture.fromUnchecked(rawTexture: types.BaseUnloadedTexture): types.OSGLTexture
    local width, height = rawTexture.width, rawTexture.height

    local t = base.new()

    t.buffer = rawTexture.pixels
    t.width = width
    t.height = height
    t.size = Vector2.new(width, height)

    return t
end

--[=[
<strong>@OSGL/Texture</strong>
<strong>@Checked</strong>
<em>Serializes the </em><code>Texture</code><em>.</em>
  ]=]
function Texture.serializeChecked(rawTexture: types.RawTexture): Result<(buffer, number, number), oEnum.TextureError>
    local texture = checkUnloadedTexture(rawTexture)

    if not texture.isOk then
        return rawTexture
    end

    return result.new(true, Texture.serializeUnchecked(texture:Unwrap()))
end

--[=[
<strong>@OSGL/Texture</strong>
<strong>@Unchecked!</strong>
<em>Serializes the </em><code>Texture</code><em>.</em>
  ]=]
function Texture.serializeUnchecked(rawTexture: types.BaseUnloadedTexture): (buffer, number, number)
    return rawTexture.pixels, rawTexture.width, rawTexture.height
end

--[=[
<strong>@OSGL/Texture</strong>
<strong>@Checked</strong>
<em>Draws the </em><code>Texture</code><em> somwhere.</em>
  ]=]
function Texture.drawChecked<T>(
    object: types.DrawableObject<T>,
    texture: types.OSGLTexture,
    textureX: number,
    textureY: number,
    rotation: number?
)
    rotation = rotation or 0

    if rotation == 0 then
        local xOffset = if textureX < 0 then math.abs(textureX) else 0
        local yOffset = if textureY < 0 then math.abs(textureY) else 0

        texture.width -= xOffset
        texture.height -= yOffset

        local drawWidth = math.min(texture.width, object.width - textureX - xOffset)
        local drawHeight = math.min(texture.height, object.height - textureY - yOffset)
        
        if drawWidth <= 0 or drawHeight <= 0 then
            return
        end

        local targetBuffer = object.buffer
        local sourceBuffer = texture.buffer
        local targetSize = texture.width * 4

        local maxY = if textureY + drawHeight - 1 > object.height
            then object.height - textureY - 1 
            else drawHeight - 1

        for y = yOffset, maxY do
            buffer.copy(
                targetBuffer,
                ((textureY + y) * object.width + textureX + xOffset) * 4,
                sourceBuffer,
                (y * (texture.width + xOffset)) * 4,
                drawWidth * 4
            )
        end
        
        texture.width += xOffset
        texture.height += yOffset
    else
        drawRotated(object, texture, textureX, textureY, rotation)
    end
end

--[=[
<strong>@OSGL/Texture</strong>
<strong>@Unchecked!</strong>
<em>Draws the </em><code>Texture</code><em> somwhere.</em>
  ]=]
function Texture.drawUnchecked<T>(
    object: types.DrawableObject<T>,
    texture: types.OSGLTexture,
    textureX: number,
    textureY: number,
    rotation: number?
)
    rotation = rotation or 0

    if rotation == 0 then
        Texture.drawChecked(object, texture, textureX, textureY, rotation)
    else
        drawRotatedUnchecked(object, texture, textureX, textureY, rotation)
    end
end

--[=[
<strong>@OSGL/Texture</strong>
<em>Creates a </em><code>Texture</code><em> from an asset id.</em>
  ]=]
function Texture.fromAssetId(assetId: number): Result<types.OSGLTexture, oEnum.DrawableObjectError>
    local newContent = Content.fromAssetId(assetId)

    local temporaryEditableImage = AssetService:CreateEditableImageAsync(newContent)
    if not temporaryEditableImage then
        return result.new(false, oEnum.DrawableObjectError.NotEnoughMemory)
    end

    local size = temporaryEditableImage.Size
    local width, height = size.X, size.Y

    local pixelBuffer = temporaryEditableImage:ReadPixelsBuffer(Vector2.zero, size)
    temporaryEditableImage:Destroy()

    local t = base.new()

    t.buffer = pixelBuffer
    t.width = width
    t.height = height
    t.size = Vector2.new(width, height)

    return result.new(true, t)
end

--[=[
<strong>@OSGL/Texture</strong>
<strong>@Checked</strong>
<em>Loads a CanvasDraw </em><code>SaveObject</code><em> as an OSGL </em><code>Texture</code><em>.</em>
  ]=]
function Texture.fromCanvasDrawSaveObject(
    saveObject: Instance,
    slowLoad: boolean?
): Result<types.OSGLTexture, oEnum.TextureError>
    local isV4Point9AndAbove = saveObject:GetAttribute("Resolution")
        and not saveObject:GetAttribute("Colour")
        and not saveObject:GetAttribute("Alpha")
    local isFromV4Point4ToV4Point8 = saveObject:GetAttribute("Colour")
        and saveObject:GetAttribute("Alpha")
        and saveObject:GetAttribute("Resolution")
    local isFromV2ToV4Point3 = saveObject:GetAttribute("ImageColours")
        and saveObject:GetAttribute("ImageAlphas")
        and saveObject:GetAttribute("ImageResolution")

    if
        not saveObject
        or typeof(saveObject) ~= "Instance"
        or not isV4Point9AndAbove and not isFromV4Point4ToV4Point8 and not isFromV2ToV4Point3
    then
        return result.new(false, oEnum.TextureError.BadInput)
    end

    -- Extracts taken from CanvasDraw/SaveObjectReader.luau by EthanTheGrand
    local width, height, bfr
    if isV4Point9AndAbove then
        local resolution = saveObject:GetAttribute("Resolution")
        width, height = resolution.X, resolution.Y

        bfr = buffer.create(width * height * 4)
        local currentBufferIndex = 0

        -- Decompress the data
        local chunkCount = #saveObject:GetChildren()

        for i = 1, chunkCount do
            local chunkString = saveObject["Chunk" .. i]
            local array = HttpService:JSONDecode(stringCompressor.Decompress(chunkString.Value))

            for j = 1, #array do
                buffer.writeu8(bfr, currentBufferIndex, array[j])
                currentBufferIndex += 1
            end

            if slowLoad then
                task.wait()
            end
        end
    elseif isFromV4Point4ToV4Point8 then
        local compressedRGB = saveObject:GetAttribute("Colour")
        local compressedAlpha = saveObject:GetAttribute("Alpha")
        local resolution = saveObject:GetAttribute("Resolution")
        width, height = resolution.X, resolution.Y

        -- Decompress the data
        local RGBArray = HttpService:JSONDecode(stringCompressor.Decompress(compressedRGB))
        local alphaArray = HttpService:JSONDecode(stringCompressor.Decompress(compressedAlpha))

        bfr = buffer.create(width * height * 4)

        for i = 1, width * height do
            local RGBIndex = i * 3 - 2
            local bfrIndex = i * 4 - 4

            buffer.writeu8(bfr, bfrIndex, RGBArray[RGBIndex])
            buffer.writeu8(bfr, bfrIndex + 1, RGBArray[RGBIndex + 1])
            buffer.writeu8(bfr, bfrIndex + 2, RGBArray[RGBIndex + 2])
            buffer.writeu8(bfr, bfrIndex + 3, alphaArray[i])
        end
    else
        local saveDataImageColours = saveObject:GetAttribute("ImageColours")
        local saveDataImageAlphas = saveObject:GetAttribute("ImageAlphas")
        local saveDataImageResolution = saveObject:GetAttribute("ImageResolution")

        width, height = saveDataImageResolution.X, saveDataImageResolution.Y

        -- Decompress the data
        local decompressedSaveDataImageColours = stringCompressor.Decompress(saveDataImageColours)
        local decompressedSaveDataImageAlphas = stringCompressor.Decompress(saveDataImageAlphas)

        -- Get a single pixel colour info form the data
        local pixelDataColoursString = string.split(decompressedSaveDataImageColours, "S")
        local pixelDataAlphasString = string.split(decompressedSaveDataImageAlphas, "S")

        bfr = buffer.create(saveDataImageResolution.X * saveDataImageResolution.Y * 4)

        for i, pixelColourString in pairs(pixelDataColoursString) do
            local RGBValues = string.split(pixelColourString, ",")
            local R, G, B = table.unpack(RGBValues)
            local A = tonumber(pixelDataAlphasString[i])

            local index = i * 4 - 4

            buffer.writeu8(bfr, index, R)
            buffer.writeu8(bfr, index + 1, G)
            buffer.writeu8(bfr, index + 2, B)
            buffer.writeu8(bfr, index + 3, A)
        end
    end

    return result.new(true, Texture.new(width, height, bfr):Unwrap())
end

--[=[
<strong>@OSGL/Texture</strong>
<em>Creates a new </em><code>Texture</code><em> from the data provided.</em>
  ]=]
function Texture.new(width: number, height: number, bfr: buffer?): Result<types.OSGLTexture, oEnum.DrawableObjectError>
    local len = width * height * 4
    local buff = bfr or buffer.create(len)

    if buffer.len(buff) ~= len then
        return result.new(false, oEnum.DrawableObjectError.BadBufferSize)
    end

    local t = base.new()
    t.width = width
    t.height = height
    t.buffer = buff

    return result.new(true, t)
end

return Texture
