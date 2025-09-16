local Jpg = script.Parent
local Reader = Jpg.Parent
local ImageReader = Reader.Parent
local ImageReaderStructs = require(ImageReader.structs)

type Dimensions = ImageReaderStructs.Dimensions
export type JpgHeader = {
	versionMajor: number,
	versionMinor: number,
	density: number,
	xDensity: number,
	yDensity: number,
	thumbnailWidth: number,
	thumbnailHeight: number,
	dimensions: Dimensions,
	componentCount: number,
	precision: number,
}

return nil