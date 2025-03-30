--!optimize 2
--!native

------------------------------------------------------------
-- OSGL v1.6b - Open-Source Graphical Library
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

--[=[
<strong>@OSGL/Drawable</strong>
<em>Resizes the </em><code>DrawableObject</code><em> to the given width and height.</em>
  ]=]
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

	-- Is a window
	if self.editableImage then
		local editableImage = AssetService:CreateEditableImage({ Size = size })
		if not editableImage then
			return result.new(false, oEnum.DrawableObjectError.NotEnoughMemory)
		end
		
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

--[=[
<strong>@OSGL/Drawable</strong>
<em>Serializes the </em><code>DrawableObject</code><em>.</em>
  ]=]
function DrawBaseImpl.Serialize<T>(self: types.DrawableObject<T>): (buffer, number, number)
	return self.buffer, self.width, self.height
end

--[=[
<strong>@OSGL/Drawable</strong>
<em>Deserializes a serialized object onto the </em><code>DrawableObject</code><em>.</em>
  ]=]
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

--[=[
<strong>@OSGL/Drawable</strong>
<strong>@Checked</strong>
<em>Returns the color of the given pixel, if in bound.</em>
  ]=]
function DrawBaseImpl.ReadPixelChecked<T>(
	self: types.DrawableObject<T>,
	x: number,
	y: number
): Result<types.Color, oEnum.DrawableObjectError>
	if x >= 0 and y >= 0 and x < self.width and y < self.height then
		return result.new(true, buffer.readu32(self.buffer, (y * self.width + x) * 4))
	end

	return result.new(false, oEnum.DrawableObjectError.OutOfBounds)
end

--[=[
<strong>@OSGL/Drawable</strong>
<strong>@Unhecked!</strong>
<em>Returns the color of the given pixel</em>
  ]=]
function DrawBaseImpl.ReadPixelUnchecked<T>(self: types.DrawableObject<T>, x: number, y: number): types.Color
	return buffer.readu32(self.buffer, (y * self.width + x) * 4)
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

--[=[
<strong>@OSGL/Drawable</strong>
<strong>@Checked</strong>
<em>Tints a region of pixels.</em>
  ]=]
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

--[=[
<strong>@OSGL/Drawable</strong>
<strong>@Unchecked!</strong>
<em>Tints a region of pixels.</em>
  ]=]
function DrawBaseImpl.TintRegionUnchecked<T>(
	self: types.DrawableObject<T>,
	tint: types.Color,
	factor: number,
	x: number,
	y: number,
	width: number,
	height: number
)
	return doTint(self, tint, factor, x, y, x + width, x + height)
end

--[=[
<strong>@OSGL/Drawable</strong>
<em>Tints the entire object.</em>
  ]=]
function DrawBaseImpl.Tint<T>(self: types.DrawableObject<T>, tint: number, factor: number)
	doTint(self, tint, factor, self.width - 1, self.height - 1)
end

--[=[
<strong>@OSGL/Drawable</strong>
<em>Resamples the entire object.</em>
  ]=]
function DrawBaseImpl.Resample<T>(self: types.DrawableObject<T>, scale: number?)
    scale = scale or 1

    -- Get original texture size and buffer
    local originalWidth = self.width
    local originalHeight = self.height

    -- Calculate the new size of the texture
    local newWidth = math.floor(originalWidth * scale)
    local newHeight = math.floor(originalHeight * scale)

    local newBuffer = buffer.create(newWidth * newHeight * 4)

    for newY = 0, newHeight - 1 do
        for newX = 0, newWidth - 1 do
            local srcX = math.clamp((newX + 0.5) / scale - 0.5, 0, originalWidth - 1)
            local srcY = math.clamp((newY + 0.5) / scale - 0.5, 0, originalHeight - 1)
            local color = buffer.readu32(self.buffer, (srcY * originalWidth + srcX) * 4)
            buffer.writeu32(newBuffer, (newY * newWidth + newX) * 4, color)
        end
    end

	local size = Vector2.new(newWidth, newHeight);
	if self.editableImage then
		local editableImage = AssetService:CreateEditableImage({ Size = size })
		if not editableImage then
			return result.new(false, oEnum.DrawableObjectError.NotEnoughMemory)
		end
		
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

    self.size = size
    self.width = newWidth
    self.height = newHeight
    self.buffer = newBuffer
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
			Resample = DrawBaseImpl.Resample,
			
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
