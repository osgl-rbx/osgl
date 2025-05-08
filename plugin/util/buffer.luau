------------------------------------------------------------
-- OSGL v1.6.2 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
--
-- Free to use, modify and distribute in your projects (including commercial games ;3)
-- Credit appreciated but not required
--
-- Do NOT:
-- - Repackage and sell OSGL directly
-- - Claim you created the core library
--
-- By using OSGL, you agree to these terms.
-- Full license available in the LICENSE file
------------------------------------------------------------

local buff = {}

function buff.stringBufferAsHex(b: buffer, width: number, height: number)
    local pixelCount = width * height
    local hexStrings = table.create(pixelCount * 4, "")
    
    for i = 0, pixelCount - 1 do
        local offset = i * 4
        hexStrings[i*4 + 1] = buff.toHex(buffer.readu8(b, offset))
        hexStrings[i*4 + 2] = buff.toHex(buffer.readu8(b, offset + 1))
        hexStrings[i*4 + 3] = buff.toHex(buffer.readu8(b, offset + 2))
        hexStrings[i*4 + 4] = buff.toHex(buffer.readu8(b, offset + 3))
    end
    
    return "\\x"..table.concat(hexStrings, "\\x")
end

function buff.toHex(num: number): string
    return string.format("%02X", num)
end

return buff