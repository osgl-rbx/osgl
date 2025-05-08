type PluginColorPicker = {
	Prompt : (self : PluginColorPicker, startingColor : Color3?) -> Color3?,
	BindToChange : (self : PluginColorPicker, (Color3) -> nil) -> nil,
	Set : (self : PluginColorPicker, color : Color3) -> nil,
	Cancel : (self : PluginColorPicker, Color3?) -> nil,
	Destroy : (self : PluginColorPicker) -> nil,
	IsOpened : (self : PluginColorPicker) -> boolean,
}

local RunService = game:GetService('RunService')

local PluginColorPicker = {}
PluginColorPicker.__index = PluginColorPicker

local plugin = script:FindFirstAncestorOfClass("Plugin")

local studioSettings = settings().Studio
local themeChanged = studioSettings.ThemeChanged

local function isRight359(str : string) : boolean
	local num : number? = tonumber(str)

	if num == 0 and string.len(str) > 1 then return false end

	return (num and num <= 359 and num >= 0)
end

local function isRight255(str : string) : boolean
	local num : number? = tonumber(str)

	if num == 0 and string.len(str) > 1 then return false end

	return (num and num <= 255 and num >= 0)
end

local function isRightHex(str : string) : boolean

	if str == '' then return true end

	local signString : string = string.sub(str, 1, 1)
	local numberString : string = string.sub(str, 2, 7)
	local hexMatch : string = string.match(numberString, '%x+')
	local isHexString : boolean = hexMatch == numberString and string.len(str) <= 7

	if signString == '#' and (numberString == '' or isHexString) then
		return true
	end

	return false
end

local function Get255RGB(color : Color3) : (number, number, number)
	return math.round(color.R * 255), math.round(color.G * 255), math.round(color.B * 255)
end

local function Color3FuzzyEq(color1 : Color3, color2 : Color3) : boolean
	local r1 : number, g1 : number, b1 : number = Get255RGB(color1)
	local r2 : number, g2 : number, b2 : number = Get255RGB(color2)

	local rRight : boolean, gRight : boolean, bRight : boolean = r1 == r2, g1 == g2, b1 == b2

	return rRight and gRight and bRight
end

local function SafeFromHex(str : string) : Color3?
	local success : boolean, color : Color3 = pcall(Color3.fromHex, str)

	if success then return color end
end

local function DisconnectTextboxInfo(textboxInfo)
	textboxInfo.textCon:Disconnect()
	textboxInfo.cursorCon:Disconnect()
	textboxInfo.selectionCon:Disconnect()
end

local function ConnectTextboxInfo(textboxInfo)
	
	local textboxBackground = textboxInfo.textboxBackground
	local textbox = textboxBackground.Textbox
	
	textboxInfo.olderCursor = textbox.CursorPosition
	textboxInfo.olderSelection = textbox.SelectionStart

	textboxInfo.oldCursor = textbox.CursorPosition
	textboxInfo.oldSelection = textbox.SelectionStart

	textboxInfo.textCon = textbox:GetPropertyChangedSignal('Text'):Connect(function()
		textboxInfo.textFunction()

		if textbox.Text ~= '' then
			textboxInfo.savedValue = textbox.Text
		end

		textboxInfo.oldValue = textbox.Text
	end)

	textboxInfo.cursorCon = textbox:GetPropertyChangedSignal('CursorPosition'):Connect(function()
		textboxInfo.olderCursor = textboxInfo.oldCursor
		textboxInfo.oldCursor = textbox.CursorPosition
	end)

	textboxInfo.selectionCon = textbox:GetPropertyChangedSignal('SelectionStart'):Connect(function()
		textboxInfo.olderSelection = textboxInfo.oldSelection
		textboxInfo.oldSelection = textbox.SelectionStart
	end)
end

local function WrapTopBottomBorders(guiObject)
	local TopBorder = Instance.new('Frame')
	TopBorder.ZIndex = 2
	TopBorder.Position = UDim2.new(0, -1, 0, -1)
	TopBorder.Size = UDim2.new(1, 1, 1, 1)
	TopBorder.BorderSizePixel = 0
	TopBorder.Name = 'TopBorder'

	local BottomBorder = Instance.new('Frame')
	BottomBorder.Name = 'BottomBorder'
	BottomBorder.ZIndex = 1
	BottomBorder.Position = UDim2.new(0, -1, 0, -1)
	BottomBorder.Size = UDim2.new(1, 2, 1, 2)
	BottomBorder.BorderSizePixel = 0

	TopBorder.Parent = guiObject
	BottomBorder.Parent = guiObject
end

