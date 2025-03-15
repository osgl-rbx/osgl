local util = {}
util.VALID_TEXTURE_VERSIONS = { "1.5b", "1.6b" }
util.VALID_FONT_VERSIONS = { "1.5b", "1.6b" }

function util.getRendererProp(object: Instance): string
	if object:IsA("ImageLabel") or object:IsA("ImageButton") then
		return "ImageContent"
	elseif object:IsA("Texture") or object:IsA("Decal") then
		return "TextureContent"
	end

	return ""
end

return util