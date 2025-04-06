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

local OSGL = script.Parent
local types = require(OSGL.types)
local result = require(OSGL.result)
local oEnum = require(OSGL.enums)
local util = require(OSGL.util)

type Result<T, E> = result.Result<T, E>

local function checkUnloadedBitmap(unloadedBitmap: types.RawTexture): Result<types.BaseUnloadedTexture, oEnum.TextureError>
	if typeof(unloadedBitmap) == "Instance" and unloadedBitmap:IsA("ModuleScript") then
		unloadedBitmap = require(unloadedBitmap)
	end

	if type(unloadedBitmap) ~= "table" or not table.find(util.VALID_TEXTURE_VERSIONS, unloadedBitmap.version) then
		return result.new(false, oEnum.TextureError.BadInput)
	end

	return result.new(true, unloadedBitmap)
end

local Bitmap = {}

--[=[
<strong>@OSGL/Bitmap</strong>
<em>Reads from the </em><code>Bitmap</code><em>.</em>
  ]=]
function Read(self: types.Bitmap, x: number, y: number, channel: number?): number
    channel = channel or 1
    return buffer.readu8(self.buffer, (y * self.width + x) * self.channels + (channel - 1))
end


--[=[
<strong>@OSGL/Bitmap</strong>
<em>Writes to the </em><code>Bitmap</code><em>.</em>
  ]=]
function Write(self: types.Bitmap, x: number, y: number, channel: number, value: number)
    return buffer.writeu8(self.buffer, (y * self.width + x) * self.channels + (channel - 1), value)
end

--[=[
<strong>@OSGL/Bitmap</strong>
<strong>@Checked</strong>
<em>Creates a new </em><code>Bitmap</code><em> from a raw one.</em>
  ]=]
function Bitmap.fromChecked(rawBitmap: types.RawTexture): Result<types.Bitmap, oEnum.TextureError>
    local raw = checkUnloadedBitmap(rawBitmap)

	if not raw.isOk then
		return raw
	end

	return result.new(true, Bitmap.fromUnchecked(raw:Unwrap()))
end

--[=[
<strong>@OSGL/Bitmap</strong>
<strong>@Unchecked!</strong>
<em>Creates a new </em><code>Bitmap</code><em> from an unloaded one.</em>
  ]=]
function Bitmap.fromUnchecked(rawBitmap: types.BaseUnloadedTexture): types.Bitmap
    local width, height, bfr = rawBitmap.width, rawBitmap.height, rawBitmap.pixels
    local channels = buffer.len(bfr) / (width * height)

    return {
        width = width,
        height = height,
        buffer = bfr,
        channels = channels,

        Read = Read,
        Write = Write,
    }
end

return Bitmap