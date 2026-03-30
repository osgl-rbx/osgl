--!optimize 2

------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
------------------------------------------------------------

local AssetService = game:GetService("AssetService")

local DrawableObject = script.Parent.Parent

local OSGL = DrawableObject.Parent
local types = require(OSGL.types)
local Result = require(OSGL.result)
local oEnum = require(OSGL.enums)
local WindowUtil = require(OSGL.DrawableObject.window.util)

type Result<T, E> = Result.Result<T, E>

function fromEditableImage<T>(editable: EditableImage): Result<types.ImmutableTexture, oEnum.TextureError>
        local editableContent = Content.fromObject(editable)
        local result: Enum.CreateContentResult, content: Content = AssetService:CreateDataModelContentAsync(editableContent)

        if result == Enum.CreateContentResult.Success then
            return Result.new(true, content)
        else
            return Result.new(false, oEnum.TextureError.ImmutableCreationError)
        end
    end

return {
    fromBuffer = function<T>(bfr: buffer, size: Vector2): Result<types.ImmutableTexture, oEnum.TextureError>
        local success, result = pcall(function(...)
            return AssetService:CreateEditableImage(bfr, { Size = size })
        end)

        if not success then
            return Result.new(false, oEnum.TextureError.ImmutableCreationError)
        end

        local validationResult = WindowUtil.validateEditableImage(result)
        if not validationResult.isOk then
            return Result.new(false, oEnum.TextureError.ImmutableCreationError)
        end

        return fromEditableImage(validationResult:Unwrap())
    end,

    fromEditableImage = fromEditableImage,
}