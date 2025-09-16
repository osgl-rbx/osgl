local Reader = script.Parent.Parent
local ImageReader = Reader.Parent
local Cursor = require(ImageReader.Parent.Cursor)

type Cursor = Cursor.Cursor

-- Parse the `IDHR` chunk Luau
return function(PNG, cursor: Cursor)
    cursor:ExpectBytesRaw(0, 0, 0, 13)
    cursor:ExpectBytes("IDHR")

    local dimensions = PNG.getDimensions(cursor):Unwrap()
    local bitDepth = cursor:ReadByte()
    local colorType = cursor:ReadByte()
    
    local compression = cursor:ReadByte()
    local filtering = cursor:ReadByte()

    local interlaced = cursor:ReadByte()
    local crc = cursor:ReadU32()

    return {
        dimensions = dimensions,
        bitDepth = bitDepth,
        colorType = colorType,
        compression = compression,
        filtering = filtering,
        interlaced = interlaced == 1,
        crc = crc,
        metadata = {},
    }
end
