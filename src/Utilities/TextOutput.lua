--- Holds a string buffer and renders strings on screen.
Utilities.TextOutput = {}
Utilities.TextOutput.buffer = {}
Utilities.TextOutput.maxLines = 100
Utilities.TextOutput.counter = 0

--- prints a text on screen
-- @param text string that shall be printed
function Utilities.TextOutput.print(text)
    Utilities.TextOutput.counter = Utilities.TextOutput.counter + 1
	table.insert(Utilities.TextOutput.buffer, 1, tostring(text))
    Utilities.TextOutput.buffer[Utilities.TextOutput.maxLines] = nil
end

--- renders string buffer on screen
function Utilities.TextOutput.draw()
	love.graphics.setColor(255,255,255)
	for i=1,#Utilities.TextOutput.buffer do
		love.graphics.print(tostring((Utilities.TextOutput.counter - i) .. ": " .. Utilities.TextOutput.buffer[i]), 10, love.graphics.getHeight() - ((i-1)*20+20))
	end
end
