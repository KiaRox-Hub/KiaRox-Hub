-- [[ KiaRox-Hub: Roblox Script Menu GUI Lab ]] --

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- // Core UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KiaRoxHub_Lab"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Protect GUI if using an executor supporting it
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- // Main Frame Container
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 420)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Standard drag fallback for mobile/PC
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 9)
UICorner.Parent = MainFrame

-- // Texted Watermark / Title (KaiRox Hub)
local Title = Instance.new("TextLabel")
Title.Name = "TitleWatermark"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "KaiRox Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(1, -20, 0, 1)
Separator.Position = UDim2.new(0, 10, 0, 45)
Separator.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Separator.BorderSizePixel = 0
Separator.Parent = MainFrame

-- // Menu List Container
local MenuList = Instance.new("ScrollingFrame")
MenuList.Size = UDim2.new(1, -20, 1, -65)
MenuList.Position = UDim2.new(0, 10, 0, 55)
MenuList.BackgroundTransparency = 1
MenuList.BorderSizePixel = 0
MenuList.ScrollBarThickness = 3
MenuList.CanvasSize = UDim2.new(0, 0, 0, 0)
MenuList.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = MenuList

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    MenuList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- // Dynamic Feature States
local Config = {
    FovClick = false,
    FovSize = 100,
    FovCircleLock = false,
    Aimbot = false,
    Wallbang = false
}

-- Drawing API FOV Circle setup
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 255, 137)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Config.FovSize
FOVCircle.Filled = false
FOVCircle.Visible = false

-- // UI Element Component Generators
local function CreateToggle(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 38)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Text = "  " .. text .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(170, 170, 170)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 13
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = MenuList
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Button
    
    local active = false
    Button.MouseButton1Click:Connect(function()
        active = not active
        if active then
            Button.BackgroundColor3 = Color3.fromRGB(35, 120, 85)
            Button.Text = "  " .. text .. ": ON"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Button.Text = "  " .. text .. ": OFF"
            Button.TextColor3 = Color3.fromRGB(170, 170, 170)
        end
        callback(active)
    end)
end

-- // RENDERING MENU LIST ITEMS

-- 1. Fov Click Toggle
CreateToggle("Fov Click", function(state)
    Config.FovClick = state
    FOVCircle.Visible = state
end)

-- 2. Fov Size ProgressBar (Slider Implementation)
local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(1, 0, 0, 50)
SliderFrame.BackgroundTransparency = 1
SliderFrame.Parent = MenuList

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "FOV Size: " .. Config.FovSize
SliderLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
SliderLabel.Font = Enum.Font.GothamMedium
SliderLabel.TextSize = 12
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.Parent = SliderFrame

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(1, 0, 0, 8)
SliderBar.Position = UDim2.new(0, 0, 0, 25)
SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SliderBar.Parent = SliderFrame

local SliderBarCorner = Instance.new("UICorner")
SliderBarCorner.CornerRadius = UDim.new(0, 4)
SliderBarCorner.Parent = SliderBar

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(Config.FovSize / 500, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ProgressBar.BorderSizePixel = 0
ProgressBar.Parent = SliderBar

local ProgressCorner = Instance.new("UICorner")
ProgressCorner.CornerRadius = UDim.new(0, 4)
ProgressCorner.Parent = ProgressBar

local IsSliding = false

local function UpdateProgressBar(input)
    local ratio = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
    Config.FovSize = math.floor(ratio * 500)
    if Config.FovSize < 10 then Config.FovSize = 10 end
    
    ProgressBar.Size = UDim2.new(ratio, 0, 1, 0)
    SliderLabel.Text = "FOV Size: " .. Config.FovSize
    FOVCircle.Radius = Config.FovSize
end

SliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        IsSliding = true
        UpdateProgressBar(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if IsSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UpdateProgressBar(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        IsSliding = false
    end
end)

-- 3. Fov Circle Lock (Prevents drifting on Mobile)
CreateToggle("Fov Circle Lock (Mobile Fix)", function(state)
    Config.FovCircleLock = state
end)

-- 4. Aimbot Mobs/Enemies
CreateToggle("Aimbot Mobs & Enemies", function(state)
    Config.Aimbot = state
end)

-- 5. Wallbang (No Clip Ammo Through Obstacles)
CreateToggle("Wallbang (No Clip Ammo)", function(state)
    Config.Wallbang = state
end)


-- // EXECUTION SYSTEM CORE

-- Helper calculation engine for valid screen-space entities
local function FetchOptimalTarget()
    local IdealTarget = nil
    local SmallestDistance = Config.FovSize
    local CenterPoint = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    local function EvaluateEntity(entity)
        if entity and entity:FindFirstChild("Humanoid") and entity:FindFirstChild("HumanoidRootPart") and entity ~= LocalPlayer.Character then
            if entity.Humanoid.Health > 0 then
                local RootPart = entity.HumanoidRootPart
                local ScreenPosition, TargetVisible = Camera:WorldToViewportPoint(RootPart.Position)
                
                if TargetVisible or Config.FovCircleLock then
                    local EntityPos2D = Vector2.new(ScreenPosition.X, ScreenPosition.Y)
                    -- For Mobile Lock, calculate vectors entirely relative to viewport center context
                    local AnchorPoint = Config.FovCircleLock and CenterPoint or UserInputService:GetMouseLocation()
                    local DeltaMag = (EntityPos2D - AnchorPoint).Magnitude
                    
                    if DeltaMag < SmallestDistance then
                        if not Config.Wallbang then
                            -- Standard line of sight raycheck when wallbang bypass is deactivated
                            local Parts = Camera:GetPartsObscuringTarget({Camera.CFrame.Position, RootPart.Position}, {LocalPlayer.Character, entity})
                            if #Parts > 0 then return end 
                        end
                        SmallestDistance = DeltaMag
                        IdealTarget = RootPart
                    end
                end
            end
        end
    end

    -- Dynamically check Player Players and loose workspace assemblies (Mobs)
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then EvaluateEntity(player.Character) end
    end
    for _, child in pairs(Workspace:GetChildren()) do
        EvaluateEntity(child)
    end
    
    return IdealTarget
end

-- Render loop handles Aimbot Tracking, Wallbang Ray Passings, and Mobile Circle Locking
RunService.RenderStepped:Connect(function()
    if Config.FovClick then
        if Config.FovCircleLock then
            -- Absolute lock centered on screen: prevents mobile screen panning from shifting circle position
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        else
            FOVCircle.Position = UserInputService:GetMouseLocation()
        end
    end

    if Config.Aimbot then
        local ActiveTarget = FetchOptimalTarget()
        if ActiveTarget then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, ActiveTarget.Position)
        end
    end
end)

-- Metatable Hooking for Wallbang (Bypasses Raycast obstacles dynamically)
local OldMetaIndex
OldMetaIndex = hookmetamethod(game, "__index", function(Self, Index)
    if Config.Wallbang and not checkcaller() then
        -- Forces weapon cast parameters to filter everything, preventing bullets from checking or hitting walls
        if Self:IsA("RaycastParams") and Index == "FilterDescendantsInstances" then
            return {Workspace} 
        end
    end
    return OldMetaIndex(Self, Index)
end)

-- Optional: Toggle Visibility of whole GUI with "Insert" key
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
