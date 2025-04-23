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

export type ToolbarData = {
    Name: string,
    Icon: string,
    Tooltip: string?,
    Id: string?,

    OnButtonClick: (Button: PluginToolbarButton) -> (),
}

return nil
