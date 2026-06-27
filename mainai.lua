-- Place this in StarterGui as a LocalScript

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- Configuration
local config = {
    enabled = false,
    fov = 100,
    smoothness = 0.1,
    targetLock = false,
    wallCheck = false,
    aimKeybind = Enum.KeyCode.E,
    currentTarget = nil,
    aiming = false
}

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
mainFrame.BorderSizePixel = 2
mainFrame.Parent = screenGui

-- Title Bar
local titleBar = Instance.new("TextLabel")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.TextSize = 16
titleBar.Font = Enum.Font.GothamBold
titleBar.Text = "AIMBOT"
titleBar.Parent = mainFrame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -28, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.Parent = titleBar

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(1, -10, 0, 30)
toggleBtn.Position = UDim2.new(0, 5, 0, 40)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
toggleBtn.TextSize = 14
toggleBtn.Font = Enum.Font.Gotham
toggleBtn.Text = "Status: OFF"
toggleBtn.Parent = mainFrame

-- FOV Slider
local fovLabel = Instance.new("TextLabel")
fovLabel.Name = "FOVLabel"
fovLabel.Size = UDim2.new(1, -10, 0, 20)
fovLabel.Position = UDim2.new(0, 5, 0, 80)
fovLabel.BackgroundTransparency = 1
fovLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fovLabel.TextSize = 12
fovLabel.Font = Enum.Font.Gotham
fovLabel.Text = "FOV: 100"
fovLabel.Parent = mainFrame

local fovSlider = Instance.new("TextButton")
fovSlider.Name = "FOVSlider"
fovSlider.Size = UDim2.new(1, -10, 0, 8)
fovSlider.Position = UDim2.new(0, 5, 0, 100)
fovSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
fovSlider.BorderColor3 = Color3.fromRGB(0, 150, 255)
fovSlider.BorderSizePixel = 1
fovSlider.Parent = mainFrame

local fovFill = Instance.new("Frame")
fovFill.Name = "Fill"
fovFill.Size = UDim2.new(0.5, 0, 1, 0)
fovFill.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
fovFill.BorderSizePixel = 0
fovFill.Parent = fovSlider

-- Smoothness Slider
local smoothLabel = Instance.new("TextLabel")
smoothLabel.Name = "SmoothLabel"
smoothLabel.Size = UDim2.new(1, -10, 0, 20)
smoothLabel.Position = UDim2.new(0, 5, 0, 120)
smoothLabel.BackgroundTransparency = 1
smoothLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
smoothLabel.TextSize = 12
smoothLabel.Font = Enum.Font.Gotham
smoothLabel.Text = "Smoothness: 0.1"
smoothLabel.Parent = mainFrame

local smoothSlider = Instance.new("TextButton")
smoothSlider.Name = "SmoothSlider"
smoothSlider.Size = UDim2.new(1, -10, 0, 8)
smoothSlider.Position = UDim2.new(0, 5, 0, 140)
smoothSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
smoothSlider.BorderColor3 = Color3.fromRGB(0, 150, 255)
smoothSlider.BorderSizePixel = 1
smoothSlider.Parent = mainFrame

local smoothFill = Instance.new("Frame")
smoothFill.Name = "Fill"
smoothFill.Size = UDim2.new(0.1, 0, 1, 0)
smoothFill.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
smoothFill.BorderSizePixel = 0
smoothFill.Parent = smoothSlider

-- Target Lock Toggle
local targetLockBtn = Instance.new("TextButton")
targetLockBtn.Name = "TargetLockBtn"
targetLockBtn.Size = UDim2.new(1, -10, 0, 25)
targetLockBtn.Position = UDim2.new(0, 5, 0, 160)
targetLockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
targetLockBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
targetLockBtn.TextSize = 12
targetLockBtn.Font = Enum.Font.Gotham
targetLockBtn.Text = "Target Lock: OFF"
targetLockBtn.Parent = mainFrame

-- Wall Check Toggle
local wallCheckBtn = Instance.new("TextButton")
wallCheckBtn.Name = "WallCheckBtn"
wallCheckBtn.Size = UDim2.new(1, -10, 0, 25)
wallCheckBtn.Position = UDim2.new(0, 5, 0, 190)
wallCheckBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
wallCheckBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
wallCheckBtn.TextSize = 12
wallCheckBtn.Font = Enum.Font.Gotham
wallCheckBtn.Text = "Wall Check: OFF"
wallCheckBtn.Parent = mainFrame

-- Next Target Button
local nextTargetBtn = Instance.new("TextButton")
nextTargetBtn.Name = "NextTargetBtn"
nextTargetBtn.Size = UDim2.new(1, -10, 0, 25)
nextTargetBtn.Position = UDim2.new(0, 5, 0, 220)
nextTargetBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
nextTargetBtn.TextColor3 = Color3.fromRGB(150, 255, 150)
nextTargetBtn.TextSize = 12
nextTargetBtn.Font = Enum.Font.Gotham
nextTargetBtn.Text = "Next Target"
nextTargetBtn.Parent = mainFrame

