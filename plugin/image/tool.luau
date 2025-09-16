------------------------------------------------------------
-- OSGL v1.6.15 - Open-Source Graphical Library
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

local OSGL = require(osglTools.OSGL)
local color = OSGL.color

local r, g, b, a = color.r, color.g, color.b, color.a

local Img = require(image.image)
local ImgReader = Img.ImageReader
local notif = require(osglScripts.notif)

function toHex(num: number): string
    return string.format("%02X", num)
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
        local files: { File } = StudioService:PromptImportFiles({
            "BMP",
            "DIB",
            "PNG",
            "TGA",
            "JPEG",
            "JPG",
            "JPE",
            "JIF",
            "JFIF",
            "JFI",
        })

        for _, file in files do
            local Success, imgDat = pcall(function()
                local dat = ImgReader.open(file:GetBinaryContents())
                dat:WithGuessedFormat():Unwrap()
                return dat:Decode():Unwrap()
            end)

            local fileName = string.match(file.Name, "(.+)%..+$") or file.Name
            if not Success then
                notif.invoke(`Failed to convert Texture '{fileName}'! Could not convert file.`)
                continue
            end

            local width, height = imgDat.width, imgDat.height
            local indexes = width * height
            local bfr = table.create(indexes, 0)

            notif.invoke(`Converting '{fileName}'.`)

            task.wait(0.1)

            local startTime = os.clock()
            local endTime
            warn(imgDat)
            local Success, errorResult = pcall(function()
                for offset = 0, indexes - 1 do
                    local dat = buffer.readu32(imgDat.buffer, offset * 4)
                    bfr[offset + 1] = `\\x{toHex(r(dat))}\\x{toHex(g(dat))}\\x{toHex(b(dat))}\\x{toHex(a(dat))}`
                end

                endTime = math.floor((os.clock() - startTime) * 100 + 0.5) / 100
            end)

            if not Success then
                warn(errorResult)
                notif.invoke(`Failed to convert Texture '{fileName}'! Could not convert PNG.`)
                continue
            end

            totalTime += endTime

            local uneditedSource = [[
--!strict

local BFR: buffer?

type TextureData = {
    version: number,
    get: () -> (number, number, buffer),
    free: () -> ()
}

return {
    version = 1,
    get = function()
        if not BFR then
            BFR = buffer.fromstring("{1}")
        end

        return {2}, {3}, BFR
    end,

    free = function()
        BFR = nil
    end
}]]

            local output = Instance.new("ModuleScript")
            output.Name = fileName

            ScriptEditorService:UpdateSourceAsync(output, function()
                local str = uneditedSource:gsub("{1}", table.concat(bfr, "")):gsub("{2}", width):gsub("{3}", height)
                return str
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
