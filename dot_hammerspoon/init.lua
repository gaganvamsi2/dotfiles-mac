hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

function MoveLeft()
	hs.eventtap.keyStroke({}, "left", 50000)
end
function MoveRight()
	hs.eventtap.keyStroke({}, "right", 50000)
end
function MoveDown()
	hs.eventtap.keyStroke({}, "down", 50000)
end
function MoveUp()
	hs.eventtap.keyStroke({}, "up", 50000)
end

hs.hotkey.bind({ "cmd" }, "h", nil, MoveLeft, MoveLeft)
hs.hotkey.bind({ "cmd" }, "j", nil, MoveDown, MoveDown)
hs.hotkey.bind({ "cmd" }, "k", nil, MoveUp, MoveUp)
hs.hotkey.bind({ "cmd" }, "l", nil, MoveRight, MoveRight)

muteMenuBar = hs.menubar.new()

function ToggleMicMute()
	currentOutputDeviceTable = hs.audiodevice.current(true)
	local currentState = currentOutputDeviceTable["muted"]
	currentInputDevice = hs.audiodevice.findInputByUID(currentOutputDeviceTable["uid"])
	if currentInputDevice:setMuted(not currentState) then
		muteMenuBar:setTitle((not currentState and "🙊" or "🐵"))
		hs.alert.show((not currentState and "🙊" or "🐵"))
	end
	currentOutputDeviceTable = hs.audiodevice.current(true)
	print(currentOutputDeviceTable["muted"] and "Muted" or "unMuted")
end

hs.hotkey.bind({ "alt", "shift" }, "A", ToggleMicMute)

if muteMenuBar then
	muteMenuBar:setClickCallback(ToggleMicMute)
	ToggleMicMute()
end

local originalFrame = nil

hs.hotkey.bind({ "cmd", "ctrl", "alt" }, "H", function()
	local zoomWindow = hs.window.find("zoom share statusbar window")
	if zoomWindow then
		if originalFrame then
			zoomWindow:setFrame(originalFrame)
			originalFrame = nil
		else
			originalFrame = zoomWindow:frame()
			local screen = zoomWindow:screen()
			local frame = zoomWindow:frame()
			frame.x = screen:frame().w + 3000
			frame.y = screen:frame().h + 3000
			zoomWindow:setFrame(frame)
		end
	end
end)

function ToggleSpeakerMute()
	currentOutputDeviceTable = hs.audiodevice.current()
	local currentState = currentOutputDeviceTable["muted"]
	currentOutputDevice = hs.audiodevice.findOutputByUID(currentOutputDeviceTable["uid"])
	if currentOutputDevice:setOutputMuted(not currentState) then
		muteMenuBar:setTitle((not currentState and "🔇" or "🔊"))
		hs.alert.show((not currentState and "🔇" or "🔊"))
	end
	currentOutputDeviceTable = hs.audiodevice.current()
	print(currentOutputDeviceTable["muted"] and "Muted" or "unMuted")
end

listener = hs.noises.new(function(number)
	hs.alert.show("sssh!" .. number)
	if number == 2 then
		ToggleSpeakerMute()
	end
end)

started = nil

function stoplisten()
	if started then
		listener:stop()
		started = nil
		hs.alert.show("Stopped listening ssss!")
		print("Stopped listening ssss!")
	else
		started = listener:start()
		hs.alert.show("Listening ssss!")
		print("Listening ssss!")
	end
end

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "S", stoplisten)

--------------------------------
-- START VIM CONFIG
--------------------------------
local VimMode = hs.loadSpoon("VimMode")
local vim = VimMode:new()

-- Configure apps you do *not* want Vim mode enabled in
-- For example, you don't want this plugin overriding your control of Terminal
-- vim
vim:disableForApp("Code"):disableForApp("Alacritty"):disableForApp("Obsidian"):disableForApp("IntelliJ IDEA")

-- If you want the screen to dim (a la Flux) when you enter normal mode
-- flip this to true.
vim:shouldDimScreenInNormalMode(false)

-- If you want to show an on-screen alert when you enter normal mode, set
-- this to true
vim:shouldShowAlertInNormalMode(true)

-- You can configure your on-screen alert font
vim:setAlertFont("Courier New")

-- Enter normal mode by typing a key sequence
vim:enterWithSequence("jk")

-- if you want to bind a single key to entering vim, remove the
-- :enterWithSequence('jk') line above and uncomment the bindHotKeys line
-- below:
--
-- To customize the hot key you want, see the mods and key parameters at:
--   https://www.hammerspoon.org/docs/hs.hotkey.html#bind
--
-- vim:bindHotKeys({ enter = { {'ctrl'}, ';' } })

--------------------------------
-- END VIM CONFIG
--------------------------------

-- hs.urlevent.bind("someAlert", function(eventName, params)
-- 	hs.alert.show("Received someAlert")
-- end)
--
-----------------------------------------------------
hs.loadSpoon("ControlEscape"):start() -- Load Hammerspoon bits from https://github.com/jasonrudolph/ControlEscape.spoon
