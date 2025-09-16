local Reader = script.Parent.Parent.Parent
local ImageReader = Reader.Parent
local Cursor = require(ImageReader.Parent.Cursor)

type Cursor = Cursor.Cursor

return function(cursor: Cursor, file)
    file.metadata = file.metadata or {}

    local data = buffer.tostring(cursor.buffer)
    local nullPos = string.find(data, "\0")
    local key = string.sub(data, 1, nullPos - 1) or ""
    local value = string.sub(data, nullPos + 1) or ""

    file.metadata[key] = string.gsub(value, "[\r\n]+$", "")
    return
end
