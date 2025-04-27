--!native
--!optimize 2

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

local StudioService = game:GetService("StudioService")
local Selection = game:GetService("Selection")
local ScriptEditorService = game:GetService("ScriptEditorService")

local image = script.Parent
local osglTools = image.Parent
local osglScripts = osglTools.scripts

local PNG = require(image.png)
local BMP = require(image.bmp)
local notif = require(osglScripts.notif)

function toHex(num: number): string
    return string.format("%02X", num)
end

local loadingTask

return {
    Name = "Image Uploader",
    Icon = "rbxassetid://71989091852609",

    OnButtonClick = function(pluginButton: PluginToolbarButton)
        if _G.osglTools.imageEditorRunning == true and loadingTask then
            task.cancel(loadingTask)
            loadingTask = nil
            pluginButton.Icon = "rbxassetid://71989091852609"
            _G.osglTools.imageEditorRunning = false

            notif.invoke("Stopped conversion.")
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
        local files: { File } = StudioService:PromptImportFiles({ "png", "bmp" })
        for _, file in files do
            local extensionTable = string.split(file.Name, ".")
            local extension = extensionTable[#extensionTable]

            pluginButton.Icon = "rbxassetid://103190868047609"

            local Success, pngData = pcall(function()
                if extension == "bmp" then
                    return BMP.Parse(file)
                else
                    return PNG.decode(buffer.fromstring(file:GetBinaryContents()))
                end
            end)

            local fileName = string.match(file.Name, "(.+)%..+$") or file.Name
            if not Success then
                notif.invoke(`Failed to convert Texture '{fileName}'! Could not convert PNG.`)
                warn(`[osgl-tools]: Failed to convert Texture '{fileName}' with error '{pngData}'`)
                continue
            end

            local width, height = pngData.width, pngData.height
            local indexes = width * height

            notif.invoke(`Converting '{fileName}'.`)

            task.wait(0.1)

            local startTime = os.clock()
            local endTime

            local tab = table.create(indexes * 4, "")

            local function defaultWrite()
                for pixel_index = 0, indexes - 1 do 
                    local x = (pixel_index % width) + 1
                    local y = math.floor(pixel_index / width) + 1
                    
                    local R, G, B, A = pngData.readPixel(x, y)
                    
                    local byte_offset = pixel_index * 4
                    
                    tab[byte_offset + 1] = toHex(R)
                    tab[byte_offset + 2] = toHex(G)
                    tab[byte_offset + 3] = toHex(B)
                    tab[byte_offset + 4] = toHex(A)
                end

                endTime = math.floor((os.clock() - startTime) * 100 + 0.5) / 100
            end

            loadingTask = task.spawn(defaultWrite)

            repeat
                task.wait()
            until endTime or not loadingTask

            if not loadingTask then
                return
            end

            totalTime += endTime

            local output = Instance.new("ModuleScript")
            output.Name = fileName

            ScriptEditorService:UpdateSourceAsync(output, function()
                return `-- Generated with OSGL Image Uploader\n\nreturn \{\n\tversion = "1.6.2",\n\twidth = {width},\n\theight = {height},\n\tpixels = buffer.fromstring("\\x{table.concat(
                    tab,
                    "\\x"
                )}")\n}`
            end)

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
            local extraMessage = successFiles == amountOfFiles and ""
                or ` with <b>{amountOfFiles - successFiles}</b> error{diff == 1 and "" or "s"}.`
            notif.invoke(
                `Successfully converted <b>{successFiles}/{amountOfFiles}</b> files in <b>{totalTime}s</b>{extraMessage}`
            )
        end

        Selection:Set(selectedItems)

        _G.osglTools.imageEditorRunning = false
        pluginButton.Icon = "rbxassetid://71989091852609"
    end,
}
