-- Reposted by @da7mu on discord

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Da7mu/Leaked-Stellar-Ui/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Name = "KiaRox-Hub",
    SubName = "Dev By KiaRox",
    Logo = "rbxassetid://81441172534384",
    WatermarkEnabled = true,
    WatermarkText = "KiaRox",
    SettingsTabEnabled = true,
    ExpiresSeconds = 86400
})

-- tabs/pages
local CombatPage = Window:AddTab({
    Name = "Combat",
    Icon = "sword"
})

-- sections
local MainSection = CombatPage:AddSection({
    Name = "Aimbot & Triggerbot",
    Icon = "crosshair"
})

local MainSection2 = CombatPage:AddSection({
    Name = "BonnieBlue",
    Icon = "house"
})

-- toggle
MainSection:AddToggle({
    Name = "Enable Aimbot",
    Default = false,
    Flag = "AimbotEnabled",
    Callback = function(v) end
})

-- button
MainSection:AddButton({
    Name = "Force Headshot",
    Callback = function(value)
    end
})

-- slider
MainSection:AddSlider({
    Name = "FOV",
    Min = 0,
    Max = 360,
    Default = 120,
    Flag = "idkfov",
    Callback = function(value)
    end
})

-- dropdown
MainSection:AddDropdown({
    Name = "Aim Part",
    Items = {"Head", "UpperTorso", "HumanoidRootPart", "Random"},
    Default = "Head",
    Flag = "AimPart",
    Callback = function(value) end
})

-- multi dropdown
MainSection:AddDropdown({
    Name = "Hit Chance",
    Items = {"100%", "90%", "75%", "50%"},
    Default = {"100%"},
    Multi = true,
    Flag = "idka",
    Callback = function(value) end
})

-- textbox
MainSection:AddTextbox({
    Name = "Amount of Hitlers",
    Placeholder = "0.12",
    Default = "0.125",
    Numeric = true,
    Finished = true,
    Flag = "hitlersvalue",
    Callback = function(value) end
})

--label
MainSection:AddLabel("Advanced Options")

--toggle
MainSection:AddToggle({
    Name = "Wallbang",
    Default = false,
    Flag = "Wallbang",
    Callback = function(value) end
})

--weird setup colorpicker
MainSection:AddLabel("Wallbang Color"):Colorpicker({
    Default = Color3.fromRGB(255, 0, 100),
    Flag = "WallbangColor",
    Callback = function(value)
        
    end
})

MainSection:AddToggle({
    Name = "Triggerbot",
    Default = false,
    Flag = "Triggerbot",
    Callback = function(value)
        
    end
})

--------------------------------------------------------------------------------------------------------

-- slider
MainSection2:AddSlider({
    Name = "Goon Position",
    Min = 0,
    Max = 360,
    Default = 120,
    Flag = "idkfo2v",
    Callback = function(value)
    end
})

-- dropdown
MainSection2:AddDropdown({
    Name = "Samet Part",
    Items = {"Head", "UpperTorso", "HumanoidRootPart", "Random"},
    Default = "Head",
    Flag = "AimPar3t",
    Callback = function(value) end
})

-- multi dropdown
MainSection2:AddDropdown({
    Name = "Samet Chance",
    Items = {"100%", "90%", "75%", "50%"},
    Default = {"100%"},
    Multi = true,
    Flag = "idk2a",
    Callback = function(value) end
})

--weird setup colorpicker
MainSection2:AddLabel("Wallbang Color"):Colorpicker({
    Default = Color3.fromRGB(255, 0, 100),
    Flag = "WallbangColor",
    Callback = function(value)
        
    end
})

MainSection2:AddToggle({
    Name = "Triggerbot",
    Default = false,
    Flag = "Trigg3erbot",
    Callback = function(value)
        
    end
})

-- textbox
MainSection2:AddTextbox({
    Name = "Amount of Samets",
    Placeholder = "0.12",
    Default = "0.125",
    Numeric = true,
    Finished = true,
    Flag = "hitlers2value",
    Callback = function(value) end
})

--label
MainSection2:AddLabel("Advanced Options")

--toggle
MainSection2:AddToggle({
    Name = "Wallbang",
    Default = false,
    Flag = "Wall3bang",
    Callback = function(value) end
})

-- toggle
MainSection2:AddToggle({
    Name = "Enable Aimbot",
    Default = false,
    Flag = "Aimbo2tEnabled",
    Callback = function(v) end
})

MainSection2:AddToggle({
    Name = "Sit Down",
    Default = true,
    Flag = "Silen3tAim",
    Callback = function(value) end
})

-- button
MainSection2:AddButton({
    Name = "Remove Highlights",
    Callback = function(value)
    end
})


-- Menu keybind
Library.MenuKeybind = tostring(Enum.KeyCode.RightControl)
local SettingsPage = Window.SettingsPage

-- Unload (call to destroy)
-- Library:Unload()