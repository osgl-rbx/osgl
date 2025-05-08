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

local editorFolder = script.Parent
local osglTools = editorFolder.Parent

local OSGL = require(osglTools.OSGL)

local editorTool = {}

export type editorTool = typeof(editorTool) & {
    name: string,
}

function editorTool:OnSelect() end

function editorTool:OnRegistration() end

function editorTool:Frame(Window: OSGL.Window) end

function editorTool:OnDeselect() end

function editorTool:Cleanup() end

return {
    new = function(name: string): editorTool
        local editorTool = table.clone(editorTool)
        editorTool.name = name

        return editorTool
    end,
}
