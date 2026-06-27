local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew",true))()
local tab = library:CreateWindow("Main Page")
local folder = tab:AddFolder("Folder")

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

library:Close()

library:Init()

