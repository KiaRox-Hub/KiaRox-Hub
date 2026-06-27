local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew",true))()
local tab = library:CreateWindow("Main Page")

folder:AddList({
    text = "Color",
    values = {"Red", "Green", "Blue"},
    callback = function(value)
        print("Selected color:", value)
    end,
    open = false,
    flag = "color_option"
})

folder:AddToggle({
	text = "Fast Train",
	flag = "toggle",
	callback = function(v)
	print(v)
end
})

folder:AddToggle({
	text = "Auto Upgrade",
	flag = "toggle",
	callback = function(v)
	print(v)
end
})

folder:AddToggle({
	text = "Auto Rebirth",
	flag = "toggle",
	callback = function(v)
	print(v)
end
})

folder:AddButton({
	text = "Click me",
	flag = "button",
	callback = function()
	print("hello world")
end
})

folder:AddLabel({
	text = "KiaRox-Hub",
	type = "label"
	})

library:Close()

library:Init()

