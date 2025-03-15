local OSGL = script.Parent.Parent
local draw = OSGL.draw
local types = require(OSGL.types)
local color = require(OSGL.color)
local pixel = require(draw.pixel)

return function<T>(object: types.DrawableObject<T>, centerX: number, centerY: number, radius: number, fill: types.Color?, stroke: types.Color?, strokeThickness: number?, rotation: number?)
	
	fill = fill or color.BLACK
	rotation = rotation or 0
	stroke = stroke or color.TRANSPARENT
	strokeThickness = strokeThickness or 0

	local radius = radius
	local strokeThickness = if stroke ~= color.TRANSPARENT then strokeThickness else 0

	local sizeX, sizeY = object.width, object.height
	local radians = rotation * (math.pi / 180)
	local cosTheta = math.cos(radians)
	local sinTheta = math.sin(radians)

	local radiusSquared = radius * radius
	local totalRadius = strokeThickness + radius
	local strokeSquared = totalRadius * totalRadius

	for y = -totalRadius, totalRadius do
		local ySquared = y * y

		for x = -totalRadius, totalRadius do
			local distance = x * x + ySquared

			if distance <= strokeSquared then
				local pixelColor = if distance <= radiusSquared then fill else stroke

				local rotatedX = x * cosTheta - y * sinTheta
				local rotatedY = x * sinTheta + y * cosTheta

				-- TODO: [saaawdust]: Fix holes.
				local pixelX = math.floor(centerX + rotatedX + 0.5) -- Snap to nearest pixel
				local pixelY = math.floor(centerY + rotatedY + 0.5)

				-- Bounds check and pixel writing
				if pixelX >= 0 and pixelX < sizeX and pixelY >= 0 and pixelY < sizeY then
					pixel(object, pixelX, pixelY, pixelColor)
				end
			end
		end
	end
end