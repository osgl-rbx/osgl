local ImageError = require(script.Parent.ImageError)

type ImageError = ImageError.ImageError
export type Cursor = {
	PeekByte: (self: Cursor) -> number,
	ReadByte: (self: Cursor) -> number,
	PeekU32: (self: Cursor) -> number,
	ReadU32: (self: Cursor) -> number,
	PeekU16: (self: Cursor) -> number,
	ReadU16: (self: Cursor) -> number,
	PeekI32: (self: Cursor) -> number,
	ReadI32: (self: Cursor) -> number,
	ExpectByte: (self: Cursor, byte: number) -> (),
	ExpectBytes: (self: Cursor, bytes: string) -> boolean,
	ExpectBytesRaw: (self: Cursor, ...number) -> boolean,
	SkipBytes: (self: Cursor, bytes: number) -> (),
	ReadString: (self: Cursor, length: number) -> string,
	Fork: (self: Cursor, length: number) -> Cursor,
	Iterate: (self: Cursor) -> () -> number,
	ReadByteCollection: (self: Cursor, bytes: number) -> buffer,
	BytesRemaining: (self: Cursor) -> number,
	PeekBit: (self: Cursor) -> number,
	ReadBit: (self: Cursor) -> number,

	buffer: buffer,
	bufferLength: number,
	position: number,
	bitPosition: number,
}

local Cursor = {}

local function isPastBufferLength(self: Cursor)
	return self.position + (self.bitPosition / 8) > self.bufferLength
end

function Cursor.BytesRemaining(self: Cursor)
	return self.bufferLength - self.position
end

function Cursor.PeekByte(self: Cursor): number
	return buffer.readu8(self.buffer, self.position)
end

function Cursor.PeekU32(self: Cursor): number
	return buffer.readu32(self.buffer, self.position)
end

function Cursor.ReadU32(self: Cursor): number
	if isPastBufferLength(self) then
		return error(ImageError.Decoding)
	end

	local result = self:PeekU32()
	self.position += 4

	return result
end

function Cursor.PeekBit(self: Cursor): number
	return buffer.readbits(self.buffer, self.position * 8 + self.bitPosition, 1)
end

function Cursor.ReadBit(self: Cursor): number
	if isPastBufferLength(self) then
		return error(ImageError.Decoding)
	end

	local result = self:PeekBit()
	self.bitPosition += 1

	return result
end

function Cursor.ReadString(self: Cursor, length: number): string
	if isPastBufferLength(self) then
		return error(ImageError.Decoding)
	end

	local characters = ""
	for i = 1, length do
		characters ..= string.char(self:ReadByte())
	end

	return characters
end

function Cursor.Fork(self: Cursor, length: number): Cursor
	local chunk = buffer.create(length)
	buffer.copy(chunk, 0, self.buffer, self.position, length)
	self.position += length

	return new(chunk)
end

function Cursor.Iterate(self: Cursor): () -> number
	return function()
		return self.position + 1 > self.bufferLength and self:ReadByte() or nil 
	end
end

function Cursor.PeekU16(self: Cursor): number
	return buffer.readu16(self.buffer, self.position)
end

function Cursor.ReadU16(self: Cursor): number
	if isPastBufferLength(self) then
		return error(ImageError.Decoding)
	end

	local result = self:PeekU16()
	self.position += 2

	return result
end

function Cursor.PeekI32(self: Cursor): number
	return buffer.readi32(self.buffer, self.position)
end

function Cursor.ReadI32(self: Cursor): number
	if isPastBufferLength(self) then
		return error(ImageError.Decoding)
	end

	local result = self:PeekI32()
	self.position += 4

	return result
end

function Cursor.ReadByte(self: Cursor): number
	if isPastBufferLength(self) then
		return error(ImageError.Decoding, 2)
	end

	local result = self:PeekByte()
	self.position += 1

	return result
end

function Cursor.ExpectByte(self: Cursor, byte: number): boolean
	if isPastBufferLength(self) then
		return error(ImageError.Decoding)
	end

	local newByte = self:ReadByte()
	return newByte == byte
end

function Cursor.ReadByteCollection(self: Cursor, bytes: number): buffer
	if isPastBufferLength(self) then
		error(ImageError.Decoding)
	end

	local subBuffer = buffer.create(bytes)
	for position = 0, bytes - 1 do
		local newByte = self:ReadByte()
		buffer.writeu8(subBuffer, position, newByte)
	end

	return subBuffer
end

function Cursor.ExpectBytes(self: Cursor, bytes: string): boolean
	return buffer.tostring(self:ReadByteCollection(string.len(bytes))) == bytes
end

function Cursor.ExpectBytesRaw(self: Cursor, ...: number): boolean
	local chars = {}

	for _, v in {...} do
		table.insert(chars, string.char(v))
	end

	return self:ExpectBytes(table.concat(chars))
end

function Cursor.SkipBytes(self: Cursor, bytes: number)
	self.position += bytes
	if isPastBufferLength(self) then
		return error(ImageError.Decoding)
	end

	return
end

function new(bfr: buffer, position: number?): Cursor
	local self = table.clone(Cursor)
	self.buffer = bfr
	self.bufferLength = buffer.len(bfr)
	self.position = position or 0
	self.bitPosition = 0

	return self
end

return {
	new = new
}
