local OSGL = script.Parent.Parent
local draw = OSGL.draw
local types = require(OSGL.types)
local pixel = require(draw.pixel)

return function<T>(object: types.DrawableObject<T>, bfr: buffer, width: number, height: number, x: number, y: number)
    local winX = object.width
    local winY = object.height

    for i = 0, width - 1 do
        local pixelX = x + i
        for j = 0, height - 1 do
            local pixelY = y + j

            if pixelX >= 0 and pixelX < winX and pixelY >= 0 and pixelY < winY then
                local col = buffer.readu32(bfr, (y * width + x) * 4)
                pixel(object, pixelX, pixelY, col)
            end
        end
    end
end
