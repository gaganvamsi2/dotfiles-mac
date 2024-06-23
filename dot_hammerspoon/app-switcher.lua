local function openApp(appName)
	hs.application.enableSpotlightForNameSearches(true)
	hs.application.open(appName)
end

local appsInOrder = { "arc", "alacritty", "goland", "obsidian", "zoom.us" }

function addSpace()
	local screenUUID = hs.screen.mainScreen():getUUID()
	local currntSpaces = hs.spaces.allSpaces()[screenUUID]
	for i = #currntSpaces + 1, 2, 1 do
		hs.spaces.addSpaceToScreen()
	end
	local allSpaces = hs.spaces.allSpaces()[screenUUID]
	print(hs.inspect.inspect(allSpaces))
	for i = 1, 5 do
		print("openning app " .. appsInOrder[i])
		openApp(appsInOrder[i])
	end
end

hs.hotkey.bind({ "cmd", "crtl", "alt", "shift" }, "z", addSpace)