-- Current Target Label
local targetLabel = Instance.new("TextLabel")
targetLabel.Name = "TargetLabel"
targetLabel.Size = UDim2.new(1, -10, 0, 20)
targetLabel.Position = UDim2.new(0, 5, 0, 250)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
targetLabel.TextSize = 10
targetLabel.Font = Enum.Font.Gotham
targetLabel.Text = "Target: None"
targetLabel.Parent = mainFrame

-- Functions
local function getPlayers()
    local players = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
            table.insert(players, p)
        end
    end
    return players
end

local function getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function isInFOV(targetPos)
    local screenPos = camera:WorldToScreenPoint(targetPos)
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
    return distance <= config.fov
end

local function canSeeTarget(target)
    if not config.wallCheck then return true end
    
    local rayOrigin = camera.CFrame.Position
    local rayDirection = (target.Character.Head.Position - rayOrigin).Unit
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {player.Character}
    
    local result = workspace:Raycast(rayOrigin, rayDirection * 1000, raycastParams)
    
    if result then
        return result.Instance:IsDescendantOf(target.Character)
    end
    return true
end

local function findClosestTarget()
    local players = getPlayers()
    local closest = nil
    local closestDistance = math.huge
    
    for _, p in pairs(players) do
        if p.Character and p.Character:FindFirstChild("Head") then
            local headPos = p.Character.Head.Position
            local distance = getDistance(camera.CFrame.Position, headPos)
            
            if isInFOV(headPos) and canSeeTarget(p) and distance < closestDistance then
                closest = p
                closestDistance = distance
            end
        end
    end
    
    return closest
end

local function switchTarget()
    local players = getPlayers()
    local currentIndex = 1
    
    for i, p in pairs(players) do
        if p == config.currentTarget then
            currentIndex = i
            break
        end
    end
    
    local nextIndex = currentIndex % #players + 1
    config.currentTarget = players[nextIndex]
end

local function updateUI()
    toggleBtn.Text = config.enabled and "Status: ON" or "Status: OFF"
    toggleBtn.TextColor3 = config.enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    
    fovLabel.Text = "FOV: " .. math.floor(config.fov)
    fovFill.Size = UDim2.new(config.fov / 200, 0, 1, 0)
    
    smoothLabel.Text = "Smoothness: " .. string.format("%.2f", config.smoothness)
    smoothFill.Size = UDim2.new(config.smoothness, 0, 1, 0)
    
    targetLockBtn.TextColor3 = config.targetLock and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    targetLockBtn.Text = "Target Lock: " .. (config.targetLock and "ON" or "OFF")
    
    wallCheckBtn.TextColor3 = config.wallCheck and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    wallCheckBtn.Text = "Wall Check: " .. (config.wallCheck and "ON" or "OFF")
    
    targetLabel.Text = "Target: " .. (config.currentTarget and config.currentTarget.Name or "None")
end

local function aim()
    if not config.enabled or not config.currentTarget or not config.currentTarget.Character then
        return
    end
    
    local targetHead = config.currentTarget.Character:FindFirstChild("Head")
    if not targetHead then return end
    
    local targetPos = targetHead.Position
    local cameraPos = camera.CFrame.Position
    local direction = (targetPos - cameraPos).Unit
    
    local newCFrame = CFrame.new(cameraPos, cameraPos + direction)
    camera.CFrame = camera.CFrame:Lerp(newCFrame, config.smoothness)
end

-- UI Events
toggleBtn.MouseButton1Click:Connect(function()
    config.enabled = not config.enabled
    updateUI()
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

targetLockBtn.MouseButton1Click:Connect(function()
    config.targetLock = not config.targetLock
    updateUI()
end)

wallCheckBtn.MouseButton1Click:Connect(function()
    config.wallCheck = not config.wallCheck
    updateUI()
end)

nextTargetBtn.MouseButton1Click:Connect(function()
    if #getPlayers() > 0 then
        switchTarget()
        updateUI()
    end
end)

-- Slider Events
fovSlider.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local dragging = true
        local connection
        connection = UserInputService.InputChanged:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local sliderSize = fovSlider.AbsoluteSize.X
                local mouseX = mouse.X - fovSlider.AbsolutePosition.X
                local percentage = math.max(0, math.min(1, mouseX / sliderSize))
                config.fov = percentage * 200
                updateUI()
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end
end)

smoothSlider.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local connection
        connection = UserInputService.InputChanged:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local sliderSize = smoothSlider.AbsoluteSize.X
                local mouseX = mouse.X - smoothSlider.AbsolutePosition.X
                local percentage = math.max(0, math.min(1, mouseX / sliderSize))
                config.smoothness = percentage
                updateUI()
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end
end)

-- Keybind
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == config.aimKeybind then
        config.aiming = true
        if config.targetLock then
            config.currentTarget = findClosestTarget()
            updateUI()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == config.aimKeybind then
        config.aiming = false
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if config.enabled and config.aiming then
        if config.targetLock and not config.currentTarget then
            config.currentTarget = findClosestTarget()
            updateUI()
        end
        aim()
    end
end)

-- Initial UI Update
updateUI()

print("Aimbot UI loaded! Press E to aim (hold). Close button hides/shows UI.")