local function WrapTextboxBackground(textboxBackground, textboxLabelText)
	local TextboxPadding = Instance.new('UIPadding')
	TextboxPadding.PaddingLeft = UDim.new(0, 3)

	local TextLabelPadding = Instance.new("UIPadding")
	TextLabelPadding.PaddingRight = UDim.new(0, 10)

	local TextLabel = Instance.new("TextLabel")
	TextLabel.AnchorPoint = Vector2.new(1, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Size = UDim2.new(0, 50, 0, 18)
	TextLabel.Text = textboxLabelText
	TextLabel.TextXAlignment = Enum.TextXAlignment.Right
	TextLabel.Font = Enum.Font.SourceSans
	TextLabel.TextSize = 14

	TextLabelPadding.Parent = TextLabel
	TextLabel.Parent = textboxBackground
	TextboxPadding.Parent = textboxBackground.Textbox
end	

local function WrapTextboxArrows(textbox)
	local upArrow = Instance.new('ImageButton')
	upArrow.BackgroundTransparency = 1
	upArrow.BorderSizePixel = 0
	upArrow.AnchorPoint = Vector2.new(1, 0)
	upArrow.Position = UDim2.new(1, -1, 0, 1)
	upArrow.Rotation = 1
	upArrow.Size = UDim2.fromOffset(16, 8)
	upArrow.Image = 'rbxassetid://129502343292983'
	upArrow.ZIndex = 12
	upArrow.ScaleType = Enum.ScaleType.Fit
	upArrow.ResampleMode = Enum.ResamplerMode.Default
	upArrow.BackgroundColor3 = Color3.new(1, 1, 1)
	upArrow.ImageColor3 = Color3.new(1, 1, 1)
	upArrow.BorderSizePixel = 0
	upArrow.AutoButtonColor = false
	upArrow.Name = 'UpArrow'

	local downArrow = Instance.new('ImageButton')
	downArrow.BackgroundTransparency = 1
	downArrow.BorderSizePixel = 0
	downArrow.AnchorPoint = Vector2.new(1, 1)
	downArrow.Position = UDim2.new(1, -1, 1, -2)
	downArrow.Rotation = 180
	downArrow.Size = UDim2.fromOffset(16, 8)
	downArrow.Image = 'rbxassetid://129502343292983'
	downArrow.ScaleType = Enum.ScaleType.Fit
	downArrow.ResampleMode = Enum.ResamplerMode.Default
	downArrow.ZIndex = 12
	downArrow.BackgroundColor3 = Color3.new(1, 1, 1)
	downArrow.ImageColor3 = Color3.new(1, 1, 1)
	downArrow.BorderSizePixel = 0
	downArrow.AutoButtonColor = false
	downArrow.Name = 'DownArrow'

	downArrow.Parent = textbox
	upArrow.Parent = textbox
end

local function CreateTextboxForBackground(textboxBackground)
	local textbox = Instance.new("TextBox")
	textbox.Name = 'Textbox'
	textbox.ClearTextOnFocus = false
	textbox.Font = Enum.Font.SourceSans
	textbox.TextSize = 14
	textbox.TextXAlignment = Enum.TextXAlignment.Left
	textbox.ZIndex = 11
	textbox.Position = UDim2.new()
	textbox.Size = UDim2.new(0, 24, 1, 0)
	textbox.BackgroundTransparency = 1
	textbox.Parent = textboxBackground
end

function PluginColorPicker.new(pluginGuiId : string) : PluginColorPicker

	assert(pluginGuiId, 'You should specify pluginGuiId as first argument when creating Color Picker!')

	local self = setmetatable({}, PluginColorPicker)

	local dockWidgetPluginGui = plugin:CreateDockWidgetPluginGui(pluginGuiId, DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, true, 287, 419))
	dockWidgetPluginGui.Title = 'Select Color'

	-- create gui objects

	local Background = Instance.new("Frame")
	Background.Name = 'Background'
	Background.BackgroundTransparency = 1
	Background.AnchorPoint = Vector2.new(0.5, 0.5)
	Background.Position = UDim2.fromScale(0.5, 0.5)
	Background.Size = UDim2.fromOffset(287, 399)
	Background.BackgroundColor3 = Color3.new(1, 1, 1)

	local OKButton = Instance.new("TextButton")
	OKButton.Name = 'OKButton'
	OKButton.Text = 'OK'
	OKButton.AnchorPoint = Vector2.new(1, 1)
	OKButton.AutoButtonColor = false
	OKButton.BorderSizePixel = 1
	OKButton.Position = UDim2.new(1, -93, 1, -12)
	OKButton.Size = UDim2.new(0, 73, 0, 23)
	OKButton.ZIndex = 11
	OKButton.Font = Enum.Font.SourceSans
	OKButton.TextSize = 14
	OKButton.Parent = Background

	local CancelButton = Instance.new("TextButton")
	CancelButton.Name = 'CancelButton'
	CancelButton.Text = 'Cancel'
	CancelButton.AnchorPoint = Vector2.new(1, 1)
	CancelButton.AutoButtonColor = false
	CancelButton.BorderSizePixel = 1
	CancelButton.Position = UDim2.new(1, -12, 1, -12)
	CancelButton.Size = UDim2.new(0, 73, 0, 23)
	CancelButton.ZIndex = 11
	CancelButton.Font = Enum.Font.SourceSans
	CancelButton.TextSize = 14
	CancelButton.Parent = Background

	local Hex = Instance.new("Frame")
	Hex.Name = 'Hex'
	Hex.AnchorPoint = Vector2.new(1, 1)
	Hex.BorderSizePixel = 2
	Hex.Position = UDim2.new(1, -68, 1, -50)
	Hex.Size = UDim2.new(0, 91, 0, 19)
	Hex.ZIndex = 11
	Hex.Parent = Background

	local HexTextboxUIStroke = Instance.new('UIStroke')
	HexTextboxUIStroke.LineJoinMode = Enum.LineJoinMode.Miter
	HexTextboxUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	HexTextboxUIStroke.Parent = Hex

	local Blue = Instance.new('Frame')
	Blue.Name = 'Blue'
	Blue.AnchorPoint = Vector2.new(1, 1)
	Blue.BorderSizePixel = 1
	Blue.Position = UDim2.new(1, -18, 1, -82)
	Blue.Size = UDim2.new(0, 41, 0, 19)
	Blue.ZIndex = 11
	Blue.Parent = Background

	local Green = Instance.new("Frame")
	Green.Name = 'Green'
	Green.AnchorPoint = Vector2.new(1, 1)
	Green.BorderSizePixel = 1
	Green.Position = UDim2.new(1, -18, 1, -109)
	Green.Size = UDim2.new(0, 41, 0, 19)
	Green.ZIndex = 11
	Green.Parent = Background

	local Red = Instance.new("Frame")
	Red.Name = 'Red'
	Red.AnchorPoint = Vector2.new(1, 1)
	Red.BorderSizePixel = 1
	Red.Position = UDim2.new(1, -18, 1, -136)
	Red.Size = UDim2.new(0, 41, 0, 19)
	Red.ZIndex = 11
	Red.Parent = Background

	local Val = Instance.new('Frame')
	Val.Name = 'Val'
	Val.AnchorPoint = Vector2.new(1, 1)
	Val.BorderSizePixel = 1
	Val.Position = UDim2.new(1, -119, 1, -82)
	Val.Size = UDim2.new(0, 41, 0, 19)
	Val.ZIndex = 11
	Val.Parent = Background

	local Sat = Instance.new('Frame')
	Sat.Name = 'Sat'
	Sat.AnchorPoint = Vector2.new(1, 1)
	Sat.BorderSizePixel = 1
	Sat.Position = UDim2.new(1, -119, 1, -109)
	Sat.Size = UDim2.new(0, 41, 0, 19)
	Sat.ZIndex = 11
	Sat.Parent = Background

	local Hue = Instance.new('Frame')
	Hue.Name = 'Hue'
	Hue.AnchorPoint = Vector2.new(1, 1)
	Hue.BorderSizePixel = 1
	Hue.Position = UDim2.new(1, -119, 1, -136)
	Hue.Size = UDim2.new(0, 41, 0, 19)
	Hue.ZIndex = 11
	Hue.Parent = Background

	local ColorShow = Instance.new("Frame")
	ColorShow.Name = 'ColorShow'
	ColorShow.AnchorPoint = Vector2.new(0, 1)
	ColorShow.BorderSizePixel = 0
	ColorShow.Position = UDim2.new(0, 13, 1, -49)
	ColorShow.Size = UDim2.new(0, 58, 0, 106)
	ColorShow.ZIndex = 3
	ColorShow.Parent = Background

	local ColorChoose = Instance.new('Frame')
	ColorChoose.Name = 'ColorChoose'
	ColorChoose.BorderSizePixel = 0
	ColorChoose.Position = UDim2.new(0, 13, 0, 21)
	ColorChoose.Size = UDim2.new(0, 220, 0, 200)
	ColorChoose.BackgroundColor3 = Color3.new(1, 1, 1)
	ColorChoose.ZIndex = 3
	ColorChoose.Parent = Background

	local WhiteOverlay = Instance.new("Frame")
	WhiteOverlay.Name = 'WhiteOverlay'
	WhiteOverlay.BorderSizePixel = 0
	WhiteOverlay.Size = UDim2.new(1, 0, 1, 0)
	WhiteOverlay.ZIndex = 4
	WhiteOverlay.ClipsDescendants = true
	WhiteOverlay.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	WhiteOverlay.Parent = ColorChoose

	local ColorChooseCursor = Instance.new('ImageLabel')
	ColorChooseCursor.Name = 'Cursor'
	ColorChooseCursor.BackgroundTransparency = 1
	ColorChooseCursor.Image = 'http://www.roblox.com/asset/?id=78763415020111'
	ColorChooseCursor.ImageColor3 = Color3.fromRGB(0, 0, 0)
	ColorChooseCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorChooseCursor.Size = UDim2.new(0, 20, 0, 20)
	ColorChooseCursor.ZIndex = 5
	ColorChooseCursor.Parent = WhiteOverlay

	local WhiteOverlayGradient = Instance.new("UIGradient")
	WhiteOverlayGradient.Rotation = 90
	WhiteOverlayGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1, 0),
		NumberSequenceKeypoint.new(1, 0, 0)
	})

	local ColorChooseGradient = Instance.new('UIGradient')
	ColorChooseGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
	})

	WhiteOverlayGradient.Parent = WhiteOverlay
	ColorChooseGradient.Parent = ColorChoose

	local ValueChoose = Instance.new('Frame')
	ValueChoose.Name = 'ValueChoose'
	ValueChoose.ZIndex = 3
	ValueChoose.BorderSizePixel = 0
	ValueChoose.AnchorPoint = Vector2.new(1, 0)
	ValueChoose.Position = UDim2.new(1, -23, 0, 21)
	ValueChoose.Size = UDim2.new(0, 13, 0, 200)
	ValueChoose.BackgroundColor3 = Color3.new(1, 1, 1)
	ValueChoose.Parent = Background

	local ValueChooseGradient = Instance.new("UIGradient")
	ValueChooseGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
	ValueChooseGradient.Rotation = 90
	ValueChooseGradient.Parent = ValueChoose

	local ValueChooseCursor = Instance.new('ImageLabel')
	ValueChooseCursor.Name = 'Cursor'
	ValueChooseCursor.AnchorPoint = Vector2.new(0, 0.5)
	ValueChooseCursor.BackgroundTransparency = 1
	ValueChooseCursor.Size = UDim2.new(0, 5, 0, 9)
	ValueChooseCursor.Image = 'http://www.roblox.com/asset/?id=133922388288237'
	ValueChooseCursor.Position = UDim2.new(1, 1, 0, 0)
	ValueChooseCursor.Parent = ValueChoose

	local ValueChooseHitbox = Instance.new('TextButton')
	ValueChooseHitbox.ZIndex = 11
	ValueChooseHitbox.Transparency = 1
	ValueChooseHitbox.Name = 'Hitbox'
	ValueChooseHitbox.Position = UDim2.fromScale(0, 1)
	ValueChooseHitbox.Size = UDim2.new(1, 6, 1, 4)
	ValueChooseHitbox.AnchorPoint = Vector2.new(0, 1)
	ValueChooseHitbox.BackgroundColor3 = Color3.new(1, 1, 1)
	ValueChooseHitbox.Parent = ValueChoose

	local ColorChooseHitbox = Instance.new('TextButton')
	ColorChooseHitbox.ZIndex = 11
	ColorChooseHitbox.Transparency = 1
	ColorChooseHitbox.Name = 'Hitbox'
	ColorChooseHitbox.Size = UDim2.fromScale(1, 1)
	ColorChooseHitbox.Position = UDim2.new()
	ColorChooseHitbox.BackgroundColor3 = Color3.new(1, 1, 1)
	ColorChooseHitbox.Parent = ColorChoose

	local MainHitbox = Instance.new('TextButton')
	MainHitbox.Active = false
	MainHitbox.ZIndex = 10
	MainHitbox.Transparency = 1
	MainHitbox.Name = 'MainHitbox'
	MainHitbox.Size = UDim2.fromScale(1, 1)
	MainHitbox.Position = UDim2.new()
	MainHitbox.Parent = dockWidgetPluginGui
	
	CreateTextboxForBackground(Hex)
	CreateTextboxForBackground(Red)
	CreateTextboxForBackground(Blue)
	CreateTextboxForBackground(Green)
	CreateTextboxForBackground(Hue)
	CreateTextboxForBackground(Sat)
	CreateTextboxForBackground(Val)
	
	Hex.Textbox.Text = '#ffffff'
	Hex.Textbox.Size = UDim2.new(1, 0, 1, 0)
	
	Red.Textbox.Text = '255'
	Blue.Textbox.Text = '255'
	Green.Textbox.Text = '255'
	Hue.Textbox.Text = '0'
	Sat.Textbox.Text = '255'
	Val.Textbox.Text = '255'

	--

	-- set selfs

	self.isOpened = false

	self.DockWidgetPluginGui = dockWidgetPluginGui
	self.Background = Background

	--

	-- connections

	local runCon = nil

	self.cons = {
		themeChanged:Connect(function()
			self:UpdateTheme()
		end),

		MainHitbox.MouseEnter:Connect(function()
			if runCon then runCon:Disconnect() end
		end),

		MainHitbox.MouseLeave:Connect(function()
			if runCon then runCon:Disconnect() end
		end),

		MainHitbox.MouseButton1Up:Connect(function()
			if runCon then runCon:Disconnect() end
		end),

		CancelButton.MouseButton1Up:Connect(function()
			if runCon then runCon:Disconnect() end
		end),

		OKButton.MouseButton1Up:Connect(function()
			if runCon then runCon:Disconnect() end
		end),

		ColorChooseHitbox.MouseButton1Up:Connect(function()
			if runCon then runCon:Disconnect() end
		end),

		ValueChooseHitbox.MouseButton1Up:Connect(function()
			if runCon then runCon:Disconnect() end
		end),

		ColorChooseHitbox.MouseButton1Down:Connect(function()
			if runCon then runCon:Disconnect() end

			local lastMousePosition : Vector2 = Vector2.new()

			runCon = RunService.RenderStepped:Connect(function()
				local currentMousePosition : Vector2 = dockWidgetPluginGui:GetRelativeMousePosition()
				local satTextbox = self.Background.Sat.Textbox
				local hueTextbox = self.Background.Hue.Textbox

				if currentMousePosition ~= lastMousePosition then

					local normalOffset : Vector2 = currentMousePosition - self.Background.ColorChoose.AbsolutePosition
					local offsetX : number = math.clamp(normalOffset.X, 0, self.Background.ColorChoose.AbsoluteSize.X)
					local offsetY : number = math.clamp(normalOffset.Y, 0, self.Background.ColorChoose.AbsoluteSize.Y)

					local newHue : number = offsetX / self.Background.ColorChoose.AbsoluteSize.X
					local newSat : number = offsetY / self.Background.ColorChoose.AbsoluteSize.Y

					satTextbox.Text = tonumber(math.round((1 - newSat) * 255))

					task.defer(function() -- very dumb fix
						hueTextbox.Text = tonumber(math.round((1 - newHue) * 359))
					end)

					lastMousePosition = currentMousePosition
				end
			end)
		end),

		ValueChooseHitbox.MouseButton1Down:Connect(function()
			if runCon then runCon:Disconnect() end

			local lastMousePosition : Vector2 = Vector2.new()

			runCon = RunService.RenderStepped:Connect(function()
				local currentMousePosition : Vector2 = dockWidgetPluginGui:GetRelativeMousePosition()
				local valTextbox = self.Background.Val.Textbox

				if currentMousePosition ~= lastMousePosition then

					local normalOffsetY : number = currentMousePosition.Y - self.Background.ValueChoose.AbsolutePosition.Y
					local offsetY : number = math.clamp(normalOffsetY, 0, self.Background.ValueChoose.AbsoluteSize.Y)

					local newVal : number = offsetY / self.Background.ValueChoose.AbsoluteSize.Y

					valTextbox.Text = tostring(math.round((1 - newVal) * 255))

					lastMousePosition = currentMousePosition
				end
			end)
		end),
		
		
	}

	--

	-- textboxes wrap!

	local hexTextboxInfo = {textboxBackground = Hex}
	hexTextboxInfo.textFunction = function()
		if isRightHex(Hex.Textbox.Text) then
			local fromHex : Color3? = SafeFromHex(Hex.Textbox.Text)

			if fromHex then self:Set(fromHex) end
		else
			DisconnectTextboxInfo(hexTextboxInfo)

			Hex.Textbox.Text = hexTextboxInfo.oldValue
			Hex.Textbox.CursorPosition = hexTextboxInfo.olderCursor
			Hex.Textbox.SelectionStart = hexTextboxInfo.olderSelection

			ConnectTextboxInfo(hexTextboxInfo)
		end
	end

	local hueTextboxInfo = {textboxBackground = Hue, maxValue = '359'}
	hueTextboxInfo.textFunction = function()

		if Hue.Textbox.Text == '' then return end

		local hue : number, sat : number, val : number = self.color:ToHSV()

		if isRight359(Hue.Textbox.Text) then
			self:Set(Color3.fromHSV(tonumber(Hue.Textbox.Text) / 359, sat, val))
		else
			DisconnectTextboxInfo(hueTextboxInfo)

			Hue.Textbox.Text = hueTextboxInfo.oldValue
			Hue.Textbox.CursorPosition = hueTextboxInfo.olderCursor
			Hue.Textbox.SelectionStart = hueTextboxInfo.olderSelection

			ConnectTextboxInfo(hueTextboxInfo)
		end
	end

	local satTextboxInfo = {textboxBackground = Sat, maxValue = '255'}
	satTextboxInfo.textFunction = function()

		if Sat.Textbox.Text == '' then return end

		local hue : number, sat : number, val : number = self.color:ToHSV()

		if isRight255(Sat.Textbox.Text) then
			self:Set(Color3.fromHSV(tonumber(Hue.Textbox.Text) / 359, tonumber(Sat.Textbox.Text) / 255, val))
		else
			DisconnectTextboxInfo(satTextboxInfo)

			Sat.Textbox.Text = satTextboxInfo.oldValue
			Sat.Textbox.CursorPosition = satTextboxInfo.olderCursor
			Sat.Textbox.SelectionStart = satTextboxInfo.olderSelection

			ConnectTextboxInfo(satTextboxInfo)
		end
	end

	local valTextboxInfo = {textboxBackground = Val, maxValue = '255'}
	valTextboxInfo.textFunction = function()

		if Val.Textbox.Text == '' then return end

		if isRight255(Val.Textbox.Text) then
			self:Set(Color3.fromHSV(tonumber(Hue.Textbox.Text / 359), tonumber(Sat.Textbox.Text) / 255, tonumber(Val.Textbox.Text) / 255))
		else
			DisconnectTextboxInfo(valTextboxInfo)

			Val.Textbox.Text = valTextboxInfo.oldValue
			Val.Textbox.CursorPosition = valTextboxInfo.olderCursor
			Val.Textbox.SelectionStart = valTextboxInfo.olderSelection

			ConnectTextboxInfo(valTextboxInfo)
		end
	end

	local redTextboxInfo = {textboxBackground = Red, maxValue = '255'}
	redTextboxInfo.textFunction = function()

		if Red.Textbox.Text == '' then return end

		local r : number, g : number, b : number = Get255RGB(self.color)

		if isRight255(Red.Textbox.Text) then
			self:Set(Color3.fromRGB(tonumber(Red.Textbox.Text), g, b))
		else
			DisconnectTextboxInfo(redTextboxInfo)

			Red.Textbox.Text = redTextboxInfo.oldValue
			Red.Textbox.CursorPosition = redTextboxInfo.olderCursor
			Red.Textbox.SelectionStart = redTextboxInfo.olderSelection

			ConnectTextboxInfo(redTextboxInfo)
		end
	end

	local greenTextboxInfo = {textboxBackground = Green, maxValue = '255'}
	greenTextboxInfo.textFunction = function()

		if Green.Textbox.Text == '' then return end

		local r : number, g : number, b : number = Get255RGB(self.color)

		if isRight255(Green.Textbox.Text) then
			self:Set(Color3.fromRGB(r, tonumber(Green.Textbox.Text), b))
		else
			DisconnectTextboxInfo(greenTextboxInfo)

			Green.Textbox.Text = greenTextboxInfo.oldValue
			Green.Textbox.CursorPosition = greenTextboxInfo.olderCursor
			Green.Textbox.SelectionStart = greenTextboxInfo.olderSelection

			ConnectTextboxInfo(greenTextboxInfo)
		end
	end

	local blueTextboxInfo = {textboxBackground = Blue, maxValue = '255'}
	blueTextboxInfo.textFunction = function()

		if Blue.Textbox.Text == '' then return end

		local r : number, g : number, b : number = Get255RGB(self.color)

		if isRight255(Blue.Textbox.Text) then
			self:Set(Color3.fromRGB(r, g, tonumber(Blue.Textbox.Text)))
		else
			DisconnectTextboxInfo(blueTextboxInfo)

			Blue.Textbox.Text = blueTextboxInfo.oldValue
			Blue.Textbox.CursorPosition = blueTextboxInfo.olderCursor
			Blue.Textbox.SelectionStart = blueTextboxInfo.olderSelection

			ConnectTextboxInfo(blueTextboxInfo)
		end
	end
	
	self.textboxes = {
		hexTextboxInfo,
		hueTextboxInfo,
		valTextboxInfo,
		satTextboxInfo,
		redTextboxInfo,
		greenTextboxInfo,
		blueTextboxInfo
	}

	--

	-- wrap some stuff (Textboxes, Arrows, Bottom and top borders, arrow mechanics)

	WrapTextboxBackground(Blue, 'Blue:')
	WrapTextboxBackground(Red, 'Red:')
	WrapTextboxBackground(Green, 'Green:')
	WrapTextboxBackground(Val, 'Val:')
	WrapTextboxBackground(Sat, 'Sat:')
	WrapTextboxBackground(Hue, 'Hue:')
	WrapTextboxBackground(Hex, 'Hex:')

	WrapTextboxArrows(Blue)
	WrapTextboxArrows(Red)
	WrapTextboxArrows(Green)
	WrapTextboxArrows(Val)
	WrapTextboxArrows(Sat)
	WrapTextboxArrows(Hue)

	WrapTopBottomBorders(ValueChoose)
	WrapTopBottomBorders(ColorChoose)
	WrapTopBottomBorders(ColorShow)
	
	self.bottomBorders = {
		ValueChoose.BottomBorder,
		ColorChoose.BottomBorder,
		ColorShow.BottomBorder
	}
	
	self.topBorders = {
		ValueChoose.TopBorder,
		ColorChoose.TopBorder,
		ColorShow.TopBorder
	}
	
	self.upArrows = {
		Blue.UpArrow,
		Red.UpArrow,
		Green.UpArrow,
		Val.UpArrow,
		Hue.UpArrow,
		Sat.UpArrow
	}
	
	self.downArrows = {
		Blue.DownArrow,
		Red.DownArrow,
		Green.DownArrow,
		Val.DownArrow,
		Hue.DownArrow,
		Sat.DownArrow
	}

	local lastArrowThread = nil

	for _, textboxInfo in ipairs(self.textboxes) do
		ConnectTextboxInfo(textboxInfo)
		
		local textboxBackground = textboxInfo.textboxBackground
		local textbox = textboxBackground.Textbox

		local focusedCon = textbox.Focused:Connect(function()
			self.focusedTextbox = textboxBackground

			textboxBackground.BorderColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBorder, Enum.StudioStyleGuideModifier.Selected)
		end)

		local focusLostCon = textbox.FocusLost:Connect(function()
			if self.focusedTextbox == textboxBackground then self.focusedTextbox = nil end

			textboxBackground.BorderColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBorder, Enum.StudioStyleGuideModifier.Default)

			if textbox.Text == '' and textboxBackground.Name ~= 'Hex' then
				DisconnectTextboxInfo(textboxInfo)

				textbox.Text = textboxInfo.savedValue

				ConnectTextboxInfo(textboxInfo)
			end
		end)

		if textboxBackground == Hex then continue end

		local upArrow = textboxBackground.UpArrow
		local downArrow = textboxBackground.DownArrow

		upArrow.MouseButton1Down:Connect(function()
			
			textbox:CaptureFocus()
			textbox.CursorPosition = 1
			
			if textboxInfo.savedValue ~= textboxInfo.maxValue then
				
				textbox.SelectionStart = string.len(textbox.Text) + 1
				
				upArrow.BackgroundTransparency = 0
				upArrow.BackgroundColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Selected)

				if lastArrowThread then task.cancel(lastArrowThread) lastArrowThread = nil end

				textbox.Text = tonumber(textbox.Text) + 1
				
				textbox.SelectionStart = string.len(textbox.Text) + 1

				lastArrowThread = task.delay(0.3, function()

					local total : number = 0

					while true do
						if textboxInfo.savedValue == textboxInfo.maxValue then
							break
						end

						total += RunService.Heartbeat:Wait()

						textbox.Text = tonumber(textbox.Text) + total // 0.1
						total %= 0.1
						
						textbox.SelectionStart = string.len(textbox.Text) + 1
					end
				end)
			end
		end)

		downArrow.MouseButton1Down:Connect(function()
			
			textbox:CaptureFocus()
			textbox.CursorPosition = 1
			
			if textboxInfo.savedValue ~= '0' then
				
				textbox.SelectionStart = string.len(textbox.Text) + 1
				
				textbox.SelectionStart = string.len(textbox.Text) + 1
				
				downArrow.BackgroundTransparency = 0
				downArrow.BackgroundColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Selected)

				if lastArrowThread then task.cancel(lastArrowThread) lastArrowThread = nil end

				textbox.Text = tonumber(textbox.Text) - 1

				lastArrowThread = task.delay(0.3, function()

					local total : number = 0

					while true do
						if textboxInfo.savedValue == '0' then
							break
						end

						total += RunService.Heartbeat:Wait()

						textbox.Text = tonumber(textbox.Text) - total // 0.15
						total %= 0.15
						
						textbox.SelectionStart = string.len(textbox.Text) + 1
					end
				end)
			end
		end)

		upArrow.MouseButton1Up:Connect(function()
			if lastArrowThread then task.cancel(lastArrowThread) lastArrowThread = nil end
			if runCon then runCon:Disconnect() end
			upArrow.BackgroundTransparency = 0
			upArrow.BackgroundColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
		end)

		upArrow.MouseEnter:Connect(function()
			upArrow.BackgroundTransparency = 0
			upArrow.BackgroundColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
		end)

		upArrow.MouseLeave:Connect(function()
			if lastArrowThread then task.cancel(lastArrowThread) lastArrowThread = nil end
			upArrow.BackgroundTransparency = 1
		end)

		downArrow.MouseButton1Up:Connect(function()
			if lastArrowThread then task.cancel(lastArrowThread) lastArrowThread = nil end
			if runCon then runCon:Disconnect() end
			downArrow.BackgroundTransparency = 0
			downArrow.BackgroundColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
		end)

		downArrow.MouseEnter:Connect(function()
			downArrow.BackgroundTransparency = 0
			downArrow.BackgroundColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
		end)

		downArrow.MouseLeave:Connect(function()
			if lastArrowThread then task.cancel(lastArrowThread) lastArrowThread = nil end
			downArrow.BackgroundTransparency = 1
		end)

		textboxBackground.MouseEnter:Connect(function()
			if textboxBackground ~= self.focusedTextbox then
				textboxBackground.BorderColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBorder, Enum.StudioStyleGuideModifier.Hover)
			end
		end)

		textboxBackground.MouseLeave:Connect(function()
			if textboxBackground ~= self.focusedTextbox then
				textboxBackground.BorderColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBorder, Enum.StudioStyleGuideModifier.Default)
			end
		end)

		textboxBackground.Textbox:GetPropertyChangedSignal('Text'):Connect(function()
			if textboxInfo.savedValue == '0' then
				textboxBackground.DownArrow.ImageColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.SubText, Enum.StudioStyleGuideModifier.Disabled)
			else
				textboxBackground.DownArrow.ImageColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.SubText, Enum.StudioStyleGuideModifier.Default)
			end

			if textboxInfo.savedValue == textboxInfo.maxValue then
				textboxBackground.UpArrow.ImageColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.SubText, Enum.StudioStyleGuideModifier.Disabled)
			else
				textboxBackground.UpArrow.ImageColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.SubText, Enum.StudioStyleGuideModifier.Default)
			end
		end)
		
		OKButton.MouseEnter:Connect(function()
			OKButton.BackgroundColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
			OKButton.BorderColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Hover)
		end)
		
		OKButton.MouseLeave:Connect(function()
			OKButton.BackgroundColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Default)
			OKButton.BorderColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Default)
		end)
		
		OKButton.MouseButton1Down:Connect(function()
			OKButton.BackgroundColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
			OKButton.BorderColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Pressed)
		end)
		
		OKButton.MouseButton1Up:Connect(function()
			OKButton.BackgroundColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Default)
			OKButton.BorderColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Default)
		end)
		
		CancelButton.MouseEnter:Connect(function()
			CancelButton.BackgroundColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
			CancelButton.BorderColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Hover)
		end)

		CancelButton.MouseLeave:Connect(function()
			CancelButton.BackgroundColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Default)
			CancelButton.BorderColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Default)
		end)

		CancelButton.MouseButton1Down:Connect(function()
			CancelButton.BackgroundColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
			CancelButton.BorderColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Pressed)
		end)

		CancelButton.MouseButton1Up:Connect(function()
			CancelButton.BackgroundColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Default)
			CancelButton.BorderColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Default)
		end)
	end

	--

	self:Set(Color3.new(1, 1, 1))
	self:UpdateTheme() -- update theme before showing it

	Background.Parent = dockWidgetPluginGui -- set parent of gui to pluginGui

	return self
