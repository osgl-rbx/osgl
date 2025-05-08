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
local editorTool = require(editorFolder.editorTool)
local OSGL = require(osglTools.OSGL)

local Tools = {}

export type Tools = typeof(Tools) & {
    tools: { [string]: editorTool.editorTool },
    selected: string?,
    toolSelected: boolean,
}

local function findTool(tools: Tools, name: string): editorTool.editorTool?
    for k, v in tools.tools do
        if k == name then
            return v
        end
    end
end

function Tools.CallFrame(self: Tools, window: OSGL.Window)
    if self.toolSelected then
        local tool = findTool(self, self.selected)
        if not tool then
            return
        end

        tool:Frame(window)
    end
end

function Tools.Add(self: Tools, Tool: editorTool.editorTool)
    local nameTaken = findTool(self, Tool.name)
    if nameTaken then
        return
    end

    self.tools[Tool.name] = Tool
    Tool:OnRegistration()
end

function Tools.Select(self: Tools, name: string)
    local toolExists = findTool(self, name)
    if not toolExists then
        return
    end

    if self.toolSelected then
        local tool = findTool(self, self.selected)
        tool:OnDeselect()
    end

    toolExists:OnSelect()
    self.toolSelected = true
    self.selected = name
end

function Tools.CallSelect(self: Tools, name: string)
    findTool(self, name):OnSelect()
end

function Tools.Deselect(self: Tools)
    if not self.selected then
        return
    end

    findTool(self, self.selected):OnDeselect()
    self.toolSelected = false
    self.selected = nil
end

function Tools.Cleanup(self: Tools)
    if self.selected then
        Tools:Deselect()
    end

    for _, v in self.tools do
        v:Cleanup()
    end

    table.clear(self.tools)
end

return {
    new = function(): Tools
        local Tools = table.clone(Tools)
        Tools.toolSelected = false
        Tools.selected = nil
        Tools.tools = {}
        Tools.callback = false

        return Tools
    end,
}
