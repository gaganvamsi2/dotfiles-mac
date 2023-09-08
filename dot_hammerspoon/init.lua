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
  local currentInputDeviceTable = hs.audiodevice.allInputDevices()
  local currentState = false;
  for i, v in ipairs(currentInputDeviceTable) do
    -- if v:name() contains "zoom" then continue
    if not string.find(v:name(), "Zoom") then
      currentState = v:muted()
      v:setMuted(not currentState)
      print(i)
      print(v:uid())
      print(v:muted())
      print(v:name())
      print(v:volume())
    end
  end
  muteMenuBar:setTitle((not currentState and "🙊" or "🐵"))
  hs.alert.show((not currentState and "🙊" or "🐵"))
end

hs.hotkey.bind({ "alt", "shift" }, "A", ToggleMicMute)

if muteMenuBar then
  muteMenuBar:setClickCallback(ToggleMicMute)
  -- ToggleMicMute()
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
  currentInputDeviceTable = hs.audiodevice.current()
  local currentState = currentInputDeviceTable["muted"]
  currentOutputDevice = hs.audiodevice.findOutputByUID(currentInputDeviceTable["uid"])
  if currentOutputDevice:setOutputMuted(not currentState) then
    muteMenuBar:setTitle((not currentState and "🔇" or "🔊"))
    hs.alert.show((not currentState and "🔇" or "🔊"))
  end
  currentInputDeviceTable = hs.audiodevice.current()
  print(currentInputDeviceTable["muted"] and "Muted" or "unMuted")
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

-- hs.urlevent.bind("someAlert", function(eventName, params)
-- 	hs.alert.show("Received someAlert")
-- end)
--
-----------------------------------------------------
hs.loadSpoon("ControlEscape"):start() -- Load Hammerspoon bits from https://github.com/jasonrudolph/ControlEscape.spoon

local function openApp(appName)
  hs.application.enableSpotlightForNameSearches(true)
  hs.application.open(appName)
end

local function MoveToSpaceId(appName, spaceId)
  local foundApp = hs.application.find(appName)
  if not foundApp then
    print("App not found " .. appName)
    hs.timer.doAfter(1, function()
      MoveToSpaceId(appName, spaceId)
    end)
    return
  end
  print("Found App: " .. hs.inspect.inspect(foundApp))
  local allWindows = hs.window.filter.new(foundApp:name()):getWindows()
  for _, v in ipairs(allWindows) do
    print("windows of app " .. appName .. ": " .. hs.inspect.inspect(v))
    hs.spaces.moveWindowToSpace(v, spaceId)
  end
end

local function addSpace()
  local ciscoApp = hs.application.find("cisco anyconnect secure mobility client")
  if ciscoApp then
    ciscoApp:kill9()
  end
  local screenUUID = hs.screen.mainScreen():getUUID()
  local currntSpaces = hs.spaces.allSpaces()[screenUUID]
  for i = #currntSpaces + 1, 5, 1 do
    hs.spaces.addSpaceToScreen()
  end
  local allSpaces = hs.spaces.allSpaces()[screenUUID]
  local appsInOrder = { 'arc', 'alacritty', 'intellij idea', 'obsidian', 'zoom.us' }
  print(hs.inspect.inspect(allSpaces))
  for i = 1, 5 do
    openApp(appsInOrder[i])
  end
  hs.timer.doAfter(3, function()
    for i = 1, 5 do
      MoveToSpaceId(appsInOrder[i], allSpaces[i])
    end
  end)
end

hs.hotkey.bind({ "cmd", "ctrl", "alt" }, "b", addSpace)

-- k = hs.hotkey.modal.new('ctrl', 'space')
--
-- print(hs.inspect.inspect(k))
--
-- function k:entered() hs.alert 'Entered mode' end
--
-- function k:exited() hs.alert 'Exited mode' end
--
-- k:bind('', 'escape', function() k:exit() end)
-- k:bind('', 'J', 'Pressed J', function() print 'let the record show that J was pressed' end)
