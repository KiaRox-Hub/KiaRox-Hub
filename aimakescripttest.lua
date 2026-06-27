-- [[ KiaRox-Hub Roblox Script Menu GUI ]] --

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- // UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KiaRoxHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Standard safety check for exploit execution environments
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- // Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Allows moving the GUI around
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- // Watermark / Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "KaiRox Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, -20, 0, 2)
Line.Position = UDim2.new(0, 10, 0, 40)
Line.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- // Container for Menu List
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = Container

-- // Feature States & FOV Circle Setup
local Features = {
    FovClick = false,
    FovSize = 100,
    FovCircleLock = false,
    Aimbot = false,
    Wallbang = false
}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Radius = Features.FovSize
FOVCircle.Filled = false
FOVCircle.Visible = false

-- // HELPER UI FUNCTIONS
local function CreateToggleButton(name, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Button.Text = text .. " : OFF"
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.Parent = Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button
    
    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Button.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
            Button.Text = text .. " : ON"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Button.Text = text .. " : OFF"
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        callback(enabled)
    end)
end

-- // BUILDING THE MENU LIST

-- 1. FOV Click Toggle
CreateToggleButton("FovClick", "FOV Click", function(state)
    Features.FovClick = state
    FOVCircle.Visible = state
end)

-- 2. FOV Size ProgressBar (Slider implementation)
local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(1, 0, 0, 50)
SliderFrame.BackgroundTransparency = 1
SliderFrame.Parent = Container

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "FOV Size: " .. Features.FovSize
SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.TextSize = 12
SliderLabel.Parent = SliderFrame

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(1, -20, 0, 10)
SliderBar.Position = UDim2.new(0, 10, 0, 25)
SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderBar.Parent = SliderFrame

local SliderProgress = Instance.new("Frame")
SliderProgress.Size = UDim2.new(Features.FovSize / 400, 0, 1, 0)
SliderProgress.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
SliderProgress.BorderSizePixel = 0
SliderProgress.Parent = SliderBar

local UserHoldingSlider = false

local function UpdateSlider(input)
    local percentage = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
    Features.FovSize = math.floor(percentage * 400) -- Max FOV 400
    if Features.FovSize < 10 then Features.FovSize = 10 end -- Min FOV 10
    SliderProgress.Size = UDim2.new(percentage, 0, 1, 0)
    SliderLabel.Text = "FOV Size: " .. Features.FovSize
    FOVCircle.Radius = Features.FovSize
end

SliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        UserHoldingSlider = true
        UpdateSlider(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if UserHoldingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UpdateSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        UserHoldingSlider = false
    end
end)

-- 3. FOV Circle Lock (Mobile Fix: Stays centered, does not wander)
CreateToggleButton("FovCircleLock", "FOV Circle Lock", function(state)
    Features.FovCircleLock = state
end)

-- 4. Aimbot Mobs/Enemies
CreateToggleButton("Aimbot", "Aimbot Mobs/Enemies", function(state)
    Features.Aimbot = state
end)

-- 5. Wallbang (No Clip Ammo through walls)
CreateToggleButton("Wallbang", "Wallbang (No Clip Ammo)", function(state)
    Features.Wallbang = state
end)


-- // CORE FUNCTIONALITY ENGINE

-- Helper: Find closest Target (Enemy or Mob) inside FOV
local function GetClosestTarget()
    local ClosestTarget = nil
    local MaxDistance = Features.FovSize
    local ScreenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- Check workspace for targets (Standard layout handles both players and custom Enemy models)
    local function CheckModel(model)
        if model and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") and model ~= LocalPlayer.Character then
            if model.Humanoid.Health > 0 then
                local Part = model.HumanoidRootPart
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Part.Position)
                
                if OnScreen or Features.FovCircleLock then
                    local TargetPos = Vector2.new(ScreenPos.X, ScreenPos.Y)
                    local MousePos = Features.FovCircleLock and ScreenCenter or UserInputService:GetMouseLocation()
                    local Distance = (TargetPos - MousePos).Magnitude
                    
                    if Distance < MaxDistance then
                        -- Wallbang integration: If wallbang is off, check line of sight
                        if not Features.Wallbang then
                            local Parts = Camera:GetPartsObscuringTarget({Camera.CFrame.Position, Part.Position}, {LocalPlayer.Character, model})
                            if #Parts > 0 then return end -- Hidden behind wall
                        end
                        MaxDistance = Distance
                        ClosestTarget = Part
                    end
                end
            end
        end
    end

    -- Scans both Players and Workspace Objects (for Mobs)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then CheckModel(p.Character) end
    end
    for _, obj in pairs(Workspace:GetChildren()) do
        CheckModel(obj)
    end
    
    return ClosestTarget
end

-- Main Loop: Controls FOV Positioning, Aimbot, and Wallbang behavior
RunService.RenderStepped:Connect(function()
    -- Manage FOV Circle updates
    if Features.FovClick then
        if Features.FovCircleLock then
            -- Force center for mobile lock stability
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        else
            FOVCircle.Position = UserInputService:GetMouseLocation()
        end
    end

    -- Run Aimbot Calculations
    if Features.Aimbot then
        local Target = GetClosestTarget()
        if Target then
            -- Smooth camera adjustments toward target head/body position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
        end
    end
end)

-- Wallbang Injection Hooks
local OldIndex
OldIndex = hookmetamethod(game, "__index", function(Self, Key)
    if Features.Wallbang and not checkcaller() then
        -- Spoofs Bullet raycasts by removing obstruction parts from calculation if ray hits a wall
        if Self:IsA("RaycastParams") and Key == "FilterDescendantsInstances" then
            return {Workspace} -- Dynamically bypass normal obstacle intersections
        end
    end
    return OldIndex(Self, Key)
end)

-- Custom Hide/Show menu toggle with 'K' key
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
