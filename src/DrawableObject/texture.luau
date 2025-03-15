local AssetService = game:GetService("AssetService")

local DrawableObject = script.Parent
local base = require(DrawableObject.base)

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
	texture: types.Texture,
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

local function checkUnloadedTexture(unloadedTexture: types.RawTexture): Result<types.BaseUnloadedTexture, oEnum.TextureError>
	if typeof(unloadedTexture) == "Instance" and unloadedTexture:IsA("ModuleScript") then
		unloadedTexture = require(unloadedTexture)
	end

	if type(unloadedTexture) ~= "table" or not table.find(util.VALID_TEXTURE_VERSIONS, unloadedTexture.version) then
		return result.new(false, oEnum.TextureError.BadInput)
	end

	return result.new(true, unloadedTexture)
end

function Texture.fromChecked(rawTexture: types.RawTexture): Result<types.Texture, oEnum.TextureError>
	local raw = checkUnloadedTexture(rawTexture)

	if not raw.isOk then
		return raw
	end

	return result.new(true, Texture.fromUnchecked(raw:Unwrap()))
end

function Texture.fromUnchecked(rawTexture: types.BaseUnloadedTexture): types.Texture
	local width, height = rawTexture.width, rawTexture.height

	local t = base.new()

	t.buffer = rawTexture.pixels
	t.width = width
	t.height = height
	t.size = Vector2.new(width, height)

	return t
end

function Texture.serializeChecked(rawTexture: types.RawTexture): Result<(buffer, number, number), oEnum.TextureError>
	local texture = checkUnloadedTexture(rawTexture)

	if not texture.isOk then
		return rawTexture
	end

	return result.new(true, Texture.serializeUnchecked(texture:Unwrap()))
end

function Texture.serializeUnchecked(rawTexture: types.BaseUnloadedTexture): (buffer, number, number)
	return rawTexture.pixels, rawTexture.width, rawTexture.height
end

function Texture.drawChecked<T>(
	object: types.DrawableObject<T>,
	texture: types.Texture,
	textureX: number,
	textureY: number,
	rotation: number?
)
	rotation = rotation or 0

	if rotation == 0 then
		local y2 = 0
		local objectSizeY = object.width
		local objectSizeX = object.height
		local width = texture.width
		local height = texture.height
		local bfr = texture.buffer

		for y = textureY, textureY + width - 1 do
			if y >= objectSizeY then
				break
			end

			y2 = y - textureY

			local x2 = 0
			for x = textureX, textureX + height - 1 do
				if x >= objectSizeX then
					break
				end

				x2 = x - textureX
				if y2 < width and x2 < height then
					pixel(object, x, y, buffer.readu32(bfr, (y2 * height + x2) * 4))
				end
			end
		end
	else
		drawRotated(object, texture, textureX, textureY, rotation)
	end
end

function Texture.drawUnchecked<T>(
	object: types.DrawableObject<T>,
	texture: types.Texture,
	textureX: number,
	textureY: number,
	rotation: number?
)
	rotation = rotation or 0

	if rotation == 0 then
		local y2 = 0
		local width = texture.width
		local height = texture.height
		local bfr = texture.buffer

		for y = textureY, textureY + width - 1 do
			y2 = y - textureY

			local x2 = 0
			for x = textureX, textureX + height - 1 do
				x2 = x - textureX
				pixel(object, x, y, buffer.readu32(bfr, (y2 * height + x2) * 4))
			end
		end
	else
		drawRotated(object, texture, textureX, textureY, rotation)
	end
end

function Texture.fromAssetId(assetId: number): Result<types.Texture, oEnum.DrawableObjectError>
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

function Texture.new(width: number, height: number, bfr: buffer?): types.Texture
	local buff = bfr or buffer.create(width * height * 4)
	local t = base.new()
	t.width = width
	t.height = height
	t.buffer = buff

	return t
end

return Texture
