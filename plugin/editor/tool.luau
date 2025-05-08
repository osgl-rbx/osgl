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

local editor = script.Parent

local Edit = require(editor.editor)

return {
    Name = "Image Editor",
    Icon = "rbxassetid://113861834125917",

    OnButtonClick = function(pluginButton: PluginToolbarButton)
        if Edit.isOpen() then
            Edit.close()
            return
        end

        Edit.open({
            width = 1024,
            height = 1024,
            buffer = buffer.create(1024 * 1024 * 4),
            name = "Untitled"
        })
    end
}