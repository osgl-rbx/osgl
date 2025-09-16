local Reader = script.Parent.Parent.Parent
local ImageReader = Reader.Parent
local Chunks = script.Parent
local Cursor = require(ImageReader.Parent.Cursor)
local util = require(Chunks.Parent.util)

type Cursor = Cursor.Cursor

return function(cursor: Cursor, file)
    file.gamma = util.beToLe32(cursor:ReadByte()) / 10e4
    return
end
