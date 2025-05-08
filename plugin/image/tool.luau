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

local imageLoader = require(osglTools.util.image)
local const = require(osglTools.util.const)
local notif = require(osglScripts.notif)

return {
    Name = "Image Importer",
    Icon = "rbxassetid://71989091852609",

    OnButtonClick = function(pluginButton: PluginToolbarButton)
        if _G.osglTools.imageEditorRunning then
            return
        end

        _G.osglTools.imageEditorRunning = true

        local totalTime = 0
        local selectedParents = Selection:Get()
        local selectedItems = {}
        local successFiles = 0

        if #selectedParents == 0 then
            table.insert(selectedParents, workspace)
        end

        -- Prompt the user for files
        local files: { File } = StudioService:PromptImportFiles(const.supportedFileTypes)
        for _, file in files do
            local success, decoder = imageLoader.load(file)

            pluginButton.Icon = "rbxassetid://71989091852609"

            local fileName = string.match(file.Name, "(.+)%..+$") or file.Name
            if not success then
                notif.invoke(`Failed to convert Texture '{fileName}'! Could not convert Item.`)
                warn(`[osgl-tools]: Failed to convert Texture '{fileName}'`)
                continue
            end

            notif.invoke(`Converting '{fileName}'.`)

            local startTime = os.clock()
            local endTime
            local value

            value = decoder:asOSGL()
            endTime = os.clock() - startTime

            repeat
                task.wait()
            until endTime

            totalTime += endTime

            local output = Instance.new("ModuleScript")
            output.Name = fileName

            ScriptEditorService:UpdateSourceAsync(output, function()
                return value
            end)

            for _, parent in selectedParents do
                local newOutput = output:Clone()
                newOutput.Parent = parent

                table.insert(selectedItems, newOutput)
            end

            output:Destroy()
            notif.invoke(string.format("Successfully converted '%s' in %.2fs", fileName, endTime))

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
