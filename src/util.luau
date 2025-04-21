------------------------------------------------------------
-- OSGL v1.6.1 - Open-Source Graphical Library
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

local util = {}
util.VALID_TEXTURE_VERSIONS = { "1.5b", "1.6b", "1.6.1" }
util.VALID_FONT_VERSIONS = { "1.5b", "1.6b", "1.6.1" }

function util.getRendererProp(object: Instance): string
	if object:IsA("ImageLabel") or object:IsA("ImageButton") then
		return "ImageContent"
	elseif object:IsA("Texture") or object:IsA("Decal") then
		return "TextureContent"
	end

	return ""
end

return util
