--!optimize 2
--!native

local AssetService = game:GetService("AssetService")

local drawableObject = script.Parent
local OSGL = drawableObject.Parent
local types = require(OSGL.types)
local result = require(OSGL.result)
local oEnum = require(OSGL.enums)
local windowBase = require(drawableObject.windowBase)

type Result<T, E> = result.Result<T, E>

local Window = {}

local function dynamicCreateEditableImage(
	Parent: types.Drawable,
	width: number,
	height: number
): Result<EditableImage, oEnum.WindowError>
	if Parent and not Window.isDrawableInstance(Parent) then
		return result.new(false, oEnum.WindowError.InvalidCreationInstance)
	end
	
	if width < 1 or width > 1024 or height < 1 or height > 1024 then
        return result.new(false, oEnum.WindowError.WindowDimensionsOutOfBounds)
	end

	local success, EditableImage: EditableImage = pcall(function()
		return AssetService:CreateEditableImage({
			Size = Vector2.new(width, height),
		})
	end)

	if not success then
		return result.new(false, oEnum.DrawableObjectError.NotEnoughMemory)
	end

	return result.new(true, EditableImage)
end

function Window.new(editableImage: EditableImage, renderers: { types.Drawable }): types.Window
    local content = Content.fromObject(editableImage)
	for _, renderObject in ipairs(renderers) do
		local sourceProperty = Window.getRenderingProperty(renderObject)
		if sourceProperty == "" then
			continue
		end

		renderObject[sourceProperty] = content
	end

	local size = editableImage.Size
	local width, height = size.X, size.Y

	local t = windowBase.new();

	t.surfaces = renderers
	t.editableImage = editableImage
	t.buffer = buffer.create(width * height * 4)
	t.width = width
	t.height = height
	t.size = size

    return t
end

function Window.from(
	drawableObject: types.Drawable,
	width: number,
	height: number
): Result<types.Window, oEnum.WindowError>
	local editableImage = dynamicCreateEditableImage(drawableObject, width, height)
	if not editableImage.isOk then
		return editableImage
	end

	return result.new(true, Window.new(editableImage:Unwrap(), { drawableObject }))
end

function Window.fromAssetId(assetId: string): Result<types.Window, oEnum.WindowError>
	local texture = Content.fromAssetId(assetId)

	local success, editableImage = pcall(function()
		return AssetService:CreateEditableImageAsync(texture)
	end)

	if not success then
		return result.new(false, oEnum.DrawableObjectError.NotEnoughMemory)
	end

	return result.new(true, Window.new(editableImage))
end

function Window.fromBuffer(buffer: buffer, width: number, height: number): Result<types.Window, oEnum.WindowError>
	local editableImage = dynamicCreateEditableImage(nil, width, height)
	if not editableImage.isOk then
		return editableImage
	end

	-- No other way other than to create Vector2 here
	local image = editableImage:Unwrap()
	image:WritePixelsBuffer(Vector2.zero, Vector2.new(width, height), buffer)

	return result.new(true, Window.new(image, {}))
end

function Window.isDrawableInstance(object: Instance): boolean
	if typeof(object) ~= "Instance" then
		return
	end

	return object:IsA("ImageLabel") or object:IsA("ImageButton") or object:IsA("Decal") or object:IsA("Texture")
end

function Window.getRenderingProperty(object: types.Drawable): string
	if not Window.isDrawableInstance(object) then
		return ""
	end

	if object:IsA("ImageLabel") or object:IsA("ImageButton") then
		return "ImageContent"
	end

	return "TextureContent"
end

return Window
