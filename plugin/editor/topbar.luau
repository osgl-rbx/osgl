local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local SmoothTween = TweenInfo.new(0.25, Enum.EasingStyle.Quad)

local Topbar = {}

export type Topbar = typeof(Topbar) & {
    buttons: { TextButton },
    connections: { RBXScriptConnection },
    area: Frame,
    template: Frame,
    currentMenu: Frame?,
    currentMenuConnections: { RBXScriptConnection }?,
    mousePosition: Vector2,
    mouseTrackingConnection: RBXScriptConnection?,
}

local function cleanMenu(self: Topbar)
    if self.currentMenu then
        self.currentMenu:Destroy()

        for _, conn in ipairs(self.currentMenuConnections or {}) do
            conn:Disconnect()
        end
        for _, menu in ipairs(self.openMenus or {}) do
            menu:Destroy()
        end
        self.currentMenu = nil
        self.currentMenuConnections = nil
        self.openMenus = nil
    end

    if self.mouseTrackingConnection then
        self.mouseTrackingConnection:Disconnect()
        self.mouseTrackingConnection = nil
    end
end

local function isMouseOverGui(gui: GuiObject, mousePos: Vector2)
    local absolutePos = gui.AbsolutePosition
    local absoluteSize = gui.AbsoluteSize
    return gui.Visible == true
        and mousePos.X >= absolutePos.X
        and mousePos.Y >= absolutePos.Y
        and mousePos.X <= absolutePos.X + absoluteSize.X
        and mousePos.Y <= absolutePos.Y + absoluteSize.Y
end

type ContextMenu = { name: string, children: { ContextMenu }?, callback: (() -> ())? }

function Topbar:AddButton(button: TextButton, contextItems: { ContextMenu })
    table.insert(self.buttons, button)

    local index = 0
    table.insert(
        self.connections,
        button.MouseEnter:Connect(function()
            cleanMenu(self)

            if not self.currentMenuConnections then
                self.currentMenuConnections = {}
            end

            self.openMenus = {}

            local function createMenu(items: { ContextMenu }, parentButton: TextButton?): Frame
                local menu = self.template:Clone()
                menu.Parent = self.area
                menu.Visible = true
                menu.Size = UDim2.new(0, 150, 0, 0)
                menu.Name = index

                index += 1

                -- Position
                if parentButton then
                    menu.Position = UDim2.new(
                        0,
                        parentButton.AbsolutePosition.X + parentButton.AbsoluteSize.X,
                        0,
                        parentButton.AbsolutePosition.Y
                    )
                else
                    menu.Position =
                        UDim2.new(0, button.AbsolutePosition.X, 0, button.AbsoluteSize.Y + button.AbsoluteSize.Y / 2)
                end

                table.insert(self.openMenus, menu)

                -- Fill
                local widths = {}
                for _, v in items do
                    local newButton = menu.Template:Clone()
                    newButton.Parent = menu
                    newButton.Name = v.name
                    newButton.Object.Text = v.name
                    newButton.LayoutOrder = #menu:GetChildren() - 3
                    newButton.Visible = true

                    table.insert(widths, newButton.Object.TextBounds.X)

                    local buttons = #menu:GetChildren() - 3
                    menu.Size = UDim2.new(
                        menu.Size.X.Scale,
                        menu.Size.X.Offset,
                        newButton.Size.Y.Scale * buttons,
                        newButton.Size.Y.Offset * buttons
                    )

                    -- Hover effects
                    table.insert(
                        self.currentMenuConnections,
                        newButton.MouseEnter:Connect(function()
                            TweenService
                                :Create(newButton, SmoothTween, {
                                    BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                                })
                                :Play()
                        end)
                    )

                    table.insert(
                        self.currentMenuConnections,
                        newButton.MouseLeave:Connect(function()
                            TweenService
                                :Create(newButton, SmoothTween, {
                                    BackgroundColor3 = Color3.fromRGB(33, 33, 33),
                                })
                                :Play()
                        end)
                    )

                    -- Handle click
                    if v.callback then
                        table.insert(
                            self.currentMenuConnections,
                            newButton.MouseButton1Click:Connect(function()
                                v.callback()
                            end)
                        )
                    end

                    -- Handle children
                    if v.children then
                        local submenu: Frame? = nil
                        table.insert(
                            self.currentMenuConnections,
                            newButton.MouseEnter:Connect(function()
                                if submenu then
                                    submenu:Destroy()
                                end
                                submenu = createMenu(v.children, newButton)
                            end)
                        )
                        table.insert(
                            self.currentMenuConnections,
                            newButton.MouseLeave:Connect(function()
                                task.wait(0.1)

                                local stillInSiblingMenu = false
                                for _, openMenu in ipairs(self.openMenus or {}) do
                                    if tonumber(openMenu.Name) > tonumber(menu.Name) then
                                        if isMouseOverGui(openMenu, self.mousePosition) then
                                            stillInSiblingMenu = true
                                            break
                                        end
                                    end
                                end

                                if submenu and not stillInSiblingMenu then
                                    submenu:Destroy()
                                    if self.openMenus then
                                        table.remove(self.openMenus, table.find(self.openMenus, submenu)) 
                                    end
                                    submenu = nil
                                end
                            end)
                        )
                    end
                end

                local largest = math.max(table.unpack(widths))
                menu.Size = UDim2.fromOffset(largest * 1.75, menu.Size.Y.Offset)

                return menu
            end

            self.currentMenu = createMenu(contextItems)

            self.mousePosition = UserInputService:GetMouseLocation()
            self.mouseTrackingConnection = RunService.Heartbeat:Connect(function()
                self.mousePosition = UserInputService:GetMouseLocation()
            end)

            local function shouldKeepMenuOpen()
                if isMouseOverGui(button, self.mousePosition) then
                    return true
                end
                for _, menu in ipairs(self.openMenus or {}) do
                    if isMouseOverGui(menu, self.mousePosition) then
                        return true
                    end
                end

                return false
            end

            local closeCheckConnection
            closeCheckConnection = RunService.Heartbeat:Connect(function()
                if not shouldKeepMenuOpen() then
                    closeCheckConnection:Disconnect()
                    cleanMenu(self)
                end
            end)

            table.insert(self.currentMenuConnections, closeCheckConnection)
        end)
    )
end

function Topbar:Clean()
    cleanMenu(self)
    table.clear(self.buttons)
    for _, conn in ipairs(self.connections) do
        conn:Disconnect()
    end
    table.clear(self.connections)
end

return {
    new = function(TopbarArea: Frame, TopbarTemplate: Frame): Topbar
        local topbar = table.clone(Topbar)
        topbar.buttons = {}
        topbar.area = TopbarArea
        topbar.template = TopbarTemplate
        topbar.connections = {}
        return topbar
    end,
}
