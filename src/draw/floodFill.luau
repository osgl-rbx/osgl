--!optimize 2
--!native

------------------------------------------------------------
-- OSGL v1.6.2 - Open-Source-Graphical-Library
-- Copyright © 2023-2025 OSGL (@saaawdust)
--
-- This software is provided ‘as-is’, without any express or implied warranty.
-- In no event will the authors be held liable for any damages arising from the use of this software.
--
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:
--
-- 1. The origin of this software must not be misrepresented;
--    you must not claim that you wrote the original software.
--    If you use this software in a product, an acknowledgment
--    in the product documentation would be appreciated but is not required.
--
-- 2. Altered source versions must be plainly marked as such,
--    and must not be misrepresented as being the original software.
--
-- 3. This notice may not be removed or altered from any source distribution.
--
------------------------------------------------------------

local OSGL = script.Parent.Parent
local types = require(OSGL.types)

local readU32 = buffer.readu32
local writeU32 = buffer.writeu32

-- uses horizontal spans to minimize stack operations
return function<T>(object: types.DrawableObject<T>, startX: number, startY: number, newColor: types.Color)
	-- default coords
	local x0, y0 = startX or 0, startY or 0
	local w, h = object.width, object.height
	local bfr = object.buffer

	-- get the target color to replace
	local target = object:ReadPixelUnchecked(x0, y0)
	if target == newColor then
		return -- nothing to do
	end

	local stack = {}
	local top = 0

	top = top + 1
	stack[top] = { x0, y0 }

	while top > 0 do
		local seed = stack[top]
		local sx, sy = seed[1], seed[2]

		stack[top] = nil
		top -= 1

		if readU32(bfr, (sy * w + sx) * 4) == target then
			local x = sx
			local idx = (sy * w + x) * 4
			while x >= 0 and readU32(bfr, idx) == target do
				x -= 1
				idx -= 4
			end
			x += 1
			idx += 4

			-- now fill right until color changes
			local spanFilledAbove = false
			local spanFilledBelow = false
			while x < w and readU32(bfr, idx) == target do
				-- paint
				writeU32(bfr, idx, newColor)

				if sy > 0 then
					local aboveIdx = idx - (w * 4)
					if readU32(bfr, aboveIdx) == target then
						if not spanFilledAbove then
							top += 1
							stack[top] = { x, sy - 1 }
							spanFilledAbove = true
						end
					else
						spanFilledAbove = false
					end
				end

				if sy < h - 1 then
					local belowIdx = idx + (w * 4)
					if readU32(bfr, belowIdx) == target then
						if not spanFilledBelow then
							top += 1
							stack[top] = { x, sy + 1 }
							spanFilledBelow = true
						end
					else
						spanFilledBelow = false
					end
				end

				-- step right
				x += 1
				idx += 4
			end
		end
	end
end
