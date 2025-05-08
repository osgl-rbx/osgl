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

local RunService = game:GetService("RunService")
if not plugin or not RunService:IsStudio() or RunService:IsRunning() then
    return
end

local osglScripts = script.Parent
local osglTools = osglScripts.Parent

local types = require(osglScripts.types)
local notif = require(osglScripts.notif)

local Toolbar = plugin:CreateToolbar("OSGL Tools")

_G.osglTools = {}

local connections: { RBXScriptConnection } = {}

for _, tool: Instance in osglTools:GetChildren() do
    local toolModule = tool:FindFirstChild("tool")
    if tool:IsA("Folder") and toolModule and toolModule:IsA("ModuleScript") then
        local moduleData: types.ToolbarData = require(toolModule)
        moduleData.Tooltip = moduleData.Tooltip or "OSGL " .. moduleData.Name
        moduleData.Id = moduleData.Id or moduleData.Name

        local pluginButton = Toolbar:CreateButton(moduleData.Id, moduleData.Tooltip, moduleData.Icon, moduleData.Name)
        pluginButton.ClickableWhenViewportHidden = true
        table.insert(
            connections,
            pluginButton.Click:Connect(function()
                moduleData.OnButtonClick(pluginButton)
            end)
        )
    end
end

notif.setup()

table.insert(
    connections,
    plugin.Unloading:Connect(function()
        for _, v in connections do
            v:Disconnect()
        end

        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        _G.osglTools.imageEditorRunning = false
    end)
)
