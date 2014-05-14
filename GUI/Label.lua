--- Label Widget

require "GUI.Widget"

GUI.Label = {}
Utilities.OO.createDerivedClass(GUI.Label, GUI.Widget)

--- Constructor of Label
-- @param text Text of Label
function GUI.Label:new(text)
    GUI.Widget.new(self)
    self.text = text or ""
end

--- Renders widget with a text field on top of it
function GUI.Label:render()
    self:renderBackground()
    self:renderCenteredText()
end

--- renders text at center of label
function GUI.Label:renderCenteredText()
    local textWidth = self.apparentContainer.font:getWidth(self.text)
    local textHeight = self.apparentContainer.font:getHeight(self.text)
    local textPosX = math.floor(self:getLeftAnchor() + self:getWidth()/2 - textWidth/2)
    local textPosY = math.floor(self:getTopAnchor() + self:getHeight()/2 - textHeight/2)

    love.graphics.setFont(self.apparentContainer.font)
    love.graphics.setColor(self.apparentContainer.fontColor)
    love.graphics.print(self.text, textPosX, textPosY)
end
