--- Button Widget

require "GUI.Label"

GUI.Button = {}
Utilities.OO.createDerivedClass(GUI.Button, GUI.Label)

--- Constructor
-- @param name label text
-- @param onClickFunc function that will be called on release
function GUI.Button:new(name, onClickFunc)
    GUI.Label.new(self, name)

    self.onRelease = onClickFunc
end

--- renders button
function GUI.Button:render()
    self:renderButton()
    self:renderCenteredText()
end

--- renders the background
function GUI.Button:renderButton()
    love.graphics.setColor(unpack(self.apparentContainer.borderColor))
    love.graphics.rectangle("line", self:getLeftAnchor(), self:getTopAnchor(), self:getWidth(), self:getHeight())
    love.graphics.setColor(unpack(self.apparentContainer.backgroundColor))
    if self.isHovered then
        love.graphics.setColor(unpack(self.apparentContainer.hoverColor))
    end
    if self.isClicked then
        love.graphics.setColor(unpack(self.apparentContainer.clickedColor))
    end
    love.graphics.rectangle("fill", self:getLeftAnchor(), self:getTopAnchor(), self:getWidth(), self:getHeight())

end
