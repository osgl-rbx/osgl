------------------------------------------------------------
-- OSGL v1.6b - Open-Source Graphical Library
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

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local DrawableObject = script.Parent
local base = require(DrawableObject.base)

local OSGL = DrawableObject.Parent
local types = require(OSGL.types)
local util = require(OSGL.util)

-- Luau Micro-Optimisations
local VecZero = Vector2.zero

local WindowBaseImpl = {}

--[=[
<strong>@OSGL/Window</strong>
<em>Renders a </em><code>Window</code><em>'s buffer to the </em><code>EditableImage</code><em>.</em>
  ]=]
function WindowBaseImpl.Render(self: types.Window)
    self.editableImage:WritePixelsBuffer(VecZero, self.size, self.buffer)
end

--[=[
<strong>@OSGL/Window</strong>
<em>Adds an additional list of objects to render the </em><code>Window</code><em> to.</em>
  ]=]
function WindowBaseImpl.AddRenderers(self: types.Window, ...: types.Drawable)
    for _, v in table.pack(...) do
        if not table.find(self.surfaces, v) then
            local prop = util.getRendererProp()
            if prop == "" then
                return
            end

            v[prop] = self.editableImage

            table.insert(self.surfaces, v)
        end
    end
end

--[=[
<strong>@OSGL/Window</strong>
<em>Removes a list of objects that the </em><code>Window</code><em> is currently rendering to</em>
  ]=]
function WindowBaseImpl.RemoveRenderers(self: types.Window, ...: types.Drawable)
    for _, v in table.pack(...) do
        local indexFound = table.find(self.surfaces, v)
        if indexFound then
            local prop = util.getRendererProp()
            if prop == "" then
                return
            end

            v[prop] = Content.none

            table.remove(self.surfaces, indexFound)
        end
    end
end

--[=[
<strong>@OSGL/Window</strong>
<em>Returns whether the mouse is hovering over the </em><code>Window</code><em>, and if so what its X and Y positions are relative to the top-left corner.</em>
  ]=]
function WindowBaseImpl.GetRelativeMousePosition(self: types.Window, image: types.ImageBase): (boolean, number, number)
    local width, height = self.width, self.height
    local sizeFactor = self.size / image.AbsoluteSize
    local inset, _ = GuiService:GetGuiInset()
    local mousePosition = UserInputService:GetMouseLocation() - image.AbsolutePosition - inset

    local relativeMousePosition = mousePosition * sizeFactor

    local x = math.round(relativeMousePosition.X)
    local y = math.round(relativeMousePosition.Y)

    local isInImage = x >= 0 and y >= 0 and x < width and y < height

    return isInImage, isInImage and x or 0, isInImage and y or 0
end

export type WindowBase = base.Base & typeof(WindowBaseImpl)

return {
    new = function(): WindowBase
        local t = base.new()

        t.Render = WindowBaseImpl.Render
        t.AddRenderers = WindowBaseImpl.AddRenderers
        t.RemoveRenderers = WindowBaseImpl.RemoveRenderers
        t.GetRelativeMousePosition = WindowBaseImpl.GetRelativeMousePosition

        return t
    end
}