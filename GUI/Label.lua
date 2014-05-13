--- Widget that draws a string on screen

require "OO"
require "GUI.Widget"

GUI.Label = {}
OO.createDerivedClass(GUI.Label, GUI.Widget)

--- Constructor of Label
-- @param text Text of Label
function GUI.Label:new(text)
    self.base.new(self)
    self.text = text
end

function GUI.Label:render()
    local textWidth = GUI.font:getWidth(self.text)
    local textHeight = GUI.font:getHeight(self.text)
    local textPosX = self:getLeftAnchor() + self:getWidth()/2 - textWidth/2
    local textPosY = self:getTopAnchor() + self:getHeight()/2 - textHeight/2

    self.base.render(self)
    love.graphics.setFont(GUI.font)
    love.graphics.setColor(0,255,0)
    love.graphics.print(self.text, textPosX, textPosY)
end