end

function PluginColorPicker:Set(color : Color3)

	self.color = color

	local hue : number, sat : number, val : number = color:ToHSV()
	local r : number, g : number, b : number = color.R, color.G, color.B
	local hex : string = color:ToHex()

	local colorFromHue : Color3 = Color3.fromHSV(tonumber(self.Background.Hue.Textbox.Text) / 359, sat, val)
	local colorFromSat : Color3 = Color3.fromHSV(hue, tonumber(self.Background.Sat.Textbox.Text) / 255, val)
	local colorFromHex : Color3? = SafeFromHex(self.Background.Hex.Textbox.Text)

	for _, textboxInfo in ipairs(self.textboxes) do
		DisconnectTextboxInfo(textboxInfo)
	end

	if colorFromHex == nil or not Color3FuzzyEq(colorFromHex, color) then
		self.Background.Hex.Textbox.Text = '#'.. color:ToHex()
	end

	if not Color3FuzzyEq(colorFromHue, color) then
		self.Background.Hue.Textbox.Text = math.round(hue * 359)
	end

	if not Color3FuzzyEq(colorFromSat, color) then
		self.Background.Sat.Textbox.Text = math.round(sat * 255)
	end

	self.Background.Val.Textbox.Text = math.round(val * 255)

	self.Background.Red.Textbox.Text = math.round(r * 255)
	self.Background.Green.Textbox.Text = math.round(g * 255)
	self.Background.Blue.Textbox.Text = math.round(b * 255)

	local hueFromText : number = tonumber(self.Background.Hue.Textbox.Text) / 359
	local satFromText : number = tonumber(self.Background.Sat.Textbox.Text) / 255

	self.Background.ColorChoose.WhiteOverlay.Cursor.Position = UDim2.fromScale(1 - hueFromText, 1 - satFromText)
	self.Background.ValueChoose.Cursor.Position = UDim2.new(1, 1, 1 - val, 0)

	self.Background.ColorShow.BackgroundColor3 = color
	self.Background.ValueChoose.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(hueFromText, satFromText, 1)), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})

	for _, textboxInfo in ipairs(self.textboxes) do
		textboxInfo.oldValue = textboxInfo.textboxBackground.Textbox.Text
		textboxInfo.savedValue = textboxInfo.textboxBackground.Textbox.Text
		ConnectTextboxInfo(textboxInfo)
	end

	if self.onChange then self.onChange(color) end
