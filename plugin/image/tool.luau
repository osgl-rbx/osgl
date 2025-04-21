------------------------------------------------------------
-- OSGL v1.6.1 - Open-Source Graphical Library
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

local StudioService = game:GetService("StudioService")
local Selection = game:GetService("Selection")

local image = script.Parent
local osglTools = image.Parent
local osglScripts = osglTools.scripts

local PNG = require(image.png)
local notif = require(osglScripts.notif)

local CHUNK_LIMIT = 200000 -- Equivilent to 200KB

function toHex(num: number): string
    return string.format("%02X", num)
end

function estimateOutput(width: number, height: number)
    local bufferLength = width * height * 12

    local headerLength = 84
    local widthLength = string.len(tostring(width))
    local heightLength = string.len(tostring(height))

    return headerLength + widthLength + heightLength + bufferLength + (width * height * 4)
end

return {
    Name = "Image Uploader",
    Icon = "rbxassetid://71989091852609",

    OnButtonClick = function(pluginButton: PluginToolbarButton)
        if _G.osglTools.imageEditorRunning == true then
            return
        end

        _G.osglTools.imageEditorRunning = true
        pluginButton.Icon = "rbxassetid://73679864301651"

        local totalTime = 0
        local selectedParents = Selection:Get()
        local selectedItems = {}
        local successFiles = 0

        if #selectedParents == 0 then
            table.insert(selectedParents, workspace)
        end

        -- Prompt the user for a PNG
        local files: {File} = StudioService:PromptImportFiles({ "png" })
        for _, file in files do
            local Success, pngData = pcall(function()
                return PNG.new(file:GetBinaryContents())
            end)

            local fileName = string.match(file.Name, "(.+)%..+$") or file.Name
            if not Success then
                notif.invoke(`Failed to convert Texture '{fileName}'! Could not convert PNG.`)
                continue
            end

            local width, height = pngData.Width, pngData.Height
            local indexes = width * height
            local bfr = ""

            if indexes > 12494 or estimateOutput(width, height) >= CHUNK_LIMIT then
                notif.invoke(`Failed to convert Texture '{fileName}'! This Texture is too big. Try to keep Textures <b>under 111x111</b>.`)
                continue
            end

            notif.invoke(`Converting '{fileName}'.`)

            task.wait(.1)

            local startTime = os.clock()
            local endTime
            Success, _ = pcall(function()
                for offset = 0, indexes do
                    local Col, A = pngData:GetPixel((offset % width) + 1, (offset // width) + 1)
                    bfr ..= `\\x{toHex(Col.R * 255)}\\x{toHex(Col.G * 255)}\\x{toHex(Col.B * 255)}\\x{toHex(A)}`
                end

                endTime = math.floor((os.clock() - startTime) * 100 + 0.5) / 100
            end)

            if not Success then
                notif.invoke(`Failed to convert Texture '{fileName}'! Could not convert PNG.`)
                continue
            end

            totalTime += endTime

            local output = Instance.new("ModuleScript")
            output.Name = fileName
            output.Source = `return \{\n\tversion = "1.6.1",\n\twidth = {width},\n\theight = {height},\n\tpixels = buffer.fromstring("{bfr}")\n}`

            for _, parent in selectedParents do
                local newOutput = output:Clone()
                newOutput.Parent = parent

                table.insert(selectedItems, newOutput)
            end

            output:Destroy()
            notif.invoke(`Successfully converted '{fileName}' in {endTime}s`)

            successFiles += 1
        end

        local amountOfFiles = #files
        if amountOfFiles > 1 then
            local diff = amountOfFiles - successFiles
            local extraMessage = successFiles == amountOfFiles and "" or ` with <b>{amountOfFiles - successFiles}</b> error{diff == 1 and "" or "s"}.`
            notif.invoke(`Successfully converted <b>{successFiles}/{amountOfFiles}</b> files in <b>{totalTime}s</b>{extraMessage}`)
        end

        Selection:Set(selectedItems)

        _G.osglTools.imageEditorRunning = false
        pluginButton.Icon = "rbxassetid://71989091852609"
    end
}
