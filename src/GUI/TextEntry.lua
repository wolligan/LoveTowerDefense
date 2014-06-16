--- Basic Text Input Field.
-- ToDo: add permanent key input after pressing key for some time.
--
-- ToDo: add selection.
--
-- ToDo: show text field cursor icon when hovering.
--@author Steve Wolligandt
--@classmod TextEntry

GUI.TextEntry = {}
GUI.TextEntry.safetyArea = 5
GUI.TextEntry.cursorHeight = 20
GUI.TextEntry.cursorBlinkInterval = 0.5 -- seconds
GUI.TextEntry.acceptedCharactes =       {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2" ,"3","4","5","6","7","8","9","0","ß",",",".","-","#","+"," "}
GUI.TextEntry.shiftModifiedCharactes =  {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","E","V","W","X","Y","Z","!","\"","§","$","%","&","/","(",")","=","?",";",":","_","'","*"," "}
Utilities.OO.createDerivedClass(GUI.TextEntry, GUI.Widget)

--- Constructor
-- @param hintText text that will be shown when there is no text typed into the text field
function GUI.TextEntry:new(hintText)
    GUI.Widget.new(self)
    self.text = ""
    self.hintText = hintText or ""
    self.cursorPos = 1
    self.showCursor = false
    self.lastTime = love.timer.getTime()
    self.timeCounter = 0
    self.translate = 0
end

--- renders the text field
function GUI.TextEntry:render()
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill", self:getLeftAnchor(), self:getTopAnchor(), self:getWidth(), self:getHeight())
    love.graphics.setColor(unpack(self.borderColor))
    love.graphics.rectangle("line", self:getLeftAnchor(), self:getTopAnchor(), self:getWidth(), self:getHeight())

    love.graphics.setStencil(function() love.graphics.rectangle("fill", self:getLeftAnchor() + GUI.TextEntry.safetyArea, self:getTopAnchor() + GUI.TextEntry.safetyArea, self:getWidth() - GUI.TextEntry.safetyArea*2, self:getHeight() - GUI.TextEntry.safetyArea*2) end)

    local curFont = self.font
    local left = self:getLeftAnchor() + GUI.TextEntry.safetyArea
    local cursorX = left + curFont:getWidth(self.text:sub(1,self.cursorPos))


    if self.text == "" then
        if not self.isActive then
            love.graphics.setColor(180,180,180)
            love.graphics.print(self.hintText, self:getLeftAnchor() + GUI.TextEntry.safetyArea, self:getTopAnchor() + self:getHeight()/2 - curFont:getHeight(self.hintText)/2)
        end
    else
        love.graphics.push()
        if self.translate > 0 then
            love.graphics.translate(-self.translate, 0)
        end
        love.graphics.setColor(unpack(self.fontColor))
        love.graphics.print(self.text, self:getLeftAnchor() + GUI.TextEntry.safetyArea, self:getTopAnchor() + self:getHeight()/2 - curFont:getHeight(self.hintText)/2)
        love.graphics.pop()
    end

    love.graphics.push()
    if self.translate > 0 then
        love.graphics.translate(-self.translate, 0)
    end

    if self.isActive and self.showCursor then
        love.graphics.setColor(100,100,100)
        love.graphics.line(cursorX, self:getTopAnchor() + GUI.TextEntry.safetyArea, cursorX, self:getTopAnchor() + GUI.TextEntry.safetyArea + GUI.TextEntry.cursorHeight)
    end
    love.graphics.pop()
    love.graphics.setStencil()
end

--- updates the TextEntry
-- @param dt delta time
function GUI.TextEntry:update(dt)
    if self.isActive then
        self.timeCounter = self.timeCounter + dt
        if love.timer.getTime() - self.lastTime > GUI.TextEntry.cursorBlinkInterval then
            self.timeCounter = 0
            self.lastTime = love.timer.getTime()
            self.showCursor = not self.showCursor
        end
    end
    self.apparentContainer.stealKeys = self.isActive
end

--- notifies that a key has been pressed
-- @param key Key that has been pressed
function GUI.TextEntry:notifyKey(key)
    if self.isActive then
        if key == "backspace" and self.cursorPos > 0 then
            self.text = self.text:sub(1,self.cursorPos-1) .. self.text:sub(self.cursorPos+1,#self.text)
            self:moveCursorLeft()
        elseif key == "delete" and self.cursorPos < #self.text then
            self.text = self.text:sub(1,self.cursorPos) .. self.text:sub(self.cursorPos+2,#self.text)
        elseif key == "left" then
            self:moveCursorLeft()
        elseif key == "right" then
            self:moveCursorRight()
        elseif table.contains(GUI.TextEntry.acceptedCharactes, key) then
            if love.keyboard.isDown("lshift", "rshift")  then
                self.text = self.text:sub(1,self.cursorPos) .. GUI.TextEntry.shiftModifiedCharactes[table.indexOf(GUI.TextEntry.acceptedCharactes, key)] .. self.text:sub(self.cursorPos+1, #self.text)
            else
                self.text = self.text:sub(1,self.cursorPos) .. key .. self.text:sub(self.cursorPos+1, #self.text)
            end
            self:moveCursorRight()
        end
    end
end

--- moves the cursor and the TextEntry view to the left.
-- TODO moving the the left does not work correctly
function GUI.TextEntry:moveCursorLeft()

    local curFont = self.font
    local left = self:getLeftAnchor() + GUI.TextEntry.safetyArea
    local cursorX = curFont:getWidth(self.text:sub(1,self.cursorPos))
    if self.translate+GUI.TextEntry.safetyArea > cursorX then
        self.translate = cursorX-GUI.TextEntry.safetyArea*2
    end

    self.cursorPos = math.max(0,self.cursorPos-1)
end

--- moves the cursor and the TextEntry view to the right
function GUI.TextEntry:moveCursorRight()
    self.cursorPos = math.min(#self.text,self.cursorPos+1)

    local curFont = self.font
    local left = self:getLeftAnchor() + GUI.TextEntry.safetyArea
    local right = self:getRightAnchor() - GUI.TextEntry.safetyArea
    local cursorX = left + curFont:getWidth(self.text:sub(1,self.cursorPos+1))
    if cursorX - self.translate > right then
        self.translate = cursorX - self:getRightAnchor() + GUI.TextEntry.safetyArea
    end
end

--- reposition cursor on click
function GUI.TextEntry:onClick()
    local mxOnString = love.mouse.getX() - self:getLeftAnchor() - GUI.TextEntry.safetyArea + self.translate
    if mxOnString <= 0 then
        self.cursorPos = 0
    elseif mxOnString >= self.font:getWidth(self.text) then
        self.cursorPos = #self.text
    else
        for i=1,#self.text do
            if (self.font:getWidth(self.text:sub(1,i)) <= mxOnString and self.font:getWidth(self.text:sub(1,i+1)) >= mxOnString) then
                self.cursorPos = i
            end
        end
    end

    self.lastTime = love.timer.getTime()
    self.showCursor = true
end
