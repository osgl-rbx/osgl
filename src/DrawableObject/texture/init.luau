--!optimize 2
--!native

------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
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

type Result<T, E> = result.Result<T, E>

local round = math.round

local Texture = {}

local function drawRotated<T>(
    object: types.DrawableObject<T>,
    texture: types.OSGLTexture,
    textureX: number, -- top-left dest position where the texture would normally draw
    textureY: number,
    rotation: number
)
    local pixel = object.Pixel

    local objW, objH = object.width, object.height
    local texW, texH = texture.width, texture.height
    local bfr = texture.buffer

    local radians = math.rad(rotation)
    local cosR = math.cos(radians)
    local sinR = math.sin(radians)

    local centerX = textureX + texW / 2
    local centerY = textureY + texH / 2

    local destX0 = textureX
    local destY0 = textureY
    local destX1 = textureX + texW - 1
    local destY1 = textureY + texH - 1

    if destX0 < 0 then destX0 = 0 end
    if destY0 < 0 then destY0 = 0 end
    if destX1 >= objW then destX1 = objW - 1 end
    if destY1 >= objH then destY1 = objH - 1 end

    for dy = destY0, destY1 do
        for dx = destX0, destX1 do
            local relX = dx - centerX
            local relY = dy - centerY

            local sxWorld =  cosR * relX + sinR * relY + centerX
            local syWorld = -sinR * relX + cosR * relY + centerY

            local sx = sxWorld - textureX
            local sy = syWorld - textureY

            if sx >= 0 and sx < texW and sy >= 0 and sy < texH then
                local isx = round(sx)
                local isy = round(sy)
                if isx >= 0 and isx < texW and isy >= 0 and isy < texH then
                    local idx = (isy * texW + isx) * 4
                    local pixelColor = buffer.readu32(bfr, idx)
                    pixel(object, dx, dy, pixelColor)
                end
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
    local pixel = object.Pixel

    local texW, texH = texture.width, texture.height
    local bfr = texture.buffer

    local radians = math.rad(rotation)
    local cosR = math.cos(radians)
    local sinR = math.sin(radians)

    local centerX = textureX + texW / 2
    local centerY = textureY + texH / 2

    for dy = textureY, textureY + texH - 1 do
        for dx = textureX, textureX + texW - 1 do
            local relX = dx - centerX
            local relY = dy - centerY

            local sx =  cosR * relX + sinR * relY + texW / 2
            local sy = -sinR * relX + cosR * relY + texH / 2

            local isx = math.floor(sx + 0.5)
            local isy = math.floor(sy + 0.5)

            local idx = (isy * texW + isx) * 4
            local pixelColor = buffer.readu32(bfr, idx)
            pixel(object, dx, dy, pixelColor)
        end
    end
end

local function checkUnloadedTexture(
    unloadedTexture: types.RawTexture
): Result<types.BaseRawTexture, oEnum.TextureError>
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
function Texture.fromUnchecked(rawTexture: types.BaseRawTexture): types.OSGLTexture
    local width, height, pixels = rawTexture.get()
    local t = base.new()

    t.buffer = pixels
    t.width = width
    t.height = height
    t.size = Vector2.new(width, height)
    t.Free = function()
        t.buffer = nil
        pixels = nil
        rawTexture.free()
    end

    t.Load = function()
        t.width, t.height, t.buffer = rawTexture.get()
    end

    pixels = nil

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
function Texture.serializeUnchecked(rawTexture: types.BaseRawTexture): (buffer, number, number)
    local width, height, pixels = rawTexture.get()
    return pixels, width, height
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
