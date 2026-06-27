-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Local Player & Camera
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- --- CONFIGURATION / STATE ---
local Settings = {
    Enabled = true,
    TargetLock = true,
    SwitchTargets = true,
    WallCheck = true,
    AimKey = Enum.KeyCode.E, -- Hold E to aim
    ToggleUIKey = Enum.KeyCode.RightShift, -- Press Right Shift to hide/show UI
    FOV = 150, -- FOV Radius in pixels
    Smoothness = 0.25 -- Lower = smoother/slower, 1 = instant
}

local IsAiming = false
local CurrentTarget = nil

-- --- CREATE CLEAN UI ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestAimUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 260)
MainFrame.Position = UDim2.new(0, 50, 0, 50)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Allows moving the test UI around
MainFrame.Parent = ScreenGui

-- UI Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Test Environment Controls"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- UI Layout for Buttons
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Title.LayoutOrder = 0

-- Function to create simple modern toggle buttons
local function CreateToggleButton(text, property, layoutOrder)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 190, 0, 35)
    Button.BackgroundColor3 = Settings[property] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
    Button.Text = text .. ": " .. (Settings[property] and "ON" or "OFF")
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansSemibold
    Button.TextSize = 14
    Button.LayoutOrder = layoutOrder
    Button.Parent = MainFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        Settings[property] = not Settings[property]
        Button.BackgroundColor3 = Settings[property] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
        Button.Text = text .. ": " .. (Settings[property] and "ON" or "OFF")
        if not Settings[property] and property == "Enabled" then
            CurrentTarget = nil
        end
    end)
end

-- Generate UI Elements
CreateToggleButton("Master Toggle", "Enabled", 1)
CreateToggleButton("Target Lock", "TargetLock", 2)
CreateToggleButton("Wall Check", "WallCheck", 3)
CreateToggleButton("Switch Targets", "SwitchTargets", 4)

-- --- FOV CIRCLE VISUALIZER ---
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.5
FOVCircle.Filled = false

-- --- HELPER FUNCTIONS ---
local function IsVisible(targetPart)
    if not Settings.WallCheck then return true end
    
    local castPoints = {Camera.CFrame.Position, targetPart.Position}
    local exclusionList = {LocalPlayer.Character, targetPart.Parent}
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = exclusionList
    
    local ray = Workspace:Raycast(castPoints[1], castPoints[2] - castPoints[1], raycastParams)
    
    return ray == nil -- If nil, nothing obstructed the ray
end

local function GetClosestTarget()
    local closestPlayer = nil
    local shortestDistance = Settings.FOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid.Health > 0 then
                local rootPart = player.Character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if distance < shortestDistance and IsVisible(rootPart) then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- --- INPUT HANDLING ---
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Handle Aim Keybind
    if input.KeyCode == Settings.AimKey then
        IsAiming = true
    end
    
    -- Handle UI Visibility Toggle
    if input.KeyCode == Settings.ToggleUIKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Settings.AimKey then
        IsAiming = false
        if not Settings.TargetLock then
            CurrentTarget = nil
        end
    end
end)

-- --- CORE LOOP ---
RunService.RenderStepped:Connect(function()
    -- Update FOV Ring Position
    local mousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = mousePos
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Visible = Settings.Enabled and MainFrame.Visible
    
    if not Settings.Enabled or not IsAiming then 
        if not Settings.TargetLock or not IsAiming then
            CurrentTarget = nil 
        end
        return 
    end

    -- Target Acquisition/Validation
    if Settings.TargetLock and CurrentTarget then
        -- Validate existing target
        local char = CurrentTarget.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or (char:FindFirstChild("Humanoid") and char.Humanoid.Health <= 0) or not IsVisible(char.HumanoidRootPart) then
            CurrentTarget = nil
        elseif Settings.SwitchTargets then
            -- Check if a closer target is available even while locked
            local potentialTarget = GetClosestTarget()
            if potentialTarget then CurrentTarget = potentialTarget end
        end
    else
        CurrentTarget = GetClosestTarget()
    end

    -- Execution of Smooth Aim
    if CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart") then
        local targetPart = CurrentTarget.Character.HumanoidRootPart
        local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        
        -- Smooth interpolation (Lerp)
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.Smoothness)
    end
end)
