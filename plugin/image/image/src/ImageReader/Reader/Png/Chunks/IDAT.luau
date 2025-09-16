local Reader = script.Parent.Parent.Parent
local ImageReader = Reader.Parent
local Cursor = require(ImageReader.Parent.Cursor)

type Cursor = Cursor.Cursor

return function(cursor: Cursor, file, chunk)
    local crc = chunk.crc
	local hash = file.hash or 0
	
	local bfr = cursor.buffer
	
	file.hash = bit32.bxor(hash, crc)
	file.zlibstream = file.zlibstream .. buffer.tostring(bfr)
    return
end
