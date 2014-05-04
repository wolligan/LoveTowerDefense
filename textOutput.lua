textOutput = {}
textOutput.buffer = {}
textOutput.position = {10,10}
function textOutput.print(text)
	textOutput.buffer[#textOutput.buffer+1] = text
end

function textOutput.draw()
	love.graphics.setColor(255,255,255)
	for i=1,#textOutput.buffer do
		love.graphics.print(tostring(textOutput.buffer[i]),textOutput.position[1],textOutput.position[2] + (i-1)*20)
	end
end
