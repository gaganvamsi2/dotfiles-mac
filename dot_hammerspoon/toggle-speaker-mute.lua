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
