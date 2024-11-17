-- Variables
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "RedstonerHub"
gui.ResetOnSpawn = false

-- Create main frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 700, 0, 400)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -200)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- Add UICorner for rounded edges
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

-- Draggable functionality
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Create title label
local title = Instance.new("TextLabel", mainFrame)
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.BorderSizePixel = 0
title.Text = "Redstoner Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSans
title.TextSize = 20

local titleCorner = Instance.new("UICorner", title)
titleCorner.CornerRadius = UDim.new(0, 12)

-- Scrolling Frame for buttons
local buttonFrame = Instance.new("ScrollingFrame", mainFrame)
buttonFrame.Name = "ButtonFrame"
buttonFrame.Size = UDim2.new(0.3, 0, 0.85, 0)
buttonFrame.Position = UDim2.new(0, 0, 0.15, 0)
buttonFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
buttonFrame.ScrollBarThickness = 5
buttonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
buttonFrame.BorderSizePixel = 0

local buttonLayout = Instance.new("UIListLayout", buttonFrame)
buttonLayout.Padding = UDim.new(0, 5)
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Content Frame
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(0.7, 0, 0.85, 0)
contentFrame.Position = UDim2.new(0.3, 0, 0.15, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
contentFrame.BorderSizePixel = 0

-- ScrollingAdd API
local ScrollingAdd = {}

-- Function to add buttons
function ScrollingAdd.Button(name)
    local button = Instance.new("TextButton", buttonFrame)
    button.Name = name
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.BorderSizePixel = 0

    local buttonCorner = Instance.new("UICorner", button)
    buttonCorner.CornerRadius = UDim.new(0, 8)

    -- Create associated content frame
    local buttonContent = Instance.new("Frame", contentFrame)
    buttonContent.Name = name .. "Content"
    buttonContent.Size = UDim2.new(1, 0, 1, 0)
    buttonContent.Visible = false
    buttonContent.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    buttonContent.BorderSizePixel = 0

    -- Click toggles visibility
    button.MouseButton1Click:Connect(function()
        for _, otherContent in pairs(contentFrame:GetChildren()) do
            if otherContent:IsA("Frame") then
                otherContent.Visible = false
            end
        end
        buttonContent.Visible = true
    end)

    -- API for content buttons
    local buttonAPI = {}
    function buttonAPI.AddButton(props)
        local contentButton = Instance.new("TextButton", buttonContent)
        contentButton.Name = props.NAME or "NewButton"
        contentButton.Size = UDim2.new(0.8, 0, 0, 40)
        contentButton.Position = UDim2.new(0.1, 0, 0.1, 0)
        contentButton.Text = props.NAME or "Button"
        contentButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        contentButton.Font = Enum.Font.SourceSans
        contentButton.TextSize = 18
        contentButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

        -- API for script handling
        local contentAPI = {}
        setmetatable(contentAPI, {
            __newindex = function(_, key, value)
                if key == "Script" then
                    contentButton.MouseButton1Click:Connect(value)
                end
            end
        })

        -- Return button API
        ScrollingAdd[props.NAME] = contentAPI
    end

    -- Store button API
    ScrollingAdd[name] = buttonAPI

    -- Update scrolling frame canvas size
    buttonFrame.CanvasSize = UDim2.new(0, 0, 0, buttonLayout.AbsoluteContentSize.Y)
end

-- Example Usage
ScrollingAdd.Button("ExampleButton")
ScrollingAdd["ExampleButton"].AddButton({ NAME = "RunExample" })
ScrollingAdd["RunExample"].Script = function()
    print("RunExample button script executed!")
end
