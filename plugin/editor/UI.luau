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

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Selection = game:GetService("Selection")
local StudioService = game:GetService("StudioService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local AssetService = game:GetService("AssetService")

local editorFolder = script.Parent
local osglTools = editorFolder.Parent

local t = require(editorFolder.types)
local tools = require(editorFolder.tools)
local topbar = require(editorFolder.topbar)
local notif = require(editorFolder.customNotifs)
local imageDecoder = require(osglTools.util.image)
local bfr = require(osglTools.util.buffer)
local const = require(osglTools.util.const)
local editbar = require(editorFolder.editBar)

local OSGL = require(osglTools.OSGL)
local Window = OSGL.Window
local Texture = OSGL.Texture
local OSGLCol = OSGL.color

local StringCompressor = require(osglTools.OSGL.DrawableObject.texture.canvasDrawStringCompressor)

local connections: { RBXScriptConnection } = {}
local connectionsForClose: { RBXScriptConnection } = {}
local window
local currentTopbar

local EditorUI = {}

local Toolset = tools.new()

local originalScaleX
local originalScaleY

function setOriginalScale(canvas: ImageLabel)
    originalScaleX = canvas.Size.X.Offset / 1920
    originalScaleY = canvas.Size.Y.Offset / 1080
end

function calculateScaledDimensions(
    maxWidthPercent,
    maxHeightPercent,
    imageWidth,
    imageHeight,
    screenWidth,
    screenHeight
)
    local maxAllowedWidth = screenWidth * maxWidthPercent
    local maxAllowedHeight = screenHeight * maxHeightPercent

    local widthScale = maxAllowedWidth / imageWidth
    local heightScale = maxAllowedHeight / imageHeight

    local scale = math.min(widthScale, heightScale)

    local scaledWidth = imageWidth * scale
    local scaledHeight = imageHeight * scale

    return scaledWidth, scaledHeight
end

function EditorUI.openFile(width: number, height: number, name: string, b: buffer?)
    local editor = require(editorFolder.editor)
    editor.close()
    EditorUI.cleanup()

    if window then
        window:Destroy()
    end

    editor.open({
        width = width,
        height = height,
        buffer = b or buffer.create(width * height * 4),
        name = name,
    })
end

function EditorUI.mount(UI: t.OSGLEditor, file: t.OSGLFile)
    if #connectionsForClose ~= 0 then
        -- Already mounted
        return
    end

    local background = UI.Background
    local backgroundScroller = background.BGScroller

    local screen = UI.Screen
    local view = screen.View
    local canvas = view.Canvas
    local editable = canvas.Editable

    canvas.Visible = false

    if not currentTopbar then
        currentTopbar = topbar.new(screen, screen.ContextTemplate)
    end

    if not originalScaleX or not originalScaleY then
        setOriginalScale(canvas)
    end

    local increment = 0
    local targetOffsetX, targetOffsetY = 0, 0
    local mouseInfluence = 15

    local screenSize = workspace.CurrentCamera

    for _, module: ModuleScript in editorFolder.lib:GetChildren() do
        local data = require(module)
        Toolset:Add(data(UI, Toolset, file))
    end

    notif.set(UI.NotifBox.Notif, UI.NotifBox)

    if not window or #window == 0 then
        window = Window.fromBuffer(file.buffer, file.width, file.height):Unwrap()
        window:AddRenderers(editable)

        local camS = workspace.CurrentCamera.ViewportSize
        local wX, wH = camS.X, camS.Y
        local scaledW, scaledH =
            calculateScaledDimensions(originalScaleX, originalScaleY, file.width, file.height, wX, wH)

        canvas.Size = UDim2.fromOffset(scaledW, scaledH)
        canvas.Visible = true
    end

    
    currentTopbar:AddButton(screen.Topbar.Left.File, {
        {
            name = "New",
            callback = function()
                local notification
                notification = notif
                    .new("Create new Texure?", {
                        notif.Input("Width", "100"),
                        notif.Input("Height", "100"),
                        notif.Input("Name", "my_texture"),
                        notif.Button("Create", function()
                            local error = false
                            local width = tonumber(notification:GetValueOfInput(1))
                            local height = tonumber(notification:GetValueOfInput(2))
                            local name = notification:GetValueOfInput(3)

                            if not width or not height then
                                notif
                                    .new("Error", {
                                        notif.Paragraph("Width and height must be integers"),
                                    }, UI.NotifBox, UI.NotifBox.Notif)
                                    :Create()
                                notification:Delete()

                                error = true
                            end

                            if error then
                                return
                            end

                            if width < 10 or height < 10 or width > 1024 or height > 1024 then
                                notif
                                    .new("Error", {
                                        notif.Paragraph(
                                            "Width and height must be above 10, and less than or equal to 1024"
                                        ),
                                    }, UI.NotifBox, UI.NotifBox.Notif)
                                    :Create()
                                notification:Delete()
                                error = true
                            end

                            if error then
                                return
                            end

                            EditorUI.openFile(width, height, name)

                            notification:Delete()
                        end),
                    }, UI.NotifBox, UI.NotifBox.Notif)
                    :Create()
            end,
        },
        {
            name = "Import",
            children = {
                {
                    name = "OSGL",
                    callback = function()
                        local item = Selection:Get()[1]
                        if not item then
                            notif
                                .new("Error", {
                                    notif.Paragraph("No object selected"),
                                }, UI.NotifBox, UI.NotifBox.Notif)
                                :Create()
                            return
                        end

                        if not item:IsA("ModuleScript") then
                            notif
                                .new("Error", {
                                    notif.Paragraph("Item is not a ModuleScript"),
                                }, UI.NotifBox, UI.NotifBox.Notif)
                                :Create()
                            return
                        end

                        local newModule = item:Clone()
                        local txt = Texture.fromChecked(newModule)
                        newModule:Destroy()

                        if not txt.isOk then
                            notif
                                .new("Error", {
                                    notif.Paragraph("Could not load texture; are you sure it's a valid OSGL texture?"),
                                }, UI.NotifBox, UI.NotifBox.Notif)
                                :Create()

                            return
                        end

                        local unwrapped: OSGL.Texture = txt:Unwrap()
                        EditorUI.openFile(unwrapped.width, unwrapped.height, item.Name, unwrapped.buffer)
                    end,
                },

                {
                    name = "CanvasDraw",
                    callback = function()
                        local item = Selection:Get()[1]
                        if not item then
                            notif
                                .new("Error", {
                                    notif.Paragraph("No object selected"),
                                }, UI.NotifBox, UI.NotifBox.Notif)
                                :Create()
                            return
                        end

                        local txt = Texture.fromCanvasDrawSaveObject(item)

                        if not txt.isOk then
                            notif
                                .new("Error", {
                                    notif.Paragraph(
                                        "Could not load texture; are you sure it's a valid CanvasDraw texture?"
                                    ),
                                }, UI.NotifBox, UI.NotifBox.Notif)
                                :Create()

                            return
                        end

                        local unwrapped: OSGL.Texture = txt:Unwrap()
                        EditorUI.openFile(unwrapped.width, unwrapped.height, item.Name, unwrapped.buffer)
                    end,
                },

                {
                    name = "PNG",
                    callback = function()
                        local fileObject = StudioService:PromptImportFile({ "png" })
                        if not fileObject then
                            return
                        end

                        local success, decoder = imageDecoder.loadPNG(fileObject)
                        if not success then
                            notif
                                .new("Error", {
                                    notif.Paragraph("Could not load texture; are you sure it's a valid PNG?"),
                                }, UI.NotifBox, UI.NotifBox.Notif)
                                :Create()
                            return
                        end

                        local width, height = decoder:dimensions()
                        EditorUI.openFile(width, height, fileObject.Name, decoder:asBuffer())
                    end,
                },

                {
                    name = "BMP",
                    callback = function()
                        local fileObject = StudioService:PromptImportFile({ "bmp" })
                        if not fileObject then
                            return
                        end

                        local success, decoder = imageDecoder.loadBMP(fileObject)
                        if not success then
                            notif
                                .new("Error", {
                                    notif.Paragraph("Could not load texture; are you sure it's a valid BMP?"),
                                }, UI.NotifBox, UI.NotifBox.Notif)
                                :Create()
                            return
                        end

                        local width, height = decoder:dimensions()
                        EditorUI.openFile(width, height, fileObject.Name, decoder:asBuffer())
                    end,
                },

                {
                    name = "JPEG (Slow, no Alpha)",
                    callback = function()
                        local fileObject = StudioService:PromptImportFile({ "jpg", "jpeg" })
                        if not fileObject then
                            return
                        end

                        local success, decoder = imageDecoder.loadJPEG(fileObject)
                        if not success then
                            notif
                                .new("Error", {
                                    notif.Paragraph("Could not load texture; are you sure it's a valid JPEG?"),
                                }, UI.NotifBox, UI.NotifBox.Notif)
                                :Create()
                            return
                        end

                        local width, height = decoder:dimensions()
                        EditorUI.openFile(width, height, fileObject.Name, decoder:asBuffer())
                    end,
                },

                {
                    name = "Asset ID (Must be owned)",
                    callback = function()
                        local assetNotif
                        assetNotif = notif.new("Enter ID", {
                            notif.Input("Asset ID", "rbxassetid://0"),
                            notif.Button("Submit", function()
                                local assetId = assetNotif:GetValueOfInput(1)
                                if not assetId then
                                    return
                                end

                                local id = tonumber(string.match(assetId, "rbxassetid://(%d+)"))
                                if not id then
                                    notif
                                        .new("Error", {
                                            notif.Paragraph("Invalid Asset ID"),
                                        }, UI.NotifBox, UI.NotifBox.Notif)
                                        :Create()
                                    return
                                end

                                local tempWindow = Window.fromAssetId(id)
                                if not tempWindow.isOk then
                                    notif
                                        .new("Error", {
                                            notif.Paragraph("Could not load asset; are you sure you own it?"),
                                        }, UI.NotifBox, UI.NotifBox.Notif)
                                        :Create()
                                    return
                                end

                                local unwrapped: OSGL.Window = tempWindow:Unwrap()
                                EditorUI.openFile(unwrapped.width, unwrapped.height, assetId, unwrapped.buffer)
                            end),
                        }, UI.NotifBox, UI.NotifBox.Notif):Create()
                    end,
                },
            },
        },

        {
            name = "Export",
            children = {
                {
                    name = "OSGL",
                    callback = function()
                        local bStr = bfr.stringBufferAsHex(file.buffer, file.width, file.height)
                        local src =
                            `-- Generated with OSGL Image Uploader\n\nreturn \{\n\tversion = "{const.version}",\n\twidth = {file.width},\n\theight = {file.height},\n\tpixels = buffer.fromstring("{bStr}")\n}`
                        for _, v in Selection:Get() do
                            local output = Instance.new("ModuleScript")
                            output.Name = file.name
                            output.Parent = v

                            ScriptEditorService:UpdateSourceAsync(output, function()
                                return src
                            end)
                        end
                    end,
                },

                {
                    name = "CanvasDraw",
                    callback = function()
                        local chunks = { {} }

                        local width = file.width
                        local height = file.height
                        local RGBAIndex = 1

                        local texture: OSGL.Texture = Texture.new(width, height, file.buffer):Unwrap()

                        local chunkLimit = 200000

                        -- Extract from CanvasDraw
                        for Y = 1, file.height do
                            for X = 1, width do
                                local col = texture:ReadPixelUnchecked(X - 1, Y - 1)

                                local R = OSGLCol.r(col)
                                local G = OSGLCol.g(col)
                                local B = OSGLCol.b(col)

                                local array = chunks[#chunks]

                                if #array >= chunkLimit then -- Ensures the string will be under 200KB
                                    table.insert(chunks, {})
                                    array = chunks[#chunks]
                                    RGBAIndex = 1
                                end

                                array[RGBAIndex] = R
                                array[RGBAIndex + 1] = G
                                array[RGBAIndex + 2] = B
                                array[RGBAIndex + 3] = OSGLCol.a(col)

                                RGBAIndex += 4

                                task.wait()
                            end
                        end

                        local newSaveObject = Instance.new("Texture")
                        newSaveObject.Name = file.name

                        for i, RGBAArray in chunks do
                            local Compressed = StringCompressor.Compress(HttpService:JSONEncode(RGBAArray))

                            local ChunkString = Instance.new("StringValue", newSaveObject)
                            ChunkString.Value = Compressed
                            ChunkString.Name = "Chunk" .. i
                            ChunkString.Parent = newSaveObject
                            task.wait()
                        end

                        newSaveObject:SetAttribute("Resolution", Vector2.new(width, height))
                        newSaveObject:SetAttribute("Version", 0)

                        for _, v in Selection:Get() do
                            local output = newSaveObject:Clone()
                            output.Parent = v
                            output.Name = file.name
                        end
                    end,
                },

                {
                    name = "Asset ID / PNG",
                    callback = function()
                        local assetNotif
                        assetNotif = notif.new("Upload", {
                            notif.Paragraph("<b>NOTE</b>"),
                            notif.Paragraph("Asset IDs can only be uploaded if the plugin is being ran locally."),
                            notif.Button("Continue", function()
                                assetNotif:Delete()
                                local result, value = AssetService:CreateAssetAsync(window.editableImage, Enum.AssetType.Image, {
                                    Name = file.name,
                                    Description = "Exported with OSGL",
                                    IsPackage = false,
                                })
                    
                                if result ~= Enum.CreateAssetResult.Success then
                                    notif
                                        .new("Error", {
                                            notif.Paragraph("Could not upload texture; are you sure you're running locally?"),
                                        }, UI.NotifBox, UI.NotifBox.Notif)
                                        :Create()
                                    return
                                end

                                local newTexture = Instance.new("Texture")
                                newTexture.Name = file.name
                                newTexture.Texture = `rbxassetid://{value}`

                                for _, v in Selection:Get() do
                                    local output = newTexture:Clone()
                                    output.Parent = v
                                end
                            end),
                            notif.Paragraph("If you're not running locally, or want to upload a PNG, follow the instructions on the OSGL DevForum post to upload manually;"),
                            notif.Paragraph("You can start by clicking the button below:"),
                            notif.Button("Upload Manually", function()
                                assetNotif:Delete()

                                local mesh = Instance.new("MeshPart")
                                mesh.TextureContent = Content.fromObject(window.editableImage)
                                mesh.Parent = workspace
                                Selection:Set({ mesh })
                            end)
                        }, UI.NotifBox, UI.NotifBox.Notif):Create()
                    end,
                }
            },
        },
    })

    currentTopbar:AddButton(screen.Topbar.Left.Edit, editbar(window, file.width, file.height, Toolset))

    local previousTool = nil
    local eraserActivationTime = 0
    local eraserMinDuration = 0.3

    local notifBox = UI.NotifBox

    table.insert(
        connectionsForClose,
        UserInputService.InputChanged:Connect(function(input)
            if #notifBox:GetChildren() > 1 then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseMovement then
                Toolset:CallFrame(window)
            end
        end)
    )

    table.insert(
        connectionsForClose,
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Toolset:CallFrame(window)
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                if Toolset.selected ~= "Eraser" then
                    previousTool = Toolset.selected
                    eraserActivationTime = os.clock()
                    Toolset:Select("Eraser")
                end
            end
        end)
    )

    table.insert(
        connectionsForClose,
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                local timeHeld = os.clock() - eraserActivationTime
                if timeHeld < eraserMinDuration then
                    task.delay(eraserMinDuration - timeHeld, function()
                        if previousTool and Toolset.selected == "Eraser" then
                            Toolset:Select(previousTool)
                            previousTool = nil
                        end
                    end)
                else
                    if previousTool then
                        Toolset:Select(previousTool)
                        previousTool = nil
                    end
                end
            end
        end)
    )

    table.insert(
        connectionsForClose,
        RunService.Heartbeat:Connect(function()
            increment -= 0.25
            if increment <= -45 then
                increment = 0
            end

            local mousePosition = UserInputService:GetMouseLocation()
            local screenSize = screenSize.ViewportSize
            local mouseOffsetX = ((mousePosition.X - screenSize.X / 2) / (screenSize.X / 2)) * mouseInfluence
            local mouseOffsetY = ((mousePosition.Y - screenSize.Y / 2) / (screenSize.Y / 2)) * mouseInfluence

            targetOffsetX = increment + mouseOffsetX
            targetOffsetY = increment + mouseOffsetY

            backgroundScroller.Position = UDim2.fromOffset(targetOffsetX, targetOffsetY)
        end)
    )
end

function EditorUI.onClose(UI: t.OSGLEditor)
    for _, v in connectionsForClose do
        v:Disconnect()
    end

    table.clear(connectionsForClose)
    Toolset:Cleanup()
    currentTopbar:Clean()
    UI.Enabled = false
    return window.buffer
end

function EditorUI.cleanup()
    for _, v in connections do
        v:Disconnect()
    end

    table.clear(connections)
end

return EditorUI
