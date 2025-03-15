--!optimize 2
--!native

local AssetService = game:GetService("AssetService")

local DrawableObject = script.Parent
local OSGL = DrawableObject.Parent
local types = require(OSGL.types)
local result = require(OSGL.result)
local oEnum = require(OSGL.enums)
local util = require(OSGL.util)
local draw = require(OSGL.draw)
local color = require(OSGL.color)

type Result<T, E> = result.Result<T, E>

local DrawBaseImpl = {}

function DrawBaseImpl.Resize<T>(
	self: types.DrawableObject<T>,
	width: number?,
	height: number?
): Result<nil, oEnum.DrawableObjectError>
	local currentWidth, currentHeight = self.width, self.height

	width = width or currentWidth
	height = height or currentHeight

	if width == currentHeight and height == currentHeight then
		return result.new(true, nil)
	end

	local copy_size
	local bfrSize = width * height * 4
	local currentSize = buffer.len(self.buffer)
	if bfrSize < currentSize then
		copy_size = bfrSize
	else
		copy_size = currentSize
	end

	local resizedBuffer = buffer.create(bfrSize)
	buffer.copy(resizedBuffer, 0, self.buffer, 0, copy_size)

	self.buffer = resizedBuffer

	local size = Vector2.new(width, height)
	self.size = size
	self.width = width
	self.height = height

	local editableImage = AssetService:CreateEditableImage({ Size = size })
	if not editableImage then
		return result.new(false, oEnum.DrawableObjectError.NotEnoughMemory)
	end

	-- Is a window
	if self.editableImage then
		self.editableImage = editableImage
		local content = Content.fromObject(editableImage)
		for _, v in self.surfaces do
			local prop = util.getRendererProp(v)
			if prop == "" then
				continue
			end

			v[prop] = content
		end
	end

	return result.new(true, nil)
end

function DrawBaseImpl.Serialize<T>(self: types.DrawableObject<T>): (buffer, number, number)
	return self.buffer, self.width, self.height
end

function DrawBaseImpl.Deserialize<T>(
	self: types.DrawableObject<T>,
	buff: buffer,
	width: number,
	height: number
): Result<nil, oEnum.DrawableObjectError>

	local otherBuffLen = buffer.len(buff)
	if (otherBuffLen ~= width * height * 4) or otherBuffLen > buffer.len(self.buffer) then
		return result.new(false, oEnum.DrawableObjectError.BadBufferSize)
	end

	DrawBaseImpl.Resize(self, width, height)
	buffer.copy(self.buffer, 0, buff)

	return result.new(true, nil)
end

function DrawBaseImpl.ReadPixelChecked<T>(
	self: types.DrawableObject<T>,
	X: number,
	Y: number
): Result<types.Color, oEnum.DrawableObjectError>
	if X > 0 and Y > 0 and X < self.width and Y < self.height then
		return result.new(true, buffer.readu32(self.buffer, (Y * self.sizeX + X) * 4))
	end

	return result.new(false, oEnum.DrawableObjectError.OutOfBounds)
end

function DrawBaseImpl.ReadPixelUnchecked<T>(self: types.DrawableObject<T>, X: number, Y: number): types.Color
	return buffer.readu32(self.buffer, (Y * self.sizeX + X) * 4)
end

local function doTint(self, tint, factor, x, y, finalX, finalY)
	local tintR = color.r(tint)
	local tintG = color.g(tint)
	local tintB = color.b(tint)
	local tintA = color.a(tint)

	local sizeX = self.width
	local bfr = self.buffer
	for x = x, finalX do
		for y = y, finalY do
			local pixelColor = buffer.readu32(bfr, (y * sizeX + x) * 4)

			buffer.writeu32(
				bfr,
				(y * sizeX + x) * 4,
				color.new(
					math.lerp(color.r(pixelColor), tintR, factor),
					math.lerp(color.g(pixelColor), tintG, factor),
					math.lerp(color.b(pixelColor), tintB, factor),
					math.lerp(color.a(pixelColor), tintA, factor)
				)
			)
		end
	end
end

function DrawBaseImpl.TintRegionChecked<T>(
	self: types.DrawableObject<T>,
	tint: types.Color,
	factor: number,
	x: number,
	y: number,
	width: number,
	height: number
)
	local finalX = x + width
	local finalY = y + height

	if x < 0 or x > width or y < 0 or y > height or finalX < 0 or finalX > width or finalY < 0 or finalY > height then
		return result.new(false, oEnum.DrawableObjectError.OutOfBounds)
	end

	doTint(self, tint, factor, x, y, finalX, finalY)

	return result.new(true, nil)
end

function DrawBaseImpl.TintRegionUnchecked<T>(
	self: types.DrawableObject<T>,
	tint: types.Color,
	factor: number,
	x: number,
	y: number,
	width: number,
	height: number
)
	return doTint(self, tint, factor, x + width, x + height)
end

function DrawBaseImpl.Tint<T>(self: types.DrawableObject<T>, tint: number, factor: number)
	doTint(self, tint, factor, self.width - 1, self.height - 1)
end

export type Base = typeof(DrawBaseImpl)

return {
	new = function(): Base
		return {
			Resize = DrawBaseImpl.Resize,
			Serialize = DrawBaseImpl.Serialize,
			Deserialize = DrawBaseImpl.Deserialize,
			ReadPixelChecked = DrawBaseImpl.ReadPixelChecked,
			ReadPixelUnchecked = DrawBaseImpl.ReadPixelUnchecked,
			TintRegionChecked = DrawBaseImpl.TintRegionChecked,
			TintRegionUnchecked = DrawBaseImpl.TintRegionUnchecked,
			Tint = DrawBaseImpl.Tint,
			
			Pixel = draw.Pixel,
			Line = draw.Line,
			Rectangle = draw.Rectangle,
			Polygon = draw.Polygon,
			Triangle = draw.Triangle,
			Circle = draw.Circle,
			Buffer = draw.Buffer,
			Clear = draw.Clear,
		}
	end
}