end

function PluginColorPicker:UpdateTheme()
	local currentTheme = studioSettings.Theme
	
	-- do a mf buttons and main buttons..... 

	self.Background.BackgroundColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.MainBackground)

	self.Background.OKButton.BorderColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder)
	self.Background.CancelButton.BorderColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder)
	self.Background.OKButton.BackgroundColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.Button)
	self.Background.CancelButton.BackgroundColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.Button)
	self.Background.OKButton.TextColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.ButtonText)
	self.Background.CancelButton.TextColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.ButtonText)

	self.Background.Hex.BorderColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.InputFieldBorder)
	self.Background.Hex.UIStroke.Color = currentTheme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
	self.Background.Hex.BackgroundColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground)
	self.Background.Hex.Textbox.TextColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.MainText)

	self.Background.ValueChoose.Cursor.ImageColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.TitlebarText)

	if self.focusedTextbox then
		self.focusedTextbox.BorderColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBorder, Enum.StudioStyleGuideModifier.Selected)
	end

	for _, topBorder in ipairs(self.topBorders) do
		topBorder.BackgroundColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.Dark)
	end

	for _, bottomBorder in ipairs(self.bottomBorders) do
		bottomBorder.BackgroundColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.Light)
	end

	for _, textboxInfo in ipairs(self.textboxes) do
		
		local textboxBackground = textboxInfo.textboxBackground
		local textbox = textboxBackground.Textbox

		textboxBackground.BackgroundColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground)
		textboxBackground.BorderColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.InputFieldBorder)
		textboxBackground.TextLabel.TextColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.TitlebarText)
		textbox.TextColor3 = currentTheme:GetColor(Enum.StudioStyleGuideColor.MainText)

		if textboxBackground.Name == 'Hex' then continue end

		if textboxInfo.savedValue == '0' then
			textboxBackground.DownArrow.ImageColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.SubText, Enum.StudioStyleGuideModifier.Disabled)
		else
			textboxBackground.DownArrow.ImageColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.SubText, Enum.StudioStyleGuideModifier.Default)
		end

		if textboxInfo.savedValue == textboxInfo.maxValue then
			textboxBackground.UpArrow.ImageColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.SubText, Enum.StudioStyleGuideModifier.Disabled)
		else
			textboxBackground.UpArrow.ImageColor3 = studioSettings.Theme:GetColor(Enum.StudioStyleGuideColor.SubText, Enum.StudioStyleGuideModifier.Default)
		end
	end
