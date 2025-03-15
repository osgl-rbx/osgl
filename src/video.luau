local OSGL = script.Parent
local drawableObject = OSGL.DrawableObject
local Texture = require(drawableObject.texture)
local types = require(OSGL.types)

local Video = {}

function PlaySync<T>(self: types.Video<T>, callback: (width: number, height: number, buffer: buffer) -> ())
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

function PlayAsync<T>(self: types.Video<T>, callback: (width: number, height: number, buffer: buffer) -> ())
	task.spawn(self.PlaySync, self, callback)
	return self
end

function Next<T>(self: types.Video<T>)
	local len = #self.frames
	if self.playbackFrame < len then
		self.playbackFrame += 1
	elseif self.loop then
		self.playbackFrame = 0
	end

	return self
end

function Previous<T>(self: types.Video<T>)
	if self.playbackFrame > 0 then
		self.playbackFrame -= 1
	end

	return self
end

function Stop<T>(self: types.Video<T>)
	self.playing = false
	self.playbackFrame = 0

	return self
end

function GetFrame<T>(self: types.Video<T>, frame: number): types.Texture
	return Texture.new(self.sizeX, self.sizeY, self.frames[frame])
end

function GetBufferOfFrame<T>(self: types.Video<T>, frame: number): buffer
	return self.frames[frame] or buffer.create(0)
end

function Video.new<T>(width: number, height: number, frames: { buffer }?): types.Video<T>
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

function Video.from<T>(collection: { types.RawTexture }): types.Video<T>
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