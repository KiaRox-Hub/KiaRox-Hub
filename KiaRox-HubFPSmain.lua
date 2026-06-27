-- Modern Dark-Themed Cheat Menu UI for Private Testing
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Context States (Your logic variables)
local Settings = {
    AimActive = false,
    FovRadius = 150,
    Smoothness = 5,
    NoRecoil = false,
    RapidFire = false,
    EspZombies = false,
    EspPlayers = false,
    InfJump = false,
    WallCheck = false,
    SwitchTargets = false,
    AimKey = Enum.KeyCode.E,
    ToggleMenuKey = Enum.KeyCode.RightShift
}

------------------------------------------------------------------------
-- UI Creation
------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestEnvironmentUI"
ScreenGui.ResetOnSpawn = false
-- Try putting it in CoreGui for private testing, fallback to PlayerGui if restricted
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UUDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Simple drag implementation for testing
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title Bar
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Title.Text = "  TEST ENVIRONMENT MENU [RShift]"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Content Scrolling Frame
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 550)
Scroll.ScrollBarThickness = 4
Scroll.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Scroll

-- FOV Circle Visualizer
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.FovRadius
FOVCircle.Filled = false
FOVCircle.Visible = false

------------------------------------------------------------------------
-- Helper UI Element Functions
------------------------------------------------------------------------
local function createToggle(name, layoutOrder, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Button.Text = "  " .. name .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(200, 50, 50)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 13
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.LayoutOrder = layoutOrder
    Button.Parent = Scroll
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button

    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Button.Text = "  " .. name .. ": ON"
            Button.TextColor3 = Color3.fromRGB(50, 200, 50)
            Button.BackgroundColor3 = Color3.fromRGB(45, 55, 45)
        else
            Button.Text = "  " .. name .. ": OFF"
            Button.TextColor3 = Color3.fromRGB(200, 50, 50)
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        end
        callback(enabled)
    end)
end

------------------------------------------------------------------------
-- Building the Menu Items
--   Using your exact requirements
------------------------------------------------------------------------

-- 1. Aim Feature Main Toggle & Keybind
createToggle("Aim Master Switch", 1, function(v) 
    Settings.AimActive = v 
    FOVCircle.Visible = v
end)

-- 2. Target Lock / Switch Targets Mode
createToggle("Target Lock (Switch Targets)", 2, function(v) Settings.SwitchTargets = v end)

-- 3. Wallcheck Option
createToggle("Wall Check", 3, function(v) Settings.WallCheck = v end)

-- 4. Smoothness Multiplier Toggle (Simple High/Low preset for the test UI)
createToggle("Enable Smooth Aim", 4, function(v) Settings.Smoothness = v and 8 or 1 end)

-- 5. No Recoil
createToggle("No Recoil (Framework Hook)", 5, function(v) Settings.NoRecoil = v end)

-- 6. Rapid Fire
createToggle("Rapid Fire (Framework Hook)", 6, function(v) Settings.RapidFire = v end)

-- 7. ESP Players
createToggle("ESP Players", 7, function(v) Settings.EspPlayers = v end)

-- 8. ESP Zombies
createToggle("ESP Zombies", 8, function(v) Settings.EspZombies = v end)

-- 9. Infinite Jump
createToggle("Infinite Jump", 9, function(v) Settings.InfJump = v end)


------------------------------------------------------------------------
-- Core Feature Logic Loops
------------------------------------------------------------------------

-- Menu Toggle Listener (Close / Reopen UI)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Settings.ToggleMenuKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Infinite Jump Implementation
UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Update FOV Reticle Position 
RunService.RenderStepped:Connect(function()
    if FOVCircle.Visible then
        FOVCircle.Position = UserInputService:GetMouseLocation()
    end
end)
