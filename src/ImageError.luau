local Result = require(script.Parent.Result)
local SafeEnum = require(script.Parent.SafeEnum)

type Result<T, E> = Result.Result<T, E>
export type ImageError = number
export type ImageResult<T> = Result<T, ImageError>

local ImageError = {
    Decoding = SafeEnum() :: ImageError,
    Encoding = SafeEnum() :: ImageError,
    Unsupported = SafeEnum() :: ImageError,
}

return ImageError