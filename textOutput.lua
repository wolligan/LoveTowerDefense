textOutput = {}
textOutput.buffer = {}
textOutput.maxLines = 100
textOutput.counter = 0

function textOutput.print(text)
    textOutput.counter = textOutput.counter + 1
	table.insert(textOutput.buffer, 1, text)
    textOutput.buffer[textOutput.maxLines] = nil
end

function textOutput.draw()
	love.graphics.setColor(255,255,255)
	for i=1,#textOutput.buffer do
		love.graphics.print(tostring((textOutput.counter - i) .. ": " .. textOutput.buffer[i]), 10, love.graphics.getHeight() - ((i-1)*20+20))
	end
end
