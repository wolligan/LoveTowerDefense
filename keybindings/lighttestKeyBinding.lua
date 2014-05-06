KeyBindings.LightTestKeyBinding = {}

KeyBindings.LightTestKeyBinding["escape"] = {
	mode = "single",
	fun = function(dt)
		love.event.push("quit")
	end
}
