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

local CoreGui = game:GetService("CoreGui")

local editorIsOpen = false
local currentEditor
local currentFile

local editorFolder = script.Parent
local osglTools = editorFolder.Parent

local UI = require(editorFolder.UI)
local t = require(editorFolder.types)
local Util = require(osglTools.util)

local Editor = {}

function Editor.isOpen()
    return editorIsOpen
end

function Editor.open(file: t.OSGLFile?)
    if editorIsOpen then
        return
    end

    editorIsOpen = true
    Editor.refreshCoreGui()
    Editor.mount(file)
end

function Editor.refreshCoreGui()
    local existingEditor = CoreGui:FindFirstChild("OSGLEditor")
    local templateEditor = game.StarterGui.OSGLEditor --editorFolder.OSGLEditor

    if not existingEditor and not currentEditor or existingEditor and currentEditor ~= existingEditor then
        if existingEditor then
            UI.cleanup()
            existingEditor:Destroy()
        end

        local newEditor = templateEditor:Clone()
        newEditor.Enabled = true
        newEditor.Parent = CoreGui

        Util.scale.Implement(newEditor, Vector2.new(1920, 1080))

        currentEditor = newEditor
        return
    end

    existingEditor.Enabled = true
end

function Editor.mount(file: t.OSGLFile?)
    if not currentEditor then
        return
    end

    if not file then
        file = currentFile
    end

    local toolbar = currentEditor.Screen.Topbar
    local centre = toolbar.Centre
    centre.ImageName.Text = file.name
    centre.Meta.Text = `{file.width}x{file.height}`
    
    currentFile = file

    UI.mount(currentEditor, currentFile)
end

function Editor.close()
    if not editorIsOpen then
        return
    end

    local bfr = UI.onClose(currentEditor)
    if currentFile then
        currentFile.buffer = bfr
    end

    editorIsOpen = false
end

return Editor
