local Reader = script.Parent.Parent.Parent
local ImageReader = Reader.Parent
local Cursor = require(ImageReader.Parent.Cursor)

type Cursor = Cursor.Cursor

return function(cursor: Cursor, file, data)
    local gray = -1
	local red = -1
	local green = -1
	local blue = -1

    local header = data.header
    local colorType = header.colorType
    local buff = cursor.buffer

    local readU16 = buffer.readu16

	if colorType then
		gray = readU16(buff, 0, header.bitDepth)
	elseif colorType == 2 then
		red = readU16(buff, 0, header.bitDepth)
		green = readU16(buff, 2, header.bitDepth)
		blue = readU16(buff, 4, header.bitDepth)
	end

    file.alpha = {
		gray = gray,
		red = red,
		green = green,
		blue = blue,
	}
end
