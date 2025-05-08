local Notif = {}

export type NotifFrame = {
    ["Content"]: Frame & {
        ["UIListLayout"]: UIListLayout,
        ["TextInput"]: Frame & {
            ["UIListLayout"]: UIListLayout,
            ["Title"]: TextLabel,
            ["InputObj"]: TextBox,
        },
        ["Button"]: Frame & {
            ["UIListLayout"]: UIListLayout,
            ["Button"]: TextButton,
        },
        ["Paragraph"]: Frame & {
            ["UIListLayout"]: UIListLayout,
            ["Title"]: TextLabel,
        },
    },
    ["Topbar"]: Frame & {
        ["Title"]: TextLabel,
        ["UIPadding"]: UIPadding,
        ["UIListLayout"]: UIListLayout,
        ["Close"]: TextButton,
    },
    ["UIDragDetector"]: UIDragDetector,
} & Frame

export type Notif = typeof(Notif) & {
    title: string,
    body: { Rasterizable },
    instances: { Frame },
    template: NotifFrame,
    holder: Frame & { NotifFrame },

    Create: (self: Notif, position: UDim2) -> { GetValueOfInput: (self: Notif, index: number) -> string, Delete: () -> () },
}

export type Rasterizable = Button | Paragraph | Input
export type Button = {
    type: "Button",
    name: string,
    callback: (button: TextButton) -> (),
}

export type Paragraph = {
    type: "Paragraph",
    text: string,
}

export type Input = {
    type: "Input",
    title: string,
    placeholder: string,
}

function Notif.Create(self: Notif, udim: UDim2?)
    local newTemplate = self.template:Clone()
    newTemplate.Parent = self.holder
    newTemplate.Visible = true
    newTemplate.Topbar.Title.Text = self.title
    
    if udim then
        newTemplate.Position = udim
    end

    local connections = {}

    local sizes = {}
    for i, v in self.body do
        if v.type == "Paragraph" then
            local paraClone = newTemplate.Content.Paragraph:Clone()
            paraClone.Parent = newTemplate.Content
            paraClone.Name = i
            paraClone.LayoutOrder = i -- No point subtracting
            paraClone.Title.Text = v.text
            paraClone.Visible = true

            if paraClone.Title.TextBounds.Y > 30 then
                paraClone.Size =
                    UDim2.new(paraClone.Size.X.Scale, paraClone.Size.X.Offset, 0, paraClone.Title.TextBounds.Y)
            end

            table.insert(sizes, paraClone.Title.TextBounds.X)
        elseif v.type == "Button" then
            local buttonClone = newTemplate.Content.Button:Clone()
            buttonClone.Parent = newTemplate.Content
            buttonClone.Name = i
            buttonClone.LayoutOrder = i
            buttonClone.Button.Text = v.name
            buttonClone.Visible = true

            table.insert(
                connections,
                buttonClone.Button.MouseButton1Click:Connect(function()
                    v.callback(buttonClone.Button)
                end)
            )
        elseif v.type == "Input" then
            local inputClone = newTemplate.Content.TextInput:Clone()
            inputClone.Parent = newTemplate.Content
            inputClone.Name = i
            inputClone.LayoutOrder = i
            inputClone.Title.Text = v.title
            inputClone.InputObj.PlaceholderText = v.placeholder
            inputClone.InputObj.Text = v.placeholder
            inputClone.Visible = true
        end
    end
    
    newTemplate.Size = UDim2.new(
        newTemplate.Size.X.Scale,
        math.max(newTemplate.Size.X.Offset - 14, unpack(sizes)) + 14,
        newTemplate.Size.Y.Scale,
        newTemplate.Size.Y.Offset + (newTemplate.Content.Paragraph.Size.Y.Offset * (#self.body - 1))
    )

    local arr = {
        GetValueOfInput = function(_, index: number)
            return newTemplate.Content:FindFirstChild(tostring(index)).InputObj.Text
        end,

        Delete = function()
            for _, v in connections do
                v:Disconnect()
            end

            table.clear(connections)

            newTemplate:Destroy()
        end
    }

    table.insert(connections, newTemplate.Topbar.Close.MouseButton1Click:Connect(function()
        arr:Delete()
    end))

    return arr
end

local defaultTemplate
local defaultHolder

return {
    set = function(template: NotifFrame, holder: Frame)
        defaultTemplate = template
        defaultHolder = holder
    end,

    new = function(title: string, body: { Rasterizable }, holder: Frame, template: NotifFrame): Notif
        if not defaultTemplate and template then
            defaultTemplate = template
        end

        if not defaultHolder and holder then
            defaultHolder = holder
        end
        
        local Notif = table.clone(Notif)
        Notif.holder = defaultHolder or holder
        Notif.template = defaultTemplate or template
        Notif.title = title
        Notif.instances = {}
        Notif.body = body

        return Notif
    end,

    Paragraph = function(text: string): Paragraph
        return {
            type = "Paragraph",
            text = text,
        }
    end,

    Button = function(name: string, callback: (button: TextButton) -> ()): Button
        return {
            type = "Button",
            name = name,
            callback = callback,
        }
    end,

    Input = function(title: string, placeholder: string): Input
        return {
            type = "Input",
            title = title,
            placeholder = placeholder,
        }
    end,
}
