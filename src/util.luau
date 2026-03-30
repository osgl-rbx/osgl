------------------------------------------------------------
-- OSGL 1.7 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
------------------------------------------------------------

local OSGL = script.Parent
local enums = require(OSGL.enums)

local draw = OSGL.draw
local blendModes = draw.blendModes 

local blendingModes = enums.BlendingMode

local util = {
    VALID_TEXTURE_VERSIONS = { "1.5b", "1.6b", "1.6.1", "1.6.2", "1.6.3", 1 },
    VALID_FONT_VERSIONS = { "1.5b", "1.6b", "1.6.1", "1.6.2", "1.6.3" },

    BLEND_MODULES = {
        [blendingModes.Normal] = require(blendModes.normal),
        [blendingModes.Overwrite] = require(blendModes.overwrite),
        [blendingModes.Additive] = require(blendModes.additive),
        [blendingModes.Multiply] = require(blendModes.multiply),
        [blendingModes.Screen] = require(blendModes.screen),
        [blendingModes.Overlay] = require(blendModes.overlay),
        [blendingModes.Subtract] = require(blendModes.subtract),
    },

    BLEND_FUNCTIONS = {
        [blendingModes.Normal] = require(blendModes.normal.alphaMode),
        [blendingModes.Additive] = require(blendModes.additive.alphaMode),
        [blendingModes.Multiply] = require(blendModes.multiply.alphaMode),
        [blendingModes.Screen] = require(blendModes.screen.alphaMode),
        [blendingModes.Overlay] = require(blendModes.overlay.alphaMode),
        [blendingModes.Subtract] = require(blendModes.subtract.alphaMode)
    }
}

function util.getRendererProp(object: Instance): string
    if object:IsA("ImageLabel") or object:IsA("ImageButton") then
        return "ImageContent"
    elseif object:IsA("Texture") or object:IsA("Decal") then
        return "TextureContent"
    end

    return ""
end

return util