local ImageReader = script.Parent.ImageReader
local ImageReaderTypes = require(ImageReader.types)

local DataReader = {}

function DataReader.convertToBuffer(dataStream: ImageReaderTypes.ReadableData): buffer
    if type(dataStream) == "string" then
        return buffer.fromstring(dataStream)
    end

    return dataStream
end

return DataReader