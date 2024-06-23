muteMenuBar = hs.menubar.new()

for _, v in ipairs(hs.audiodevice.allInputDevices()) do
	if not string.find(v:name(), "Zoom") then
		v:setMuted(false)
	end
end

function ToggleMicMute()
	local currentInputDeviceTable = hs.audiodevice.allInputDevices()
	local currentState = false
	for i, v in ipairs(currentInputDeviceTable) do
		if not string.find(v:name(), "Zoom") then
			currentState = v:muted()
			v:setMuted(not currentState)
			print(i)
			print(v:uid())
			print("muted:")
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
end
