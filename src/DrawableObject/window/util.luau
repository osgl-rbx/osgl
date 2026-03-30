------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
-----------------------------------------------------------

local Window = script.Parent
local OSGL = Window.Parent.Parent

local oEnum = require(OSGL.enums)
local Result = require(OSGL.result)

local WindowUtil = {}

function WindowUtil.validateEditableImage(EditableImage: EditableImage): Result.Result<EditableImage, oEnum.WindowError>
    local success, error = pcall(function()
        return EditableImage:WritePixelsBuffer(Vector2.zero, Vector2.one, buffer.create(4))
    end)

    if not success and error == "EditableImage is not accessible. Go to the Security Tab in Game Settings to enable this API." then
        return Result.new(false, oEnum.WindowError.APINotEnabled)
    end

    return Result.new(true, EditableImage)
end

return WindowUtil