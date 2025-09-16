local SafeEnum = require(script.Parent.SafeEnum)

type Extensions = "BMP"
type ImageFormatFromExtension = (extension: Extensions) -> ImageFormat
export type ImageFormat = number

local ImageFormat = {
	UNKNOWN = SafeEnum() :: ImageFormat,
	BMP = SafeEnum() :: ImageFormat,
	PNG = SafeEnum() :: ImageFormat,
	TGA = SafeEnum() :: ImageFormat,
    JPG = SafeEnum() :: ImageFormat,
}

local extensionMap = {
	["BMP"] = ImageFormat.BMP,
	["DIB"] = ImageFormat.BMP,

	["PNG"] = ImageFormat.PNG,
	["TGA"] = ImageFormat.TGA,

    ["JPEG"] = ImageFormat.JPG,
    ["JPG"] = ImageFormat.JPG,
    ["JPE"] = ImageFormat.JPG,
    ["JIF"] = ImageFormat.JPG,
    ["JFIF"] = ImageFormat.JPG,
    ["JFI"] = ImageFormat.JPG
}

ImageFormat.fromExtension = function(extension: Extensions)
	return extensionMap[string.upper(extension)] or ImageFormat.UNKNOWN
end

return ImageFormat :: typeof(ImageFormat)
