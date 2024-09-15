local imageEditor = script.Parent.Parent
local BaseTool = require(imageEditor.ToolHandler.BaseTool)
local types = require(imageEditor.types)
local mouseData = require(imageEditor.ToolHandler.mouseData)

local OSGL = require(imageEditor.OSGL)
local OSGLTypes = OSGL.types
local draw = OSGL.draw
local color = OSGL.color

local Pen = {}
setmetatable(Pen, BaseTool)
Pen.__index = Pen

type PenTool = types.BaseTool & {
	color: OSGLTypes.Color,
}

function Pen.new()
	local self = setmetatable({
		color = color.RED,
		previousMousePointX = nil,
		previousMousePointY = nil,
	}, Pen)

	return self
end

function Pen.HandleInput(self: PenTool, input: InputObject, window: OSGLTypes.Window)
	local isInWindow, x, y = window:GetRelativeMouse()
	if not isInWindow or not mouseData.MouseButton1Down then
        self.previousMousePointX = nil
		self.previousMousePointY = nil
		return
	end

	if self.previousMousePointX and self.previousMousePointY then
		draw.line(window, {
			startX = self.previousMousePointX,
			startY = self.previousMousePointY,
			stopX = x,
			stopY = y,
            color = self.color
		})
	else
		draw.pixel(window, x, y, self.color)
	end

	self.previousMousePointX, self.previousMousePointY = x, y
	window:Render()
end


return Pen
