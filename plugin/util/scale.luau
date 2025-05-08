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

local Scale = {}

local function ApplyScale(object: GuiObject, xScale: number, yScale: number)
	local originalSize = object.Size
	local originalPosition = object.Position
	local anchor = object.AnchorPoint

	local originalPixelPosition = Vector2.new(
		originalPosition.X.Offset + (originalSize.X.Offset * anchor.X),
		originalPosition.Y.Offset + (originalSize.Y.Offset * anchor.Y)
	)

	object.Size = UDim2.new(
		originalSize.X.Scale,
		originalSize.X.Offset * xScale,
		originalSize.Y.Scale,
		originalSize.Y.Offset * yScale
	)

	local newPixelPosition = Vector2.new(originalPixelPosition.X * xScale, originalPixelPosition.Y * yScale)

	object.Position = UDim2.new(
		originalPosition.X.Scale,
		newPixelPosition.X - (object.Size.X.Offset * anchor.X),
		originalPosition.Y.Scale,
		newPixelPosition.Y - (object.Size.Y.Offset * anchor.Y)
	)

    local scaleFactor = math.min(
        xScale,
        yScale
    )

	local scaleKey = string.gsub(`Scaled_{xScale}_{yScale}`, ".", "_")
	for _, child in ipairs(object:GetDescendants()) do
		if child:GetAttribute(scaleKey) then
			return
		end

		if child:IsA("UIStroke") then
			child.Thickness = child.Thickness * scaleFactor
		end

		if child:IsA("UIPadding") then
			child.PaddingLeft = UDim.new(child.PaddingLeft.Scale, child.PaddingLeft.Offset * scaleFactor)
			child.PaddingRight = UDim.new(child.PaddingRight.Scale, child.PaddingRight.Offset * scaleFactor)
			child.PaddingTop = UDim.new(child.PaddingTop.Scale, child.PaddingTop.Offset * scaleFactor)
			child.PaddingBottom = UDim.new(child.PaddingBottom.Scale, child.PaddingBottom.Offset * scaleFactor)
		end

		if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
			child.TextSize *= scaleFactor
		end

		if child:IsA("UIListLayout") or child:IsA("UIGridLayout") then
			child.Padding = UDim.new(child.Padding.Scale, child.Padding.Offset * scaleFactor)
		end

		if child:IsA("UICorner") then
			child.CornerRadius = UDim.new(child.CornerRadius.Scale, child.CornerRadius.Offset * scaleFactor)
		end

		child:SetAttribute(scaleKey, true)
	end
end

function Scale.Implement(Base: ScreenGui, DesignResolution: Vector2, TargetResolution: Vector2?)
	repeat
		task.wait()
	until workspace.CurrentCamera.ViewportSize ~= Vector2.one

	TargetResolution = TargetResolution or workspace.CurrentCamera.ViewportSize

    if TargetResolution == DesignResolution then
        return
    end

	local Dx, Dy = DesignResolution.X, DesignResolution.Y
	local Tx, Ty = TargetResolution.X, TargetResolution.Y

	local xScale = Tx / Dx
	local yScale = Ty / Dy

	for _, v: GuiObject in Base:GetDescendants() do
		if v:IsA("GuiObject") then
			ApplyScale(v, xScale, yScale)
		end
	end
end

return Scale