end

function PluginColorPicker:Prompt(startingColor : Color3?)
	if startingColor then self:Set(startingColor) end

	self.DockWidgetPluginGui.Enabled = true

	self.running = coroutine.running()

	self.DockWidgetPluginGui:BindToClose(function()
		task.spawn(self.running)
	end)

	local okButtonCon = self.Background.OKButton.MouseButton1Up:Once(function()
		task.spawn(self.running, self.color)
	end)

	local cancelButtonCon = self.Background.CancelButton.MouseButton1Up:Once(function()
		task.spawn(self.running)
	end)

	local result : Color3? = coroutine.yield()

	okButtonCon:Disconnect()
	cancelButtonCon:Disconnect()
	self.DockWidgetPluginGui:BindToClose(nil)
	self.DockWidgetPluginGui.Enabled = false

	self.running = nil
	self.onChange = nil

	return result
end

function PluginColorPicker:Cancel(customColor : Color3?)
	if self.running then task.spawn(self.running, customColor) end
end

function PluginColorPicker:BindToChange(fn : (Color3) -> ...any)
	self.onChange = fn
end

function PluginColorPicker:IsOpened()
	return self.DockWidgetPluginGui.Enabled
end

function PluginColorPicker:Destroy()
	for _, con in ipairs(self.cons) do
		con:Disconnect()
	end

	self.Background:Destroy()
end

return PluginColorPicker