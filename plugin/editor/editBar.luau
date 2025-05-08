local editorFolder = script.Parent
local notif = require(editorFolder.customNotifs)
local OSGL = require(editorFolder.Parent.OSGL)
local color = OSGL.color
local tools = require(editorFolder.tools)

return function(window: OSGL.Window, width: number, height: number, toolbar: tools.Tools)
    local bfr = window.buffer

    return {
        {
            name = "Flip Vertically",
            callback = function()
                local rowBuffer = buffer.create(width * 4)
                
                for y = 0, math.floor(height / 2) - 1 do
                    local topRowOffset = y * width * 4
                    local bottomRowOffset = (height - 1 - y) * width * 4

                    buffer.copy(rowBuffer, 0, bfr, topRowOffset, width * 4)
                    buffer.copy(bfr, topRowOffset, bfr, bottomRowOffset, width * 4)
                    buffer.copy(bfr, bottomRowOffset, rowBuffer, 0, width * 4)
                end

                window:Render()
            end,
        },
        {
            name = "Flip Horizontally",
            callback = function()
                local tempPixel = buffer.create(4)
                
                for y = 0, height - 1 do
                    local rowStart = y * width * 4
                    
                    for x = 0, math.floor(width / 2) - 1 do
                        local leftOffset = rowStart + x * 4
                        local rightOffset = rowStart + (width - 1 - x) * 4
                        
                        buffer.copy(tempPixel, 0, bfr, leftOffset, 4)
                        buffer.copy(bfr, leftOffset, bfr, rightOffset, 4)
                        buffer.copy(bfr, rightOffset, tempPixel, 0, 4)
                    end
                end

                window:Render()
            end,
        },

        {
            name = "Tint",
            callback = function()
                toolbar:Deselect()

                local rgbNotif
                rgbNotif = notif.new("Tint", {
                    notif.Input("R", 255),
                    notif.Input("G", 255),
                    notif.Input("B", 255),
                    notif.Input("A", 255),
                    notif.Input("Factor (0 - 1)", 1),
                    notif.Button("Submit", function()
                        local R, G, B, A = rgbNotif:GetValueOfInput(1), rgbNotif:GetValueOfInput(2), rgbNotif:GetValueOfInput(3), rgbNotif:GetValueOfInput(4)
                        window:Tint(color.new(R, G, B, A), rgbNotif:GetValueOfInput(5))
                        window:Render()

                        rgbNotif:Delete()
                    end)
                }):Create()

                window:Render()
            end,
        },

        {
            name = "Invert Colors",
            callback = function()
                for i = 0, (width * height * 4) - 1, 4 do
                    local pixel = buffer.readu32(bfr, i)
                    local R, G, B, A = color.read(pixel)
                    R = 255 - R
                    G = 255 - G
                    B = 255 - B

                    buffer.writeu32(bfr, i, color.new(R, G, B, A))
                end
                window:Render()
            end,
        }
    }
end