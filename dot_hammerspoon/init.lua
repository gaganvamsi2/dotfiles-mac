hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

require("toggle-mute")
require("hide-zoom-control")
require("app-switcher")

hs.hotkey.bind({ "cmd", "capslock" }, "h", function()
	hs.alert.show("test")
end)
