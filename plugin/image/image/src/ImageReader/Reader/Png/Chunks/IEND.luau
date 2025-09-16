local Reader = script.Parent.Parent.Parent
local ImageReader = Reader.Parent
local Cursor = require(ImageReader.Parent.Cursor)

type Cursor = Cursor.Cursor

return function(cursor: Cursor, file)
    file.isReading = false
    return
end
