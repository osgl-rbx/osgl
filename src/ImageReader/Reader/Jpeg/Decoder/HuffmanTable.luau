local module = {}

local function BitsFromLength(root, element, pos)
	if type(root) == "table" then
		if pos == 0 then
			if #root < 2 then
				table.insert(root, element)
				return true
			end

			return false
		end

		for i = 0, 1 do
			if #root == i then
				table.insert(root, {})
			end

			if BitsFromLength(root[i + 1], element, pos - 1) == true then
				return true
			end
		end
	end

	return false
end

function module.CreateHuffmanTable()
	local huff = {}

	huff.root = {}
	huff.symbols = {}

	return huff
end

function module.ConstructTree(huffmanTable, lengths, elements)
	huffmanTable.elements = elements
	local ii = 0

	for i = 1, #lengths do
		for j = 1, lengths[i] do
			BitsFromLength(huffmanTable.root, elements[ii + 1], i - 1)
			ii = ii + 1
		end
	end
end

function module.GetNextSymbolFromHuffmanTable(huffmanTable, bitStream)
	if huffmanTable == nil then
		error("HUFFMAN TABLE IS NIL.")
	end
	
	local r = huffmanTable.root
	
	local length = 0

	while type(r) == "table" do
		r = r[bitStream.ReadBit() + 1]
		length = length + 1
	end

	return r, length
end

function module.GetCode(huffmanTable, bitStream)
	while true do
		local result = module.GetNextSymbolFromHuffmanTable(huffmanTable, bitStream)
		
		if result == nil then
			return -1
		end
		
		return result
	end
end

return module