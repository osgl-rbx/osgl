--!optimize 2
--!native

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

local Draw = script.Parent
local OSGL = Draw.Parent
local types = require(OSGL.types)
local pixel = require(Draw.pixel)
local color = require(OSGL.color)

return function<T>(object: types.DrawableObject<T>, startX: number, startY: number, stopX: number, stopY: number, thickness: number, c: types.Color)
	thickness = thickness or 1
	c = c or color.BLACK

	if thickness == 0 then
		return
	end

	local width, height = object.width, object.height

	local dx = stopX - startX
	local dy = stopY - startY

	local steps = math.max(math.abs(dx), math.abs(dy))

	local xIncrement = dx / steps
	local yIncrement = dy / steps

	local x = startX
	local y = startY

	local function drawThickPoint(px: number, py: number)
		local halfThickness = thickness / 2
		for offsetX = -halfThickness, halfThickness do
			for offsetY = -halfThickness, halfThickness do
				local pixelX = math.floor(px + offsetX + .5)
				local pixelY = math.floor(py + offsetY + .5)
				if pixelX >= 0 and pixelX < width and pixelY >= 0 and pixelY < height then
					pixel(object, pixelX, pixelY, c)
				end
			end
		end
	end

	for _ = 0, steps do
		drawThickPoint(x, y)
		x += xIncrement
		y += yIncrement
	end
end
