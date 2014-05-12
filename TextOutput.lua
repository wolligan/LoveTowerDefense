--- ADD ME
TextOutput = {}
TextOutput.buffer = {}
TextOutput.maxLines = 100
TextOutput.counter = 0

---
function TextOutput.print(text)
    TextOutput.counter = TextOutput.counter + 1
	table.insert(TextOutput.buffer, 1, text)
    TextOutput.buffer[TextOutput.maxLines] = nil
end

---
function TextOutput.draw()
	love.graphics.setColor(255,255,255)
	for i=1,#TextOutput.buffer do
		love.graphics.print(tostring((TextOutput.counter - i) .. ": " .. TextOutput.buffer[i]), 10, love.graphics.getHeight() - ((i-1)*20+20))
	end
end
