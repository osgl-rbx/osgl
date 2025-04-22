------------------------------------------------------------
-- OSGL v1.6.2 - Open-Source Graphical Library
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

local Video = {}

--[=[
<strong>@OSGL/Video</strong>
<em>Plays a </em><code>Video</code><em> synchronously.</em>
  ]=]
function PlaySync(self: types.Video, callback: (width: number, height: number, buffer: buffer) -> ())
	local frames = #self.frames
	local timePerFrame = 1 / self.frameRate

	self.playing = true
	while self.playing do
		self.playbackFrame += 1

		if self.playbackFrame > frames then
			if self.loop then
				self.playbackFrame = 1
			else
				self.playing = false
				break
			end
		end

		callback(self.width, self.height, self.frames[self.playbackFrame])
		task.wait(timePerFrame)
	end

	return self
end

--[=[
<strong>@OSGL/Video</strong>
<em>Plays a </em><code>Video</code><em> asynchronously.</em>
  ]=]
function PlayAsync(self: types.Video, callback: (width: number, height: number, buffer: buffer) -> ())
	task.spawn(self.PlaySync, self, callback)
	return self
end

--[=[
<strong>@OSGL/Video</strong>
<em>Skips a frame of the </em><code>Video</code><em>.</em>
  ]=]
function Next(self: types.Video)
	local len = #self.frames
	if self.playbackFrame < len then
		self.playbackFrame += 1
	elseif self.loop then
		self.playbackFrame = 0
	end

	return self
end

--[=[
<strong>@OSGL/Video</strong>
<em>Goes to the previous frame of the </em><code>Video</code><em>.</em>
  ]=]
function Previous(self: types.Video)
	if self.playbackFrame > 0 then
		self.playbackFrame -= 1
	end

	return self
end

--[=[
<strong>@OSGL/Video</strong>
<em>Stops playback of the </em><code>Video</code><em>.</em>
  ]=]
function Stop(self: types.Video)
	self.playing = false
	self.playbackFrame = 0

	return self
end

--[=[
<strong>@OSGL/Video</strong>
<em>Returns a frame of the</em><code>Video</code><em>.</em>
  ]=]
function GetFrame(self: types.Video, frame: number): (buffer, number, number)
	return self.frames[frame], self.width, self.height
end

--[=[
<strong>@OSGL/Video</strong>
<em>Returns the buffer of a frame from the </em><code>Video</code><em>.</em>
  ]=]
function GetBufferOfFrame(self: types.Video, frame: number): buffer
	return self.frames[frame] or buffer.create(0)
end

--[=[
<strong>@OSGL/Video</strong>
<em>Creates a new </em><code>Video</code><em>.</em>
  ]=]
function Video.new(width: number, height: number, frames: { buffer }?): types.Video
	local frames = frames or {}

    local size
	for i, v: buffer in ipairs(frames) do
        local len = buffer.len(v)

		if not size then
			size = len
		elseif len ~= size then
			warn("Failed to load video frame ".. i.. ". The frame has been discarded, all frames but be the same size!")
			table.remove(frames, i)
		end
	end

	return {
		width = width,
		height = height,
		playbackFrame = 0,
		frameRate = 1 / #frames,
		frames = frames,
		playing = false,
		loop = false,

		PlaySync = PlaySync,
		PlayAsync = PlayAsync,
		Previous = Previous,
		Next = Next,
		Stop = Stop,

		GetBufferOfFrame = GetBufferOfFrame,
		GetFrame = GetFrame
	}
end

--[=[
<strong>@OSGL/Video</strong>
<em>Creates a new </em><code>Video</code><em> from a collection of raw </em><code>Texture</code><em>s.</em>
  ]=]
function Video.from(collection: { types.RawTexture }): types.Video
	local framesAmount = #collection

	if framesAmount == 0 then
		return Video.new(0, 0)
	end

	local bfrCollection = table.create(framesAmount)

	local width, height
	for i, v in collection do
		if typeof(v) == "Instance" and v:IsA("ModuleScript") then
			v = require(v)
		end

		if not width or not height then
			width, height = v.width, v.height
		elseif width ~= v.width or height ~= v.height then
			warn("Failed to load video frame ".. i.. ". The frame has been discarded, all frames but be the same size!")
			continue
		end

        bfrCollection[i] = v.pixels
	end

	return Video.new(width, height, bfrCollection)
end

return Video
